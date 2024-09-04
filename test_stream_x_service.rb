require_relative 'stream_x_sdk'
require_relative 'stream_x_server'
require 'redis'
# require 'fakeredis'

redis_opts = { host: 'localhost', port: 6379, db: 0 }
redis = Redis.new(redis_opts)

server = start_server(redis_opts)

res = []
100.times do
  res << get_active_streams(redis)
end
p res

server.kill
