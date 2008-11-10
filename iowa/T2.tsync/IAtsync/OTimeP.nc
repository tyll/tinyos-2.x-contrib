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
    interface LocalTime<TMilli>;  // supposedly 32768 ticks per sec
    interface Counter<T32khz,uint32_t> as Counter32;  // varies with platform
    interface Counter<TMicro,uint32_t> as CounterMicro;  // ditto
    interface Wakker;
    interface Leds as SkewLeds;
    interface Leds as EmergencyLeds;
    }
  }
implementation {
 
  /*** Crucial Constant:  at most 200 seconds between native clock reads ***/
  enum { BETWEEN_INTERVAL = 200 };
  
  /*** Variables that determine OTime's State ***/

  norace timeSync_t LastClock; // result of most recent call to get Local Time
                            // that had some skew applied to it --- 
                            // basically only used within OTime.getLocalTime

  norace timeSync_t LastLocalClock;  // most recent value of get Local Time
                            
  norace timeSync_t LastSysTime;   // records most recent call to system time, 
                            // but extending to 48 bits from 32 bits
                            
  norace timeSync_t LastRefTime;   // this is the system value at the instant
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

  norace uint16_t stepBack;    // amount to adjust clock by on next reading

  norace float skew;        // skew factor:  skew is 1.0 + this value

  const timeSync_t ZeroTime = { 0u, 0u };

  uint32_t lastLTMicro;     // saved by getLocalTime for later access
  uint32_t calibrateMilli;  // clock rate measurement variables
  uint32_t calibrateMicro;  
  float    calibrateRatio; 

  command void OTime.setSkew( float newSkew ) { atomic  skew = newSkew; }
  command float OTime.getSkew( ) { 
    float readSkew;
    atomic { readSkew = skew; }
    return readSkew; 
    }

  command void OTime.init() {
    LastLocalClock = LastClock = LastSysTime = 
            LastRefTime = Displacement = 
            LocalOffset = ZeroTime;
    OffsetSign = TRUE;
    calibrateMilli = calibrateMicro = 0; 
    skew = calibrateRatio = 0.0;
    stepBack = 0;
    Displacement.ClockL = 62914560u;  // extra minute enables stepBack 
    call Wakker.soleSet(0,BETWEEN_INTERVAL*8); // for native time 
                                // extended to 48 bits, we need to 
                                // invoke system clock with some frequency,
                                // so waking up at least once every 
                                // BETWEEN_INTERVAL seconds is a good idea
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

  // Emergency!  Crash Here ...
  task void crash() {
    call EmergencyLeds.led0On();
    call EmergencyLeds.led1On();
    call EmergencyLeds.led2On();
    post crash();
    }
  
  /**
   * Test for a "big jump" between two timeSync_t 
   * objects (w.r.t. a given threshold) 
   */
  command bool OTime.bigjump( timeSyncPtr p, 
          timeSyncPtr q, uint32_t threshold ) {
    timeSync_t d;
    if (call OTime.lesseq(q,p)) 
         call OTime.subtract(p,q,&d);
    else call OTime.subtract(q,p,&d);
    if (d.ClockH) return TRUE;
    if (d.ClockL > threshold) return TRUE;
    return FALSE;
    }

  // perform sanity check on proposed new, native clock
  // reading -- if it is bizarre, then there is some kind
  // of software error:  TinyOS, Application writing over
  // data/code, who knows?  best just to crash here ...
  void sanityCheck( timeSyncPtr p ) { 
    uint32_t lim = BETWEEN_INTERVAL + 10;
    lim *= TPS;    // maximum number of jiffies

    // assume LastSysTime is either zero or meaningful
    // and that proposed new time value is within 
    // BETWEEN_INTERVAL seconds of LastSysTime value, 
    // plus or minus a few seconds

    if (LastSysTime.ClockH == 0 && LastSysTime.ClockL == 0) return;
    if (call OTime.bigjump(&LastSysTime,p,lim)) post crash();
    return;
    }

  /**
   * OTime.getLocalTime returns current local clock,
   * provided by system clock, with skew computed to
   * update the LocalOffset value, as a side-effect. 
   * NOTE:  the RESULT DOES NOT APPLY SKEW to the time 
   * value returned -- this is important!
   */
  command void OTime.getLocalTime( timeSyncPtr p ) { 
    bigClock a;
    timeSync_t v;
    int32_t w;

    #if defined(PLATFORM_TELOSB)
     atomic p->ClockL = call Counter32.get();  // binary 32KHz
     p->ClockL <<= 5;   // convert to binary microseconds
     lastLTMicro = p->ClockL;  // save for possible later reference
     p->ClockH = LastSysTime.ClockH;   // presume no carry, initially
     if (p->ClockL < LastSysTime.ClockL) p->ClockH++;  // else do the carry
     sanityCheck(p);    // check before overwrite
     LastSysTime = *p;  // now, there is a new, previous system clock time

    #elif defined(PLATFORM_MICAZ)
     atomic p->ClockL = call CounterMicro.get(); // get native microseconds
     lastLTMicro = p->ClockL;  // save for possible later reference
     p->ClockH = LastSysTime.ClockH;   // presume no carry, initially
     if (p->ClockL < LastSysTime.ClockL) p->ClockH++;  // else do the carry
     sanityCheck(p);    // check before overwrite
     LastSysTime = *p;  // now, there is a new, previous system clock time
     #if defined(MIXED_CC2420)
     call OTime.Z2Tel(p);   // convert to binary microseconds
     #endif
    #endif

    // apply "step back" amount and reset to zero
    if (stepBack != 0) {
       v.ClockH = 0;
       v.ClockL = stepBack;
       if (call OTime.lesseq(&v,p)) call OTime.subtract(p,&v,p);
       stepBack = 0;
       }

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
     
    LastRefTime = *p;
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
   * 1024 * 32kHz) for Telos, but based on ticks of 921600 in
   * the case of MicaZ.  Most likely, don't use this for 
   * MicaZ.
   */
  async command uint32_t OTime.getNative32() {
    uint32_t v;
    atomic v = call Counter32.get() << 5;
    return v;
    }

  /**
   * Return most recent native microsecond clock value
   * of getLocalTime() invocation 
   */
  command uint32_t OTime.getLastLTMicro() { return lastLTMicro; }

  /**
   * OTime.getNativeMicro() is a wrapper for CounterMicro, 
   * provided so that only one incarnation of CounterMicro is
   * used across different modules of timesync.
   */
  async command uint32_t OTime.getNativeMicro() {
    uint32_t v;
    atomic v = call CounterMicro.get();
    return v;
    }

  /**
   * Telos:
   *  just like getNative32, i.e., 32khz counter * 2^10 
   * MicaZ:
   *  return the native microsecond clock
   */
  async command uint32_t OTime.getStableMicro32() {
    uint32_t v;
    #if defined(PLATFORM_TELOSB)
     atomic v = call Counter32.get() << 5;
    #elif defined(PLATFORM_MICAZ)
     atomic v = call CounterMicro.get(); // get native microseconds
     #if defined(MIXED_CC2420)
     { timeSync_t x;
       x.ClockL = v;
       x.ClockH = 0;
       call OTime.Z2Tel(&x);
       return x.ClockL;
     }
     #endif
    #endif
    return v;
    }

  /**
   * OTime.getLocalTime32 returns the scaled-to-32-bits
   * version of getLocalTime
   */
  command uint32_t OTime.getLocalTime32( ) { 
    uint32_t r;
    uint32_t s;
    timeSync_t t;

    call OTime.getLocalTime( &t );
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
  command void OTime.pubLocalTime( timeSyncPtr p ) {
    call OTime.getLocalTime(p);
    if (OffsetSign) call OTime.add(p,&LocalOffset,p);
    else if (call OTime.lesseq(&LocalOffset,p))
            call OTime.subtract(p,&LocalOffset,p);
    }

  /**
   * OTime.getGlobalTime adds current displacement 
   * to the localTime. 
   */
  command void OTime.getGlobalTime( timeSyncPtr p ) { 
    call OTime.pubLocalTime(p);
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
   *  time value (where each jiffie is 145.636 seconds)
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
     // resolution for Telos will be like MicaZ
     v = (t->ClockL >> 27);
     w = (t->ClockH & 0x07);
     return (w<<5) + v;   // convert to new jiffie
     }

  /**
   *  Read local time to the 145-sec jiffie, converting
   *  to 1-byte units.
   */
  command uint8_t OTime.getLocalTimeByte( ) {
     timeSync_t t; 
     call OTime.getLocalTime(&t);
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
   * OTime.setStepBack schedules a backward adjustment
   * to Local/Global clock, upon next reading
   */
  command void OTime.setStepBack( uint16_t amt ) {
    stepBack = amt;
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
  async command void OTime.subtract( timeSyncPtr a, timeSyncPtr b, 
  				     timeSyncPtr c ) {
    timeSync_t v;   // in case pointer c=b or c=a
    v.ClockH = a->ClockH - b->ClockH;
    v.ClockL = a->ClockL - b->ClockL;
    if (a->ClockL < b->ClockL) v.ClockH--;
    c->ClockH = v.ClockH;  c->ClockL = v.ClockL;
    }

  /**
   *  Convert MicaZ time value (microsec) to Telos (microsec)
   */
  async command void OTime.Z2Tel( timeSyncPtr p ) {
    bigClock u;
    uint64_t d;
    u.partsInt.hi = p->ClockH;
    u.partsInt.lo = p->ClockL;
    d = u.bigInt.g / 4096;      // correction factor
    u.bigInt.g *= 256;          // jiffies 921600 -> jiffies 1024^2
    u.bigInt.g /= 225;
    u.bigInt.g -= d;        
    p->ClockH = u.partsInt.hi;
    p->ClockL = u.partsInt.lo;
    }
  async command void OTime.Z2Tels( uint32_t * p ) {
    uint32_t d = (*p) / 4096;
    *p *= 256;
    *p /= 225;
    *p -= d;
    }

  /**
   * return current calibration ratio
   */
  command float OTime.calibrate() { return calibrateRatio; }

  /**
   * Internal Calibration:  measure native microsecond rate versus
   * native, binary millisecond clock rate.
   */
  task void doCalibrate() {
    int64_t a,b;
    float x,y;
    uint32_t curMilli;
    uint32_t curMicro;
    timeSync_t v;   
    curMilli = call OTime.getBinaryMilli();
    call OTime.getLocalTime( &v );
    #if defined(PLATFORM_MICAZ) 
     call OTime.Z2Tel( &v );  // convert to Telos-style, binary milliseconds
    #endif
    curMicro = v.ClockL;

    // initialize if this is a first-time call or there is a rollover
    if (calibrateMilli == 0 || calibrateMicro == 0 || 
        calibrateMilli > curMilli || calibrateMicro > curMicro) {
       calibrateMilli = curMilli; 
       calibrateMicro = curMicro;   
       return;   // no ratio known yet
       }

    // ensure that interval between previous recorded value
    // and the current time is at least a minute 
    if (curMilli - calibrateMilli < 61440u) // = 1024*60 
       return;

    // calculate new rate-difference-ratio and reset the calibration variables
    a = curMilli;
    a -= calibrateMilli;
    a *= 1024;      // this would be number of binary microseconds
    b = curMicro;
    b -= calibrateMicro;
    x = a - b;      // this is number of binary microseconds (difference)
    y = b;
    calibrateRatio = x / y;  // question: what about overflow?
    calibrateMilli = curMilli;
    calibrateMicro = curMicro;
    }

  /**
   * Periodic firing of Wakker so we get a recent base
   * on the current value of system clock:  at least every  
   * BETWEEN_INTERVAL (often enough not to skip rollover)
   * seconds, call OTime.getLocalTime() to keep intervals between
   * clock readings short (so as not to miss an overflow) 
   */
  event error_t Wakker.wakeup(uint8_t indx, uint32_t wake_time) {
    post doCalibrate();
    call Wakker.soleSet(0,BETWEEN_INTERVAL*8);   // reschedule self  
    return SUCCESS;
    }

  async event void Counter32.overflow() { }
  async event void CounterMicro.overflow() { }
  command uint32_t OTime.getBinaryMilli() {
    uint32_t v;
    atomic v = call LocalTime.get();
    return v;
    }
}
  
