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
    xvfb_command = "Xvfb :#{display} -screen 0 #{dims} -ac -nolisten tcp -nolisten unix &"
    puts "Xvfb starting #{xvfb_command}"
    spawn(xvfb_command)
    puts "Xvfb command: #{xvfb_command}"
  end

  def kill
    Process.kill("SIGINT", read_pid_file)
  end

  def pid_file = "/tmp/.X#{@display}-lock"

  def check_proc
    File.exist? pid_file
  end

  def read_pid_file
    if File.exist? pid_file
      pid = IO.read(pid_file).strip.to_i
      if pid == 0
        puts "Error read pid file"
        return nil
      end
      return pid
    end
    return nil
  end
end


class PulseSource
  def initialize
  end
end
