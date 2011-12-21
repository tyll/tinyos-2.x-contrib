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
 *
 * @author Greg Hackmann
 * @version $Revision$
 * @date $Date$
 */

generic module SendingC(uint16_t interval, bool sends)
{
	uses
	{
		interface Boot;
		interface Leds;
		interface LowPowerListening;
//		interface RadioDutyCycling;
		interface AMSend as AMSender;
		interface Receive as AMReceiver;
		interface Packet;
		interface Timer<TMilli> as SendTimer;
		interface SplitControl;
//		interface Random;
	}
}

implementation
{
	message_t packet;

	event void Boot.booted()
	{
		call SplitControl.start();
	}

	event void AMSender.sendDone(message_t * bufPtr, error_t error)
	{
		if(error != SUCCESS)
		{
			call Leds.led0On();
			call Leds.led1On();
			call Leds.led2On();
		}
		else
			call Leds.led2Off();
	}

	event void SendTimer.fired()
	{
		if(sends)
		{
			call Leds.led2On();
			call AMSender.send(AM_BROADCAST_ADDR, &packet, 2 * sizeof(uint8_t));
		}
	}
	
	event message_t * AMReceiver.receive(message_t * message, void * payload, uint8_t length)
	{
		call Leds.led1Toggle();
		return message;
	}
	
	event void SplitControl.startDone(error_t err)
	{
		uint8_t * nodeId;
		call LowPowerListening.setLocalWakeupInterval(interval);
			
		nodeId = (uint8_t *)call Packet.getPayload(&packet, sizeof(uint8_t));
		*nodeId = TOS_NODE_ID;

		call SendTimer.startPeriodic(8000);
	}

	event void SplitControl.stopDone(error_t err)
	{
	}
}
