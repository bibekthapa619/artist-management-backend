Sidekiq.configure_server do |config|
  config.queues = [
    ['critical', 5],
    ['default', 2],
    ['low', 1]
  ]

  config.redis = { url: ENV['REDIS_URL'] || 'redis://localhost:6379/0' }
end