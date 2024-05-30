require_relative 'driver'
require_relative 'virtual_display'
display = VirtualDisplay.new

Driver.new(display.display).start
sleep 2
display.stream
display.take_screen('./test.png')

puts 'end'

sleep 10
display.kill
