/*
 * "Copyright (c) 2000-2007 The Regents of the University of
 * California.  All rights reserved.
 *
 * Permission to use, copy, modify, and distribute this software and
 * its documentation for any purpose, without fee, and without written
 * agreement is hereby granted, provided that the above copyright
 * notice, the following two paragraphs and the author appear in all
 * copies of this software.
 * 
 * IN NO EVENT SHALL THE UNIVERSITY OF CALIFORNIA BE LIABLE TO ANY
 * PARTY FOR DIRECT, INDIRECT, SPECIAL, INCIDENTAL, OR CONSEQUENTIAL
 * DAMAGES ARISING OUT OF THE USE OF THIS SOFTWARE AND ITS
 * DOCUMENTATION, EVEN IF THE UNIVERSITY OF CALIFORNIA HAS BEEN
 * ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
 * 
 * THE UNIVERSITY OF CALIFORNIA SPECIFICALLY DISCLAIMS ANY WARRANTIES,
 * INCLUDING, BUT NOT LIMITED TO, THE IMPLIED WARRANTIES OF
 * MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE.  THE SOFTWARE
 * PROVIDED HEREUNDER IS ON AN "AS IS" BASIS, AND THE UNIVERSITY OF
 * CALIFORNIA HAS NO OBLIGATION TO PROVIDE MAINTENANCE, SUPPORT,
 * UPDATES, ENHANCEMENTS, OR MODIFICATIONS."
 *
 */

/**
 * Count pulses on the Telos GIO1 (TAINCLK) pin and periodically
 * output display count on UART.  Uses Timer A as counter.
 * 
 * @author Prabal Dutta
 * @date   Sep 8, 2007
 */
module EnergyMeterP {
  uses {
    interface Boot;
    interface Msp430Timer as Msp430TimerA;
    interface HplMsp430GeneralIO as Port21;
    interface HplMsp430GeneralIO as Port62;
    interface HplMsp430GeneralIO as Port63;
    interface HplMsp430GeneralIO as Port64;
    interface HplMsp430GeneralIO as Port65;
    
  }
  provides {
    interface EnergyMeter;
  }
}
implementation {

  int32_t m_cbase; // Clock overflows * timer width.

  event void Boot.booted() {
    // Reset energy counter value.
    atomic m_cbase = 0;

    // Configure Timer A.
    call Msp430TimerA.clear();
    call Msp430TimerA.setClockSource(MSP430TIMER_INCLK);
    call Msp430TimerA.setInputDivider(MSP430TIMER_CLOCKDIV_1);
    //call Msp430TimerA.setMode(MSP430TIMER_CONTINUOUS_MODE);

    // Configure the I/O port.
    call Port21.selectModuleFunc();
    call Port21.makeInput();

    // Must make input b/c 2.1 and 6.2 are connected together.
    call Port62.makeInput();
    

    // Quanto Testbed Mote configure iCount
    call Port63.makeOutput();
    call Port64.makeOutput();
    call Port65.makeOutput();
    call Port63.set();
    call Port64.set();
    call Port65.set();
    
  }

  // Handle counter overflows every 0xFFFF cycles.
  async event void Msp430TimerA.overflow() {
    atomic m_cbase += 65536;
  }

  async command void EnergyMeter.reset() {
    call Msp430TimerA.setMode(MSP430TIMER_STOP_MODE);
    call Msp430TimerA.clear();
    atomic m_cbase = 0;
  }

  async command void EnergyMeter.start() {
    call Msp430TimerA.setMode(MSP430TIMER_CONTINUOUS_MODE);
  }

  async command void EnergyMeter.pause() {
    call Msp430TimerA.setMode(MSP430TIMER_STOP_MODE);
  }

  async command uint32_t EnergyMeter.read() {
    uint32_t count = 0;
    atomic {
      call Msp430TimerA.setMode(MSP430TIMER_STOP_MODE);
      count = call Msp430TimerA.get();
      call Msp430TimerA.setMode(MSP430TIMER_CONTINUOUS_MODE);
      count += m_cbase;
    }
    return count;
  }
}
