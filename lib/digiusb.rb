# The DigiUSB class helps find, connect to, and talk with Digisparks using the
# DigiUSB arduino library bundled with the Digispark Arduino software. This
# class aims to work like an IO object, letting you read and write characters,
# bytes, and strings as if it were a file, socket, or serial port. To get
# started, grab a list of Digisparks with the DigiUSB.sparks method. Each spark
# has an inspect method with a unique identifier including the USB device name
# (usually DigiUSB), and some numbers representing which ports and hubs each
# spark connects to. To begin with, DigiUSB.sparks.last works well if you only
# intend to have one digispark connected to your computer. Eventually the device
# name (aka "product name") will hopefully provide a simple way to differentiate
# different digisparks.
#
# Once you have a reference to a Digispark, you can start using it as if it were
# an IO object immediately with methods like getc and putc. As soon as you start
# interacting with the Digispark using these reading and writing methods the
# Digispark will be claimed to your ruby program and will be unavailable to
# other programs until you do one of: close the ruby program, or unplug and plug
# back in the Digispark.
#
# Note also that calling DigiUSB.sparks can sometimes disrupt program uploads,
# so if you're polling waiting for a digispark to appear you may see some
# programming errors in the Digispark Arduino software.

require 'libusb'

# simple IO-like read/write access to a digispark using the DigiUSB library
class DigiUSB
  ProductID = 0x05df # product id number from Digistump
  VendorID = 0x16c0 # vendor id number for Digistump
  Timeout = 1_000 # spark needs to DigiUSB.refresh or DigiUSB.sleep every second
  DefaultPollingFrequency = 15 # 15hz when waiting for data to be printed
  
  # :nodoc: initialize a new DigiUSB object using a libusb device object
  def initialize device
    @device = device
    @handle = nil
    @polling_frequency = DefaultPollingFrequency
  end
  
  # polling frequency describes how aggressively ruby will ask for new bytes
  # when waiting for the device to print something a lower value is faster (it
  # is in hertz)
  attr_accessor :polling_frequency
  
  # Returns an array of all Digisparks connected to this computer. Optionally
  # specify a device name string to return only Digisparks with that name. At
  # the time of writing there is no easy way to customize the device name in
  # the Digispark Arduino software, but hopefully there will be in the future.
  def self.sparks product_name = false
    usb = LIBUSB::Context.new
    usb.devices.select { |device|
      device.idProduct == ProductID && device.idVendor == VendorID && (product_name == false || product_name.to_s == device.product)
    }.map { |handle|
      self.new(handle)
    }
  end
  
  
  # Attempt to read a single character from the Digispark. Returns a string
  # either zero or one characters long. A zero character string means there are
  # no characters available to read - the Digispark hasn't printed anything for
  # you to consume yet. Returns next time Digispark calls DigiUSB.refresh()
  # regardless of how many characters are available.
  def getc
    control_transfer(
      bRequest: 0x01, # hid get report
      dataIn: 1
    )
  end
  
  # Send a single character in to the Digispark's memory. Argument may be either
  # a single byte String, or an integer between 0 and 255 inclusive.
  #
  # Returns next time Digispark calls DigiUSB.refresh()
  def putc character
    character = [character % 256].pack('C') if character.is_a? Integer
    raise "Cannot putc more than one byte" if character.bytesize > 1
    raise "Cannot putc fewer than one byte" if character.bytesize < 1
    
    control_transfer(
      bRequest: 0x09, # hid set report
      wIndex: character.ord
    )
  end
  
  # Read a string from the Digispark until a newline is received (eg, from the
  # println function in Digispark's DigiUSB library) The returned string
  # includes a newline character on the end.
  def gets
    chars = ""
    until chars.include? "\n"
      char = getc()
      chars += char
      sleep 1.0 / @polling_frequency if char == ""
    end
    return chars
  end
  alias_method :getln, :gets
  alias_method :get_line, :gets
  
  # Send a String to the Digispark followed by a newline.
  def puts string = ""
    write "#{string}\n"
  end
  alias_method :println, :puts
  alias_method :print_line, :puts
  alias_method :write_line, :puts
  
  # Send a String to the Digispark
  def write string
    string.each_byte do |byte|
      putc byte
    end
    string
  end
  alias_method :print, :write
  alias_method :send, :write
  
  # Recieve a specific number of bytes and return them as a String. Unlike #getc
  # read will wait until the specified number of bytes are available before
  # returning.
  def read bytes = 1
    chars = ""
    
    until chars.include? "\n"
      char = getc()
      chars += char
      sleep 1.0 / @polling_frequency if char == ""
    end
    
    chars += getc() until chars.length == bytes
    return chars
  end
  
  # A friendly textual representation of this specific Digispark. Can be called
  # without claiming the digispark for this program
  def inspect
    "<Digispark:#{name}:@#{address}>"
  end
  alias_method :to_s, :inspect
  
  # Return the device name as a String
  def name
    @device.product
  end
  
  # Returns the device's bus number and address on the computer's USB interface
  # as a string
  def address
    "#{@device.bus_number}.#{@device.device_address}"
  end
  
  # Release this Digispark so other programs can read and write to it.
  def close
    @handle.close
    @handle = nil
  end
  alias_method :release, :close
  
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


