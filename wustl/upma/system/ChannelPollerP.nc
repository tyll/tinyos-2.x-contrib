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
 
/**
 * Automatically performs periodic LPL checks.
 *
 * @author Greg Hackmann
 */
module ChannelPollerP
{
	provides interface ChannelPoller;
	provides interface LowPowerListening;
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
	uint16_t ms_ = 0;
	
	uint16_t getActualDutyCycle(uint16_t dutyCycle);
	
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
	
	async command void LowPowerListening.setLocalSleepInterval(uint16_t ms)
	{
		atomic ms_ = ms;
		if(running_)
			call Alarm.start(ms);
		// Save the sleep interval, and reset the alarm if the poller is active
	}
	
	async command uint16_t LowPowerListening.getLocalSleepInterval()
	{
		atomic return ms_;
	}
	
	async command void LowPowerListening.setLocalDutyCycle(uint16_t dutyCycle)
	{
		uint16_t ms = call LowPowerListening.dutyCycleToSleepInterval(dutyCycle);
		call LowPowerListening.setLocalSleepInterval(ms);
	}
	
	async command uint16_t LowPowerListening.getLocalDutyCycle()
	{
		uint16_t ms = call LowPowerListening.getLocalSleepInterval();
		return call LowPowerListening.sleepIntervalToDutyCycle(ms);
	}
	
	async command uint16_t LowPowerListening.dutyCycleToSleepInterval(uint16_t dutyCycle)
	{
		dutyCycle = getActualDutyCycle(dutyCycle);
		if(dutyCycle == 10000)
			return 0;
		
		return (DUTY_ON_TIME * (10000 - dutyCycle)) / dutyCycle;
	}
	
	async command uint16_t LowPowerListening.sleepIntervalToDutyCycle(uint16_t ms)
	{
		if(ms == 0)
			return 10000;
		return getActualDutyCycle((DUTY_ON_TIME * 10000) / (ms + DUTY_ON_TIME));
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

	uint16_t getActualDutyCycle(uint16_t dutyCycle)
	{
		if(dutyCycle > 10000)
			return 10000;
		else if(dutyCycle == 0)
			return 1;
		return dutyCycle;
	}
}
