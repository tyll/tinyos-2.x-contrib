#include "printf.h"

module LplTestP {

	uses {
		interface Boot;
		interface Leds;

		interface Timer<TMilli> as Timer;

		interface SplitControl as RadioControl;
		interface AMSend as Send;
		interface Receive;
		interface PacketAcknowledgements as Acks;
		interface AMPacket;
	}

} implementation {
	
	message_t data;
	bool dataBusy;

	uint32_t seqno;

	/********** Boot **********/

	event void Boot.booted() {
		dbg("App", "Booted\n");
		call RadioControl.start();
	}

	event void RadioControl.startDone(error_t error) {
		dbg("App", "App startdone\n");
		if(TOS_NODE_ID!=RECEIVER) {
			call Timer.startPeriodic(256);
		}
	}

  event void RadioControl.stopDone(error_t error) {

	}

	/********** Data **********/

	event void Timer.fired() {
		lpltest_msg_t* d = (lpltest_msg_t*)call Send.getPayload(&data, sizeof(lpltest_msg_t));

		dbg("App", "Fired!\n");
		printf("fired\n");

		if(dataBusy) {
			call Leds.led0Toggle();
			return;
		}

		call Acks.requestAck(&data);

		d->seqno = ++seqno;
		
		if(call Send.send(RECEIVER, &data, sizeof(lpltest_msg_t))==SUCCESS) {
			dataBusy = TRUE;
		}
	}

  event void Send.sendDone(message_t* msg, error_t error) {
		dataBusy = FALSE;

		if(error==SUCCESS && call Acks.wasAcked(msg)) {
			dbg("App", "Acked!\n");
			call Leds.led1Toggle();
		} else {
			dbg("App", "NOT acked!\n");
			call Leds.led0Toggle();
		}
		printfflush();
	}

  event message_t* Receive.receive(message_t* msg, void* payload, uint8_t len) {
		lpltest_msg_t*	d = ((lpltest_msg_t*)payload);
		dbg("App", "RECEIVED!\n");
		call Leds.led2Toggle();
		printfflush();
		return msg;
	}

}
