
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
 * This interface controls the watch dog timer (WDT)
 *
 */

/**
 *
 * @author Martin Leopold <leopold@diku.dk>
 */

#include <CC2430Timer.h>

interface HplCC2430TimerWDT {

  /* 
   * Enable the WDT, once enabled it cannot be disabled
   */
  async command void enable();

  /** 
   * Set the timer mode. Once the timer is enabled in WDT mode the
   * timer cannot be disabled or swithed to timer mde.
   *
   * @param mode
   */
  async command void setMode( enum cc2430_timerWDT_mode_t mode );

  /** 
   * Enable/disable timer
   *
   */
  async command void enable();
  async command void disable();
  
  /*
   * Enable/disable interrupts (only in timer mode)
   */
  async command void enableEvents();
  async command void disableEvents();

  /** 
   * Clear WDT interval (in WDT mode) or clear counter (in timer mode)
   * This could technically be one instruction shorter in timer mode,
   * buy hey - thie is simpler.
   *
   */
  async command void clear();

  /** 
   * Set the the interval between clear sequence requirements
   * @param i 
   */
  async command void setInterval( enum cc2430_timerMAC_interval_t i );
  async command enum cc2430_timerMAC_interval_t getInterval();

  /** 
   * The timer interval expired. NOTE: in WDT mode no interrupt is
   * generated.
   * 
   */
  async event void fired();

}
