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
 
#include "TestCase.h"

/** 
 * @author David Moss
 */
 
module TestPacketLinkP {
  provides {
    interface Send as SubSend;
  }
  
  uses {
    interface Send;
    interface PacketLink;
    
    interface TestCase as TestPacketRetries;
    interface TestCase as TestPacketPointers;
    interface TestCase as TestPacketDelay;
    interface TestCase as TestCancel;
    interface Timer<TMilli>;
    interface State;
    interface Leds;
    interface State as PacketLinkState;
  }
}

implementation {

  enum {
    S_IDLE,
    S_TESTPACKETRETRIES,
    S_TESTPACKETPOINTERS,
    S_TESTPACKETDELAY,
    S_TESTCANCEL,
  };
   
  message_t myMsg[5];
  uint32_t numSends;
  bool cancelled;
  bool timerFired;
  bool sendDone;
  message_t *messageSending;
  uint8_t msgIndex;
  
  /** TRUE if the test failed for the TestPointers test case */
  bool testFailed;
  
  message_t *subsendMsg;
  uint8_t subsendLen;
  
  /***************** Prototypes ****************/
  task void sendPointerTestMsg();
  task void subsendDone();
  
  /***************** Test Events ****************/
  event void TestPacketRetries.run() {
    call State.forceState(S_TESTPACKETRETRIES);
    numSends = 0;
    call PacketLink.setRetries(&myMsg[0], 1000);
    call PacketLink.setRetryDelay(&myMsg[0], 0);
    if(call Send.send(&myMsg[0], 0) != SUCCESS) {
      assertFail("myMsg[0] couldn't be sent");
      call TestPacketRetries.done();
      call State.toIdle();
    }
  }

  event void TestPacketPointers.run() {
    call State.forceState(S_TESTPACKETPOINTERS);
    msgIndex = 0;
    testFailed = FALSE;
    post sendPointerTestMsg();
  }
  
  event void TestPacketDelay.run() {
    call State.forceState(S_TESTPACKETDELAY);
    call PacketLink.setRetries(&myMsg[0], 100);
    call PacketLink.setRetryDelay(&myMsg[0], 5);
    timerFired = FALSE;
    if(call Send.send(&myMsg[0], 10) != SUCCESS) {
      assertFail("Could not send message");
      call State.toIdle();
      call TestPacketDelay.done();
      
    } else {
      // Timer should fire before the sendDone event is signaled.
      // It's a lower bounds
      call Timer.startOneShot(450);
    }
  }
  
  event void TestCancel.run() {
    call State.forceState(S_TESTCANCEL);
    numSends = 0;
    cancelled = FALSE;
    call PacketLink.setRetries(&myMsg[4], 10);
    call PacketLink.setRetryDelay(&myMsg[4], 0);
    if(call Send.send(&myMsg[4], 10) != SUCCESS) {
      assertFail("Could not send message");
      call State.toIdle();
      call TestCancel.done();
    }
  }
  
  
  /***************** Timer Events ****************/
  event void Timer.fired() {
    timerFired = TRUE;
  }
  
  /***************** Send Events ****************/
  /**
   * Send is connected above PacketLink
   */
  event void Send.sendDone(message_t* msg, error_t error) {
    sendDone = TRUE;
    
    if(call State.getState() == S_TESTPACKETRETRIES) {
      assertTrue("SendState != IDLE", call PacketLinkState.isIdle());
      assertFalse("Too few messages", numSends < 1000);
      assertFalse("Too many messages", numSends > 1000);
      assertFalse("sendDone(ERROR)", error);
      call TestPacketRetries.done();
      
    } else if (call State.getState() == S_TESTPACKETPOINTERS) {
      assertEquals("Send returned incorrect ptr", (message_t *) &myMsg[msgIndex], msg);
      msgIndex++;
      post sendPointerTestMsg();
      
    } else if (call State.getState() == S_TESTPACKETDELAY) {
      if(timerFired) {
        // Timer fired, our packet was sent long enough.
        assertSuccess();
        
      } else {
        assertFail("SendDone occured too early");
      }
      
      call State.toIdle();
      call Timer.stop();
      call TestPacketDelay.done();
      
    } else if (call State.getState() == S_TESTCANCEL) {
      if(msg != &myMsg[4]) {
        assertFail("Send returned the incorrect ptr");
      }
      
      assertFalse("Too many packets after cancel", numSends > 3);
      call TestCancel.done();
    }
  }
 
  
  /***************** SubSend Commands ****************/
  /**
   * SubSend is connected below PacketLink - it will potentiallyy get called
   * multiple times for each call to Send.send(..) into PacketLink.
   */
  command error_t SubSend.send(message_t *msg, uint8_t len) {
    numSends++;

    if(call State.getState() == S_TESTPACKETRETRIES) {
      if(msg != &myMsg[0]) {
        assertFail("SubSend saw an incorrect pointer");
      }
      
    } else if (call State.getState() == S_TESTPACKETPOINTERS) {
      if(msg != &myMsg[msgIndex]) {
        assertFail("SubSend got incorrect pointer");
      } else if(len != 10) {
        assertFail("SubSend got incorrect length (expected 10)");
      }
      
    } else if (call State.getState() == S_TESTPACKETDELAY) {
      // Just let it signal sendDone()
      
    } else if (call State.getState() == S_TESTCANCEL) {
      if(call Send.cancel(&myMsg[4]) != SUCCESS) {
        assertFail("Could not cancel message");
      }
    }
    
    subsendMsg = msg;
    subsendLen = len;
    post subsendDone();
    
    return SUCCESS;
  }

  command error_t SubSend.cancel(message_t *msg) {
    cancelled = TRUE;
    
    if(msg != &myMsg[4]) {
      assertFail("SubSend.cancel(wrong pointer)");
    }
    
    return SUCCESS;
  }
  
  command uint8_t SubSend.maxPayloadLength() {
    return TOSH_DATA_LENGTH;
  }

  command void *SubSend.getPayload(message_t* msg, uint8_t len) {
    return msg->data;
  }
  
  /***************** Tasks ***************/
  task void sendPointerTestMsg() {
    if(msgIndex < 5) {
      call PacketLink.setRetries(&myMsg[msgIndex], 5);
      if(call Send.send((message_t *) &myMsg[msgIndex], 10) != SUCCESS) {
        assertFail("Couldn't send msg");
        call TestPacketPointers.done();
        call State.toIdle();
      }
      
    } else {
      call State.toIdle();
      call TestPacketPointers.done();
    }
  }
  
  task void subsendDone() {
    signal SubSend.sendDone(subsendMsg, SUCCESS);
  }
}

