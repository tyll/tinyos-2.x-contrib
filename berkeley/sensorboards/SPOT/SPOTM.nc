//SPOT Energy Meter using FM3116
//@author Fred Jiang <fxjiang@eecs.berkeley.edu>

#include <Timer.h>

module SPOTM {
	uses interface Boot;
	uses interface FM3116 as Measure;
	uses interface FM3116 as Base;
	uses interface Timer<TMilli> as Timer;
	uses interface GeneralIO as RW;
	uses interface GeneralIO as EN;
	uses interface GeneralIO as CAL;
	uses interface GeneralIO as CEN;
	uses interface GeneralIO as CE2N;
	uses interface GeneralIO as CLE;
	uses interface GeneralIO as ALE;
	uses interface GeneralIO as REN;
	uses interface GeneralIO as WEN;
	uses interface GeneralIO as WPN;
	uses interface GeneralIO as RBN;
	uses interface GeneralIO as RB2N;
	provides interface Boot as RealBoot;
	provides interface SPOT;
}

implementation {
	
	enum stage {
		CAL_START,
		CAL_END,
		NORMAL
	};

	uint32_t time_cal_1, time_cal_2, energy_cal_1, energy_cal_2, time, energy;
	uint8_t stage = CAL_START;
			
	event void Boot.booted() {
		call RW.makeOutput();
		call RW.set();
		call EN.makeOutput();
		call EN.set();
		call CAL.makeOutput();

		// Calibration
		call CAL.set();
		
		// disable storage
		call CEN.makeOutput();
		call CEN.set();
		call CE2N.makeOutput();
		call CE2N.set();
		call CLE.makeOutput();
		call CLE.set();
		call ALE.makeOutput();
		call ALE.set();
		call REN.makeOutput();
		call REN.set();
		call WEN.makeOutput();
		call WEN.set();
		call WPN.makeOutput();
		call WPN.set();
		call RBN.makeInput();
		call RB2N.makeInput();
		call Base.init();
	}

	event void Base.initDone() {
		call Measure.init();
	}
		
	event void Measure.initDone() {
		// wait for calibration mode to settle
		call Timer.startOneShot(5120);
	}

	event void Base.writeReg_Done() {}
	
	event void Base.calDone() {}
		
	event void Base.readReg_Done(uint8_t val) {}
		
	event void Base.readDone(uint32_t cnt) {}

	event void Measure.writeReg_Done() {}
	
	event void Measure.calDone() {}
		
	event void Measure.readReg_Done(uint8_t val) {}
		
	event void Measure.readDone(uint32_t cnt) {}

	event void Base.snapshotDone() {
		call Measure.takeSnapshot();
	}
	
	event void Measure.snapshotDone() {
		call RW.set();
		call Base.readCounter_Only();
	}
	
	event void Base.readOnly_Done(uint32_t cnt) {
		switch(stage) {
		case CAL_START:
			time_cal_1 = cnt;
			break;
		case CAL_END:
			time_cal_2 = cnt;
			break;
		case NORMAL:
			time = cnt;
			break;
		}
		call Measure.readCounter_Only();
	}
	
	event void Measure.readOnly_Done(uint32_t cnt) {
		switch(stage) {
		case CAL_START:
			energy_cal_1 = cnt;
			stage = CAL_END;
			call Timer.startOneShot(1024);
			break;
		case CAL_END:
			energy_cal_2 = cnt;
			stage = NORMAL;
			call CAL.clr();
			call Timer.startOneShot(5120);
			break;
		case NORMAL:
			energy = cnt;
			signal SPOT.sampleDone(time, energy);
			break;
		}
	}
	
	event void Timer.fired() {
		switch(stage) {
		case CAL_START:
			// take calibration value
			call RW.clr();
			call Measure.takeSnapshot();
			break;			
		case CAL_END:
			call RW.clr();
			call Measure.takeSnapshot();	
			break;
		case NORMAL:
			signal RealBoot.booted();
			break;
		}
	}

	command error_t SPOT.sample() {
		if (stage != NORMAL)
			return FAIL;
		else {
			call RW.clr();
			call Measure.takeSnapshot();
			return SUCCESS;
		}
	}

	command uint32_t SPOT.getCalTime1() {
		return time_cal_1;
	}

	command uint32_t SPOT.getCalTime2() {
		return time_cal_2;
	}

	command uint32_t SPOT.getCalEnergy1() {
		return energy_cal_1;
	}

	command uint32_t SPOT.getCalEnergy2() {
		return energy_cal_2;
	}

}
