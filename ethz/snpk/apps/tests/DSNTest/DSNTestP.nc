#include <Timer.h>
#include "DSNTest.h"

module DSNTestP
{
	uses interface Leds;
	uses interface Boot;
	uses interface DsnSend as DSN;
	uses interface DsnReceive;
	uses interface Timer<TMilli> as Timer;
	uses interface Timer<TMilli> as BlinkTimer;
	uses interface AMPacket;
	uses interface Packet;
	uses interface SplitControl as RadioControl;
}
implementation
{
	
	enum tests {
		TEST_INT_DEC_HEX_BIN,
		TEST_INT_PACKET,
		TEST_INT_HEXSTREAM,
	};
	enum {
		TEST_COUNT=3,
	};
	
	uint8_t blinkcount=0;
	message_t test_msg;
	uint8_t test=TEST_INT_DEC_HEX_BIN;
		
	
	void startBlink(uint8_t numberOfBlinks) {
		blinkcount+=2*numberOfBlinks;
		call BlinkTimer.startOneShot(0);
	}
	
	event void Boot.booted()
	{
		call Leds.led0On();
		call Timer.startPeriodic(TIMER_TIMEOUT_MILLI);
		call DSN.logInt(call AMPacket.address());
		call DSN.logInt(TOS_NODE_ID);
		call DSN.logInfo("Node NODE_ID:%i booted (AM:%i)");
	}
	
	event void Timer.fired()
	{
		call Leds.led2Toggle();
		startBlink(1);
		
		switch (test) {
			case TEST_INT_DEC_HEX_BIN:
				call DSN.logInt(TOS_NODE_ID);
				call DSN.logInt(TOS_NODE_ID);
				call DSN.logInt(TOS_NODE_ID);
				call DSN.logInfo("My id is %i, %h, %b2");
			case TEST_INT_PACKET:
				call AMPacket.setDestination(&test_msg, 0xffff);
				call AMPacket.setSource(&test_msg, 0x01); 
				call AMPacket.setType(&test_msg, 0x10);
				call Packet.setPayloadLength(&test_msg, 8);
				call DSN.logPacket(&test_msg);
				break;
			case TEST_INT_HEXSTREAM:
				call DSN.logHexStream((uint8_t*)&test_msg, 8);
				break;
		}
		test++;
		test=test % TEST_COUNT;		
	}
	
	event void BlinkTimer.fired()
	{
		blinkcount--;
		call Leds.led0Toggle();
		if (blinkcount>0)
			call BlinkTimer.startOneShot(100);
	}
	
	event void DsnReceive.receive(void * msg, uint8_t len)
	{
		call Leds.led1Toggle();
		startBlink(2);
		call DSN.logInfo(msg);
	}
	
	event void RadioControl.startDone(error_t error) {}
	event void RadioControl.stopDone(error_t error) {}
	
}


