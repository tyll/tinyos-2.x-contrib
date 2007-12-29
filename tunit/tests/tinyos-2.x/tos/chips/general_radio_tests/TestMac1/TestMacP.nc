/*
 * Copyright (c) 2007, Vanderbilt University
 * All rights reserved.
 *
 * Permission to use, copy, modify, and distribute this software and its
 * documentation for any purpose, without fee, and without written agreement is
 * hereby granted, provided that the above copyright notice, the following
 * two paragraphs and the author appear in all copies of this software.
 * 
 * IN NO EVENT SHALL THE VANDERBILT UNIVERSITY BE LIABLE TO ANY PARTY FOR
 * DIRECT, INDIRECT, SPECIAL, INCIDENTAL, OR CONSEQUENTIAL DAMAGES ARISING OUT
 * OF THE USE OF THIS SOFTWARE AND ITS DOCUMENTATION, EVEN IF THE VANDERBILT
 * UNIVERSITY HAS BEEN ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
 * 
 * THE VANDERBILT UNIVERSITY SPECIFICALLY DISCLAIMS ANY WARRANTIES,
 * INCLUDING, BUT NOT LIMITED TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY
 * AND FITNESS FOR A PARTICULAR PURPOSE.  THE SOFTWARE PROVIDED HEREUNDER IS
 * ON AN "AS IS" BASIS, AND THE VANDERBILT UNIVERSITY HAS NO OBLIGATION TO
 * PROVIDE MAINTENANCE, SUPPORT, UPDATES, ENHANCEMENTS, OR MODIFICATIONS.
 *
 * Author: Miklos Maroti
 */

#include <Timer.h>
#include "TestCase.h"

module TestMacP
{
	uses
	{
		interface TestControl as SetUpOneTime;
		interface TestCase;
		interface TestControl as TearDownOneTime;

		interface Statistics as RxThroughput;
		interface Statistics as RxMissing;
		interface Statistics as RxDuplicates;
		interface Statistics as TxThroughput;
		interface Statistics as TxNotAcked;
		interface Statistics as TxFailed;

		interface SplitControl as RadioControl;
		interface AMSend;
		interface Receive;
		interface Receive as Snoop;
		interface PacketAcknowledgements;
		interface Timer<TMilli>;
	}
}

