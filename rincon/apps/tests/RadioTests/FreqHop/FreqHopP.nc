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
 */

module FreqHopP {
  uses {
    interface Boot;
    interface SplitControl;
    interface AMSend;
    interface Receive;
    interface CC2420Config;
    interface AMPacket;
    interface Timer<TMilli>;
    interface Leds;
    interface JDebug;
  }
}

implementation {

  uint8_t chan1 = 11;

  uint8_t chan2 = 20;
  
  bool transmitter;
  
  bool onChan1 = TRUE;
  
  bool radioOn = FALSE;
  
  message_t fullMsg;
  
  /****************** Prototypes ****************/
  task void send();
  
  /****************** Boot Events ****************/
  event void Boot.booted() {
    transmitter = (call AMPacket.address() == 0);

    if(transmitter || call AMPacket.address() == 1) {
      call CC2420Config.setChannel(chan1);
      call JDebug.jdbg("on chan1", 0, 0, 0);
      
    } else {
      call CC2420Config.setChannel(chan2);
      call JDebug.jdbg("on chan2", 0, 0, 0);
    }
    
    call CC2420Config.sync();
  }
  
  /****************** SplitControl ****************/
  event void SplitControl.startDone(error_t error) {
    radioOn = TRUE;
    if(transmitter) {
      post send();
    }
  }
  
  event void SplitControl.stopDone(error_t error) {
  }
  
  /****************** CC2420Config  ****************/
  event void CC2420Config.syncDone(error_t error) {
    if(!radioOn) {
      call SplitControl.start();
    } else {
      if(transmitter) {
        post send();
        //call Timer.startOneShot(100);
      } else {
        call Leds.led2On();
      }
    }
  }
  
  /****************** AMSend ****************/
  event void AMSend.sendDone(message_t *msg, error_t error) {
    if(transmitter) {
      call Leds.led1Toggle();

      if(onChan1) {
        call CC2420Config.setChannel(chan2);
        call JDebug.jdbg("send to chan2", 0, 0, 0);
      } else {
        call CC2420Config.setChannel(chan1);
        call JDebug.jdbg("send to chan1", 0, 0, 0);
      }
      
      onChan1 = !onChan1;
      // syncDone posts send
      call CC2420Config.sync();
     
    }
  }
  
  /****************** Receive ****************/
  event message_t *Receive.receive(message_t *msg, void *payload, uint8_t len) {
    call Leds.led1Toggle();
    return msg;
  }
  
  /****************** Timer ****************/
  event void Timer.fired() {
    post send();
  }
  
  
  /****************** Tasks ****************/
  task void send() {
    
    if(call AMSend.send(AM_BROADCAST_ADDR, &fullMsg, 1) != SUCCESS) {
      call Leds.led0Toggle();
      post send();
    }
  }
}
