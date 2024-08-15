require 'memory_profiler'

input = 'input.mp4'
m3u8 = 'test.m3u8'
rtmp = 'rtmp://restream.dev/abc201af-b8cf-4fb1-9eed-408a93203419/a325c7f56010'
MemoryProfiler.start
puts 'Start main'
main_stream = "ffmpeg -loglevel error -re -stream_loop -1 -i #{input} -c:v libx264 -b:v 1000k -c:a aac -b:a 192k -f hls -hls_time 4 -hls_list_size 0 -hls_flags delete_segments #{m3u8}"
@main_stream = spawn(main_stream)
Process.detach(@main_stream)

second = 0
@checker = Thread.new do
  loop do
    second += 1
    p "Second: #{second}"
    sleep(1)
  end
end

sleep(15)
puts 'Start restream'
restream = "ffmpeg -i #{m3u8} -c:v libx264 -b:v 1000k -c:a aac -b:a 192k -f flv #{rtmp}"
@restream = spawn(restream)
Process.detach(@restream)

report = MemoryProfiler.stop
report.pretty_print

if gets
  Process.kill('SIGINT', @main_stream)
  Process.kill('SIGINT', @restream)
  @checker.kill
end
