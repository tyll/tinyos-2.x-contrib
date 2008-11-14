/*
 * "Copyright (c) 2008 The Regents of the University  of California.
 * All rights reserved."
 *
 * Permission to use, copy, modify, and distribute this software and its
 * documentation for any purpose, without fee, and without written agreement is
 * hereby granted, provided that the above copyright notice, the following
 * two paragraphs and the author appear in all copies of this software.
 *
 * IN NO EVENT SHALL THE UNIVERSITY OF CALIFORNIA BE LIABLE TO ANY PARTY FOR
 * DIRECT, INDIRECT, SPECIAL, INCIDENTAL, OR CONSEQUENTIAL DAMAGES ARISING OUT
 * OF THE USE OF THIS SOFTWARE AND ITS DOCUMENTATION, EVEN IF THE UNIVERSITY OF
 * CALIFORNIA HAS BEEN ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
 *
 * THE UNIVERSITY OF CALIFORNIA SPECIFICALLY DISCLAIMS ANY WARRANTIES,
 * INCLUDING, BUT NOT LIMITED TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY
 * AND FITNESS FOR A PARTICULAR PURPOSE.  THE SOFTWARE PROVIDED HEREUNDER IS
 * ON AN "AS IS" BASIS, AND THE UNIVERSITY OF CALIFORNIA HAS NO OBLIGATION TO
 * PROVIDE MAINTENANCE, SUPPORT, UPDATES, ENHANCEMENTS, OR MODIFICATIONS."
 *
 */

#include "CC2420.h"
module TestIEEE154P {
  uses {
    interface Boot;
    interface SplitControl as RadioControl;
    interface IEEE154Send as Send;
    // interface AMSend as Send;
    interface Receive;
    interface Timer<TMilli>;
    interface Leds;
  }
} implementation {

  message_t M;
  uint16_t counter = 0;
  uint16_t failures;

enum {
  CC2420_SIZE = MAC_HEADER_SIZE + MAC_FOOTER_SIZE,
};

  event void Boot.booted() {
    call RadioControl.start();
    failures = 0;
  }

  event void RadioControl.startDone(error_t e) {
    call Timer.startPeriodic(256);
  }

  event void RadioControl.stopDone(error_t e) {

  }

  event message_t *Receive.receive(message_t *msg, void *payload, uint8_t len) {
    call Leds.led1Toggle();
    return msg;
  }

  event void Send.sendDone(message_t *msg, error_t e) {
    if (e != SUCCESS) {
      call Leds.led2Toggle();
      failures++;
    }

  }

  event void Timer.fired() {
    uint16_t *payload = (uint16_t *)call Send.getPayload(&M , 4);

    *payload = 0xffff - counter++;

    payload++;
    call Leds.led2Toggle();
    *payload = counter;
    if (call Send.send(AM_BROADCAST_ADDR, &M, 4) != SUCCESS) {
      call Leds.led0Toggle();
      failures++;
    } 
  }
}
