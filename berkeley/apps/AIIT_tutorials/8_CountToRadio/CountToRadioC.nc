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
 * CountToRadio - A TinyOS application that shows the concept of sending 
 *          a radio message.            
 * 
 * Behavior: 'CountToRadio' program starts a timer at an interval of 1s.
 *           Each time the timer is triggered, this program sends 
 *           a radio message that contains its node ID and counter 
 *           variable. The counter variable is incremented each time 
 *           the timer is triggered. LED is set to last 3-bits of the
 *           counter value.
 *
 *           The goal of this lesson is to write a receiver program
 *           'RadioToCount' program that receives the counter message
 *           and sets its LED as last 3-bits of the receiverd counter
 *           value.
 *
 * Concepts Illustrated:
 * 
 *   Mote-mote communication - TEP111, TEP116
 *                             Tinyos 2.0 tutorial lesson 3
 *
 * @author David Culler <dculler@archrock.com>
 * @author Jaein Jeong  <jaein@eecs.berkeley.edu>
 * @version $Revision$ 
 *
 */

#include <UserButton.h>
#include "Timer.h"
#include "Counter.h"

module CountToRadioC {
  uses {
    interface SplitControl as Control;
    interface Leds;
    interface Boot;
    interface AMSend;
    interface Timer<TMilli> as MilliTimer;
    interface Packet;
    interface Notify<button_state_t>;
  }
}
implementation {

  message_t packet;

  bool locked = FALSE;

  uint16_t counter = 0;

  event void Boot.booted() {
    call Control.start();
    call Notify.enable();
    call MilliTimer.startPeriodic(1024);
  }

  void send_counter() {
    if (locked) {
      return;
    }
    else {
      counter_msg_t* rcm = 
        (counter_msg_t*) call Packet.getPayload(&packet, NULL);

      rcm->nodeid = TOS_NODE_ID;
      rcm->counter = counter;

      if (call AMSend.send(AM_BROADCAST_ADDR, &packet, 
          sizeof(counter_msg_t)) == SUCCESS) {
	      locked = TRUE;
      }
    }
  }

  event void AMSend.sendDone(message_t* bufPtr, error_t error) {
    if (&packet == bufPtr) {
      locked = FALSE;
    }
  }

  event void MilliTimer.fired() {
    counter++;
    call Leds.set(counter & 0x07);
    send_counter(); 
  }

  // state can be either BUTTON_PRESSED or BUTTON_RELEASED
  event void Notify.notify( button_state_t state ) {
    if (state == BUTTON_PRESSED) {
    }
  }

  event void Control.startDone(error_t err) { }
  event void Control.stopDone(error_t err)  { }
  

}




