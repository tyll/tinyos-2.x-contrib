/* 
 * Copyright (c) 2008, University of Twente (UTWENTE), the Netherlands.
 * All rights reserved.
 *
 * Redistribution and use in source and binary forms, with or without
 * modification, are permitted provided that the following conditions
 * are met:
 * - Redistributions of source code must retain the above copyright notice,
 *   this list of conditions and the following disclaimer.
 * - Redistributions in binary form must reproduce the above copyright
 *   notice, this list of conditions and the following disclaimer in the
 *   documentation and/or other materials provided with the distribution.
 * - Neither the name of the University of Twente (UTWENTE)
 *   nor the names of its contributors may be used to 
 *   endorse or promote products derived from this software without 
 *   specific prior written permission.
 * 
 * THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS
 * "AS IS" AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT
 * LIMITED TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR
 * A PARTICULAR PURPOSE ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT
 * OWNER OR CONTRIBUTORS BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL,
 * SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED
 * TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA,
 * OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY
 * OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT
 * (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE
 * USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
 *
 * ========================================================================
 */

/*
 * @author Leon Evers
 *
 */
configuration nRF905ActiveMessageC {
  provides {
    interface SplitControl;
    interface AMSend[am_id_t id];
    interface Receive[am_id_t id];
    interface Receive as Snoop[am_id_t id];
    interface AMPacket;
    interface Packet;
    interface PacketAcknowledgements;
    #ifdef LOW_POWER_LISTENING
    interface LowPowerListening;
    #endif
  }
}
implementation {
  components nRF905SendReceiveC;
  Packet                 = nRF905SendReceiveC;
  PacketAcknowledgements = nRF905SendReceiveC;
 components nRF905ActiveMessageP;

#ifdef LOW_POWER_LISTENING
  components  nRF905LowPowerListeningC as Lpl;
  LowPowerListening = Lpl;
  nRF905ActiveMessageP.SubSend -> Lpl.Send;
  nRF905ActiveMessageP.SubReceive -> Lpl.Receive;
  SplitControl = Lpl;
#else
 
  nRF905ActiveMessageP.Packet     -> nRF905SendReceiveC;
  nRF905ActiveMessageP.SubSend    -> nRF905SendReceiveC.Send;
  nRF905ActiveMessageP.SubReceive -> nRF905SendReceiveC.Receive;
  SplitControl = nRF905SendReceiveC;
#endif
  AMPacket = nRF905ActiveMessageP;
  AMSend   = nRF905ActiveMessageP;
  Receive  = nRF905ActiveMessageP.Receive;
  Snoop  = nRF905ActiveMessageP.Snoop;


  components ActiveMessageAddressC;  
  nRF905ActiveMessageP.amAddress -> ActiveMessageAddressC;  


  components nRF905IrqConfC, nRF905PatternConfC, nRF905PhyRssiConfC;

}
