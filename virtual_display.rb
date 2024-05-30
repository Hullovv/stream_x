DISPLAY = 100

class VirtualDisplay
  attr_reader :display, :pid, :path, :ffmpeg_pid

  def initialize
    @display = Random.random_number 100...1_000_000
    launch_x
  end

  def take_screen(path)
    system "import -display :#{display} -window root #{path}"
  rescue StandardError => e
    puts e
    nil
  end

  def stream
    ffmpeg_command = "ffmpeg -y -video_size 1920x1080 -framerate 25 -f x11grab -i :#{@display} -loglevel debug ./t4_#{Time.now.to_i}.mp4"
    puts ffmpeg_command
    @ffmpeg_pid = spawn(ffmpeg_command)
    Process.detach(@ffmpeg_pid)
  end

  def launch_x(dims = '1920x1080x24')
    @pid = spawn("Xvfb :#{display} -screen 0 #{dims} &")
    puts pid
  end

  def kill
    Process.kill('SIGINT', @ffmpeg_pid)
    Process.kill('SIGKILL', @pid)
    FileUtils.rm lock_file
  end

  def lock_file = "/tmp/.X#{display}-lock"

  def check_proc
    puts `ps aux | grep #{pid}`
  end
end
