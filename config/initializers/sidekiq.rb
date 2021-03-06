require 'sidekiq/scheduler'

Sidekiq.default_worker_options = { backtrace: 10, retry: 10, failures: :exhausted }

Sidekiq.configure_server do |config|
  config.redis = ConnectionPool.new(size: 105) { Redis.new(url: ENV['REDIS_URL']) }
  config.average_scheduled_poll_interval = 10
  config.on(:startup) do
    Sidekiq.schedule = YAML.load_file(File.expand_path("../../schedule.yml",__FILE__))
    Sidekiq::Scheduler.reload_schedule!
  end
end

Sidekiq.configure_client do |config|
  config.redis = ConnectionPool.new(size: 5) { Redis.new(url: ENV['REDIS_URL']) }
end
