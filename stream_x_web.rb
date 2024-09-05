require 'sinatra/base'
require_relative 'stream_x_sdk'

class StreamXApp < Sinatra::Base
  set :port, 8080
  set :root,  File.dirname(__FILE__)
  set :views, proc { File.join(root, 'stream_x_web') }

  get '/' do
    'Hello world!111'
  end

  get '/active_streams' do
    @active_streams = get_active_streams
    p "get res: #{@active_streams}, #{@active_streams.class}"
    erb :index
  end

  get '/test_json' do
    JSON.generate({ a: 123, b: 423 })
  end
end
