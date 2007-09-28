
/**
 * Not used!  This remains only to save development time next time software 
 * packet CRC's are required in some radio.
 * 
 * 
 * Since CRC's are somewhat broken on the CCxx00 radios, this was one solution
 * that was fully unit tested.  However, it made acknowledgements a nightmare.
 * So we switched strategies on the CCxx00 radios to make the RX FIFO
 * autoflush if the CRC was incorrect, which worked around the CRC problem
 * described in the errata.  This component is left over, not plugged in 
 * anywhere in the blaze radio stack, but can be applied elsewhere as needed
 * since the code for it is already done.
 * 
 *
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
