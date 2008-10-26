
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
 *
 * @author Martin Leopold <leopold@diku.dk>
 */
/**
 * This interface controls the 16 bit timer 1
 */

#include <CC2430Timer.h>

interface HplCC2430Timer16 {

  /** 
   * Get the current time.
   * @return  the current time
   */
  async command uint16_t get();

  /** 
   * Set the current time.
   * @param t     the time to set
   */
  async command void set( uint16_t t );

  async command void enableCompare0();
  async command void enableCompare1();
  async command void enableCompare2();

  async command void disableCompare0();
  async command void disableCompare1();
  async command void disableCompare2();

  /** 
   * Get the value of the compare register
   * @return value of compare register
   */
  async command uint16_t getCompare0();
  async command uint16_t getCompare1();
  async command uint16_t getCompare2();

  /** 
   * Set the value of the compare register
   * @return value of compare register to set
   */
  async command void setCompare0( uint16_t t );
  async command void setCompare1( uint16_t t );
  async command void setCompare2( uint16_t t );

  /** 
   * Set the timer mode
   */
  async command void setMode( enum cc2430_timer1_mode_t mode );

  /** 
   * Get the timer mode
   * @return timer mode
   */
  async command enum cc2430_timer1_mode_t getMode();

  /* 
   * Set the T1IE flag to enable/disable interrupts altogether:
   * capture, compare and overflow. Remember to set the overflow
   * interrupt mask as well if overflow interrupts are desired.
   *
   */
  async command void enableEvents();
  async command void disableEvents();

  /* 
   * Set/clear the overflow interrupt enable flag T1CLT.OVFIM.  No
   * interrupts will be generated on overflow unless this flag is set.
   */
  async command void enableOverflow();
  async command void disableOverflow();

  /*
   * Check/clear the interrupt status flag corresponding to the mask
   * from the enum cc2430_timer1_if
   *
   * @param if_mask Mask to check/clear bit in T1CTL
   */

  async command bool isIfPending(enum cc2430_timer1_if_t if_mask);
  async command void clearIf(enum cc2430_timer1_if_t if_mask);

  /** 
   * Set the prescaler (clock divider) according to the predefined
   * division values. See CC2430Timer.h.
   *
   * @param scale One of 4 predefined prescaler settings.
   */
  async command void setScale( enum cc2430_timer1_prescaler_t );

  /** 
   * Get prescaler setting.
   * @return  Prescaler setting of clock -- see CC2430Timer.h
   */
  async command enum cc2430_timer1_prescaler_t getScale();

  /** 
   * The timer has fired - the type of interrupt must be checked in
   * T1CTL
   *
   */
  async event void fired();

}
