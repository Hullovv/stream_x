class FFmpeg
  def initialize(xid, display_id)
    @xid = xid
    @display_id = display_id
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
    "ffmpeg -y -video_size 1920x1080 -framerate 25 -f x11grab -i :#{@display_id} -f pulse -i #{@xid}.monitor -loglevel quiet ./video/#{@xid}.mp4"
  end

end