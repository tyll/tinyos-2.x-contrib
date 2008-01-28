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

#include "PowCon.h"
#include "Tnbrhood.h"

module PowConP {
  provides { 
    interface PowCon[uint8_t id];
    interface PowConQS;
    interface SplitControl;
    }
  uses {
    interface Leds;
    interface Wakker;
    interface Tsync;
    interface Random;
    interface SplitControl as AMControl;
    }
  }

implementation {
  powsched client[WAKE_slots];      // contains powsched for active clients
  uint8_t  ids[WAKE_slots];         // used to remember identities after sort
  uint8_t  priorityIds[WAKE_slots]; // used for priority scheduling
  uint16_t offset;
  uint16_t fireOffset;   // used within a firing event to sequence clients 
  uint8_t fireClient = WAKE_slots;  // client number in sequence of firings
  bool gotSync = FALSE;  // False until global clocks are synchronized 
  bool forceOn = TRUE;   // initially True; also by forceOn() command 
  bool powerOn = FALSE;   // initially, radio is off
  bool IOpending = FALSE;  // and no messages in transit
  bool initialized = FALSE;  // and even AMControl has not been called 
  uint8_t slots = 0;
  
  // a pseudo-LCM function, finds smallest value z such that
  // z >= y, and z = k*x for some value k  
  uint16_t pLCM(uint16_t x, uint16_t y) {
     uint16_t k = y/x; 
     while (TRUE) {  // this had better terminate! 
        if (k*x == y) return y; y++;
        }
     return 0;  // to make compiler happy
     }

  // sort the client table in increasing order of periods
  void sortClients() {
     uint8_t i,j;
     if (!slots) return;
     for (i=0;i<slots-1;i++) 
        for (j=i+1;j<slots;j++) {
           if ( client[j].period<client[i].period ) { 
              powsched s;
              uint8_t b;
              s = client[j]; client[j] = client[i]; client[i] = s;
              b = ids[j]; ids[j] = ids[i]; ids[i] = b;
              }
           }
     }

  // return current maximum period for all clients
  command uint16_t PowCon.maxPeriod[uint8_t id]() {
     uint16_t r = NORM_WAIT;  // default value to return
     uint8_t i,j;
     if (!slots) return r;
     for (i=0;i<slots;i++)
       r = ( client[i].period > r ) ? client[i].period : r;
     return r;
     }

  // sort priorities, given the sorted client powsched array & id array
  void sortPriorities() {
     uint8_t i,j;
     if (!slots) return;
     for (i=0;i<slots-1;i++) 
        for (j=i+1;j<slots;j++) {
           if ( client[j].priority<client[i].priority ) { 
              powsched s;
              uint8_t b;
              s = client[j]; client[j] = client[i]; client[i] = s;
              b = ids[j]; ids[j] = ids[i]; ids[i] = b;
              }
           }
     for (i=0;i<slots;i++) priorityIds[i] = ids[i];  // remember the result
     // => priorityIds is list of Ids, in increasing order by priority
     }

  // provide initialization and power-control of radio
  command error_t SplitControl.start() { 
     powerOn = TRUE;
     return call AMControl.start(); 
     }
  event void AMControl.startDone( error_t r ) { 
     if (!initialized) {
        signal SplitControl.startDone(r);
	initialized = TRUE;  // optimistic -- what happens if r is FAIL?
	return;
	}
     }
  command error_t SplitControl.stop() { }
  event void AMControl.stopDone( error_t r ) { 
     powerOn = FALSE;  // maybe that is wrong if r != SUCCESS ... 
     }

  // task to set up client activity 
  task void fire() {  // implicit parameters:  fireOffset, fireClient
     uint8_t i;
     while (fireClient < slots) { // handle first/next client
        uint16_t a;
        if (!powerOn) { 
	   // if power is not on yet, the best ideas is to 
	   // schedule that to occur in 126 milliseconds:  
	   // that will turn on the power just 2 milliseconds 
	   // before the next "Wakker" unit (1/8 sec)
	   // UNFORTUNATELY, I couldn't reliably get TinyOS to
	   // schedule this so tightly, hence, just call AMControl.start:
           call AMControl.start(); 
           powerOn = TRUE;
	   }
        // lookup index of first/next client, by priority 
        for (i=0;i<slots;i++) if (priorityIds[fireClient] == ids[i]) break;
        if (i >= slots) return;   // should never occur
        a = fireOffset % client[i].period;  // integral with client?  
        if (a == 0) { // this client can be activated now 
           signal PowCon.wake[ids[i]]();
           call Wakker.soleSet(1,client[i].livetime);
           fireClient++;
           return;
           }
        fireClient++;
        }
     // here is where one could power-down the radio
     if (!forceOn) if (!IOpending) call AMControl.stop();
     for (i=0;i<WAKE_slots;i++) signal PowCon.idle[i]();
     } 

  // Set first/next wakeup time
  //   Note:  this could be called even while a firing sequence
  //   is active, so be careful to call Wakker.clear() before
  //   invoking setWakeup()
  // Results:  fire posted;  offset adjusted;  
  //           soleSet(0) for periodWake() scheduled so that
  //           the next iteration of setWakeup will occur
  void setWakeup() {
     uint32_t x;
     uint16_t m, n;

     // test for cycle just completed -- in that case, a new major
     // cycle begins again
     if (!slots) return;
     if (offset >= client[slots-1].period) offset = 0; 

     // isolate the following cases (1)--(5):  
     // let m = clock % maxperiod, let n = clock % minperiod
     // 1.  offset == 0 && m is approximately zero
     //     =>  pretend clock % maxperiod is zero, so next 
     //         offset += minperiod, but wait time is    
     //         minperiod - m;  fire as if m were zero
     // 2.  offset == 0 && m is approximately maxperiod 
     //     =>  leave offset alone, wait time is 
     //         maxperiod - m
     // 3.  offset == k*minperiod & n is approx zero
     //     =>  pretend clock % minperiod is zero, so next
     //         offset = minperiod * (1 + m/minperiod), 
     //         and the wait time is minperiod - n;  
     //         fire as though n were zero
     // 4.  offset == k*minperiod & n is approx minperiod 
     //     =>  leave offset alone, wait time is 
     //         minperiod - n
     // 5.  offset == k*minperiod but none of the above hold
     //     =>  wait for minperiod - n, but make offset 
     //         the rounded up value of m, that is 
     //         offset = minperiod * (1 + m/minperiod)

     x = call Wakker.clock();  //  x is current alarm clock
     m = x % client[slots-1].period;  
     if (offset == 0) {
        if (m < 8) {  // case 1. above
           fireOffset = 0; 
           if (fireClient >= slots) {
              fireClient = 0;
              post fire();
              }
           call Wakker.soleSet(0,client[0].period-m);    
           offset = client[0].period;  
           return;
           }
	if (m > client[slots-1].period - 8) { // case 2 above
           call Wakker.soleSet(0,client[slots-1].period-m);    
	   return;
	   }
	}
     n = x % client[0].period;
     if (n < 8) { // case 3, above
        fireOffset = offset;
        if (fireClient >= slots) {
           fireClient = 0;
           post fire();
           }
        call Wakker.soleSet(0,client[0].period-n);    
        offset = client[0].period * (1 + m/client[0].period);
        return;
        }
     if (n > client[0].period - 8) { // case 4 above
        call Wakker.soleSet(0,client[0].period-n);    
        return;
        }
     // case 5 is the remaining action
     call Wakker.soleSet(0,client[0].period-n);
     offset = client[0].period * (1 + m/client[0].period);
     }

  // wake up at prescribed minimum cycle period interval 
  task void periodWake() {
     setWakeup();     // handled above
     }

  command void PowCon.restart[uint8_t id] () {
     powsched w;
     uint16_t totlive, minper;
     uint8_t i;

     // first, kill any current alarm 
     call Wakker.clear();   // remove all my Wakker settings

     // signal each client to solicit period 
     for (i=slots=0;i<WAKE_slots;i++) { 
        signal PowCon.supply[i](&w);
        if (w.period != 0 && w.livetime != 0) { 
	   // client is requesting a period/livetime
           client[slots] = w;
           ids[slots] = i;
           slots++;
           }
        }
     if (!slots) return;

     // convert any 0xffff value into the minimum period length
     for (i=0,minper=0xffff;i<slots;i++) 
        minper = (minper > client[i].period) ? client[i].period : minper; 
     for (i=0;i<slots;i++)  
        client[i].period = 
           (client[i].period == 0xffff) ? minper : client[i].period;

     // calculate total livetime possible for a period that includes
     // all clients sequentially executed
     for (i=totlive=0;i<slots;i++) totlive += client[i].livetime;

     // then ensure that each client period is big enough to handle
     // all the clients running in that period
     for (i=0;i<slots;i++) 
        if (totlive > client[i].period) 
           client[i].period = totlive;

     // fit all periods to the smallest one 
     sortPriorities();  // obtain sort by priorities 
     sortClients();     // then sort by period-length values
                        // so that next step will make sense
     if (slots > 1) for (i=1;i<slots;i++)
        // adjust every period to be multiple of least period length
        client[i].period = pLCM(client[0].period,client[i].period);

     // now start the major cycle
     offset = 0;      
     fireClient = slots;  // fire-next client back to initial position
     setWakeup();
     }

  // produce a random delay amount
  command uint8_t PowCon.randelay[uint8_t id]() {
     return  (call Random.rand16()) % EXCHANGE_INTERVAL;
     }

  // this will also turn radio on, eventually
  command void PowCon.forceOn[uint8_t id]() { forceOn = TRUE; } 

  // this will allow radio to be off, eventually
  command void PowCon.allowOff[uint8_t id]() { forceOn = FALSE; }

  event error_t Wakker.wakeup(uint8_t indx, uint32_t wake_time) {
    switch (indx) {
      case 0: post periodWake(); break;
      case 1: post fire(); break;
      }
    return SUCCESS; 
    }

  // default events for interfaces
  default event void PowCon.wake[uint8_t id]() { }
  default event void PowCon.idle[uint8_t id]() { }
  default event void PowCon.supply[uint8_t id]( powschedPtr p ) { }

  // what to do when Tsync says things are synchronized
  event void Tsync.synced() { // clock sync event
     #ifdef POWCON
     forceOn = FALSE;   //  sync means we can try power control
     #endif
     }
  
  // interface commands for PowConQS -- provided for the 
  // AMSend wrapper, PowAMSend
  command bool PowConQS.status() { return powerOn; }
  command void PowConQS.setIOPending(bool t) { IOpending = t; }
  command void PowConQS.startPowerDown() { call AMControl.stop(); }
  }
