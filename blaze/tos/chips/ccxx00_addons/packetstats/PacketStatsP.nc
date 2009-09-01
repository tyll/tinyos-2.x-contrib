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
 
module PacketStatsP {
  provides {
    /** Stats: Total number of packets transmitted by this node */
    interface PacketCount as TransmittedPacketCount;
    
    /** Stats: Total number of packets received by this node */
    interface PacketCount as ReceivedPacketCount;
    
    /** Stats: Total number of packets overheard by this node */
    interface PacketCount as OverheardPacketCount;
    
  }
  
  uses {
    interface AMSend[am_id_t amId];
    interface Receive[am_id_t amId];
    interface Receive as Snoop[am_id_t amId];
  }
}

implementation {

  uint32_t transmittedPackets;
  uint32_t receivedPackets;
  uint32_t overheardPackets;
  
  
  /***************** PacketCount Commands **************/
  command uint32_t TransmittedPacketCount.getTotal() {
    return transmittedPackets;
  }
  
  command uint32_t ReceivedPacketCount.getTotal() {
    return receivedPackets;
  }
  
  command uint32_t OverheardPacketCount.getTotal() {
    return overheardPackets;
  }
  
  
  /***************** Receive Events ****************/
  event message_t *Receive.receive[am_id_t amId](message_t *msg, void *payload, uint8_t len) {
    receivedPackets++;
    return msg;
  }

  event message_t *Snoop.receive[am_id_t amId](message_t *msg, void *payload, uint8_t len) {
    overheardPackets++;
    return msg;
  }
  

  /***************** AMSend Events ****************/
  event void AMSend.sendDone[am_id_t amId](message_t *msg, error_t error) {
    transmittedPackets++;
  }  
  
}

