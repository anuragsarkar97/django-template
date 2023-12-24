module CachingFunctionality
  extend ActiveSupport::Concern

  included do
    before_update :update_cache
    before_destroy :update_cache
    before_save :update_cache

    def update_cache
      Rails.cache.delete([self.class.to_s, self.id.to_s])
      true
    end
  end

  module ClassMethods
    def clear_cache(mongo_ids)
      mongo_ids.each do |mongo_id|
        Rails.cache.delete([self.to_s, mongo_id])
      end
    end

    def cached_find(mongo_id, in_memory_expires_in=nil)
      return nil unless mongo_id
      if in_memory_expires_in
        Cache::MultiLevel.instance.fetch([self.to_s, mongo_id.to_s], in_memory_expires_in: in_memory_expires_in) { find(mongo_id) }
      else
        Rails.cache.fetch([self.to_s, mongo_id.to_s]) { find(mongo_id) }
      end
    end
  end
end
