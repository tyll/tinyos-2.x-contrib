/* "Copyright (c) 2000-2005 The Regents of the University of California.  
 * All rights reserved.
 *
 * Permission to use, copy, modify, and distribute this software and its
 * documentation for any purpose, without fee, and without written agreement
 * is hereby granted, provided that the above copyright notice, the following
 * two paragraphs and the author appear in all copies of this software.
 * 
 * IN NO EVENT SHALL THE UNIVERSITY OF CALIFORNIA BE LIABLE TO ANY PARTY FOR
 * DIRECT, INDIRECT, SPECIAL, INCIDENTAL, OR CONSEQUENTIAL DAMAGES ARISING OUT
 * OF THE USE OF THIS SOFTWARE AND ITS DOCUMENTATION, EVEN IF THE UNIVERSITY
 * OF CALIFORNIA HAS BEEN ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
 * 
 * THE UNIVERSITY OF CALIFORNIA SPECIFICALLY DISCLAIMS ANY WARRANTIES,
 * INCLUDING, BUT NOT LIMITED TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY
 * AND FITNESS FOR A PARTICULAR PURPOSE.  THE SOFTWARE PROVIDED HEREUNDER IS
 * ON AN "AS IS" BASIS, AND THE UNIVERSITY OF CALIFORNIA HAS NO OBLIGATION TO
 * PROVIDE MAINTENANCE, SUPPORT, UPDATES, ENHANCEMENTS, OR MODIFICATIONS."
 *
 * Copyright (c) 2007 University of Padova
 * Copyright (c) 2007 Orebro University
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
 * - Neither the name of the the copyright holders nor the names of
 *   their contributors may be used to endorse or promote products derived
 *   from this software without specific prior written permission.
 *
 * THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS
 * ``AS IS'' AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT
 * LIMITED TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS
 * FOR A PARTICULAR PURPOSE ARE DISCLAIMED.  IN NO EVENT SHALL THE COPYRIGHT
 * HOLDERS OR THEIR CONTRIBUTORS BE LIABLE FOR ANY DIRECT, INDIRECT,
 * INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES
 * (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR
 * SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION)
 * HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT,
 * STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE)
 * ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED
 * OF THE POSSIBILITY OF SUCH DAMAGE.
 */

/**
 * Sending active messages over the serial port to the XBee
 *
 * @author Philip Levis
 * @author Ben Greenstein
 * @author Mirko Bordignon <mirko.bordignon@ieee.org>
 */

#include <Xbee.h>

