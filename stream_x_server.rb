require 'redis'
require 'json'
require 'securerandom'
require_relative 'lib/stream_x'

def process_request(path, params)
  case path
  when '/api/get_active_streams' then StreamX.streams_list.keys
  when '/api/start_stream' then StreamX.create_stream(url: params[:url]).xid
  when '/api/stop_stream' then StreamX.streams_list[params[:xid]]&.stop_stream
  else 0
  end
end

def wait_message(redis)
  puts 'Wait Message'
  _, message = redis.brpop('requests')
  JSON.parse(message, symbolize_names: true)
end

def start_server
  Thread.new do
    redis = Redis.new({ host: 'localhost', port: 6379, db: 0 })
    loop do
      message = wait_message(redis)
      Logger.info("Message receive: #{message}", source: :stream_x_server)

      response = process_request(message[:path], message[:params])
      Logger.info("Send response: #{response} to #{message[:response_key]}", source: :stream_x_server)
      redis.set(message[:response_key], JSON.generate(response))
    end
  end
end
