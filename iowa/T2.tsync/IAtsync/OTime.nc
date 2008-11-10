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
interface OTime {

  /**
   *  Initialize OTime (necessary, to set up recurring task, etc)
   */
  command void init();

  /**
   * Read current global time scaled to 
   * 32 bits (but dropping the two most significant
   * bits, for increased accuracy).
   *
   * OK, here's the deal:  the timeSync structure
   * keeps time as an unsigned 48-bit number, where
   * the least significant bit is derived from the SysTime
   * component.  According to the document there (as of 
   * April 2004), the SysTime in platform/mica2 scales the 
   * timer to get 921.6 KHz (ticks/second).  That means 
   * each tick is 1.08507 microseconds.  So a 48-bit number
   * can be about (2^48)*1.08507=3.08466e8 seconds, or about
   * 9.7747 years of time before rollover.  My measurements
   * of MicaZ platform indicated that a more accurate count
   * for ticks per second is 921.778 KHz, but I use the 
   * 921.6 KHz figure because 921600 = (32*30)^2, which makes
   * conversion to Telos ticks per second, 2^20, simpler.
   * 
   * However, the interface requirement here is for 32 bits, 
   * with a desired precision around 1 millisecond, so
   * we drop the 10 low-order (least significant) bits.
   * That means each "jiffy" in the result is 1.11111 milliseconds.
   *
   */
  command uint32_t getGlobalTime32( );

  /**
   *  Read Local Time scaled to 32 bits -- same documentation
   *  as for getGlobalTime32, but this one just returns the
   *  result for the local time (with no skew adjust).
   */
  command uint32_t getLocalTime32( );

  /**
   *  Telos:
   *   Return current native 32kHz counter value shifted to
   *   binary microseconds.  That is, 32kHz means one jiffie 
   *   is 1/32768 -- not 32000.  Thus one jiffie 
   *   would be 1/(2^10).  Converting T such jiffies to 
   *   binary microseconds (= 1/(2^20) jiffies) means just 
   *   a multiply by 2^10 (shift left 10).  
   *  MicaZ:
   *   Return the native microsecond clock, but converted
   *   to Telos units of 1/(2^10).  This conversion is included
   *   basically because I can see no reason to offer the 
   *   ersatz 32kHz counter given by TinyOS.
   */
  async command uint32_t getNative32( );

  /**
   * Telos:
   *  just like getNative32, i.e., 32khz counter * 2^10 
   * MicaZ:
   *  return the native microsecond clock
   */
  async command uint32_t getStableMicro32( );

  /**
   *   Return current native microsecond counter value (different from
   *   getLocalTime32, because there is no 48-bit clock backing up carries,
   *   and on msp430 platform, getLocalTime uses the 32kHz counter).
   *  Telos:
   *   The getNativeMicro is *unstable* for duration more than 6400
   *   ticks, because the microsecond clock's skew is +/- 0.5% (the
   *   figure 6400 is derived from 
   *       (6400 / (2^20)) * 0.005 = 3.05176e-5 
   *   and 1/32768 = 30.5176 microseconds;  hence it is better to 
   *   use the 32KHz clock for longer durations.
   *  MicaZ:
   *   The getNativeMicro works well, but as noted above, the 
   *   the jiffies are determined by 921.6 or 921.778 KHz.
   */
  async command uint32_t getNativeMicro( );


  /**
   *  All platforms:  this is a wrapper for LocalTime.get()
   *  as documented in TEP 102.  It returns a value
   *  from the _binary_ millisecond counter.  With the 32-bit
   *  width, it will roll over in about 48 days.  Conversion
   *  from binary milliseconds to 1/32768 jiffies:  x <<= 5.
   */
  command uint32_t getBinaryMilli();

  /**
   *  Convert a timeSync to 145.636-second-jiffies, truncated 
   *  to a single byte, which rolls over every ten hours. 
   */
  command uint8_t convTimeByte( timeSyncPtr t );

  /**
   *  Read local time in 145.636-second-jiffies, truncated 
   *  to a single byte, which rolls over every ten hours. 
   */
  command uint8_t getLocalTimeByte( );

  /**
   *  Read global time in 145.636-second-jiffies, truncated 
   *  to a single byte, which rolls over every ten hours. 
   */
  command uint8_t getGlobalTimeByte( );

  /**
   * Calculate absolute difference between two 1-byte time
   * values (where each jiffie is 145.636 seconds);  result
   * is somewhat ambiguous, due to rollover;  we assume here
   * that the first parameter is "larger" than the second
   * parameter (which may not strictly look true, because of
   * rollover, but used wisely, this works anyway).
   */
  command uint8_t subtractTimeByte( uint8_t a, uint8_t b );

  /**
   * Convert 1/8-second units to 1-byte time value
   */
  command uint8_t convEightTimeByte( uint32_t time );

  /**
   *  Convert a timeSync value to eighths of second unit
   */
  command uint32_t convTimeEights( timeSyncPtr r ); 

  /**
   *  Convert a timeSync value to one-second units 
   */
  command uint32_t convTimeSeconds( timeSyncPtr r ); 

