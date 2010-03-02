/* 
 * Copyright (c) 2006, Ecole Polytechnique Federale de Lausanne (EPFL),
 * Switzerland.
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
 * - Neither the name of the Ecole Polytechnique Federale de Lausanne (EPFL) 
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
 * @author Henri Dubois-Ferriere
 *
 */
configuration SX1211ActiveMessageC {
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
  components SX1211SendReceiveC;
  Packet                 = SX1211SendReceiveC;
  PacketAcknowledgements = SX1211SendReceiveC;
 components SX1211ActiveMessageP;

#ifdef LOW_POWER_LISTENING
  components SX1211LowPowerListeningC as Lpl;
  LowPowerListening = Lpl;
  SX1211ActiveMessageP.SubSend -> Lpl.Send;
  SX1211ActiveMessageP.SubReceive -> Lpl.Receive;
  SplitControl = Lpl;
#else
 
  SX1211ActiveMessageP.Packet     -> SX1211SendReceiveC;
  SX1211ActiveMessageP.SubSend    -> SX1211SendReceiveC.Send;
  SX1211ActiveMessageP.SubReceive -> SX1211SendReceiveC.Receive;
  SplitControl = SX1211SendReceiveC;
#endif
  AMPacket = SX1211ActiveMessageP;
  AMSend   = SX1211ActiveMessageP;
  Receive  = SX1211ActiveMessageP.Receive;
  Snoop  = SX1211ActiveMessageP.Snoop;


  components ActiveMessageAddressC;  
  SX1211ActiveMessageP.amAddress -> ActiveMessageAddressC;  

  components SX1211IrqConfC, SX1211PatternConfC, SX1211PhyRssiConfC;
}
