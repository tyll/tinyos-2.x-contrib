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
#include "Beacon.h"
#include "Tnbrhood.h"
#include "PowCon.h"

module TsyncP {
  provides interface Tsync;
  provides interface Boot as componentBoot;
  uses {
    interface Boot;
    interface Counter<T32khz,uint16_t>;
    interface SplitControl as AMControl;
    interface Receive as BeaconReceive;
    interface AMSend as ProbeSend;
    interface AMSend as ProbeDebug;
    // interface AMSend as BeaconSend; 
    interface TimeSyncAMSend<TMicro,uint32_t> as BeaconSend;
    interface TimeSyncPacket<TMicro,uint32_t>;
    interface PacketTimeStamp<TMicro,uint32_t>;
    interface Receive as ProbeReceive;
    interface OTime;
    interface Leds as MsgLeds;
    interface Leds;
    interface Wakker;
    interface Tnbrhood;
    interface Neighbor;
    interface PowCon;
    #ifdef DEMO_LIGHTS
    interface Leds as ShowLeds;
    #endif
    #ifdef TUART
    interface AMSend as UARTSend;
    #endif
    #ifdef TRACK
    interface StdControl as skewControl;
    #endif
    }
  }
implementation {

  /****************************************************************/
  /*                                                              */
  /*  State of Tsync:  these variables and constants govern the   */
  /*  control logic of Time Sync.  The state transition of a mote */
  /*  depends on beacons received from neighbors, which include   */
  /*  the states of those neighbors -- hence the Tnbrhood.h and   */
  /*  Tnbrhood interface are important also for the control       */
  /*  logic of Time Sync.                                         */
  /*                                                              */
  /****************************************************************/
  uint16_t frequency;   // current beacon frequency      
  int8_t  freqcount;    // only used when frequency is INIT_WAIT 
  //  the two above control the timing of Beacon firing
  uint8_t mode;        // see Tnbrhood.h for a definition of modes
  uint8_t demoCounter;  // NOT NEEDED FOR PRODUCTION VERSION
  uint8_t DEBUGCOUNT = 0;   // ### just for debugging ####

  /*---------------- end of state variables ----------------------*/

  /***** variables for processing a received beacon ***************/ 
  timeSync_t receiveTime;
  int16_t theDiff;   
  int16_t showDiff;   
  beaconMsg buf;
  bool bufFree;
  /*---------------- end of variables for received beacon --------*/

  /***** variables for responding to a probe **********************/
  message_t probeMsg;

  /***** variables for generating a beacon ************************/ 
  message_t msg;       
  bool msgFree;
  /*---------------- end of variables for generating a beacon ----*/


  /*** local function to XOR two timeSync's ***********************/
  void timeSyncXOR(timeSyncPtr a, timeSyncPtr b, timeSyncPtr c) {
    c->ClockH = a->ClockH ^ b->ClockH;
    c->ClockL = a->ClockL ^ b->ClockL;
    }

  /*** task to initialize variables, signal other components to init ***/
  task void allInit() {
    call Wakker.init();             // tell Wakker to start first
    call OTime.init();              // and then OTime is second;
    signal componentBoot.booted();  // then tell all other components to start
    theDiff = 0;
    demoCounter = 0; 
    bufFree = msgFree = TRUE;
    frequency = INIT_WAIT;    
    freqcount = INIT_COUNT; 
    mode = MODE_RECOVERING + MODE_EVALUATE;
    call Neighbor.regist(NORM_WAIT);
    call PowCon.forceOn();  
    call Wakker.clear();
    call PowCon.restart();   // this will schedule main task 
    }

  /*** After mote boots, wait for Radio services to start *********/
  event void Boot.booted() {
    error_t r = call AMControl.start();
    if (r == EALREADY) { post allInit(); } // bypass startDone
    // here, one could test for EBUSY and set a timer;  but it's
    // unclear that wait & retry would be a solution.
    }
  event void AMControl.startDone(error_t e) {
    // ignore e, because there is no recourse for failure here
    post allInit();
    }
  event void AMControl.stopDone(error_t e) { }

  /***** Evaluate results of recovery beacon period ***************/
  task void evaluate() {
    if (mode & MODE_NORMAL) return;
    msgFree = bufFree = TRUE;
    #ifdef TRACK
    { uint8_t b;
    timeSync_t t, v, w;
    b = call Tnbrhood.getMaxDisplacement(&t);
    if (b != 0) {
        // check if maxdisplacement is in the "future" 
        call OTime.pubLocalTime(&v);  // get skew-adjusted local time
        call OTime.add(&v,&t,&w);    // w is conjectured maximum
        call OTime.conv1LocalTime(&v);  // now v is curr global time
        // adopt new time if larger than what we now have
        if (call OTime.lesseq(&v,&w)) call OTime.setGlobalOffset(&t); 
        }
    }
    #endif
    mode = MODE_NORMAL;           // enforce Invariant:  normal after evaluate 
    call Tnbrhood.setMode(mode);  // Tnbrhood also needs this
    }

  /***** build a basic beacon message *****************************/ 
  uint32_t buildBeacon( beaconMsgPtr p ) {  // note: p may be unaligned
    beaconMsg bMsg;
    timeSync_t genTime;
    uint32_t stamptime;
    bMsg.mode = mode;
    bMsg.NbrSize = call Tnbrhood.Nsize();
    bMsg.sndId = TOS_NODE_ID;
    bMsg.prevDiff = showDiff;
    showDiff = 16000 + DEBUGCOUNT;
    call OTime.pubLocalTime( &genTime );
    stamptime = call OTime.getStableMicro32();
    bMsg.Local = genTime;
    call OTime.conv1LocalTime( &genTime );   
    bMsg.Virtual = genTime;
    timeSyncXOR(&bMsg.Local,&bMsg.Virtual,&bMsg.Xor);
    memcpy((uint8_t*)p,(uint8_t*)&bMsg,sizeof(beaconMsg));
    return stamptime;
    }

  /***** Generate a beacon ****************************************/ 
  task void genBeacon() {
    uint32_t stamptime;
    error_t r;
    // cases for skipping the beacon this time
    if (TOS_NODE_ID == 0 || !msgFree) return;
    call MsgLeds.led0Toggle();
    msgFree = FALSE;
    stamptime = buildBeacon((beaconMsgPtr)&msg.data); 
    r = call BeaconSend.send(AM_BROADCAST_ADDR, 
                             &msg, sizeof(beaconMsg), stamptime); 
    if (r != SUCCESS) { 
       call Wakker.soleSet(1,1);  // retry soon:  somebody else had channel
       msgFree = TRUE; 
       return;
       }
    }

  #if defined(DEMO_LIGHTS) 
  /**
   * Das BlinkenLightsUndGeLuidZettenDemoTasks
   */
  task void showDemo() {
    call ShowLeds.led0On();
    call ShowLeds.led1On();
    call ShowLeds.led2On();
    call Wakker.soleSet(4,8);
    }
  task void showDemoOff() {
    call ShowLeds.led0Off();
    call ShowLeds.led1Off();
    call ShowLeds.led2Off();
    if (demoCounter > 0) {
       demoCounter--;
       call Wakker.soleSet(3,8);
       }
    }
  /***** Demo Routine (just for show) **************************/
  void doDemo() {
    demoCounter = 4;
    call Wakker.soleSet(3,2);
    }
  #endif

  /**
   * Tsync's main task: schedules, by PowCon wakeup, 
   * beacon and demo tasks 
   */
  task void mainTask() {
    uint8_t i;

    // test for completion of the initial phase
    if (frequency < NORM_WAIT) {
       freqcount--;
       if (freqcount >= 0) { 
          call Wakker.soleSet(1,1);   // wait 1/8 second
          return;
          }
       frequency = NORM_WAIT;
       call PowCon.restart();
       return;
       }

    if ((mode & MODE_RECOVERING)) post evaluate(); 

    // schedule a beacon to be sent
    i = call PowCon.randelay();
    if (i == 0) post genBeacon();
    else call Wakker.soleSet(1,i);  
 
    // don't try fancy stuff until in normal mode
    if ((!mode & MODE_NORMAL)) return; 

    // check for first-time synchrony 
    if ( !(mode & MODE_GOTSYNC) ) {
       uint16_t x = (theDiff < 0) ? -theDiff : theDiff; 
       uint8_t n = call Tnbrhood.Nsize();
       if ( (n > 0) && 
            (((uint32_t)x) <= (uint32_t)NORM_WAIT*MAX_DRIFT) && 
	    (x != 32767) ) {
          mode |= MODE_GOTSYNC;
          call Wakker.setSync();   // align the alarm service
          #if defined(POWCON)
          call Neighbor.fix();     // temporarily fix the current set of neighbors
          #endif
          signal Tsync.synced();   // inform users of being synced 
          }
       }
    else call Wakker.setSync();   // realign alarm service, if needed 

    #if defined(DEMO_LIGHTS) 
    doDemo();  // show some synchronized behavior in demo 
    #endif
    }

  /***** Calculate truncated difference between two times *********/ 
  int16_t delta ( timeSyncPtr p, timeSyncPtr q ) {
    timeSync_t t;
    if (call OTime.lesseq(q,p)) { 
       call OTime.subtract(p,q,&t);
       if (t.ClockH != 0 || t.ClockL > 32767u) return 32767;
       else return (int16_t)((uint16_t)t.ClockL);
       }
    else {  
       call OTime.subtract(q,p,&t);
       if (t.ClockH != 0 || t.ClockL > 32767u) return -32767;
       else return -(int16_t)((uint16_t)t.ClockL);
       }
    }

  /***** record (for skew) incoming beacon if it is sane **********/ 
  int8_t saneRecord( beaconMsgPtr q, timeSyncPtr loc ) {
    // loc should be local Clock corresonding to arrival time of q
    // hidden parameter:  theDiff should have been calculated for q
    // return -1 for non-normal neighbor, insane value, or table full
    // return 0 for normal neighbor who cannot be processed 
    // return 1 for normal, sane, bidirectional in-table neighbor
    #if !defined(TRACK) 
     // this recording step really has no effect for non-tracking style
     call Tnbrhood.record(q->mode,loc,&q->Local,&q->Virtual,theDiff,q->sndId);
     if (q->mode & MODE_NORMAL) return 1;
     else return -1;  // consider anyone to be a neighbor
    #else 
    neighborPtr n;
    uint16_t x;
    uint8_t age;
    /*   Step 1:  record the beacon   */
    call Tnbrhood.record(q->mode,loc,&q->Local,&q->Virtual,theDiff,q->sndId);

    age = call Tnbrhood.age( q->sndId, loc );  
          // get approximate length of time between beacons
    if (age == 0) age = 1;
    n = call Tnbrhood.findNbr( q->sndId );
    if (n == NULL) // maybe this was the first time for a neighbor
       n = call Tnbrhood.findNbr( q->sndId );  // try again
    if (n == NULL) return -1;    // failure to record => table full

    // decide about how to classify the beacon  
    x = (theDiff < 0) ? -theDiff : theDiff; 
    if (x >= 32767u) return -1;

    if (x <= SANE_JIFFIES) {  // within few jiffies automatically sane
      if (n->mode & MODE_BIDIRECTIONAL) return 1;
      return 0; 
      }

    // not within SANE_JIFFIES, but maybe OK:
    // now "age" is interval so we can check if x exceeds reasonable value
    if (age >= 32768u/SKEW_PU) return -1;
    if (x > age*SKEW_PU) return -1;
    if (n->mode & MODE_BIDIRECTIONAL) return 1;
    return 0; 
    #endif
    }

  /***** Process a beacon message (adjust & control) **************/ 
  //
  //  MISSING:  - logic to handle feed from GPS
  //            - logic to permanently fail (too many spontaneous
  //                       restarts in a short period, or failing
  //                       some explicit calculational challenge)
  //            - how to handle clock rollover (though maybe that
  //                       could entirely be contained in OTime)
  //
  task void fileBeacon() { 
    #ifdef TRACK
    neighborPtr p;
    uint16_t otherId;
    #endif
    timeSync_t saveLocal;
    timeSync_t workTime;
    beaconMsgPtr q = &buf;
    uint8_t Nsize;

    // call MsgLeds.led0Toggle();

    if (mode & MODE_DISCARD) { // Oops ... clock has been reset.
      mode &= ~MODE_DISCARD;   // don't forget: remove discard bit
      return (void)(bufFree = TRUE); 
      }

    // for experiments, reject some addresses
    if (!(call Neighbor.allow(q->sndId))) return (void)(bufFree = TRUE);

    saveLocal = receiveTime;
    call OTime.conv2LocalTime( &receiveTime );  // Global Time when recvd

    // calculate difference between beacon and our global times
    showDiff = theDiff = delta( &q->Virtual, &receiveTime );

    // for convenience, obtain current Nsize here
    Nsize = call Tnbrhood.Nsize(); 

    // ensure that this message contributes to neighborhood health
    call Neighbor.received(q->sndId);  // COULD BE MORE STRICT:
     // that is, one could consider reception for the purpose
     // of neighborhood evaluation to be only sane values, which
     // would de-link them eventually;  just a thought for now.

    /****************************************************************/
    /* case:  mode is non-normal (recovering)                       */
    /****************************************************************/
    if (mode & MODE_RECOVERING) {
       // record theDiff, who sent, and VClock when received
       // --- from anybody, since we are recovering
       #if !defined(TRACK)  
       // in non-tracking version, just copy larger time
       // from any normal node within hearing range
       if (q->mode & MODE_NORMAL) {
          if (call OTime.lesseq(&q->Virtual,&receiveTime))  
             return (void)(bufFree = TRUE); 
          call OTime.subtract(&q->Virtual,&receiveTime,&workTime);
          call OTime.adjGlobalTime( &workTime );
          }
       else return (void)(bufFree = TRUE); 
       #else
       // in tracking version, save up all the values and 
       // evaluate later 
       call Tnbrhood.record(q->mode, &saveLocal, &q->Local, 
                            &q->Virtual, theDiff, q->sndId); 
       return (void)(bufFree = TRUE); 
       #endif
       }

    /****************************************************************/
    /* case:  mode is normal (not recovering)                       */
    /****************************************************************/
    if (!(mode & MODE_NORMAL)) return (void)(bufFree = TRUE); 

    // find out who sent beacon (if anyone) and determine if it 
    // looks like a reasonably sane value for VClock, record it if
    // so, then consider clock adjustment to incoming beacon
    switch ( saneRecord(q,&saveLocal) ) {

      /*** insane beacon values or a recovering neighbor ***********/
      case -1: 
               // consider being at least be helpful by increasing
               // the frequency of beaconing
               if (q->mode & MODE_RECOVERING) {  
	          #if !defined(POWCON)
                  frequency = INIT_WAIT;        // time for "helping" 
                  freqcount = INIT_COUNT;
                  call PowCon.forceOn();  // abandon power schedule
                  call PowCon.restart();  // restart the schedule
                  call Wakker.clear();          // clearing Wakker could
		  #endif
                  msgFree = bufFree = TRUE;     // require msgFree 
                                                // and bufFree reset
                  // WARNING WARNING PREVIOUS STMT COULD BE A BUG!!!
		  // (because some scheduled activity is manipulating
		  //  the buffers ... oh well)
                  return;
                  }
              
               #if !defined(TRACK) 
               // in non-Tracking mode, do the simplest thing
               if (call OTime.lesseq(&q->Virtual,&receiveTime))  
                    return (void)(bufFree = TRUE); 
               call OTime.subtract(&q->Virtual,&receiveTime,&workTime);
	       #if defined(STOPJUMP)
	       if (workTime.ClockH > 0) return (void)(bufFree = TRUE);
	       if (workTime.ClockL > 10u*TPS) return (void)(bufFree = TRUE);
	       #endif
               call OTime.adjGlobalTime( &workTime );
               return (void)(bufFree = TRUE); 
               #else

               /*** if neighborhood is too small, different logic **/
               if ((call Tnbrhood.Nsize()) < 2) { 
                 // for small neighborhoods, we trust a normal neighbor
                 if (call OTime.lesseq(&q->Virtual,&receiveTime)) 
                            return (void)(bufFree = TRUE);
	         if (call Tnbrhood.suspect(q->sndId)) // skip suspect neighbor 
                    return (void)(bufFree = TRUE); 
		 // neighbor is persistent (or just starting), so be 
		 // gullible and adjust to this crazy neighbor clock
                 call OTime.subtract(&q->Virtual,&receiveTime,&workTime);
	         #if defined(STOPJUMP)
	         if (workTime.ClockH > 0) return (void)(bufFree = TRUE);
	         if (workTime.ClockL > 10u*TPS) return (void)(bufFree = TRUE);
	         #endif
                 call OTime.adjGlobalTime( &workTime );
                 return (void)(bufFree = TRUE); 
                 }

               /*** exit if not biconnected neighbor **/
               p = call Tnbrhood.findNbr(q->sndId);   
               if (!(p->mode & MODE_BIDIRECTIONAL)) { 
                  return (void)(bufFree = TRUE);  // not biconn, ignore 
                  }

               /*** remaining decisions depend on outliers *********/
               switch (call Tnbrhood.outlier(&otherId)) {
                 case  1:  /*** there is a single outlier **********/
                     if (otherId == TOS_NODE_ID) {
		        uint8_t l;
                        // my node is presumably faulty 
                        l = call Tnbrhood.getMaxDisplacement(&workTime);
                        if (l != 0) call OTime.setGlobalOffset(&workTime); 
                        break;
                        }
                     //**** here is a place to "accuse" the outlier ***
                     //  which could accelerate fault containment
                     //  The idea would be to sever this neighbor if
                     //  (1) it is repeatedly an outlier, and (2) has
                     //  itself a large neighborhood with which it agrees
                     //  -- but all of this may be too intricate for the
                     //  mote regime, so for now we just ignore the outlier.
                     //  NOTE:  experiments show this decision can partition
                     //  the network in some poorly connected cases.  Another
                     //  possibility would be to send an "accuse" message
                     //  to the outlier:  if an outlier gets repeated 
                     //  accuse nodes from normal nodes with big neighborhoods,
                     //  then maybe it's time to pay attention and adjust to
                     //  the accuser.
                     break;  
                 case  0:  /*** there is no outlier ****************/
                 case -1:  /*** there are multiple outliers ********/
                     // either for no outlier (somewhat "normal")
                     // or for multiple outliers ("chaos"), adjust 
                     // to the time in the beacon
                     if (call OTime.lesseq(&q->Virtual,&receiveTime)) break;
                     call OTime.subtract(&q->Virtual,&receiveTime,&workTime);
	             #if defined(STOPJUMP)
	             if (workTime.ClockH > 0) return (void)(bufFree = TRUE);
	             if (workTime.ClockL > 10u*TPS) 
		        return (void)(bufFree = TRUE);
	             #endif
                     call OTime.adjGlobalTime( &workTime );
                     break;
                 };
               return (void)(bufFree = TRUE); 
               #endif

      /*** sane beacon from normal neighbor ************************/
      case 1: // record theDiff, who sent, and VClock when received
               if (call OTime.lesseq(&q->Virtual,&receiveTime)) 
                  return (void)(bufFree = TRUE); 
               call OTime.subtract(&q->Virtual,&receiveTime,&workTime);
	       #if defined(STOPJUMP)
	       if (workTime.ClockH > 0) return (void)(bufFree = TRUE);
	       if (workTime.ClockL > 10u*TPS) return (void)(bufFree = TRUE);
	       #endif
               call OTime.adjGlobalTime( &workTime );
               return (void)(bufFree = TRUE); 

      #ifdef TRACK
      /*** unable to decide about a normal neighbor ****************/
      case 0: // record theDiff, who sent, and VClock when received
               if ((call Tnbrhood.Nsize()) > 1) return (void)(bufFree = TRUE); 
               // for small neighborhoods, we can trust a normal neighbor
               if (call OTime.lesseq(&q->Virtual,&receiveTime))
                  return (void)(bufFree = TRUE); 
               call OTime.subtract(&q->Virtual,&receiveTime,&workTime);
	       #if defined(STOPJUMP)
	       if (workTime.ClockH > 0) return (void)(bufFree = TRUE);
	       if (workTime.ClockL > 10u*TPS) return (void)(bufFree = TRUE);
	       #endif
               call OTime.adjGlobalTime( &workTime );
               return (void)(bufFree = TRUE); 
      #endif
      }
      bufFree = TRUE;  // shouldn't be executed.
    }

  /***** Determine receiveTime for a Beacon message ******/
  // return TRUE if the time is calculated, otherwise FALSE because
  // of rollover or some other condition
  bool calcReceiveTime(message_t* m, timeSyncPtr z) {
    timeSync_t myStamp;
    uint32_t stamptime;
    if (!bufFree) return FALSE; 
    stamptime = call TimeSyncPacket.eventTime(m); 
    if (!(call TimeSyncPacket.isValid(m))) return FALSE;
    myStamp.ClockL = call OTime.getStableMicro32();
    if (stamptime >= myStamp.ClockL) return FALSE;
    myStamp.ClockL -= stamptime;   
    myStamp.ClockH = 0;
    call OTime.getLocalTime(z);
    call OTime.subtract(z,&myStamp,z);
    return TRUE;
    }

  /***** Receive beacon & post fileBeacon to process **************/ 
  event message_t* BeaconReceive.receive(message_t* m, void* lp, uint8_t l) {
    timeSync_t w;
    if (!bufFree) return m; 
    if (!calcReceiveTime(m,&receiveTime)) return m;

    call MsgLeds.led2Toggle();
    DEBUGCOUNT++;
    showDiff = 15000 + DEBUGCOUNT;       // for display/debug 

    // check message for data errors (beyond CRC)
    memcpy((uint8_t*)&buf,lp,sizeof(beaconMsg));
    timeSyncXOR(&buf.Local,&buf.Virtual,&w);
    if (w.ClockH != buf.Xor.ClockH || 
        w.ClockL != buf.Xor.ClockL) return m;
    bufFree = FALSE;
    post fileBeacon();
    return m;
    }

  /***** Debug/Instrument:  respond to probe **********************/ 
  event message_t* ProbeReceive.receive( message_t* m, void* pl, uint8_t l ) {
    beaconProbeAck pamsg;
    beaconProbeMsg q;
    timeSync_t probeTime;
    timeSync_t stamptime;
    uint32_t current;

    if (!bufFree) return m; 
    if (!(call PacketTimeStamp.isValid(m))) return m;
    stamptime.ClockL = call PacketTimeStamp.timestamp(m);
    call OTime.getLocalTime(&probeTime);
    current = call OTime.getStableMicro32();
    if (current < stamptime.ClockL) return m;
    stamptime.ClockL = current - stamptime.ClockL;
    stamptime.ClockH = 0;
    call OTime.subtract(&probeTime,&stamptime,&probeTime);

    call MsgLeds.led1Toggle();
    memcpy((uint8_t*)&q,(uint8_t*)pl,sizeof(beaconProbeMsg));
    pamsg.mode = mode;
    pamsg.skew = call OTime.getSkew();
    pamsg.calibRatio = call OTime.calibrate();
    pamsg.count = q.count;
    pamsg.sndId = TOS_NODE_ID;
    pamsg.Local = probeTime;
    call OTime.conv2LocalTime( &probeTime );  // convert to global clock
    pamsg.Virtual = probeTime;
    memcpy((uint8_t*)&probeMsg.data,(uint8_t*)&pamsg,sizeof(beaconProbeAck));
    call ProbeSend.send(AM_BROADCAST_ADDR, &probeMsg, sizeof(beaconProbeAck));
    return m;  
    }

  event void BeaconSend.sendDone(message_t* s, error_t e) {
    #ifdef TUART
    beaconMsgPtr p = (beaconMsgPtr)&msg.data;
    buildBeacon(p);  // get fresh times (to be exact)
    if (SUCCESS == call 
      UARTSend.send(AM_UART_ADDR, &msg, sizeof(beaconMsg))) return;
    #endif
    msgFree = TRUE;
    call Neighbor.sent();  // Bug possible if UART connected! 
    }
  #ifdef TUART
  event void UARTSend.sendDone(message_t* s, error_t e) {
    msgFree = TRUE;
    }
  #endif
  event void ProbeSend.sendDone(message_t* s, error_t e) {
    }
  event void ProbeDebug.sendDone(message_t* s, error_t e) {
    }

  // these two are provided, but do nothing
  event void Neighbor.join( uint16_t Id ) { };
  event void Neighbor.leave( uint16_t Id ) { };

  event error_t Wakker.wakeup(uint8_t indx, uint32_t wake_time) {
    switch (indx) {
      case 1: post genBeacon(); break;
      #if defined(DEMO_LIGHTS)
      case 3: post showDemo(); break;
      case 4: post showDemoOff(); break;
      #endif
      }
    return SUCCESS; 
    }

  event void PowCon.wake() { post mainTask(); }
  event void PowCon.idle() { }  // not used
  event void PowCon.supply( powschedPtr p ) {
    p->period = frequency;
    p->livetime = EXCHANGE_INTERVAL;
    p->priority = 1;     // Tsync has #1 priority
    call Wakker.clear();
    }

  async event void Counter.overflow() { }
  }

