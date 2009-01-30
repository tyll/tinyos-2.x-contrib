#include "DSN.h"
#include "msp430usart.h"
generic module DsnPlatformTinyNode184P(bool useHandshake) {
	provides {
		interface DsnPlatform;
		interface Msp430UartConfigure;
		interface Resource as DummyResource; // this resource is once granted, never released
	}
	uses {
		interface HplMsp430UsciUart as HplMsp430Usart;
		interface GeneralIO as TxPin;
		interface GeneralIO as RxRTSPin;
		interface GeneralIO as RxCTSPin;
		interface GpioInterrupt as RxRTSInt;
		command void setAmAddress(am_addr_t a);
		interface Packet;
		interface Resource;
	}
}
implementation {
	
	bool dummyResourceGranted=FALSE;
	
	msp430_uart_union_config_t dsn_config = {
  		{
  		    utxe : 1, 
  		    urxe : 1, 
  		    ubr : UBR_32KHZ_9600, 
  		    umctl : UMCTL_32KHZ_9600, 
  		    ssel : 0x01, 
  		    pena : 0, 
  		    pev : 0, 
  		    spb : 0, 
  		    clen : 0, 
  		    mode :0,
  		    msb: 0,
  		    dorm: 0,
  		    brkeie: 0,
  		    rxeie: 1,
  		}
	};		
	
	command void DsnPlatform.init(){		
		// set TxPin high
		// a low pin would cause framing errors in the dsn uart
		call TxPin.set();
		call TxPin.makeOutput();
		// setup pin for rx RTS interrupt
		call RxRTSPin.makeInput();
		call RxRTSInt.enableRisingEdge();
		// setup CTS pin
		call RxCTSPin.set();		// default hi = not ready to receive
		call RxCTSPin.makeOutput();
	}
	
	async command void DsnPlatform.flushUart(){
		while (!call HplMsp430Usart.isTxEmpty());
		signal DsnPlatform.flushUartDone();
	}
	
	async event void RxRTSInt.fired() {
		signal DsnPlatform.rxRequest();
	}
	
	async command void DsnPlatform.rxGrant(){
		call RxCTSPin.clr();
	}
	
	async command void DsnPlatform.rxRelease(){
		call RxCTSPin.set();
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
	  		
  	async command msp430_uart_union_config_t* Msp430UartConfigure.getConfig() {
	    return &dsn_config;
  	}
 /********* DummyResource ****************************/
 	task void grantedTask() {
 		signal DummyResource.granted();
 	}
 	
	async command error_t DummyResource.request() {
		if (!dummyResourceGranted)
			call Resource.request();
		else
			post grantedTask();
		return SUCCESS;
	}
	
	async command error_t DummyResource.immediateRequest() {
		if (!dummyResourceGranted)
			if (call Resource.immediateRequest()==SUCCESS) {
				dummyResourceGranted=TRUE;
				return SUCCESS;
			}
		else
			return SUCCESS;
	}
	
	async command error_t DummyResource.release() {return FAIL;}
	async command bool DummyResource.isOwner() {return dummyResourceGranted; }
	event void Resource.granted() {
		atomic dummyResourceGranted=TRUE;
		signal DummyResource.granted();
	} 
	
	// ************* Timeout monitor for rx line ***********
	command void DsnPlatform.startTimeoutMonitor(uint8_t timeout) {
	}
	command void DsnPlatform.stopTimeoutMonitor() {
	}	
	async command void DsnPlatform.updateTimeoutMonitor() {
	}	

  	default async command void RxCTSPin.set() {}
  	default async command void RxCTSPin.clr() {}
  	default async command void RxCTSPin.makeOutput() {}
  	default async command void RxRTSPin.makeInput() {}
  	default async command error_t RxRTSInt.enableRisingEdge() {return SUCCESS;}
  	default event void DummyResource.granted() {}
}
