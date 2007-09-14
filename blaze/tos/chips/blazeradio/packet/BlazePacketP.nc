
#include "Blaze.h"
#include "IEEE802154.h"

/**
 * @author David Moss
 */
module BlazePacketP {

  provides {
    interface BlazePacket;
    interface BlazePacketBody;
    interface PacketAcknowledgements as Acks;
  }

}

implementation {

  blaze_header_t *getHeader( message_t *msg ) {
    return (blaze_header_t *) ( msg->data - sizeof( blaze_header_t ));
  }

  blaze_metadata_t *getMetadata( message_t *msg ) {
    return (blaze_metadata_t *) msg->metadata;
  }

  async command error_t Acks.requestAck( message_t* p_msg ) {
    getHeader( p_msg )->fcf |= 1 << IEEE154_FCF_ACK_REQ;
    return SUCCESS;
  }

  async command error_t Acks.noAck( message_t* p_msg ) {
    getHeader( p_msg )->fcf &= ~(1 << IEEE154_FCF_ACK_REQ);
    return SUCCESS;
  }

  async command bool Acks.wasAcked( message_t* p_msg ) {
    return getMetadata( p_msg )->ack;
  }

  async command void BlazePacket.setPower( message_t* p_msg, uint8_t power ) {
    if ( power > 31 )
      power = 31;
    getMetadata( p_msg )->txPower = power;
  }

  async command uint8_t BlazePacket.getPower( message_t* p_msg ) {
    return getMetadata( p_msg )->txPower;
  }
   
  async command int8_t BlazePacket.getRssi( message_t* p_msg ) {
    return getMetadata( p_msg )->rssi;
  }

  async command error_t BlazePacket.getLqi( message_t* p_msg ) {
    return getMetadata( p_msg )->lqi;
  }
  
  async command void BlazePacket.setRadio( message_t* p_msg, uint8_t radio ){
    getMetadata( p_msg )->radio = radio;
  }
  
  async command uint8_t BlazePacket.getRadio( message_t* p_msg ){
    return getMetadata( p_msg )->radio;
  }
  
  async command blaze_header_t *BlazePacketBody.getHeader( message_t* msg ){
    return getHeader( msg );
  }
  
  async command blaze_metadata_t *BlazePacketBody.getMetadata( message_t* msg ){
    return getMetadata( msg );
  }

}
