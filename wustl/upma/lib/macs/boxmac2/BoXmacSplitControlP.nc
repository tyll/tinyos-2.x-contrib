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
 * Turns the X-MAC MAC layer on and off as a whole.
 *
 * @author Greg Hackmann
 */
module BoXmacSplitControlP
{
	provides interface SplitControl;
	
	uses interface RadioPowerControl;
	uses interface StdControl as SenderControl;
	uses interface StdControl as ChannelPollerControl;
	uses interface State;
}
implementation
{
	enum
	{
		S_STOPPED = 0,
		S_STARTING = 1,
		S_STARTED = 2,
		S_STOPPING = 3,
	};
	
	command error_t SplitControl.start()
	{
		if(call State.getState() != S_STOPPED)
			return FAIL;
		// Make sure we're off
		
		call State.forceState(S_STARTING);
		return call RadioPowerControl.start();
		// Turn on the radio
	}
	
	event void RadioPowerControl.startDone(error_t err)
	{
		// If we're busy powering everything up
		if(call State.getState() == S_STARTING)
		{
			call State.forceState(S_STARTED);
			call SenderControl.start();	
			call ChannelPollerControl.start();
			signal SplitControl.startDone(SUCCESS);
			// Turn on the Sender and poller, then signal success
		}
	}
	
	command error_t SplitControl.stop()
	{
		if(call State.getState() != S_STARTED)
			return FAIL;
		// Make sure we're on
		
		call State.forceState(S_STOPPING);
		call ChannelPollerControl.stop();
		call SenderControl.stop();
		return call RadioPowerControl.stop();
		// Turn off the poller, Sender, and radio
	}
	
	event void RadioPowerControl.stopDone(error_t err)
	{
		if(call State.getState() == S_STOPPING)
		{
			call State.forceState(S_STOPPED);
			signal SplitControl.stopDone(SUCCESS);
			// Signal success
		}
	}
}
