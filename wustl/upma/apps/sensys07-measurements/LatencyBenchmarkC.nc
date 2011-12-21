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

module LatencyBenchmarkC
{
	uses interface Boot;
	uses interface Leds;
	uses interface AMSend as AMSender;
	uses interface Packet;
	uses interface AMPacket;
	uses interface Receive as AMReceiver;
	uses interface SplitControl;
	uses interface LowPowerListening;
#ifdef SCP
	uses interface Interval as SyncInterval;
#endif

	uses interface Timer<TMilli> as SendTimer;
	uses interface Timer<TMilli> as StartTimer;
//	uses interface Timer<TMilli> as LedTimer;
	
	uses interface Counter<TMilli, uint32_t>;
}
implementation
{
	enum
	{
		PACKET_LENGTH = TOSH_DATA_LENGTH - FOOTER_SIZE,
		SAMPLE_INTERVAL = 3000U,
		MAX_SAMPLES = 50,
	};
	
	void sendForward();
	void sendBackward();
	void doSendForward();
	void doSendBackward();
	
	uint16_t samples[MAX_SAMPLES];
	uint16_t numSamples = 0;
	
	uint32_t startedAt;
	uint32_t benchmarkStart;
	uint32_t benchmarkEnd;
	uint32_t benchmarkVDuty;
	uint32_t benchmarkOscDuty;
	uint32_t benchmarkRadioDuty;
	
	message_t packet;

	async event void Counter.overflow() { }
	task void sendResults()
	{
		static uint8_t i = 0;
		if(i < MAX_SAMPLES)
		{
			printf("%u,", samples[i++]);
			printfflush();
			post sendResults();
		}
		else if(i == MAX_SAMPLES)
		{
			printf("\n%lu\t", benchmarkVDuty);
			printf("%lu\t", benchmarkOscDuty);
			printf("%lu\t", benchmarkRadioDuty);
			printf("%lu\n", benchmarkEnd - benchmarkStart);
			i++;
			printfflush();
		}
	}
	
	void sendForward()
	{
		if(TOS_NODE_ID == NUM_HOPS)
		{
			sendBackward();
			return;
		}
		
		call Leds.led1On();
//		call LedTimer.startOneShot(SAMPLE_INTERVAL * 2 / 3);
		startedAt = call Counter.get();
		doSendForward();
	}
	
//	event void LedTimer.fired() { call Leds.led1Off(); call Leds.led2Toggle(); }
	
	task void sendForwardTask()
	{
		doSendForward();
	}
	
	void doSendForward() 
	{
		if(call AMSender.send(TOS_NODE_ID + 1, &packet, PACKET_LENGTH) != SUCCESS)
			post sendForwardTask();
	}
	
	void sendBackward()
	{
		if(numSamples < MAX_SAMPLES)
			samples[numSamples] = call Counter.get() - startedAt;
		numSamples++;

		call Leds.led1Off();
//		call LedTimer.stop();
		
		//if(TOS_NODE_ID == 0)
		if(TOS_NODE_ID != NUM_HOPS)
		{
			if(numSamples == MAX_SAMPLES)
			{
				benchmarkEnd = call Counter.get();
				benchmarkVDuty = vDutyCycle;
				benchmarkOscDuty = oscDutyCycle;
				benchmarkRadioDuty = radioDutyCycle;
			}
			if(numSamples == MAX_SAMPLES * 4 / 3)
			{
				call Leds.led0On();
				post sendResults();
			}
		}
		
		if(TOS_NODE_ID == 0)					
			return;

		doSendBackward();
	}
	
	task void sendBackwardTask()
	{
		doSendBackward();
	}
	
	void doSendBackward() 
	{
		if(call AMSender.send(TOS_NODE_ID - 1, &packet, PACKET_LENGTH) != SUCCESS)
			post sendBackwardTask();
	}
	
	event void SendTimer.fired()
	{
		if(TOS_NODE_ID == 0 /*&& numSamples < MAX_SAMPLES*/)
			sendForward();
	}
	
	event void Boot.booted()
	{
#ifdef UPMA
#ifdef SCP
		call SyncInterval.set(PREAMBLE_LENGTH * 100U + 10);
#endif
#else
		call LowPowerListening.setRemoteWakeupInterval(&packet, PREAMBLE_LENGTH);
#endif
		call SplitControl.start();
	}
	
	event message_t * AMReceiver.receive(message_t * message, void * payload, uint8_t length)
	{
		am_id_t from = call AMPacket.source(message);
//		call Leds.led0Toggle();
		if(from == TOS_NODE_ID - 1)
			sendForward();
		else
			sendBackward();

		return message;
	}

	event void AMSender.sendDone(message_t * msg, error_t error)
	{
	}
	
	event void SplitControl.startDone(error_t err)
	{
		memset(call Packet.getPayload(&packet, PACKET_LENGTH), TOS_NODE_ID, PACKET_LENGTH);
		#ifndef TDMA
		call LowPowerListening.setLocalWakeupInterval(PREAMBLE_LENGTH);
		#endif
		benchmarkStart = call Counter.get();

#ifdef SCP
		call StartTimer.startOneShot(PREAMBLE_LENGTH * 150U);
#else
		call SendTimer.startPeriodic(SAMPLE_INTERVAL);
#endif
	}
	
	event void StartTimer.fired()
	{
		call SendTimer.startPeriodic(SAMPLE_INTERVAL);
	}

	event void SplitControl.stopDone(error_t err)
	{
	}
}
