#include <OSCBoards copy.h>
#include <OSCBoards.h>
#include <OSCBundle.h>
#include <OSCData.h>
#include <OSCMatch.h>
#include <OSCMessage.h>
#include <OSCTiming.h>
#include <SLIPEncodedSerial.h>
#include <SLIPEncodedUSBSerial.h>

#include <OSCMessage.h>

/*
 * Make an OSC message and send it over serial
 */

#define ANALOG_INPUT_COUNT 6
#define UPDATE_INTERVAL_MSEC 40

#ifdef BOARD_HAS_USB_SERIAL

#include <SLIPEncodedUSBSerial.h>
SLIPEncodedUSBSerial SLIPSerial( thisBoardsSerialUSB );

#else

#include <SLIPEncodedSerial.h>
SLIPEncodedSerial SLIPSerial(Serial);

#endif

uint32_t next_time;

void setup()
{
    // begin SLIPSerial just like Serial
    SLIPSerial.begin(115200);
    while (!Serial)
        continue;

    next_time = millis() + UPDATE_INTERVAL_MSEC;
}

void loop()
{
    uint32_t now = millis();
    if ((int32_t)(next_time - now) > 0)
        return;
    next_time += UPDATE_INTERVAL_MSEC;

    // the message wants an OSC address as first argument
    OSCMessage msg("/wek/inputs");
  
    // add all the analog inputs
    for (int i = 0; i < ANALOG_INPUT_COUNT; i++)
        msg.add(((float)analogRead(i))/1023.0f); // scale between 0 and 1

    // SLIPSerial.beginPacket();  
    msg.send(SLIPSerial);       // send the bytes to the SLIP stream
    SLIPSerial.endPacket();     // mark the end of the OSC Packet
    msg.empty();                // free space occupied by message
}
