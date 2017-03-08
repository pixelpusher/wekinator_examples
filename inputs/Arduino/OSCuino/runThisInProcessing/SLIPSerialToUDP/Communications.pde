//UDP communication
UDP udp;

int inPort =  6449; // udp input, if needed (not used right now)
int outPort = 6448; // wekinator port
String ipAddress = "127.0.0.1"; // our computer


/************************************************************************************
 SERIAL
 ************************************************************************************/

//the Serial communcation to the Arduino
Serial serial;

final String[] serialRateStrings = {
  "300", "1200", "2400", "4800", "9600", "14400", 
  "19200", "28800", "38400", "57600", "115200"
};

String serialList[] = null;

int baud=0;
int serialListNumber = 2;

ArrayList<Byte> serialBuffer = new ArrayList<Byte>();

void setupSerial() {
  if (baud < 1)
  {
    // choose highest rate if none was selected
    baud = int(serialRateStrings[serialRateStrings.length-1]);
  }
  if (serialList != null) {
    serialListNumber = (int)serialddl.getValue();
    println("opening " + serialList[serialListNumber]);
    serial = new Serial(this, serialList[serialListNumber], baud);
  }
}

void stopSerial() {
  serial.stop();
}

void serialEvent(Serial serial) { 
  //decode the message
  while (serial.available () > 0) {
    slipDecode(byte(serial.read()));
  }
}

void SerialSendToUDP() {

  byte [] buffer = new byte[serialBuffer.size()];
  int ctr=0;
  int dataCount = -1;

  //copy the buffer over
  for (Byte b : serialBuffer) {
    byte bb = buffer[ctr++] = b.byteValue();

    // DEBUG
    //print((char)val);
  }

  // DEBUG
  //println("::serial sent:" + (ctr-dataCount));
  //send it off
  UDPSendBuffer(buffer);
  //clear the buffer
  serialBuffer.clear();
  //light up the indicator
  drawIncomingSerial();
}

void serialSend(byte[] data) {
  //encode the message and send it
  for (int i = 0; i < data.length; i++) {
    slipEncode(data[i]);
  }
  //write the eot
  serial.write(eot);
}

/************************************************************************************
 SLIP ENCODING
 ************************************************************************************/

byte eot = byte(192);
byte slipesc = byte(219);
byte slipescend = byte(220);
byte slipescesc = byte(221);

byte previousByte;

void slipDecode(byte incoming) {
  byte previous = previousByte;
  previousByte = incoming;
  //if the previous was the escape char
  if (previous == slipesc) {
    //if this one is the esc eot
    if (incoming==slipescend) { 
      serialBuffer.add(eot);
    } else if (incoming==slipescesc) {
      serialBuffer.add(slipesc);
    }
  } else if (incoming==eot) {
    //if it's the eot
    //send off the packet
    if (previous != eot) {
      SerialSendToUDP();
    }
  } else if (incoming != slipesc) {
    serialBuffer.add(incoming);
  }
}

void slipEncode(byte incoming) {
  if (incoming == eot) { 
    serial.write(slipesc);
    serial.write(slipescend);
  } else if (incoming==slipesc) {  
    serial.write(slipesc);
    serial.write(slipescesc);
  } else {
    serial.write(incoming);
  }
}


/************************************************************************************
 UDP
 ************************************************************************************/


void setupUDP() {
  udp = new UDP( this, inPort );
  // udp.log( true );     // <-- printout the connection activity
  udp.listen( true );
}

void stopUDP() {
  udp.close();
}

void UDPSendBuffer(byte[] data) {
  udp.send( data, ipAddress, outPort );
}

//called when UDP recieves some data
void receive( byte[] data) {
  drawIncomingUDP();
  //send it over to serial
  serialSend(data);
}