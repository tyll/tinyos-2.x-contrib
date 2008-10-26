
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
 * @author Martin Leopold
 */


// Our Timer.h must take precense over tos/lib/timer/Timer.h - the empty structures
// does not work with Keil
#include <Timer.h>
#include <CC2430Timer.h>

module PlatformP { 
  provides interface Init;
  uses interface Init as LedsInit;
  uses interface Init as GIOInit;
}
implementation {
  command error_t Init.init() {
    uint8_t new_clkcon;

    // ChipCon
//CLKCON·|=·0x40;···············\
//while(!HIGH_FREQUENCY_RC_OSC_STABLE);·\
//if(TICKSPD·==·0){·············\
//··CLKCON·|=·0x08;·············\
//}·····························\
//SLEEP·|=·0x04;················\ 


    /*
      Select high power, high precision 32 MHz external crysatal
     */

    // Setting the clock source to crystal waiting for it to be stable
    // This taks time and consumes more power than the internal than the
    // internal oscilator
    //
    // Clock calibration and clock source selection
    //    1. Power up external high-power, high-precision osc
    //    2. Wait for it to stabelize
    //    3. Select clock source
    //
    // The change should be reflected in CLKCON.CLKSPD
    //
    // This should probably be moved to its own little interface that look
    // like ChipCon's SET_MAIN_CLOCK_SOURCE in hal.h
    //
    // This procedure follows the datasheet (section 14.20 figure 54)
    // and not the procedure from SET_MAIN_CLOCK_SOURCE which is
    // nothing like the datasheet.

   
    /* Select system clock frequency 32 MHz */
    //CLKCON &= ~_BV(CC2430_CLKCON_CLKSPD);
    // Can only be read!

    // set (power) MODE=0
    SLEEP = (SLEEP & ~CC2430_SLEEP_MODE_MASK) | CC2430_SLEEP_POWERMODE_0; 

    // Power up all oscilators (Must be cleared when toggling CLKCON.OSC)
    // See section 13.10.3
    SLEEP  &= ~_BV(CC2430_SLEEP_OSC_PD);
    while (!(SLEEP & _BV(CC2430_SLEEP_XOSC_STB))); // Wait for XOSC powered up and stable

    new_clkcon = 0x0;
    /* Timer ticks divder = 1 */
    new_clkcon = (new_clkcon & ~CC2430_CLKCON_TICKSPD_MASK) | CC2430_TICKF_DIV_1;

    // Select 32768Hz oscilator source (crystal or internal)
    new_clkcon &= ~_BV(CC2430_CLKCON_OSC32K); // crystal

    /* Select system clock source = 32 MHz crystal*/
    /* If the osc. is not powered up and stable this powers it up and the switch takes effect
     * when the crystal is stable       
     */
    //new_clkcon |= _BV(CC2430_CLKCON_OSC); // 16 MHz CPU
    new_clkcon &= ~_BV(CC2430_CLKCON_OSC); // 32 MHz CPU

    new_clkcon |= _BV(CC2430_CLKCON_TICKSPD);

    CLKCON = new_clkcon;

    // while (!(SLEEP & _BV(CC2430_SLEEP_HFRC_STB))); 

    //SLEEP &= ~0x04; // Must be cleared when toggling OSC
    //CLKCON &= ~0x47; // Clear CLKCON.OSC
    //while (!(SLEEP & 0x40)) ; // Wait for XOSC_STB flag (XOSC powered up and stable)

    /*
      Select low power, low precision 16 MHz internal RC oscilator
     */

//    CLKCON |= 0x40;
//    while(!(SLEEP & 0x20));
//    /* Set tickspd devider low */
//    if((CLKCON & 0x37) == 0){
//      CLKCON |= 0x08;
//    }
//    SLEEP |= 0x04; // Power down oscilators OSC_PD
//

//    MAKE_IO_PIN_OUTPUT(P1_DIR, 0);
//    MAKE_IO_PIN_OUTPUT(P1_DIR, 3);
//    P1_0 = 0;
//    P1_3 = 0;

    call LedsInit.init();
    return SUCCESS;
  }

  default command error_t LedsInit.init() { return SUCCESS; }
}
