
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
 * 
 * @author Martin Leopold <leopold@polaric.dk>
 *
 */

#include <iocip51.h>
#include <io8051.h>

module Hplcip51IOC {
  provides interface Hplcip51IO as P00;
  provides interface Hplcip51IO as P01;
  provides interface Hplcip51IO as P02;
  provides interface Hplcip51IO as P03;
  provides interface Hplcip51IO as P04;
  provides interface Hplcip51IO as P05;
  provides interface Hplcip51IO as P06;
  provides interface Hplcip51IO as P07;

  provides interface Hplcip51IO as P10;
  provides interface Hplcip51IO as P11;
  provides interface Hplcip51IO as P12;
  provides interface Hplcip51IO as P13;
  provides interface Hplcip51IO as P14;
  provides interface Hplcip51IO as P15;
  provides interface Hplcip51IO as P16;
  provides interface Hplcip51IO as P17;

  provides interface Hplcip51IO as P20;
  provides interface Hplcip51IO as P21;
  provides interface Hplcip51IO as P22;
  provides interface Hplcip51IO as P23;
  provides interface Hplcip51IO as P24;
  provides interface Hplcip51IO as P25;
  provides interface Hplcip51IO as P26;
  provides interface Hplcip51IO as P27;

  provides interface Hplcip51IO as P30;
  provides interface Hplcip51IO as P31;
  provides interface Hplcip51IO as P32;
  provides interface Hplcip51IO as P33;
  provides interface Hplcip51IO as P34;
  provides interface Hplcip51IO as P35;
  provides interface Hplcip51IO as P36;
  provides interface Hplcip51IO as P37;

#ifdef __cip51_has_port4
  provides interface Hplcip51IO as P40;
  provides interface Hplcip51IO as P41;
  provides interface Hplcip51IO as P42;
  provides interface Hplcip51IO as P43;
  provides interface Hplcip51IO as P44;
  provides interface Hplcip51IO as P45;
  provides interface Hplcip51IO as P46;
  provides interface Hplcip51IO as P47;
#endif

  provides interface Init;
}

