README for ReliableSerial
Author/Contact: dgay42@gmail.com

Description:

This directory contains the simple reliable transmission protocol
developed in Chapter 7.5 of "TinyOS Programming". It contains the
TinyOS (ReliableSerialC.nc) and Java (ReliableMoteIF.java) sides of
the protocol, and a test application derived from the TinyOS 2.x
TestSerial application.

The java application (ReliableTestSerial.java) sends packets to the
serial port at 1Hz: the packet contains an incrementing counter. When
the mote application (ReliableTestSerialAppC.nc) receives a counter
packet, it displays the bottom three bits on its LEDs. Likewise, the
mote also sends packets to the serial port at 1Hz. Upon reception of a
packet, the java application prints the counter's value to standard
out.

Tools:

  java ReliableTestSerial [-comm <packetsource>]

  If not specified, the <packetsource> defaults to sf@localhost:9001 or
  to your MOTECOM environment variable (if defined).

Known bugs/limitations:

None.
