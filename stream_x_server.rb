require 'redis'
require 'json'
require 'securerandom'
require_relative 'lib/stream_x'

def process_request(path, _params)
  case path
  when '/api/get_active_streams' then StreamX.streams_list
  else 0
  end
end

def wait_message(redis)
  puts 'Wait Message'
  _, message = redis.brpop('requests')
  JSON.parse(message)
end

def start_server
  Thread.new do
    redis = Redis.new({ host: 'localhost', port: 6379, db: 0 })
    loop do
      message = wait_message(redis)
      puts "Received message: #{message}"

      request = message
      response = process_request(request['path'], request['params'])  # Здесь должна быть ваша логика обработки
      redis.set(request['response_key'], JSON.generate(response))
      # Обработка сообщения здесь
    end
  end
end