implementation {
#define MAKE_NEW_PIN(name, pin, pin_out_mode, pin_in_mode, pin_skip, pin_dir_bit) \
  inline async command bool name.get()        { return ( pin != 0); } \
  inline async command void name.set()        { pin = 1; } \
  inline async command void name.clr()        { pin = 0; } \
  async command void        name.toggle()     { atomic { pin = ~pin; } } \
  inline async command bool name.isPushPull()   { (pin_out_mode & _BV(pin_dir_bit)); } \
  inline async command bool name.isOpenDrain()  {!(pin_out_mode & _BV(pin_dir_bit)); } \
  inline async command bool name.isSkipped()    { (pin_skip    & _BV(pin_dir_bit)); } \
  inline async command bool name.isAnalogInput(){ (pin_in_mode & _BV(pin_dir_bit)); } \
  inline async command void name.skip()         {  pin_skip     |=  _BV(pin_dir_bit); } \
  inline async command void name.dontSkip()     {  pin_skip     &= ~_BV(pin_dir_bit); } \
  inline async command void name.makePushPull() {  pin_out_mode |=  _BV(pin_dir_bit); } \
  inline async command void name.makeOpenDrain(){  pin_out_mode &= ~_BV(pin_dir_bit); } \
  inline async command void name.makeAnalogInput()    { pin_in_mode  |=  _BV(pin_dir_bit); } \
  inline async command void name.disableAnalogInput() { pin_in_mode  &= ~_BV(pin_dir_bit); } 

  MAKE_NEW_PIN(P00, P0_0, P0MDOUT, P0MDIN, P0SKIP, 0);
  MAKE_NEW_PIN(P01, P0_1, P0MDOUT, P0MDIN, P0SKIP, 1);
  MAKE_NEW_PIN(P02, P0_2, P0MDOUT, P0MDIN, P0SKIP, 2);
  MAKE_NEW_PIN(P03, P0_3, P0MDOUT, P0MDIN, P0SKIP, 3);
  MAKE_NEW_PIN(P04, P0_4, P0MDOUT, P0MDIN, P0SKIP, 4);
  MAKE_NEW_PIN(P05, P0_5, P0MDOUT, P0MDIN, P0SKIP, 5);
  MAKE_NEW_PIN(P06, P0_6, P0MDOUT, P0MDIN, P0SKIP, 6);
  MAKE_NEW_PIN(P07, P0_7, P0MDOUT, P0MDIN, P0SKIP, 7);

  MAKE_NEW_PIN(P10, P1_0, P1MDOUT, P1MDIN, P1SKIP, 0);
  MAKE_NEW_PIN(P11, P1_1, P1MDOUT, P1MDIN, P1SKIP, 1);
  MAKE_NEW_PIN(P12, P1_2, P1MDOUT, P1MDIN, P1SKIP, 2);
  MAKE_NEW_PIN(P13, P1_3, P1MDOUT, P1MDIN, P1SKIP, 3);
  MAKE_NEW_PIN(P14, P1_4, P1MDOUT, P1MDIN, P1SKIP, 4);
  MAKE_NEW_PIN(P15, P1_5, P1MDOUT, P1MDIN, P1SKIP, 5);
  MAKE_NEW_PIN(P16, P1_6, P1MDOUT, P1MDIN, P1SKIP, 6);
  MAKE_NEW_PIN(P17, P1_7, P1MDOUT, P1MDIN, P1SKIP, 7);

  MAKE_NEW_PIN(P20, P2_0, P2MDOUT, P2MDIN, P2SKIP, 0);
  MAKE_NEW_PIN(P21, P2_1, P2MDOUT, P2MDIN, P2SKIP, 1);
  MAKE_NEW_PIN(P22, P2_2, P2MDOUT, P2MDIN, P2SKIP, 2);
  MAKE_NEW_PIN(P23, P2_3, P2MDOUT, P2MDIN, P2SKIP, 3);
  MAKE_NEW_PIN(P24, P2_4, P2MDOUT, P2MDIN, P2SKIP, 4);
  MAKE_NEW_PIN(P25, P2_5, P2MDOUT, P2MDIN, P2SKIP, 5);
  MAKE_NEW_PIN(P26, P2_6, P2MDOUT, P2MDIN, P2SKIP, 6);
  MAKE_NEW_PIN(P27, P2_7, P2MDOUT, P2MDIN, P2SKIP, 7);

  MAKE_NEW_PIN(P30, P3_0, P3MDOUT, P3MDIN, P3SKIP, 0);
  MAKE_NEW_PIN(P31, P3_1, P3MDOUT, P3MDIN, P3SKIP, 1);
  MAKE_NEW_PIN(P32, P3_2, P3MDOUT, P3MDIN, P3SKIP, 2);
  MAKE_NEW_PIN(P33, P3_3, P3MDOUT, P3MDIN, P3SKIP, 3);
  MAKE_NEW_PIN(P34, P3_4, P3MDOUT, P3MDIN, P3SKIP, 4);
  MAKE_NEW_PIN(P35, P3_5, P3MDOUT, P3MDIN, P3SKIP, 5);
  MAKE_NEW_PIN(P36, P3_6, P3MDOUT, P3MDIN, P3SKIP, 6);
  MAKE_NEW_PIN(P37, P3_7, P3MDOUT, P3MDIN, P3SKIP, 7);

  /* Only available on 48 pin devices */

#ifdef __cip51_has_port4
  // P4 has to be handled separately since it is not bit-adressable
  // and cannot bi skipped
  MAKE_NEW_PIN(P40, P4_0, P4MDOUT, P4MDIN, , 0);
  MAKE_NEW_PIN(P41, P4_1, P4MDOUT, P4MDIN, , 1);
  MAKE_NEW_PIN(P42, P4_2, P4MDOUT, P4MDIN, , 2);
  MAKE_NEW_PIN(P43, P4_3, P4MDOUT, P4MDIN, , 3);
  MAKE_NEW_PIN(P44, P4_4, P4MDOUT, P4MDIN, , 4);
  MAKE_NEW_PIN(P45, P4_5, P4MDOUT, P4MDIN, , 5);
  MAKE_NEW_PIN(P46, P4_6, P4MDOUT, P4MDIN, , 6);
  MAKE_NEW_PIN(P47, P4_7, P4MDOUT, P4MDIN, , 7);
#endif

  /* Configure all I/O pins as analog input (should reduce power consumption and noise) */
  command error_t Init.init() {

    // Seems to freeze the platform!?

/*     P0MDOUT = 0; */
/*     P1MDOUT = 0; */
/*     P2MDOUT = 0; */
/*     P3MDOUT = 0; */

    // Seems to freeze some times too!?
/*     P0MDIN = 0; */
/*     P1MDIN = 0; */
/*     P2MDIN = 0; */
/*     P3MDIN = 0; */

#ifdef __cip51_has_port4
    P4MDOUT = 0;
    P4MDIN = 0;
#endif

    return SUCCESS;
  }
}
