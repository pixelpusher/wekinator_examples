#include <OSCMessage.h>
#include <OSCBundle.h>
#include <OSCBoards.h>

#ifdef BOARD_HAS_USB_SERIAL
#include <SLIPEncodedUSBSerial.h>
SLIPEncodedUSBSerial SLIPSerial( thisBoardsSerialUSB );
#else
#include <SLIPEncodedSerial.h>
SLIPEncodedSerial SLIPSerial(Serial1);
#endif

#define UPDATE_INTERVAL_MSEC 40


int32_t next_time;

uint32_t counter = 0;

boolean LEDState = false; // off

OSCBundle bundleOut;


void setup()
{
  pinMode(13, OUTPUT); // LED

  // begin SLIPSerial just like Serial
  SLIPSerial.begin(115200);
  while (!Serial)
    continue;

  next_time = millis() + UPDATE_INTERVAL_MSEC;
}


void LEDcontrol(OSCMessage &msg)
{

  LEDState = !LEDState;
  digitalWrite(13, LEDState);

  //  if (msg.isInt(0))
  //  {
  //    //pinMode(LED_BUILTIN, OUTPUT);
  //    digitalWrite(LED_BUILTIN, (msg.getInt(0) > 0) ? LOW : HIGH);
  //  }
  //  else if (msg.isString(0))
  //  {
  //    int length = msg.getDataLength(0);
  //    if (length < 5)
  //    {
  //      char str[length];
  //      msg.getString(0, str, length);
  //      if ((strcmp("on", str) == 0) || (strcmp("On", str) == 0))
  //      {
  //        pinMode(LED_BUILTIN, OUTPUT);
  //        digitalWrite(LED_BUILTIN, HIGH);
  //      }
  //      else if ((strcmp("off", str) == 0) || (strcmp("off", str) == 0))
  //      {
  //        pinMode(LED_BUILTIN, OUTPUT);
  //        digitalWrite(LED_BUILTIN, LOW);
  //      }
  //    }
  //  }

}

void loop()
{
  OSCBundle bundleIN;
  int size;

  if (!SLIPSerial.endofPacket())
  {
    if ( (size = SLIPSerial.available()) > 0)
    {
      while (size--)
        bundleIN.fill(SLIPSerial.read());
    }

    if (!bundleIN.hasError()) {
      bundleIN.dispatch("/OnMouseDown", LEDcontrol);
      bundleIN.dispatch("/OnMouseUp", LEDcontrol);
      //LEDState = !LEDState;
      //digitalWrite(13, LEDState);

    }
    bundleIN.empty();
  }

  int32_t now = millis();

  if ((int32_t)(next_time - now) <= 0)
  {
    next_time = now + UPDATE_INTERVAL_MSEC;

    counter = (counter + 1) % 100;

    // the message wants an OSC address as first argument
    bundleOut.add("/CubeX").add((float)counter / 50);

    SLIPSerial.beginPacket();
    bundleOut.send(SLIPSerial);       // send the bytes to the SLIP stream
    SLIPSerial.endPacket();     // mark the end of the OSC Packet
    bundleOut.empty();                // free space occupied by message
  }
}
