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

#include "OTime.h"
#include "Beacon.h"
#include "Timer.h"

module probeTsyncP {
  uses {
    interface Boot;
    interface AMSend;
    interface SplitControl as AMControl;
    interface Leds;
    interface Timer<TMilli>;
  }
}
implementation
{

  /* Buffers, switches, etc */
  message_t msg;      // used only for send
  bool msgFree;
  uint16_t count;     // counter on each probe msg

  event void Boot.booted() { call AMControl.start(); }

  event void AMControl.startDone(error_t e) {
    if (e == SUCCESS) {
      call Timer.startOneShot(256);
      msgFree = TRUE;
      count = 0;
      }
    }
  event void AMControl.stopDone(error_t e) { }

  task void launch() {
    beaconProbeMsg p;
    error_t r;
    if (!msgFree) return;
    p.count = count++;
    memcpy((uint8_t*)&msg.data,(uint8_t*)&p,sizeof(beaconProbeMsg));
    r = call AMSend.send(AM_BROADCAST_ADDR, &msg, sizeof(beaconProbeMsg));
    if (r == SUCCESS) { 
      msgFree = FALSE;
      }
    else call Timer.startOneShot(256);
    }

  event void AMSend.sendDone(message_t* s, error_t e) {
    if (e == SUCCESS) call Leds.led0Toggle(); 
    msgFree = TRUE;
    call Timer.startOneShot(30*1024u);
    }
 
  /**
   * Timer wakeup
   * @author herman@cs.uiowa.edu
   */
  event void Timer.fired() { post launch(); }
}
