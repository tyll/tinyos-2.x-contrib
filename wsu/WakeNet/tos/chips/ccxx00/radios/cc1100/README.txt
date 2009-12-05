To select a lower baud rate, overwrite the CC1100.h file with the baud
rate file of your choice.  Then you might need to look at BlazeTransmitP
in the TXFIFO.writeDone() event to make sure the kill switch in there, 'count',
doesn't cause your transmittion to fail prematurely.

