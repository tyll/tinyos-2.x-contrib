#include <UserButton.h>

/**
 * Copyright (c) 2007 Arch Rock Corporation
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
 * - Neither the name of the Arch Rock Corporation nor the names of
 *   its contributors may be used to endorse or promote products derived
 *   from this software without specific prior written permission.
 *
 * THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS
 * ``AS IS'' AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT
 * LIMITED TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS
 * FOR A PARTICULAR PURPOSE ARE DISCLAIMED.  IN NO EVENT SHALL THE
 * ARCHED ROCK OR ITS CONTRIBUTORS BE LIABLE FOR ANY DIRECT, INDIRECT,
 * INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES
 * (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR
 * SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION)
 * HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT,
 * STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE)
 * ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED
 * OF THE POSSIBILITY OF SUCH DAMAGE
 */

/**
 * Count - Second TinyOS application building on Push
 *
 * Behavior: Pressing the user button rotates a counter among 0,1,2 and 3
 *           (initially 0). 
 *
 *           When the counter is 0, no timer is fired.
 *           When the counter is 1, Timer0 (period 1s) is fired.
 *           When the counter is 2, Timer0 and Timer1 (period 2s) are fired.
 *           When the counter is 3, Timer0, Timer1, Timer2 (period 4s) are fired.
 *
 *           When Timer0 is fired, led0 (led LED) is toggled.
 *           When Timer1 is fired, led1 (green LED) is toggled.
 *           When Timer2 is fired, led2 (blue LED) is toggled.
 *
 * Concepts Illustrated:
 * 
 *   Timer - a critical subsystem - TEP102
 *           Virtual resource provided as a parameterized interface.
 * 
 * @author David Culler <dculler@archrock.com>
 * @author Jaein Jeong  <jaein@eecs.berkeley.edu>
 * @version $Revision$ 
 *
 */

module CountC {      // Definition in external interfaces
  uses {
    interface Boot;
    interface Notify<button_state_t>;
    interface Leds;

    interface Timer<TMilli> as Timer0;
    interface Timer<TMilli> as Timer1;
    interface Timer<TMilli> as Timer2;
  }
}
implementation {
  bool isTimerRunning = FALSE;
  uint8_t counter = 0;

  void rotate_timer() {

    counter = (counter + 1) & 0x03;
    call Leds.set(0);

    if (counter == 0) {    
      call Timer0.stop();
      call Timer1.stop();
      call Timer2.stop();
    }
    else if (counter == 1) {
      call Timer0.startPeriodic(1000);
      call Timer1.stop();
      call Timer2.stop();
    }
    else if (counter == 2) {
      call Timer0.startPeriodic(1000);
      call Timer1.startPeriodic(2000);
      call Timer2.stop(); 
    }
    else if (counter == 3) {
      call Timer0.startPeriodic(1000);
      call Timer1.startPeriodic(2000);
      call Timer2.startPeriodic(4000);
    } 
  }


  event void Boot.booted() {
    call Notify.enable();   // enable input subsystem upon boot
  }
 
  // state can be either BUTTON_PRESSED or BUTTON_RELEASED
  event void Notify.notify( button_state_t state ) {
    if (state == BUTTON_PRESSED) {
      rotate_timer();
    }
  }

  event void Timer0.fired() {
    call Leds.led0Toggle();
  }

  event void Timer1.fired() {
    call Leds.led1Toggle();
  }

  event void Timer2.fired() {
    call Leds.led2Toggle();
  }

}

