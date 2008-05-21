
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


generic module Hcs08TimerP(
  uint16_t TPMxSC_addr,
  uint16_t TPMxCNT_addr,
  uint16_t TPMxMOD_addr )
{
  provides interface Hcs08Timer as Timer;
  uses interface Hcs08TimerEvent as Overflow;
}
implementation
{
  #define TPMxSC (*(volatile uint8_t*)TPMxSC_addr)
  #define TPMxCNT (*(volatile uint16_t*)TPMxCNT_addr)
  #define TPMxMOD (*(volatile uint16_t*)TPMxMOD_addr)

  async command uint16_t Timer.get()
  {
	return TPMxCNT;
  }

  async command bool Timer.isOverflowPending()
  {
    return (TPMxSC & HSC08TIMER_TOF) >> 7;
  }

  async command void Timer.clearOverflow()
  {
    TPMxSC &= ~HSC08TIMER_TOF;
  }

  async command void Timer.clear()
  {
    TPMxCNT = 0;
  }

  async command void Timer.enableEvents()
  {
    TPMxSC |= HSC08TIMER_TOIE;
  }

  async command void Timer.disableEvents()
  {
    TPMxSC &= ~HSC08TIMER_TOIE;
  }

  async command void Timer.setClockSource( uint8_t clockSource )
  {
  	TPMxSC = (TPMxSC & ~(HSC08TIMER_CLKSA|HSC08TIMER_CLKSB)) | ((clockSource << 3) & (HSC08TIMER_CLKSA|HSC08TIMER_CLKSB));
  }

  async command void Timer.setInputDivider( uint8_t inputDivider )
  {
    TPMxSC = (TPMxSC & ~(HSC08TIMER_PS2|HSC08TIMER_PS1|HSC08TIMER_PS0)) | ((inputDivider) & (HSC08TIMER_PS2|HSC08TIMER_PS1|HSC08TIMER_PS0));
  }

  async event void Overflow.fired()
  {
  	uint8_t t;
  	TPMxSC &= ~HSC08TIMER_TOF;
    signal Timer.overflow();
  }

  default async event void Timer.overflow()
  {
  }
  
}

