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
 * Automatically generated header file for BBoot
 */
 
#include "BBoot.h"

configuration Link_BBootC {
  uses {
    interface BBoot;
  }
}

implementation {
  components Link_BBootP as LinkP;
  
  components new SerialAMSenderC(AM_BBOOTMSG) as SerialEventSendC,
      new SerialAMSenderC(AM_BBOOTMSG) as SerialReplySendC,
      new SerialAMReceiverC(AM_BBOOTMSG),
      SerialActiveMessageC;
      
  LinkP.SerialReplySend -> SerialReplySendC;
  LinkP.SerialEventSend -> SerialEventSendC;
  LinkP.SerialReceive -> SerialAMReceiverC;
  LinkP.SerialPacket -> SerialActiveMessageC;
  LinkP.SerialAMPacket -> SerialActiveMessageC;
  
  /** No radio
  components new AMSenderC(AM_BBOOTMSG) as RadioEventSendC,
      new AMSenderC(AM_BBOOTMSG) as RadioReplySendC,
      new AMReceiverC(AM_BBOOTMSG) as RadioReceiveC,
      ActiveMessageC,
      MessageTransportC;
      
  LinkP.RadioReplySend -> RadioReplySendC;
  LinkP.RadioEventSend -> RadioEventSendC;
  LinkP.RadioReceive -> RadioReceiveC;
  LinkP.MessageTransport -> MessageTransportC;
  LinkP.RadioPacket -> ActiveMessageC;
  LinkP.RadioAMPacket -> ActiveMessageC;
  */
  
  BBoot = LinkP;
}
