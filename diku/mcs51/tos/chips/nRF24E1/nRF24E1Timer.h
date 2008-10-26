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
 *
 * @author Mikkel Jønsson <jonsson@diku.dk>
 */

#ifndef _H_nRF24E1Timer_H
#define _H_nRF24E1Timer_H
enum {
     nRF24E1_T2CON_MODE_MASK = 0x35,
     nRF24E1_TMOD0_MODE_MASK = 0x0F, //Timer0 conf in TMOD
     nRF24E1_T0M_CKCON_MASK =  0x08,
     nRF24E1_T2M_CKCON_MASK =  0x20
     };
enum nRF24E1_timer2_prescaler_t {
     nRF24E1_TIMER2_DIV_12 = 0x00,//0x20 CKCON.5
     nRF24E1_TIMER2_DIV_4  = 0x20
};
enum nRF24E1_timer0_prescaler_t {
     nRF24E1_TIMER0_DIV_12 = 0,//0x08 CKCON.5
     nRF24E1_TIMER0_DIV_4  = 0x08
};
     
/*
Timer2 Settings 
TF2 EXF2 RCLK TCLK EXEN2 TR2 C/T2 CP/RL2
x    x    0     0    x    0    x    1   mode 1: 16-bit w. capture
x    x    0     0    x    0    x    0   mode 2: 16-bit w. auto-reaload
*/
enum nRF24E1_timer2_mode_t {
     nRF24E1_TIMER2_MODE_ARELOAD = 0x00,
     nRF24E1_TIMER2_MODE_CAPT = 0x01
};
enum nRF24E1_timer0_mode_t {
     nRF24E1_TIMER0_MODE_13B_COUNTER = 0x00,
     nRF24E1_TIMER0_MODE_16B_COUNTER = 0x01,
     nRF24E1_TIMER0_MODE_8B_ARELOAD = 0x20
};

enum {
  DEFAULT_INTERVAL = 52202U, 
  DEFAULT_SCALE = 12,
  TICKS_PER_MILIS = 1334U	// ClockTicks per millisecond
};
enum nRF24E1_timer1_baud_t {
     nRF24E1_TIMER1_BAUD_19_2 = 0xF3,
     nRF24E1_TIMER1_BAUD_9_6 = 0xE6,
     nRF24E1_TIMER1_BAUD_4_8 = 0xCC,
     nRF24E1_TIMER1_BAUD_2_4 = 0x98,
     nRF24E1_TIMER1_BAUD_1_2 = 0x30
};


#endif //_H_nRF24E1Timer_H
