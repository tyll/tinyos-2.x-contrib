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
 * Control clock functions of the CC2430 (register CLKCON)
 *
 * @author Martin Leopold <leopold@diku.dk>
 */

interface CC2430ClockControl {

  /*
   * Get/set the 32.768 kHz clock source CLKCON.OSC32K
   *
   * @param s Source (true (1) 32.768 kHz RC osc., false (0) 32.768 kHz crystal osc.)
   */
  async command void set32kClkSourceRC() {}
  async command void set32kClkSourceCrystal() {}
  async command bool get32kClkSourceRC () {}


  /*
   * Get/set the system clock source CLKCON.OSC
   *
   * @param s Source true (1) = 16 MHz RC oscilator, false (0) 32 MHz crystal osc.
   */
  async command void setSysClkSourceRC () {}
  async command void setSysClkSourceCrystal () {}
  async command bool getSysClkSourceRC () {}


  /* 
   * set/get system clock frequency CLCKCON.CLKSPD
   *
   * @param s speed (true (1) 16 MHz, false (0) 32 Mhz)
   */

  async command void setSysFreq16MHz () {}
  async command void setSysFreq32MHz () {}
  async command bool getSysFreq16MHz () {}
  /* 
   * set/get system clock frequency divider value CLKCON.TICKSPD
   *
   * @param 
   */

  async command void setSysClockDiv (uint8_t d) {}
  async command uint8_t getSysClockDiv () {}

}
