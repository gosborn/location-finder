# use localhost when not in docker container
# otherwise, specify redis information in .env file

Sidekiq.configure_server do |config|
  config.redis = {
      host: ENV['REDIS_HOST'] || 'localhost',
      port: ENV['REDIS_PORT'] || '6379'
  }
end

Sidekiq.configure_client do |config|
  config.redis = {
      host: ENV['REDIS_HOST'] || 'localhost' ,
      port: ENV['REDIS_PORT'] || '6379'
  }
end
