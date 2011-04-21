/**
 * @author Morten Tranberg Hansen <mth at cs dot au dot dk>
 * @date   June 6 2010
 */

#include "UnifiedBroadcastApp.h"

generic module PeriodicProtocolP(uint32_t period, bool sendFullPacket, bool isUrgent) {

	uses {
		interface Boot;
		interface Leds;
		interface Timer<TMilli>;
		interface AMSend;
        interface AMPacket;
        interface Packet;
		interface Receive;
		interface UnifiedBroadcast;
		interface LocalTime<TMilli>;
	}


} implementation {

	message_t test_msg;
	bool busy = FALSE;
	uint32_t counter;

	event void Boot.booted() {
		busy = FALSE;
		if(TOS_NODE_ID==SENDER) {
			call Timer.startPeriodic(period);
		}
		if(isUrgent) {
			call UnifiedBroadcast.disableDelay();
		}
	}

	event void Timer.fired() {
		test_msg_t* msg = call AMSend.getPayload(&test_msg, sizeof(test_msg_t));
        uint8_t i;

		if(busy) {
			dbg("PeriodicProtocol", "PeriodicProtocol: %hhu: already sending at %hu\n", TOS_NODE_ID, period);
			return;
		}

		msg->counter = ++counter;
		msg->timestamp = counter;//call LocalTime.get();
        for(i=0; i<TOSH_DATA_LENGTH-sizeof(test_msg_t); i++) {
          *((uint8_t*)(msg+1)+i) = i+1;
        }

		if(call AMSend.send(AM_BROADCAST_ADDR, &test_msg, sendFullPacket?TOSH_DATA_LENGTH-4:sizeof(test_msg_t)-sizeof(test_msg_t))==SUCCESS) {
			busy = TRUE;
		} else {
			call Leds.led0Toggle();
		}

	}

  event void AMSend.sendDone(message_t* msg, error_t err) {
		call Leds.led1Toggle();
		busy = FALSE;
		dbg("PeriodicProtocol", "PeriodicProtocol: %hhu: sendDone %hu\n", TOS_NODE_ID, period);
  }

  event message_t* Receive.receive(message_t* msg, void* payload, uint8_t len) {
#ifdef TOSSIM
		test_msg_t* t = (test_msg_t*)payload; 
		dbg("PeriodicProtocol", "PeriodicProtocol: %hhu: received %lu at %hu\n", TOS_NODE_ID, t->counter, period);
#endif
		call Leds.led2Toggle();

		return msg;
	}

}
