/* Copyright (c) 2007, Tor Petterson <motor@diku.dk>
 * All rights reserved.
 *
 * Redistribution and use in source and binary forms, with or without modification,
 * are permitted provided that the following conditions are met:
 *
 *  - Redistributions of source code must retain the above copyright notice, this
 *    list of conditions and the following disclaimer.
 *  - Redistributions in binary form must reproduce the above copyright notice,
 *    this list of conditions and the following disclaimer in the documentation
 *    and/or other materials provided with the distribution.
 *  - Neither the name of the University of Copenhagen nor the names of its
 *    contributors may be used to endorse or promote products derived from this
 *    software without specific prior written permission.
 *
 * THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS" AND ANY
 * EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED WARRANTIES
 * OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE DISCLAIMED. IN NO EVENT
 * SHALL THE COPYRIGHT OWNER OR CONTRIBUTORS BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL,
 * SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT
 * OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION)
 * HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR
 * TORT (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE,
 * EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
 */

/*
  @author Tor Petterson <motor@diku.dk>
*/

#include "hardware.h"

module PlatformP{
	uses interface Init as Hcs08ClockInitInit;
	uses interface Hcs08ClockInit;
	uses interface Hcs08ClockControl as ClockControl;
	provides interface Init;
	uses interface Init as LedsInit;
}
implementation {

  command error_t Init.init() {
  	call Hcs08ClockInitInit.init();
//    configureLowLevelRegisters();  
//    TOSH_SET_PIN_DIRECTIONS(); 
    call LedsInit.init();

    return SUCCESS;
  }
  
  event void Hcs08ClockInit.initClocks()
  {
    //call ClockControl.enterFEIMode(14, 2);
    ICGTRM = *((uint8_t*)0xFFBE);
  }

  event void Hcs08ClockInit.initTimer1()
  {
    call Hcs08ClockInit.defaultInitTimer1();
  }

  event void Hcs08ClockInit.initTimer2()
  {
    call Hcs08ClockInit.defaultInitTimer2();
  }
  
  default command error_t LedsInit.init() 
  {
    return SUCCESS;
  }
  
  /** The Codewarior compiler gets very unhappy if it has to do a sizeof() on an empty tasklist
   * so we put a null task here so apps without a task will compile
   */
  task void nullTask()
  {
  }
  
}

