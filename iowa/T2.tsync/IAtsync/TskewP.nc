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

#include "Tnbrhood.h"
#include "Beacon.h"
#include "OTime.h"

module TskewP {
  uses interface OTime;
  uses interface Wakker;
  uses interface PowCon;
  uses interface AMSend;
  uses interface Receive;
  uses interface Tnbrhood;
  uses interface Boot;
  uses interface Leds;
  }
implementation {
  float mySkew;  
  // buffer for gossip messages
  message_t msg;       
  uint8_t  roundCount;
  uint16_t frequency = SKEW_NOISE_WAIT;
  bool msgFree;
  bool started;

  /**
   * (re) Initialization. 
   */
  event void Boot.booted() {
    msgFree = TRUE;   
    started = FALSE;  // no round is active yet
    frequency = SKEW_NOISE_WAIT;  // start inactive 
    memset((uint8_t*)&msg.data, 0, sizeof(skewMsg));
    call Wakker.soleSet(1,SKEW_NOISE_WAIT); 
    call Wakker.soleSet(3,3*NORM_WAIT);
    }

  // evaluate skew wrt all neighbors
  float evalSkew() { 
    neighborPtr p,q;
    float r;
    r = -1.0;   // default is that skew not computable 
    q = call Tnbrhood.nbrTab();  // start of Neighbor table
    for (p=q;  p<q+NUM_NEIGHBORS; p++) {  // scan all neighbors
       if (!(p->mode & MODE_NORMAL)) continue;
       if (p->Id == 0) continue; 
       if (p->slope <= 0.0) continue;  
       if (p->slope > r) r = p->slope;
       }
    // r = -1.0  ==> insufficient data to compute
    // else r is maximum skew wrt any neighbor (determines my own skew)
    return r;
    }
    
  /* send a skew report message */
  task void sendTask() {
    error_t r;
    r = call AMSend.send(AM_BROADCAST_ADDR, &msg, sizeof(skewMsg));
    if (r != SUCCESS) call Wakker.soleSet(1,1);  
                           // retry soon:  somebody else had channel
    }
  // after report message sent
  event void AMSend.sendDone(message_t* s, error_t e) {
    msgFree = TRUE;
    }
  /* kick off skew report */
  void reportSkew() {
    timeSync_t now;
    skewMsg p;
    mySkew = evalSkew();   // calculate what we now find
    if (mySkew < 0.0) mySkew = 0.0;  // do not report negative skew
    // build record to transmit
    msgFree = FALSE;
    p.rootId = p.sndId = p.minId = TOS_NODE_ID;
    p.skewMin = mySkew;
    call OTime.getGlobalTime(&now);
    p.initStamp = now;
    p.seqno = 1;
    memcpy((uint8_t*)&msg.data,(uint8_t*)&p,sizeof(skewMsg));
    post sendTask();
    }
    
  /* process incoming skew report message */ 
  event message_t* Receive.receive( message_t* m, void* lp, uint8_t l ) {
    skewMsg p;  // for previously built message
    skewMsg q;  // for incoming message
    bool resend = FALSE;     // default:  no resend
    if (!started) return m;  // message received out-of-turn
    if (!msgFree) return m;   // treat as I/O error -- the incoming
       // message arrived between send and sendDone, and I am fearful
       // of changing fields in the "sent" message in this case
    memcpy((uint8_t*)&p,(uint8_t*)&msg.data,sizeof(skewMsg));
    memcpy((uint8_t*)&q,lp,sizeof(skewMsg));
    call Wakker.soleSet(2,SKEW_DIFFUSION_TIME);  // re-schedule evaluation
    if (p.sndId == 0) {  // recieved a report before we got to send one 
       // "pretend" we did send a message
       mySkew = evalSkew();  // calculate current skew estimate 
       if (mySkew <= 0.0) mySkew = 0.0; // unavailable => pretend it is zero 
       p.sndId = p.minId = TOS_NODE_ID;
       p.skewMin = mySkew;
       p.rootId = q.rootId;  // but copy new root
       p.seqno = q.seqno;    // and sequence number
       p.initStamp = q.initStamp;  // and origin time
       resend = TRUE;
       }
    // compare incoming report to previously transmitted report
    // copy lower origin time, if needed
    if (!(call OTime.lesseq(&p.initStamp,&q.initStamp))) {
       // adopt new root time, Id, seqno
       p.rootId = q.rootId;
       p.seqno = q.seqno;    
       p.initStamp = q.initStamp;  
       resend = TRUE;
       }
    // copy lower skewMin if needed
    if (q.skewMin < p.skewMin) { 
       p.skewMin = q.skewMin; 
       p.minId = q.minId;
       resend = TRUE;
       } 
    // decide whether to resend and how to schedule
    if (resend) {
       msgFree = FALSE;
       call Wakker.soleSet(1, call PowCon.randelay() );
       }
    memcpy((uint8_t*)&msg.data,(uint8_t*)&p,sizeof(skewMsg));
    return m; 
    }

  // Experimental:  offsetCheck -- scan neighborhood to see if this
  // node is running "fast" compared to all normal neighbors, and 
  // then attempt to set the clock back only in that case
  task void offsetCheck() {
    timeSync_t s;
    timeSync_t g;
    float z;
    int16_t r;
    r = call Tnbrhood.overDiff();   // get max-of-median in differences
    z = call OTime.getSkew();       // get current skew
    if (r<0 && z==0.0) { // all neighbors are behind + this node is fastest 
      r = -r;
      s.ClockH = 0;
      s.ClockL = r;
      call OTime.getGlobalOffset(&g);
      if (call OTime.lesseq(&s,&g)) {
        call OTime.subtract(&g,&s,&g);
        call OTime.setGlobalOffset(&g);
        }
      }
    call Wakker.soleSet(3,3*NORM_WAIT);
    }

  /* Evaluate results of a gossip round */
  task void evaluate() {
    skewMsg p;
    memcpy((uint8_t*)&p,(uint8_t*)&msg.data,sizeof(skewMsg));
    // check that we have some meaningful data
    if (p.sndId == 0) return; // oops, maybe try this later
    // main question:  does there exist a node with "zero" skew?
    if (p.skewMin == 0.0) {  
       // yes! so we can set skew to whatever we like
       if (mySkew > 0.0 && mySkew < 1.0)  // sanity enforced  
          call OTime.setSkew(mySkew); // sanity enforced
       }
    else {  // there exists nobody with minimum skew equal 0.0
       // if unlucky to have minimum, yet positive skew, retreat 
       if (mySkew > 0.0 && mySkew == p.skewMin) {
          float currentSkew = call OTime.getSkew();
          if (currentSkew < mySkew) mySkew = currentSkew;
          mySkew *= 0.5;  // divide in half to scale back
          call OTime.setSkew(mySkew); 
          }
       } 
    }

  event error_t Wakker.wakeup(uint8_t indx, uint32_t wake_time) {
    switch (indx) {
      case 1: post sendTask(); break; 
      case 2: post evaluate(); break; 
      case 3: post offsetCheck(); break; 
      }
    return SUCCESS;
    }

  event void PowCon.wake() { 
    if (!started) {  // start a round of skew messages, leading to evaluation 
       uint32_t clock = call Wakker.clock();
       if (clock < SKEW_NOISE_WAIT) return; // looks too early ... 
       roundCount = 0;
       started = TRUE;
       frequency = INIT_WAIT;  
       call PowCon.restart();       
       return;
       }
    // is it time to evaluate and terminate the round? 
    if (roundCount > 3) { 
       // call Wakker.soleSet(2,SKEW_DIFFUSION_TIME);  // schedule evaluation
       // former logic is this SKEW_DIFFUSION_TIME, with some good reason
       frequency = SKEW_NOISE_WAIT;  // resume inactive 
       started = FALSE;          
       call PowCon.restart();        // restart power conservation
       return;
       }
    // normal round activity:  emit a skew message
    if (roundCount == 0) reportSkew(); 
    else if (msgFree) {  // resend whatever exists in buffer
       msgFree = FALSE;
       call Wakker.soleSet(1, call PowCon.randelay() );
       }
    roundCount += 1;
    }
  event void PowCon.idle() { } // not used
  event void PowCon.supply( powschedPtr p ) {
    p->period = frequency;
    p->livetime = EXCHANGE_INTERVAL;
    p->priority = 3;     // Tskew is below Tsync, Tnbrhood in priority
    }

}
