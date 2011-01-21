/**
 * Internal interface for the MRF24J40 to get portions of a packet.
 *
 * @author
 * Chaiporn Jaikaeo (chaiporn.j@ku.ac.th)
 */
 
interface Mrf24PacketBody
{
  /**
   * @return pointer to the mrf24_header_t of the given message
   */
  async command mrf24_header_t * ONE getHeader(message_t * ONE msg);
  
  /**
   * @return pointer to the mrf24_metadata_t of the given message
   */
  async command mrf24_metadata_t * ONE getMetadata(message_t * ONE msg);
}
