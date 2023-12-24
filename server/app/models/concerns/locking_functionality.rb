# frozen_string_literal: true

module LockingFunctionality
  extend ActiveSupport::Concern
  included do
    field :concurrency_locks, type: Hash

    # This method is considered "preferred but not prod-tested." It is "preferred"
    # because it uses Mongo to ensure atomic lock aquisition. Whether successful
    # or unsuccessful in acquiring the lock this method will always make 1 DB call.
    #
    # This method does not block (wait to acquire the lock) but instead returns
    # whether or not it was able to aquire the lock.
    #
    # @param [String, Symbol] lock_name The name of the lock that this method will
    #   try to acquire. Strings and symbols are the same lock (sym and sym.to_s
    #   are considered the same lock.)
    # @param [Integer, ActiveSupport::Duration] lock_duration How long the lock will be held before it expires.
    #   If provided as an Integer, then the unit will default to days. Use ActiveSupport::Duration for clarity (120.seconds, 1.hour, etc.)
    # @param [DateTime] current_time The time to consider the current time. For testing only.
    #   Don't manipulate this to inappropriately get a lock.
    # @return [Boolean] True if the lock was acquired, False if the lock was not acquired.
    def acquire_lock_if_possible(lock_name: 'default', lock_duration: 1.hour, current_time: DateTime.now,
                                 locked_by: nil)
      # Considered DST issues -- both time returned from Mongo & current_time will be properly zoned
      # and can be compared across zones so no need to account for that in here
      locked_hash_key_name = "concurrency_locks.#{lock_name}"
      # locked_by is for debugging purpose only
      locked_hash_locked_by_key_name = "concurrency_locks.#{lock_name}_locked_by" if locked_by
      # This syntax has to be very specific b/c of Mongoid - The field/hash key
      # is a symbol, the operator (lt) is a method.
      lock_expired_compared_to = locked_hash_key_name.to_sym.lt
      expired_lock = self.class.unscoped.where(lock_expired_compared_to => current_time).selector
      lock_never_set = self.class.unscoped.where(locked_hash_key_name => nil).selector
      ok_to_acquire_lock = self.class.unscoped.or(expired_lock, lock_never_set).selector
      set_hash = { locked_hash_key_name => current_time + lock_duration }
      set_hash[locked_hash_locked_by_key_name] = locked_by if locked_by

      hint = (self.class.shard_config || {})[:key] || { _id: 1 }
      atomic_selector
      hint = { _id: 1 } if hint['_id']
      criteria = self.class.hint(hint).unscoped.where(atomic_selector)

      criteria = criteria.where(team_id: team_id) if instance_of?(Account)
      resulting_doc = criteria.and(ok_to_acquire_lock)
                              .context
                              .find_one_and_update(
                                { '$set' => set_hash },
                                # upsert:false means don't create another document if you can't find
                                { upsert: false, return_document: :after }
                              )

      # find_one_and_update returns the doc if a modification was made, otherwise
      # it returns nil.
      !!resulting_doc
    end

    def unlock(lock_name = 'default', locked_by = nil)
      # https://sentry.io/organizations/apolloio/issues/3001727401/?project=6196681&query=is%3Aunresolved&statsPeriod=14d
      return if lock_name.nil?

      lock_name = lock_name.to_s.strip
      # Have to use `_id` (not `id`) here. Not exactly sure why -- perhaps because
      # we're calling functionality a layer below mongoid (?).
      # upsert:false means don't create another document if you can't find
      # https://apolloio.slack.com/archives/CV92T825N/p1661814148431549?thread_ts=1660936542.164429&cid=CV92T825N
      if (lock_name == 'crm_account_push') && (id.to_s == '551e3ef07261695147160000')
        PagingEvent.create!(key: 'apollo_crm_account_push_unlock', data: {
                              host: Socket.gethostname,
                              caller: caller.to_s,
                              locked_by: locked_by,
                              locks_str: concurrency_locks.to_s
                            })
      end
      selector = { _id: id }
      selector[:team_id] = team_id if instance_of?(Account)
      self.class.collection.update_one(selector, { '$unset' => { "concurrency_locks.#{lock_name}" => '' } },
                                       upsert: false)
    end

    # Deprecated - prefer to use currently_locked? as this exposes internal
    # locking implementation details.
    def locked_at(lock_name = 'default')
      lock_name = lock_name.to_s.strip
      HashWithIndifferentAccess.new(reload.concurrency_locks.to_h)[lock_name]
    end

    # Checks whether the referenced lock is currently leased/held.
    #
    # Makes 1 DB call to check status of the lock.
    #
    # @param [String, Symbol] lock_name The name of the lock that may be held.
    # @param [DateTime] current_time For testing only
    def currently_locked?(lock_name: 'default', current_time: DateTime.now)
      lock_value = HashWithIndifferentAccess.new(reload.concurrency_locks.to_h)[lock_name]
      !lock_value.nil? && lock_value >= current_time
    end

    # Returns criteria you can add to a query on the class this is included in
    # to only return objects that are "unlocked" for the given lock.
    #
    # @param [String] lock_name The lock to check in the criteria
    # @param [DateTime] current_time For testing only
    def self.currently_unlocked_criteria(lock_name: 'default', current_time: DateTime.now)
      specific_lock = "concurrency_locks.#{lock_name}".to_sym
      lock_less_than_eq_to = specific_lock.lte
      lock_never_set_or_was_deleted = unscoped.where(specific_lock => nil).selector
      lock_expired = unscoped.where(lock_less_than_eq_to => current_time).selector
      unscoped.or(lock_never_set_or_was_deleted, lock_expired).selector
    end
  end
end
