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
 * @author Greg Hackmann,Mo Sha
 * @version $Revision$
 * @date $Date$
 */
module DutyCycleBenchmarkC
{
	uses interface Boot;
	uses interface Leds;
	uses interface AMSend as AMSender;
	uses interface Receive as AMReceiver;
	uses interface Packet;
	//uses interface CC2420Packet;
	uses interface SplitControl;
	uses interface LowPowerListening;
#ifdef SCP
	uses interface Interval as SyncInterval;
#endif
	
#ifdef SCP
	uses interface Timer<TMilli> as StartTimer;
#endif
	uses interface Timer<TMilli> as SendTimer;
}
implementation
{
	uint16_t packetCount = 0;
	
	enum
	{
		PACKET_LENGTH = TOSH_DATA_LENGTH - FOOTER_SIZE,
		NUM_SAMPLES = 30,
		SAMPLE_INTERVAL = 2000U,
		RECEIVER = 0,
	};
	
	message_t packet;

	void send();
	task void sendResult();
	
	task void doSend() { send(); }
	void send()
	{
		if(call AMSender.send(RECEIVER, &packet, PACKET_LENGTH) != SUCCESS)
			post doSend();
	}
	
	event void Boot.booted()
	{
#ifdef UPMA
#ifndef TDMA
		call LowPowerListening.setLocalWakeupInterval(PREAMBLE_LENGTH);
#endif
#ifdef SCP
		call SyncInterval.set(PREAMBLE_LENGTH * 10U);
#endif
#else
		call LowPowerListening.setLocalWakeupInterval(PREAMBLE_LENGTH);
		call LowPowerListening.setRemoteWakeupInterval(&packet, PREAMBLE_LENGTH);
#endif
		call SplitControl.start();
	}
	
	event void AMSender.sendDone(message_t * msg, error_t err)
	{
		uint8_t * payload = (uint8_t *)call Packet.getPayload(&packet, PACKET_LENGTH);
		if(err == SUCCESS)
		{
			packetCount++;
			payload[0] = (uint8_t)(packetCount >> 8);
			payload[1] = (uint8_t)packetCount;

			if(packetCount == NUM_SAMPLES)
				post sendResult();		
		}
		
//		else if(TOS_NODE_ID != RECEIVER)
//			send();
	}
	
	event void SplitControl.startDone(error_t err)
	{
		memset(call Packet.getPayload(&packet, PACKET_LENGTH), TOS_NODE_ID, PACKET_LENGTH);
		//call CC2420Packet.setPower(&packet, 0);

#ifdef SCP
		call StartTimer.startOneShot(15000);
	}
	
	event void StartTimer.fired()
	{
//		call BenchmarkTimer.startOneShot(BENCHMARK_LENGTH);*/
#endif
		if(TOS_NODE_ID != RECEIVER)
			call SendTimer.startPeriodic(SAMPLE_INTERVAL);
	}
	
	event void SendTimer.fired()
	{
		send();
	}
	
	event message_t * AMReceiver.receive(message_t * msg, void * payload, uint8_t len)
	{
//		if(call BenchmarkTimer.isRunning())
//			packetCount++;
		return msg;
	}

	event void SplitControl.stopDone(error_t err) { }
	
//	message_t result;
	
	task void sendResult()
	{
		call Leds.led0On();
		printf("%lu\n", vDutyCycle);
		printf("%lu\n", oscDutyCycle);
		printf("%lu\n", radioDutyCycle);
		printf("%lu\n%lu\n", radioStartCount, radioStopCount);
		printfflush();
	}
}