module XbeeActiveMessageP {
  provides {
    interface AMSend[am_id_t id];
    interface Receive[am_id_t id];
    interface AMPacket;
    interface Packet;
  }
  uses {
    interface Send as SubSend;
    interface Receive as SubReceive;
    interface Receive as StatusReceive;
    interface Leds; // debug
    command am_addr_t amAddress();
  }
}
implementation {

  uint8_t FrameID = 0;

  // we store the pointer to the last sent message
  // to relate it with received status messages
  message_t* lastSentMsg;

  // debug
  void setLeds(uint16_t val) {
    if (val & 0x01)
      call Leds.led0On();
    else 
      call Leds.led0Off();
    if (val & 0x02)
      call Leds.led1On();
    else
      call Leds.led1Off();
    if (val & 0x04)
      call Leds.led2On();
    else
      call Leds.led2Off();
  }

  xbee_header_t* getHeader(message_t* msg) {
    return (xbee_header_t*)(msg->data - sizeof(xbee_header_t));
  }

  xbee_metadata_t* getMetadata(message_t* msg) {
    return (xbee_metadata_t*)(msg->footer + sizeof(xbee_footer_t));
  }

  command error_t AMSend.send[am_id_t id](am_addr_t dest,
					  message_t* msg,
					  uint8_t len) {
    xbee_header_t* header = getHeader(msg);
    xbee_metadata_t* metadata = getMetadata(msg);
    header->api = XBEE_API_TX;

    FrameID++;
    if (FrameID==0x00) {   // 8-bit rollover: we do not want FrameID=0
      FrameID++;           // (it disables response frame)
    }
    lastSentMsg = msg;

    header->opt[0] = FrameID;
    header->opt[1] = (dest >> 8) & 0xFF;  // MSB of the dest addr
    header->opt[2] = dest & 0xFF;         // LSB of the dest addr

    // on the xbee (with MM=2) acks are required by default,
    // disable them unless specified
    if ((metadata->ack_req)!=TRUE) {
      header->opt[3] = 0x01;
    }
    header->type = id;      // AM type

    return call SubSend.send(msg, len);
  }

  command error_t AMSend.cancel[am_id_t id](message_t* msg) {
    return call SubSend.cancel(msg);
  }

  command uint8_t AMSend.maxPayloadLength[am_id_t id]() {
    return call Packet.maxPayloadLength();
  }

  command void* AMSend.getPayload[am_id_t id](message_t* m) {
    return call Packet.getPayload(m, NULL);
  }
  
  event void SubSend.sendDone(message_t* msg, error_t result) {
    signal AMSend.sendDone[call AMPacket.type(msg)](msg, result);
  }

 default event void AMSend.sendDone[uint8_t id](message_t* msg, error_t result) {
   return;
 }

 default event message_t* Receive.receive[uint8_t id](message_t* msg, void* payload, uint8_t len) {
   return msg;
 }
 
  
  command void* Receive.getPayload[am_id_t id](message_t* m, uint8_t* len) {
    return call Packet.getPayload(m, len);
  }

  command uint8_t Receive.payloadLength[am_id_t id](message_t* m) {
    return call Packet.payloadLength(m);
  }
  
  event message_t* SubReceive.receive(message_t* msg, void* payload, uint8_t len) {
    return signal Receive.receive[call AMPacket.type(msg)](msg, msg->data, len);
  }

  event message_t* StatusReceive.receive(message_t* msg, void* payload, uint8_t len) {

    xbee_header_t* header = getHeader(lastSentMsg);
    xbee_metadata_t* metadata = getMetadata(lastSentMsg);

    // would be better to use a meaningful struct, cast payload to reference it,
    // and access proper fields. Have to investigate why it doesn't work
    // in the meantime, access directly the data vector

    if ((msg->data[0]) == header->opt[0]) {   // frame ID matches
      if ((msg->data[1])==0) {                // 0=ok
        metadata->ack = TRUE;
      }
      else {// could discriminate more finely: 1=noAck, 2=CCA failure, 3=Purged
        metadata->ack = FALSE;
      }
    }

    return msg;
  }

  command void Packet.clear(message_t* msg) {
    return;
  }

  command uint8_t Packet.payloadLength(message_t* msg) {
    xbee_metadata_t* metadata = getMetadata(msg);    
    return metadata->length;
  }

  command void Packet.setPayloadLength(message_t* msg, uint8_t len) {
    getMetadata(msg)->length  = len;
  }
  
  command uint8_t Packet.maxPayloadLength() {
    return TOSH_DATA_LENGTH;
  }
  
  command void* Packet.getPayload(message_t* msg, uint8_t* len) {
    if (len != NULL) { 
      *len = call Packet.payloadLength(msg);
    }
    return msg->data;
  }

  command am_addr_t AMPacket.address() {
    return call amAddress();
  }

  command am_addr_t AMPacket.destination(message_t* amsg) {
    xbee_header_t* header = getHeader(amsg);
    return ((header->opt[1] << 8) + header->opt[2]); 
  }

  command am_addr_t AMPacket.source(message_t* amsg) {
    xbee_header_t* header = getHeader(amsg);
    return ((header->opt[0] << 8) + header->opt[1]);
  }

  command void AMPacket.setDestination(message_t* amsg, am_addr_t addr) {
    xbee_header_t* header = getHeader(amsg);
    header->opt[1] = (addr >> 8) & 0xFF;  // MSB of the dest addr
    header->opt[2] = addr & 0xFF;         // LSB of the dest addr
  }

  command void AMPacket.setSource(message_t* amsg, am_addr_t addr) {
    // automatically done in hardware by the xbee
  }
  
  command bool AMPacket.isForMe(message_t* amsg) {
    // hardware address filtering: if received the packet, it was for me
    return TRUE;
  }

  command am_id_t AMPacket.type(message_t* amsg) {
    xbee_header_t* header = getHeader(amsg);
    return header->type;
  }

  command void AMPacket.setType(message_t* amsg, am_id_t type) {
    xbee_header_t* header = getHeader(amsg);
    header->type = type;
  }

}
