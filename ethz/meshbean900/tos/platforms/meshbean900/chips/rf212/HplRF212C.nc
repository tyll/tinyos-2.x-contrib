/*
 * Copyright (c) 2007, Vanderbilt University
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
 * Author: Miklos Maroti
 */

#include <RadioConfig.h>

configuration HplRF212C
{
	provides
	{
		interface GeneralIO as SELN;
		interface Resource as SpiResource;
		interface FastSpiByte;

		interface GeneralIO as SLP_TR;
		interface GeneralIO as RSTN;

		interface GpioCapture as IRQ;
		interface Alarm<TRadio, uint16_t> as Alarm;
		interface LocalTime<TRadio> as LocalTimeRadio;
	}
}

implementation
{
	components HplRF212P;
	IRQ = HplRF212P.IRQ;

	HplRF212P.PortIRQ -> IO.PortE5;
	
	components Atm128SpiC as SpiC;
	SpiResource = SpiC.Resource[unique("Atm128SpiC.Resource")];
	FastSpiByte = SpiC;

	components HplAtm128GeneralIOC as IO;
	SLP_TR = IO.PortB4;
	RSTN = IO.PortA7;
	SELN = IO.PortB0;

	components HplAtm128InterruptC;
    HplRF212P.Interrupt -> HplAtm128InterruptC.Int5;

	components HplAtm128Timer3C as TimerC;
	HplRF212P.Timer -> TimerC;

	components new AlarmThree16C() as AlarmC;
	Alarm = AlarmC;

	components RealMainP;
	RealMainP.PlatformInit -> HplRF212P.PlatformInit;

	components LocalTimeMicroC;
	LocalTimeRadio = LocalTimeMicroC;
	
	components McuSleepC;
    McuSleepC.McuPowerOverride -> HplRF212P;
	
	
}
