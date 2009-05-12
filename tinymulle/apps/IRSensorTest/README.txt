README for TestAdc
Author/Contact: fanzha@ltu.se

Description:

TestAdc is an application for testing the IRSensor.
It requests data via the Radio. This component samples IR sensor and send the ADC
value to another Mulle node which conneted to PC and has MyBaseStaion component in it.
On the PC, the user can run this command in the terminal:

 java net.tinyos.tools.Listen -comm serial@/dev/ttyUSB0:57600

There should be ADC value and IO status of INT4 displayed on the screen.

