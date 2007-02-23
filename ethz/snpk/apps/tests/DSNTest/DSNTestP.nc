#include <Timer.h>
#include "DSNTest.h"

module DSNTestP
{
	uses interface Leds;
	uses interface Boot;
	uses interface DSN;
	uses interface Timer<TMilli> as Timer;
	uses interface AMPacket;
	uses interface SplitControl as RadioControl;
}
implementation
{
	event void Boot.booted()
	{
		call Leds.led0On();
		call Timer.startPeriodic(TIMER_TIMEOUT_MILLI);
		call DSN.logInt(call AMPacket.address());
		call DSN.logInfo("Node %i booted");
	}
	
	event void Timer.fired()
	{
		call Leds.led2Toggle();
		call DSN.logInfo("Timer fired");
	}
	
	event void DSN.receive(void * msg, uint8_t len)
	{
		call Leds.led1Toggle();
		call DSN.logInfo(msg);	
	}
	
	event void RadioControl.startDone(error_t error) {}
	event void RadioControl.stopDone(error_t error) {}
	
}


