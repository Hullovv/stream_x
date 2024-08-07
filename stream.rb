require 'securerandom'
require_relative 'driver'
require_relative 'source'

class Stream
  @@actives = {}

  attr_reader :uuid, :chrome, :display, :ffmpeg_pid, :log_level, :active

  def initialize
    @uuid = SecureRandom.uuid
    @display = VirtualDisplay.new
    @chrome = Driver.new(@display.display)
    @@actives[@uuid] = { thread: nil, status: 'offline', stream: self }
    puts "Initialize stream: #{@uuid}"
  end

  def video_save; end

  def ffmpeg_command
    "ffmpeg -y -video_size 1920x1080 -framerate 25 -f x11grab -i :#{@display.display} -loglevel quiet ./video/t4_#{Time.now.to_i}.mp4 &"
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

    @chrome.driver.quit
    @display.kill
    stop_ffmpeg
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
