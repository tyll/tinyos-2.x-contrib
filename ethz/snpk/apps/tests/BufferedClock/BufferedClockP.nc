/**
 * This application makes the ACLK available at pin 2.0 aka GIO0
 * On the Tmote, R14 has to be soldered with a 0R resistor. 
 * 
 */

module BufferedClockP {
	uses {
		interface Boot;
		interface Timer<TMilli> as Timer;
	    interface Leds;
	    interface DsnSend;
	    interface Read<uint16_t> as InternalTemp;
	    interface Read<uint16_t> as SensirionTemp;
	    interface Read<uint16_t> as InternalVoltage;
	} 
}
implementation {
	uint16_t voltage,internalTemp;
	
	event void Boot.booted(){
		call DsnSend.logInt(TOS_NODE_ID);
		call DsnSend.log("node %i booted");
		TOSH_SEL_ADC3_IOFUNC();
		TOSH_MAKE_ADC3_INPUT();
		TOSH_SEL_GIO0_MODFUNC();
		TOSH_MAKE_GIO0_OUTPUT();
		call Timer.startPeriodic(4096);
	}
	
	event void Timer.fired() {
		call Leds.led0On();
		// read temp sensor
		call InternalVoltage.read();
	}
		
	event void InternalVoltage.readDone( error_t result, uint16_t val ) {
		voltage=val;
		call InternalTemp.read();
	}
	
	event void InternalTemp.readDone( error_t result, uint16_t val ) {
		internalTemp = val;
		call SensirionTemp.read();
	}
	
	event void SensirionTemp.readDone( error_t result, uint16_t val ) {
		call DsnSend.logInt(call Timer.getNow());
		call DsnSend.logInt(voltage);
		call DsnSend.logInt(val);
		call DsnSend.logInt(internalTemp);
		call DsnSend.log("%i:%i %i %i");
		call Leds.led0Off();
	}
}
