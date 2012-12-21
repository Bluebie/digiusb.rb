require 'digiusb'

spark = DigiUSB.sparks.last

print spark.puts "Jake! Jake! Good Morning! Whatcha' doin' buddy?"
print msg = spark.gets
print spark.puts "What are you #{msg.downcase.gsub(/[^a-z]/, '')} about, dude?"
print spark.gets
print spark.puts "Haha! Beep! Boop! Boooop! Beep! Boop!"
print spark.gets
print spark.puts "Huh! I like it!"
print spark.puts "Weeeeoooooooo!"
print spark.puts "Woooooah! Algebraic!"
