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
    interface TestCase as TestThroughput;
    interface TestControl as TearDownOneTime;
    interface SplitControl;
    interface AMSend;
    interface Receive;
    interface Leds;
    interface PacketAcknowledgements;
    interface Statistics;
    interface Timer<TMilli>;
    interface State as RunState;
    interface RadioBackoff;
  }
}

implementation {

  /** Message to send */
  message_t myMsg;
  
  /** Number of messages sent */
  uint32_t sent;
  
  /** Notify an ack failure only one time */
  bool ackFailureSent;
  
  /**
   * Minimum number of packets we should be seeing per second
   */
  enum {
    LOWER_BOUNDS = 21950,  // 365+ packets per second
    TEST_DURATION = 61440,  // 1 minute
  };
  
  enum {
    S_IDLE,
    S_RUNNING,
  };
  
  /***************** Prototypes ****************/
  task void sendMsg();
  
  
  /***************** SetUpOneTime Events ****************/
  event void SetUpOneTime.run() {
    call SplitControl.start();
    call PacketAcknowledgements.noAck(&myMsg);
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
  
  /***************** RadioBackoff Events ****************/
  async event void RadioBackoff.requestInitialBackoff(message_t *msg) {
  }
  
  async event void RadioBackoff.requestCongestionBackoff(message_t *msg) {
  }
    
  async event void RadioBackoff.requestCca(message_t *msg) {
    call RadioBackoff.setCca(FALSE);
  }
  
  
  /***************** TestThroughput Events ****************/
  event void TestThroughput.run() {
    sent = 0;
    call RunState.forceState(S_RUNNING);
    call Timer.startOneShot(TEST_DURATION);
    post sendMsg();
  }
  
  /***************** Timer Events ****************/
  event void Timer.fired() {
    call RunState.toIdle();
    call Statistics.log("[packets/sec]", (uint32_t) ((float) sent / (float) 60));
    assertResultIsAbove("Throughput is too low", LOWER_BOUNDS, sent);
    call TestThroughput.done(); 
  }
  
  /***************** AMSend Events ****************/
  event void AMSend.sendDone(message_t *msg, error_t error) {
    sent++;
    if(call PacketAcknowledgements.wasAcked(msg) && !ackFailureSent) {
      ackFailureSent = TRUE;
      assertFail("Msg was ack'd but shouldn't have been.");
    }
    
    if(!call RunState.isIdle()) {
      post sendMsg();
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

