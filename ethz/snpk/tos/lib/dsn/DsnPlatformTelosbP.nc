#include "DSN.h"
#if USART == 0
#define DSN_HANDSHAKE
#endif
module DsnPlatformTelosbP {
	provides {
		interface DsnPlatform;
		interface Msp430UartConfigure;
		interface Resource as DsnResource; // no handshake:this resource is once granted, never released
											 // handshake: wire through to uart
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
		interface Boot;
		interface Timer<TMilli> as TimeoutTimer;
	}
}
implementation {
	
	bool dummyResourceGranted=FALSE;

	msp430_uart_union_config_t dsn_config = {
  		{
  		ubr: UBR_1MHZ_115200, //UBR_32KHZ_9600,			//UBR_1MHZ_9600
  		umctl: UMCTL_1MHZ_115200, //UMCTL_32KHZ_9600, 			//UMCTL_1MHZ_9600
  		ssel: 0x02, //0x01,		//Clock source (00=UCLKI; 01=ACLK; 10=SMCLK; 11=SMCLK)
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
#ifdef DSN_HANDSHAKE
		// setup pin for rx RTS interrupt
		call RxRTSPin.makeInput();
		// setup CTS pin
		call RxCTSPin.set();		// default hi = not ready to receive
		call RxCTSPin.makeOutput();
#endif		
	}
	
	event void Boot.booted(){
#ifdef DSN_HANDSHAKE		
		call RxRTSInt.disable(); // this clears pending interrupt flags
		call RxRTSInt.enableRisingEdge();
#else
		call DsnResource.immediateRequest();
#endif
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
		return sizeof(cc2420_header_t);
	}
	
	command void* DsnPlatform.getHeader( message_t* msg ) {
    	return (void * )( msg->data - call DsnPlatform.getHeaderLength() );
	}
	
	command uint8_t DsnPlatform.getPayloadLength(message_t * msg) {
		return call Packet.payloadLength(msg);
	}
	
	async command bool DsnPlatform.isHandshake() {
#ifdef DSN_HANDSHAKE		
		return TRUE;
#else
		return FALSE;
#endif		
	}
	  	
	event void RadioControl.startDone(error_t error) {}
	event void RadioControl.stopDone(error_t error) {}
	
  	async command msp430_uart_union_config_t* Msp430UartConfigure.getConfig() {
	    return &dsn_config;
  	}
 /********* DsnResource ****************************/
 	task void grantedTask() {
 		signal DsnResource.granted();
 	}
 	
	async command error_t DsnResource.request() {
#ifdef DSN_HANDSHAKE
		return call Resource.request();
#else
		if (!dummyResourceGranted)
			call Resource.request();
		else
			post grantedTask();
		return SUCCESS;
#endif		
	}
	
	async command error_t DsnResource.immediateRequest() {
#ifdef DSN_HANDSHAKE
		return call Resource.immediateRequest();
#else		
		atomic {
			if (!dummyResourceGranted)
				if (call Resource.immediateRequest()==SUCCESS)
					dummyResourceGranted=TRUE;
		}
		return SUCCESS;
#endif		
	}
	
	async command error_t DsnResource.release() {
#ifdef DSN_HANDSHAKE
		return call Resource.release();
#else
		return FAIL;
#endif
	}
	async command bool DsnResource.isOwner() {
#ifdef DSN_HANDSHAKE
		return call Resource.isOwner();
#else		
		return dummyResourceGranted;
#endif		
	}
	
	event void Resource.granted() {
#ifndef DSN_HANDSHAKE
		atomic dummyResourceGranted=TRUE;
#endif
		signal DsnResource.granted();
	} 

	// ************* Timeout monitor for rx line ***********
	
	bool rxhandled;
	
	command void DsnPlatform.startTimeoutMonitor(uint8_t timeout) {
		atomic rxhandled=FALSE;
		call TimeoutTimer.startPeriodic(timeout);
	}
	command void DsnPlatform.stopTimeoutMonitor() {
		call TimeoutTimer.stop();
	}
	
	async command void DsnPlatform.updateTimeoutMonitor() {
		rxhandled=TRUE;
	}
	
	event void TimeoutTimer.fired() {
		atomic if (!rxhandled) {
			call TimeoutTimer.stop();
			signal DsnPlatform.timeoutMonitorFired();
		}
	}
	
	// ************* default stuff
	
  	default async command void RxCTSPin.set() {}
  	default async command void RxCTSPin.clr() {}
  	default async command void RxCTSPin.makeOutput() {}
  	default async command void RxRTSPin.makeInput() {}
  	default async command error_t RxRTSInt.enableRisingEdge() {return SUCCESS;}
  	default event void DsnResource.granted() {}
}
