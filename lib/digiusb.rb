require 'libusb'

# simple IO-like read/write access to a digispark using the DigiUSB library
class DigiUSB
  ProductID = 0x05df
  VendorID = 0x16c0
  Manufacturer = "digistump.com"
  Timeout = 1_000 # one second till device crashes due to lack of calling DigiUSB.refresh()
  
  def initialize device
    @device = device
    @handle = nil
  end
  
  def self.sparks
    usb = LIBUSB::Context.new
    usb.devices.select { |device|
      device.idProduct == ProductID && device.idVendor == VendorID && device.manufacturer == "digistump.com"
    }.map { |handle|
      self.new(handle)
    }
  end
  
  
  # read a single character
  def getc
    control_transfer(
      bRequest: 0x01, # hid get report
      dataIn: 1
    )
  end
  
  # write a single character
  def putc character
    character = [character].pack('c') if character.is_a? Integer
    raise "Cannot putc more than one byte" if character.bytesize > 1
    raise "Cannot putc fewer than one byte" if character.bytesize < 1
    
    control_transfer(
      bRequest: 0x09, # hid set report
      wIndex: character.ord
    )
  end
  
  # get a string up until the first newline
  def gets
    chars = ""
    chars += getc() until chars.include? "\n"
    return chars
  end
  
  # write a string followed by a newline
  def puts string = ""
    write "#{string}\n"
  end
  alias_method :println, :puts
  
  # write a string
  def write string
    string.each_byte do |byte|
      putc byte
    end
    string
  end
  alias_method :print, :write
  
  # read a certain number of bytes and return them as a string
  def read bytes = 1
    chars = ""
    chars += getc() until chars.length == bytes
    return chars
  end
  
  def inspect
    "<Digispark:#{@device.product}:@#{@device.bus_number}->#{@device.device_address}>"
  end
  alias_method :to_s, :inspect
  
  
  
  private
  
  def io
    unless @handle
      @handle = @device.open
    end
    
    @handle
  end
  
  def control_transfer(opts = {}) #:nodoc:
    io.control_transfer({
      wIndex: 0,
      wValue: 0,
      bmRequestType: usb_request_type(opts),
      timeout: Timeout
    }.merge opts)
  rescue LIBUSB::ERROR_TIMEOUT, LIBUSB::ERROR_IO
    raise ErrorCrashed
  end
  
  # calculate usb request type
  def usb_request_type opts #:nodoc:
    value = LIBUSB::REQUEST_TYPE_CLASS | LIBUSB::RECIPIENT_DEVICE
    value |= LIBUSB::ENDPOINT_OUT if opts.has_key? :dataOut
    value |= LIBUSB::ENDPOINT_IN if opts.has_key? :dataIn
    return value
  end
end

class DigiUSB::ErrorCrashed < StandardError
  def initialize
    super("Digispark has crashed, most likely due to not running DigiUSB.refresh() often enough in device program #{$!.class.name}")
  end
end


