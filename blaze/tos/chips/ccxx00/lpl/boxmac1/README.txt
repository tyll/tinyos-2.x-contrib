BoX-MAC-1 uses continuously modulated packetized wake-up transmissions. There
are no gaps in modulation between packets.  It uses single energy-based receive 
checks like BMAC to determine if there is a transmitter nearby.  This makes its 
receive checks extremely efficient.  The only type of receive check more 
efficient would be wake-on radio's.

Unlike BMAC, the packetized continuously modulated wake-up transmission allows 
the node to sleep if it is not the destination address of the transmission.

This implementation changes the MCSM1 register on the radio to stay in Tx 
mode after a Tx is complete. In other words, the radio will immediately begin
sending the next preamble, ideally with no gaps in modulation (which hasn't
been confirmed).


TODO 
* Make sure this is compatible with the continuoussense CSMA implementation
* Force the packet on subsequent sends. Don't use CCA.

