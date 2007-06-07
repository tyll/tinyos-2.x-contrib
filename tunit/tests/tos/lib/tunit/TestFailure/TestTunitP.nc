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
    interface TestCase as TestFailure;
    interface TestCase as TestLongFailMsg;
    interface TestCase as TestAssertEquals;
    interface TestCase as TestBelow;
    interface TestCase as TestAbove;
    interface TestCase as TestNull;
    interface TestCase as TestNotNull;
    interface TestCase as TestFloatError;
    interface TestCase as NoAssertion;
  }
}

implementation {

  event void TestFailure.run() {
    assertTrue("This is supposed to be a failure. And it spans multiple messages.", FALSE);
    call TestFailure.done();
  }
  
  event void TestLongFailMsg.run() {
    assertFail("12345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890");
    call TestLongFailMsg.done();
  }
  
  event void TestAssertEquals.run() {
    assertEquals("OK 10 and 11", 10, 11);
    call TestAssertEquals.done();
  }
  
  event void TestBelow.run() {
    assertResultIsBelow("OK 1", 10, 10);
    assertResultIsBelow("OK 2", 10, 50);
    call TestBelow.done();
  }
  
  event void TestAbove.run() {
    assertResultIsAbove("OK 1", 10, 10);
    assertResultIsAbove("OK 2", 50, 10);
    call TestAbove.done();
  }
  
  event void TestNull.run() {
    uint8_t i;
    i = 0; // so we don't get a warning.
    assertNull(&i);
    call TestNull.done();
  }
  
  event void TestNotNull.run() {
    assertNotNull(NULL);
    call TestNotNull.done();
  }
  
  event void TestFloatError.run() {
    float val1 = 123.4567;
    float val2 = 0.1234567;
    
    assertEquals("OK. Float error (123.4567 != 0.1234567)", val1, val2);
    call TestFloatError.done();
  }
  
  event void NoAssertion.run() {
    call NoAssertion.done();
  }
}

