require 'redis'
REDIS = Redis.new({ host: 'localhost', port: 6379, db: 0 })

def fetch_response(request_id)
  p "Wait Response From #{request_id}"
  response_key = "response:#{request_id}"
  times = 10
  loop do
    p "Wait Response [#{request_id}] Attempts: #{times}"
    return if times < 0

    times -= 1
    response = REDIS.get(response_key)
    p "Wait Response [#{request_id}] Get Response: #{response}"

    if response
      REDIS.del response_key if REDIS.exists? response_key
      return JSON.parse(response)
    end

    sleep 0.5
  end
end

def send_message(path, params)
  p "Send Request To #{path} with params: #{params}"

  request_id = SecureRandom.uuid # Генерируем уникальный идентификатор сообщения
  REDIS.lpush('requests', JSON.generate({ id: request_id, path:, params:, response_key: "response:#{request_id}" }))
  request_id
end

def use_api(path, params)
  request_id = send_message(path, params)
  fetch_response(request_id)
end

def get_active_streams
  use_api('/api/get_active_streams', {})
end

# @return xid : string
def start_stream(url)
  use_api('/api/start_stream', {url:})
end

def stop_stream(xid)
  use_api('/api/stop_stream', {xid:})
end