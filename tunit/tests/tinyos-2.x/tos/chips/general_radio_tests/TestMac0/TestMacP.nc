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

	void receive(message_t* msg)
	{
		assertFail("unexpected transmitter in communication range");
		post radioStop();
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
	
/* ----- transmit ----- */

	message_t txMsg;
	uint8_t sendTarget;

	task void sendTask()
	{
		if( state != STATE_RUNNING )
			return;

		call PacketAcknowledgements.requestAck(&txMsg);
		if( call AMSend.send(sendTarget, &txMsg, sizeof(test_msg_t)) != SUCCESS )
			post sendTask();
		else
			sendTarget = (sendTarget + 1) & 0x1f;
	}

	event void AMSend.sendDone(message_t* msg, error_t error)
	{
		if( error == SUCCESS && call PacketAcknowledgements.wasAcked(msg) )
		{
			assertFail("unexpected transmitter in communication range");
			post radioStop();
		}
		else
			post sendTask();
	}

/* ----- real test ----- */

	enum { TEST_DURATION = 10000 };

	// called once for each node
	void realStart()
	{
		if( state != STATE_READY )
		{
			assertFail("unexpected real start");
			post radioStop();
			return;
		}

		state = STATE_RUNNING;
		post sendTask();

		call Timer.startOneShot(TEST_DURATION);
	}

	event void Timer.fired()
	{
		// turn off the radio no matter what
		post radioStop();

		if( state == STATE_RUNNING )
		{
			assertSuccess();

			state = STATE_STOPPED;
			call TestCase.done();
		}
	}

/* ----- startup / shutdown ----- */
	
	task void radioStart()
	{
		error_t e = call RadioControl.start();
		if( e == EALREADY )
			call SetUpOneTime.done();
		else if( e == FAIL )
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
		if( e == EALREADY && state == STATE_TEAR_DOWN ) 
			call TearDownOneTime.done();
		else if( e == FAIL )
			post radioStop();
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
