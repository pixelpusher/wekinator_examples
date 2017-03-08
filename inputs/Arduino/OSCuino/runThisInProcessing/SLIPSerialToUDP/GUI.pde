/************************************************************************************
 GUI
 ************************************************************************************/

ControlP5 cp5;

// DropdownList serialddl;
// DropdownList baudddl;
ScrollableList serialddl;
ScrollableList baudddl;
Textlabel arduinoLabel;
Textlabel UDPLabel;
Textlabel incomingPacket;
Button startButton;
Button stopButton;
Textfield ipAddressField;
Textfield incomingPortField;
Textfield outgoingPortField;

void setupGUI() {
  //the ControlP5 object
  cp5 = new ControlP5(this);

  //start button
  startButton = cp5.addButton("START")
    .setPosition(200, 200)
    .setSize(200, 19)
    ;

  //stop button
  stopButton = cp5.addButton("STOP")
    .setPosition(200, 200)
    .setSize(200, 19)
    ;
  stopButton.hide();

  //Serial Port selector
  // serialddl = cp5.addDropdownList("SerialPort")
  serialddl = cp5.addScrollableList("SerialPort")
    .setPosition(50, 100)
    .setSize(200, 200)
    ;
  serialddl.setItemHeight(20);
  serialddl.setBarHeight(15);
  serialddl.getCaptionLabel().set("SELECT ARDUINO SERIAL PORT");
  serialddl.getCaptionLabel().getStyle().marginTop = 3;
  serialddl.getCaptionLabel().getStyle().marginLeft = 3;
  serialddl.getValueLabel().getStyle().marginTop = 3;
  //set the serial options
  //String SerialList[] = Serial.list();
  serialList = Serial.list();
  for (int i=0; i<serialList.length; i++) {
    String portName = serialList[i];
    serialddl.addItem(portName, i);
  }
  if (serialList.length > 0)
    serialddl.setValue(0);

  //setup the baud list
  // baudddl = cp5.addDropdownList("BaudRate")
  baudddl = cp5.addScrollableList("BaudRate")
    .setPosition(50, 50)
    .setSize(200, 200)
    ;
  baudddl.setItemHeight(20);
  baudddl.setBarHeight(15);
  baudddl.getCaptionLabel().set("SELECT THE BAUD RATE");
  baudddl.getCaptionLabel().getStyle().marginTop = 3;
  baudddl.getCaptionLabel().getStyle().marginLeft = 3;
  baudddl.getValueLabel().getStyle().marginTop = 3;
  //the baud options
  for (int i=0; i<serialRateStrings.length; i++) {
    String baudString = serialRateStrings[i];
    baudddl.addItem(baudString, i);
  }
  baudddl.setValue(serialRateStrings.length - 1);

  //udp IP/port
  ipAddressField = cp5.addTextfield("IP address")
    .setPosition(300, 30)
    .setAutoClear(false)
    .setText(ipAddress)
    ;
  incomingPortField = cp5.addTextfield("Incoming Port Number")
    .setPosition(300, 80)
    .setAutoClear(false)
    .setText(str(inPort))
    ;

  outgoingPortField = cp5.addTextfield("Outgoing Port Number")
    .setPosition(300, 130)
    .setAutoClear(false)
    .setText(str(outPort))
    ;

  //text labels
  arduinoLabel = cp5.addTextlabel("arduinoLabel")
    .setText("Serial")
    .setPosition(50, 10)
    .setColorValue(0xffffff00)
    .setFont(createFont("SansSerif", 11))
    ;
  UDPLabel = cp5.addTextlabel("UDPLabel")
    .setText("UDP")
    .setPosition(300, 10)
    .setColorValue(0xffffff00)
    .setFont(createFont("SansSerif", 11))
    ;

  incomingPacket = cp5.addTextlabel("incomingPacketLabel")
    .setText("Incoming Packet")
    .setPosition(210, 100)
    .setColorValue(0xffffff00)
    .setFont(createFont("SansSerif", 10))
    ;
  incomingPacket.hide();
}

//hide all the controls and show the stop button
void hideControls() {
  serialddl.hide();
  baudddl.hide();
  startButton.hide();
  outgoingPortField.hide();
  incomingPortField.hide();
  ipAddressField.hide();
  incomingPacket.show();
  //show the stop button
  stopButton.show();
}

void showControls() {
  serialddl.show();
  baudddl.show();
  startButton.show();
  outgoingPortField.show();
  incomingPortField.show();
  ipAddressField.show();
  incomingPacket.hide();
  //hide the stop button
  stopButton.hide();
}


void controlEvent(ControlEvent theEvent) {
  String eventName = theEvent.getName();
  if (theEvent.isGroup()) {
    if (eventName == "SerialPort") {
      //set the serial port 
      serialListNumber = int(theEvent.getValue());
    } else if (eventName == "BaudRate") {
      int index = int(theEvent.getValue());
      baud = Integer.parseInt(serialRateStrings[index]);
    } else {
    }
  } else if (theEvent.isAssignableFrom(Textfield.class)) {
    if (eventName == "IP address") {
      ipAddressField.setFocus(false);
      ipAddress = theEvent.getStringValue();
    } else if (eventName == "Incoming Port Number") {
      incomingPortField.setFocus(false);
      inPort = Integer.parseInt(theEvent.getStringValue());
    } else if (eventName == "Outgoing Port Number") {
      outgoingPortField.setFocus(false);
      outPort = Integer.parseInt(theEvent.getStringValue());
    }
  }
}