// Energy Meter using FM3116
// @ Fred Jiang

#include <Timer.h>
#include "EnergyMsg.h"

#define SAMPLES 10
#define INTERVAL 1024

module BlinkSPOTM {
	uses interface Boot;
	uses interface AMSend;
	uses interface SplitControl as AMControl;
	uses interface Packet;
	uses interface Leds;
	uses interface Timer<TMilli> as Timer;
	uses interface SPOT;
}

implementation {
		
	message_t pkt;
	EnergyMsg_t* energymsg;

	uint8_t flag;

	uint32_t counter;
	
	uint32_t base[SAMPLES];
	uint32_t measure[SAMPLES];

	uint8_t index;
	uint8_t index2;
	
	event void Boot.booted() {
//		uint32_t[4] calData;
//		call Leds.led0On();
		flag = 0;
		counter = 0;
		index2 = 0;

		// get the calibration data out
		index = 2;
		base[0] = call SPOT.getCalTime1();
		base[1] = call SPOT.getCalTime2();
		measure[0] = call SPOT.getCalEnergy1();
		measure[1] = call SPOT.getCalEnergy2();
		call Timer.startOneShot(INTERVAL);		
	}

	event void AMControl.startDone(error_t err) {
		if (err == SUCCESS) {

			energymsg = (EnergyMsg_t*) call Packet.getPayload(&pkt, sizeof(energymsg));
			energymsg->base = base[index2];
			energymsg->energy = measure[index2];
			
			call Leds.led1Toggle();
			if (call AMSend.send(AM_BROADCAST_ADDR, &pkt, sizeof(EnergyMsg_t)) == SUCCESS) {
				// call Leds.led0Toggle();
			}		
		}
		else {
			call AMControl.start();
		}	
	}
	
	event void AMControl.stopDone(error_t err) {}


	event void SPOT.sampleDone(uint32_t time, uint32_t energy) {
		base[index] = time;
		measure[index] = energy;
		index = index + 1;

        /*
		call Leds.led0Toggle();
		call Leds.led1Toggle();
		call Leds.led2Toggle();
		*/
		
		call Timer.startOneShot(INTERVAL);
	}
	
	event void Timer.fired() {
		if (index < (SAMPLES)) {
			call SPOT.sample();
		} else {
			index2 = 0;
			call AMControl.start();
		}
	}
	
	event void AMSend.sendDone(message_t* msg, error_t error) {
		index2++;
		
		if(index2<SAMPLES) {
			energymsg = (EnergyMsg_t*) call Packet.getPayload(&pkt, sizeof(energymsg));
			energymsg->base = base[index2];
			energymsg->energy = measure[index2];
			call Leds.led1Toggle();
			
			if (call AMSend.send(AM_BROADCAST_ADDR, &pkt, sizeof(EnergyMsg_t)) == SUCCESS) {}
		} else {	
			call AMControl.stop();
		}
	}
	
}
