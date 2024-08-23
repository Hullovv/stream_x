class VirtualDisplay
  attr_reader :d_id, :pid, :path

  def initialize(display_id, resolution: [1280, 720])
    @d_id = display_id
    @width = resolution.first
    @height = resolution.last
    launch_x
  end

  def resolution = "#{@width}x#{@height}x24"

  def take_screen(path)
    system "import -display :#{d_id} -window root #{path}"
  rescue StandardError => e
    puts e
    nil
  end

  def launch_x
    puts 'Launch Xvfb'
    xvfb_command = "Xvfb :#{d_id} -screen 0 #{resolution} -ac -nolisten tcp -nolisten unix"
    puts "Xvfb starting #{xvfb_command}"
    @pid = spawn(xvfb_command)
    puts "Xvfb command: #{xvfb_command}"
  end

  def kill
    Process.kill('SIGINT', read_pid_file)
  end

  def pid_file = "/tmp/.X#{@d_id}-lock"

  def check_proc
    File.exist? pid_file
  end

  def read_pid_file
    if File.exist? pid_file
      pid = IO.read(pid_file).strip.to_i
      if pid == 0
        puts 'Error read pid file'
        return nil
      end
      return pid
    end
    nil
  end
end