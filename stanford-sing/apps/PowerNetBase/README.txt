@author Maria Kazandjieva, <mariakaz@cs.stanford.edu>
@date June 17, 2009

Run this code to collect packets from a CTP network of PowerNet motes.

This is a combination of base station code + serial forwarding.
The node running this app is the root of a CTP tree. It receives
messages over the wireless medium and transfers them to the serial
port through which it is connected. 

Note that the Base Station mote should have an ID such that
TOS_NODE_ID % 500 == 0

To run:
make telosb install,0 bsl,/dev/ttyUSBx

Note: make sure base station and PowerNet motes are configured to
communicate on the same channel.
