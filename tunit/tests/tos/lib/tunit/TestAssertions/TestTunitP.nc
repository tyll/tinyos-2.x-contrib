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
    interface TestCase as TestAssertEquals;
    interface TestCase as TestBelow;
    interface TestCase as TestAbove;
    interface TestCase as TestAssertCompares;
    interface TestCase as TestAssertTrue;
    interface TestCase as TestAssertFalse;
    interface TestCase as TestAssertNull;
    interface TestCase as TestAssertNotNull;
    interface TestCase as TestAssertSuccess;
  }
}

implementation {

  event void TestAssertEquals.run() {

    assertEquals("uint8_t", (uint8_t) 0xFF, (uint8_t) 0xFF);
    assertEquals("uint16_t", (uint16_t) 0xFFFF, (uint16_t) 0xFFFF);
    assertEquals("uint32_t", (uint32_t) 0xFFFFFFFF, (uint32_t) 0xFFFFFFFF);
    assertEquals("int8_t", (int8_t) -1, (int8_t) -1);
    assertEquals("int16_t", (int16_t) -1, (int16_t) -1);
    assertEquals("int32_t", (int32_t) -1, (int32_t) -1);
    assertEquals("float", (float) 1.001, (float) 1.001);
   
    call TestAssertEquals.done();
  }
  
  event void TestBelow.run() {
    assertResultIsBelow("Below failed", 32, 31);
    call TestBelow.done();
  }
  
  event void TestAbove.run() {
    assertResultIsAbove("Above failed", 31, 32);
    call TestAbove.done();
  }
  
  event void TestAssertCompares.run() {
    uint8_t array1[] = {0, 1, 2, 3, 4, 5};
    uint8_t array2[] = {0, 1, 2, 3, 4, 5};

    assertCompares("Compares", &array1, &array2, sizeof(array1));
    
    call TestAssertCompares.done();
  }
  
  event void TestAssertTrue.run() {
    assertTrue("False", TRUE);
    call TestAssertTrue.done();
  }
  
  event void TestAssertFalse.run() {
    assertFalse("True", FALSE);
    call TestAssertFalse.done();
  }
  
  event void TestAssertNull.run() {
    assertNull(NULL);
    call TestAssertNull.done();
  }
  
  event void TestAssertNotNull.run() {
    uint8_t array1[] = {0, 1, 2, 3, 4, 5};
    assertNotNull(&array1);
    call TestAssertNotNull.done();
  }
  
  event void TestAssertSuccess.run() {
    assertSuccess();
    call TestAssertSuccess.done();
  }
}

