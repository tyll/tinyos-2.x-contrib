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

#include "TestMsg.h"

generic module TestC(bool sends)
{
	uses interface Boot;
	uses interface Scp;
	uses interface Interval as SyncInterval;
	uses interface Timer<TMilli> as Timer;
	uses interface Leds;
	uses interface SplitControl as RadioControl;
	uses interface AMSend;
	uses interface Receive;
	
	uses interface AMSend as AMSerial;
}
implementation
{
	message_t msg;
	
	event void Boot.booted()
	{
		call RadioControl.start();
	}
	
	event void RadioControl.startDone(error_t err)
	{
		call SyncInterval.set(15000);
		call Scp.setWakeupInterval(3000);
		call Timer.startPeriodic(5000);
	}
	
	event void RadioControl.stopDone(error_t err)
	{
	}
	
	event void Timer.fired()
	{
		if(sends)
		{
			TestMsg * payload = (TestMsg *)call AMSend.getPayload(&msg, sizeof(TestMsg));
			payload->payload[0] = 'T';
			payload->payload[1] = 'e';
			payload->payload[2] = 's';
			payload->payload[3] = 't';
			payload->payload[4] = '\0';
			if(call AMSend.send(AM_BROADCAST_ADDR, &msg, sizeof(TestMsg)) == SUCCESS)
				call Leds.led0On();
		}
	}
	
	event void AMSend.sendDone(message_t * m, error_t error)
	{
		call Leds.led0Off();
	}
	
	event message_t * Receive.receive(message_t * m, void * payload, uint8_t len)
	{
		call Leds.led1Toggle();
		call AMSerial.send(AM_BROADCAST_ADDR, m, len);
		return m;
	}
	
	event void AMSerial.sendDone(message_t * m, error_t error) { }
}
