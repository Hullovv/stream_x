require_relative 'ffmpeg_mp4'
require_relative 'ffmpeg_m3u8'

class FFmpeg
  def self.[](version = nil)
    case version
    when :m3u8 then FFmpegM3U8
    when :mp4 then FFmpegMP4
    end
  end
end
