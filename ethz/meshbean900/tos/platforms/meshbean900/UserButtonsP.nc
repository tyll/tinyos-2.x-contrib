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

module UserButtonsP
{
	provides interface UserButtons;
	
	uses
	{
		// Userbutton 1
		interface Get<button_state_t> as UB1Get;
		interface Notify<button_state_t> as UB1Notify;
		
		// Userbutton 2
		interface Get<button_state_t> as UB2Get;
		interface Notify<button_state_t> as UB2Notify;
	}
}

implementation
{

	// Userbutton 1
	
	command button_state_t UserButtons.UB1Get()
	{
		button_state_t val = BUTTON_RELEASED;
		if(call UB1Get.get() == 0)
		{
			val = BUTTON_PRESSED;
		}
		return val;
	}
	
	command void UserButtons.UB1Enable()
	{
		call UB1Notify.enable();
	}
	
	command void UserButtons.UB1Disable()
	{
		call UB1Notify.disable();
	}
	
	event void UB1Notify.notify(bool val)
	{
		button_state_t sigVal = BUTTON_RELEASED;
		if(val == 0)
		{
			sigVal = BUTTON_PRESSED;
		}
		signal UserButtons.UB1Notify(sigVal);
	}
	
	
	// Userbutton 2

	command button_state_t UserButtons.UB2Get()
	{
		button_state_t val = BUTTON_RELEASED;
		if(call UB2Get.get() == 0)
		{
			val = BUTTON_PRESSED;
		}
		return val;
	}

	command void UserButtons.UB2Enable()
	{
		call UB2Notify.enable();
	}
	
	command void UserButtons.UB2Disable()
	{
		call UB2Notify.disable();
	}

	event void UB2Notify.notify(bool val)
	{
		button_state_t sigVal = BUTTON_RELEASED;
		if(val == 0)
		{
			sigVal = BUTTON_PRESSED;
		}
		signal UserButtons.UB2Notify(sigVal);	
	}
}
