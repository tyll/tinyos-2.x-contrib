// AC Mote and Energy Meter using ADE7753
// @ Fred Jiang <fxjiang@eecs.berkeley.edu>

#include "EnergyMsg.h"
#define INTERVAL 1024

module ACMeterApp {
	uses interface Boot;
	uses interface AMSend;
	uses interface Receive as AMReceive;
	uses interface Packet;
	uses interface Leds;
	uses interface SplitControl as MeterControl;
	uses interface SplitControl as AMControl;
	uses interface ACMeter;
}

implementation {
	message_t pkt;
	EnergyMsg_t* energymsg;

	uint32_t energy;

	task void SendVal() {
		energymsg = (EnergyMsg_t*) call Packet.getPayload(&pkt, sizeof(energymsg));
		atomic energymsg->energy = energy;
		
		if (call AMSend.send(AM_BROADCAST_ADDR, &pkt, sizeof(EnergyMsg_t)) == SUCCESS) {
//				call Leds.led1Toggle();
		}		
		return;
	}
		
	event void Boot.booted() {
		atomic energy = 0;
		call AMControl.start();
	}

	event void MeterControl.startDone(error_t err) {
		// start reading energy at 1Hz
		call ACMeter.start(INTERVAL);
	}

	event void MeterControl.stopDone(error_t err) {}
	
	event void AMControl.startDone(error_t err) {
		if (err == SUCCESS) {
			call MeterControl.start();
		}
		else {
			call AMControl.start();
		}	
	}

	event message_t* AMReceive.receive(message_t* msg, void* payload, uint8_t len) {
		call ACMeter.toggle();
		return msg;
	}
	
	event void AMSend.sendDone(message_t* msg, error_t error) {}
	
	event void AMControl.stopDone(error_t err) {}

	event void ACMeter.sampleDone(uint32_t val) {
		atomic energy = val;
		post SendVal();
	}
	
}
	
