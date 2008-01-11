module SensorTestP {
	uses {
		interface Boot;
		interface Timer<TMilli>; 
		interface Read<uint16_t>;
    	interface Leds;
    	interface DSN;
	}
}
implementation {
	event void Boot.booted() {
		call Timer.startPeriodic(1024);
		//call Leds.led1On();
	}
	
	event void Timer.fired() {
		call Leds.led2On();
		call Read.read();
	}

	event void Read.readDone(error_t result, uint16_t data) {
		uint16_t hi,lo;
		call Leds.led0Off();
		call Leds.led1Off();
		call Leds.led2Off();
    	if (result != SUCCESS) {
    		call Leds.led0On();
		if (result == EINVAL) {
			call Leds.led1On();
                	call DSN.log("No valid data");
		}
		else {
    			call DSN.log("No sensor attached");
		}
    	}
    	else {
    		// check range
    		// valid between 19°C and 30°C
    		if (data >= 5860 && data <= 6960) {
    			call Leds.led1On();
    		}
    		else {
    			call Leds.led0On();
    			call Leds.led1On();
    		}
    		hi = (data - 3960)/100;
    		lo = (data - 3960) % 100;
    		
    		call DSN.logInt(hi);
    		call DSN.logInt(lo);
    		if (lo < 10)
    			call DSN.log("Sensor value is %i.0%i");
    		else
    			call DSN.log("Sensor value is %i.%i");
    	}
	}
	
	event void DSN.receive(void *msg, uint8_t len) {
	}
}
