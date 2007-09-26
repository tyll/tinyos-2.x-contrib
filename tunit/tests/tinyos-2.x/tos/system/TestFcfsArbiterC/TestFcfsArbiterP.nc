/*
 * Copyright (c) 2004, Technische Universitat Berlin
 * All rights reserved.
 *
 * Redistribution and use in source and binary forms, with or without
 * modification, are permitted provided that the following conditions
 * are met:
 * - Redistributions of source code must retain the above copyright notice,
 *   this list of conditions and the following disclaimer.
 * - Redistributions in binary form must reproduce the above copyright
 *   notice, this list of conditions and the following disclaimer in the
 *   documentation and/or other materials provided with the distribution.
 * - Neither the name of the Technische Universitat Berlin nor the names
 *   of its contributors may be used to endorse or promote products derived
 *   from this software without specific prior written permission.
 *
 * THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS
 * "AS IS" AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT
 * LIMITED TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR
 * A PARTICULAR PURPOSE ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT
 * OWNER OR CONTRIBUTORS BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL,
 * SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED
 * TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA,
 * OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY
 * OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT
 * (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE
 * USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
*/

/**
 *
 * @author Kevin Klues <klues@tkn.tu-berlin.de>
 * @version  $Revision$
 * @date $Date$
 */

#include "TestCase.h"

module TestFcfsArbiterP {
  uses {
    interface Resource as Resource0;
    interface Resource as Resource1;
    interface Resource as Resource2;

    interface TestCase as TestFcfsOrder; 
  }
}
implementation {

  uint8_t resource;

  //All resources try to gain access
  event void TestFcfsOrder.run() {
    resource = 0;
    call Resource0.request();
    call Resource2.request();
    call Resource1.request();
  }
  
  //If granted the resource, turn on an LED  
  event void Resource0.granted() {
    assertEquals("Resource Granted Out of Order: 0", resource, 0);
    resource = 2;
    call Resource0.release();
  }  
  event void Resource1.granted() {
    assertEquals("Resource Granted Out of Order: 1", resource, 1);
    call Resource1.release();
    call TestFcfsOrder.done();
  }  
  event void Resource2.granted() {
    assertEquals("Resource Granted Out of Order: 2", resource, 2);
    resource = 1;
    call Resource2.release();
  }  
}
