
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
 * @author Tor Petterson <motor@diku.dk>
 */

configuration Hcs08TimerC
{
  provides interface Hcs08Timer as Timer1;
  provides interface Hcs08TimerControl as Control1C0;
  provides interface Hcs08TimerControl as Control1C1;
  provides interface Hcs08TimerControl as Control1C2;
  provides interface Hcs08Compare as Compare1C0;
  provides interface Hcs08Compare as Compare1C1;
  provides interface Hcs08Compare as Compare1C2;
  
  provides interface Hcs08Timer as Timer2;
  provides interface Hcs08TimerControl as Control2C0;
  provides interface Hcs08TimerControl as Control2C1;
  provides interface Hcs08TimerControl as Control2C2;
  provides interface Hcs08TimerControl as Control2C3;
  provides interface Hcs08TimerControl as Control2C4;
  provides interface Hcs08Compare as Compare2C0;
  provides interface Hcs08Compare as Compare2C1;
  provides interface Hcs08Compare as Compare2C2;
  provides interface Hcs08Compare as Compare2C3;
  provides interface Hcs08Compare as Compare2C4;
}
implementation
{
  components new Hcs08TimerP( TPM1SC_Addr, TPM1CNTH_Addr, TPM1MODH_Addr ) as Hcs08Timer1
           , new Hcs08TimerP( TPM2SC_Addr, TPM2CNTH_Addr, TPM2MODH_Addr ) as Hcs08Timer2
           , new Hcs08TimerCapComP( TPM1C0SC_Addr, TPM1C0VH_Addr ) as Hcs08Timer1C0
           , new Hcs08TimerCapComP( TPM1C1SC_Addr, TPM1C1VH_Addr ) as Hcs08Timer1C1
           , new Hcs08TimerCapComP( TPM1C2SC_Addr, TPM1C2VH_Addr ) as Hcs08Timer1C2
           , new Hcs08TimerCapComP( TPM2C0SC_Addr, TPM2C0VH_Addr ) as Hcs08Timer2C0
           , new Hcs08TimerCapComP( TPM2C1SC_Addr, TPM2C1VH_Addr ) as Hcs08Timer2C1
           , new Hcs08TimerCapComP( TPM2C2SC_Addr, TPM2C2VH_Addr ) as Hcs08Timer2C2
           , new Hcs08TimerCapComP( TPM2C3SC_Addr, TPM2C3VH_Addr ) as Hcs08Timer2C3
           , new Hcs08TimerCapComP( TPM2C4SC_Addr, TPM2C4VH_Addr ) as Hcs08Timer2C4
           , Hcs08TimerCommonP as Common, McuSleepC
           ;

  // Timer 1
  Timer1 = Hcs08Timer1.Timer;
  Hcs08Timer1.Overflow -> Common.TPM1Overflow;
  
  // Timer 1 channel 0
  Control1C0 = Hcs08Timer1C0.Control;
  Compare1C0 = Hcs08Timer1C0.Compare;
  Hcs08Timer1C0.Timer -> Hcs08Timer1.Timer;
  Hcs08Timer1C0.Event -> Common.TPM1CH0;
  McuSleepC.McuPowerState <- Hcs08Timer1C0;

  // Timer 1 channel 1
  Control1C1 = Hcs08Timer1C1.Control;
  Compare1C1 = Hcs08Timer1C1.Compare;
  Hcs08Timer1C1.Timer -> Hcs08Timer1.Timer;
  Hcs08Timer1C1.Event -> Common.TPM1CH1;
  McuSleepC.McuPowerState <- Hcs08Timer1C1;
  
  // Timer 1 channel 2
  Control1C2 = Hcs08Timer1C2.Control;
  Compare1C2 = Hcs08Timer1C2.Compare;
  Hcs08Timer1C2.Timer -> Hcs08Timer1.Timer;
  Hcs08Timer1C2.Event -> Common.TPM1CH2;
  McuSleepC.McuPowerState <- Hcs08Timer1C2;
  
  // Timer 2
  Timer2 = Hcs08Timer2.Timer;
  Hcs08Timer2.Overflow -> Common.TPM2Overflow;
  
  // Timer 2 channel 0
  Control2C0 = Hcs08Timer2C0.Control;
  Compare2C0 = Hcs08Timer2C0.Compare;
  Hcs08Timer2C0.Timer -> Hcs08Timer2.Timer;
  Hcs08Timer2C0.Event -> Common.TPM2CH0;
  McuSleepC.McuPowerState <- Hcs08Timer2C0;

  // Timer 2 channel 1
  Control2C1 = Hcs08Timer2C1.Control;
  Compare2C1 = Hcs08Timer2C1.Compare;
  Hcs08Timer2C1.Timer -> Hcs08Timer2.Timer;
  Hcs08Timer2C1.Event -> Common.TPM2CH1;
  McuSleepC.McuPowerState <- Hcs08Timer2C1;

  // Timer 2 channel 2
  Control2C2 = Hcs08Timer2C2.Control;
  Compare2C2 = Hcs08Timer2C2.Compare;
  Hcs08Timer2C2.Timer -> Hcs08Timer2.Timer;
  Hcs08Timer2C2.Event -> Common.TPM2CH2;
  McuSleepC.McuPowerState <- Hcs08Timer2C2;

  // Timer 2 channel 3
  Control2C3 = Hcs08Timer2C3.Control;
  Compare2C3 = Hcs08Timer2C3.Compare;
  Hcs08Timer2C3.Timer -> Hcs08Timer2.Timer;
  Hcs08Timer2C3.Event -> Common.TPM2CH3;
  McuSleepC.McuPowerState <- Hcs08Timer2C3;

  // Timer 2 channel 4
  Control2C4 = Hcs08Timer2C4.Control;
  Compare2C4 = Hcs08Timer2C4.Compare;
  Hcs08Timer2C4.Timer -> Hcs08Timer2.Timer;
  Hcs08Timer2C4.Event -> Common.TPM2CH4;
  McuSleepC.McuPowerState <- Hcs08Timer2C4;

}

