require 'redis'
require 'json'
require 'securerandom'

def process_request(path, _params)
  case path
  when '/api/get_active_streams' then 123
  else 0
  end
end

def wait_message(redis)
  puts 'Wait Message'
  _, message = redis.brpop('requests')
  JSON.parse(message)
end

def start_server(redis_opts)
  Thread.new do
    redis = Redis.new(redis_opts)
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
