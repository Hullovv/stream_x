class Logger
  LOG_PATH = './log/'

  def self.info(message, source: :stream_x)
    Thread.new do
      log = Logger.new(:info, source, message)
      log.write
      log.print
    end
  end

  def initialize(level, source, message)
    @level = level
    @source = source
    @message = message
    @log_time = Time.now
  end

  def write
    open(LOG_PATH + 'main.log', 'a') { |f| f.write(schema) }
    open(LOG_PATH + "#{@source}.log", 'a') { |f| f.write(schema) }
  end

  def print
    puts schema
  end

  def schema
    "[#{@log_time}] [#{@source}] [#{@level}] #{@message.to_s}\n"
  end
end