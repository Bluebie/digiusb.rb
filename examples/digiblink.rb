# A little example program for driving the digirgb example code
# needs colorist rubygem to parse colors
require 'digiusb'
require 'colorist'

light = DigiUSB.sparks.last # get the spark most recently plugged in (or maybe just a random one? not sure)
raise "Couldn't find a DigiUSB device to talk to" if light.nil?

color = ARGV.first.to_color

# send out each byte
light.putc 's' # start character
light.putc color.r
light.putc color.g
light.putc color.b

puts "Light is now #{ARGV.first}"
