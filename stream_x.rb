require 'securerandom'
require_relative 'source'
require_relative 'browser'
require_relative 'ffmpeg'

class StreamX
  def self.create_stream = new.create_stream

  def create_stream
    @xid = "XID_#{SecureRandom.uuid}"
    @display_id = 10 + Random.rand(2147483637)
    @display = VirtualDisplay.new(@display_id)
    @alsa = Pulse.new(@xid)
    @browser = setup_browser
    @ffmpeg = FFmpeg.new(@xid, @display_id)
    self
  end

  def stop_stream
    @ffmpeg.stop
    @browser.link.close
    @display.kill
    @alsa.kill
  end

  private

  def setup_browser
    browser = Browser.new
    browser.set_display(@display_id)
    browser.set_audio(@xid)
    browser.launch
    browser
  end
end