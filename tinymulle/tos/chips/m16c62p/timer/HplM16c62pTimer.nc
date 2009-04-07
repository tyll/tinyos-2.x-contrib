/*
 * Copyright (c) 2004-2005 Crossbow Technology, Inc.  All rights reserved.
 *
 * Permission to use, copy, modify, and distribute this software and its
 * documentation for any purpose, without fee, and without written agreement is
 * hereby granted, provided that the above copyright notice, the following
 * two paragraphs and the author appear in all copies of this software.
 * 
 * IN NO EVENT SHALL CROSSBOW TECHNOLOGY OR ANY OF ITS LICENSORS BE LIABLE TO 
 * ANY PARTY FOR DIRECT, INDIRECT, SPECIAL, INCIDENTAL, OR CONSEQUENTIAL 
 * DAMAGES ARISING OUT OF THE USE OF THIS SOFTWARE AND ITS DOCUMENTATION, EVEN
 * IF CROSSBOW OR ITS LICENSOR HAS BEEN ADVISED OF THE POSSIBILITY OF SUCH 
 * DAMAGE. 
 *
 * CROSSBOW TECHNOLOGY AND ITS LICENSORS SPECIFICALLY DISCLAIM ALL WARRANTIES,
 * INCLUDING, BUT NOT LIMITED TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY 
 * AND FITNESS FOR A PARTICULAR PURPOSE. THE SOFTWARE PROVIDED HEREUNDER IS 
 * ON AN "AS IS" BASIS, AND NEITHER CROSSBOW NOR ANY LICENSOR HAS ANY 
 * OBLIGATION TO PROVIDE MAINTENANCE, SUPPORT, UPDATES, ENHANCEMENTS, OR 
 * MODIFICATIONS.
 */
/**
 * @author Martin Turon <mturon@xbow.com>
 */

/**
 * Basic interface to the hardware timers on an Renesas M16C/62p.
 * This interface provides four major groups of functionality:<ol>
 *      <li>Timer Value: get/set current time
 *      <li>Interrupt event, occurs when the timer under- or overflows.
 *      <li>Control of Interrupt: enableInterrupt/disableInterrupt/clearInterrupt...
 *      <li>Timer Initialization: turn on/off clock source
 * </ol>
 *
 * @author Henrik Makitaavola
 */
#include "M16c62pTimer.h"
interface HplM16c62pTimer
{
  /**
   * Turn on the clock.
   */
  async command void on();
  
  /**
   * Turn off the clock.
   */
  async command void off();

  /**
   * Check if the clock is on.
   */
  async command bool isOn();

  /** 
   * Get the current time.
   * @return  the current time.
   */
  async command uint16_t get();

  /** 
   * Set the current time.
   * @param t the time to set.
   */
  async command void set( uint16_t t );

  /**
   * Signalled on timer interrupt.
   */
  async event void fired();

  /**
   * Clear the interrupt flag.
   */
  async command void clearInterrupt();

  /**
   * Enable the interrupts.
   */
  async command void enableInterrupt();

  /**
   * Turn off interrupts.
   */
  async command void disableInterrupt();

  /** 
   * Checks if an interrupt has occured.
   * @return TRUE if interrupt has triggered.
   */
  async command bool testInterrupt();

  /** 
   * Checks if interrupts are on.
   * @return TRUE if interrups are enabled.
   */
  async command bool isInterruptOn();
}
