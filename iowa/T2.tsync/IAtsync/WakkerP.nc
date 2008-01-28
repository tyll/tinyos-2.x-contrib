/*
* Copyright (c) 2007 University of Iowa 
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
* - Neither the name of The University of Iowa  nor the names of
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
 * Timesync suite of interfaces, components, testing tools, and documents.
 * @author Ted Herman
 * Development supported in part by NSF award 0519907. 
 */
//--EOCpr712 (do not remove this line, which terminates copyright include)

#include "OTime.h"

module WakkerP {
  provides { 
    interface Wakker[uint8_t id];
    }
  uses {
    interface OTime;
    interface Leds;
    interface Timer<TMilli> as TimerThousand;
    }
  }

implementation {
  uint32_t nextCheck;
  uint32_t theClock;
  uint32_t increment;
  sched_list schedList[ALRM_slots];

  // enum { TPS = 1048576u };

  // compute & set next wakeup time 
  //  parameter "extra" is an extra number of milliseconds to wait (for alignment)
  //  ("extra" is signed to enable adjustment forward or backward)
  void reNext(int8_t extra) {
     uint32_t smallTime = 0xffffffff;
     uint8_t i;
     for (i=0; i<ALRM_slots; i++) 
        if ((schedList+i)->wake_time < smallTime) 
                smallTime = (schedList+i)->wake_time;  
     atomic nextCheck = smallTime;
     if (nextCheck == 0xffffffff) {
        call TimerThousand.stop();
        increment = 0;  // FLAG for no waiting
        }
     else {
        int32_t s = extra;
        if (nextCheck > theClock) increment = nextCheck - theClock;
        else increment = 1;
	s += increment << 7;
        call TimerThousand.startOneShot(s);
        }
     }

  /**
   * Initializes the Wakker component.
   * @author herman@cs.uiowa.edu
   */
  command void Wakker.init[uint8_t id]() {
     uint8_t i;
     for(i=0;i<ALRM_slots;i++) 
       (schedList+i)->wake_time = 0xffffffff; 
     atomic {
        nextCheck = 0xffffffff;
        theClock = 0;
        }
     call TimerThousand.startOneShot( 1*128 );  // 1/8 of one second
     }

  /**
   * Clears out the list of Wakker events (intended mainly
   * for failure/reset).
   * @author herman@cs.uiowa.edu
   */
  command void Wakker.clear[uint8_t id]() {
     uint8_t i;
     for (i=0; i<ALRM_slots; i++)  
        if ((schedList+i)->wake_time != 0xffffffff &&
            (schedList+i)->id == id)
            (schedList+i)->wake_time = 0xffffffff;
     }

  /**
   * Clear out list of Wakker events with a particular index
   */
  command void Wakker.cancel[uint8_t id]( uint8_t indx ) {
     uint8_t i;
     for (i=0; i<ALRM_slots; i++)  
        if ((schedList+i)->wake_time != 0xffffffff &&
            (schedList+i)->id == id && 
            (schedList+i)->indx == indx)
            (schedList+i)->wake_time = 0xffffffff;
     }


  /**
   * Reads the current Wakker "clock" (1/8 seconds since initialized). 
   * @author herman@cs.uiowa.edu
   * @return Always returns current Wakker time (in 1/8 seconds) 
   */
  command uint32_t Wakker.clock[uint8_t id]() {
     uint32_t r;
     atomic r = theClock;
     return r;
     }

  /**
   * Align Wakker's "theClock" according to the Global Clock of OTime.
   */
  command void Wakker.setSync[uint8_t id]() {
     uint64_t v;
     bigClock u;
     timeSync_t p;
     uint32_t c,d, myClock;
     uint8_t i;
     int8_t adjustMilli;

     call OTime.getGlobalTime(&p);
     u.partsInt.lo = p.ClockL;
     u.partsInt.hi = p.ClockH;
     c = u.bigInt.g / (TPS/8);  // c is # 1/8 secs on global clock
     u.bigInt.g /= 1024;        // g is # binary milliseconds on global clock 
     v = (c + 1);  v *= 128;    // this is the next whole interval for 1/8s, in binary msecs
     i = (v > u.bigInt.g) ? v - u.bigInt.g : 0; 
     i = (i > 128) ? 128 : i;   // i is # milliseconds for adjustment (cap at 128 = 1/8 sec)
     i = (i == 128) ? 0 : i;    // but 128 is same as zero, perfect alignment 
     adjustMilli = (i > 63) ? -(128 - i) : i;   // go forward or backward, whichever is closer 

     atomic myClock = theClock;

     if (c > myClock) {   // advance clock
          d = c - myClock;
          for (i=0; i<ALRM_slots; i++) 
            if ((schedList+i)->wake_time != 0xffffffff) 
               (schedList+i)->wake_time += d;
          atomic theClock = c;
          reNext(adjustMilli);
          }
     else if (c < myClock) {  // backup clock
          d = myClock - c;
          for (i=0; i<ALRM_slots; i++) 
            if ((schedList+i)->wake_time != 0xffffffff) 
               (schedList+i)->wake_time -= d;
          atomic theClock = c;
          reNext(adjustMilli);
          }
     }


  /**
   * Rewinds the current Wakker "clock".
   */
  command void Wakker.rewind[uint8_t id]() {
     uint8_t i;
     uint32_t myClock;
     atomic myClock = theClock;
     for (i=0; i<ALRM_slots; i++) { 
        if ((schedList+i)->wake_time != 0xffffffff) {
           if ((schedList+i)->wake_time >= myClock)
                (schedList+i)->wake_time -= myClock;
           else (schedList+i)->wake_time = 0;
           }
        }
     atomic theClock = 0;
     reNext(0);
     }

  /**
   * Subroutine: sets the Wakker to fire at a specified Wakker time. 
   * @author herman@cs.uiowa.edu
   * @return Returns SUCCESS if alarm scheduled, otherwise FAIL 
   */
  error_t setWakker ( uint8_t id, uint8_t indx, uint32_t wake_time) {
     uint8_t i;
     for (i=0; i<ALRM_slots; i++) 
       if ((schedList+i)->wake_time == 0xffffffff) {
          (schedList+i)->wake_time = wake_time;
          (schedList+i)->indx = indx;
          (schedList+i)->id = id;
          reNext(0);
          return SUCCESS;
          }
     dbg(DBG_USR1, "*** Wakker setting failed for id %d, index %d, time %d\n",
          id, indx, wake_time);
     return FAIL;  // did not find empty slot
     }

  /**
   * Sets the Wakker to fire at a specified Wakker time. 
   * @author herman@cs.uiowa.edu
   * @return Returns SUCCESS if alarm scheduled, otherwise FAIL 
   */
  command error_t Wakker.schedule[uint8_t id] ( uint8_t indx, 
     uint32_t wake_time) {
     return setWakker(id,indx,wake_time);
     }

  /**
   * Higher overhead schedule command -- overrides existing entry
   * @author herman@cs.uiowa.edu
   * @return Returns SUCCESS if alarm scheduled, otherwise FAIL 
   */
  command error_t Wakker.soleSchedule[uint8_t id] ( uint8_t indx, 
     uint32_t wake_time) {
     uint8_t i;
     // first, kill any existing entry of same index
     for (i=0; i<ALRM_slots; i++)  
        if ((schedList+i)->wake_time != 0xffffffff &&
            (schedList+i)->id == id && 
            (schedList+i)->indx == indx) 
            (schedList+i)->wake_time = 0xffffffff;
     return setWakker(id,indx,wake_time);
     }

  /**
   * Sets the Wakker to fire at a specified delay with respect 
   * to the current Wakker time (ie 1/8 seconds since initialization). 
   * @author herman@cs.uiowa.edu
   * @return Returns SUCCESS if alarm scheduled, otherwise FAIL 
   */
  command error_t Wakker.set[uint8_t id] ( uint8_t indx, 
     uint32_t delay_time) {
     uint32_t myClock;
     atomic myClock = theClock;
     return setWakker(id,indx,(myClock+delay_time));
     }

  /**
   * Higher overhead set command -- overrides existing entry
   */
  command error_t Wakker.soleSet[uint8_t id] ( uint8_t indx, 
     uint32_t delay_time) {
     uint32_t myClock;
     uint8_t i;
     // first, kill any existing entry of same index
     for (i=0; i<ALRM_slots; i++)  
        if ((schedList+i)->wake_time != 0xffffffff &&
            (schedList+i)->id == id && 
            (schedList+i)->indx == indx) 
            (schedList+i)->wake_time = 0xffffffff;
     // rest is same as set function above
     atomic myClock = theClock;
     return setWakker(id,indx,(myClock+delay_time));
     }

  default event error_t Wakker.wakeup[uint8_t id](uint8_t indx,
     uint32_t wake_time) {
     return SUCCESS;
     }

  // Tell caller how many slots are available 
  command uint8_t Wakker.slotsAvailable[uint8_t id]() {
     uint8_t i,r = 0;
     for (i=0; i<ALRM_slots; i++)  
        if ((schedList+i)->wake_time == 0xffffffff) r++;
     return r;
     }


  task void trigger() {
     uint32_t myClock;
     uint32_t s;
     error_t r;
     uint8_t i, id, indx;
     id = 255;
     indx = 255;
     atomic myClock = theClock;

     call Leds.led0Toggle();

     // find all candidates to signal
     for (i=0; i<ALRM_slots; i++) 
       if ((schedList+i)->wake_time != 0xffffffff &&
           (schedList+i)->wake_time <= myClock) {
               s = (schedList+i)->wake_time;
               (schedList+i)->wake_time = 0xffffffff;
               id = (schedList+i)->id;
               indx = (schedList+i)->indx;
               r = signal Wakker.wakeup[id](indx,myClock);
               if (r == FAIL) { (schedList+i)->wake_time = s; break; }
               }
     reNext(0);
     }

  /**
   * Periodic firing of SysAlarm so Wakker can check for scheduled
   * events (mostly done once per second, unless Wakker gets behind
   * in its scheduling -- then it fires more often).  This event
   * signals possibly one scheduled Wakker.wakeup event, and also
   * calls SysAlarm.set for the next firing. 
   * @author herman@cs.uiowa.edu
   */
  event void TimerThousand.fired() {
     bool noTrigger;
     theClock += increment;
     noTrigger = (theClock < nextCheck);

     // call Leds.led1Toggle();

     if (noTrigger) {
        increment = nextCheck - theClock;
        call TimerThousand.startOneShot(increment);
        return;
        }

     post trigger();
     return call TimerThousand.startOneShot(128);  
     }
}
