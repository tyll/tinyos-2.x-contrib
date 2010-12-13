README for TestCounter
Author/Contact: Aitor Hernandez <aitorhh@kth.se>

Description:

In this application the mote is trying to read bytes from the LS7366R
connected to the mote (See schematic.png) each 50 ms. The result is
show with printf throught serial

Criteria for a successful test:

Connect the mote to the PC and execute the printf reader.
	$ java net.tinyos.tools.PrintfClient -comm serial@/dev/ttyUSB0:tmote
We have to see something like "Received data xx" each 50ms

Tools: 
support/sdk/java/net/tinyos/tools/PrintfClient  


Usage: 

1. Install the program in one mote:

    $ make <platform> install

Known bugs/limitations: NONE