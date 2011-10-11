/*
 * Copyright (c) 2005-2006 Rincon Research Corporation
 * All rights reserved.
 *
 * Redistribution and use in source and binary forms, with or without
 * modification, are permitted provided that the following conditions
 * are met:
 * - Redistributions of source code must retain the above copyright
 *   notice, this list of conditions and the following disclaimer.
 * - Redistributions in binary form must reproduce the above copyright
 *   notice, this list of conditions and the following disclaimer in the
 *   documentation and/or other materials provided with the
 *   distribution.
 * - Neither the name of the Rincon Research Corporation nor the names of
 *   its contributors may be used to endorse or promote products derived
 *   from this software without specific prior written permission.
 *
 * THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS
 * ``AS IS'' AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT
 * LIMITED TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS
 * FOR A PARTICULAR PURPOSE ARE DISCLAIMED.  IN NO EVENT SHALL THE
 * RINCON RESEARCH OR ITS CONTRIBUTORS BE LIABLE FOR ANY DIRECT, INDIRECT,
 * INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES
 * (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR
 * SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION)
 * HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT,
 * STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE)
 * ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED
 * OF THE POSSIBILITY OF SUCH DAMAGE
 */

#include "Blaze.h"
#include "BlazeTimeSyncMessage.h"

/**
 * @author David Moss
 */
module BlazePacketP {

  provides {
    interface BlazePacket;
    interface BlazePacketBody;
    interface LinkPacketMetadata;
    
    interface PacketTimeStamp<T32khz, uint32_t> as PacketTimeStamp32khz;
    interface PacketTimeStamp<TMilli, uint32_t> as PacketTimeStampMilli;
    interface PacketTimeSyncOffset;

  }
  uses interface LocalTime<T32khz> as LocalTime32khz;
  uses interface LocalTime<TMilli> as LocalTimeMilli;
  

}

implementation {

  /***************** Functions ****************/
  blaze_header_t *getHeader( message_t *msg ) {
    return (blaze_header_t *) ( msg->data - sizeof( blaze_header_t ));
  }

  blaze_metadata_t *getMetadata( message_t *msg ) {
    return (blaze_metadata_t *) msg->metadata;
  }

  /***************** BlazePacket Commands ****************/
  async command void BlazePacket.setPower( message_t* p_msg, uint8_t power ) {
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
  
  /***************** BlazePacketBody Commands ****************/
  async command blaze_header_t *BlazePacketBody.getHeader( message_t* msg ){
    return getHeader( msg );
  }
  
  async command blaze_metadata_t *BlazePacketBody.getMetadata( message_t* msg ){
    return getMetadata( msg );
  }
  
  /**************** LinkPacketMetadata Commands **************/
  async command bool LinkPacketMetadata.highChannelQuality(message_t* msg) {
    return call BlazePacket.getLqi(msg) > 105; // Taken from the CC2420 stack
  }
  
  //mingsen
 /***************** PacketTimeStamp32khz Commands ****************/
  async command bool PacketTimeStamp32khz.isValid(message_t* msg)
  {
    return ( getMetadata( msg )->timestamp != CC1101_INVALID_TIMESTAMP);
  }

  async command uint32_t PacketTimeStamp32khz.timestamp(message_t* msg)
  {
    return getMetadata( msg )->timestamp;
  }

  async command void PacketTimeStamp32khz.clear(message_t* msg)
  {
    getMetadata( msg )->timesync = FALSE;
    getMetadata( msg )->timestamp = CC1101_INVALID_TIMESTAMP;
  }

  async command void PacketTimeStamp32khz.set(message_t* msg, uint32_t value)
  {
    getMetadata( msg )->timestamp = value;
  }

  //mingsen
  /***************** PacketTimeStampMilli Commands ****************/
  // over the air value is always T32khz, which is used to capture SFD interrupt
  // (Timer1 on micaZ, B1 on telos)
  async command bool PacketTimeStampMilli.isValid(message_t* msg)
  {
    return call PacketTimeStamp32khz.isValid(msg);
  }

  //timestmap is always represented in 32khz
  //28.1 is coefficient difference between T32khz and TMilli on MicaZ
  async command uint32_t PacketTimeStampMilli.timestamp(message_t* msg)
  {
    int32_t offset = (call LocalTime32khz.get()-call PacketTimeStamp32khz.timestamp(msg));
    offset/=28.1;
    return call LocalTimeMilli.get() - offset;
  }

  async command void PacketTimeStampMilli.clear(message_t* msg)
  {
    call PacketTimeStamp32khz.clear(msg);
  }

  async command void PacketTimeStampMilli.set(message_t* msg, uint32_t value)
  {
    int32_t offset = (value - call LocalTimeMilli.get()) << 5;
    call PacketTimeStamp32khz.set(msg, offset + call LocalTime32khz.get());
  }
    /*----------------- PacketTimeSyncOffset -----------------*/
  async command bool PacketTimeSyncOffset.isSet(message_t* msg)
  {
    return (getMetadata( msg )->timesync);
  }

  //returns offset of timestamp from the beginning of cc1101 header which is
  //          sizeof(blaze_header_t)+datalen-sizeof(timesync_radio_t)
  //uses packet length of the message which is
  //          MAC_HEADER_SIZE+MAC_FOOTER_SIZE+datalen
  async command uint8_t PacketTimeSyncOffset.get(message_t* msg)
  {
    return getHeader(msg)->length
            + (sizeof(blaze_header_t) - MAC_HEADER_SIZE)
            - MAC_FOOTER_SIZE
            - sizeof(timesync_radio_t);
  }
  
  async command void PacketTimeSyncOffset.set(message_t* msg)
  {
    getMetadata( msg )->timesync = TRUE;
  }
  
  async command void PacketTimeSyncOffset.setoffvalue(message_t* msg, uint8_t value)
  {
    getMetadata( msg )->offset = value;
  }


  async command void PacketTimeSyncOffset.cancel(message_t* msg)
  {
    getMetadata( msg )->timesync = FALSE;
  }
}
