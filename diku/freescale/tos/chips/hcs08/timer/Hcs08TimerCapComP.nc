
/* "Copyright (c) 2000-2003 The Regents of the University of California.
 * All rights reserved.
 *
 * Permission to use, copy, modify, and distribute this software and its
 * documentation for any purpose, without fee, and without written agreement
 * is hereby granted, provided that the above copyright notice, the following
 * two paragraphs and the author appear in all copies of this software.
 *
 * IN NO EVENT SHALL THE UNIVERSITY OF CALIFORNIA BE LIABLE TO ANY PARTY FOR
 * DIRECT, INDIRECT, SPECIAL, INCIDENTAL, OR CONSEQUENTIAL DAMAGES ARISING OUT
 * OF THE USE OF THIS SOFTWARE AND ITS DOCUMENTATION, EVEN IF THE UNIVERSITY
 * OF CALIFORNIA HAS BEEN ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
 *
 * THE UNIVERSITY OF CALIFORNIA SPECIFICALLY DISCLAIMS ANY WARRANTIES,
 * INCLUDING, BUT NOT LIMITED TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY
 * AND FITNESS FOR A PARTICULAR PURPOSE.  THE SOFTWARE PROVIDED HEREUNDER IS
 * ON AN "AS IS" BASIS, AND THE UNIVERSITY OF CALIFORNIA HAS NO OBLIGATION TO
 * PROVIDE MAINTENANCE, SUPPORT, UPDATES, ENHANCEMENTS, OR MODIFICATIONS."
 */

/**
 * @author Cory Sharp <cssharp@eecs.berkeley.edu>
 * @author Tor Petterson <motor@diku.dk>
 */

#include "Hcs08Timer.h"

generic module Hcs08TimerCapComP(
    uint16_t TPMxCnSC_addr,
    uint16_t TPMxCnVL_addr
  )
{
  provides interface Hcs08TimerControl as Control;
  provides interface Hcs08Compare as Compare;
  uses interface Hcs08Timer as Timer;
  uses interface Hcs08TimerEvent as Event;
  uses interface McuPowerState;
}
implementation
{
  #define TPMxCnSC (*(volatile uint8_t*)TPMxCnSC_addr)
  #define TPMxCnVL (*(volatile uint8_t*)TPMxCnVL_addr)

  async command void Control.setMode(uint8_t mode)
  {
  	 TPMxCnSC = (TPMxCnSC & ~(HSC08TIMER_MSnB|HSC08TIMER_MSnA)) | 
  	 			 ((mode << 4) &   (HSC08TIMER_MSnB|HSC08TIMER_MSnA));
  }
  
  async command uint8_t Control.getMode()
  {
  	return (TPMxCnSC & (HSC08TIMER_MSnB|HSC08TIMER_MSnA)) >> 4;
  }
    
  async command void Control.setPin(uint8_t pin)
  {
  	TPMxCnSC = (TPMxCnSC & ~(HSC08TIMER_ELSnB|HSC08TIMER_ELSnA)) | 
  				((pin << 2) &   (HSC08TIMER_ELSnB|HSC08TIMER_ELSnA));
  }
    
  async command uint8_t Control.getPin()
  {
  	return (TPMxCnSC & (HSC08TIMER_ELSnB|HSC08TIMER_ELSnA)) >> 2;
  }
  
  async command bool Control.isInterruptPending()
  {
    return (TPMxCnSC & HSC08TIMER_CHnF) >> 7;
  }

  async command void Control.clearPendingInterrupt()
  {
    TPMxCnSC &= ~HSC08TIMER_CHnF;
  }

  async command void Control.enableEvents()
  {
    TPMxCnSC |= HSC08TIMER_CHnIE;
    call McuPowerState.update();
  }

  async command void Control.disableEvents()
  {
    TPMxCnSC &= ~HSC08TIMER_CHnIE;
    call McuPowerState.update();
  }

  async command bool Control.areEventsEnabled()
  {
    return (TPMxCnSC & HSC08TIMER_CHnIE) >> 6;
  }

  async command uint16_t Compare.getEvent()
  {
    return TPMxCnVL;
  }

  async command void Compare.setEvent( uint16_t x )
  {
    TPMxCnVL = x;
  }

  async command void Compare.setEventFromPrev( uint16_t x )
  {
    TPMxCnVL += x;
  }

  async command void Compare.setEventFromNow( uint16_t x )
  {
    TPMxCnVL = call Timer.get() + x;
  }

  async event void Event.fired()
  {
  	TPMxCnSC &= ~HSC08TIMER_CHnF;
    if( (call Control.getMode()) == HSC08TIMER_M_COM )
      signal Compare.fired();
  }

  default async event void Compare.fired()
  {
  }

  async event void Timer.overflow()
  {
  }
}

