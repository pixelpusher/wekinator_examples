/**
 * VisualiseWekinatorOSC by Evan Raskob
 * For visualising OSC messages from Arduino to Wekinator
 *
 * TODO: pause button
 */

import oscP5.*;
import netP5.*;
import controlP5.*;

final int OSC_PORT = 6448; // wekinator port for osc messages
final String OSC_HOST = "127.0.0.1"; // IP address of remote computer to send to

OscP5 oscP5;
ControlP5 gui;
Textarea oscReceivedTxt; // for displaying incoming OSC messages




void setup() 
{
  size(400, 400);
  
  // start oscP5, listening for incoming messages at wekinator port
  oscP5 = new OscP5(this, OSC_PORT);
  
  gui = new ControlP5(this);
  
  oscReceivedTxt = gui.addTextarea("txt")
                  .setPosition(width/10,height/10)
                  .setSize(8*width/10,8*height/10)
                  .setFont(createFont("arial",12))
                  .setLineHeight(14)
                  .setColor(color(10))
                  .setColorBackground(color(180,180,250))
                  .setColorForeground(color(255,200));
                  
  oscReceivedTxt.setText("Incoming OSC:");
  
}


void draw() 
{
  background(0);
}


//
// this triggers whenever OSC messages are received
//
void oscEvent(OscMessage theOscMessage) {
  
  oscReceivedTxt.clear();
  
  /* print the address pattern and the typetag of the received OscMessage */
  oscReceivedTxt.append("### received an osc message.");
  oscReceivedTxt.append(" addrpattern: "+theOscMessage.addrPattern());

  oscReceivedTxt.append(" typetag: "+theOscMessage.typetag()+"\n");
oscReceivedTxt.append("\n");

  String types = theOscMessage.typetag();
  
  for (int i=0; i < types.length(); i++)
  {
    char type = types.charAt(i);

    switch(type)
    {
    case 'f': 
      {
        oscReceivedTxt.append("float[" + i + "]=" + theOscMessage.get(i).floatValue());
        oscReceivedTxt.append("\n");
        println("f");
      }
      break;

    case 's':
      {
        oscReceivedTxt.append("String[" + i + "]=" + theOscMessage.get(i).stringValue());
        oscReceivedTxt.append("\n");
      }
      break;

    case 'i':
      {
        oscReceivedTxt.append("int[" + i + "]=" + theOscMessage.get(i).intValue());
        oscReceivedTxt.append("\n");
      }
      break;

    default: 
      oscReceivedTxt.append("ERR: bad OSC type:" + type);
      oscReceivedTxt.append("\n");
    } // end switch
  }
}