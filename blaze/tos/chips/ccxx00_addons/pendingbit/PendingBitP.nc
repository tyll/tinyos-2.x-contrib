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
 * @author David Moss
 */
 
module PendingBitP {
  provides {
    interface PendingBit;
  }

  uses {
    interface Receive[am_id_t amId];
    interface LowPowerListening;
    interface BlazePacket;
    interface Timer<TMilli>;
  }
}

implementation {

  uint16_t normalLocalWakeupInterval;
  
  uint16_t abnormalDuration = 10240U;
  
  uint16_t abnormalWakeupInterval = 0;
  
  /***************** PendingBit Commands ****************/
  command void PendingBit.setDuration(uint16_t bms) {
    abnormalDuration = bms;
  }
  
  command void PendingBit.setLocalWakeupInterval(uint16_t bms) {
    abnormalWakeupInterval = bms;
  }
  
  command void PendingBit.forcePendingBitMode() {
    if(!call Timer.isRunning()) {
      normalLocalWakeupInterval = call LowPowerListening.getLocalWakeupInterval();
      call LowPowerListening.setLocalWakeupInterval(abnormalWakeupInterval);
    }
    
    call Timer.startOneShot(abnormalDuration);
  }
  
  /***************** Receive Events *****************/
  event message_t *Receive.receive[am_id_t amId](message_t *msg, void *payload, uint8_t length) {
    if(call BlazePacket.isPacketPending(msg)) {
      call PendingBit.forcePendingBitMode();
    }
    
    return msg;
  }
  
  /***************** Timer Events ****************/
  event void Timer.fired() {
    if(call LowPowerListening.getLocalWakeupInterval() == abnormalWakeupInterval) {
      call LowPowerListening.setLocalWakeupInterval(normalLocalWakeupInterval);
    }
  }
  
}
