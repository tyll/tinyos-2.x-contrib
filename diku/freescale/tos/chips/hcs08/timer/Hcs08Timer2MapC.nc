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
 * Hcs08Timer1MapC presents as a paramaterized interface the 3 channel timer TPM1
 * on the Hcs08.
 * 
 * Adapted from Msp430Timer32khzMapC.
 *
 * @author Cory Sharp <cssharp@eecs.berkeley.edu>
 * @author Tor Petterson <motor@diku.dk>
 */

configuration Hcs08Timer2MapC
{
  provides interface Hcs08Timer[ uint8_t id ];
  provides interface Hcs08TimerControl[ uint8_t id ];
  provides interface Hcs08Compare[ uint8_t id ];
}
implementation
{
  components Hcs08TimerC;

  Hcs08Timer[0] = Hcs08TimerC.Timer2;
  Hcs08TimerControl[0] = Hcs08TimerC.Control2C0;
  Hcs08Compare[0] = Hcs08TimerC.Compare2C0;

  Hcs08Timer[1] = Hcs08TimerC.Timer2;
  Hcs08TimerControl[1] = Hcs08TimerC.Control2C1;
  Hcs08Compare[1] = Hcs08TimerC.Compare2C1;

  Hcs08Timer[2] = Hcs08TimerC.Timer2;
  Hcs08TimerControl[2] = Hcs08TimerC.Control2C2;
  Hcs08Compare[2] = Hcs08TimerC.Compare2C2;

  Hcs08Timer[3] = Hcs08TimerC.Timer2;
  Hcs08TimerControl[3] = Hcs08TimerC.Control2C3;
  Hcs08Compare[3] = Hcs08TimerC.Compare2C3;

  Hcs08Timer[4] = Hcs08TimerC.Timer2;
  Hcs08TimerControl[4] = Hcs08TimerC.Control2C4;
  Hcs08Compare[4] = Hcs08TimerC.Compare2C4;
}

