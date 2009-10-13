/*
 * SX1211PacketP.nc
 *
 *  Created on: Sep 30, 2009
 *      Author: rlim
 */

#include "message.h"
#include "SX1211.h"

module SX1211PacketP {

  provides {
    interface SX1211Packet;
    interface SX1211PacketBody;
  }

  uses interface Packet;
}

implementation {

  /***************** CC2420Packet Commands ****************/
   
  async command uint8_t SX1211Packet.getRssi( message_t* p_msg ) {
    return (call SX1211PacketBody.getMetadata( p_msg ))->strength;
  }

  /***************** CC2420PacketBody Commands ****************/
  async command sx1211_header_t * SX1211PacketBody.getHeader( message_t* msg ) {
	return (sx1211_header_t*)(((uint8_t*)msg->data) - sizeof(sx1211_header_t) );
  }

  async command sx1211_metadata_t *SX1211PacketBody.getMetadata( message_t* msg ) {
    return (sx1211_metadata_t*)msg->metadata;
  }

}
