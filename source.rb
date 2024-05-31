DISPLAY = 100

class VirtualDisplay
  attr_reader :display, :pid, :path

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

  def launch_x(dims = '1920x1080x24')
    puts "Launch X"
    xvfb_command = "Xvfb :#{display} -screen 0 #{dims} &"
    puts "Xvfb starting #{xvfb_command}"
    spawn(xvfb_command)
    puts "Xvfb command: #{xvfb_command}"
  end

  def kill
    puts "kill display: #{@display}, PID: #{@pid}"
    Process.kill('SIGKILL', @pid)
    FileUtils.rm lock_file
  end

  def pid_file = "/tmp/.X#{@display}-lock"

  def check_proc
    puts `ps aux | grep #{pid}`
  end
end
