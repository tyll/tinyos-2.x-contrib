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
 * @author Cory Sharp <cssharp@eecs.berkeley.edu>
 */

/**
 * HilTimerMilliC provides a parameterized interface to a virtualized
 * millisecond timer and local time in milli precision.  TimerMilliC in
 * tos/system/ uses this component to allocate new timers.
 * See TEP 102 for more information.
 *
 * @author Henrik Makitaavola
 */

configuration HilTimerMilliC
{
  provides interface Init;

  provides interface Timer<TMilli> as TimerMilli[ uint8_t num ];
  provides interface LocalTime<TMilli>;
}
implementation
{
  components new AlarmToTimerC(TMilli);
  components new VirtualizeTimerC(TMilli,uniqueCount(UQ_TIMER_MILLI));
  components new CounterToLocalTimeC(TMilli);
#ifdef ENABLE_STOP_MODE
  components RV8564AlarmCounterMilli32C as AlarmCounterMilli32C;
#else
  components AlarmCounterMilli32C;
#endif

  TimerMilli = VirtualizeTimerC;
  LocalTime = CounterToLocalTimeC;

  VirtualizeTimerC.TimerFrom -> AlarmToTimerC;
  AlarmToTimerC.Alarm -> AlarmCounterMilli32C.Alarm;
  CounterToLocalTimeC.Counter -> AlarmCounterMilli32C.Counter;
  Init = AlarmCounterMilli32C;
}
