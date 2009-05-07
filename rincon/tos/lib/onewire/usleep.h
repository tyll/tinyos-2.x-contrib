/*
 * Copyright (c) 2005-2006 Rincon Research Corporation
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
 * - Neither the name of the Rincon Research Corporation nor the names of
 *   its contributors may be used to endorse or promote products derived
 *   from this software without specific prior written permission.
 *
 * THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS
 * ``AS IS'' AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT
 * LIMITED TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS
 * FOR A PARTICULAR PURPOSE ARE DISCLAIMED.  IN NO EVENT SHALL THE
 * RINCON RESEARCH OR ITS CONTRIBUTORS BE LIABLE FOR ANY DIRECT, INDIRECT,
 * INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES
 * (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR
 * SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION)
 * HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT,
 * STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE)
 * ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED
 * OF THE POSSIBILITY OF SUCH DAMAGE
 */

/***********************************************************************
 * usleep.h -- microsecond-preicision sleep
 */

#ifndef __usleep_h__
#define __usleep_h__

#ifndef CLOCK_MHZ
#error "Please define CLOCK_MHZ to be the system clock speed for usleep()"
#endif

#ifdef USLEEP_CLOCKS_PER_ITER
#undef USLEEP_CLOCKS_PER_ITER
#endif

#ifdef __MSP430__
// mspgcc-recommended delay loop
//  -- 3 clocks per iteration
static void __inline__ _usleep(register uint16_t n) {
  __asm__ __volatile__ (
			"1: \n"
			" dec %[n] \n"
			" jne 1b \n"
			: [n] "+r"(n));
}
#define USLEEP_CLOCKS_PER_ITER 3
#endif

#ifdef __AVR__
// tweaked version of _delay_loop_2 in avr/delay.h
// 4 clocks per iter
static void __inline__ _usleep(register uint16_t n) {
  __asm__ __volatile__(
		       "1: \n"
		       " sbiw %0, 1 \n" // 2
		       " brne 1b\n"     // 2/1
		       " nop \n"        // 1
		       : "=w" (n)
		       : "0" (n));
}
#define USLEEP_CLOCKS_PER_ITER 4
#endif

#ifndef USLEEP_CLOCKS_PER_ITER
#error "Please define the appropriate _usleep() routine for your platform"
#endif

#ifdef _USLEEP_FAC
#undef _USLEEP_FAC
#endif

#define _USLEEP_FAC (((double) CLOCK_MHZ) / ((double) USLEEP_CLOCKS_PER_ITER))

#define usleep(us) _usleep( (((double) (us)) * _USLEEP_FAC) )

#endif

/*** EOF usleep.h */

