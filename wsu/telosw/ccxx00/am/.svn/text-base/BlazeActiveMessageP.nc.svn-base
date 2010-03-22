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

/**
 * Active message implementation on top of the Blaze radio. This
 * implementation uses the 16-bit addressing mode of 802.15.4: the
 * only additional byte it adds is the AM id byte, as the first byte
 * of the data payload.
 *
 * @author Philip Levis
 * @author David Moss
 */
 
#include "Blaze.h"

module BlazeActiveMessageP {
  provides {
    interface AMSend[am_id_t id];
    interface SendNotifier[am_id_t id];
    interface Receive[am_id_t id];
    interface Receive as Snoop[am_id_t id];
    interface AMPacket;
    interface Packet;
  }
  
  uses {
    interface Send as SubSend;
    interface Receive as SubReceive;
    interface RadioSelect;
    interface BlazePacket;
    interface BlazePacketBody;
    interface ActiveMessageAddress;
    interface Leds;

  }
}

implementation {

  enum {
    BLAZE_SIZE = MAC_HEADER_SIZE + MAC_FOOTER_SIZE,
  };
  


  /***************** AMSend Commands ****************/
  command error_t AMSend.send[am_id_t id](am_addr_t addr,
					  message_t* msg,
					  uint8_t len) {
    
    blaze_header_t *header = call BlazePacketBody.getHeader( msg );
        
    header->length = len + BLAZE_SIZE;
    header->type = id;
    header->dest = addr;
    header->destpan = call ActiveMessageAddress.amGroup();
    header->src = call ActiveMessageAddress.amAddress();
    
    signal SendNotifier.aboutToSend[id](addr, msg);
    
    return call SubSend.send( msg, header->length + 1);
  }

  command error_t AMSend.cancel[am_id_t id](message_t* msg) {
    return call SubSend.cancel(msg);
  }

  command uint8_t AMSend.maxPayloadLength[am_id_t id]() {
    return call Packet.maxPayloadLength();
  }

  command void *AMSend.getPayload[am_id_t id](message_t *msg, uint8_t len) {
    return call SubSend.getPayload(msg, len);
  }
  
  /***************** AMPacket Commands ****************/
  command am_addr_t AMPacket.address() {
    return call ActiveMessageAddress.amAddress();
  }
 
  command am_addr_t AMPacket.destination(message_t* amsg) {
    blaze_header_t* header = call BlazePacketBody.getHeader(amsg);
    return header->dest;
  }
 
  command am_addr_t AMPacket.source(message_t* amsg) {
    blaze_header_t* header = call BlazePacketBody.getHeader(amsg);
    return header->src;
  }

  command void AMPacket.setDestination(message_t* amsg, am_addr_t addr) {
    blaze_header_t* header = call BlazePacketBody.getHeader(amsg);
    header->dest = addr;
  }

  command void AMPacket.setSource(message_t* amsg, am_addr_t addr) {
    blaze_header_t* header = call BlazePacketBody.getHeader(amsg);
    header->src = addr;
  }

  command bool AMPacket.isForMe(message_t* amsg) {
    return (call AMPacket.destination(amsg) == call AMPacket.address() ||
	    call AMPacket.destination(amsg) == AM_BROADCAST_ADDR);
  }

  command am_id_t AMPacket.type(message_t* amsg) {
    blaze_header_t* header = call BlazePacketBody.getHeader(amsg);
    return header->type;
  }

  command void AMPacket.setType(message_t* amsg, am_id_t type) {
    blaze_header_t* header = call BlazePacketBody.getHeader(amsg);
    header->type = type;
  }
  
  command am_group_t AMPacket.group(message_t* amsg) {
    return (call BlazePacketBody.getHeader(amsg))->destpan;
  }

  command void AMPacket.setGroup(message_t* amsg, am_group_t grp) {
    // Overridden intentionally when we send()
    (call BlazePacketBody.getHeader(amsg))->destpan = grp;
  }

  command am_group_t AMPacket.localGroup() {
    return call ActiveMessageAddress.amGroup();
  }
  

  /***************** Packet Commands ****************/
  command void Packet.clear(message_t* msg) {
    memset(call BlazePacketBody.getHeader(msg), sizeof(blaze_header_t), 0);
    memset(call BlazePacketBody.getMetadata(msg), sizeof(blaze_metadata_t), 0);
  }
  
  command uint8_t Packet.payloadLength(message_t* msg) {
    return (call BlazePacketBody.getHeader(msg))->length - BLAZE_SIZE;
  }
  
  command void Packet.setPayloadLength(message_t* msg, uint8_t len) {
    (call BlazePacketBody.getHeader(msg))->length  = len + BLAZE_SIZE;
  }
  
  command uint8_t Packet.maxPayloadLength() {
    return TOSH_DATA_LENGTH;
  }
  
  command void *Packet.getPayload(message_t* msg, uint8_t len) {
    if (len <= TOSH_DATA_LENGTH) {
      return msg->data;
    } else {
      return NULL;
    }
  }

  
  /***************** SubSend Events ****************/
  event void SubSend.sendDone(message_t* msg, error_t result) {

    signal AMSend.sendDone[call AMPacket.type(msg)](msg, result);
  }

  
  /***************** SubReceive Events ****************/
  event message_t* SubReceive.receive(message_t* msg, void* payload, uint8_t len) {

    if (call AMPacket.isForMe(msg)) {
      return signal Receive.receive[call AMPacket.type(msg)](msg, payload, len - BLAZE_SIZE);
    } else {
      signal Snoop.receive[call AMPacket.type(msg)](msg, payload, len - BLAZE_SIZE);
    }
    
    return msg;
  }
  

  /***************** ActiveMessageAddress Events ****************/
  async event void ActiveMessageAddress.changed() {
  }
  
  
  /***************** Defaults ****************/
  default event message_t* Receive.receive[am_id_t id](message_t* msg, void* payload, uint8_t len) {
    return msg;
  }
  
  default event message_t* Snoop.receive[am_id_t id](message_t* msg, void* payload, uint8_t len) {
    return msg;
  }

  default event void AMSend.sendDone[am_id_t id](message_t* msg, error_t err) {
  }
  
  default event void SendNotifier.aboutToSend[am_id_t amId](am_addr_t addr, message_t *msg) {
  }

}
