class PulseAudio
  attr_reader :pulse_id

  def initialize(xid)
    @xid = xid
    launch_pulse
  end

  def launch_pulse
    puts 'Launch pulse'
    pulse_command = "pactl load-module module-null-sink sink_name=#{@xid} sink_properties=device.description=#{@xid}"
    puts "Pulse starting #{pulse_command}"
    @module_id = `#{pulse_command}`.strip
    puts "...#{@module_id}..: Module ID"
    puts "Pulse command: #{pulse_command}"
  end

  def kill
    puts "kill pulse: #{@xid}, ID: #{@module_id}"
    kill_pulse_command = "pactl unload-module #{@module_id}"
    puts "Kill pulse command: #{kill_pulse_command}"
    `#{kill_pulse_command}`
  end
end