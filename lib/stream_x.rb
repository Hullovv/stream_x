require 'securerandom'
require_relative 'virtual_display'
require_relative 'pulse_audio'
require_relative 'browser'
require_relative 'ffmpeg'

class StreamX
  attr_reader :xid

  @streams = {}

  def self.create_stream(url: nil, resolution: [1280, 720]) = new.create_stream(url:, resolution:)

  def create_stream(url: nil, resolution: [1280, 720])
    @xid = "XID_#{SecureRandom.uuid}"
    @display_id = Random.rand(10..2_147_483_646)

    @display = VirtualDisplay.new(@display_id, resolution:)
    @alsa = PulseAudio.new(@xid)

    @browser = setup_browser(url:, resolution:)
    @ffmpeg = FFmpeg[:m3u8].new(@xid, @display_id, resolution:)

    StreamX.add_stream(self)
    self
  end

  def stop_stream
    @ffmpeg.stop
    @browser.link.close
    @display.kill
    @alsa.kill
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

  def self.streams_list = @streams
end
