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
 * Implements the dummy MAC layer's pass-through behavior.
 *
 * @author Greg Hackmann
 */
module NoPowerManagerP
{
	provides interface SplitControl;
	
	uses interface RadioPowerControl;
	uses interface ChannelMonitor;
	uses interface Resend;
	uses interface PacketAcknowledgements;
}
implementation
{
	async event void ChannelMonitor.error() { }
	async event void ChannelMonitor.busy() { }
	async event void ChannelMonitor.free() { }
	
	command error_t SplitControl.start()
	{
		return call RadioPowerControl.start();
	}
	
	event void RadioPowerControl.startDone(error_t err)
	{
		signal SplitControl.startDone(err);
	}

	command error_t SplitControl.stop()
	{
		return call RadioPowerControl.stop();
	}
	
	event void RadioPowerControl.stopDone(error_t err)
	{
		signal SplitControl.stopDone(err);
	}	
}
