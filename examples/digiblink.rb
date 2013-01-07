# A little example program for driving the digirgb example code
require 'digiusb/digiblink'

light = DigiBlink.sparks.last # get the spark most recently plugged in (or maybe just a random one? not sure)
raise "Couldn't find a DigiUSB device to talk to" if light.nil?

light.color = ARGV.first
puts "Light is now #{ARGV.first}"
