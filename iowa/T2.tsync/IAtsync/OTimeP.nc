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

module OTimeP
{
  provides { interface OTime; }
  uses {
    interface Boot;
    #if defined(PLATFORM_TELOSB)
    interface Counter<T32khz,uint32_t> as Counter32;
    interface Counter<TMicro,uint32_t> as CounterMicro;
    #endif
    interface Wakker;
    interface Leds as SkewLeds;
    }
  }
implementation {
  /*** Variables that determine OTime's State ***/

  norace timeSync_t LastClock; // result of most recent call to get Local Time
                            // that had some skew applied to it --- 
                            // basically only used within OTime.getLocalTime

  norace timeSync_t LastLocalClock;  // most recent value of get Local Time
                            
  norace timeSync_t LastSysTime;   // records most recent call to SysTime, 
                            // but extending to 48 bits from 32 bits
                            
  norace timeSync_t LastRefTime;   // this is the SysTime value at the instant
                            // when getLocalTime was called AND applied skew;
                            // it is used heuristically to skip the overhead
                            // of applying skew too often, hopefully thus
                            // amortizing the overhead of skew calculation
                            
  norace timeSync_t Displacement;  // add this amount to local time to get 
                            // the value of global time;  the Tsync module
                            // sets this value

  norace timeSync_t LocalOffset;  // +/- this amount to local time to get
                            // the value of public local time;  this will always
                            // be zero until skew is applied
  norace bool OffsetSign;   // TRUE if LocalOffset is positive, else FALSE

  norace uint16_t cleep;    // counter for "deep sleep" iterations
                            // where each iteration is about 8 seconds

  norace uint32_t sleepUnit;       // # jiffies in a 255/7 interval, measured
                            // empirically 
  norace bool sleepUnitStable;

  norace int16_t skewAdjust;       // amount to adjust clock by on each reading

  norace float skew;        // skew factor:  skew is 1.0 + this value

  const timeSync_t ZeroTime = { 0u, 0u };

  command void OTime.setSkew( float newSkew ) { atomic  skew = newSkew; }
  command float OTime.getSkew( ) { 
    float readSkew;
    atomic { readSkew = skew; }
    return readSkew; 
    }

  event void Boot.booted() {
    LastLocalClock = LastClock = LastSysTime = 
            LastRefTime = Displacement = 
            LocalOffset = ZeroTime;
    OffsetSign = TRUE;
    cleep = 0;
    skew = 0.0;
    skewAdjust = 0;
    call Wakker.set(0,200*8);    // for proper handling of SysTime 
                                // extended to 48 bits, we need to 
                                // invoke SysTime with some frequency,
                                // so waking up at least once every 
                                // 200 seconds is a good idea
    }

  /**
   *  Get/Set globalTime offset
   */
  command void OTime.getGlobalOffset( timeSyncPtr p ) {
    *p = Displacement;
    }
  command void OTime.setGlobalOffset( timeSyncPtr p ) {
    Displacement = *p;
    }

  /**
   * OTime.getLocalTime returns current local clock,
   * provided by SysTime.get(), with skew computed to
   * update the LocalOffset value.  BUT RESULT DOES NOT
   * APPLY SKEW to the time value returned -- this is important!
   */
  command void OTime.getLocalTime( timeSyncPtr p, uint32_t * r ) { 
    bigClock a;
    timeSync_t v;
    int32_t w;
    #if defined(PLATFORM_TELOSB)
    atomic p->ClockL = call Counter32.get() << 5;
    #endif
    if (r != NULL) *r = p->ClockL;
    // add to high-order part if carry implied by clock wrapping around
    if ( p->ClockL < LastSysTime.ClockL ) LastSysTime.ClockH++;
    LastSysTime.ClockL = p->ClockL;
    p->ClockH = LastSysTime.ClockH;

    // compute adjustment due to skew
    // first step:  compute elapsed time since last clock reading
    // (we hope this is long enough to give numerical significance
    //  a danger is that getLocalTime is called so often that 
    //  the skew adjustment is always too small to be significant,
    //  with the result that no adjustment is ever applied.)
    call OTime.subtract( p, &LastRefTime, &v );  // now v is elapsed time

    // quick return if too small an interval has elapsed since the last reading
    call OTime.add(&LastClock,&v,p);   // tentative result is (LastClock+v)
    if (v.ClockH == 0 && v.ClockL < INTERVAL_WO_SKEW) {
       LastLocalClock = *p;
       return;
       }
     
    LastRefTime = LastSysTime;

    // the following takes care of skew slope = 1.0, leaving only the 
    // fractional part to deal with, which is in 'skewAdjust' variable
    LastClock = *p;

    if (!DO_SKEW_ADJUST) {
       // remember to record the output value
       LastLocalClock = *p;
       return;
       }
   
    // second step, adjust the skew offset 
    a.partsInt.lo = v.ClockL;
    a.partsInt.hi = v.ClockH;  // a is elapsed time between calls
    w = ((float)a.bigInt.g * skew);    // this is adjustment amount  
    if (w > 0) {
       v.ClockL = w;
       v.ClockH = 0;
       if (OffsetSign) 
          call OTime.add(&LocalOffset,&v,&LocalOffset);
       else if (call OTime.lesseq(&v,&LocalOffset)) // prevent underflow 
              call OTime.subtract(&LocalOffset,&v,&LocalOffset);
       else {  // switching from negative offset to positive
              call OTime.subtract(&v,&LocalOffset,&LocalOffset);
              OffsetSign = TRUE;
              }
       }
    else if (w < 0) {
       w = -w;
       v.ClockL = w;
       v.ClockH = 0; 
       if (!OffsetSign)
          call OTime.add(&LocalOffset,&v,&LocalOffset);
       else if (call OTime.lesseq(&v,&LocalOffset)) // prevent underflow 
          call OTime.subtract(&LocalOffset,&v,&LocalOffset);
       else {  // switching from positive offset to negative 
          call OTime.subtract(&v,&LocalOffset,&LocalOffset);
          OffsetSign = FALSE;
          }
       }
    if (!OffsetSign) {
       call SkewLeds.led0On();
       call SkewLeds.led1Off();
       }
    else if (LocalOffset.ClockH != 0 || LocalOffset.ClockL != 0) {
       call SkewLeds.led0Off();
       call SkewLeds.led1On();
       }
    else {
       call SkewLeds.led0Off();
       call SkewLeds.led1Off();
       }
    // remember to record the output value
    LastLocalClock = *p;
    }
 
  /*** return most recent result from getLocalTime *************/
  command void OTime.getLastLocalTime( timeSyncPtr t ) 
    { *t = LastLocalClock; }

  /**
   * OTime.getNative32() is a wrapper for Counter32khz, 
   * provided so that only one incarnation of Counter32khz is
   * is used across different modules of timesync.  Units are 
   * "microseconds" (binary microseconds, that is, equal to 
   * 1024 * 32kHz)
   */
  async command uint32_t OTime.getNative32() {
    return (call Counter32.get() << 5);
    }

  /**
   * OTime.getNativeMicro() is a wrapper for CounterMicro, 
   * provided so that only one incarnation of CounterMicro is
   * used across different modules of timesync.
   */
  async command uint32_t OTime.getNativeMicro() {
    return (call CounterMicro.get());
    }

  /**
   * OTime.getLocalTime32 returns the scaled-to-32-bits
   * version of getLocalTime
   */
  command uint32_t OTime.getLocalTime32( ) { 
    uint32_t r;
    uint32_t s;
    timeSync_t t;

    call OTime.getLocalTime(&t,NULL);
    // isolate "middle" 32 bits
    r = t.ClockL >> 10;  // discard low-order 10 bits.
    s = t.ClockH;        // s = hi order 16 bits from 48-bit clock
    s = s << 22;         // position 10 of these bits to be hi-order
    r = r | s;           // get hi-order (32-10)=22 bits
    return r;
    }

  /**
   * OTime.pubLocalTime obtains the Local Time and
   * then applies a skew adjustment to the result.
   */
  command void OTime.pubLocalTime( timeSyncPtr p, uint32_t * t) {
    call OTime.getLocalTime(p,t);
    if (OffsetSign) call OTime.add(p,&LocalOffset,p);
    else if (call OTime.lesseq(&LocalOffset,p))
            call OTime.subtract(p,&LocalOffset,p);
    }

  /**
   * OTime.getGlobalTime adds current displacement 
   * to the localTime. 
   */
  command void OTime.getGlobalTime( timeSyncPtr p ) { 
    call OTime.pubLocalTime(p,NULL);
    call OTime.add(p,&Displacement,p);
    }

  /**
   * OTime.getGlobalTime32 returns the scaled-to-32-bits
   * version of getGlobalTime
   */
  command uint32_t OTime.getGlobalTime32( ) { 
    uint32_t r;
    uint32_t s;
    timeSync_t t;

    call OTime.getGlobalTime(&t);
    // isolate "middle" 32 bits
    r = t.ClockL >> 10;  // discard low-order 10 bits.
    s = t.ClockH;        // s = hi order 16 bits from 48-bit clock
    s = s << 22;         // position 22 of these bits to be hi-order
    r = r | s;           // get hi-order (32-10)=22 bits
    return r;
    }

  /**
   * OTime.convTimeEights converts a timeSync_t to 
   * a 32-bit value, truncated (rounded down) to the nearest 
   * eighth of one second
   */
  command uint32_t OTime.convTimeEights( timeSyncPtr r ) {
     bigClock u;
     u.partsInt.hi = r->ClockH;
     u.partsInt.lo = r->ClockL;
     u.bigInt.g /= (TPS/8); // now divide to get 1/8 sec units 
     return u.partsInt.lo;  
     }

  /**
   * OTime.getGlobalTimeEights returns the current
   * global time, truncated (rounded down) to the nearest 
   * eighth of one second
   */
  command uint32_t OTime.getGlobalTimeEights( ) {
     timeSync_t p;
     call OTime.getGlobalTime(&p);
     return call OTime.convTimeEights(&p);  
     }

  /**
   * OTime.convTimeSeconds rounds a timeSync_t down to the second 
   */
  command uint32_t OTime.convTimeSeconds( timeSyncPtr r ) {
     return ( (call OTime.convTimeEights(r)) >> 3 );
     }

  /**
   * OTime.getGlobalTimeSeconds returns the current
   * global time, truncated (rounded down) to the nearest second
   */
  command uint32_t OTime.getGlobalTimeSeconds( ) {
     return ( (call OTime.getGlobalTimeEights()) >> 3 );
     }

  /**
   * Calculate absolute difference between two 1-byte time
   * values (where each jiffie is 145.636 seconds);  result
   * is somewhat ambiguous, due to rollover;  we assume here
   * that the first parameter is "larger" than the second
   * parameter (which may not strictly look true, because of
   * rollover, but used wisely, this works anyway).  
   */
  command uint8_t OTime.subtractTimeByte( uint8_t a, uint8_t b ) {
    if (a >= b) return (a-b);  else return  (a + (255 - b) + 1);
    }

  /**
   *  Convert a 32-bit, eight-of-second value to a 1-byte
   *  time value (where each jiffied is 145.636 seconds)
   */
  command uint8_t OTime.convEightTimeByte( uint32_t time ) {
     return (uint8_t)( time / (uint32_t)(ONE_BYTE_TIME_UNIT * 8) );
     }

  /**
   *  Convert a Tsync to 1-byte units: rounding down to
   *  the nearest second, then truncating to one Byte
   *  result, where each "jiffie" is 145.636 seconds, rolling 
   *  over every ten hours or so.
   */
  command uint8_t OTime.convTimeByte( timeSyncPtr t ) {
     uint8_t v,w;
     if (TPS == 921600u) { // fast method for MicaZ
        v = (t->ClockL >> 27);
        w = (t->ClockH & 0x07);
        return (w<<5) + v;   // convert to new jiffie
        }
     // resolution for Mica128 will be 134.218 seconds
     if (TPS == 500000u) { // fast method for Mica128
        v = (t->ClockL >> 26);  
        w = (t->ClockH & 0x03);
        return (w<<6) + v;   // convert to new jiffie
        }
     // resolution for Telos will be like MicaZ
     if (TPS == 1048576u) { // fast method for Telos 
        v = (t->ClockL >> 27);
        w = (t->ClockH & 0x07);
        return (w<<5) + v;   // convert to new jiffie
        }
     return 0;
     }

  /**
   *  Read local time to the 145-sec jiffie, converting
   *  to 1-byte units.
   */
  command uint8_t OTime.getLocalTimeByte( ) {
     timeSync_t t; 
     call OTime.getLocalTime(&t,NULL);
     return call OTime.convTimeByte(&t);
     }

  /**
   *  Read global time to the 145-sec jiffie, converting
   *  to 1-byte units.
   */
  command uint8_t OTime.getGlobalTimeByte( ) {
     timeSync_t p;
     call OTime.getGlobalTime(&p);
     return call OTime.convTimeByte(&p);
     }


  /**
   * OTime.conv1LocalTime adds current displacement 
   * to the provided LocalTime to get Global Time. 
   * OTime.conv2LocalTime is similar, but also adds
   * the current skew adjustment (NOTE CAREFULLY, 
   * only really valid for a very recent LocalTime)
   */
  command void OTime.conv1LocalTime( timeSyncPtr p ) { 
    call OTime.add(p,&Displacement,p); 
    }
  command void OTime.conv2LocalTime( timeSyncPtr p ) { 
    call OTime.add(p,&Displacement,p); 
    if (OffsetSign) call OTime.add(p,&LocalOffset,p);
    else if (call OTime.lesseq(&LocalOffset,p))
            call OTime.subtract(p,&LocalOffset,p);
    }

  /**
   * OTime.adjGlobalTime adjusts current displacement. 
   */
  command void OTime.adjGlobalTime( timeSyncPtr p ) { 
    call OTime.add(p,&Displacement,&Displacement);
    }

  /**
   * OTime.lesseq compares two time values (a,b)
   * returning TRUE iff  a <= b
   */
  command bool OTime.lesseq( timeSyncPtr a, timeSyncPtr b ) {
    if (a->ClockH > b->ClockH) return FALSE;
    if (a->ClockH < b->ClockH) return TRUE;
    if (a->ClockL > b->ClockL) return FALSE;
    return TRUE;
    }

  /**
   * OTime.add sums two time values (a,b) into c
   */
  async command void OTime.add( timeSyncPtr a, timeSyncPtr b, timeSyncPtr c ) {
    timeSync_t v;   // in case pointer c=b or c=a
    v.ClockH = a->ClockH + b->ClockH;
    v.ClockL = a->ClockL + b->ClockL;
    if (v.ClockL < a->ClockL || v.ClockL < b->ClockL) v.ClockH++;
    c->ClockH = v.ClockH;  c->ClockL = v.ClockL;
    }

  /**
   * OTime.subtract does c = a - b  (works only if a > b)
   */
  async command void OTime.subtract( timeSyncPtr a, timeSyncPtr b, timeSyncPtr c ) {
    timeSync_t v;   // in case pointer c=b or c=a
    v.ClockH = a->ClockH - b->ClockH;
    v.ClockL = a->ClockL - b->ClockL;
    if (a->ClockL < b->ClockL) v.ClockH--;
    c->ClockH = v.ClockH;  c->ClockL = v.ClockL;
    }

  /**
   * Periodic firing of Wakker so we get a recent base
   * on the current value of SysTime
   */
  event error_t Wakker.wakeup(uint8_t indx, uint32_t wake_time) {
    timeSync_t m;
    call OTime.getGlobalTime( &m ); 
    call Wakker.set(0,200*8);   // reschedule self  
    return SUCCESS;
    }

  /**
   * Convert a TelosB-based clock (2^{20} jiffies/sec) to
   * a MicaZ-based clock (921.6e3 jiffies/sec)
   *
   * The method is simple:  conversion from TelosB to 
   * MicaZ is just multiplication by  921600/(1024*1024)
   * which reduces to multiplication by (15/16)^2
   **/
  command void OTime.Tel2Z( timeSyncPtr p ) {
    bigClock u;
    u.partsInt.hi = p->ClockH;
    u.partsInt.lo = p->ClockL;
    u.bigInt.g *= 225;
    u.bigInt.g /= 256;
    p->ClockH = u.partsInt.hi;
    p->ClockL = u.partsInt.lo;
    }
  command void OTime.Tel2Zs( uint32_t * p ) {  
    // RESEARCH: can this be more accurate
	// using bit shifting?
    *p *= 225;
    *p /= 256;
    }

  /**
   * Convert a MicaZ-based clock (921.6e3 jiffies/sec) to
   * a TelosB-based clock (2^{20} jiffies/sec)
   *
   * The method is simple:  conversion from MicaZ to 
   * Telosb is just multiplication by  (1024*1024)/921600
   * which reduces to multiplication by (16/15)^2 
   */
  command void OTime.Z2Tel( timeSyncPtr p ) {
    bigClock u;
    u.partsInt.hi = p->ClockH;
    u.partsInt.lo = p->ClockL;
    u.bigInt.g *= 256;
    u.bigInt.g /= 225;
    p->ClockH = u.partsInt.hi;
    p->ClockL = u.partsInt.lo;
    }
  command void OTime.Z2Tels( uint32_t * p ) {
    *p *= 256;
    *p /= 225;
    }
  async event void Counter32.overflow() { }
  async event void CounterMicro.overflow() { }
}
