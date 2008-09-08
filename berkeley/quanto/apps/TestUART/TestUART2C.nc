// $Id$

/*                  tab:4
 * "Copyright (c) 2000-2005 The Regents of the University  of California.  
 * All rights reserved.
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
 * Copyright (c) 2002-2003 Intel Corporation
 * All rights reserved.
 *
 * This file is distributed under the terms in the attached INTEL-LICENSE     
 * file. If you do not find these files, copies can be found by writing to
 * Intel Research Berkeley, 2150 Shattuck Avenue, Suite 1300, Berkeley, CA, 
 * 94704.  Attention:  Intel License Inquiry.
 */

/**
 * Implementation for Blink application.  Toggle the red LED when a
 * Timer fires.
 **/

#include "Timer.h"
#include <UserButton.h>

/* When the button is pressed, 3 UART packes are sent one right
 * after the other.
 * After this the quanto event log is flushed.
 */ 
module TestUART2C
{
  uses interface Timer<TMilli> as Timer;
  uses interface Leds;
  uses interface Boot;
  //Context stuff
  uses interface SingleContext as CPUContext;
  uses interface Notify<button_state_t> as UserButtonNotify;
  uses interface QuantoLog;
  uses interface AMSend as UARTSend;
}

implementation
{
  int count;
  int total;
  uint8_t len[3] = {8,16,28};

  message_t uart_msg;
  uint8_t *payload;
     
  enum { 
   ACT_TYPE_APP = 1,
  };

  task void send();

  void start() {
    count = 0;
    call QuantoLog.record();
    call CPUContext.set(mk_act_local(ACT_TYPE_QUANTO));
    post send();
  }

  event void Boot.booted()
  {
    total = 3;    
    payload = call UARTSend.getPayload(&uart_msg, call UARTSend.maxPayloadLength());
    memset(payload, 0xca , call UARTSend.maxPayloadLength());
    call UserButtonNotify.enable();
  }


  event void UserButtonNotify.notify(button_state_t buttonState) {
    if (buttonState == BUTTON_PRESSED) {
        start();
    }
  }

  event void QuantoLog.full()
  {
     call QuantoLog.flush();
  }

  task void send() 
  {
      //act_t current = call CPUContext.get();
      //call CPUContext.set(ACT_TYPE_QUANTO);
      call UARTSend.send(AM_BROADCAST_ADDR, &uart_msg, len[count]);
      //call CPUContext.set(current);
  }
  event void UARTSend.sendDone(message_t *msg, error_t error) {
    if (error != SUCCESS) {
      call Leds.led0Toggle();
    } else {
      count++;
      if (count < total) {
          post send();
      } else {
          call QuantoLog.flush();
      }
    }
  }
  
  event void Timer.fired() {};

}

