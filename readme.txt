DigiUSB is a little rubygem for talking to Digisparks using the DigiUSB library provided by Digistump. It works a little bit like a digi-serial port - you can send digi-bytes to it and read digi-bytes out, and includes some common digi-methods like gets, puts, print, and write, so you can use it a bit like an IO. DigiUSB also comes with a little terminal called digiterm, which you can use to sort of telnet in to your sparks!

Sometimes it's lonely on the internet so I made a virtual friend as an example. You can find it in the examples folder - open jake.ino up in the digispark version of the arduino software and upload it in the usual way. Once that's done pop open your terminal and enter 'digiterm'

Type in lines like these to play with your new best friend!:->

  Jake! Jake! Good Morning! Whatcha' doin' buddy?
  What are you meditating about, dude?
  Haha! Beep! Boop! Boooop! Beep! Boop!
  Huh! I like it!
  Weeeeoooooooo!
  Woooooah! Algebraic!

Eventually I found myself too busy to play with Jake but I didn't want him to get lonely, so I made a robot to play with him. You can setup your own friend for Jake too! Just create a cron job or alarm or whatever on your computer to run finn.rb from the examples folder however often you want. I chose once per second. You might want to opt for a more frequent interval!

I hope this all makes sense and is useful to someone.

As usual, I'm sorry I killed your cat. It was an accident, but I wont accept any liability for that or anything else digiusb might do to you or your beloved friends. What were you doing keeping all those knives in the catroom anyway?!

—
Bluebie