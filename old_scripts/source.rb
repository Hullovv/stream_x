DISPLAY = 100

class VirtualDisplay
  attr_reader :display, :pid, :path

  def initialize(display_id, resolution: )
    @display = display_id
    launch_x
  end

  def take_screen(path)
    system "import -display :#{display} -window root #{path}"
  rescue StandardError => e
    puts e
    nil
  end

  def launch_x(dims = '1920x1080x24')
    puts 'Launch X'
    xvfb_command = "Xvfb :#{display} -screen 0 #{dims} -ac -nolisten tcp -nolisten unix &"
    puts "Xvfb starting #{xvfb_command}"
    spawn(xvfb_command)
    puts "Xvfb command: #{xvfb_command}"
  end

  def kill
    Process.kill('SIGINT', read_pid_file)
  end

  def pid_file = "/tmp/.X#{@display}-lock"

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

class Pulse
  attr_reader :pulse_id

  def initialize(xid)
    @pulse_id = xid
    launch_pulse
  end

  def launch_pulse
    puts 'Launch pulse'
    pulse_command = "pactl load-module module-null-sink sink_name=#{@pulse_id} sink_properties=device.description=#{@pulse_id}"
    puts "Pulse starting #{pulse_command}"
    @module_id = `#{pulse_command}`.strip
    puts "...#{@module_id}..: Module ID"
    puts "Pulse command: #{pulse_command}"
  end

  def kill
    puts "kill pulse: #{@pulse_id}, ID: #{@module_id}"
    kill_pulse_command = "pactl unload-module #{@module_id}"
    puts "Kill pulse command: #{kill_pulse_command}"
    `#{kill_pulse_command}`
  end
end
