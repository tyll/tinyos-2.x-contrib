
/**
 * Rather than make the CRC checking an explicit layer in the radio stack,
 * we simply allow Receive and Transmit to connect into the PacketCrc in
 * parallel.  The PacketCrc interface modifies the length byte of the packet!
 * If the transmit branch is sending with CRC's enabled, then the receive
 * branch must also have CRC's enabled to obtain the correct packet length.
 * 
 * Making this functionality modular, rather than splitting it between
 * the Transmit and Receive branches, makes it possible to unit test.
 * 
 * @author David Moss
 */
 
configuration PacketCrcC {
  provides {
    interface PacketCrc;
  }
}

implementation {

  components PacketCrcP;
  PacketCrc = PacketCrcP;

  components CrcC;
  PacketCrcP.Crc -> CrcC;
  
}
