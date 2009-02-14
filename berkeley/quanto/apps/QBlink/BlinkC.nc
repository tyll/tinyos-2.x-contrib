// $Id$

/*									tab:4
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

module BlinkC
{
  uses interface Timer<TMilli> as Timer0;
  uses interface Timer<TMilli> as Timer1;
  uses interface Timer<TMilli> as Timer2;
  uses interface Leds;
  uses interface Boot;
  //Context stuff
  uses interface SingleContext as CPUContext;
  uses interface Notify<button_state_t> as UserButtonNotify;
  uses interface QuantoLog;
}
implementation
{
  uint8_t m_state;
  enum {
    ACT_RED = 1,
    ACT_GREEN = 2,
    ACT_BLUE = 3,
    S_NORMAL, //blinking
    S_REC,    //blinking and logging
    S_FULL,   //not blinking and flushing
    BASE_PERIOD = 1024,
  };

  void startBlinking() {
    call CPUContext.set(mk_act_local(ACT_RED));
    call Timer0.startPeriodic( BASE_PERIOD );
    call CPUContext.set(mk_act_local(ACT_GREEN));
    call Timer1.startPeriodic( BASE_PERIOD<<1 );
    call CPUContext.set(mk_act_local(ACT_BLUE));
    call Timer2.startPeriodic( BASE_PERIOD<<2 );
 
  }


  void stopBlinking() {
    call Leds.led0Off();
    call Leds.led1Off();
    call Leds.led2Off();
    call Timer0.stop();
    call Timer1.stop();
    call Timer2.stop();
  }

  
  void enterNormal() {
    m_state = S_NORMAL;
    startBlinking();
  }

  void enterRec() {
    m_state = S_REC;
    call QuantoLog.record();
  }

  void enterFull() {
    m_state = S_FULL;
    stopBlinking();
  }

  event void Boot.booted()
  {
   enterNormal();
   call UserButtonNotify.enable();
  }

  event void QuantoLog.full()
  {
    enterFull();
  }

  event void QuantoLog.flushDone() {
    enterNormal();
  }

  event void UserButtonNotify.notify(button_state_t buttonState) {
    if (buttonState == BUTTON_PRESSED) {
        if (m_state == S_NORMAL)
            enterRec();
        else if (m_state == S_FULL) {
            call QuantoLog.flush();
        }
    }
  }

  event void Timer0.fired()
  {
    dbg("BlinkC", "Timer 0 fired @ %s.\n", sim_time_string());
    call Leds.led0Toggle();
  }
  
  event void Timer1.fired()
  {
    dbg("BlinkC", "Timer 1 fired @ %s \n", sim_time_string());
    call Leds.led1Toggle();
  }
  
  event void Timer2.fired()
  {
    dbg("BlinkC", "Timer 2 fired @ %s.\n", sim_time_string());
    call Leds.led2Toggle();
  }
}

