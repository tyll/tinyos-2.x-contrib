/*
 * SX1211PacketBody.nc
 * 
 *
 *  Created on: Sep 30, 2009
 *      Author: rlim
 */

/**
 * Internal interface for the SX1211 to get portions of a packet.
 */
 
interface SX1211PacketBody {

  /**
   * @return pointer to the sx1211_header_t of the given message
   */
  async command sx1211_header_t * getHeader(message_t * msg);
  
  /**
   * @return pointer to the sx1211_metadata_t of the given message
   */
  async command sx1211_metadata_t * getMetadata(message_t * msg);
  
}

