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
 * Sending service messages over the serial port to the XBee
 *
 * @author Philip Levis
 * @author Ben Greenstein
 * @author Mirko Bordignon <mirko.bordignon@ieee.org>
 */

#include <Xbee.h>

module XbeeServiceMessageP {
  provides {
    //interface Init;
    //interface AMSend[am_id_t id];
    //interface Receive[am_id_t id];
    //interface AMPacket;
    //interface Packet;
    //interface PacketAcknowledgements;
  }
  uses {
    interface Send as SubSend;
    interface Receive as SubReceive;
    command am_addr_t amAddress();
  }
}
implementation {
  /*
  message_t ATCommandMsg;
  //nx_uint8_t ATopt[2];
  typedef nx_struct ATopt {
    nx_uint8_t MSB;
    nx_uint8_t LSB;
  } ATopt;
  */
  xbee_service_header_t* getHeader(message_t* msg) {
    return (xbee_service_header_t*)(msg->data - sizeof(xbee_service_header_t));
  }

  xbee_metadata_t* getMetadata(message_t* msg) {
    return (xbee_metadata_t*)(msg->footer + sizeof(xbee_footer_t));
  }
  /*
  command error_t Init.init() {

    // set the node AM address issuing the proper AT command to the Xbee
    xbee_header_t* header = getHeader(&ATCommandMsg);
    ATopt* opt = (ATopt*)(call Packet.getPayload(&ATCommandMsg, NULL));
    am_addr_t addr = call amAddress();
    header->api = 0x08;
    header->opt[0] = 0x00;    // no ACK
    header->opt[1] = 0x44;    // ASCII for D
    header->opt[2] = 0x4C;    // ASCII for L
    header->opt[3] = 0x00;    // uppermost two bits of DL = 0x0000
    header->type = 0x00;
    opt->MSB = (addr >> 8) & 0xFF; //MSB of the node address
    opt->LSB = addr & 0xFF;        //LSB of the node address
    return call SubSend.send(&ATCommandMsg, 2);
  }
  */
  command error_t AMSend.send[am_id_t id](am_addr_t dest,
					  message_t* msg,
					  uint8_t len) {
    xbee_service_header_t* header = getHeader(msg);
    //header->dest = dest;
    // Do not set the source address or group, as doing so
    // prevents transparent bridging. Need a better long-term
    // solution for this.
    //header->src = call AMPacket.address();
    //header->group = TOS_AM_GROUP;
    //header->type = id;
    //header->length = len;
    header->api = 0x08;
    //header->opt[0] = 0x00;  // for the moment disable the response frame 
    //header->opt[1] = (dest >> 8) & 0xFF;  // MSB of the dest addr
    //header->opt[2] = dest & 0xFF;         // LSB of the dest addr
    //header->opt[3] = 0x01;  // for the moment disable ACKs
    //header->type = id;      // AM type

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
    xbee_header_t* header = getHeader(amsg);
    // to be implemented ...
    //header->src = addr;
  }
  
  command bool AMPacket.isForMe(message_t* amsg) {
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

  async command error_t PacketAcknowledgements.requestAck( message_t* msg ) {
    return FAIL;
  }
  async command error_t PacketAcknowledgements.noAck( message_t* msg ) {
    return SUCCESS;
  }
   
  async command bool PacketAcknowledgements.wasAcked(message_t* msg) {
    return FALSE;
  }

}
