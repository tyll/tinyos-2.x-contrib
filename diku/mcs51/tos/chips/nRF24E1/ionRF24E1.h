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
 * FOR A PARTICULAR PURPOSE ARE DISCLAIMED.  IN NO EVENT SHALL STANFORD
 * UNIVERSITY OR ITS CONTRIBUTORS BE LIABLE FOR ANY DIRECT, INDIRECT,
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
 * Provide nRF24E1 specific register maps
 *
 * @author Martin Leopold <leopold@diku.dk>
 */

#ifndef _H_ionRF24E1_H
#define _H_ionRF24E1_H

// Interrupt definitions these correspond to the orriginal 8051/8052 defs.
// we use the avr like __vector_? syntax will be mangled to something
// else later for Keil:
//   void __vector_X(void) interrupt X

#define SIG_INTERRUPT0          __vector_0
#define SIG_TIMER0              __vector_1
#define SIG_INTERRUPT1          __vector_2
#define SIG_TIMER1              __vector_3
#define SIG_SERIAL              __vector_4
#define SIG_TIMER2              __vector_5
#define SIG_ADC                 __vector_8

sfr DPS __attribute((x86));
//sfr at 0x86 DPS;

sfr P0_DIR __attribute((x94));
//sfr at 0xFD P0_DIR;

sfr P1_DIR __attribute((x96));
//sfr at 0xFE P0_DIR;

sfr P0_ALT __attribute((x95));
//sfr at 0x95 P0_ALT;

sfr P1_ALT __attribute((x97));
//sfr at 0x97 P1_ALT;

sfr RADIO __attribute((xA0));
//sfr at 0xA0 RADIO;

sfr IP __attribute((xB8));
//sfr at 0xB8 IP;

sfr EIE __attribute((xE8));
//sfr at 0xE8 EIE;

sfr IE __attribute((xA8));
//sfr at 0xA8 IE;

/*  IE  */ 

sbit EA __attribute((xAF));
//sbit at IE^7 EA;

sbit ET2 __attribute((xAD));
//sbit at IE^5 ET2;

sbit ES __attribute((xAC));
//sbit at IE^4 ES;

sbit ET1 __attribute((xAB));
//sbit at IE^3 ET1;

sbit EX1 __attribute((xAA));
//sbit at IE^2 EX1;

sbit ET0 __attribute((xA9));
//sbit at IE^1 ET0;

sbit EX0 __attribute((xA8));
//sbit at IE^0 EX0;


/* RADIO */

#define SBIT_PWR_UP 0xA7
#define SBIT_DR2 0xA6
#define SBIT_CE 0xA6
#define SBIT_CLK2 0xA5
#define SBIT_DOUT2 0xA4
#define SBIT_CS 0xA3
#define SBIT_DR1 0xA2
#define SBIT_CLK1 0xA1
#define SBIT_DATA 0xA0

#endif // _H_ionRF24E1_H
