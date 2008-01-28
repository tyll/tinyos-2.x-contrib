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
#include "PowCon.h"

module TnbrhoodP {
  provides interface Tnbrhood;
  provides interface Neighbor[uint8_t type];
  uses interface Boot;
  uses interface OTime;
  uses interface Leds;
  uses interface Wakker;
  uses interface Random;
  #ifdef TRACK
  uses interface AMSend;
  uses interface Receive;
  uses interface PowCon;
  #endif
}
implementation
{
  uint8_t sendCount[NUM_TYPES];   // how many messages have been sent 
  uint32_t sendTime[NUM_TYPES];   // last send time for each type
  uint16_t sendFreq[NUM_TYPES];   // frequency of sending
  neighbor_t nbrTab[NUM_NEIGHBORS]; 
  uint32_t Base;    // Base is amount to add to Local time to get
                    // Virtual time, taken as the median for all 
                    // normal, bidirectional nodes in the neighborhood
  const timeSync_t ZeroTime = { 0u, 0u };
  uint8_t mode;     // current mode of this node (set by modeSet)
  bool baseBack;    // TRUE iff some neighbor's virtual clock is 
                    // less than our local time:  this implies that
                    // the entire outlier logic and Base calculation
                    // is invalid here, so don't use it.

  // buffer for heartbeat messages
  message_t msg;       
  neighborMsg nMsg;
  bool msgFree;

  /* Remove this fast implementation in favor of one that uses less
   * constant size memory (because of stupid compiler)
  // count bits in a word
  const char table[256] = { 0, 1, 1, 2, 1, 2, 2, 3, 1, 2, 2, 3, 
      2, 3, 3, 4, 1, 2, 2, 3, 2, 3, 3, 4, 2, 3, 3, 4, 3, 4, 4, 5, 1, 2, 2, 3, 
      2, 3, 3, 4, 2, 3, 3, 4, 3, 4, 4, 5, 2, 3, 3, 4, 3, 4, 4, 5, 3, 4, 4, 5, 
      4, 5, 5, 6, 1, 2, 2, 3, 2, 3, 3, 4, 2, 3, 3, 4, 3, 4, 4, 5, 2, 3, 3, 4, 
      3, 4, 4, 5, 3, 4, 4, 5, 4, 5, 5, 6, 2, 3, 3, 4, 3, 4, 4, 5, 3, 4, 4, 5, 
      4, 5, 5, 6, 3, 4, 4, 5, 4, 5, 5, 6, 4, 5, 5, 6, 5, 6, 6, 7, 1, 2, 2, 3, 
      2, 3, 3, 4, 2, 3, 3, 4, 3, 4, 4, 5, 2, 3, 3, 4, 3, 4, 4, 5, 3, 4, 4, 5, 
      4, 5, 5, 6, 2, 3, 3, 4, 3, 4, 4, 5, 3, 4, 4, 5, 4, 5, 5, 6, 3, 4, 4, 5, 
      4, 5, 5, 6, 4, 5, 5, 6, 5, 6, 6, 7, 2, 3, 3, 4, 3, 4, 4, 5, 3, 4, 4, 5, 
      4, 5, 5, 6, 3, 4, 4, 5, 4, 5, 5, 6, 4, 5, 5, 6, 5, 6, 6, 7, 3, 4, 4, 5, 
      4, 5, 5, 6, 4, 5, 5, 6, 5, 6, 6, 7, 4, 5, 5, 6, 5, 6, 6, 7, 5, 6, 6, 7, 
      6, 7, 7, 8 };  // table of # 1 bits in a byte
  uint8_t wordCount( uint8_t x ) { return table[x]; }
  */ 

  uint8_t wordCount( uint8_t x ) { 
    uint8_t r;
    r = x & 0x1; 
    if (x & 0x2) r++;
    if (x & 0x4) r++;
    if (x & 0x8) r++;
    if (x & 0x10) r++;
    if (x & 0x20) r++;
    if (x & 0x40) r++;
    if (x & 0x80) r++;
    return r;
    }

  uint8_t bitOn( uint8_t byte, uint8_t indx ) {
    return (1<<indx)&byte;
    }
  uint8_t bitSet( uint8_t byte, uint8_t indx ) {
    return (1<<indx)|byte;
    }
  uint8_t bitUnSet( uint8_t byte, uint8_t indx ) {
    return (~(1<<indx))&byte;
    }
  // calculate median of a 5-element "diffs" array
  int8_t medianFive( int8_t * b ) { 
    uint8_t i,j;
    int8_t x, c[5];
    for (i=0; i<5; i++) c[i] = b[i];
    for (i=0; i<5; i++) 
      for (j=i; j<5; j++) 
        if (c[i]<c[j]) { x = c[i]; c[i] = c[j];  c[j] = x; } 
    return c[2];   // middle of sorted array is median
    }

  // swap two byte arrays 
  void swap( char * a, char * b, int8_t n ) {
    if (a == b) return;
    while (--n >= 0) {  a[n] ^= b[n];  b[n] ^= a[n];  a[n] ^= b[n]; }
    }

  // test whether a given diff is "sane"
  bool saneDiff( int16_t diff ) { 
    return ((diff < 32760) && (diff > -32760)); }
 
  /**
   * Filter incoming message by Id of sender 
   *   
   *      ***************************************
   *      *  CHANGE ME TO GET TOPOLOGY CONTROL  *
   *      ***************************************
   */
  command bool Neighbor.allow[uint8_t type]( uint16_t addr ) {
    return TRUE;
    /* --- uncomment to implement an artificial topology 
    uint16_t d = (TOS_NODE_ID > addr) ? 
                  TOS_NODE_ID - addr : 
                  addr - TOS_NODE_ID;
    if (d<5) return TRUE; 
    if (d>=6) return FALSE;
    d = call Random.rand16();
    d &= 0x000f;  // now d in range [0,f]
    return (bool)(d<2); // 2 in 16 chance of TRUE
    */
    }

  /**
   * (re) Initialization. 
   */
  event void Boot.booted() {
    memset( sendCount, 0, NUM_TYPES );
    memset( sendTime, 0, NUM_TYPES*4 );
    memset( sendFreq, 0, NUM_TYPES*2 );
    memset( nbrTab, 0, NUM_NEIGHBORS*sizeof(neighbor_t) );
    Base = 0;       // initial guess is zero offset 
    mode = 0;     
    baseBack = FALSE;
    msgFree = TRUE;
    call Wakker.soleSet(0,HEALTH_CHECK_FREQ);   // periodic health check 
    }
  command void Tnbrhood.setMode(uint8_t m) { mode = m; }

  #ifdef TRACK
  /**** Set (Base,p->eights) for active neighborhood **************/
  void task balanceTask() {
    neighborPtr p,q;
    timeSync_t t;
    uint32_t c,x;
    int16_t d;
    uint8_t i,j,k,n;

    // Check for baseBack possible to reset
    if ((Base != 0) && baseBack) 
       for (p=nbrTab;  p<nbrTab+NUM_NEIGHBORS; p++) 
           if (p->mode & MODE_BIDIRECTIONAL)
              if (call OTime.lesseq(&p->RemoteVirtual,&p->Local))
                      return;   // sadly, baseBack still needed
    baseBack = FALSE;

    // If Base is zero, attempt to assign a base
    if (Base != 0) return;  // assume nonzero Base is OK;

    // count size of problem first (maybe it's trivial)
    for (p=nbrTab, n=0;  p<nbrTab+NUM_NEIGHBORS; p++)  
       if (p->mode & MODE_BIDIRECTIONAL) n++; 
    if (n == 0) return;   

    // Goal:  find median value for neighborhood offset
    //        do this the hard way:  sort table 
    for (p=nbrTab+NUM_NEIGHBORS-1;  p>nbrTab; p--)  
       if (p->mode & MODE_BIDIRECTIONAL) 
          for (q=nbrTab; q<p; q++) 
             if (!(q->mode & MODE_BIDIRECTIONAL)) {
                swap((char *)q, (char *)p, sizeof(neighbor_t));
                q = p;         // break from this loop
                }      
    // now, with bidirectional at the start, we can sort
    // by the value of the displacement (in a dumb way)
    if (n > 1) 
        for (k=n; k>0; k--) { // locate maximum
            for (i=0, c=0; i<k; i++) {
	       // fear not that this subtraction can fail
	       // because of overflow - it's only in balancing
               call OTime.subtract(&nbrTab[i].RemoteVirtual,
                                   &nbrTab[i].Local,&t);
               x = call OTime.convTimeEights(&t);
               if (x > c) { j = i; c = x; }
               }
            if (c > 0)  swap((char *)&nbrTab[k-1], (char *)&nbrTab[i], 
                             sizeof(neighbor_t));
            }
    // median is at midpoint in the array
    n = n >> 1;
    call OTime.subtract(&nbrTab[n].RemoteVirtual,
                        &nbrTab[n].Local,&t);
    Base = call OTime.convTimeEights(&t);

    // assign eights for everyone using Base
    for (p=nbrTab;  p<nbrTab+NUM_NEIGHBORS; p++) { 
        call OTime.subtract(&p->RemoteVirtual,&p->Local,&t);
        c = call OTime.convTimeEights(&t);   // convert to 1/8 seconds
        if (c >= Base)  d = (c - Base) > 127 ? 127 : c - Base;   
        else            d = (Base - c) < -127 ? -127 : - (int16_t)( Base - c );  
        p->eights = d;
        }
    }
  #endif

  /**** Test if a given neighbor is healthy enough to persist ****/
  bool isHealthy(neighborPtr p, uint8_t type) {
    uint8_t x;
    if (!(mode & MODE_NORMAL)) return TRUE;  // we are generous
                             // if not normal ourselves
    #ifdef TRACK
    if (!(p->mode & MODE_NORMAL)) return FALSE; 
    #endif
    if ( wordCount(p->rcvHist[type]) >= 
         (sendCount[type] >> 1) ) return TRUE;
    // the following case is tricky:  we say that empty history
    // is healthy because a node is just joining the neighborhood 
    if (!p->rcvHist[type]) return TRUE;    
    x = p->rcvHist[type] & 0xf;   // isolate last nibble
    if (!(p->rcvHist[type] & 0xf0) ) {  // first nibble is zero
       if (x & 0x6) return TRUE;  // case: xmmx where mm != 0
       if (x & 0x1) return TRUE;  // case: xxx1
       // note: this means we reject case 1000 --- is that too strong?
       }   
    return FALSE;    // failing the above, link is unhealthy
    }

  /**** health test and "join" signal ****/
  bool healthy(neighborPtr p, uint8_t type) {
    uint8_t i;
    if (!isHealthy(p,type)) return FALSE;
    // after this, any result is TRUE
    // the only question is whether to "connect" or not
    if (bitOn(p->connected,type)) return TRUE;
    #ifndef TRACK
    // for non-TRACK implementation--and assuming that Tsync is
    // at layer 0 in the hierarchy--force type 0 to be connected
    p->connected = bitSet(p->connected,0);   
    #endif
    /*** only connect if connected at levels below ***/
    for (i=0; i<type; i++) if (!bitOn(p->connected,i)) return TRUE; 
    /*** note that returning early from the above loop
         means it's possible to be healthy but not connected ***/
    p->connected = bitSet(p->connected,type);
    signal Neighbor.join[type](p->Id); // tell dependent 
    return TRUE;
    }

  /**** interrogate connectedness **************************************/
  command bool Neighbor.present[uint8_t type]( uint16_t Id ) {
    neighborPtr p;
    p = call Tnbrhood.findNbr( Id );   // locate record for recording
    if (p == NULL || p->Id != Id) return FALSE;
    return bitOn(p->connected,type);
    }    

  /**** Register a Message type for health determination ***************/
  command error_t Neighbor.regist[uint8_t type]( uint32_t freq ) { 
    if (type >= NUM_TYPES) return FAIL;  // only handles a few types
    sendFreq[type] = freq;
    sendTime[type] = 1;     // this just shows type was registered
    return SUCCESS;  // currently doesn't take care of frequency changes
    }

  /**** Periodically check health of neighbors, eliminating sick ones **/
  void task ageTask() {
    neighborPtr p;
    uint8_t i,j;
    for (p=nbrTab;  p<nbrTab+NUM_NEIGHBORS; p++) {
       if (p->Id == 0) continue;
       /*** CONTROVERSY:  CASCADE FAILURE HIERARCHICALLY  ***/
       for (i=0; i<NUM_TYPES; i++) if (sendTime[i] > 0) {
          if (healthy(p,i)) continue;
          // node p is "sick" at level i
          for (j=i; j<NUM_TYPES; j++) { // kill at level j >= i 
             p->connected = bitUnSet(p->connected,j);
             signal Neighbor.leave[j](p->Id); // tell dependents 
             }
          if (i==0) memset( p, 0, sizeof(neighbor_t) );  
          break;  // done with node p
          }
       }
    #ifdef TRACK
    post balanceTask();    // also, check if Base needs rebalancing 
    #endif
    call Wakker.soleSet(0,HEALTH_CHECK_FREQ);  
    }

  /**
   *  Return Nsize (should be number of 
   *  biconnected, normal neighbors)
   */
  command uint8_t Tnbrhood.Nsize( ) { 
    uint8_t i,n;
    for (i=n=0; i<NUM_NEIGHBORS; i++) 
       if ( nbrTab[i].Id != 0 
               #ifdef TRACK
                       && (nbrTab[i].mode & MODE_BIDIRECTIONAL) 
                           && (nbrTab[i].mode & MODE_NORMAL)
               #endif
                       ) n++; 
    return n;
    }

  /**
   * Record that we heard from a neighboring mote
   */
  command void Neighbor.received[uint8_t type]( uint16_t id ) {
    uint8_t i;
    if (type >= NUM_TYPES) return;  // validate type
    /*** Looks strange to allow by type, but that's TinyOS ***/
    if (!(call Neighbor.allow[type](id))) return;
    for (i=0; i<NUM_NEIGHBORS; i++) if (nbrTab[i].Id == id) break;
    if (i==NUM_NEIGHBORS) return; 
    // record that msg was received
    /*** Notice two behaviors depending on sendFreq[type] ***/
    if (sendFreq[type] != 0 && (nbrTab[i].rcvHist[type] & 1))  
       // slide history over for non-self-clocking freq  
       nbrTab[i].rcvHist[type] <<= 1;  
       // because this weights more receives, allowing a  
       // larger tally of bits for more frequent receives
    nbrTab[i].rcvHist[type] |= 1; 
    }

  /**
   * Record that we sent a message to all neighbors
   */
  command void Neighbor.sent[uint8_t type]() {
    neighborPtr p;
    timeSync_t W;
    uint32_t v,w;
    if (type >= NUM_TYPES) return;  // validate type
    if (sendFreq[type] == 0) { // test for self-clocking
       // simply age all bit vectors (one more sent vs record of received)
       sendCount[type] = (sendCount[type] < 8) ? sendCount[type]+1 : 8;
       for (p=nbrTab;  p<nbrTab+NUM_NEIGHBORS; p++) p->rcvHist[type] <<= 1;
       return;
       }
    // sendFreq > 0  ==>  only count wrt current period
    call OTime.getLocalTime(&W);
    w = call OTime.convTimeEights(&W);
    v = w - sendTime[type];   
    // v is elapsed time since last send
    if (v >= sendFreq[type]) {
       sendCount[type] = (sendCount[type] < 8) ? sendCount[type]+1 : 8;
       for (p=nbrTab;  p<nbrTab+NUM_NEIGHBORS; p++) p->rcvHist[type] <<= 1;
       sendTime[type] = w;   // remember new period starting
       }
    }

  /**
   * "fixate" the current set of neighbors 
   */
  command void Neighbor.fix[uint8_t type]() {
    // for any connected neighbor, pretend a perfect history
    // of messages received;  this will effectively "freeze"
    // the current set of neighbors for a while
    neighborPtr p;
    for (p=nbrTab;  p<nbrTab+NUM_NEIGHBORS; p++) 
       // question:  should it be even more liberal, just looking
       // for normal, biconnected neighbors?
       if (p->Id != 0 && bitOn(p->connected,type)) 
          p->rcvHist[type] = 0xff;     
    }    

  /**
   *  Return TRUE if a neighbor's recent history of "diff" values is 
   *  suspicious.
   */
  command bool Tnbrhood.suspect( uint16_t Id ) {
    #if defined(TRACK)
    neighborPtr p;
    uint8_t i; 
    p = call Tnbrhood.findNbr( Id );   // locate record for recording
    if (p == NULL) return FALSE;       // no reason to suspect stranger
    i = p->byteMem & 0xf;       // i is recent "history" 
    if (i == 0) return FALSE;   // zero history is VERY BAD, so bad, in fact,
                                // that I don't know the right answer;  so
				// I will let this pass, even if it is some
				// kind of persistent error!
    if (i == 0xf) return FALSE; // flawless history!  
    return TRUE;                // somewhere in last four values, there was
                                // a flaw;  let the flaws die out naturally
				// through continued recording
    #else
    return FALSE;
    #endif
    }

  /**
   * (Forcibly) record a time and mote id 
   */
  command void Tnbrhood.record( uint8_t imode,     // incoming mode
                                timeSyncPtr Local, // NOT virtual
                                timeSyncPtr RemoteLocal,
                                timeSyncPtr RemoteVirtual,
                                int16_t diff,
                                uint16_t Id ) {
    neighborPtr p;
    #ifdef TRACK
    uint8_t i;
    bigClock a,b,e,f;
    timeSync_t w,v;
    float m;
    uint32_t c;
    int16_t d;
    /*** WARNING:  consumes about sixty (60) bytes of stack!!! ***/
    /*** WARNING:  use of saneDiff(diff) is meant to suppress noise,
         but could prevent convergence in pathological cases -- one
         could just make saneDiff(x) return TRUE if this is a problem
         in practice ***/

    p = call Tnbrhood.findNbr( Id );   // locate record for recording
    if (p == NULL) {
       if (!(imode & MODE_NORMAL)) return;  // table full for non-normal nbr
       for (i=0; i<NUM_NEIGHBORS; i++)     // try to kick out non-normal in tab 
          if (!(nbrTab[i].mode & MODE_NORMAL)) break;
       if (i==NUM_NEIGHBORS) return;          // still no room
       p = &nbrTab[i];
       }

    // distinguish two cases:  either this is new neighbor/mode, or 
    // just new data for an existing neighbor/mode
    if (p->Id != Id) {
       memset( p, 0, sizeof(neighbor_t) );
       p->Id = Id;
       p->mode = imode; 
       p->Local = *Local;
       p->RemoteVirtual = *RemoteVirtual;
       p->oldLocal = *Local;
       if (saneDiff(diff)) {
         p->oldRemoteLocal = *RemoteLocal;
         // NOTE:  if not saneDiff(diff), field will be zero
	 p->byteMem = 0x8;  // set bit for sane value recorded 
	 }
       return;
       }
        
    // second case -- from someone we know, but there are subcases
    // according to whether the mode has changed somehow
    if ( ((p->mode & MODE_NORMAL) && (!(imode & MODE_NORMAL))) ||  
         (!(p->mode & MODE_NORMAL) && (imode & MODE_NORMAL)) 
       ) {
       //** degrading from normal to non-normal neighbor
       //** or upgrading from non-normal to normal 
       p->mode = imode; 
       p->eights = 0;
       p->Local = *Local;
       p->RemoteVirtual = *RemoteVirtual;
       if (saneDiff(diff)){
          p->oldLocal = *Local;
          p->oldRemoteLocal = *RemoteLocal;
          i = (p->byteMem & 0xf) >> 1;
	  p->byteMem = i | 0x8 | (p->byteMem & 0xf0);
          }
       // NOTE:  if not saneDiff, fields not set!
       return;
       }
    if ( (p->mode & MODE_NORMAL) && (imode & MODE_NORMAL) ) {
       // just a regular beacon from someone familiar
       p->eights = 0;  // can be overwritten below
       p->Local = *Local;
       p->RemoteVirtual = *RemoteVirtual;
       // conditionally, update oldLocal and oldRemoteLocal
       a.partsInt.lo = p->oldRemoteLocal.ClockL; 
       a.partsInt.hi = p->oldRemoteLocal.ClockH; 
       if (a.bigInt.g == 0 && saneDiff(diff)) { // first reading 
          p->oldRemoteLocal = *RemoteLocal;
          p->oldLocal = *Local;
          a.partsInt.lo = RemoteLocal->ClockL; 
          a.partsInt.hi = RemoteLocal->ClockH; 
          }
       b.partsInt.lo = RemoteLocal->ClockL; 
       b.partsInt.hi = RemoteLocal->ClockH; 
       e.bigInt.g = b.bigInt.g - a.bigInt.g;
       // DEBUG CODE
       b.bigInt.g = a.bigInt.g = TPS*145;
       p->DebugAge = 0;
       while (a.bigInt.g < e.bigInt.g) {
          a.bigInt.g += b.bigInt.g;
          p->DebugAge += 1;
          if (p->DebugAge > 10) break;
          }

       if ( (e.bigInt.g > (SKEW_NOISE_WAIT/8)*TPS) 
                && saneDiff(diff)) {
          i = (p->byteMem & 0xf) >> 1;
	  p->byteMem = i | 0x8 | (p->byteMem & 0xf0);
          // e.bigInt.g is "delta y" in slope calculation
          a.partsInt.lo = p->oldLocal.ClockL; 
          a.partsInt.hi = p->oldLocal.ClockH; 
          b.partsInt.lo = Local->ClockL; 
          b.partsInt.hi = Local->ClockH; 
          // don't forget to "slide the window"
          p->oldRemoteLocal = *RemoteLocal;
          p->oldLocal = *Local;
          // f.bigInt.g will be "delta x" in slope calc
          f.bigInt.g = b.bigInt.g - a.bigInt.g;
          //  slope is (delta y)/(delta x), but for 
          //  higher precision, we actually want 
          //  1 + m = slope, where m is signed float;
          //  hence calculation is 
          //  m = (delta y - delta x) / delta x
          if (e.bigInt.g >= f.bigInt.g) {
             a.bigInt.g = e.bigInt.g - f.bigInt.g;
             m = (float) a.bigInt.g;
             }
          else {
             a.bigInt.g = f.bigInt.g - e.bigInt.g;
             m = - (float) a.bigInt.g;
             }
          m = m / (float) f.bigInt.g;
          #ifdef SKEW_SAFETY
          if (m > SKEW_SAFETY) m -= SKEW_SAFETY; // heuristic safety margin
          #endif
          p->slope = m;
          }
       else {  // for insane diff value, note that
          i = (p->byteMem & 0xf) >> 1;
	  p->byteMem = i | (p->byteMem & 0xf0);
          }
       }

    // post-processing of a normal neighbor:  take care of eights field
    if ( (p->mode & MODE_NORMAL) && (p->mode & MODE_BIDIRECTIONAL) ) {
       v = *Local;      // need current global time
       call OTime.conv2LocalTime(&v);  // now v should be global time for us
       if (call OTime.lesseq(RemoteVirtual,&v)) baseBack = TRUE; 
       else {   // feasible to use Base
          call OTime.subtract(RemoteVirtual,&v,&w);
          c = call OTime.convTimeEights(&w);   // convert to 1/8 seconds
          if (Base == 0) Base = c;            // first-time is simple
          if (c >= Base) d = (c - Base) > 127 ? 127 : c - Base;   
          else           d = (Base - c) < -127 ? -127 : - (int16_t)( Base - c );  
          p->eights = d;
          }
       }
    // more post-processing of a normal neighbor: record diff value 
    if ( (p->mode & MODE_NORMAL) && 
         (p->mode & MODE_BIDIRECTIONAL) &&
	 saneDiff(diff) ) {
       uint8_t k = p->byteMem >> 4;  // isolate 4 bits of index
       int8_t y = diff / 256;
       k = (k >= 4) ? 0 : (k + 1);   // increment modulo 5
       p->byteMem = (k << 4) | (p->byteMem & 0xf);  
       p->diffs[k] = y;              // store in circular buffer 
       }
    #else
    // "recording" for non-tracking implementation just tries to 
    // add a new neighbor for the incoming beacon
    p = call Tnbrhood.findNbr( Id );   // locate record for recording
    if (p == NULL) return;             // table was full
    /*** CONTROVERSY:  maybe we should, if imode is normal, consider
     * replacing some existing table item for this new node;  but that
     * would mean a forced "leave" for somebody  else, hmm... ******/
    if (p->Id == Id) return;           // consider this as "recorded"
    // else p->Id must be zero -- we can grab this entry
    p->Id = Id;
    #endif
    }

  /**
   *  Look for the maximum of the median diff values, supposing that
   *  all are negative values, considering only normal neighbors.
   */
  command int16_t Tnbrhood.overDiff() {
    #if defined(TRACK)
    neighborPtr p, q;
    int16_t s, max;
    bool found;
    // commence a scan/search for maximum median
    max = -32767;   // no maximum known
    found = FALSE;  // no neighbors found
    for (p=q=nbrTab;  p<nbrTab+NUM_NEIGHBORS; p++) {
       if (p->Id == 0) continue;
       if ((p->mode & MODE_NORMAL) && (p->mode & MODE_BIDIRECTIONAL)) {
	  found = TRUE;
	  s = medianFive(p->diffs) << 8;
	  max = (max < s) ? s : max;  
	  }
       }
    if (!found) max = 0;
    return max;
    #else
    return 0;
    #endif
    }

  /**
   *    Fetch maximum displacement recorded so far.
   *    value returned indicates result of fetch attempt:
   *    0 => no maximum could be obtained (really poor neighborhood)
   *    1 => maximum could be obtained, but not from any normal node
   *    2 => maximum could be obtained from a normal node
   *    3 => maximum could be obtained from a bidirectional, normal neighbor 
   */
  command uint8_t Tnbrhood.getMaxDisplacement( timeSyncPtr t ) {
    #ifdef TRACK
    neighborPtr p;
    uint8_t j,k,n;   // counters of different types
    timeSync_t v;
    *t = ZeroTime;
    // count types of neighbors 
    for (p=nbrTab, j=k=n=0;  p<nbrTab+NUM_NEIGHBORS; p++) {
       if (p->Id == 0) continue;
       if (p->mode & MODE_BIDIRECTIONAL) n++;
       if (p->mode & MODE_NORMAL) k++;
       if (p->mode & MODE_RECOVERING) j++;
       }
    if (n > 0) { // get maximum displacement among friends
       for (p=nbrTab;  p<nbrTab+NUM_NEIGHBORS; p++) 
          if (p->mode & MODE_BIDIRECTIONAL) {
	     if (call OTime.lesseq(&p->RemoteVirtual,&p->Local)) 
	        return 0;  // don't try goofy subtraction!
             call OTime.subtract(&p->RemoteVirtual,&p->Local,&v);
             if (call OTime.lesseq(t,&v)) *t = v;
             }
       return 3;
       }
    if (k > 0) { // get maximum displacement among friends
       for (p=nbrTab;  p<nbrTab+NUM_NEIGHBORS; p++) 
          if (p->mode & MODE_NORMAL) {
	     if (call OTime.lesseq(&p->RemoteVirtual,&p->Local)) 
	        return 0;  // don't try goofy subtraction!
             call OTime.subtract(&p->RemoteVirtual,&p->Local,&v);
             if (call OTime.lesseq(t,&v)) *t = v;
             }
       return 2;
       }
    if (j > 0) { // get maximum displacement among friends
       for (p=nbrTab;  p<nbrTab+NUM_NEIGHBORS; p++) 
          if (p->mode & MODE_RECOVERING) {
	     if (call OTime.lesseq(&p->RemoteVirtual,&p->Local)) 
	        return 0;  // don't try goofy subtraction!
             call OTime.subtract(&p->RemoteVirtual,&p->Local,&v);
             if (call OTime.lesseq(t,&v)) *t = v;
             }
       return 1;
       }
    #endif
    return 0;  // else no maximum found (sigh)
    }

  /**
   *  Find the Id of any outlier among the set of 
   *  normal neighbors;  return Id of said outlier.
   *
   *  Return codes: 
   *          0  there is no outlier -- set Id to zero          
   *         -1  there is more than one outlier (ambiguous)   
   *          1  there is exactly one outlier  
   *             -- in this last case only, the identity
   *             of the outlier is stored at the 
   *             caller-provided location.
   */
  command int8_t Tnbrhood.outlier( uint16_t * IdPtr ) { 
    #ifdef TRACK
    uint32_t locbase;
    timeSync_t t;
    neighborPtr p;
    int16_t max, min, x, smax, smin;
    bool skipped;

    *IdPtr = 0;  // default result
    if (baseBack) return 0;  // outlier computation is invalid
    if (call Tnbrhood.Nsize() == 0) return 0;
   
    max = -127; min = 127;
    for (p=nbrTab;  p<nbrTab+NUM_NEIGHBORS; p++) {
       if (p->Id == 0) continue;
       if (!(p->mode & MODE_BIDIRECTIONAL)) continue;
       max = (p->eights > max) ? p->eights : max ;
       min = (p->eights < min) ? p->eights : min ;
       }
    if (min == 127) return 0;  

    // also, need to include our own clock in the survey
    call OTime.getGlobalOffset(&t);
    locbase = call OTime.convTimeEights(&t);
    if (locbase >= Base) 
      x = (locbase - Base > 127) ? 127 : (locbase - Base);
    else
      x = (Base - locbase > 127) ? -127 : -(Base - locbase);
    max = (x > max) ? x : max ;
    min = (x < min) ? x : min ;
    if (max <= min) return 0;
    if (max - min <= OUTLIER_LIMIT) return 0;  // two-second span is OK

    // test to see if there are two outliers
    
    /***** first:  remove max and compute smax ************/
    skipped = (x == max) ? TRUE : FALSE;
    for (p=nbrTab, smax = -127; p<nbrTab+NUM_NEIGHBORS; p++) {
       if (p->Id == 0) continue;
       if (!(p->mode & MODE_BIDIRECTIONAL)) continue;
       if (!skipped && p->eights == max) { skipped = TRUE; continue; }
       smax = (p->eights > smax) ? p->eights : smax ;
       }
    if (x != max) smax = (x > smax) ? x : smax;
    
    /***** second:  remove min and compute smin ************/
    skipped = (x == min) ? TRUE : FALSE;
    for (p=nbrTab, smin = 127; p<nbrTab+NUM_NEIGHBORS; p++) {
       if (p->Id == 0) continue;
       if (!(p->mode & MODE_BIDIRECTIONAL)) continue;
       if (!skipped && p->eights == min) { skipped = TRUE; continue; }
       smin = (p->eights < smin) ? p->eights : smin ;
       }
    if (x != min) smin = (x < smin) ? x : smin;

    /****** third, decide on basis of max, smax, min, smin **********/
    if (smax - min <= OUTLIER_LIMIT) {  // max is outlier!
       *IdPtr = TOS_NODE_ID;      // assume we are culprit
       for (p=nbrTab; p<nbrTab+NUM_NEIGHBORS; p++) {
          if (p->Id == 0) continue;
          if (!(p->mode & MODE_BIDIRECTIONAL)) continue;
          if (p->eights == max) *IdPtr = p->Id;
          }
       // if (x == max) *IdPtr = p->Id; 
       return 1;
       } 
    if (max - smin <= OUTLIER_LIMIT) {  // min is outlier!
       *IdPtr = TOS_NODE_ID;      // assume we are culprit
       for (p=nbrTab; p<nbrTab+NUM_NEIGHBORS; p++) {
          if (p->Id == 0) continue;
          if (!(p->mode & MODE_BIDIRECTIONAL)) continue;
          if (p->eights == min) *IdPtr = p->Id;
          }
       // if (x == min) *IdPtr = p->Id; 
       return 1;
       } 

    /****** neither max nor min was the unique outlier ***********/
    #endif
    return -1; 
    }

  /**
   * Find specified entry (or empty slot) 
   */
  command neighborPtr Tnbrhood.findNbr( uint16_t specId ) {
    neighborPtr p, q;
    bool found = FALSE;
    for (p=q=nbrTab;  p<nbrTab+NUM_NEIGHBORS; p++) {
       if (p->Id == 0 && !found) {q = p; found = TRUE;}  // remember empty slot
       if (p->Id == specId) return p;
       }
    if (q->Id == 0) return q;
    return NULL;
    }

  /**
   * Return start of neighbor table 
   */
  command neighborPtr Tnbrhood.nbrTab() { return nbrTab; }

  /**
   * get approximate "age" for a specified neighbor 
   */
  command uint8_t Tnbrhood.age( uint16_t Id, timeSyncPtr curTime ) {
    #ifdef TRACK
    neighborPtr p;
    uint8_t r,s;
    if (Id == 0) return 0;
    for (p=nbrTab;  p<nbrTab+NUM_NEIGHBORS; p++) {
       if (p->Id != Id) continue;
       s = call OTime.convTimeByte(curTime);   // current time
       r = call OTime.convTimeByte(&p->Local); // former time (last beacon)     
       return (s-r);
       }
    #endif
    return 0;
    }

  #ifdef TRACK
  // send a neighborhood message
  task void sendTask() {
    error_t r;
    r = call AMSend.send(AM_BROADCAST_ADDR, &msg, sizeof(neighborMsg));
    if (r != SUCCESS) call Wakker.soleSet(2,1);  
                           // retry soon:  somebody else had channel
    }
  // after neighborhood message sent
  event void AMSend.sendDone(message_t* sent, error_t e) {
    msgFree = TRUE;
    }

  // prepare and send a neighborhood message
  /*** Warning:  this is currently too specific 
       to timesync;  generalization should be for
           each level in Neighbor component hierarchy ***/
  task void healthTask() {
    uint8_t i;
    if (!msgFree) { 
       call Wakker.soleSet(1,1); // retry later
       return;
       }
    msgFree = FALSE;
    nMsg.sndId = TOS_NODE_ID;
    for (i=0; i<NUM_NEIGHBORS; i++) {
       nMsg.nodes[i] = 0;
       if (nbrTab[i].Id != 0 && (nbrTab[i].mode & MODE_NORMAL)) 
          nMsg.nodes[i] = nbrTab[i].Id;
       } 
    // DEBUG -- show a byte of history information 
    // ########## TEMP HACK
    // for (i=0; i<NUM_NEIGHBORS; i++) 
    //  if (nbrTab[i].Id != 0 && (nbrTab[i].mode & MODE_NORMAL)) 
    //     nMsg.nodes[NUM_NEIGHBORS-1] = nbrTab[i].connected;

    memcpy((uint8_t*)&msg.data,&nMsg,sizeof(neighborMsg));
    i = call PowCon.randelay();
    if (i == 0) post sendTask();    // send the message
    else call Wakker.soleSet(2,i); 
    }
  
  // process incoming neighborhood message
  event message_t* Receive.receive(message_t* m, void* pl, uint8_t l ) {
    neighborMsg p;
    uint8_t i,j;
    memcpy((uint8_t*)&p,pl,sizeof(neighborMsg));
    if (!(call Neighbor.allow[0](p.sndId))) return m;
    // check if this neighborhood message is an "Ack" of our existence
    for (i=0; i<NUM_NEIGHBORS; i++)  
       if (p.nodes[i] == TOS_NODE_ID) 
          // attempt to record the Ack
          for (j=0; j<NUM_NEIGHBORS; j++) 
             if ( nbrTab[j].Id == p.sndId && 
                  (nbrTab[j].mode & MODE_NORMAL)) { 
                nbrTab[j].mode |= MODE_BIDIRECTIONAL; 
                // NOTE:  nbrTab[j].eights is zero, hope that is OK
                return m;
                }
    // if we didn't return above, then health message did NOT
    // contain our address -- implying that we are not in a 
    // totally bidirectional relationship, hence we want to 
    // remove (if necessary) this node from our table
    for (i=0; i<NUM_NEIGHBORS; i++)  
       if ( nbrTab[i].Id == p.sndId ) 
            nbrTab[i].mode &= ~MODE_BIDIRECTIONAL;
    return m; 
    }
  #endif

  event error_t Wakker.wakeup(uint8_t indx, uint32_t wake_time) {
    switch (indx) {
      case 0: post ageTask(); break;
      #ifdef TRACK
      case 1: post healthTask(); break;
      case 2: post sendTask(); break;
      #endif
      }
    return SUCCESS;
    }

  #ifdef TRACK
  event void PowCon.wake() {
    post healthTask();  // schedule sending heartbeat/nbrhood message 
    }
  event void PowCon.idle() { } // not used
  event void PowCon.supply( powschedPtr p ) {
    p->period = NORM_WAIT;
    p->livetime = EXCHANGE_INTERVAL;   
    p->priority = 2;  // Tsync is above Tnbrhood in priority
    call Wakker.clear();  // kill any currently scheduled alarms
    call Wakker.soleSet(0,HEALTH_CHECK_FREQ);   // periodic health check 
    }
  #endif

  default event void Neighbor.leave[uint8_t type](uint16_t Id) { }
  default event void Neighbor.join[uint8_t type](uint16_t Id) { }
  }

