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


#include "UserButton.h"

configuration UserButtonsC
{
	// Button 1
	provides interface Get<button_state_t> as Button1Get;
  	provides interface Notify<button_state_t> as Button1Notify;
  	
  	// Button 2
  	provides interface Get<button_state_t> as Button2Get;
  	provides interface Notify<button_state_t> as Button2Notify;
}

implementation
{
	components HplUserButtonsC;

	components RealMainP;
    RealMainP.PlatformInit -> HplUserButtonsC.PlatformInit;

	// SwichToggleC connects GeneralIO and Get as well as GpioInterrupt and Notify
  	components new SwitchToggleC() as SwitchToggleButton1;
  	SwitchToggleButton1.GpioInterrupt -> HplUserButtonsC.GpioInterruptButton1;
  	SwitchToggleButton1.GeneralIO -> HplUserButtonsC.GeneralIOButton1;
  	
  	components new SwitchToggleC() as SwitchToggleButton2;
  	SwitchToggleButton2.GpioInterrupt -> HplUserButtonsC.GpioInterruptButton2;
  	SwitchToggleButton2.GeneralIO -> HplUserButtonsC.GeneralIOButton2;
	
  	Button1Get = SwitchToggleButton1.Get;
  	Button1Notify = SwitchToggleButton1.Notify;
  	
	Button2Get = SwitchToggleButton2.Get;
  	Button2Notify = SwitchToggleButton2.Notify;

}
