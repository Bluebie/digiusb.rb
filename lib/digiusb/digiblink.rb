# little class which abstracts setting colour of digiblink
require 'digiusb'
require 'colorist'

class DigiBlink < DigiUSB
  def color= value
    color = value.to_color unless value.is_a? Colorist::Color

    # send out each byte
    self.putc 's' # start character
    self.putc color.r
    self.putc color.g
    self.putc color.b
  end
end