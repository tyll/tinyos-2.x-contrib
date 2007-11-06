/*
 * "Copyright (c) 2007 Washington University in St. Louis.
 * All rights reserved.
 *
 * Permission to use, copy, modify, and distribute this software and its
 * documentation for any purpose, without fee, and without written agreement is
 * hereby granted, provided that the above copyright notice, the following
 * two paragraphs and the author appear in all copies of this software.
 *
 * IN NO EVENT SHALL WASHINGTON UNIVERSITY IN ST. LOUIS BE LIABLE TO ANY PARTY
 * FOR DIRECT, INDIRECT, SPECIAL, INCIDENTAL, OR CONSEQUENTIAL DAMAGES ARISING
 * OUT OF THE USE OF THIS SOFTWARE AND ITS DOCUMENTATION, EVEN IF WASHINGTON
 * UNIVERSITY IN ST. LOUIS HAS BEEN ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
 *
 * WASHINGTON UNIVERSITY IN ST. LOUIS SPECIFICALLY DISCLAIMS ANY WARRANTIES,
 * INCLUDING, BUT NOT LIMITED TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY
 * AND FITNESS FOR A PARTICULAR PURPOSE.  THE SOFTWARE PROVIDED HEREUNDER IS
 * ON AN "AS IS" BASIS, AND WASHINGTON UNIVERSITY IN ST. LOUIS HAS NO
 * OBLIGATION TO PROVIDE MAINTENANCE, SUPPORT, UPDATES, ENHANCEMENTS, OR
 * MODIFICATIONS."
 */

/**
 *
 * @author Kevin Klues (klueska@cs.wustl.edu)
 * @version $Revision$
 * @date $Date$
 */

#ifndef LOCAL_TIME_EXTENDED_H
#define LOCAL_TIME_EXTENDED_H

#include "Timer.h"

typedef nx_struct local_time16 {
  nx_uint16_t sticks; /* s: Ticks of 16 bit counter */
  nx_uint32_t mticks; /* m: Ticks incremented upon overflow of 16 bit counter */
} local_time16_t;

typedef nx_struct local_time32 {
  nx_uint32_t sticks; /* s: Ticks of 32 bit counter */
  nx_uint32_t mticks; /* m: Ticks incremented upon overflow of 32 bit counter */
} local_time32_t;

#endif
