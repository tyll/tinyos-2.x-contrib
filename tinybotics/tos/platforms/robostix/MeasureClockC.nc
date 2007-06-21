/*
 * Copyright (c) 2006 Intel Corporation
 * All rights reserved.
 *
 * This file is distributed under the terms in the attached INTEL-LICENSE     
 * file. If you do not find these files, copies can be found by writing to
 * Intel Research Berkeley, 2150 Shattuck Avenue, Suite 1300, Berkeley, CA, 
 * 94704.  Attention:  Intel License Inquiry.
 *
 * Copyright (c) 2007 University of Padova
 * Copyright (c) 2007 Orebro University
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
 * - Neither the name of the the copyright holders nor the names of
 *   their contributors may be used to endorse or promote products derived
 *   from this software without specific prior written permission.
 *
 * THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS
 * ``AS IS'' AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT
 * LIMITED TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS
 * FOR A PARTICULAR PURPOSE ARE DISCLAIMED.  IN NO EVENT SHALL THE COPYRIGHT
 * HOLDERS OR THEIR CONTRIBUTORS BE LIABLE FOR ANY DIRECT, INDIRECT,
 * INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES
 * (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR
 * SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION)
 * HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT,
 * STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE)
 * ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED
 * OF THE POSSIBILITY OF SUCH DAMAGE.
 */

/**
 * Recycled from mica code to mimic calibration functionalities
 * in case of an external crystal on timer0 (absent on stock robostixes);
 * fakes jiffies count for the moment
 * @author David Gay
 * @author Mirko Bordignon <mirko.bordignon@ieee.org>
 */

#include <RobostixTimer.h>
#include <scale.h>

module MeasureClockC {
  provides {
    /**
     * This code MUST be called from PlatformP only, hence the exactlyonce.
     */
    interface Init @exactlyonce();
    interface Atm128Calibrate;
  }
}
implementation 
{
  enum {
    /* This is expected number of cycles per jiffy at the platform's
       specified MHz. Assumes PLATFORM_MHZ == 1, 2, 4, 8 or 16. */
    MAGIC = 488 / (16 / PLATFORM_MHZ)
  };

  uint16_t cycles = MAGIC;

  command error_t Init.init() {
/*     /\* Measure clock cycles per Jiffy (1/32768s) *\/ */
/*     /\* This code doesn't use the HPL to avoid timing issues when compiling */
/*        with debugging on *\/ */
/*     atomic */
/*       { */
/* 	uint8_t now, wraps; */
/* 	uint16_t start; */

/* 	/\* Setup timer0 to count 32 jiffies, and timer1 cpu cycles *\/ */
/* 	TCCR1B = 1 << CS10; */
/* 	ASSR = 1 << AS0; */
/* 	TCCR0 = 1 << CS01 | 1 << CS00; */

/* 	/\* Wait for 1s for counter to stablilize after power-up (yes, it */
/* 	   really does take that long). That's 122 wrap arounds of timer 1 */
/* 	   at 8MHz. *\/ */
/* 	start = TCNT1; */
/* 	for (wraps = MAGIC / 2; wraps; ) */
/* 	  { */
/* 	    uint16_t next = TCNT1; */

/* 	    if (next < start) */
/* 	      wraps--; */
/* 	    start = next; */
/* 	  } */

/* 	/\* Wait for a TCNT0 change *\/ */
/* 	now = TCNT0; */
/* 	while (TCNT0 == now) ; */

/* 	/\* Read cpu cycles and wait for next TCNT0 change *\/ */
/* 	start = TCNT1; */
/* 	now = TCNT0; */
/* 	while (TCNT0 == now) ; */
/* 	cycles = TCNT1; */

/* 	cycles = (cycles - start + 16) >> 5; */

/* 	/\* Reset to boot state *\/ */
/* 	ASSR = TCCR1B = TCCR0 = 0; */
/* 	TCNT0 = 0; */
/* 	TCNT1 = 0; */
/* 	ETIFR = TIFR = 0xff; */
/* 	while (ASSR & (1 << TCN0UB | 1 << OCR0UB | 1 << TCR0UB)) */
/* 	  ; */
/*       } */
    return SUCCESS;
  }

  async command uint16_t Atm128Calibrate.cyclesPerJiffy() {
    return cycles;
  }

  async command uint32_t Atm128Calibrate.calibrateMicro(uint32_t n) {
    return scale32(n + MAGIC / 2, cycles, MAGIC);
  }

  async command uint32_t Atm128Calibrate.actualMicro(uint32_t n) {
    return scale32(n + (cycles >> 1), MAGIC, cycles);
  }

  async command uint8_t Atm128Calibrate.adcPrescaler() {
    /* This is also log2(cycles/3.05). But that's a pain to compute */
    if (cycles >= 390)
      return ATM128_ADC_PRESCALE_128;
    if (cycles >= 195)
      return ATM128_ADC_PRESCALE_64;
    if (cycles >= 97)
      return ATM128_ADC_PRESCALE_32;
    if (cycles >= 48)
      return ATM128_ADC_PRESCALE_16;
    if (cycles >= 24)
      return ATM128_ADC_PRESCALE_8;
    if (cycles >= 12)
      return ATM128_ADC_PRESCALE_4;
    return ATM128_ADC_PRESCALE_2;
  }

  async command uint16_t Atm128Calibrate.baudrateRegister(uint32_t baudrate) {
    // value is (cycles*32768) / (8*baudrate) - 1
    return ((uint32_t)cycles << 12) / baudrate - 1;
  }
}
