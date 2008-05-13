This directory and the subdirectories contain the different parts for a 802.15.4 sniffer based upon a telosb mote with a tinyos2 802.15.4 packet sniffer and a java program (see ./java) and wireshark plugins (see ./wireshark) on the computer-side.

-= Basic Concept =-
The TinyOs 2 programm on the node receives all packets on the current channel and forwards them over the serial line to the SerialForwarder running on the computer. The java programm on the computer opens a connection to the SerialForwarder. With the help of wireshark the TCP/IP traffic (containing the raw cc2420 packets) between the SerialForwarder and the java program can be analysed and stored. The wireshark plugins make it possible to analyse the network traffic captured by the telosb mote.

-= TinyOs2 Application =-
The TinyOs2 application switches the mote into receive mode and forwards _all_ packets it receives over the serial line. The cc2420 raw messages are stored in the payload of the ActiveMessage of the serial line.

Furthermore the mote listens to command frames on the serial line and acknowledges success of a command by resending/echoing it.

Currently the only command message supported is for switching the channel.



-= Quick Info for Setup -=

1) Build and install the plugins in ./wireshark/

2) Build and install ./ on a telosb mote

3) Build ./java/ and follow the instructions in ./java/README.txt
