#include <AM.h>
#include "DSN.h"

module noDSNP
{
	provides interface DSN;	
	provides interface Init as NodeIdInit;
	uses command void setAmAddress(am_addr_t a);
}
implementation
{
  command error_t DSN.log(void * msg) {
  	return SUCCESS;
  	}
  command error_t DSN.logLen(void * msg, uint8_t len) {
  	return SUCCESS;
  	}
  command error_t DSN.logError(void * msg) {
  	return SUCCESS;
  	}
  command error_t DSN.logWarning(void * msg) {
  	return SUCCESS;
  	}
  command error_t DSN.logInfo(void * msg) {
  	return SUCCESS;
  	}
  command error_t DSN.logDebug(void * msg) {
  	return SUCCESS;
  	}
  command error_t DSN.appendLog(void * msg) {
	return SUCCESS;
	}
	
  async command void DSN.logInt(uint32_t n) {}
  command error_t DSN.logPacket(message_t * msg) {return SUCCESS;}
  command error_t DSN.logHexStream(uint8_t* msg, uint8_t len) {return SUCCESS;}   

  command error_t DSN.stopLog() {
  	return SUCCESS;
  	}
  command error_t DSN.startLog() {
  	return SUCCESS;
  	}
  
  command error_t NodeIdInit.init() {
		 volatile uint16_t *IdAddr;
	  	// setup node id
		IdAddr=(uint16_t *)ID_ADDR;
		if (*IdAddr!=NO_ID) {
			TOS_NODE_ID=*IdAddr;
			call setAmAddress(TOS_NODE_ID);
		}
		return SUCCESS;
  }
  
  command void DSN.emergencyLogEnable(uint32_t timeout) {}
  command void DSN.emergencyLogDisable() {}
  command error_t DSN.emergencyLogAdd(void * pointer, uint8_t numBytes, uint8_t * description) {
  	return SUCCESS;
  	}
}

