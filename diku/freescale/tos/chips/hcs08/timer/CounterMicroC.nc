
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
 * CounterMicroC is the counter to be used for all usecs.
 *
 * @author Cory Sharp <cssharp@eecs.berkeley.edu>
 * @author Tor Petterson <motor@diku.dk>
 * @see  Please refer to TEP 102 for more information about this component and its
 *          intended use.
 */

#include "Timer.h"

configuration CounterMicroC
{
  provides interface Counter<TMicro,uint16_t> as CounterMicro16;
  provides interface Counter<TMicro,uint32_t> as CounterMicro32;
  provides interface LocalTime<TMicro> as LocalTimeMicro;
}
implementation
{
  components Hcs08TimerC
           , Hcs08CounterMicroC
           , new TransformCounterC(TMicro,uint32_t,TMicro,uint16_t,0,uint16_t) as Transform
           , new CounterToLocalTimeC(TMicro)
           ;

  CounterMicro16 = Hcs08CounterMicroC;
  CounterMicro32 = Transform.Counter;
  LocalTimeMicro = CounterToLocalTimeC;

  CounterToLocalTimeC.Counter -> Transform;
  Transform.CounterFrom -> Hcs08CounterMicroC;
}

