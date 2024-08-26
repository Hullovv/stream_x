require 'securerandom'
require_relative 'driver'
require_relative 'pupper'
require_relative 'source'

class Stream
  @@actives = {}

  attr_reader :uuid, :chrome, :display, :ffmpeg_pid, :log_level, :active

  def initialize
    @uuid = SecureRandom.uuid
    @display = VirtualDisplay.new
    @audio = Pulse.new
    @chrome = Pupper.new(@display.display, @audio)
    @@actives[@uuid] = { thread: nil, status: 'offline', stream: self }
    puts "Initialize stream: #{@uuid}"
  end

  def video_save; end

  def ffmpeg_command
    "ffmpeg -y -video_size 1920x1080 -framerate 25 -f x11grab -i :#{@display.display} -f pulse -i #{@audio.pulse_id}.monitor -loglevel quiet ./video/t4_#{Time.now.to_i}.mp4 &"
  end

  def start
    stream_th = Thread.new do
      @chrome.start
      stream
    end
    stream_th.name = @uuid
    @@actives[@uuid] = { thread: stream_th, status: 'active', stream: self }
    true
  end

  def stop
    return unless @@actives[@uuid][:thread].kill

    stop_ffmpeg
    @chrome.driver.close
    @display.kill
    @audio.kill
    @@actives[@uuid][:status] = 'offline'
  end

  def self.stop_stream(uuid)
    if @@active[uuid].empty?
      puts "UUID: #{uuid} not found, return"
      return
    end
    @@actives[uuid][:stream].stop
  end

  def stream
    puts ffmpeg_command
    @ffmpeg_pid = spawn(ffmpeg_command)
    puts "ffmpeg pid #{@ffmpeg_pid}"
    Process.detach(@ffmpeg_pid)
  end

  def stop_ffmpeg
    puts "ffmpeg pid #{@ffmpeg_pid} kill"
    # Process.kill('SIGINT', @ffmpeg_pid)
  end

  def self.active
    @@actives
  end
end
