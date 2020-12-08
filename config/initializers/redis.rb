Sidekiq.configure_server do |config|
  config.redis = { url: ENV.fetch("redis_url") { "http://localhost:6379" }}
end

Sidekiq.configure_client do |config|
  config.redis = { url: ENV.fetch("redis_url") { "http://localhost:6379" }}
end
