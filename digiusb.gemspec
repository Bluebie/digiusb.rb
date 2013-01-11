Gem::Specification.new do |s|
  s.name = 'digiusb'
  s.version = '1.0.4'
  s.summary = "a tiny library for talking to digisparks"
  s.author = 'Bluebie'
  s.email = "a@creativepony.com"
  s.homepage = "http://github.com/Bluebie/digiusb.rb"
  s.description = "A tiny library for talking to digispark (a small arduino clone) over usb a bit like talking
  to a real arduino through a serial port! This library works with the DigiUSB library built in to Digistump's
  version of the Arduino software. Also includes a tiny terminal tool, kinda like telnet for digisparks"
  s.files = Dir['lib/**/*.rb'] + ['readme.txt', 'license.txt'] + Dir['examples/**/*.rb'] + Dir['bin/**/*.rb']
  s.executables << 'digiterm'
  s.required_ruby_version = '>= 1.9.3' # thanks dmcinnes
  
  s.rdoc_options << '--main' << 'lib/digiusb.rb'
  
  s.add_dependency 'libusb', '>= 0.2.0'
  s.add_dependency 'colorist', '>= 0.0.2' # used by digiusb/digiblink for parsing colors
  s.add_dependency 'colored', '>= 1.2' # used by digiterm to color output
end