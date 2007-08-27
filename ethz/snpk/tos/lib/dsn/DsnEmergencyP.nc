#include "DSN.h"
#include <Timer.h>
module DsnEmergencyP {
	provides interface DsnEmergency;
	uses {
		interface DsnSend as DSN;
		interface Timer<TMilli> as EmergencyTimer;
		interface LocalTime<T32khz>;
	}
}
implementation {
	// emergency variables
	bool emergencyLogEnabled=FALSE;
	uint8_t numEmergencyVars=0;
	VarStruct emergencyVar[255];
	uint32_t emergencyTimeout;
	
	/***************************************
	 * Emergency output
	 * *************************************/
	
	command void DsnEmergency.adjustTimeout () {
		if (emergencyLogEnabled) {
			call EmergencyTimer.startOneShot(emergencyTimeout);
		}
	}
	
	command void DsnEmergency.enable(uint32_t timeout) {
		emergencyLogEnabled=TRUE;
		emergencyTimeout=timeout;
		call EmergencyTimer.startOneShot(emergencyTimeout);
	}
	
	command void DsnEmergency.disable() {
		emergencyLogEnabled=FALSE;
		call EmergencyTimer.stop();
	}
	
	command error_t DsnEmergency.addMonitorVariable(void * pointer, uint8_t numBytes, uint8_t * description) {
		if (numEmergencyVars<255) {
			emergencyVar[numEmergencyVars].pointer=pointer;
			emergencyVar[numEmergencyVars].length=numBytes;
			emergencyVar[numEmergencyVars].description=description;
			numEmergencyVars++;
			return SUCCESS;
		}
		else {
			return FAIL;
		}
	}
	
	event void EmergencyTimer.fired() {
		uint8_t i;
		// log all registered variables
		call DsnEmergency.disable()
		call DSN.startLog();
		call DSN.logInt(call LocalTime.get());
		call DSN.log("Emergency dump at %i:");
		for (i=0;i<numEmergencyVars;i++) {
			call DSN.appendLog(emergencyVar[i].description);
			call DSN.appendLog("=");
			call DSN.logHexStream((uint8_t *) emergencyVar[i].pointer, emergencyVar[i].length);
		}
	}	
}
