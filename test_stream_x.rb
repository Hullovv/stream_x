require_relative 'lib/stream_x'

stream = StreamX.create_stream(url: 'https://rutube.ru/video/2c7230d6ac4767e7cc0b7aeea0907143/')

sleep 25

stream.stop_stream