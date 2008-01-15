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

module TestStateP {
  uses {
    interface State;
    
    interface TestControl as SetUp;
    
    interface TestCase as TestForce;
    interface TestCase as TestRequest;
    interface TestCase as TestToIdle;
  }
}

implementation {

  /**
   * Possible states
   */
  enum {
    S_IDLE,
    S_STATE1,
    S_STATE2,
    S_STATE3,
  };
  
  /***************** Prototypes ****************/
  
  /***************** SetUpOneTime Events ***************/
  event void SetUp.run() {
    call State.toIdle();
    call SetUp.done();
  }

  /***************** Tests ****************/
  event void TestForce.run() {
    call State.forceState(S_STATE1);
    assertTrue("TestForce: S_STATE1 not forced correctly", call State.getState() == S_STATE1);
    call State.forceState(S_STATE2);
    assertEquals("TestForce: S_STATE2 not forced correctly", call State.getState(), S_STATE2);
    assertTrue("TestForce: 1. isState() failed", call State.isState(S_STATE2));
    
    call State.forceState(S_IDLE);
    assertFalse("TestForce: State was supposed to be idle", call State.getState() == S_STATE3);
    assertFalse("TestForce: 2. isState() failed", call State.isState(S_STATE2));
    
    call TestForce.done();
  }
  
  event void TestRequest.run() {
    call State.toIdle();
    call State.requestState(S_STATE1);
    assertTrue("TestReq: S_STATE1 not requested correctly", call State.getState() == S_STATE1);
    call State.requestState(S_STATE2);
    assertFalse("TestReq: S_STATE2 requested incorrectly", call State.getState() == S_STATE2);
    call State.requestState(S_IDLE);
    assertTrue("TestReq: S_IDLE not requested correctly", call State.isIdle());
    
    call TestRequest.done();
  }
  
  
  event void TestToIdle.run() {
    call State.forceState(S_STATE3);
    assertTrue("TestToIdle: S_STATE3 not forced correctly", call State.getState() == S_STATE3);
    call State.toIdle();
    assertTrue("TestToIdle: toIdle() didn't work", call State.getState() == S_IDLE);
    assertTrue("TestToIdle: toIdle()/isIdle() didn't work", call State.isIdle());
    
    call TestToIdle.done();
  }
  
}

