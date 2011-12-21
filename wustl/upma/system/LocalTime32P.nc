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

generic module LocalTime32P(typedef counter_t) @safe() {
	provides {
		interface Init;
		interface LocalTimeExtended<counter_t, local_time32_t> as LocalTime;
	}
	uses interface Counter<counter_t, uint32_t>;
}
implementation {
	local_time32_t g;
	
	void swap(local_time32_t* t1, local_time32_t* t2) {
		local_time32_t* temp;
		temp = t2;
		t2 = t1;
		t1 = temp;
	}
	
	command error_t Init.init() {
		memset(&g, 0, sizeof(g));
		return SUCCESS;
	}
	
	async command local_time32_t LocalTime.getNow() {
		atomic {
			g.sticks = call Counter.get();
  			return g;
  		}
  	}
  	
  	async command local_time32_t LocalTime.add(local_time32_t* t1, local_time32_t* t2) {
  		local_time32_t added;
  		uint64_t sticks = (uint64_t)t1->sticks + (uint64_t)t2->sticks;

  		added.mticks = t1->mticks + t2->mticks;
  		if(sticks > 0xFFFFFFFFL)
  			added.mticks++;
  		added.sticks = sticks & 0xFFFFFFFFL;
  		
  		return added;
  	}
  	
  	async command local_time32_t LocalTime.sub(local_time32_t* t1, local_time32_t* t2) {
  		local_time32_t gt;
  		//Swap to make sure that t2 is greater than t1 for calcualtions below
  		if( call LocalTime.lessThan(t2, t1) )
  			swap(t2, t1);
  		
  		if(t2->sticks >= t1->sticks) {
  			gt.mticks = t2->mticks - t1->mticks;
  			gt.sticks = t2->sticks - t1->sticks;
  		}
  		else {
  			gt.mticks = t2->mticks - t1->mticks - 1;
  			gt.sticks = 65536UL - t1->sticks + t2->sticks;
  		}
  		return gt;
  		// Fix thanks to Andrew Keating
	}
	
	async command int8_t LocalTime.compare(local_time32_t* t1, local_time32_t* t2) {
		if(t2->mticks < t1->mticks)
			return 1;
		else if(t2->mticks > t1->mticks)
			return -1;
		else if(t2->sticks < t1->sticks)
			return 1;
		else if(t2->sticks > t1->sticks)
			return -1;
		else
			return 0;
  	}
  	
  	async command bool LocalTime.lessThan(local_time32_t* t1, local_time32_t* t2) {
  		return (t1->mticks < t2->mticks) || (t1->mticks == t2->mticks && (t1->sticks < t2->sticks));
//  		return call LocalTime.compare(t1, t2) == -1;
  	}
  	
  	async command bool LocalTime.greaterThan(local_time32_t* t1, local_time32_t* t2) {
  		return call LocalTime.compare(t1, t2) == 1;
  	}

  	async command bool LocalTime.equal(local_time32_t* t1, local_time32_t* t2) {
  		return call LocalTime.compare(t1, t2) == 0;
  	}
  	
  	async event void Counter.overflow() {
 		atomic g.mticks++;
 	}
}
