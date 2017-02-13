import processing.serial.*; //<>// //<>// //<>//
//download at http://ubaa.net/shared/processing/udp/
import hypermedia.net.*;
//download at www.sojamo.de/libraries/controlp5
import controlP5.*;

/*
 * This example reads sensor data from an Arduino (using the OSC library from IRCAM)
 * and relays it to Wekinator using OSC (over UDP).
 * 
 * modified by Evan Raskob (info@pixelist.info)
 *
 */


boolean applicationRunning = false;

//start everything
public void START(int theValue) {
  setupUDP();
  setupSerial();
  hideControls();
  applicationRunning = true;
}

public void STOP() {
  stopSerial();
  stopUDP();
  showControls();
  applicationRunning = false;
}


/************************************************************************************
 SETUP/DRAW
 ************************************************************************************/

void setup() {
  // configure the screen size and frame rate
  size(550, 250, P3D);
  frameRate(30);
  setupGUI();
}

void draw() {
  background(128);
  if (applicationRunning) {
    drawIncomingPackets();
  }
}


/************************************************************************************
 VISUALIZING INCOMING PACKETS
 ************************************************************************************/

int lastSerialPacket = 0;
int lastUDPPacket = 0;

void drawIncomingPackets() {
  //the serial packet
  fill(0);
  rect(75, 50, 100, 100);
  //the udp packet
  rect(325, 50, 100, 100);
  int now = millis();
  int lightDuration = 75;
  if (now - lastSerialPacket < lightDuration) {
    fill(255);
    rect(85, 60, 80, 80);
  }
  if (now - lastUDPPacket < lightDuration) {
    fill(255);
    rect(335, 60, 80, 80);
  }
}

void drawIncomingSerial() {
  // println("drawIncomingSerial");
  lastSerialPacket = millis();
}

void drawIncomingUDP() {
  lastUDPPacket = millis();
}