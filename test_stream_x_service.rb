require_relative 'stream_x_sdk'
require_relative 'stream_x_server'
require_relative 'stream_x_web'
require 'redis'

server = start_server

WEB = true
StreamXApp.run! if WEB == true

server.kill
