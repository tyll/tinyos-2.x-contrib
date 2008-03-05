/*
 * Copyright (c) 2005-2006 Intel Corporation
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

/* 
 *  @author Mirko Bordignon <mirko.bordignon@ieee.org>
 */

#ifndef ROBOSTIXTIMER_H
#define ROBOSTIXTIMER_H

#include <Timer.h>
#include <Atm128Timer.h>

/* Some types for the non-standard rates that robostix timers might be running
   at.
 */
typedef struct { } T64khz;

/* TX is the typedef for the rate of timer X, 
   ROBOSTIX_PRESCALER_X is the prescaler for timer X,
   ROBOSTIX_DIVIDER_X_FOR_Y_LOG2 is the number of bits to shift timer X by
     to get rate Y,
   counter_X_overflow_t is uint16_t if ROBOSTIX_DIVIDER_X_FOR_Y_LOG2 is 0,
     uint32_t otherwise.
*/

// default settings
#if MHZ == 16
typedef T64khz TZero;
typedef uint32_t counter_zero_overflow_t;

enum {
  ROBOSTIX_PRESCALER_ZERO = ATM128_CLK8_DIVIDE_256,
  ROBOSTIX_DIVIDE_ZERO_FOR_MILLI_LOG2 = 6,
};

#else
#error "Unknown clock rate. MHZ must be defined to one of 1, 2, 4, or 8."
#endif

enum {
  PLATFORM_MHZ = MHZ
};

#endif
