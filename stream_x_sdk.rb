def fetch_response(redis, request_id)
  p "Wait Response From #{request_id}"
  response_key = "response:#{request_id}"
  times = 3
  loop do
    p "Wait Response [#{request_id}] Attempts: #{times}"
    return if times < 0

    times -= 1
    response = redis.get(response_key)
    p "Wait Response [#{request_id}] Get Response: #{response}"

    if response
      redis.del response_key if redis.exists? response_key
      return JSON.parse(response)
    end

    sleep 1  # Ожидание ответа, можно использовать более короткую задержку
  end
end

def send_message(redis, path, params)
  p "Send Request To #{path} with params: #{params}"

  request_id = SecureRandom.uuid # Генерируем уникальный идентификатор сообщения
  redis.lpush('requests', JSON.generate({ id: request_id, path:, params:, response_key: "response:#{request_id}" }))
  request_id
end

def get_active_streams(redis)
  request_id = send_message(redis, '/api/get_active_streams', {})
  fetch_response(redis, request_id)
end
