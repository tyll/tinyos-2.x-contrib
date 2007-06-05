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
    interface TestCase as Test1;
    interface TestCase as Test2;
    interface TestCase as Test3;
    interface TestCase as Test4;
    interface TestCase as Test5;
    interface TestCase as Test6;
    interface TestCase as Test7;
  }
}

implementation {

  event void SetUpOneTime.run() {
    call SetUpOneTime.done();
  }
  
  
  event void Test1.run() {
    assertFail("OK 1");
    call Test1.done();
  }
  
  event void Test2.run() {
    assertFail("OK 2");
    call Test2.done();
  }
  
  event void Test3.run() {
    assertFail("OK 3");
    call Test3.done();
  }
  
  event void Test4.run() {
    assertFail("OK 4");
    call Test4.done();
  }
  
  event void Test5.run() {
    assertFail("OK 5");
    call Test5.done();
  }
    
  event void Test6.run() {
    assertFail("OK 6");
    call Test6.done();
  }
    
  event void Test7.run() {
    assertFail("OK 7");
    call Test7.done();
  }
}

