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
 * This layer combines the Send command with the AckReceive event
 * from the asynchronous portion of the receive stack.  It also provides
 * the PacketAcknowledgement interface
 *
 * Above this layer, nothing should be asynchronous context
 * Below this layer should be CSMA
 *
 * 'Acknowledgment' is how it's spelled in the U.S.
 * 'Acknowledgement' is British. 
 * Since TinyOS has a PacketAcknowledgement interface, this will be the
 * Acknowledgement component to keep things consistent.
 * 
 * @author David Moss
 */
configuration AcknowledgementsC {
  provides {
    interface Send[radio_id_t id];
    interface PacketAcknowledgements;
  }
  
  uses {
    interface Send as SubSend[radio_id_t id];
  }
}

implementation {

  components AcknowledgementsP;
  Send = AcknowledgementsP;
  PacketAcknowledgements = AcknowledgementsP;
  SubSend = AcknowledgementsP;
  
  components BlazeSpiC;
  AcknowledgementsP.ChipSpiResource -> BlazeSpiC;
  
  components BlazePacketC;
  AcknowledgementsP.BlazePacketBody -> BlazePacketC;
  
  components new AlarmMultiplexC();
  AcknowledgementsP.AckWaitTimer -> AlarmMultiplexC;
  
  components BlazeReceiveC;
  AcknowledgementsP.AckReceive -> BlazeReceiveC;
  
  components LedsC;
  AcknowledgementsP.Leds -> LedsC;
  
}
