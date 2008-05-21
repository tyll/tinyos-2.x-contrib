/* Copyright (c) 2007, Tor Petterson <motor@diku.dk>
 * All rights reserved.
 *
 * Redistribution and use in source and binary forms, with or without modification,
 * are permitted provided that the following conditions are met:
 *
 *  - Redistributions of source code must retain the above copyright notice, this
 *    list of conditions and the following disclaimer.
 *  - Redistributions in binary form must reproduce the above copyright notice,
 *    this list of conditions and the following disclaimer in the documentation
 *    and/or other materials provided with the distribution.
 *  - Neither the name of the University of Copenhagen nor the names of its
 *    contributors may be used to endorse or promote products derived from this
 *    software without specific prior written permission.
 *
 * THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS" AND ANY
 * EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED WARRANTIES
 * OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE DISCLAIMED. IN NO EVENT
 * SHALL THE COPYRIGHT OWNER OR CONTRIBUTORS BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL,
 * SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT
 * OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION)
 * HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR
 * TORT (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE,
 * EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
 */

/*
  @author Tor Petterson <motor@diku.dk>
*/

#ifndef _H_Hsc08Timer_h
#define _H_Hsc08Timer_h

enum {
  //Bits in the TPMxSC register
  HSC08TIMER_TOF = 0x80,
  HSC08TIMER_TOIE = 0x40,
  HSC08TIMER_CPWMS = 0x20,
  HSC08TIMER_CLKSB = 0x10,
  HSC08TIMER_CLKSA = 0x8,
  HSC08TIMER_PS2 = 0x4,
  HSC08TIMER_PS1 = 0x2,
  HSC08TIMER_PS0 = 0x1,
  
  //Clock source
  HSC08TIMER_CLK_OFF = 0,
  HSC08TIMER_CLK_BUS = 1,
  HSC08TIMER_CLK_FIX = 2,
  HSC08TIMER_CLK_EXT = 3,
  
  //Clock prescaler
  HSC08TIMER__CLOCKDIV_1 = 0,
  HSC08TIMER__CLOCKDIV_2 = 1,
  HSC08TIMER__CLOCKDIV_4 = 2,
  HSC08TIMER__CLOCKDIV_8 = 3,
  HSC08TIMER__CLOCKDIV_16 = 4,
  HSC08TIMER__CLOCKDIV_32 = 5,
  HSC08TIMER__CLOCKDIV_64 = 6,
  HSC08TIMER__CLOCKDIV_128 = 7,
  
  //Bits in the TPMxCnSC register
  HSC08TIMER_CHnF = 0x80,
  HSC08TIMER_CHnIE = 0x40,
  HSC08TIMER_MSnB = 0x20,
  HSC08TIMER_MSnA = 0x10,
  HSC08TIMER_ELSnB = 0x8,
  HSC08TIMER_ELSnA = 0x4,
  
  //Timer channel mode
  HSC08TIMER_M_CAP = 0,
  HSC08TIMER_M_COM = 1,
  HSC08TIMER_M_PWM = 2,
  
  //Timer pin settings
  HSC08TIMER_P_OFF = 0,
  
  //Capture mode
  HSC08TIMER_P_RISE = 1,
  HSC08TIMER_P_FALL = 2,
  HSC08TIMER_P_BOTH = 3,
  
  //Compare mode
  HSC08TIMER_P_TOGGLE = 1,
  HSC08TIMER_P_CLEAR = 2,
  HSC08TIMER_P_SET = 3,
  
  //PWM mode
  HSC08TIMER_P_HIGH = 2,
  HSC08TIMER_P_LOW = 1,
};
#endif//_H_Hsc08Timer_h