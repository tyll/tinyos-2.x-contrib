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

#include "msp430baudrates.h"
#include <hardware.h>
#include "DSNBoot.h"

module DSNBootInitP
{
	provides interface Init;
}
implementation
{
	enum {
    ACLK_CALIB_PERIOD = 8,
    ACLK_KHZ = 32,
    TARGET_DCO_KHZ = 4096, // prescribe the cpu clock rate in kHz
    TARGET_DCO_DELTA = (TARGET_DCO_KHZ / ACLK_KHZ) * ACLK_CALIB_PERIOD,
	};
	
	void set_dco_calib( int calib ) {
		BCSCTL1 = (BCSCTL1 & ~0x07) | ((calib >> 8) & 0x07);
		DCOCTL = calib & 0xff;
	}

	uint16_t test_calib_busywait_delta( int calib ) {
	    int8_t aclk_count = 2;
    	uint16_t dco_prev = 0;
	    uint16_t dco_curr = 0;
	
	    set_dco_calib( calib );

    	while( aclk_count-- > 0 ) {
			TBCCR0 = TBR + ACLK_CALIB_PERIOD; // set next interrupt
			TBCCTL0 &= ~CCIFG; // clear pending interrupt
			while( (TBCCTL0 & CCIFG) == 0 ); // busy wait
			dco_prev = dco_curr;
			dco_curr = TAR;
	    }
		return dco_curr - dco_prev;
	}

	// busyCalibrateDCO
	// Should take about 9ms if ACLK_CALIB_PERIOD=8.
	// DCOCTL and BCSCTL1 are calibrated when done.
	void busyCalibrateDco() {
	    // --- variables ---
	    int calib;
    	int step;

	    // --- setup ---

    	TACTL = TASSEL1 | MC1; // source SMCLK, continuous mode, everything else 0
	    TBCTL = TBSSEL0 | MC1;
    	BCSCTL1 = XT2OFF | RSEL2;
	    BCSCTL2 = 0;
    	TBCCTL0 = CM0;

	    // --- calibrate ---

    	// Binary search for RSEL,DCO,DCOMOD.
	    // It's okay that RSEL isn't monotonic.

    	for( calib=0,step=0x800; step!=0; step>>=1 ) {
			// if the step is not past the target, commit it
			if( test_calib_busywait_delta(calib|step) <= TARGET_DCO_DELTA )
				calib |= step;
    	}

		// if DCOx is 7 (0x0e0 in calib), then the 5-bit MODx is not useable, set it to 0
    	if( (calib & 0x0e0) == 0x0e0 )
      		calib &= ~0x01f;

		set_dco_calib( calib );
	}
  
	command error_t Init.init()
	{
	// set clocks
	busyCalibrateDco();

    // BCSCTL2
    // .SELM = 0; select DCOCLK as source for MCLK
    // .DIVM = 0; set the divisor of MCLK to 1
    // .SELS = 0; select DCOCLK as source for SCLK
    // .DIVS = 2; set the divisor of SCLK to 4
    // .DCOR = 0; select internal resistor for DCO
    BCSCTL2 = DIVS1;
   
    return SUCCESS;	
	}
}
