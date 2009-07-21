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

module CtpRoutingPacketP {
  provides {
    interface CtpRoutingPacket;
  }
  
  uses {
    interface Packet;
  }
}

implementation {

  /***************** Functions ****************/
  ctp_routing_header_t *getHeader(message_t *m) {
    return (ctp_routing_header_t*) call Packet.getPayload(m, call Packet.maxPayloadLength());
  }

  /***************** CtpRoutingPacket Commands ***************/
  command bool CtpRoutingPacket.getOption(message_t* msg, ctp_options_t opt) {
    return ((getHeader(msg)->options & opt) == opt);
  }

  command void CtpRoutingPacket.setOption(message_t* msg, ctp_options_t opt) {
    getHeader(msg)->options |= opt;
  }

  command void CtpRoutingPacket.clearOption(message_t* msg, ctp_options_t opt) {
    getHeader(msg)->options &= ~opt;
  }

  command void CtpRoutingPacket.clearOptions(message_t* msg) {
    getHeader(msg)->options = 0;
  }
  
  command am_addr_t CtpRoutingPacket.getParent(message_t* msg) {
    return getHeader(msg)->parent;
  }
  
  command void CtpRoutingPacket.setParent(message_t* msg, am_addr_t addr) {
    getHeader(msg)->parent = addr;
  }
  
  command uint16_t CtpRoutingPacket.getEtx(message_t* msg) {
    return getHeader(msg)->etx;
  }
  
  command void CtpRoutingPacket.setEtx(message_t* msg, uint8_t etx) {
    getHeader(msg)->etx = etx;
  }
  
  
}

