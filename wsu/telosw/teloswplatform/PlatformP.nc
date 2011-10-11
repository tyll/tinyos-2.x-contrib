#include "hardware.h"

module PlatformP @safe() {
	provides interface Init;
	uses interface Init as MoteClockInit;
	uses interface Init as MoteInit;
	uses interface Init as LedsInit;
	   uses interface EnergyMeter;
	   uses interface WakeupADC as WakeupADC0;
	   uses interface WakeupADC as WakeupADC1;
	   uses interface Accelerometer;
}
implementation {
	command error_t Init.init() {
		call MoteClockInit.init();
		call MoteInit.init();
		call LedsInit.init();

		call EnergyMeter.init();
		call WakeupADC0.init();
		call WakeupADC1.init();
		
		call Accelerometer.init();
		return SUCCESS;
	}

	default command error_t LedsInit.init() { return SUCCESS; }

		async event void Accelerometer.int1(){}
		async event void Accelerometer.int2(){}
		async event void WakeupADC0.adc_int(){}
		async event void WakeupADC1.adc_int(){}
	 
}
