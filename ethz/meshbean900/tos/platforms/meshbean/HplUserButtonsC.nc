/* Copyright (c) 2009, Distributed Computing Group (DCG), ETH Zurich.
*  All rights reserved.
*
*  Redistribution and use in source and binary forms, with or without
*  modification, are permitted provided that the following conditions
*  are met:
*
*  1. Redistributions of source code must retain the above copyright
*     notice, this list of conditions and the following disclaimer.
*  2. Redistributions in binary form must reproduce the above copyright
*     notice, this list of conditions and the following disclaimer in the
*     documentation and/or other materials provided with the distribution.
*  3. Neither the name of the copyright holders nor the names of
*     contributors may be used to endorse or promote products derived
*     from this software without specific prior written permission.
*
*  THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS `AS IS'
*  AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE
*  IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE
*  ARE DISCLAIMED.  IN NO EVENT SHALL THE COPYRIGHT HOLDERS OR CONTRIBUTORS
*  BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR
*  CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO, LOSS OF USE, DATA,
*  OR PROFITS) HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN
*  CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE)
*  ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF
*  THE POSSIBILITY OF SUCH DAMAGE.
*
*  @author Roland Flury <rflury@tik.ee.ethz.ch>
*  @author Philipp Sommer <sommer@tik.ee.ethz.ch>
*  @author Richard Huber <rihuber@ee.ethz.ch>
*  @author Thomas Fahrni <tfahrni@ee.ethz.ch>
* 
*/


configuration HplUserButtonsC
{
	provides interface GeneralIO as GeneralIOButton1;
  	provides interface GpioInterrupt as GpioInterruptButton1;
  	
  	provides interface GeneralIO as GeneralIOButton2;
  	provides interface GpioInterrupt as GpioInterruptButton2;

	provides interface Init as PlatformInit;

}
implementation
{

	components HplAtm128GeneralIOC as GeneralIOC;
	components HplAtm128InterruptC as InterruptC;
	
	// GeneralIO
	GeneralIOButton1 = GeneralIOC.PortE6;
	GeneralIOButton2 = GeneralIOC.PortE7;
	
	// Interrupt UB1
	components new Atm128GpioInterruptC() as InterruptUserButton1C;
	InterruptUserButton1C.Atm128Interrupt -> InterruptC.Int6;
	GpioInterruptButton1 = InterruptUserButton1C.Interrupt;
	
	// Interrupt UB2
	components new Atm128GpioInterruptC() as InterruptUserButton2C;
	InterruptUserButton2C.Atm128Interrupt -> InterruptC.Int7;
	GpioInterruptButton2 = InterruptUserButton2C.Interrupt;
	
	// Init
	components HplUserButtonsP;
	PlatformInit = HplUserButtonsP;
	HplUserButtonsP.GeneralIOButton1 -> GeneralIOC.PortE6;
	HplUserButtonsP.GeneralIOButton2 -> GeneralIOC.PortE7;

}