  /**
   *  Read global time to the second (rounding down to
   *  the nearest second)
   */
  command uint32_t getGlobalTimeSeconds( );

  /**
   *  Read global time to the eighth-second (rounding down to
   *  the nearest eighth-second)
   */
  command uint32_t getGlobalTimeEights( );

  /**
   * Read current global time.
   */
  command void getGlobalTime( timeSyncPtr t );

  /**
   * Get/Set offset of global time wrt local time (always an additive adjust)
   */
  command void getGlobalOffset( timeSyncPtr t );
  command void setGlobalOffset( timeSyncPtr t );

  /**
   * Add specified amount to the offset of global time wrt local time
   */
  command void adjGlobalTime( timeSyncPtr t );

  /**
   * Set a "set back" amount, to be applied with the next local or
   * global time fetch.
   */
  command void setStepBack( uint16_t amt );

  /**
   * Read current local time.  
   *         In provided structure, getLocalTime puts the current 
   *         number of ticks on the clock.  Each tick represents 
   *         1/2^20 = 0.953674 microseconds (Telos) or similar,
   *         after conversion from local architecture.
   * Implementation Notes:
   *      1. getLocalTime calculates the current skew factor as a 
   *         side-effect, but DOES NOT apply this skew adjustment to
   *         the value it returns in timeSyncPtr t.  If the 
   *         invocation is within INTERVAL_WO_SKEW jiffies of a previous
   *         call to getLocalTime, this extra side-effect is merely 
   *         interpolated, rather than fully calculated, so as 
   *         to avoid a case of numerical insignificance (because skew 
   *         applied to very small numbers would be zero);  in such cases
   *         the skew adjustment just adds the elapsed number of 
   *         jiffies between calls (ie, a crude interpolation).  
   *      2. Currently, there is no explicit support for rollover.
   */
  command void getLocalTime( timeSyncPtr t );
  /**
   *  Adjoint to getLocalTime:  return the native Microsec clock value 
   *  associated with the last call of getLocalTime
   */
  command uint32_t getLastLTMicro();  

  /**
   * Read current local time, but also apply skew to it; 
   * this is only used for "public" exposure of local time,
   * as in beacon messages or by Global Time routines, so
   * they have a basis that includes skew.  The logic is simple,
   * consisting of calling getLocalTime and then adding the 
   * skew adjustment that getLocalTime has already calculated.
   */
  command void pubLocalTime( timeSyncPtr t );

  /**
   * The following just returns the most recent previous
   * result of getLocalTime (a quick-and-dirty timestamp)
   */
  command void getLastLocalTime( timeSyncPtr t );

  /**
   * Convert current local time.  
   *         Converts provided local time to global 
   *         (just adding a displacement).
   * Version 1 just adds the global displacment;
   * Version 2 also adds the current skew displacement
   * (NOTE: Version 2 therefore presumes the input is
   *  a value very near the current local time value)
   */
  command void conv1LocalTime( timeSyncPtr t );
  command void conv2LocalTime( timeSyncPtr t );

  /**
   * Set/get skew factor to desired deviation from 1.0
   */
  command void setSkew( float skew );
  command float getSkew( );

  /**
   * Arithmetic functions on timeSync_t objects
   */
  async command void add( timeSyncPtr a, timeSyncPtr b, timeSyncPtr c );
  async command void subtract( timeSyncPtr a, timeSyncPtr b, timeSyncPtr c );
  command bool lesseq( timeSyncPtr a, timeSyncPtr b );

  /**
   * sanity checking function (bigCheck)
   *  returns TRUE if two timeSync_t objects differ by 
   *  more than a threshold (given as a uint32_t value) 
   */
  command bool bigjump( timeSyncPtr a, timeSyncPtr b, uint32_t t );

  /**
   * Conversion from 921600 ticks per second to 2^20 ticks per second
   * (but also works for 32 "KHz" conversion, ie 28800 to 32768)
   */
  async command void Z2Tel( timeSyncPtr p );
  async command void Z2Tels( uint32_t * p );

  /**
   * Calibrate method is just for fun.  It returns the ratio of 
   * the native, non-CPU 32KHz clock (2^15=32768 ticks per second)
   * to the CPU microsecond clock over a "long" period, that is, 
   * for at least one minute before calculation.  In the case of 
   * MicaZ, the CPU microsecond clock is first converted, using 
   * the Z2Tel method above, to approximately binary microseconds.
   *
   * Notes on the (float) value returned:
   *
   * 1.  If zero, then either the ratio is perfect 1/1, or there 
   *     haven't been enough clock measurements yet to determine
   *     the ratio.  The measurement and calculation is driven
   *     by calling calibrate(), so you should call calibrate() 
   *     periodically to get a measurement.
   *
   * 2.  Instead of just the ratio (32KHz-rate)/(microsecond-rate)
   *     which would be some number close to 1.0, we calculate 
   *          (32KHz-rate * 32) - (microsecond-rate) 
   *          -------------------------------------- 
   *                   microsecond-rate
   *     because this gets higher precision (more significant digits)
   *     and should be some number in [0,+/-10^-5], according to 
   *     datasheets for current platform technology.
   */
  command float calibrate( );
  }

