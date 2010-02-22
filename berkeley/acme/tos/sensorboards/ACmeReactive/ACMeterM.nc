/* "Copyright (c) 2008 The Regents of the University  of California.
 * All rights reserved."
 *
 * Permission to use, copy, modify, and distribute this software and its
 * documentation for any purpose, without fee, and without written agreement is
 * hereby granted, provided that the above copyright notice, the following
 * two paragraphs and the author appear in all copies of this software.
 *
 * IN NO EVENT SHALL THE UNIVERSITY OF CALIFORNIA BE LIABLE TO ANY PARTY FOR
 * DIRECT, INDIRECT, SPECIAL, INCIDENTAL, OR CONSEQUENTIAL DAMAGES ARISING OUT
 * OF THE USE OF THIS SOFTWARE AND ITS DOCUMENTATION, EVEN IF THE UNIVERSITY OF
 * CALIFORNIA HAS BEEN ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
 *
 * THE UNIVERSITY OF CALIFORNIA SPECIFICALLY DISCLAIMS ANY WARRANTIES,
 * INCLUDING, BUT NOT LIMITED TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY
 * AND FITNESS FOR A PARTICULAR PURPOSE.  THE SOFTWARE PROVIDED HEREUNDER IS
 * ON AN "AS IS" BASIS, AND THE UNIVERSITY OF CALIFORNIA HAS NO OBLIGATION TO
 * PROVIDE MAINTENANCE, SUPPORT, UPDATES, ENHANCEMENTS, OR MODIFICATIONS."
 *
 */

/**
 * ACme Energy Monitor
 * @author Fred Jiang <fxjiang@eecs.berkeley.edu>
 * @version $Revision$
 */


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
	uint32_t renergy;
	uint32_t laenergy, lvaenergy, lvarenergy;
	uint8_t stage;
	uint8_t onoff_state;
//	uint16_t interval;
	bool dirty;
	
	uint8_t energyMode;
	
	enum STAGES {
		INIT,
		SET_MODE,
		SET_LINECYC,
		SET_GAIN,
		NORMAL
	};

	enum ONOFF_STATE {
		SET,
		CLR
	};
	
	enum ENERGYMODE {
		AENERGY,
		LAENERGY,
		LVAENERGY,
		LVARENERGY
	};
	
	task void signalStartDone() {
		signal SplitControl.startDone(SUCCESS);
		return;
	}
	
	command error_t SplitControl.start() {
		atomic energy = 0;
		atomic stage = INIT;
		// atomic interval = 1024;
		atomic dirty = TRUE;
		atomic onoff_state = SET;
		energyMode = AENERGY;
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
                atomic dirty = TRUE;
		call Timer.startPeriodic(interval);
		return SUCCESS;
	}

	command error_t ACMeter.stop() {
                atomic dirty = TRUE;
		call Timer.stop();
		return SUCCESS;
	}

	// event void ACMeter.sampleDone(uint32_t ener) {}
	
	event void Timer.fired() {
		// first get realEnergy
		energyMode = AENERGY;
		// at 1Hz, reading RENERGY is equal to power
		call ADE7753.getReg(ADE7753_RAENERGY, 4);
		// call ADE7753.getReg(ADE7753_MODE, 3);
		
	}

	task void signalSampleDone() {
		uint32_t l_energy, l_renergy, l_laenergy, l_lvaenergy, l_lvarenergy;
		if (energyMode==AENERGY) {
			energyMode=LAENERGY;
			return call ADE7753.getReg(ADE7753_LAENERGY, 4);	
		} else if (energyMode==LAENERGY) {
			energyMode=LVAENERGY;
			return call ADE7753.getReg(ADE7753_RVAENERGY, 4);	
		} else if (energyMode==LVAENERGY) {
			energyMode=LVARENERGY;
			return call ADE7753.getReg(ADE7753_LVARENERGY, 4);	
		} else if (energyMode==LVARENERGY) {
			energyMode=AENERGY;
			atomic l_energy = energy;
			atomic l_laenergy = laenergy;
			atomic l_lvaenergy = lvaenergy;
			atomic l_lvarenergy = lvarenergy;
			signal ACMeter.sampleDone(l_energy, l_laenergy, l_lvaenergy, l_lvarenergy);
			return;
		}
	}

	async event void ADE7753.getRegDone( error_t error, uint8_t regAddr, uint32_t val, uint16_t len) {
		atomic if (dirty) {
			dirty = FALSE;
			return;
		} else {
			if (energyMode==AENERGY) {
				atomic energy = val;
			} else if (energyMode==LAENERGY) {
				atomic laenergy = val;
			} else if (energyMode==LVAENERGY) {
				atomic lvaenergy = val;
			} else if (energyMode==LVARENERGY) {
				atomic lvarenergy = val;
			} else {
				// should not get here
			}
			post signalSampleDone();
		}
	}
	
  task void setRegGain() {
	call ADE7753.setReg(ADE7753_GAIN, 2, ADE7753_GAIN_VAL);
  }

  task void setRegLinecyc() {
	call ADE7753.setReg(ADE7753_LINECYC, 3, ADE7753_LINECYC_VAL);
  }

	async event void ADE7753.setRegDone( error_t error, uint8_t regAddr, uint32_t val, uint16_t len) {
		switch (stage) {
		case INIT:
			return;
		case SET_MODE:
//			atomic stage = SET_LINECYC;
			atomic stage = SET_GAIN;	
//            post setRegLinecyc();
			post setRegGain();
			return;
		case SET_LINECYC:
			atomic stage = SET_GAIN;
	        post setRegGain();
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
	
