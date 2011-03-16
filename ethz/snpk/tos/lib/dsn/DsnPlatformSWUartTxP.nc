#include "DSN.h"
generic module DsnPlatformSWUartTxP(bool useHandshake) {
	provides {
		interface DsnPlatform;
		interface Resource as DummyResource; // this resource is once granted, never released
	}
	uses { 
		interface GeneralIO as TxPin;
		command void setAmAddress(am_addr_t a);
		interface Packet;
	}
}
implementation {
	
	bool dummyResourceGranted=FALSE;
	
	command void DsnPlatform.init(){		
		// set TxPin high
		// a low pin would cause framing errors in the dsn uart
		call TxPin.set();
		call TxPin.makeOutput();
	}
	
	async command void DsnPlatform.flushUart(){
		signal DsnPlatform.flushUartDone();
	}
	
	command am_addr_t DsnPlatform.getSavedId() {
		volatile uint16_t *IdAddr = (uint16_t *)MSP430_ID_ADDR;
		return *IdAddr;
	}
	
	command void DsnPlatform.setNodeId(am_addr_t id) {
		TOS_NODE_ID=id;
		call setAmAddress(id);
	}
	
	command uint8_t DsnPlatform.getHeaderLength() {
		return 0;
	}
	
	command void* DsnPlatform.getHeader( message_t* msg ) {
    	return (void * )( msg->data - call DsnPlatform.getHeaderLength() );
	}
	
	command uint8_t DsnPlatform.getPayloadLength(message_t * msg) {
		return 0;
	}
	
	async command bool DsnPlatform.isHandshake() {
		return useHandshake;
	}
	
	async command void DsnPlatform.rxGrant(){}
	
	async command void DsnPlatform.rxRelease(){}
	  		
 /********* DummyResource ****************************/
 	task void grantedTask() {
		atomic dummyResourceGranted=TRUE;
 		signal DummyResource.granted();
 	}
 	
	async command error_t DummyResource.request() {
		post grantedTask();
		return SUCCESS;
	}
	
	async command error_t DummyResource.immediateRequest() {
		atomic dummyResourceGranted=TRUE;
		return SUCCESS;
	}
	
	async command error_t DummyResource.release() {return FAIL;}
	async command bool DummyResource.isOwner() {return dummyResourceGranted; }
	
	// ************* Timeout monitor for rx line ***********
	command void DsnPlatform.startTimeoutMonitor(uint8_t timeout) {
	}
	command void DsnPlatform.stopTimeoutMonitor() {
	}	
	async command void DsnPlatform.updateTimeoutMonitor() {
	}	

  	default event void DummyResource.granted() {}
}
