// AC Mote and Energy Meter using ADE7753
// @ Fred Jiang <fxjiang@eecs.berkeley.edu>

#include <Timer.h>
#include "ADE7753.h"

module ACMeterM {
	provides interface SplitControl;
	provides interface ACMeter;
	uses interface Timer<TMilli> as Timer;
	uses interface Leds;
	uses interface ADE7753;
	uses interface SplitControl as MeterControl;
	uses interface HplMsp430GeneralIO as onoff;
}

implementation {
	uint32_t energy;
	uint8_t stage;
	uint8_t onoff_state;
//	uint16_t interval;
	bool dirty;
	
	enum STAGES {
		INIT,
		SET_MODE,
		SET_GAIN,
		NORMAL
	};

	enum ONOFF_STATE {
		SET,
		CLR
	};
	
	task void signalStartDone() {
		signal SplitControl.startDone(SUCCESS);
		return;
	}

	task void signalSampleDone() {
		signal ACMeter.sampleDone(energy);
		return;
	}
	
	command error_t SplitControl.start() {
		atomic energy = 0;
		atomic stage = INIT;
		// atomic interval = 1024;
		atomic dirty = TRUE;
		atomic onoff_state = SET;
		call onoff.makeOutput();
		call onoff.set();
		call MeterControl.start();
		return SUCCESS;
	}

	command error_t SplitControl.stop() {}
	
	//event void SplitControl.startDone(error_t error) {}

	event void MeterControl.startDone(error_t err) {
		atomic stage = SET_MODE;
		call ADE7753.setReg(ADE7753_MODE, 3, ADE7753_MODE_VAL);
	}

	event void MeterControl.stopDone(error_t err) {}	

	command bool ACMeter.set(bool state) {
		if (state) {
			call onoff.set();
                        onoff_state = SET;
		} else {
			call onoff.clr();
                        onoff_state = CLR;
		}
		return state;
	}

	command bool ACMeter.getState() {
		bool isSet;
		if(onoff_state == SET) {
			isSet = TRUE;
		} else {
			isSet = FALSE;
		}
		return isSet;
	}
	
	command bool ACMeter.toggle() {
		if (onoff_state == SET) {
			onoff_state = CLR;
			call onoff.clr();
			return FALSE;
		} else {
			onoff_state = SET;
			call onoff.set();
			return TRUE;
		}	
	}
	
	command error_t ACMeter.start(uint16_t interval) {
		dirty = TRUE;
		call Timer.startPeriodic(interval);
		return SUCCESS;
	}

	command error_t ACMeter.stop() {
		dirty = TRUE;
		call Timer.stop();
		return SUCCESS;
	}

	// event void ACMeter.sampleDone(uint32_t ener) {}
	
	event void Timer.fired() {
		// at 1Hz, reading RENERGY is equal to power
		call ADE7753.getReg(ADE7753_RAENERGY, 4);
	}

	async event void ADE7753.getRegDone( error_t error, uint8_t regAddr, uint32_t val, uint16_t len) {
		if (dirty) {
			dirty = FALSE;
			return;
		} else {
			atomic energy = val;
			post signalSampleDone();
		}
	}
	
	async event void ADE7753.setRegDone( error_t error, uint8_t regAddr, uint32_t val, uint16_t len) {
		switch (stage) {
		case INIT:
			return;
		case SET_MODE:
			atomic stage = SET_GAIN;
			call ADE7753.setReg(ADE7753_GAIN, 2, ADE7753_GAIN_VAL);
			return;
		case SET_GAIN:
			atomic stage = NORMAL;
			post signalStartDone();
			return;
		default:
			return;
		}
	}
	
}
	
