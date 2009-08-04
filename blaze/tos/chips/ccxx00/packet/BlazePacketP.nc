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

/**
 * @author David Moss
 */
module BlazePacketP {

  provides {
    interface BlazePacket;
    interface BlazePacketBody;
    interface LinkPacketMetadata;
  }

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
  /** 
   * From the CC1101 Datasheet:
   * LQI is best used as a relative measurement of the link quality (a low 
   * value indicates a better link than what a high value does), since the value 
   * is dependent on the modulation format.
   */
  async command bool LinkPacketMetadata.highChannelQuality(message_t* msg) {
    // Measured experimentally probably using MSK modulation, 0 dBm TX power.
    // After the LQI went up above it's good value of 12-13, it reached into 
    // the 20's and the packet reception rate went way down.
    return call BlazePacket.getLqi(msg) < 16;
  }


}
