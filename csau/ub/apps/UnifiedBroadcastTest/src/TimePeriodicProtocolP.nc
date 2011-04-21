/**
 * @author Morten Tranberg Hansen <mth at cs dot au dot dk>
 * @date   June 6 2010
 */

#include "UnifiedBroadcastApp.h"
#include "printf.h"

generic module TimePeriodicProtocolP(uint32_t period) {

	uses {
		interface Boot;
		interface Leds;
		interface Timer<TMilli>;
		interface TimeSyncAMSend<TMilli,uint32_t>;
        interface TimeSyncPacket<TMilli, uint32_t>;
		interface Receive;
		//interface UnifiedBroadcast;
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
		/*if(isUrgent) {
			call UnifiedBroadcast.disableDelay();
			}*/
	}

	event void Timer.fired() {
		test_msg_t* msg = call TimeSyncAMSend.getPayload(&test_msg, sizeof(test_msg_t));
		printfflush();		

		if(busy) {
			printf("%hhu: already sending at %hu\n", TOS_NODE_ID, period);
			return;
		}

		msg->counter = ++counter;
		msg->timestamp = call LocalTime.get();
		//printf("%hhu: sending %lu at %hu\n", TOS_NODE_ID, counter, period);

		if(call TimeSyncAMSend.send(AM_BROADCAST_ADDR, &test_msg, sizeof(test_msg_t), msg->timestamp)==SUCCESS) {
			busy = TRUE;
		} else {
			call Leds.led0Toggle();
		}

	}

  event void TimeSyncAMSend.sendDone(message_t* msg, error_t err) {
		call Leds.led1Toggle();
		busy = FALSE;
		printf("%hhu: sendDone %hu\n", TOS_NODE_ID, period);
	}

	void print_message(message_t* msg) {
		uint8_t j;
		for(j=0; j<sizeof(message_t); j++) {
			printf("%hhu ", *((uint8_t*)msg+j)); 
		}
		printf("\n");
	}


  event message_t* Receive.receive(message_t* msg, void* payload, uint8_t len) {
		test_msg_t* t = (test_msg_t*)payload; 
		call Leds.led2Toggle();

		if(call TimeSyncPacket.isValid(msg)) {
			printf("local %lu vs. remote %lu\n", call TimeSyncPacket.eventTime(msg), t->timestamp);
		} else {
			printf("NOT VALID\n");
		}
		
		//printf("%hhu: received %lu at %hu\n", TOS_NODE_ID, t->counter, period);
		print_message(msg);
		printfflush();
		return msg;
	}

}
