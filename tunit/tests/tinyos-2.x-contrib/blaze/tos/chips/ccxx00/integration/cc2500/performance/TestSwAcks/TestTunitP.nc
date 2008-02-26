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

#include "TestCase.h"

module TestTunitP {
  uses {
    interface TestControl as SetUpOneTime;
    interface TestCase as TestRf;
    interface TestControl as TearDownOneTime;
    interface SplitControl;
    interface AMSend;
    interface Receive;
    interface Leds;
    interface PacketAcknowledgements;
    interface Statistics;
  }
}

implementation {

  /** Message to send */
  message_t myMsg;
  
  /** Number of messages sent */
  uint32_t sent;
  
  /** Number of acks missed out of the number of messages sent */
  uint32_t acksReceived;
  
  
  enum {
    TOTAL_PACKETS = 10000,
    LOWER_BOUNDS = 9900, 
  };
  
  
  /***************** Prototypes ****************/
  task void sendMsg();
  
  
  /***************** SetUpOneTime Events ****************/
  event void SetUpOneTime.run() {
    call SplitControl.start();
    call PacketAcknowledgements.requestAck(&myMsg);
  }
  
  /***************** TearDownOneTime Events ****************/
  event void TearDownOneTime.run() {
    call SplitControl.stop();
  }
  
  /***************** SplitControl Events ****************/
  event void SplitControl.startDone(error_t error) {
    call SetUpOneTime.done();
  }
  
  event void SplitControl.stopDone(error_t error) {
    call TearDownOneTime.done();
  }
  
  /***************** TestRf Events ****************/
  event void TestRf.run() {
    sent = 0;
    acksReceived = 0;
    post sendMsg();
  }
  
  /***************** AMSend Events ****************/
  event void AMSend.sendDone(message_t *msg, error_t error) {
    sent++;
    if(call PacketAcknowledgements.wasAcked(msg)) {
      acksReceived++;
      call Leds.led2Off();
    } else {
      call Leds.led2On();
    }
    
    if(sent < TOTAL_PACKETS) {
      post sendMsg();
      
    } else {
      assertResultIsAbove("Missed too many acks", LOWER_BOUNDS, acksReceived);
      call Statistics.log("[# acks/10000 msgs]", acksReceived);
      call TestRf.done();
    }
  }
  
  event message_t *Receive.receive(message_t *msg, void *payload, error_t error) {
    call Leds.led1Toggle();
    return msg;
  }
  
  
  /***************** Tasks *****************/
  task void sendMsg() {
    call Leds.led0Toggle();
    if(call AMSend.send(1, &myMsg, 0) != SUCCESS) {
      post sendMsg();
    }
  }
}

