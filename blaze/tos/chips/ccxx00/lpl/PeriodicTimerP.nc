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
 
module PeriodicTimerP {
  provides {
    interface Timer<TMilli>;
  }
  
  uses {
    interface Timer<TMilli> as SubTimer;
  }
}

implementation {
  
  bool stopped = FALSE;
  
  bool running = FALSE;
  
  bool oneShot = FALSE;
  
  uint32_t currentInterval = 0;
  
  
  /***************** Timer Commands ****************/
  command void Timer.startPeriodic(uint32_t dt) {
    oneShot = FALSE;
    running = TRUE;
    
    if((dt != currentInterval) || stopped) { 
      stopped = FALSE;
      currentInterval = dt;
      
      if(currentInterval > 0) {
        call SubTimer.startPeriodic(dt);
      
      } else {
        running = FALSE;
      }
    }
  }
  
  command void Timer.startOneShot(uint32_t dt) {
    oneShot = TRUE;
    running = TRUE;
    
    if(dt != currentInterval || stopped) {
      stopped = FALSE;
      currentInterval = dt;
      
      if(currentInterval > 0) {
        call SubTimer.startPeriodic(dt);
        
      } else {
        running = FALSE;
        oneShot = FALSE;
      }
    }
  }
  
  command void Timer.stop() {
    running = FALSE;
    oneShot = FALSE;
    stopped = TRUE;
  }
  
  command bool Timer.isRunning() {
    return running;
  }
  
  command bool Timer.isOneShot() {
    return call SubTimer.isOneShot();
  }
  
  command void Timer.startPeriodicAt(uint32_t t0, uint32_t dt) {
    running = TRUE;
    currentInterval = dt;
    call SubTimer.startPeriodicAt(t0, dt);
  }
  
  command void Timer.startOneShotAt(uint32_t t0, uint32_t dt) {
    running = TRUE;
    currentInterval = dt;
    call SubTimer.startOneShotAt(t0, dt);
  }
  
  command uint32_t Timer.getNow() {
    return call SubTimer.getNow();
  }
  
  command uint32_t Timer.gett0() {
    return call SubTimer.gett0();
  }
  
  command uint32_t Timer.getdt() {
    return call SubTimer.getdt();
  }
  
  /***************** SubTimer Events ****************/
  event void SubTimer.fired() {
    if(running) {
      if(oneShot) {
        oneShot = FALSE;
        running = FALSE;
      }
      
      signal Timer.fired();
    }
  }
}
