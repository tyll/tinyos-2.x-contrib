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

/**
 * This program tests that the system boots and the scheduler is running
 * 
 * @author Tor Petterson <motor@diku.dk>
*/

module Null2SerTaskC
{
  uses interface Boot;
}
implementation
{
  task void nullTask2();
    
  // Serial line debug functions
  void initSer()
  {
    SCI2BD = 8000000/(16*38400);
    SCI2C2 = 0xC;
  }

  void putSer(uint8_t data)
  {
    // Wait for Transmit Data Register to be empty.
    while(!SCI2S1_TDRE);
    SCI2D = data;
    // Wait for Transmission Complete.
    while(!SCI2S1_TC);
  }

  task void nullTask1()
  {
  	putSer('1');
  	post nullTask2();
  }
  
  task void nullTask2()
  {
  	putSer('2');
  	post nullTask1();
  }

  event void Boot.booted() {
    initSer();
    putSer('B');
    post nullTask1();
  }
}

