/*
* Copyright (c) 2007 University of Iowa 
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
* - Neither the name of The University of Iowa  nor the names of
*   its contributors may be used to endorse or promote products derived
*   from this software without specific prior written permission.
*
* THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS
* ``AS IS'' AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT
* LIMITED TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS
* FOR A PARTICULAR PURPOSE ARE DISCLAIMED.  IN NO EVENT SHALL STANFORD
* UNIVERSITY OR ITS CONTRIBUTORS BE LIABLE FOR ANY DIRECT, INDIRECT,
* INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES
* (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR
* SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION)
* HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT,
* STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE)
* ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED
* OF THE POSSIBILITY OF SUCH DAMAGE.
*/

/**
 * Timesync suite of interfaces, components, testing tools, and documents.
 * @author Ted Herman
 * Development supported in part by NSF award 0519907. 
 */
//--EOCpr712 (do not remove this line, which terminates copyright include)

//:mode=c:

#include "PowCon.h"
/**
 * Interface for power control 
 */
interface PowCon {
  /**
   *   Client command:  request new schedule to be calculated
   *   -- also used to resume power conservation
   */
  command void restart();

  /**
   *   PowCon event:  signal each client to solicit a wake/sleep 
   *   schedule, which the client does by filling in the provided
   *   powsched structure.  Supply can be signalled many times
   *   as a result of restarts, schedule computation, etc.   
   */
  event void supply(powschedPtr p);

  /**
   *   Wake event:  signal client that waking interval starts
   */
  event void wake();

  /**
   *   Idle event:  signal client that power is off
   */
  event void idle();

  /**
   *   Client command:  tell PowCon to suspend conservation, 
   *   leaving power on until further notice
   */
  command void forceOn();  

  /**
   *   Client command:  tell PowCon to resume conservation. 
   */
  command void allowOff();  
  
  /**
   *   Client command:  get random delay amount to delay 
   *   before message send (to decrease contention on MAC) 
   */
  command uint8_t randelay();

  /**
   *   Client command:  get maximum period of all clients
   */
  command uint16_t maxPeriod();
}
