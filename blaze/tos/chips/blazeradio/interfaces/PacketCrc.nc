
/**
 * With a 16-bit CRC, there is always a 1 in 65535 chance of obtaining
 * a corrupted packet that passes the CRC check.  It can and will happen, given
 * enough time.
 * 
 * If your messages need a higher integrity, I recommend adding your own
 * 8- or 16-bit CRC check in your application layer at the end of your 
 * payload.  I wouldn't recommend using this particular interface / component 
 * to do it, this interface is to be used only by AsyncTransmitP and 
 * BlazeReceiveP.
 * 
 * @author David Moss
 */
 
interface PacketCrc {

  /**
   * Append a CRC to the end of the message.  The first byte of the
   * message MUST be the length byte of the full packet (header + payload)
   * minus the length byte itself.  The length byte of the packet will be
   * increased by 2 to show the packet now contains a 2-byte CRC-16 at the end.
   *
   * @param msg the packet to calculate and append a CRC.  The length byte
   *     will always increase by 2.
   */
  async command void appendCrc(uint8_t *msg);
  
  /**
   * Verify a CRC at the end of a message.  The first byte of the
   * message MUST be exactly as received - the full packet, including the 
   * 16-bit CRC at the end, minus the length byte itself.  After CRC
   * confirmation, the length byte will be decremented by 2 to remove
   * the existance of the CRC.
   *
   * @param msg the packet to verify the CRC.  The length byte will decrease
   *     by 2 regardless of the result, removing the CRC.
   * @return TRUE if the CRC check passed and the data is most likely ok
   */
  async command bool verifyCrc(uint8_t *msg);
  
}
