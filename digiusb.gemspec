Gem::Specification.new do |s|
  s.name = 'digiusb'
  s.version = '0.0.1'
  s.summary = "a tiny library for talking to digisparks"
  s.author = 'Bluebie'
  s.email = "a@creativepony.com"
  s.homepage = "http://github.com/Bluebie/digiusb"
  s.description = "A tiny library for talking to digispark (a small arduino clone) over usb a bit like talking
  to a real arduino through a serial port! This library works with the DigiUSB library built in to Digistump's
  version of the Arduino software. Also includes a tiny terminal tool, kinda like telnet for digisparks"
  s.files = Dir['lib/**.rb'] + ['readme.txt', 'license.txt'] + Dir['examples/**.rb'] + Dir['bin/**.rb']
  s.executables << 'digiterm'
  
  s.rdoc_options << '--main' << 'lib/digiusb.rb'
  
  s.add_dependency 'libusb', '>= 0.2.0'
end