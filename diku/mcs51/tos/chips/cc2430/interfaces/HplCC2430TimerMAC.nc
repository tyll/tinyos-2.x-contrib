
/*
 * Copyright (c) 2007 University of Copenhagen
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
 * - Neither the name of University of Copenhagen nor the names of
 *   its contributors may be used to endorse or promote products derived
 *   from this software without specific prior written permission.
 *
 * THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS
 * ``AS IS'' AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT
 * LIMITED TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS
 * FOR A PARTICULAR PURPOSE ARE DISCLAIMED.  IN NO EVENT SHALL THE UNIVERSITY
 * OF COPENHAGEN OR ITS CONTRIBUTORS BE LIABLE FOR ANY DIRECT, INDIRECT,
 * INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES
 * (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR
 * SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION)
 * HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT,
 * STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE)
 * ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED
 * OF THE POSSIBILITY OF SUCH DAMAGE.
 */

/**
 * This interface controls the MAC timer 
 *
 * The MAC timer differs substatially from the other timers. The
 * counter register is internal. It has a 16 bit timer, but the
 * overflow count register is 20 bit wide.
 */

/**
 *
 * @author Martin Leopold <leopold@diku.dk>
 */

#include <CC2430Timer.h>

interface HplCC2430TimerMAC {

  /** 
   * Set the timer mode
   */
  async command void setMode( enum cc2430_timerMAC_mode_t mode );

  /** 
   * Get the timer mode
   * @return timer mode
   */
  async command enum cc2430_timerMAC_mode_t getMode();

  /** 
   * Get the current adjustment (delta) counter
   * @return current delta
   */
  async command uint16_t getAdjust();

  /** 
   * Set the current adjustment (delta) counter
   * @param d   the time to set
   */
  async command void setAdjust ( uint16_t d );

  /** 
   * Get the current 20 bit overflow count
   * @return Current overflow count (only 20 valid bits)
   */
  async command uint32_t getOverflow();

  /** 
   * Set the current 20 bit overflow count
   * @param o Set the current overflow count (bits above 20 will be ignored)
   */
  async command void setOverflow ( uint32_t o );

  /* 
   *
   */
  async command void setSyncStop();
  async command void clrSyncStop();

  /* 
   * Enable or disable events of this timer:
   *   Cmp       Compare interrupt
   *   Overflow  Overflow interrupt
   *   OvfCmp    Overflow count compare interrupt
   */
  async command void enableCmpEvents();
  async command void disableCcmEvents();

  async command void enableOverflowEvent();
  async command void disableOverflowEvent();

  async command void enableOvfCmpEvent();
  async command void disableOvfCmpEvent();


  /*
   * Check/clear the interrupt status flag corresponding to the mask
   * from the enum cc2430_timer1_if
   *
   * @param if_mask Mask to check/clear bit in T1CTL
   */

  async command bool isIfPending(enum cc2430_timerMAC_if_t if_mask);
  async command void clearIf(enum cc2430_timerMAC_if_t if_mask);

  /** 
   * The timer has fired - the reasen must be checked separately
   *
   */
  async event void fired();

}
