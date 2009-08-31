//$Id$

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
 * @author Vlado Handziski <handzisk@tkn.tu-berlind.de>
 */

#include <Msp430DcoSpec.h>

#include "Msp430Timer.h"

module Msp430ClockP
{
  provides interface Init;
  provides interface Msp430ClockInit;
}
implementation
{
  MSP430REG_NORACE(IE1);
  MSP430REG_NORACE(TACTL);
  MSP430REG_NORACE(TAIV);
  MSP430REG_NORACE(TBCTL);
  MSP430REG_NORACE(TBIV);

  enum
  {
    ACLK_CALIB_PERIOD = 8,
    TARGET_DCO_DELTA = (TARGET_DCO_KHZ / ACLK_KHZ) * ACLK_CALIB_PERIOD,
  };

  inline void timerBTick(uint16_t ticks) {
    ticks += TBR;
    while (TBR != ticks)
      ;
  }

#warning "ROSC must be present on MSP430F2618 platforms!"

#define RSEL_MASK 0x07
#define SRCH_BGN  0x400

  command void Msp430ClockInit.defaultSetupDcoCalibrate() {
    int i;

    // Enable P2.5 ROSC, maybe
    CLR_FLAG(P2IE,  1 << 5);
    CLR_FLAG(P2IFG, 1 << 5);
    CLR_FLAG(P2REN, 1 << 5);
    SET_FLAG(P2OUT, 1 << 5);
    CLR_FLAG(P2DIR, 1 << 5);
    SET_FLAG(P2SEL, 1 << 5);

    TACTL   = TASSEL1 | MC1; // source SMCLK, continuous mode
    TBCTL   = TBSSEL0 | MC1; // source  ACLK, continuous mode
    BCSCTL1 = XT2OFF | RSEL2;
    // Use P2.5, maybe
    BCSCTL2 = DCOR;

    TBCCTL0 = CM0;

    // wait for things to stabilize
#warning "Waiting 2000ms for ACLK stabilization"
    for (i = 0; i < 20; i++)
      timerBTick(100 << 5);
   }
    
  command void Msp430ClockInit.defaultInitClocks() {
    // IE1.OFIE = 0; no interrupt for oscillator fault
    CLR_FLAG( IE1, OFIE );

    // BCSCTL1
    // .XT2OFF = 1; disable the external oscillator for SCLK and MCLK
    // .XTS = 0; set low frequency mode for LXFT1
    // .DIVA = 0; set the divisor on ACLK to 1
    // .RSEL, do not modify
    BCSCTL1 = XT2OFF | (BCSCTL1 & (RSEL2|RSEL1|RSEL0));

    // BCSCTL2
    // .SELM = 0; select DCOCLK as source for MCLK
    // .DIVM = 0; set the divisor of MCLK to 1
    // .SELS = 0; select DCOCLK as source for SCLK
    // .DIVS = 2; set the divisor of SCLK to 4
    // .DCOR = 0; select internal resistor for DCO
#ifdef MHZ_8
#warning "Using MCLK/8 for SMCLK"
    BCSCTL2 = DIVS1 | DIVS0 | DCOR;
#else
#warning "Using MCLK/4 for SMCLK"
    BCSCTL2 = DIVS1 | DCOR;
#endif
  }

  command void Msp430ClockInit.defaultInitTimerA()
  {
    TAR = 0;

    // TACTL
    // .TACLGRP = 0; each TACL group latched independently
    // .CNTL = 0; 16-bit counter
    // .TASSEL = 2; source SMCLK = DCO/4
    // .ID = 0; input divisor of 1
    // .MC = 0; initially disabled
    // .TACLR = 0; reset timer A
    // .TAIE = 1; enable timer A interrupts
    TACTL = TASSEL1 | TAIE;
  }

  command void Msp430ClockInit.defaultInitTimerB()
  {
    TBR = 0;

    // TBCTL
    // .TBCLGRP = 0; each TBCL group latched independently
    // .CNTL = 0; 16-bit counter
    // .TBSSEL = 1; source ACLK
    // .ID = 0; input divisor of 1
    // .MC = 0; initially disabled
    // .TBCLR = 0; reset timer B
    // .TBIE = 1; enable timer B interrupts
    TBCTL = TBSSEL0 | TBIE;
  }

  default event void Msp430ClockInit.setupDcoCalibrate()
  {
    call Msp430ClockInit.defaultSetupDcoCalibrate();
  }
  
  default event void Msp430ClockInit.initClocks()
  {
    call Msp430ClockInit.defaultInitClocks();
  }

  default event void Msp430ClockInit.initTimerA()
  {
    call Msp430ClockInit.defaultInitTimerA();
  }

  default event void Msp430ClockInit.initTimerB()
  {
    call Msp430ClockInit.defaultInitTimerB();
  }


  void startTimerA()
  {
    // TACTL.MC = 2; continuous mode
    TACTL = MC1 | (TACTL & ~(MC1|MC0));
  }

  void stopTimerA()
  {
    //TACTL.MC = 0; stop timer B
    TACTL = TACTL & ~(MC1|MC0);
  }

  void startTimerB()
  {
    // TBCTL.MC = 2; continuous mode
    TBCTL = MC1 | (TBCTL & ~(MC1|MC0));
  }

  void stopTimerB()
  {
    //TBCTL.MC = 0; stop timer B
    TBCTL = TBCTL & ~(MC1|MC0);
  }

  void set_dco_calib(uint16_t calib) {
    // 20080328: handle erratum BCL12 for F2618
    // NB: BCL12 shouldn't occur using this cal algorithm!
#warning "Using BCL12 erratum workaround code"

    uint8_t newRSel, oldRSel, ctl;

    // collect old & new RSEL, remainder of current settings
    newRSel = (calib >> 8) & RSEL_MASK;
    oldRSel = BCSCTL1 & RSEL_MASK;
    ctl     = BCSCTL1 ^ oldRSel;

    // BCL12: use 13 as intermediate value to avoid ~20us dead time
    //        when switching from >13 to <12
    if ((oldRSel > 13) && (newRSel < 12)) {
      BCSCTL1 = ctl | 13;
      // Wait for a tick
      timerBTick(1);
    }
    // *now* hit the target freq
    BCSCTL1 = ctl | newRSel;

    DCOCTL = calib & 0xff;

    // Wait for timer B to tick
    timerBTick(2);
  }

  uint16_t test_calib_busywait_delta(int calib) {
    register uint16_t t0, t1;

    // tweak the DCO
    set_dco_calib(calib);
    // count TA for some TB counts
    t0 = TAR;
    timerBTick(ACLK_CALIB_PERIOD);
    t1 = TAR;
    // return number of TA counts
    return t1 - t0;
  }

  // busyCalibrateDCO
  // Should take about 9ms if ACLK_CALIB_PERIOD=8.
  // DCOCTL and BCSCTL1 are calibrated when done.
  void busyCalibrateDco()
  {
    int calib;
    int step;

    // Binary search for RSEL,DCO,DCOMOD.
    for (calib=0, step=SRCH_BGN; step != 0; step >>= 1) {
      // if the step is not past the target, commit it
      if( test_calib_busywait_delta(calib | step) <= TARGET_DCO_DELTA ) {
        calib |= step;
      }
      // if DCOx is 7 (0x0e0 in calib), then the 5-bit MODx is not usable
      if ((calib & 0x00e0) == 0x00e0)
	break;
    }
    // finish up
    set_dco_calib(calib);
  }

  command error_t Init.init() {
    // Reset timers and clear interrupt vectors
    TACTL = TACLR;
    TAIV  = 0;
    TBCTL = TBCLR;
    TBIV  = 0;

    atomic {
      // Calibrate DCO against the LF rock
      signal Msp430ClockInit.setupDcoCalibrate();
      busyCalibrateDco();
      // Get everything rolling
      signal Msp430ClockInit.initClocks();
      signal Msp430ClockInit.initTimerA();
      signal Msp430ClockInit.initTimerB();
      startTimerA();
      startTimerB();
    }
    return SUCCESS;
  }
}

