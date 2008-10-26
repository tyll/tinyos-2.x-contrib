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
 * This file is identical to HplMcs51GeneralIOC, except it adds
 * the additional IO ports found on the CC2430 that were not found
 * in the classic 8051.
 * 
 * @author Martin Leopold <leopold@diku.dk>
 *
 */

#include <io8051.h>
#include <ioCC2430.h>

module HplCC2430GeneralIOC {
  provides interface GeneralIO as P00;
  provides interface GeneralIO as P01;
  provides interface GeneralIO as P02;
  provides interface GeneralIO as P03;
  provides interface GeneralIO as P04;
  provides interface GeneralIO as P05;
  provides interface GeneralIO as P06;
  provides interface GeneralIO as P07;

  provides interface GeneralIO as P10;
  provides interface GeneralIO as P11;
  provides interface GeneralIO as P12;
  provides interface GeneralIO as P13;
  provides interface GeneralIO as P14;
  provides interface GeneralIO as P15;
  provides interface GeneralIO as P16;
  provides interface GeneralIO as P17;

  provides interface GeneralIO as P20;
  provides interface GeneralIO as P21;
  provides interface GeneralIO as P22;
  provides interface GeneralIO as P23;
  provides interface GeneralIO as P24;

  provides interface Init;
}

implementation {
#define MAKE_NEW_PIN(name, pin, pin_dir, pin_dir_bit) \
  inline async command bool name.get()        { return ( pin != 0); } \
  inline async command void name.set()        { pin = 1; } \
  inline async command void name.clr()        { pin = 0; } \
  async command void        name.toggle()     { atomic { pin = ~pin; } } \
  inline async command bool name.isInput()    { IS_IO_PIN_INPUT(pin_dir, pin_dir_bit); } \
  inline async command bool name.isOutput()   { IS_IO_PIN_OUTPUT(pin_dir, pin_dir_bit); } \
  inline async command void name.makeInput()  { MAKE_IO_PIN_INPUT (pin_dir, pin_dir_bit); } \
  inline async command void name.makeOutput() { MAKE_IO_PIN_OUTPUT(pin_dir, pin_dir_bit); }

  // The syntax for defining the sbit (bit accessible registers) is
  // compiler specfic, but the usage should be compiler independant

  MAKE_NEW_PIN(P00, P0_0, P0_DIR, 0);
  MAKE_NEW_PIN(P01, P0_1, P0_DIR, 1);
  MAKE_NEW_PIN(P02, P0_2, P0_DIR, 2);
  MAKE_NEW_PIN(P03, P0_3, P0_DIR, 3);
  MAKE_NEW_PIN(P04, P0_4, P0_DIR, 4);
  MAKE_NEW_PIN(P05, P0_5, P0_DIR, 5);
  MAKE_NEW_PIN(P06, P0_6, P0_DIR, 6);
  MAKE_NEW_PIN(P07, P0_7, P0_DIR, 7);

  MAKE_NEW_PIN(P10, P1_0, P1_DIR, 0);
  MAKE_NEW_PIN(P11, P1_1, P1_DIR, 1);
  MAKE_NEW_PIN(P12, P1_2, P1_DIR, 2);
  MAKE_NEW_PIN(P13, P1_3, P1_DIR, 3);
  MAKE_NEW_PIN(P14, P1_4, P1_DIR, 4);
  MAKE_NEW_PIN(P15, P1_5, P1_DIR, 5);
  MAKE_NEW_PIN(P16, P1_6, P1_DIR, 6);
  MAKE_NEW_PIN(P17, P1_7, P1_DIR, 7);

  MAKE_NEW_PIN(P20, P2_0, P2_DIR, 0);
  MAKE_NEW_PIN(P21, P2_1, P2_DIR, 1);
  MAKE_NEW_PIN(P22, P2_2, P2_DIR, 2);
  MAKE_NEW_PIN(P23, P2_3, P2_DIR, 3);
  MAKE_NEW_PIN(P24, P2_4, P2_DIR, 4);

  /* Configure all I/O pins as input */
  command error_t Init.init() {
    P0_DIR = 0;
    P1_DIR = 0;
    P2_DIR = 0;
  }
}
