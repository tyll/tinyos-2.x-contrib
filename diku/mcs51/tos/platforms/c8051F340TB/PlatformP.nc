/*
 * Copyright (c) 2008 Polaric
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
 * - Neither the name of Polaric nor the names of its contributors may
 *   be used to endorse or promote products derived from this software
 *   without specific prior written permission.
 *
 * THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND
 * CONTRIBUTORS ``AS IS'' AND ANY EXPRESS OR IMPLIED WARRANTIES,
 * INCLUDING, BUT NOT LIMITED TO, THE IMPLIED WARRANTIES OF
 * MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE
 * DISCLAIMED.  IN NO EVENT SHALL POLARIC OR ITS CONTRIBUTORS BE
 * LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL,
 * EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT
 * LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS
 * OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER
 * CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT,
 * STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE)
 * ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF
 * ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
 */

/**
 * @author Martin Leopold <leopold@polaric.dk>
 */


module PlatformP { 
  provides interface Init;
  uses interface Init as LedsInit;
  uses interface Init as GPIOInit;
}
implementation {

  void Delay(void)
  {
    uint16_t x;
    for(x = 0;x < 500;x)
      x++;
  }

  command error_t Init.init() {
    uint16_t i;

    // Disable watchdog timer
    PCA0MD &= ~0x40;

    /*
     * Internal oscillator 12 MHz
     */
    OSCICN = 0x83;

    /**
     * Power up to 4x multiplier resulting in a 48 MHz oscillator, for
     * system clock and USB Full Speed
     */
    CLKMUL = 0;// Reset
    CLKMUL |= _BV(CIP51_CLKMUL_MULEN);
    while(i<500) {
      i++;
    }
    CLKMUL |= _BV(CIP51_CLKMUL_MULINT);
    while(i<500) {
      i++;
    }
    while(!(CLKMUL & _BV(CIP51_CLKMUL_MULRDY))) {}

    /**
     * Select 48 MHz clock as system clock source
     */
    FLSCL  |= 0x10; // set FLRT for 48MHz SYSCLK
    CLKSEL = 0x03;

    
    /* Setup X-bar
     * P0_0 SCK
     * P0_1 MISO
     * P0_2 MOSI
     * P0_3 NSS
     * P0_4 TX0
     * P0_5 TX1
     * P0_6
     * P0_7
     *
     * P1_0
     * P1_1
     * P1_2 SDA
     * P1_3 SCL
     * P1_4 
     * P1_5 
     * P1_6
     * P1_7
     *
     * P2_0
     * P2_1
     * P2_2
     * P2_3 LED
     * P2_4 LED
     * P2_5 
     * P2_6
     * P2_7
     */

    call GPIOInit.init();
    call LedsInit.init();

    P0SKIP = 0xC0;
    P1SKIP = 0x03;
    P2SKIP = 0x04;  // Skip the LED (P2.2)

    XBR0 = 0x07;
    XBR1 = 0x40;

    // Enable interrupts
    EA = 1;

    return SUCCESS;
  }

  default command error_t LedsInit.init() { return SUCCESS; }
}
