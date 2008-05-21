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
 * @author Tor Petterson <motor@diku.dk>
 */
 
 #include "Hcs08Timer.h"

module Hcs08ClockP
{
  provides interface Init;
  provides interface Hcs08ClockInit;
  provides interface Hcs08ClockControl;
}
implementation
{

  command void Hcs08ClockInit.defaultInitClocks()
  {
  	//Do nothing
  }

  command void Hcs08ClockInit.defaultInitTimer1()
  {
	//Do nothing
  }

  command void Hcs08ClockInit.defaultInitTimer2()
  {
  	//busclock is 8 Mhz so this gives us a 1 us clock
	TPM2SC |= HSC08TIMER__CLOCKDIV_8;
	//Clock source is BUSCLK
	TPM2SC |= (HSC08TIMER_CLK_BUS << 3);
	// Enable interrupts
	TPM2SC |= HSC08TIMER_TOIE;
  }

  default event void Hcs08ClockInit.initClocks()
  {
    call Hcs08ClockInit.defaultInitClocks();
  }

  default event void Hcs08ClockInit.initTimer1()
  {
    call Hcs08ClockInit.defaultInitTimer1();
  }

  default event void Hcs08ClockInit.initTimer2()
  {
    call Hcs08ClockInit.defaultInitTimer2();
  }

  command error_t Init.init()
  {
    // Reset timers and clear interrupt vectors
    TPM1SC &= ~HSC08TIMER_TOF;
    TPM1CNT = 0;
    TPM2SC &= ~HSC08TIMER_TOF;
    TPM2CNT = 0;
    
    atomic
    {
      signal Hcs08ClockInit.initClocks();
      signal Hcs08ClockInit.initTimer1();
      signal Hcs08ClockInit.initTimer2();
    }

    return SUCCESS;
  }
  
  command void Hcs08ClockControl.enterFEIMode(uint8_t multFact, uint8_t divFact)
  {
	// f_IRG = 243 KHz
	// f_ICGOUT = (f_IRG / 7) * 64 * multFact / divFact
	// 16 MHz = ( 243 kHz / 7) * 64 * 14 / 2
	// multFact : 4, 6, 8, 10, 12, 14, 16,  18
	// divFact  : 1, 2, 4,  8, 16, 32, 64, 128
	
	uint8_t MFD, RFD = 0;
	
	// Set busClock variable.
	busClock = (fIRG / 7) * 64 * (multFact / divFact)/2;
	
	// Calculate MFD bits.
	MFD = (multFact - 4)>>1;
	MFD &= 0x07;
	
	// Calculate RFD bits.
	while (divFact) {
	  divFact = divFact>>1;
	  RFD++;
	}
	RFD--;
	RFD &= 0x07;
	
	// Set clock into FEI mode.	
	ICGC1 = 0x28;  //00101000, REFS = 1, CLKS = 1.
	while (!ICGS2_DCOS); // Wait for DCO to be stable.
	ICGC2_MFD = MFD;
	ICGC2_RFD = RFD;	
	ICGC2_LOLRE = 0;
	ICGC2_LOCRE = 0;
 }

  command void Hcs08ClockControl.enterFBEMode(uint8_t divFact)
  {
	// f_ICGOUT = f_EXT / divFact
	// divFact  : 1, 2, 4,  8, 16, 32, 64, 128

	uint8_t RFD = 0;

	// Set busClock variable.
	busClock = (extClock / divFact)/2;

	// Calculate RFD bits.
	while (divFact) {
	  divFact = divFact>>1;
	  RFD++;
	}
	RFD--;
	RFD &= 0x07;
	
	// Set clock into FBE mode.
	ICGC1 = 0x50; // 01010000, RANGE = 1, CLKS = 2.
	while (!ICGS1_ERCS); // Wait for External Clock to be stable.
	ICGC2_RFD = RFD;	
	ICGC2_LOLRE = 0;
	ICGC2_LOCRE = 0;
  }

  command void Hcs08ClockControl.enterFEEMode(bool rng, uint8_t multFact, uint8_t divFact)
  {
	// f_ICGOUT = f_EXT * (64*!rng) * multFact / divFact
	// multFact : 4, 6, 8, 10, 12, 14, 16,  18
	// divFact  : 1, 2, 4,  8, 16, 32, 64, 128

	uint8_t MFD, RFD = 0;
	
	// Set busClock variable.
	busClock = (extClock * (64*!rng) * (multFact / divFact))/2;
	
	// Calculate MFD bits.
	MFD = (multFact - 4)>>1;
	MFD &= 0x07;
	
	// Calculate RFD bits.
	while (divFact) {
	  divFact = divFact>>1;
	  RFD++;
	}
	RFD--;
	RFD &= 0x07;
	
	// Set clock into FEE mode.
	if (rng) {
	  ICGC1 = 0x58; // 01011000
	} else {
	  ICGC1 = 0x18; // 00011000
	}

	while (!ICGS2_DCOS || !ICGS1_ERCS); // Wait for DCO and External Clock to be stable.
	ICGC2_MFD = MFD;
	ICGC2_RFD = RFD;	
	ICGC2_LOLRE = 0;
	ICGC2_LOCRE = 0;
	// Wait for frequency loop to lock.
	while (!ICGS1_LOCK);
  }
}

