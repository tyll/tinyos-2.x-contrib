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
 * Tx == 1
 * Tx == 2
 * Tx == 3
 */
 
module TestMultiP {
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
    interface JDebug;
  }
}

implementation {
 
  uint8_t count;
  message_t fullMsg;
  bool transmitter;
  uint8_t mote1;
  uint8_t mote2;
  uint8_t mote3;
  uint16_t missed1;
  uint16_t missed2;
  uint16_t missed3;
  uint32_t delivered1;
  uint32_t delivered2;
  uint32_t delivered3;
  
  
  /**************** Prototypes ****************/
  task void send();
  
  /**************** Boot Events ****************/
  event void Boot.booted() {
    transmitter = (call AMPacket.address() != 0);
    
    call LowPowerListening.setLocalSleepInterval(1000);
    call SplitControl.start();
  }
  
  event void SplitControl.startDone(error_t error) {
    if(transmitter) {
      call Heartbeat.startPeriodic(100);
      count = 0;
      post send();
      
    } else {
      mote1 = 0;
      mote2 = 0;
      mote3 = 0;
      missed1 = 0;
      missed2 = 0;
      missed3 = 0;
      delivered1 = 0;
      delivered2 = 0;
      delivered3 = 0;
    }
  }
  
  event void SplitControl.stopDone(error_t error) {
  }
  
  
  /**************** Send Receive Events *****************/
  event void AMSend.sendDone(message_t *msg, error_t error) {
    if(transmitter) {
      count++; 
      call Leds.led2Off();
      call Leds.led1Off();
      call Timer.startOneShot(500);
    }
  }
  
  event message_t *Receive.receive(message_t *msg, void *payload, uint8_t len) {
    if(transmitter) {
      return msg;
    }
    
    if(call AMPacket.source(msg) % 3 == 0) {
      call Leds.led2Toggle();
      delivered3++;
      if(mote3 != ((TestMultiMsg *) payload)->myData[0]) {
        missed3++;
        call JDebug.jdbg("Mote3: MISSED %i; Received %l", delivered3, missed3, 0);
      } else {
        call JDebug.jdbg("Mote3: Received %l", delivered3, 0, 0);
      }
      mote3 = ((TestMultiMsg *) payload)->myData[0];
      mote3++;
      
    } else if(call AMPacket.source(msg) % 2 == 0) {
      call Leds.led1Toggle();
      delivered2++;
      if(mote2 != ((TestMultiMsg *) payload)->myData[0]) {
        missed2++;
        call JDebug.jdbg("Mote2: MISSED %i; Received %l", delivered2, missed2, 0);
      } else {
        call JDebug.jdbg("Mote2: Received %l", delivered2, 0, 0);
      }
      mote2 = ((TestMultiMsg *) payload)->myData[0];
      mote2++;
      
    } else {
      call Leds.led0Toggle();
      delivered1++;
      if(mote1 != ((TestMultiMsg *) payload)->myData[0]) {
        missed1++;
        call JDebug.jdbg("Mote1: MISSED %i; Received %l", delivered1, missed1, 0);
      } else {
        call JDebug.jdbg("Mote1: Received %l", delivered1, 0, 0);
      }
      mote1 = ((TestMultiMsg *) payload)->myData[0];
      mote1++;
      
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
    TestMultiMsg *multiMsg = (TestMultiMsg *) call Packet.getPayload(&fullMsg, NULL);
    memset(multiMsg->myData, count, TOSH_DATA_LENGTH);
    call LowPowerListening.setRxSleepInterval(&fullMsg, 1000);
    if(call AMSend.send(0, &fullMsg, sizeof(TestMultiMsg)) != SUCCESS) {
      post send();
    }
  }
}

