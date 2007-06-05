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
 
#include "PowerOutlet.h"
#include "AM.h"

module PowerOutletP {
  provides {
    interface PowerOutletFeedback;
  }
  
  uses {
    interface Boot;
    interface SplitControl as RadioSplitControl;
    interface SplitControl as SerialSplitControl;
    interface Leds;
    interface Timer<TMilli> as GreenTimer;
    interface Timer<TMilli> as RedTimer;
    interface Timer<TMilli> as DelayTimer;
    interface HplMsp430GeneralIO as Green;
    interface HplMsp430GeneralIO as Red;
  }
}

implementation {

  /** The assumed current states of our lamps */
  bool greenOn;
  bool redOn;
  
  /** TRUE if we should switch the states through our momentary switches */
  bool switchGreen;
  bool switchRed;
  
  
  /***************** Prototypes ***************/
  task void switchLamps();
  
  /***************** Boot Events ***************/
  event void Boot.booted() {
    greenOn = FALSE;
    redOn = FALSE;
    switchGreen = FALSE;
    switchRed = FALSE;
    call SerialSplitControl.start();
    call RadioSplitControl.start();
  }
  
  /***************** RadioSplitControl Events ***************/
  event void RadioSplitControl.startDone(error_t error) {
  }

  event void RadioSplitControl.stopDone(error_t error) {
  }
  
  /***************** SerialSplitControl Events ***************/    
  event void SerialSplitControl.startDone(error_t error) {
  }
  
  event void SerialSplitControl.stopDone(error_t error) {
  }
  
  /***************** PowerOutletFeedback Commands ****************/
  command void PowerOutletFeedback.setPower(bool green, bool red) {
    if(green != greenOn) {
      switchGreen = TRUE;
    }
    
    if(red != redOn) {
      switchRed = TRUE;
    }
    
    post switchLamps();
  }
  
  /***************** Timer Events ****************/
  event void GreenTimer.fired() {
    call Green.clr();
    greenOn = !greenOn;
    if(greenOn) {
      call Leds.led1On();
    } else {
      call Leds.led1Off();
    }
    call DelayTimer.startOneShot(128);
  }
  
  event void DelayTimer.fired() {
    post switchLamps();
  }
  
  event void RedTimer.fired() {
    call Red.clr();
    redOn = !redOn;
    if(redOn) {
      call Leds.led0On();
    } else {
      call Leds.led0Off();
    }
    post switchLamps();
  }
  
  /***************** Functions ****************/
  task void switchLamps() {
    if(switchGreen) {
      switchGreen = FALSE;
      call Green.set();
      call GreenTimer.startOneShot(256);
      
    } else if(switchRed) {
      switchRed = FALSE;
      call Red.set();
      call RedTimer.startOneShot(256);
      
    }
  }
}

