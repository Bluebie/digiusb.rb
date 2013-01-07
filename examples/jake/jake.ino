#include <DigiUSB.h>

void setup() {
  DigiUSB.begin();
}

void wait_till_newline() {
  // when there are no characters to read, or the character isn't a newline
  while (!DigiUSB.available() || DigiUSB.read() != '\n') {
    // refresh the usb port
    DigiUSB.refresh();
  }
}

void answer_1() { DigiUSB.println("Meditating!"); };
void answer_2() { DigiUSB.println("Wait Dude! I'm connecting to the internet with my mind!"); }
void answer_3() { DigiUSB.println("Check it out I downloaded a little dance!"); }

void loop() {
  wait_till_newline();
  answer_1();
  wait_till_newline();
  answer_2();
  wait_till_newline();
  answer_3();
  wait_till_newline();
  wait_till_newline();
  wait_till_newline();
}
