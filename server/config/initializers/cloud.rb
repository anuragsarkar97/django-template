module Cloud
  def self.prod_or_staging?
    Rails.env.production? || Rails.env.staging?
  end

  def self.production?
    Rails.env.production?
  end

  def self.staging?
    Rails.env.staging?
  end

  def self.development_or_staging?
    !production?
  end

  def self.development_or_test?
    !production? && !staging?
  end

  def self.run_db_job_synchronously?
    (Rails.env.test? || !Socket.gethostname.starts_with?('rails'))
  end

  # There is a class of db operations that the UI triggers but does not need to wait for.
  # In those cases, we spin up a new Thread so that it does not block the UI.
  def self.maybe_spin_thread(logic)
    run_db_job_synchronously? ? logic.call : Thread.new do logic.call end
  end
end
