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

module LocalTime32khz16P {
	provides {
		interface Init;
		interface LocalTimeExtended<T32khz, local_time16_t> as LocalTime;
	}
	uses interface Counter<T32khz, uint16_t>;
}
implementation {
	local_time16_t g;
	
	void swap(local_time16_t* t1, local_time16_t* t2) {
		local_time16_t* temp;
		temp = t2;
		t2 = t1;
		t1 = temp;
	}
	
	command error_t Init.init() {
		memset(&g, 0, sizeof(g));
		return SUCCESS;
	}
	
	async command local_time16_t LocalTime.getNow() {
		atomic {
			g.sticks = call Counter.get();
  			return g;
  		}
  	}
  	
  	async command local_time16_t LocalTime.add(local_time16_t* t1, local_time16_t* t2) {
  		local_time16_t added;
  		uint32_t sticks = (uint32_t)t1->sticks + (uint32_t)t2->sticks;

  		added.mticks = t1->mticks + t2->mticks;
  		if(sticks > 0xFFFFL)
  			added.mticks++;
  		added.sticks = sticks & 0xFFFFL;
  		
  		return added;
  	}
  	
  	async command local_time16_t LocalTime.sub(local_time16_t* t1, local_time16_t* t2) {
  		local_time16_t gt;
  		//Swap to make sure that t2 is greater than t1 for calcualtions below
  		if(t2->mticks < t1->mticks)
  			swap(t2,t1);
  		if(t2->sticks >= t1->sticks) {
  		  	gt.mticks = t2->mticks - t1->mticks;
  			gt.sticks = t2->sticks - t1->sticks;
  		}
  		else if(t2->mticks == t1->mticks && t2->sticks > t1->sticks) {
  			gt.mticks = 0;
  			gt.sticks = t2->sticks - t1->sticks;
  		}
  		else {
  			gt.mticks = t2->mticks - t1->mticks - 1;
  			gt.sticks = t1->sticks - t2->sticks;
  		}
  		return gt;
  	}
  	
  	async command int8_t LocalTime.compare(local_time16_t* t1, local_time16_t* t2) {
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
  	
  	async command bool LocalTime.lessThan(local_time16_t* t1, local_time16_t* t2) {
  		return (t1->mticks < t2->mticks) || (t1->mticks == t2->mticks && (t1->sticks < t2->sticks));
//  		return call LocalTime.compare(t1, t2) == -1;
  	}
  	
  	async command bool LocalTime.greaterThan(local_time16_t* t1, local_time16_t* t2) {
  		return call LocalTime.compare(t1, t2) == 1;
  	}

  	async command bool LocalTime.equal(local_time16_t* t1, local_time16_t* t2) {
  		return call LocalTime.compare(t1, t2) == 0;
  	}

  	async event void Counter.overflow() {
 		atomic g.mticks++;
 	}
}
