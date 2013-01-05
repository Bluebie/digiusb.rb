# A little example program for driving the digirgb example code

require 'digiusb'

light = DigiUSB.sparks.last # get the spark most recently plugged in (or maybe just a random one? not sure)

# some colour strings to lookup
color_table = {
  red: [255, 0, 0],
  green: [0, 255, 0],
  blue: [0, 0, 255],
  yellow: [255, 255, 0],
  aqua: [0, 255, 255],
  violet: [255, 0, 255],
  purple: [255, 0, 255],
  black: [0, 0, 0],
  grey: [127, 127, 127],
  white: [255, 255, 255]
}

if color_table.has_key? ARGV.first.to_sym
  color = color_table[ARGV.first.to_sym]
else
  color = ARGV.map { |string| string.to_i }
end

# send out each byte
light.putc 115 # start character 's'
light.putc color[0]
light.putc color[1]
light.putc color[2]

puts "Light should now be #{ARGV.join ':'}"