#include "Ieee154Test.h"
#include "printf.h"

module Ieee154TestP {

	uses {
		interface Boot;
		interface Leds;
		interface Timer<TMilli>;

		interface SplitControl as RadioControl;

#ifdef USE_AM
		interface AMSend as Send;
#else
		interface Ieee154Send as Send;
#endif

		interface Receive;
		interface Packet;
		interface PacketLink;

	}

} implementation {

	message_t myMsg;

	void print_data(void* payload, uint8_t len) {
		uint8_t i;
		uint8_t* p = (uint8_t*) payload;
		for(i=0; i<len; i++) {
			printf("%hhu,", *(p+i));
		}
	}

	/********** Init **********/

	event void Boot.booted() {
		call RadioControl.start();
	}
 
	event void RadioControl.startDone(error_t error) {
		if(error==SUCCESS) {
			if(TOS_NODE_ID==SENDER_ID) {
				call Timer.startPeriodic(1024);
			}
		} else {
			call RadioControl.start();
		}
	}

	event void RadioControl.stopDone(error_t error) {

	}

	/********** Send **********/

	event void Timer.fired() {		
		uint8_t i;
		uint8_t len = call Packet.maxPayloadLength();
		uint8_t* d = call Packet.getPayload(&myMsg, len);

		for(i=0; i<len; i++) {
			d[i] = i;
		}

		call PacketLink.setRetries(&myMsg, PACKET_LINK_RETRIES);
		call PacketLink.setRetryDelay(&myMsg, PACKET_LINK_DELAY);
		
		if(call Send.send(TOS_NODE_ID+1, &myMsg, len)!=SUCCESS) {
			call Leds.led0Toggle();
		}
	}

  event void Send.sendDone(message_t* msg, error_t error) {

		if(error==SUCCESS && call PacketLink.wasDelivered(msg)) {
			call Leds.led1Toggle();
		} else {
			//call Leds.led0Toggle();
		}
		printf("%hhu: senddone: ", TOS_NODE_ID);
		print_data(msg, sizeof(message_t)-sizeof(message_metadata_t));
		printf("\n");

		printfflush();
	}

	/********** Receive **********/

  event message_t* Receive.receive(message_t* msg, void* payload, uint8_t len) {
		call Leds.led2Toggle();
		//printf("%hhu: receive : ", TOS_NODE_ID);
		//print_data(msg, sizeof(message_t)-sizeof(message_metadata_t));
		printf("\n");
		printfflush();
		return msg;
	}

}
