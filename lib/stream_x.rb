require 'securerandom'
require_relative 'virtual_display'
require_relative 'pulse_audio'
require_relative 'browser'
require_relative 'ffmpeg'
require_relative '../logger'

class StreamX
  attr_reader :xid

  @streams = {}

  def self.create_stream(url: nil, resolution: [1280, 720]) = new.create_stream(url:, resolution:)

  def create_stream(url: nil, resolution: [1280, 720])
    @xid = "XID_#{SecureRandom.uuid}"
    @display_id = Random.rand(10..2_147_483_646)

    @display = VirtualDisplay.new(@display_id, resolution:)
    Logger.info("Create Xvfb with display id: #{@display_id}")
    @alsa = PulseAudio.new(@xid)
    Logger.info("Create PulseAudio with id: #{@xid}")

    @browser = setup_browser(url:, resolution:)
    Logger.info("Create Browser with id: #{@xid} and display id: #{@display_id}")
    @ffmpeg = FFmpeg[:m3u8].new(@xid, @display_id, resolution:)
    Logger.info("Create FFmpeg(m3u8) with id: #{@xid} and display id: #{@display_id}")

    StreamX.add_stream(self)
    self
  end

  def stop_stream
    @ffmpeg.stop
    @browser.link.close
    @display.kill
    @alsa.kill
    Logger.info("StreamX with id: #{@xid} Stopped")
    StreamX.remove_stream(self)
    true
  end

  private

  def setup_browser(url: nil, resolution: [1280, 720])
    browser = Browser.new
    browser.set_display(@display_id)
    browser.set_audio(@xid)
    browser.launch(url:, resolution:)
    browser
  end

  def self.add_stream(stream_x)
    @streams[stream_x.xid] = stream_x
  end

  def self.remove_stream(stream_x)
    @streams.delete(stream_x.xid)
  end

  def self.streams_list = @streams
end
