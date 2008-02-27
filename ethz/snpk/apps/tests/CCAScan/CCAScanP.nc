/**
 * This application shows clearchannel state on LEDs 
 * 
 */
#include "AM.h"
#include "CC2420.h"
module CCAScanP {
	uses {
		interface Boot;
		
		interface SplitControl as RadioControl;

	    interface Leds;
		
	    interface DsnSend;
	    
	    interface LowPowerListening;
	    interface CC2420Config;

	    interface ReceiveIndicator as EnergyIndicator;
	    interface ReceiveIndicator as ByteIndicator;
	    interface ReceiveIndicator as PacketIndicator;
	    
	    interface Timer<TMilli>;
	    
	    interface DsnCommand<uint8_t> as SetChannelCommand;
	} 
}
implementation {
	task void sampleCCA();
	uint8_t inrow=0;
	
	void printConfig();
	
	event void Boot.booted(){
		call DsnSend.logInt(TOS_NODE_ID);
		call DsnSend.log("node %i booted");
		TOSH_MAKE_GIO2_OUTPUT();
		call RadioControl.start();
	}
	
	event void RadioControl.startDone(error_t error) {
		call LowPowerListening.setLocalSleepInterval(0);
		printConfig();
		post sampleCCA();
	}
	
	event void RadioControl.stopDone(error_t error) {	}
		
	event void CC2420Config.syncDone( error_t error ) {
		printConfig();
	}
	
	task void sampleCCA() {
		if (call EnergyIndicator.isReceiving()) {
			//call Leds.led1On();
			TOSH_SET_GIO2_PIN();
			inrow++;
		}
		else {
			//call Leds.led1Off();
			TOSH_CLR_GIO2_PIN();
			if (inrow>4) {
				call Leds.led1On();
				call Timer.startOneShot(10);
			}
			inrow=0;
		}
		post sampleCCA();
	}
	
	event void Timer.fired() {
		call Leds.led1Off();
	}
	
	event void SetChannelCommand.detected(uint8_t * values, uint8_t n) {
		call CC2420Config.setChannel( values[0] );
		call CC2420Config.sync();
	}
	
	void printConfig() {
		call DsnSend.logInt(call CC2420Config.getChannel());
		call DsnSend.logInt(call CC2420Config.getShortAddr());
		call DsnSend.logInt(call CC2420Config.getPanAddr());
		call DsnSend.logInt(call CC2420Config.isAddressRecognitionEnabled());
		call DsnSend.logInt(call CC2420Config.isHwAutoAckDefault());
		call DsnSend.logInt(call CC2420Config.isAutoAckEnabled());
		call DsnSend.log("CC2420 configuration: ch %i, addr %i, pan %i, addrrec %i, hwAck %i, autoAck %i");
	}
}
