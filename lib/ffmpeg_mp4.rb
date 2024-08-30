class FFmpegMP4
  def initialize(xid, display_id, resolution: [1280, 720])
    @xid = xid
    @display_id = display_id
    @resolution = resolution.join('x')
    start
  end

  def start
    puts "#{@xid}: Start FFmpeg"
    puts "#{@xid}: FFmpeg command: #{command}"
    @pid = spawn(command)
    puts "#{@xid}: FFmpeg pid #{@pid}"
    Process.detach(@pid)
    true
  end

  def stop
    Process.kill('SIGINT', @pid)
    puts "#{@xid}: FFmpeg Stopped"
  end

  def command
    "ffmpeg -y -video_size #{@resolution} -framerate 25 -f x11grab -i :#{@display_id} -f pulse -i #{@xid}.monitor -b:v 1000k -c:a aac -b:a 192k -loglevel quiet ./video/#{@xid}.mp4"
  end

end