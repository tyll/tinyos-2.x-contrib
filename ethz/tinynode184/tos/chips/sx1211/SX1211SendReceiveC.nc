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
configuration SX1211SendReceiveC {
    provides interface Send;
    provides interface Packet;
    provides interface PacketAcknowledgements;
    provides interface AckSendReceive;
    provides interface SplitControl @atleastonce();
    provides interface Receive;
    provides interface SendBuff;
}

implementation {

  components SX1211SendReceiveP;
  Send = SX1211SendReceiveP;
  Receive = SX1211SendReceiveP;
  Packet = SX1211SendReceiveP;
  PacketAcknowledgements = SX1211SendReceiveP;
  AckSendReceive = SX1211SendReceiveP;
  SplitControl = SX1211SendReceiveP;
  SendBuff = SX1211SendReceiveP;

  components SX1211PhyC;
  SX1211SendReceiveP.SX1211PhyRxTx -> SX1211PhyC;
  SX1211SendReceiveP.SX1211PhyRssi -> SX1211PhyC;
  SX1211SendReceiveP.PhySplitControl -> SX1211PhyC;
  
  components SX1211PacketC;
  SX1211SendReceiveP.SX1211PacketBody -> SX1211PacketC;

}

