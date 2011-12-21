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

module ThroughputBenchmarkC
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
	
	uses interface Timer<TMilli> as StartTimer;
	uses interface Timer<TMilli> as BenchmarkTimer;
}
implementation
{
	uint16_t packetCount = 0;
	
	enum
	{
		PACKET_LENGTH = TOSH_DATA_LENGTH - FOOTER_SIZE,
		BENCHMARK_LENGTH = 60U * 1000U,
		RECEIVER = 0,
	};
	
	message_t packet;

	task void sendResult();
	
	task void send()
	{
	#ifdef UPMA
		#ifndef TDMA
			call LowPowerListening.setRemoteWakeupInterval(&packet,PREAMBLE_LENGTH);
		#endif
		#endif
		if(call AMSender.send(RECEIVER, &packet, PACKET_LENGTH) != SUCCESS)
			post send();
	}
	
	event void Boot.booted()
	{
		call SplitControl.start();
	}
	
	event void AMSender.sendDone(message_t * msg, error_t err)
	{	
		//call Leds.led0On();
		if(TOS_NODE_ID != RECEIVER)
			post send();
	}
	
	event void SplitControl.startDone(error_t err)
	{
#ifdef UPMA
#ifndef TDMA
		call LowPowerListening.setLocalWakeupInterval(PREAMBLE_LENGTH);
#endif
#ifdef SCP
		call SyncInterval.set(PREAMBLE_LENGTH * 100U + 10);
#endif
#endif

#ifdef SCP
		call StartTimer.startOneShot(15000);
#else
		call StartTimer.startOneShot(1000);
#endif
	}
	
	event void StartTimer.fired()
	{
		call BenchmarkTimer.startOneShot(BENCHMARK_LENGTH);
		if(TOS_NODE_ID != RECEIVER)
			post send();
	}
	
	event message_t * AMReceiver.receive(message_t * msg, void * payload, uint8_t len)
	{
		//call Leds.led1On();
		//call Leds.led0On();
		if(call BenchmarkTimer.isRunning())
			packetCount++;
		return msg;
	}

	event void SplitControl.stopDone(error_t err) { }
	
	task void sendResult()
	{
		call Leds.led0On();
		printf("%u\n", packetCount);
		printfflush();
	}
	
	event void BenchmarkTimer.fired()
	{
		if(TOS_NODE_ID == RECEIVER)
			post sendResult();
	}
}
