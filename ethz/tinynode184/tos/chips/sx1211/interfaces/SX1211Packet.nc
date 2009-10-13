/*
 * SX1211Packet.nc
 *
 *  Created on: Sep 30, 2009
 *      Author: rlim
 */

#include "message.h"

interface SX1211Packet {
    
  /**
   * Get rssi value for a given packet. For received packets, it is
   * the received signal strength when receiving that packet. For sent
   * packets, it is the received signal strength of the ack if an ack
   * was received.
   */
  async command uint8_t getRssi( message_t* p_msg );
  
}
