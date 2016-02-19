OSCuino Library: Arduino Analog Input

    This example shows how to use an Arduino's analog inputs with
    Wekinator.


Prerequisites

    You need an Arduino, any model.

    Install the Arduino IDE.
    https://www.arduino.cc/en/Main/Software

    Connect one or more analog sensors to the Arduino's analog pins,
    starting with A0.  I used a two-axis joystick on A0 and A1.


Run the Demo

    Connect the Arduino to your computer.

    Open Analog_Inputs.ino in the Arduino IDE.

    Edit ANALOG_INPUT_COUNT to match the number of analog pins you're
    using.

    Click Upload.

    Quit the Ardino IDE to release the serial port.

    Launch SLIPSerialToUDP for your platform.

    Select the correct serial port.

    Click START.

    Now SLIPSerialToUDP is sending OSC packets.  Wekinator should be able
    to receive them.


Build from Source

    Get the OSCuino library here.
    https://github.com/CNMAT/OSC

    Get these Processing libraries.

     - UDP
       http://ubaa.net/shared/processing/udp/

     - controlP5
       http://www.sojamo.de/libraries/controlp5
