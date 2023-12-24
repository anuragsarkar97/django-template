class AbstractWorker
  include Sidekiq::Worker
  sidekiq_options :retry => true

  def perform(*args)
    perform_logic_exists = self.class.method(:perform_logic) rescue false
    if perform_logic_exists
      self.class.perform_logic(*args)
    else
      raise "#{self.class} must override perform instance method or perform_logic class method."
    end
  end

  # @return [String] this worker's queue name
  def self.queue_name
    self.sidekiq_options['queue']
  end

  def self.queue
    Sidekiq::Queue.new(queue_name)
  end

  def self.latency
    queue.latency
  rescue Redis::BaseError => e
    1000000000
  end

  def self.q_size
    queue.size
  rescue Redis::BaseError => e
    1000000000
  end

  # You can add functions here that applies to all Sidekiq workers. But please test this
  # because it has not been run
  # def perform(*args)
  #   super(*args)
  # end
end
