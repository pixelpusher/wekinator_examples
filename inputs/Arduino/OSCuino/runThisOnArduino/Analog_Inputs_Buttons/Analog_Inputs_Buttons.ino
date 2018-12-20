#include <OSCBoards copy.h>
#include <OSCBoards.h>
#include <OSCBundle.h>
#include <OSCData.h>
#include <OSCMatch.h>
#include <OSCMessage.h>
#include <OSCTiming.h>
#include <SLIPEncodedSerial.h>
#include <SLIPEncodedUSBSerial.h>
#include <Button.h>
#include <OSCMessage.h>

/*
 * Like the other version, this one makes an OSC message and sends it over
 * serial as OSC when a button is toggled.  Uses SLIPSerial and OSC library from IRCAM and
 * Button library forked from others at https://github.com/pixelpusher/Button
 * March 2017
 * This code is in the public domain.
 *
 */

#define ANALOG_INPUT_COUNT 2
#define UPDATE_INTERVAL_MSEC 40

#ifdef BOARD_HAS_USB_SERIAL

#include <SLIPEncodedUSBSerial.h>
SLIPEncodedUSBSerial SLIPSerial( thisBoardsSerialUSB );

#else

#include <SLIPEncodedSerial.h>
SLIPEncodedSerial SLIPSerial(Serial);

#endif

uint32_t next_time;

const int ButtonPin = 2; // pin button is attached to

ButtonCB button(ButtonPin, Button::PULL_UP);

boolean sendOSC = false; // only when button is toggled


void doPressHandler(const Button& button) {
  // nothing
  digitalWrite(13, HIGH);
}

void doReleaseHandler(const Button& button) {
  // nothing
  digitalWrite(13, LOW);
}

void doClickHandler(const Button& button) {
  sendOSC = !sendOSC;
}



void setup()
{
  digitalWrite(13, LOW);
  
  // setup button
  button.pressHandler(doPressHandler);
  button.releaseHandler(doReleaseHandler);
  button.clickHandler(doClickHandler);

  // begin SLIPSerial just like Serial
  SLIPSerial.begin(115200);
  while (!Serial)
    continue;

  next_time = millis() + UPDATE_INTERVAL_MSEC;
}

void loop()
{
  button.process();
  uint32_t now = millis();

  if (sendOSC || button.held())
  {
//    digitalWrite(13, HIGH);
    if ((int32_t)(next_time - now) > 0)
      return;
    next_time += UPDATE_INTERVAL_MSEC;

    // the message wants an OSC address as first argument
    OSCMessage msg("/wek/inputs");

    // add all the analog inputs
    for (int i = 0; i < ANALOG_INPUT_COUNT; i++)
      msg.add(((float)analogRead(i)) / 1023.0f); // scale between 0 and 1

    // SLIPSerial.beginPacket();
    msg.send(SLIPSerial);       // send the bytes to the SLIP stream
    SLIPSerial.endPacket();     // mark the end of the OSC Packet
    msg.empty();                // free space occupied by message
  }
  else
  {
//    digitalWrite(13, LOW);
  }
}
