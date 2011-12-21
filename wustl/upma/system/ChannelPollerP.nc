/*
 * "Copyright (c) 2007 Washington University in St. Louis.
 * All rights reserved.
 *
 * Permission to use, copy, modify, and distribute this software and its
 * documentation for any purpose, without fee, and without written agreement is
 * hereby granted, provided that the above copyright notice, the following
 * two paragraphs and the author appear in all copies of this software.
 *
 * IN NO EVENT SHALL WASHINGTON UNIVERSITY IN ST. LOUIS BE LIABLE TO ANY PARTY
 * FOR DIRECT, INDIRECT, SPECIAL, INCIDENTAL, OR CONSEQUENTIAL DAMAGES ARISING
 * OUT OF THE USE OF THIS SOFTWARE AND ITS DOCUMENTATION, EVEN IF WASHINGTON
 * UNIVERSITY IN ST. LOUIS HAS BEEN ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
 *
 * WASHINGTON UNIVERSITY IN ST. LOUIS SPECIFICALLY DISCLAIMS ANY WARRANTIES,
 * INCLUDING, BUT NOT LIMITED TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY
 * AND FITNESS FOR A PARTICULAR PURPOSE.  THE SOFTWARE PROVIDED HEREUNDER IS
 * ON AN "AS IS" BASIS, AND WASHINGTON UNIVERSITY IN ST. LOUIS HAS NO
 * OBLIGATION TO PROVIDE MAINTENANCE, SUPPORT, UPDATES, ENHANCEMENTS, OR
 * MODIFICATIONS."
 */

#include "Lpl.h"
 
/**
 * Automatically performs periodic LPL checks.
 *
 * @author Greg Hackmann
 */
module ChannelPollerP @safe()
{
	provides interface ChannelPoller;
	provides interface StdControl;
	
	uses interface Alarm<TMilli, uint16_t>;
	uses interface ChannelMonitor;
	uses interface Leds;
	uses interface State;
}
implementation
{
	enum
	{
		S_IDLE = 0,
		S_CHECKING = 1,
	};
	
	enum
	{
		DUTY_ON_TIME = 6
	};
	
	bool running_ = FALSE;

	uint16_t ms_ = LPL_DEF_LOCAL_WAKEUP;
	
	async event void Alarm.fired()
	{
		// If the channel poller is active
		if(running_)
		{
			call Alarm.start(ms_);
			// Restart the timer
			call State.forceState(S_CHECKING);
			// Move into the busy state
			call ChannelMonitor.check();
			// Do a CCA check
		}
	}
		
	async event void ChannelMonitor.busy()
	{
		if(call State.isIdle())
			return;
		// If the check isn't for us, ignore it
			
		call State.toIdle();
		signal ChannelPoller.activityDetected(TRUE);
		// Move into the idle state and signal that the channel is busy
	}
	
	async event void ChannelMonitor.free()
	{
		if(call State.isIdle())
			return;
		// If the check isn't for us, ignore it
			
		call State.toIdle();
		signal ChannelPoller.activityDetected(FALSE);
		// Move into the idle state and signal that the channel is free
	}
	
	async event void ChannelMonitor.error() { }
	
	async command void ChannelPoller.setWakeupInterval(uint16_t ms)
	{
		atomic ms_ = ms;
		if(running_)
			call Alarm.start(ms);
		// Save the sleep interval, and reset the alarm if the poller is active
	}
	
	async command uint16_t ChannelPoller.getWakeupInterval()
	{
		atomic return ms_;
	}
	
	command error_t StdControl.start()
	{
		atomic
		{
			running_ = TRUE;
			if(ms_ > 0)
				call Alarm.start(ms_);
			// Note that we're active, and start the alarm if possible
		}
		return SUCCESS;
	}

	command error_t StdControl.stop()
	{
		call Alarm.stop();
		atomic running_ = FALSE;
		// Note that we're inactive and stop the alarm
		return SUCCESS;
	}
}
