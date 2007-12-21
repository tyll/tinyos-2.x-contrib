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
 * Note: Adapted from CC2420 files.
 */

#include "Bc4.h"
#include "AM.h"

configuration Bc4ActiveMessageC {
  provides {
    interface AMSend[am_id_t id];
    interface Receive as Receive[am_id_t id];
    interface AMPacket;
    interface Packet;
    interface Bc4Packet;
    interface PacketAcknowledgements;
  }
}
implementation {

  components Bc4ActiveMessageP as AM;
  components ActiveMessageAddressC as Address;
  components Bc4PacketC;
  components BC4TransmitC, BC4ReceiveC;
  components BC4ControlC, HalBtC;
  components BTAMAddressC;
components HalLCDC;
  
  Packet       = AM;
  AMSend   = AM;
  
  AMPacket = AM;
  
  Receive = AM.Receive;
  
  PacketAcknowledgements = Bc4PacketC;
  
  AM.SubSend -> BC4TransmitC;
  BC4ReceiveC <- AM.SubReceive;
  
  Bc4Packet = Bc4PacketC;
  AM.Bc4Packet -> Bc4PacketC;
  
  BC4TransmitC.SubSend -> BC4ControlC;
  BC4ReceiveC.SubReceive -> BC4ControlC;
  
  BC4ControlC.HalBt -> HalBtC;
  
  AM.BTAMAddress -> BTAMAddressC;
  AM.amAddress -> Address;
  
  AM.HalLCD -> HalLCDC.HalLCD;  
}
