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
 * @author David Moss
 * Rx == 0
 * Tx != 0
 */
 
module TestBroadcastP {
  uses {
    interface Boot;
    interface SplitControl;
    interface LowPowerListening;
    interface AMSend;
    interface Receive;
    interface AMPacket;
    interface Packet;
    interface Timer<TMilli>;
    interface Leds;
    interface Timer<TMilli> as Heartbeat;
  }
}

implementation {
 
  uint8_t count;
  message_t fullMsg;
  bool transmitter;
  
  /**************** Prototypes ****************/
  task void send();
  
  /**************** Boot Events ****************/
  event void Boot.booted() {
    transmitter = (call AMPacket.address() != 0);
    count = 0;
    
    call LowPowerListening.setLocalSleepInterval(200);
    call SplitControl.start();
  }
  
  event void SplitControl.startDone(error_t error) {
    if(transmitter) {
      post send();
    }
    call Heartbeat.startPeriodic(200);
  }
  
  event void SplitControl.stopDone(error_t error) {
  }
  
  
  /**************** Send Receive Events *****************/
  event void AMSend.sendDone(message_t *msg, error_t error) {
    if(transmitter) {
      call Leds.led1Off();
      count++; 
      //call Timer.startOneShot(200);
      post send();
    }
  }
  
  event message_t *Receive.receive(message_t *msg, void *payload, uint8_t len) {
    if(!transmitter) {
      call Leds.led1Toggle();
    }
    return msg;
  }
  
  /**************** Timer Events ****************/
  event void Timer.fired() {
    if(transmitter) {
      post send();
    }
  }
  
  event void Heartbeat.fired() {
    call Leds.led0Toggle();
  }
  
  /**************** Tasks ****************/
  task void send() {
    TestBroadcastMsg *syncMsg = (TestBroadcastMsg *) call Packet.getPayload(&fullMsg, NULL);
    syncMsg->count = count;
    call Leds.led1On();
    call LowPowerListening.setRxSleepInterval(&fullMsg, 200);
    if(call AMSend.send(AM_BROADCAST_ADDR, &fullMsg, sizeof(TestBroadcastMsg)) != SUCCESS) {
      post send();
    }
  }
}