implementation
{
/* ----- message ----- */

	typedef struct test_msg_t
	{
		uint8_t source;		// in the range [0, MAX_SOURCE-1]
		uint32_t sequence;	// in the range [1, expected]
		uint8_t stuff[23];
	} test_msg_t;

	enum
	{
		STATE_READY = 0,
		STATE_RUNNING = 1,
		STATE_STOPPED = 2,
		STATE_TEAR_DOWN = 3,
	};
	uint8_t state;

	void realStart();
	task void radioStop();

/* ----- receive ----- */

	enum { MAX_SOURCE = 10 };

	typedef struct rx_stat_t
	{
		uint32_t expected;		// the number of messages we expect
		uint32_t sequence;		// the last sequence number we saw, starts from 1
		uint32_t missing;		// the number of missing packets
		uint32_t duplicates;	// the number of duplicate packets
		uint32_t errors;		// backward jumps in the sequence numbers
		uint32_t firstTime;		// when was the first message received
		uint32_t lastTime;		// when was the last message received
	} rx_stat_t;

	rx_stat_t rxStats[MAX_SOURCE];

	void receive(message_t* msg)
	{
		uint8_t source = ((test_msg_t*)(msg->data))->source;
		uint32_t seq = ((test_msg_t*)(msg->data))->sequence;

		// start up the slave nodes
		if( state == STATE_READY )
		{
			if( TOS_NODE_ID == 0 )
			{
				assertFail("unexpected test message before startup");
				post radioStop();
			}
			else
				realStart();
		}
		else if( state != STATE_RUNNING )
			return;

		if( source < MAX_SOURCE && 0 < seq && seq <= rxStats[source].expected )
		{
			if( rxStats[source].sequence == seq )
				rxStats[source].duplicates += 1;
			else if( rxStats[source].sequence > seq )
				rxStats[source].errors += 1;
			else 
				rxStats[source].missing += seq - rxStats[source].sequence - 1;

			rxStats[source].lastTime = call Timer.getNow();
			if( rxStats[source].sequence == 0 )
				rxStats[source].firstTime = rxStats[source].lastTime;

			rxStats[source].sequence = seq;
		}
		else
		{
			assertFail("unexpected test message received");
			post radioStop();
		}
	}

	event message_t* Receive.receive(message_t* msg, void* payload, uint8_t len)
	{
		receive(msg);
		return msg;
	}

	event message_t* Snoop.receive(message_t* msg, void* payload, uint8_t len)
	{
		receive(msg);
		return msg;
	}
	
	void rxReport(uint8_t id)
	{
		call RxThroughput.log("pkts/sec", (1000.0 * (rxStats[id].sequence - rxStats[id].missing - 1)) / (float)(rxStats[id].lastTime - rxStats[id].firstTime));
		call RxMissing.log("1/1000 pkts", (rxStats[id].missing + rxStats[id].expected - rxStats[id].sequence) * 1000.0 / rxStats[id].expected);
		call RxDuplicates.log("1/1000 pkts", rxStats[id].duplicates * 1000.0 / rxStats[id].expected);

		assertEquals("rx sequence number error", 0, rxStats[id].errors);
	}

/* ----- transmit ----- */

	message_t txMsg;
	uint32_t txSequence;
	uint32_t txBusy;
	uint32_t txUnacked;
	uint32_t txCount;
	uint32_t txFirstTime;
	uint32_t txLastTime;

	uint8_t sendSource;
	uint8_t sendTarget;

	task void sendTask()
	{
		test_msg_t* data;
		
		if( state != STATE_RUNNING )
			return;

		if( txSequence == 0 )
			txFirstTime = call Timer.getNow();

		data = (test_msg_t*)(txMsg.data);
		data->source = sendSource;
		data->sequence = txSequence + 1;

		call PacketAcknowledgements.requestAck(&txMsg);
		if( call AMSend.send(sendTarget, &txMsg, sizeof(test_msg_t)) != SUCCESS )
		{
			++txBusy;
			post sendTask();
		}
	}

	event void AMSend.sendDone(message_t* msg, error_t error)
	{
		txLastTime = call Timer.getNow();

		if( error != SUCCESS )
		{
			++txBusy;
			post sendTask();
		}
		else
		{
			if( ! call PacketAcknowledgements.wasAcked(msg) )
				++txUnacked;

			if( ++txSequence < txCount )
				post sendTask();
		}
	}

	void txReport()
	{
		call TxThroughput.log("pkts/sec", 1000.0 * txSequence / (txLastTime - txFirstTime));
		call TxNotAcked.log("1/1000 pkts", txUnacked * 1000.0 / txSequence);
		call TxFailed.log("1/1000 pkts", txBusy * 1000.0 / txSequence);
	}

/* ----- real test ----- */

	enum { TEST_DURATION = 15000 };

	// called once for each node
	void realStart()
	{
		if( state != STATE_READY )
		{
			assertFail("unexpected real start");
			post radioStop();
		}

		state = STATE_RUNNING;

		if( TOS_NODE_ID == 0 )
		{
			txCount = 1000;
			sendSource = 0;
			sendTarget = 1;

			post sendTask();
		}
		else
		{
			rxStats[0].expected = 1000;
			rxStats[0].sequence = 0;
		}

		call Timer.startOneShot(TEST_DURATION);
	}

	event void Timer.fired()
	{
		// turn off the radio no matter what
		post radioStop();

		if( state == STATE_RUNNING )
		{
			state = STATE_STOPPED;

			if( TOS_NODE_ID == 0 )
				txReport();
			else
				rxReport(0);

			if( TOS_NODE_ID == 0 )
				call Timer.startOneShot(5000);	// settle down

			assertSuccess();
		}
		else if( state == STATE_STOPPED && TOS_NODE_ID == 0 )
			call TestCase.done();
	}

/* ----- startup / shutdown ----- */
	
	task void radioStart()
	{
		error_t e = call RadioControl.start();
		if( e != SUCCESS && e != EALREADY )
			post radioStart();
	}

	event void SetUpOneTime.run()
	{
		post radioStart();
	}

	event void RadioControl.startDone(error_t error)
	{
		if( error != SUCCESS )
			post radioStart();
		else
			call SetUpOneTime.done();
	}

	task void radioStop()
	{
		error_t e = call RadioControl.stop();
		if( e != SUCCESS && e != EALREADY )
			post radioStop();
		else if( e == EALREADY && state == STATE_TEAR_DOWN ) 
			call TearDownOneTime.done();
	}

	event void TearDownOneTime.run()
	{
		state = STATE_TEAR_DOWN;
		post radioStop();
	}

	event void RadioControl.stopDone(error_t error)
	{
		if( error != SUCCESS )
			post radioStop();
		else if( state == STATE_TEAR_DOWN )
			call TearDownOneTime.done();
	}

	event void TestCase.run()
	{
		if( TOS_NODE_ID != 0 )
		{
			assertFail("unexpected testcase run");
			post radioStop();
		}
		else
			realStart();
	}
}
