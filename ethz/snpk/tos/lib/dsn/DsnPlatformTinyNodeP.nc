#include "DSN.h"
generic module DsnPlatformTinyNodeP(bool useHandshake) {
	provides {
		interface DsnPlatform;
		interface Msp430UartConfigure;
		interface Resource as DummyResource; // this resource is once granted, never released
	}
	uses {
		interface HplMsp430Usart;
		interface GeneralIO as TxPin;
		interface GeneralIO as RxRTSPin;
		interface GeneralIO as RxCTSPin;
		interface GpioInterrupt as RxRTSInt;
		command void setAmAddress(am_addr_t a);
		interface Packet;
		interface SplitControl as RadioControl;
		interface Resource;
	}
}
implementation {
	
	bool dummyResourceGranted=FALSE;
	
	msp430_uart_union_config_t dsn_config = {
  		{
  		ubr: UBR_32KHZ_9600,			//UBR_1MHZ_9600
  		umctl: UMCTL_32KHZ_9600, 			//UMCTL_1MHZ_9600
  		ssel: 0x01,		//Clock source (00=UCLKI; 01=ACLK; 10=SMCLK; 11=SMCLK)
		pena: 0,
		pev: 0,
		spb: 0,
		clen: 1,
		listen: 0,
		mm: 0,
		ckpl:0,
		urxse: 0,
		urxeie: 1,
		urxwie: 0,
		utxe:1,		// 1:enable tx module
  		urxe:1,		// 1:enable rx module
  	}};
	
	
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
		return sizeof(xe1205_header_t);
	}
	
	command void* DsnPlatform.getHeader( message_t* msg ) {
    	return (void * )( msg->data - call DsnPlatform.getHeaderLength() );
	}
	
	command uint8_t DsnPlatform.getPayloadLength(message_t * msg) {
		return call Packet.payloadLength(msg);
	}
	
	async command bool DsnPlatform.isHandshake() {
		return useHandshake;
	}
	  	
	event void RadioControl.startDone(error_t error) {}
	event void RadioControl.stopDone(error_t error) {}
	
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
