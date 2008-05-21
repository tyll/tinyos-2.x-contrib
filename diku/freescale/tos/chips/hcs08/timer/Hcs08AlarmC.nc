//$Id$

/* "Copyright (c) 2000-2003 The Regents of the University of California.
 * All rights reserved.
 *
 * Permission to use, copy, modify, and distribute this software and its
 * documentation for any purpose, without fee, and without written agreement
 * is hereby granted, provided that the above copyright notice, the following
 * two paragraphs and the author appear in all copies of this software.
 *
 * IN NO EVENT SHALL THE UNIVERSITY OF CALIFORNIA BE LIABLE TO ANY PARTY FOR
 * DIRECT, INDIRECT, SPECIAL, INCIDENTAL, OR CONSEQUENTIAL DAMAGES ARISING OUT
 * OF THE USE OF THIS SOFTWARE AND ITS DOCUMENTATION, EVEN IF THE UNIVERSITY
 * OF CALIFORNIA HAS BEEN ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
 *
 * THE UNIVERSITY OF CALIFORNIA SPECIFICALLY DISCLAIMS ANY WARRANTIES,
 * INCLUDING, BUT NOT LIMITED TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY
 * AND FITNESS FOR A PARTICULAR PURPOSE.  THE SOFTWARE PROVIDED HEREUNDER IS
 * ON AN "AS IS" BASIS, AND THE UNIVERSITY OF CALIFORNIA HAS NO OBLIGATION TO
 * PROVIDE MAINTENANCE, SUPPORT, UPDATES, ENHANCEMENTS, OR MODIFICATIONS."
 */

/**
 * Hcs08AlarmC is a generic component that wraps the Hcs08 HPL timers and
 * compares into a TinyOS Alarm.
 * 
 * Adapted from Msp430Alarm
 *
 * @author Cory Sharp <cssharp@eecs.berkeley.edu>
 * @author Tor Petterson <motor@diku.dk>
 * @see  Please refer to TEP 102 for more information about this component and its
 *          intended use.
 */

generic module Hcs08AlarmC(typedef frequency_tag)
{
  provides interface Init;
  provides interface Alarm<frequency_tag,uint16_t> as Alarm;
  uses interface Hcs08Timer;
  uses interface Hcs08TimerControl;
  uses interface Hcs08Compare;
}
implementation
{
  command error_t Init.init()
  {
    call Hcs08TimerControl.disableEvents();
    call Hcs08TimerControl.setMode(HSC08TIMER_M_COM);
    call Hcs08TimerControl.setPin(HSC08TIMER_P_OFF);
    return SUCCESS;
  }

  async command void Alarm.start( uint16_t dt )
  {
    call Alarm.startAt( call Alarm.getNow(), dt );
  }

  async command void Alarm.stop()
  {
    call Hcs08TimerControl.disableEvents();
  }

  async event void Hcs08Compare.fired()
  {
    call Hcs08TimerControl.disableEvents();
    signal Alarm.fired();
  }

  async command bool Alarm.isRunning()
  {
    return call Hcs08TimerControl.areEventsEnabled();
  }

  async command void Alarm.startAt( uint16_t t0, uint16_t dt )
  {
    atomic
    {
      uint16_t now = call Hcs08Timer.get();
      uint16_t elapsed = now - t0;
      if( elapsed >= dt )
      {
        call Hcs08Compare.setEventFromNow(2); //this might have to be a bigger number since this i a micro timer
      }
      else
      {
        uint16_t remaining = dt - elapsed;
        if( remaining <= 2 )
          call Hcs08Compare.setEventFromNow(2);//this might have to be a bigger number since this i a micro timer
        else
          call Hcs08Compare.setEvent( now+remaining );
      }
      call Hcs08TimerControl.clearPendingInterrupt();
      call Hcs08TimerControl.enableEvents();
    }
  }

  async command uint16_t Alarm.getNow()
  {
    return call Hcs08Timer.get();
  }

  async command uint16_t Alarm.getAlarm()
  {
    return call Hcs08Compare.getEvent();
  }

  async event void Hcs08Timer.overflow()
  {
  }
}

