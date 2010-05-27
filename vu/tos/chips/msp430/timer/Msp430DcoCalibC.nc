/*
 * Copyright (c) 2010, Vanderbilt University
 * All rights reserved.
 *
 * Permission to use, copy, modify, and distribute this software and its
 * documentation for any purpose, without fee, and without written agreement is
 * hereby granted, provided that the above copyright notice, the following
 * two paragraphs and the author appear in all copies of this software.
 * 
 * IN NO EVENT SHALL THE VANDERBILT UNIVERSITY BE LIABLE TO ANY PARTY FOR
 * DIRECT, INDIRECT, SPECIAL, INCIDENTAL, OR CONSEQUENTIAL DAMAGES ARISING OUT
 * OF THE USE OF THIS SOFTWARE AND ITS DOCUMENTATION, EVEN IF THE VANDERBILT
 * UNIVERSITY HAS BEEN ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
 * 
 * THE VANDERBILT UNIVERSITY SPECIFICALLY DISCLAIMS ANY WARRANTIES,
 * INCLUDING, BUT NOT LIMITED TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY
 * AND FITNESS FOR A PARTICULAR PURPOSE.  THE SOFTWARE PROVIDED HEREUNDER IS
 * ON AN "AS IS" BASIS, AND THE VANDERBILT UNIVERSITY HAS NO OBLIGATION TO
 * PROVIDE MAINTENANCE, SUPPORT, UPDATES, ENHANCEMENTS, OR MODIFICATIONS.
 *
 * Author: Janos Sallai
 */ 

configuration Msp430DcoCalibC
{
	provides interface StdControl;
}
implementation
{
  components Msp430DcoCalibP, Msp430TimerC, McuSleepC;

  Msp430DcoCalibP.TimerMicro -> Msp430TimerC.TimerB;
  Msp430DcoCalibP.Timer32khz -> Msp430TimerC.TimerA;
  Msp430DcoCalibP.McuPowerOverride <- McuSleepC;
  
  StdControl = Msp430DcoCalibP;
  
  // debugging
  components DiagMsgC, LedsC;
  Msp430DcoCalibP.DiagMsg -> DiagMsgC;
  Msp430DcoCalibP.Leds -> LedsC;
}

