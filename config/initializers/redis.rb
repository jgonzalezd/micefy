$redis = Redis.current



#This approach allows for a Redis configuration very similar to the native Rails database configuration. You can have environment specific databases or even Redis installs, and you can pass any configuration the Redis gem understands.

# # Location: config/initializers/redis.rb
# conf_file = File.join('config','redis.yml')

# $redis = if File.exists?(conf_file)
#   conf = YAML.load(File.read(conf_file))
#   conf[Rails.env.to_s].blank? ? Redis.new : Redis.new(conf[Rails.env.to_s])
# else
#   Redis.new
# end
# # Location: config/redis.yml
# development:
#   url: redis://127.0.0.1:6379/1
# test:
#   url: redis://127.0.0.1:6379/15
# production:
#   host: data.myapp.com
#   port: 6333
#   db: 0
