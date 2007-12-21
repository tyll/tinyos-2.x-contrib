/*
 * Copyright (c) 2007 nxtmote project
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
 * - Neither the name of nxtmote project nor the names of
 *   its contributors may be used to endorse or promote products derived
 *   from this software without specific prior written permission.
 *
 * THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS
 * ``AS IS'' AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT
 * LIMITED TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS
 * FOR A PARTICULAR PURPOSE ARE DISCLAIMED.  IN NO EVENT SHALL THE
 * ARCHED ROCK OR ITS CONTRIBUTORS BE LIABLE FOR ANY DIRECT, INDIRECT,
 * INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES
 * (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR
 * SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION)
 * HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT,
 * STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE)
 * ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED
 * OF THE POSSIBILITY OF SUCH DAMAGE
 */

/**
 * @author Rasmus Ulslev Pedersen
 */

#include "message.h"

module Bc4PacketC {

  provides interface Bc4Packet;
  provides interface PacketAcknowledgements as Acks;

}

implementation {

  async command bc4_header_t *Bc4Packet.getHeader( message_t* msg ) {
    return (bc4_header_t*)( msg->data - sizeof( bc4_header_t ) );
  }

  async command bc4_metadata_t *Bc4Packet.getMetadata( message_t* msg ) {
    return (bc4_metadata_t*)msg->metadata;
  }

  //TODO
  async command error_t Acks.requestAck( message_t* p_msg ) {
    return SUCCESS;
  }

  async command error_t Acks.noAck( message_t* p_msg ) {
    return SUCCESS;
  }

  async command bool Acks.wasAcked( message_t* p_msg ) {
    return 0;
  }

}
