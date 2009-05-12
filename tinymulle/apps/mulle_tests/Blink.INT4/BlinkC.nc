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

module BlinkC @safe()
{
  uses interface Timer<TMilli> as Timer0;
  uses interface Timer<TMilli> as Timer1;
  uses interface Timer<TMilli> as Timer2;
  uses interface Leds;
  uses interface Boot;
  //uses interface GpioInterrupt as GInt;
  uses interface SplitControl as MotionControl;
  uses interface MotionSensor as Motion;
  uses interface Init;
  //uses interface HplM16c62pInterrupt as Int;
  //uses interface GeneralIO as IO;
}
implementation
{
  event void Boot.booted()
  {
   
    call Init.init(); 
    call MotionControl.start();
    //call Timer0.startPeriodic( 250 );
    //call Timer1.startPeriodic( 500 );
    //call Timer2.startPeriodic( 1000 );
    //call IO.makeInput();
    //call Int.enable();
    //call GInt.enableRisingEdge();
  }

  //async event void GInt.fired() {
//    call Leds.led0Toggle();
  //}

  event void MotionControl.startDone(error_t error) {
      call Leds.led0On();  
  }
  event void MotionControl.stopDone(error_t error) {}

  async event void Motion.isMotion()
  {
    call Leds.led1On();
  }
  
  async event void Motion.noMotion()
  {
    call Leds.led1Off();
  }

  event void Timer0.fired()
  {
  }
  
  event void Timer1.fired()
  {
  }
  
  event void Timer2.fired()
  {
  }
  

  
}

