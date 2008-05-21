
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
 * Microsec alarm
 *
 * @author Cory Sharp <cssharp@eecs.berkeley.edu>
 * @see  Please refer to TEP 102 for more information about this component and its
 *          intended use.
 */

generic configuration AlarmMicroC()
{
  provides interface Init;
  provides interface Alarm<TMicro,uint16_t> as AlarmMicro16;
  provides interface Alarm<TMicro,uint32_t> as AlarmMicro32;
}
implementation
{
  components new Hcs08TimerMicroC() as Hcs08Timer
           , new Hcs08AlarmC(TMicro) as Hcs08Alarm
           , new TransformAlarmC(TMicro,uint32_t,TMicro,uint16_t,0) as Transform
           , CounterMicroC as Counter
           ;

  Init = Hcs08Alarm;

  AlarmMicro16 = Hcs08Alarm;
  AlarmMicro32 = Transform;

  Transform.AlarmFrom -> Hcs08Alarm;
  Transform.Counter -> Counter;

  Hcs08Alarm.Hcs08Timer -> Hcs08Timer;
  Hcs08Alarm.Hcs08TimerControl -> Hcs08Timer;
  Hcs08Alarm.Hcs08Compare -> Hcs08Timer;
}

