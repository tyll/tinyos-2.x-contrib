
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
 * Exports Timer1 as Alarm/Counter interfaces This version uses the
 *  HPL timer interface, it has been replaced by
 *  HPLCC2430Timer1AlarmCounterP that uses Timer1 directly. This
 *  conserves stackspace in the absence of inline.
 *
 * Note: The fake interrupt mask for compare channels has NOT been
 * implemented - this causes tremendous jitter in the timer intervals
 *
 * isRunning is not implemented
 */

generic module CC2430Timer1AlarmCounterP( typedef frequency ) {
  provides interface Counter<frequency, uint16_t> as Counter;
  provides interface Alarm<frequency, uint16_t> as Alarm0;
  provides interface Init;

  uses interface HplCC2430Timer16 as Timer1;

} implementation {

  /*
   * Argh.. Do we know if Timer1.init() has finished by this point?
   */
  command error_t Init.init() {
    call Timer1.set(0);
    call Timer1.setScale(CC2430_TIMER1_DIV_128);
    call Timer1.clearIf(CC2430_T1_CH0IF);
    call Timer1.clearIf(CC2430_T1_CH1IF);
    call Timer1.clearIf(CC2430_T1_CH2IF);
    call Timer1.clearIf(CC2430_T1_OVFIF);
    call Timer1.enableOverflow();
    call Timer1.enableEvents();
    call Timer1.setMode(CC2430_TIMER1_MODE_FREE);

    call Timer1.enableCompare0();
    return SUCCESS;
  }
 
  async command void Alarm0.stop(){ call Timer1.disableCompare0(); }
  async command bool Alarm0.isRunning(){ return TRUE; }
  async command uint16_t Alarm0.getAlarm(){ return (call Timer1.getCompare0()); }
  async command uint16_t Alarm0.getNow(){ return call Timer1.get(); }

  async command void Alarm0.start(uint16_t dt){
    call Alarm0.startAt(call Timer1.get(), dt);
  }

  async command void Alarm0.startAt(uint16_t t0, uint16_t dt){
    /* Stolen fra mica128 code by David Gay*/

    now = call Timer1.get();
    dbg("Atm128AlarmC", "   starting timer at %llu with dt %llu\n", (uint64_t)t0, (uint64_t) dt);
    /* We require dt >= mindt to avoid setting an interrupt which is in
       the past by the time we actually set it. mindt should always be
       at least 2, because you cannot set an interrupt one cycle in the
       future. It should be more than 2 if the timer's clock rate is
       very high (e.g., equal to the processor clock). */
    if (dt < mindt)
      dt = mindt;

    expires = t0 + dt;

    guardedExpires = expires - mindt;

    /* t0 is assumed to be in the past. If it's numerically greater than
       now, that just represents a time one wrap-around ago. This requires
       handling the t0 <= now and t0 > now cases separately. 

       Note also that casting compared quantities to timer_size produces
       predictable comparisons (the C integer promotion rules would make it
       hard to write correct code for the possible timer_size size's) */
    if (t0 <= now)
      {
	/* if it's in the past or the near future, fire now (i.e., test
	   guardedExpires <= now in wrap-around arithmetic). */
	if (guardedExpires >= t0 && // if it wraps, it's > now
	    guardedExpires <= now) 
	  call Timer1.setCompare0(call Timer1.get() + mindt);
	else
	  call Timer1.setCompare0(expires);
      }
    else
      {
	/* again, guardedExpires <= now in wrap-around arithmetic */
	if (guardedExpires >= t0 || // didn't wrap so < now
	    guardedExpires <= now)
	  call Timer1.setCompare0(call Timer1.get() + mindt);
	else
	  call Timer1.setCompare0(expires);
      }
    call Timer1.enableCompare0();
  }

  async command uint16_t Counter.get() {
    return call Timer1.get();
  }
  async command bool Counter.isOverflowPending() {
    return (call Timer1.isIfPending(CC2430_T1_OVFIF));
  }
  async command void Counter.clearOverflow()     {
    call Timer1.clearIf(CC2430_T1_OVFIF); 
  }

  async event void Timer1.fired() {
    if (call Timer1.isIfPending(CC2430_T1_CH2IF)){
    }
    if (call Timer1.isIfPending(CC2430_T1_CH1IF)){
    }
    if (call Timer1.isIfPending(CC2430_T1_CH0IF)){
      call Timer1.disableCompare0();
      call Timer1.clearIf(CC2430_T1_CH0IF);
      signal Alarm0.fired();
    }
    if (call Timer1.isIfPending(CC2430_T1_OVFIF)) {
      call Timer1.clearIf(CC2430_T1_OVFIF);
      signal Counter.overflow();
    }
  }

 default async event void Counter.overflow() { }
 default async event void Alarm0.fired() { }
}
