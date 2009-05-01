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
 
/**
 * @author Philip Levis
 * @author Kyle Jamieson
 * @author David Moss
 */

#include "Ctp.h"

configuration CtpForwardingEngineC {
  provides {
    interface StdControl;
    interface Send[uint8_t client];
    interface Receive[collection_id_t id];
    interface Receive as Snoop[collection_id_t id];
    interface Intercept[collection_id_t id];
    interface CtpCongestion;
  }
  
  uses {
    interface CollectionId[uint8_t client];
  }
}

implementation {

  enum {
    CLIENT_COUNT = uniqueCount(UQ_CTP_CLIENT),
    QUEUE_SIZE = CLIENT_COUNT + FORWARD_COUNT,
  };
  
  components CtpForwardingEngineP;
  StdControl = CtpForwardingEngineP;
  Send = CtpForwardingEngineP;
  Receive = CtpForwardingEngineP.Receive;
  Snoop = CtpForwardingEngineP.Snoop;
  Intercept = CtpForwardingEngineP;
  CtpCongestion = CtpForwardingEngineP;
  CollectionId = CtpForwardingEngineP;
  
  components MainC;
  MainC.SoftwareInit -> CtpForwardingEngineP;
  
  components CtpDataPacketC;
  CtpForwardingEngineP.CtpPacket -> CtpDataPacketC;
  CtpForwardingEngineP.Packet -> CtpDataPacketC;
  
  components CtpRoutingEngineC;
  CtpForwardingEngineP.CtpInfo -> CtpRoutingEngineC;
  CtpForwardingEngineP.UnicastNameFreeRouting -> CtpRoutingEngineC;
  CtpForwardingEngineP.RootControl -> CtpRoutingEngineC;
  
  components new PoolC(message_t, FORWARD_COUNT) as MessagePoolP;
  CtpForwardingEngineP.MessagePool -> MessagePoolP;
  
  components new PoolC(fe_queue_entry_t, FORWARD_COUNT) as QEntryPoolP;
  CtpForwardingEngineP.QEntryPool -> QEntryPoolP;

  components new QueueC(fe_queue_entry_t*, QUEUE_SIZE) as SendQueueP;
  CtpForwardingEngineP.SendQueue -> SendQueueP;

  components new LruCtpMsgCacheC(CACHE_SIZE) as SentCacheP;
  CtpForwardingEngineP.SentCache -> SentCacheP;

  components LinkEstimatorC;
  CtpForwardingEngineP.LinkEstimator -> LinkEstimatorC;
  
  components new TimerMilliC() as RetransmitTimer;
  CtpForwardingEngineP.RetransmitTimer -> RetransmitTimer;

  components new TimerMilliC() as CongestionTimer;
  CtpForwardingEngineP.CongestionTimer -> CongestionTimer;
  
  components RandomC;
  CtpForwardingEngineP.Random -> RandomC;
  
  components ActiveMessageC;
  CtpForwardingEngineP.RadioSplitControl -> ActiveMessageC;
  CtpForwardingEngineP.NormalPacket -> ActiveMessageC;
  
  components new AMSenderC(AM_CTP_DATA);
  CtpForwardingEngineP.SubSend -> AMSenderC;
  CtpForwardingEngineP.NormalPacket -> AMSenderC;
  CtpForwardingEngineP.AMPacket -> AMSenderC;
  CtpForwardingEngineP.PacketAcknowledgements -> AMSenderC;
  
  components new AMReceiverC(AM_CTP_DATA);
  CtpForwardingEngineP.SubReceive -> AMReceiverC;
  
  components new AMSnooperC(AM_CTP_DATA);
  CtpForwardingEngineP.SubSnoop -> AMSnooperC;
  
  components LedsC;
  CtpForwardingEngineP.Leds -> LedsC;
  
  
}
