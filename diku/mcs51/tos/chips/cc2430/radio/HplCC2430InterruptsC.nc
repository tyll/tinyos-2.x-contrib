
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


module HplCC2430InterruptsC {

  provides interface GpioCapture as CaptureSFD;
  provides interface GpioInterrupt as InterruptTXDone;
  provides interface GpioInterrupt as InterruptCCA;
  provides interface GpioInterrupt as InterruptFIFOP;
  provides interface GpioInterrupt as InterruptRFErr;

}

implementation {

  /**
   * Any one interrupt is eabled then RFIE will be enabled, which is never disabled.
   * So if all interrupts are later turned off we will still receive the RFIE interrups,
   * but they will be rejected in the interrupt handler...
   */

  /**
   * All the interrupts are "rising-edge" that is the interrupts are generated
   * when the corresponding signal goes from 0 to 1
   */

 // Clear any left over inerrupts
 // Enable the global RFIE - for all
 // Enable the bit mask for this int
 // No falling int will be generated

#define MAKE_NEW_RF_IRQ(name, bit_name)		   \
  async command error_t name.enableRisingEdge() {  \
    atomic {		                           \
     RFIM |=  _BV(CC2430_RFIM_##bit_name );        \
     RFIF &= ~_BV(CC2430_RFIF_##bit_name);         \
     IEN2 |=  _BV(CC2430_IEN2_RFIE);               \
    }                                              \
    return SUCCESS;                                \
  };						   \
  async command error_t name.enableFallingEdge() { \
     return FAIL;                                  \
  };				                   \
  async command error_t name.disable() {           \
    atomic {RFIM &= ~_BV( CC2430_RFIM_##bit_name );}\
    return SUCCESS;                                \
  };

  /*
   * Ugh.. Hack, maybe I should do a real capture some day...
   *
   * we just want to capture the radio matches the start frame (SFD) and we know they'll
   * be using timer 1 - so just read the time and give it to 'em 0].
   */

#define GET_NOW(p) ((uint8_t*)&p)[1]=T1CNTL;\
                   ((uint8_t*)&p)[0]=T1CNTH
 // Clear any left over inerrupts
 // Enable the global RFIE - for all
#define MAKE_NEW_RF_CAPTURE(name, bit_name)	   \
  async command error_t name.captureRisingEdge() { \
    atomic {                                       \
     RFIM |=  _BV(CC2430_RFIM_##bit_name);	   \
     RFIF &= ~_BV(CC2430_RFIF_##bit_name);         \
     IEN2 |=  _BV(CC2430_IEN2_RFIE);               \
     return SUCCESS;                               \
    }                                              \
  };                                               \
  async command error_t name.captureFallingEdge() {\
    return FAIL;				   \
  };                                               \
  async command void name.disable() {              \
    atomic {RFIM &= ~_BV(CC2430_RFIM_##bit_name);} \
  };


/*
 * Interrupts from SIG_RF
 */

  MAKE_NEW_RF_IRQ(InterruptCCA, CCA);
  MAKE_NEW_RF_IRQ(InterruptFIFOP, FIFOP);
  MAKE_NEW_RF_IRQ(InterruptTXDone, TXDONE);

  MAKE_NEW_RF_CAPTURE(CaptureSFD, SFD);

/*
 * Interrupts from SIG_RFERR
 */

  async command error_t InterruptRFErr.enableRisingEdge() {
    atomic {
      RFERRIF = 0;	
      RFERRIE = 1;
    }
    return SUCCESS;
  };
  async command error_t InterruptRFErr.enableFallingEdge() {
     return FAIL;
  };
  async command error_t InterruptRFErr.disable() {
     RFERRIE = 0;
     return SUCCESS;
  }


  MCS51_INTERRUPT(SIG_RFERR) {
  atomic {
    RFERRIF = 0; // Same as TCON &= ~_BV(1);
    signal InterruptRFErr.fired();
  }
  }

  MCS51_INTERRUPT(SIG_RF) { 
    // Remember to clear the flags in the order RFIM, S1CON
    // see datasheet section 14.4

    // P1_3 = P1_3 ? 0 : 1; // Toggle Led3

    atomic{
      uint8_t RFIF_RFIM = RFIF & RFIM; // Event signalled and mask enabled

      //MAKE_IO_PIN_OUTPUT(P1_DIR, 3);
      //P1_3 = 0;

      // Clear all interrupt flags
      //RFIF = 0;

      /* The eratta sheet suggests that this is the propper way
	 to work arround bugs */

      RFIF &= ~((uint8_t)0x01);
      RFIF &= ~((uint8_t)0x02);
      RFIF &= ~((uint8_t)0x04);
      RFIF &= ~((uint8_t)0x08);
      RFIF &= ~((uint8_t)0x10);
      RFIF &= ~((uint8_t)0x20);
      RFIF &= ~((uint8_t)0x40);
      RFIF &= ~((uint8_t)0x80);

      if ( RFIF_RFIM & _BV(CC2430_RFIF_CCA)) {
	  signal InterruptCCA.fired();
      }

      if ( RFIF_RFIM & _BV(CC2430_RFIF_FIFOP)) {
	  signal InterruptFIFOP.fired();
      }

      if ( RFIF_RFIM & _BV(CC2430_RFIF_TXDONE)) {
	  signal InterruptTXDone.fired();
      }

      if ( RFIF_RFIM & _BV(CC2430_RFIF_SFD) ) {
    	uint16_t now;
    	GET_NOW(now);
    	signal CaptureSFD.captured(now);
      }

      // Clear the general RF interrupts
      S1CON &= ~0x03;
      
    }
  }

 default async event void CaptureSFD.captured(uint16_t time) {}
 default async event void InterruptTXDone.fired() {}
 default async event void InterruptCCA.fired() {}
 default async event void InterruptFIFOP.fired() {}
 default async event void InterruptRFErr.fired() {}

}
