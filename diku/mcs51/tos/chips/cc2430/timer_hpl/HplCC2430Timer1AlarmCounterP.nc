
/*
 * Copyright (c) 2007 University of Copenhagen
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
 * - Neither the name of University of Copenhagen nor the names of
 *   its contributors may be used to endorse or promote products derived
 *   from this software without specific prior written permission.
 *
 * THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS
 * ``AS IS'' AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT
 * LIMITED TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS
 * FOR A PARTICULAR PURPOSE ARE DISCLAIMED.  IN NO EVENT SHALL THE UNIVERSITY
 * OF COPENHAGEN OR ITS CONTRIBUTORS BE LIABLE FOR ANY DIRECT, INDIRECT,
 * INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES
 * (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR
 * SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION)
 * HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT,
 * STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE)
 * ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED
 * OF THE POSSIBILITY OF SUCH DAMAGE.
 */

/**
 *
 * @author Martin Leopold <leopold@diku.dk>
 */

/**
 * Exports Timer1 as Alarm/Counter interfaces
 *  
 *   The frequency is just there for show - it doesnt really do anything
 *
 * Note: The byte order of the registers i very important: the low
 * byte must always be read or written first!
 */

generic module HplCC2430Timer1AlarmCounterP( typedef frequency ) {
  provides interface Counter<frequency, uint16_t> as Counter;
  provides interface Alarm<frequency, uint16_t> as Alarm0;
  provides interface Alarm<frequency, uint16_t> as Alarm1;
  provides interface Alarm<frequency, uint16_t> as Alarm2;
  provides interface Init;

} implementation {

  /*
   * Argh.. Do we know if Timer1.init() has finished by this point?
   */
  command error_t Init.init() {

    T1CCTL1 = 0;
    T1CCTL2 = 0;

    T1CNTL = 0; T1CNTH = 0;
    //T1CTL  = ((T1CTL & ~CC2430_T1CTL_DIV_MASK) | CC2430_TIMER1_DIV_8);
    //T1CTL  = ((T1CTL & ~CC2430_T1CTL_DIV_MASK) | CC2430_TIMER1_DIV_32);
    //T1CTL  = ((T1CTL & ~CC2430_T1CTL_DIV_MASK) | CC2430_TIMER1_DIV_128);
    T1CTL  = ((T1CTL & ~CC2430_T1CTL_DIV_MASK) | CC2430_TIMER1_DIV_1);

    // Clear all interrupt flags
    T1CTL &= ~(CC2430_T1_CH0IF) & ~(CC2430_T1_CH1IF) & ~(CC2430_T1_CH2IF) & ~(CC2430_T1_OVFIF);

    // Compare register 0
    T1CCTL0 |= (1 << CC2430_T1CCTLx_MODE); // Mode = compare
    //T1CCTL0 |= (1 << CC2430_T1CCTLx_IM) | (1 << CC2430_T1CCTLx_MODE);

    // Start compare running
    T1IE   = 1;   // enable events
    TIMIF |= _BV(CC2430_TIMIF_OVFIM); // Enable overflow int
    T1CCTL0 |= 0x40; // Compare int on
    T1CTL  = (T1CTL & ~CC2430_T1CTL_MODE_MASK) | CC2430_TIMER1_MODE_FREE;
    //T1CCTL0 &= ~0x40; // Compare int off
    //T1CTL |= 1; //CC2430_TIMER1_MODE_FREE
    //T1CTL &= ~2; //CC2430_TIMER1_MODE_FREE

    return SUCCESS;
  }
 
// ORDER IS IMPORTANT HERE! Allways read Low register first!!
#define GET_NOW(p) ((uint8_t*)&p)[1]=T1CNTL;\
                   ((uint8_t*)&p)[0]=T1CNTH

/*********************************************************************
 *                              Alarm 0                              *
 *********************************************************************/ 

  async command void Alarm0.stop(){   T1CCTL0 &= ~_BV(CC2430_T1CCTLx_IM) ;  }
  async command bool Alarm0.isRunning(){ return (T1CCTL0 & _BV(CC2430_T1CCTLx_IM)); }
  async command uint16_t Alarm0.getAlarm(){
    uint16_t r;
    // Order is important!! Read low first!!
    ((uint8_t*)&r)[1] = T1CC0L;
    ((uint8_t*)&r)[0] = T1CC0H;
    return (r); 
  }

  async command uint16_t Alarm0.getNow(){
    uint16_t r;
    /*    ((uint8_t*)&r)[1] = T1CNTL;
      ((uint8_t*)&r)[0] = T1CNTH;*/
    GET_NOW(r);

    return r;
  }

  async command void Alarm0.start(uint16_t dt){
    uint16_t now;
    /*now = call Alarm0.getNow();
    ((uint8_t*)&now)[1] = (uint8_t) T1CNTL;
    ((uint8_t*)&now)[0] = (uint8_t) T1CNTH;*/
    GET_NOW(now);

    call Alarm0.startAt( now, dt );
  }

  async command void Alarm0.startAt(uint16_t t0, uint16_t dt){
    uint16_t set, now, elapsed;

    atomic {
      GET_NOW(now);
      /*((uint8_t*)&now)[1] = (uint8_t) T1CNTL;
    ((uint8_t*)&now)[0] = (uint8_t) T1CNTH;*/

      elapsed = now - t0; // This number wraps if counter has wrapped
   
      if( elapsed >= dt )  {
    set = now + 5; // elapse in 5 tics
      } else {
    uint16_t remaining = dt - elapsed;
    if( remaining <= 5 )  {
      set = now + 5; // elapse in 5 tics
    } else {
      set = remaining + now;
    }
      }

    // Order is important!! Allways write Low byte first!!
    T1CC0L = (uint8_t) ((uint8_t*)&set)[1];
    T1CC0H = (uint8_t) ((uint8_t*)&set)[0];
    T1CCTL0 |= _BV(CC2430_T1CCTLx_IM);  // Enable interrupt mask
    }

    return;
  }

/*********************************************************************
 *                              Alarm 1                              *
 *********************************************************************/ 

  async command void Alarm1.stop(){   T1CCTL1 &= ~_BV(CC2430_T1CCTLx_IM) ;  }
  async command bool Alarm1.isRunning(){ return (T1CCTL1 & _BV(CC2430_T1CCTLx_IM)); }
  async command uint16_t Alarm1.getAlarm(){
    uint16_t r;
    // Order is important!! Read low first!!
    ((uint8_t*)&r)[1] = T1CC1L;
    ((uint8_t*)&r)[0] = T1CC1H;
    return (r); 
  }

  async command uint16_t Alarm1.getNow(){
    uint16_t r;
    GET_NOW(r);
    return r;
  }

  async command void Alarm1.start(uint16_t dt){
    uint16_t now;
    GET_NOW(now);
    call Alarm1.startAt( now, dt );
  }

  async command void Alarm1.startAt(uint16_t t0, uint16_t dt){
    uint16_t set, now, elapsed;

    atomic {
      GET_NOW(now);

      elapsed = now - t0; // This number wraps if counter has wrapped
   
      if( elapsed >= dt )  {
    set = now + 5; // elapse in 5 tics
      } else {
    uint16_t remaining = dt - elapsed;
    if( remaining <= 5 )  {
      set = now + 5; // elapse in 5 tics
    } else {
      set = remaining + now;
    }
      }

    // Order is important!! Allways write Low byte first!!
    T1CC1L = (uint8_t) ((uint8_t*)&set)[1];
    T1CC1H = (uint8_t) ((uint8_t*)&set)[0];
    T1CCTL1 |= _BV(CC2430_T1CCTLx_IM);  // Enable interrupt mask
    }

    return;
  }

/*********************************************************************
 *                              Alarm 2                              *
 *********************************************************************/ 

  async command void Alarm2.stop(){   T1CCTL2 &= ~_BV(CC2430_T1CCTLx_IM) ;  }
  async command bool Alarm2.isRunning(){ return (T1CCTL2 & _BV(CC2430_T1CCTLx_IM)); }
  async command uint16_t Alarm2.getAlarm(){
    uint16_t r;
    // Order is important!! Read low first!!
    ((uint8_t*)&r)[1] = T1CC2L;
    ((uint8_t*)&r)[0] = T1CC2H;
    return (r); 
  }

  async command uint16_t Alarm2.getNow(){
    uint16_t r;
    GET_NOW(r);
    return r;
  }

  async command void Alarm2.start(uint16_t dt){
    uint16_t now;
    GET_NOW(now);
    call Alarm2.startAt( now, dt );
  }

  async command void Alarm2.startAt(uint16_t t0, uint16_t dt){
    uint16_t set, now, elapsed;

    atomic {
      GET_NOW(now);

      elapsed = now - t0; // This number wraps if counter has wrapped
   
      if( elapsed >= dt )  {
    set = now + 5; // elapse in 5 tics
      } else {
    uint16_t remaining = dt - elapsed;
    if( remaining <= 5 )  {
      set = now + 5; // elapse in 5 tics
    } else {
      set = remaining + now;
    }
      }

    // Order is important!! Allways write Low byte first!!
    T1CC2L = (uint8_t) ((uint8_t*)&set)[1];
    T1CC2H = (uint8_t) ((uint8_t*)&set)[0];
    T1CCTL2 |= _BV(CC2430_T1CCTLx_IM);  // Enable interrupt mask
    }

    return;
  }

/*********************************************************************
 *                              Junk                                 *
 *********************************************************************/ 

      /*
    now = GET_NOW();
    elapsed now - t0;
    //((uint8_t*)&now)[0] = (uint8_t) T1CNTH;
    //((uint8_t*)&now)[1] = (uint8_t) T1CNTL;
    stor = now + dt; //t0 + dt;
    set = (uint16_t) (stor % 0xFFFF);

       T1CC0H = (uint8_t) ((uint8_t*)&set)[0];
       T1CC0L = (uint8_t) ((uint8_t*)&set)[1];
       T1CCTL0 |= _BV(CC2430_T1CCTLx_IM);  // Enable interrupt mask
     return;
      */
 
         /* This stuff is stolen from the atm128 platfom (David Gay) */
     /* Leave it here for now ...*/
    //    uint32_t expires, guardedExpires, stor;
    //uint16_t compare, more_now;
    //const uint8_t mindt = 2;

    //now = call Alarm0.getNow();
//    ((uint8_t*)&now)[0] = (uint8_t) T1CNTH;
//    ((uint8_t*)&now)[1] = (uint8_t) T1CNTL;
//
//    if (dt < mindt)
//      dt = mindt;
//
//    expires = t0 + dt;
//
//    guardedExpires = expires - mindt;
//    if (t0 <= now)     {
//      //if it's in the past or the near future, fire now (i.e., test
//      //     guardedExpires <= now in wrap-around arithmetic).
//  if (guardedExpires >= t0 && // if it wraps, it's > now
//      guardedExpires <= now) {
//    //compare = call Alarm0.getNow() + mindt;
//    ((uint8_t*)&more_now)[0] = (uint8_t) T1CNTH;
//    ((uint8_t*)&more_now)[1] = (uint8_t) T1CNTL;
//    compare = more_now + mindt;
//  }
//  else
//    compare = expires;
//      }
//    else
//      {
//  // again, guardedExpires <= now in wrap-around arithmetic
//  if (guardedExpires >= t0 || // didn't wrap so < now
//      guardedExpires <= now) {
//    //compare = call Alarm0.getNow() + mindt ;
//    ((uint8_t*)&more_now)[0] = (uint8_t) T1CNTH;
//    ((uint8_t*)&more_now)[1] = (uint8_t) T1CNTL;
//    compare = more_now + mindt;
//  }
//  else
//    compare = expires;
//      }
//    T1CC0H = (uint8_t) ((uint8_t*)&compare)[0];
//    T1CC0L = (uint8_t) ((uint8_t*)&compare)[1];
//    //T1CTL  &= ~CC2430_T1_CH0IF;          // Clear IF
//    //T1CCTL0 |= _BV(CC2430_T1CCTLx_IM);  // Enable interrupt mask (IM)
//
//    return;
//

/*********************************************************************
 *                              Counter                              *
 *********************************************************************/ 

  async command uint16_t Counter.get() {
    uint16_t r;
    ((uint8_t*)&r)[1] = T1CNTL;
    ((uint8_t*)&r)[0] = T1CNTH;

    return r;
  }
  async command bool Counter.isOverflowPending() {
    return( T1CTL & CC2430_T1_OVFIF );
  }
  async command void Counter.clearOverflow()     {
    T1CTL &= ~CC2430_T1_OVFIF;
  }

/*********************************************************************
 *                              Interrupts                           *
 *********************************************************************/ 

  /*
   * The interrupt handler will be executed regardless of which
   * interrupt has been issued. Since the compare registers are likely
   * to fire with masks off - we need to check that this particular
   * interrupt is actually enabled.
   */

  MCS51_INTERRUPT(SIG_T1) { 
    atomic{
      if ( (T1CCTL2 & _BV(CC2430_T1CCTLx_IM)) && (T1CTL & CC2430_T1_CH2IF) ) {
    T1CTL   &= ~_BV(CC2430_T1CTL_CH2IF);   // Clear IF
    T1CCTL2 &= ~_BV(CC2430_T1CCTLx_IM);    // Clear IM - startAt sets it
    signal Alarm2.fired();
      }
      if ( (T1CCTL1 & _BV(CC2430_T1CCTLx_IM)) && (T1CTL & CC2430_T1_CH1IF) ) {
    T1CTL   &= ~_BV(CC2430_T1CTL_CH1IF);   // Clear IF
    T1CCTL1 &= ~_BV(CC2430_T1CCTLx_IM);    // Clear IM - startAt sets it
    signal Alarm1.fired();
      }
      if ( (T1CCTL0 & _BV(CC2430_T1CCTLx_IM)) && (T1CTL & CC2430_T1_CH0IF) ) {
    T1CTL   &= ~_BV(CC2430_T1CTL_CH0IF);    // Clear IF
    T1CCTL0 &= ~_BV(CC2430_T1CCTLx_IM);     // Clear IM - startAt sets it
    signal Alarm0.fired();
      }
      if (T1CTL & CC2430_T1_OVFIF) {
    T1CTL   &= ~_BV(CC2430_T1CTL_OVFIF);   // Clear IF
    signal Counter.overflow();
      }
    }
  }

 default async event void Counter.overflow() { }
 default async event void Alarm0.fired() { }
 default async event void Alarm1.fired() { }
 default async event void Alarm2.fired() { }
}
