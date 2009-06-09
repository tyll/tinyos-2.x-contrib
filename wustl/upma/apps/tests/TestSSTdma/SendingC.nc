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
 * @author Octav Chipara
 * @version $Revision$
 * @date $Date$
 */

static uint32_t csmaCalls;


generic module SendingC(uint16_t interval, bool sends)
{
	uses
	{
		interface Boot;
		interface Leds;
		interface AMSend as AMSender;
		interface Receive as AMReceiver;
		interface Packet;
		interface Timer<TMilli> as SendTimer;
		interface Timer<TMilli> as FlushTimer;
		interface Timer<TMilli> as BenchmarkTimer;
		interface Timer<TMilli> as StartTimer;
		interface Counter<T32khz, uint32_t> as Counter;
		interface SplitControl;

		interface HplMsp430GeneralIO as Pin;
		interface HplMsp430GeneralIO as RcvPin;
		interface Stats;
	}
}

implementation
{
	enum
	{
		BENCHMARK_LENGTH = 10 * 1024,
	};
	
	message_t packet;
	uint8_t *nodeId;
	uint16_t packetsSent, packetsReceived;
	bool sends;
	uint32_t sendTime;
	uint32_t latency;

	task void sendTask() {
		//printf("send task\n");
		if(sends == FALSE)
		{
			//call Pin.set();
			//call Leds.led0Toggle();
			//printf("app send\n");
			if (call AMSender.send(AM_BROADCAST_ADDR, &packet, 2 * sizeof(uint8_t)) != SUCCESS) {
				post sendTask();
			} else {
				sends = TRUE;
				sendTime = call Counter.get();
			}
		}
	}
	
	
	event void Boot.booted()
	{
		sends = FALSE;
		packetsSent = 0;
		packetsReceived  = 0;
		latency = 0;
		csmaCalls = 0;
		post sendTask();
		//call FlushTimer.startPeriodic(250);
		call SplitControl.start();
	}
	
	

	event void AMSender.sendDone(message_t * bufPtr, error_t error)
	{
		if (&packet == bufPtr) {
			uint32_t now = call Counter.get();
			latency = latency + (now - sendTime);
		
		
			//printf("app send done now=%lu sendTime=%lu latency=%lu\n", now, sendTime, (now - sendTime));
			//call Leds.led0Toggle();
			if (error == SUCCESS) packetsSent++;
			sends = FALSE;
			//call Pin.toggle();
			post sendTask();
		}
	}
	
	task void flush() {
		printfflush();
	}

	async event void Counter.overflow() {
		printf("Overflow");
		post flush();
	}
	
	event void FlushTimer.fired() {
				//call Leds.led2Toggle();
		printfflush();
	}
	
	event void SendTimer.fired()
	{
		//post sendTask();
	}
	
	event message_t * AMReceiver.receive(message_t * message, void * payload, uint8_t length)
	{
		//call RcvPin.toggle();
		packetsReceived++;
		return message;
	}
	
	event void SplitControl.startDone(error_t err)
	{	
		nodeId = (uint8_t *)call Packet.getPayload(&packet, sizeof(uint8_t));
		*nodeId = TOS_NODE_ID;

		//printf("starting");
		
		if (TOS_NODE_ID != 0)  {
			call SendTimer.startPeriodic(3000);
		}
		call StartTimer.startOneShot(1000);
		//call Leds.led0On();
		//call Leds.led1On();
		//call Leds.led2On();
	}

	event void SplitControl.stopDone(error_t err)
	{
	}
	
	event void StartTimer.fired()
	{
		call BenchmarkTimer.startPeriodic(BENCHMARK_LENGTH);
	}
		
	event void BenchmarkTimer.fired()
	{
		//call Leds.led0On();
		uint32_t avg_latency = 0;
		if (packetsSent != 0) avg_latency = latency / packetsSent;
		
		printf("STATS: %u %u %lu csma %d cca %d busy %d\n", 
			packetsSent, 
			packetsReceived, 
			avg_latency, 
			call Stats.getCsmaCalls(),
			call Stats.getCcaCalls(),
			call Stats.getFailedCcas());
		packetsSent = 0;
		packetsReceived  = 0;
		latency = 0;
		call Stats.setCsmaCalls(0);
		call Stats.setCcaCalls(0);
		call Stats.setFailedCcas(0);
		printfflush();	
	}
	
}
