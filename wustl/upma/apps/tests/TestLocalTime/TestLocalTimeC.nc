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

#include "LocalTimeExtended.h"

module TestLocalTimeC {
  uses interface LocalTimeExtended<T32khz, local_time16_t> as LocalTime;
  uses interface Boot;
  uses interface Timer<TMilli>;
}
implementation
{
  local_time16_t t1, t2, t3;

  event void Boot.booted()
  {
  	t1 = call LocalTime.getNow();
    call Timer.startOneShot( 5120 );
  }

  event void Timer.fired()
  {
  	t2 = call LocalTime.getNow();
  	t3 = call LocalTime.sub(&t1, &t2);
  	printf("Time sticks: %u\n", t1.sticks);
  	printf("Time mticks: %lu\n", t1.mticks);
  	printf("Time sticks: %u\n", t2.sticks);
  	printf("Time mticks: %lu\n", t2.mticks);
  	printf("Time sticks: %u\n", t3.sticks);
  	printf("Time mticks: %lu\n\n", t3.mticks);
  	printfflush();
  	t1 = call LocalTime.getNow();
    call Timer.startOneShot( 5120 );  	
  }
}

