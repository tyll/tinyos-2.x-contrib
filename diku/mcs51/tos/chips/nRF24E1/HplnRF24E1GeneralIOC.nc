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
 * @author Mikkel Jønsson <jonsson@diku.dk>
 * @author Martin Leopold <leopold@diku.dk>
 */
 
#include <io8051.h>
#include <ionRF24E1.h>

module HplnRF24E1GeneralIOC {
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
}
implementation {
#define MAKE_NEW_PIN(name, pin, pin_dir, pin_alt, pin_dir_bit) \
  inline async command bool name.get()        { return ( pin != 0); } \
  inline async command void name.set()        { pin = 1; } \
  inline async command void name.clr()        { pin = 0; } \
  async command void        name.toggle()     { atomic { pin = ~pin; } } \
  inline async command bool name.isInput()    { IS_IO_PIN_INPUT(pin_dir, pin_dir_bit); } \
  inline async command bool name.isOutput()   { IS_IO_PIN_OUTPUT(pin_dir, pin_dir_bit); } \
  inline async command void name.makeInput()  { MAKE_IO_PIN_INPUT (pin_dir, pin_dir_bit); } \
  inline async command void name.makeOutput() { pin_dir &= (0 << pin_dir_bit); pin_alt &= (0 << pin_dir_bit); pin = 0;} \

  // The syntax for defining the sbit (bit accessible registers) is
  // compiler specfic, but the usage should be compiler independant
  MAKE_NEW_PIN(P00, P0_0, P0_DIR, P0_ALT, 0);
  MAKE_NEW_PIN(P01, P0_1, P0_DIR, P0_ALT, 1);
  MAKE_NEW_PIN(P02, P0_2, P0_DIR, P0_ALT, 2);
  MAKE_NEW_PIN(P03, P0_3, P0_DIR, P0_ALT, 3);
  MAKE_NEW_PIN(P04, P0_4, P0_DIR, P0_ALT, 4);
  MAKE_NEW_PIN(P05, P0_5, P0_DIR, P0_ALT, 5);
  MAKE_NEW_PIN(P06, P0_6, P0_DIR, P0_ALT, 6);
  MAKE_NEW_PIN(P07, P0_7, P0_DIR, P0_ALT, 7);
  
  MAKE_NEW_PIN(P10, P1_0, P1_DIR, P1_ALT, 0);
  MAKE_NEW_PIN(P11, P1_1, P1_DIR, P1_ALT, 1);
  MAKE_NEW_PIN(P12, P1_2, P1_DIR, P1_ALT, 2);
}
