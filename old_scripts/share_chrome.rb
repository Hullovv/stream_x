require_relative 'stream'
stream = Stream.new
a = nil
puts 'Enter command'
while true
  a = gets.chomp
  begin
    if a == 'start'
      puts 'stream start'
      stream.start
      next
    elsif a == 'stop'
      puts 'stream stop'
      stream.stop
      next
    elsif a == 'false'
      break
    elsif a == 'active'
      puts Stream.active
      next
    else
      puts a
      next
    end
  rescue Interrupt => e
    stream.stop
    break
  end
  exit 1
end
