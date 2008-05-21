
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
 * AlarmMilliC is the alarm for async millisecond alarms
 *
 * @author Cory Sharp <cssharp@eecs.berkeley.edu>
 * @author Tor Petterson <motor@diku.dk>
 * @see  Please refer to TEP 102 for more information about this component and its
 *          intended use.
 */
 
generic configuration AlarmMilliC()
{
  provides interface Init;
  provides interface Alarm<TMilli,uint32_t> as AlarmMilli32;
}
implementation
{
  components new Hcd08TimerMicroC() as Hcs08Timer
           , new Hcs08AlarmC(TMicro) as Hcs08Alarm
           , new TransformAlarmC(TMilli,uint32_t,TMicro,uint16_t,10) as Transform
           , CounterMilliC as Counter
           ;

  Init = Hcs08Alarm;

  AlarmMilli32 = Transform;

  Transform.AlarmFrom -> Hcs08Alarm;
  Transform.Counter -> Counter;

  Hcs08Alarm.Hcs08Timer -> Hcs08Timer;
  Hcs08Alarm.Hcs08TimerControl -> Hcs08Timer;
  Hcs08Alarm.Hcs08Compare -> Hcs08Timer;
}

