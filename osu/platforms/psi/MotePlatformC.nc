/**
 * Copyright (c) 2007 - The Ohio State University.
 * All rights reserved.
 *
 * Permission to use, copy, modify, and distribute this software and its
 * documentation for any purpose, without fee, and without written agreement is
 * hereby granted, provided that the above copyright notice, the following
 * two paragraphs, and the author attribution appear in all copies of this
 * software.
 *
 * IN NO EVENT SHALL THE OHIO STATE UNIVERSITY BE LIABLE TO ANY PARTY FOR
 * DIRECT, INDIRECT, SPECIAL, INCIDENTAL, OR CONSEQUENTIAL DAMAGES ARISING OUT
 * OF THE USE OF THIS SOFTWARE AND ITS DOCUMENTATION, EVEN IF THE OHIO STATE
 * UNIVERSITY HAS BEEN ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
 *
 * THE OHIO STATE UNIVERSITY SPECIFICALLY DISCLAIMS ANY WARRANTIES,
 * INCLUDING, BUT NOT LIMITED TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY
 * AND FITNESS FOR A PARTICULAR PURPOSE.  THE SOFTWARE PROVIDED HEREUNDER IS
 * ON AN "AS IS" BASIS, AND THE OHIO STATE UNIVERSITY HAS NO OBLIGATION TO
 * PROVIDE MAINTENANCE, SUPPORT, UPDATES, ENHANCEMENTS, OR MODIFICATIONS.

	@author 
	Lifeng Sang  <sangl@cse.ohio-state.edu>
	Anish Arora  <anish@cse.ohio-state.edu>	
	$Date$
	
	Porting TinyOS to Intel PSI motes
 */

module MotePlatformC {
  provides interface Init;
}
implementation {
	
	
  inline void uwait(uint16_t u) { 
    uint16_t t0 = TAR;
    while((TAR - t0) <= u);
  } 

  inline void TOSH_wait() {
    nop(); nop();
  }


	
	void sys_reset() {
	  /* clear out a bunch of interrupt enables */
	  ADC12CTL0 = 0;
	  IE1 = 0;
	  IE2 = 0;
	  P1IE = 0;
	  P2IE = 0;
	  
	  // reset the NFC chip -- in newer versions this should
	  // be moved to a user-space operation
#define IM2_RESET 0x04
	  
	  P4DIR |= IM2_RESET;
	  P4OUT |= IM2_RESET;
	  uwait(1000);
	  P4OUT &= ~IM2_RESET;
	}


  // send a bit via bit-banging to the flash
  void TOSH_FLASH_M25P_DP_bit(bool set) {
    if (set)
      TOSH_SET_SIMO0_PIN();
    else
      TOSH_CLR_SIMO0_PIN();
    TOSH_SET_UCLK0_PIN();
    TOSH_CLR_UCLK0_PIN();
  }

  // put the flash into deep sleep mode
  // important to do this by default
  void TOSH_FLASH_M25P_DP() {
    //  SIMO0, UCLK0
    TOSH_MAKE_SIMO0_OUTPUT();
    TOSH_MAKE_UCLK0_OUTPUT();
    TOSH_MAKE_FLASH_HOLD_OUTPUT();
    TOSH_MAKE_FLASH_CS_OUTPUT();
    TOSH_SET_FLASH_HOLD_PIN();
    TOSH_SET_FLASH_CS_PIN();

    TOSH_wait();

    // initiate sequence;
    TOSH_CLR_FLASH_CS_PIN();
    TOSH_CLR_UCLK0_PIN();
  
    TOSH_FLASH_M25P_DP_bit(TRUE);   // 0
    TOSH_FLASH_M25P_DP_bit(FALSE);  // 1
    TOSH_FLASH_M25P_DP_bit(TRUE);   // 2
    TOSH_FLASH_M25P_DP_bit(TRUE);   // 3
    TOSH_FLASH_M25P_DP_bit(TRUE);   // 4
    TOSH_FLASH_M25P_DP_bit(FALSE);  // 5
    TOSH_FLASH_M25P_DP_bit(FALSE);  // 6
    TOSH_FLASH_M25P_DP_bit(TRUE);   // 7

    TOSH_SET_FLASH_CS_PIN();

    TOSH_SET_SIMO0_PIN();
    TOSH_MAKE_SIMO0_INPUT();
    TOSH_MAKE_UCLK0_INPUT();
    TOSH_CLR_FLASH_HOLD_PIN();
  }

  command error_t Init.init() {
    // reset all of the ports to be input and using i/o functionality
       
    
    atomic
     {
     		
	P1SEL = 0;
	P2SEL = 0;
	P3SEL = 0x3e;
	P4SEL = 0;
	P5SEL = 0xf;
	P6SEL = 0x7;

	P1DIR = 0x10;
	P1OUT = 0x10;
 
	P2DIR = 0x8;
	P2OUT = 0x0;

	P3DIR = 0x5b;
	P3OUT = 0x51;

	P4DIR = 0x25;
	P4OUT = 0x1;

	P5DIR = 0xd4;
	P5OUT = 0x10;

	P6DIR = 0x80;
	P6OUT = 0x0;

	P1IE = 0;
	P2IE = 0;

	// the commands above take care of the pin directions
	// there is no longer a need for explicit set pin
	// directions using the TOSH_SET/CLR macros

	// wait 10ms for the flash to startup
	uwait(1024*10);
	
	
	//No external flash on the PSI mote, it doesn't matter	
	
	TOSH_FLASH_M25P_DP(); // Put the flash in deep sleep state	
		
	}//atomic
	
	//System reset
	sys_reset();

	
    return SUCCESS;
  }
}
