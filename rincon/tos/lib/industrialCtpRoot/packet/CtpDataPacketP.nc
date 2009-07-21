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
 
#include "Ctp.h"

/**
 * @author Philip Levis
 * @author Kyle Jamieson
 * @author David Moss
 */

module CtpDataPacketP {
  provides {
    interface CtpPacket;
    interface Packet;
  }
  
  uses {
    interface Packet as SubPacket;
  }
}

implementation {
  
  /***************** Functions ****************/
  ctp_data_header_t *getHeader(message_t* m) {
    return (ctp_data_header_t*) call SubPacket.getPayload(m, sizeof(ctp_data_header_t));
  }
  
  /***************** Packet Commands ****************/
  command void Packet.clear(message_t* msg) {
    call SubPacket.clear(msg);
  }
  
  command uint8_t Packet.payloadLength(message_t* msg) {
    return call SubPacket.payloadLength(msg) - sizeof(ctp_data_header_t);
  }

  command void Packet.setPayloadLength(message_t* msg, uint8_t len) {
    call SubPacket.setPayloadLength(msg, len + sizeof(ctp_data_header_t));
  }
  
  command uint8_t Packet.maxPayloadLength() {
    return call SubPacket.maxPayloadLength() - sizeof(ctp_data_header_t);
  }

  command void* Packet.getPayload(message_t* msg, uint8_t len) {
    uint8_t* payload = call SubPacket.getPayload(msg, len + sizeof(ctp_data_header_t));
    if (payload != NULL) {
      payload += sizeof(ctp_data_header_t);
    }
    return payload;
  }
  
  
  /***************** CtpPacket Commands ****************/
  command uint8_t CtpPacket.getType(message_t* msg) {
    return getHeader(msg)->type;
  }
  
  command am_addr_t CtpPacket.getOrigin(message_t* msg) {
    return getHeader(msg)->origin;
  }
  
  command uint16_t CtpPacket.getEtx(message_t* msg) {
    return getHeader(msg)->etx;
  }
  
  command uint8_t CtpPacket.getSequenceNumber(message_t* msg) {
    return getHeader(msg)->originSeqNo;
  }
   
  command uint8_t CtpPacket.getThl(message_t* msg) {
    return getHeader(msg)->thl;
  }
  
  command void CtpPacket.setThl(message_t* msg, uint8_t thl) {
    getHeader(msg)->thl = thl;
  }
  
  command void CtpPacket.setOrigin(message_t* msg, am_addr_t addr) {
    getHeader(msg)->origin = addr;
  }
  
  command void CtpPacket.setType(message_t* msg, uint8_t id) {
    getHeader(msg)->type = id;
  }

  command bool CtpPacket.option(message_t* msg, ctp_options_t opt) {
    return ((getHeader(msg)->options & opt) == opt);
  }

  command void CtpPacket.setOption(message_t* msg, ctp_options_t opt) {
    getHeader(msg)->options |= opt;
  }
  
  command void CtpPacket.clearOption(message_t* msg, ctp_options_t opt) {
    getHeader(msg)->options &= ~opt;
  }

  command void CtpPacket.setEtx(message_t* msg, uint16_t etx) {
    getHeader(msg)->etx = etx;
  }
  
  command void CtpPacket.setSequenceNumber(message_t* msg, uint8_t seqno) {
    getHeader(msg)->originSeqNo = seqno;
  }
  
  command bool CtpPacket.matchInstance(message_t* m1, message_t* m2) {
    return (call CtpPacket.getOrigin(m1) == call CtpPacket.getOrigin(m2) &&
            call CtpPacket.getSequenceNumber(m1) == call CtpPacket.getSequenceNumber(m2) &&
            call CtpPacket.getThl(m1) == call CtpPacket.getThl(m2) &&
            call CtpPacket.getType(m1) == call CtpPacket.getType(m2));
  }

  command bool CtpPacket.matchPacket(message_t* m1, message_t* m2) {
    return (call CtpPacket.getOrigin(m1) == call CtpPacket.getOrigin(m2) &&
            call CtpPacket.getSequenceNumber(m1) == call CtpPacket.getSequenceNumber(m2) &&
            call CtpPacket.getType(m1) == call CtpPacket.getType(m2));
  }
  
}
