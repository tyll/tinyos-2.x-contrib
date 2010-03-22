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
#include "Lpl.h"
#include "Wor.h"

configuration LplC {
  provides {
    interface Send[radio_id_t radioId];
    interface Receive[radio_id_t radioId];
    interface LowPowerListening[radio_id_t id];
    interface SplitControl[radio_id_t id];
  }
  
  uses {
    interface Send as SubSend[radio_id_t radioId];
    interface Receive as SubReceive[radio_id_t radioId];
		//added by Gang Aug 26 09
		interface SplitControl as SubControl[radio_id_t radioId];
  }
}

implementation {
  components LplP;
  Send = LplP.Send;
  Receive = SubReceive;
  SubSend = LplP.SubSend;
  SplitControl = LplP.SplitControl;
  LowPowerListening = LplP;
  
  components SplitControlManagerC;
  LplP.SplitControlManager -> SplitControlManagerC;
  
  components BlazeReceiveC;
  LplP.RxNotify -> BlazeReceiveC;
  LplP.ReceiveState -> BlazeReceiveC;
  
  components WorC;
  LplP.Wor -> WorC;
  
  components BlazePacketC;
  LplP.BlazePacketBody -> BlazePacketC;
  
  components LedsC;
  LplP.Leds -> LedsC;
  
  components new StateC();
  LplP.State -> StateC;

	//add by Gang Spe 17
	SubControl = LplP.SubControl;

	components BlazeSpiC;
	LplP.STX -> BlazeSpiC.STX;
	components new TimerMilliC() as preamble;
	LplP.PreambleTimer -> preamble;
  components new BlazeSpiResourceC();
	LplP.Resource -> BlazeSpiResourceC;
	
  
}

