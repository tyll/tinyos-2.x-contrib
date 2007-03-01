/**
 * DSN Component for TinyOS.
 *
 * This component gives the facility to easily log messages to the Deployment Support Network
 * and receive commands.
 *
 * @author Roman Lim <rlim@ee.ethz.ch>
 * @modified 10/3/2006 Added documentation.
 *
 **/

#include "DSN.h"
#include <Timer.h>

module DSNP
{
	provides interface DSN;	
	provides interface Init;
	
	uses interface UartStream;
	uses interface HplMsp430Usart;
	uses interface Resource;
	uses interface GeneralIO as TxPin;
#ifndef 	NOSHARE
	uses interface GeneralIO as RxRTSPin;
	uses interface GeneralIO as RxCTSPin;
	uses interface GpioInterrupt as RxRTSInt;
#endif
	uses command void setAmAddress(am_addr_t a);
	uses interface Packet;
	uses interface SplitControl as RadioControl;
	uses interface Timer<TMilli> as Timer;
	uses interface Timer<TMilli> as EmergencyTimer;
	uses interface LocalTime<T32khz>;
			
	uses interface Leds;
}

implementation
{
	bool sending=FALSE;
	uint8_t ringbuffer[BUFFERSIZE];
	uint8_t * bufferStart;
	uint8_t * bufferEnd;
	uint8_t rxlen;
	uint8_t rxbuffer[RXBUFFERSIZE];
	bool rxreq=FALSE;
	volatile uint16_t *IdAddr;
	uint32_t n[LOG_NR_BUFFERSIZE]; // buffer for ints to print out
	uint8_t nptr=0;
	bool running=TRUE;
	bool requested=FALSE;
	
	// emergency variables
	bool emergencyLogEnabled=FALSE;
	uint8_t numEmergencyVars=0;
	VarStruct emergencyVar[255];
	uint32_t emergencyTimeout;
	
	/* prototype */
	void stop();
	void adjustEmergencytimeout();
	
	/**
	* Initialization for the DSN Component
	* Sets up pins, buffer and node id
	**/
	command error_t Init.init() {
		// set TxPin high
		// a low pin would cause framing errors in the dsn uart
		call TxPin.makeOutput();
		call TxPin.set();
		
#ifndef NOSHARE
		// setup pin for rx RTS interrupt
		call RxRTSPin.makeInput();
		call RxRTSInt.enableRisingEdge();
		// setup CTS pin
		call RxCTSPin.makeOutput();
		call RxCTSPin.set();		// default hi = not ready to receive
#endif

		// setup ringbuffer
		bufferStart=&ringbuffer[0];
		bufferEnd=&ringbuffer[0];
		
		// setup node id
		IdAddr=(uint16_t *)ID_ADDR;
		if (*IdAddr!=NO_ID) {
			TOS_NODE_ID=*IdAddr;
			call setAmAddress(TOS_NODE_ID);
		}
		
		// set startup time (a few ms, all output is buffered)
		call Timer.startOneShot(STARTUP_WAIT_TIME);		
		return SUCCESS;
	}

	uint32_t pow(uint16_t b, uint8_t e) {
		uint8_t i;
		uint32_t r=1;
		for (i=0;i<e;i++)
			r*=b;
		return r;
	}
	
	void storeByte(uint8_t b) {
    	atomic {
			*bufferEnd=b;
    		if (bufferEnd==&ringbuffer[BUFFERSIZE-1])
    			bufferEnd=&ringbuffer[0];
	    	else
	    		bufferEnd++;
	    }
    }
    
	void storeMsgHex(uint8_t * msg, uint8_t len) {
		uint8_t i, val;
		for (i=0;i<len;i++) {
			val=msg[i]/16;
			if (val > 9)
				storeByte(val-10+65); 
			else
				storeByte(val+48); 
			val=msg[i]%16;
			if (val > 9)
				storeByte(val-10+65); 
			else
				storeByte(val+48);
		if (i!=len-1)	storeByte(32); 
		}
	}
    
	/**
	* Add chars to the tx buffer
	* String has to end with LOG_DELIMITER or 0
	**/
    void storeMsg(uint8_t * msg) {
    	uint16_t msgPtr=0;
		uint8_t nrPtr=0;
		uint32_t tmpN;
		uint8_t i;
		bool storedNr=FALSE;

		while (((msgPtr==0) | (msg[msgPtr-1]!=LOG_DELIMITER)) & (msg[msgPtr]!=0)) {
    		if (msg[msgPtr]=='%') {
    			atomic tmpN=n[nrPtr];
    			if (msg[msgPtr+1]=='i') {
		    		storedNr=FALSE;
    				if (tmpN==0) {
    					storeByte('0');
    				}
    				else {
						for (i=10;i>0;i--) {
							if (tmpN/pow(10,i-1)>0) {
								storedNr=TRUE;
								storeByte(tmpN/pow(10,i-1)+48);
								tmpN=tmpN % pow(10,i-1);
							}
							else if (storedNr)
								storeByte('0');
						}
					}
					storedNr=TRUE;
    			}
    			else if (msg[msgPtr+1]=='h') {	// hexadecimal output
	    			for (i=4;i>0;i--) {
    					storeMsgHex(((uint8_t *) (&tmpN))+i-1, 1);
    				}
    				storedNr=TRUE;
    			}
    			else if (msg[msgPtr+1]=='b') {	// binary output
    				if ((msg[msgPtr+2]!='1') & (msg[msgPtr+2]!='2') & (msg[msgPtr+2]!='3') & (msg[msgPtr+2]!='4')) {
    					i=32;
    				}
    				else {
    					i = (msg[msgPtr+2]-48)*8;
    					msgPtr++;
    				}
    				for (;i>0;i--) {
    					if ((tmpN >> (i-1)) & 0x01)
  							storeByte('1');
  						else
  							storeByte('0');
    				}
    				storedNr=TRUE;
    			}
    			msgPtr++;
    			if (storedNr) {
					msgPtr++;
					nrPtr++;
				}
     		}
    		else    		
	    		storeByte(msg[msgPtr++]);
    	}
    	if ((msg[msgPtr]==0) & ((msgPtr==0) | (msg[msgPtr-1]!=LOG_DELIMITER)))
    		storeByte(LOG_DELIMITER);
		atomic nptr=0;
    }
    
    /**
	* Add chars to the tx buffer
	* String length is defined by len
	**/
	void storeMsgNr(uint8_t * msg, uint8_t len) {
		uint8_t i;
		for (i=0;i<len; i++) {
	   		storeByte(msg[i]);
   		}
    }
    
    /**
	* Add chars to the tx buffer
	* String length is defined by \0 at the end
	* max len bytes
	**/
	void storeMsgNull(uint8_t * msg) {
		uint8_t i=0;
		while (msg[i]!=0) {
	   		storeByte(msg[i++]);
   		}
    }
	
	/**
	* Sends all messages until end of ringbuffer
	**/
	void sendBuf() {
		if (bufferEnd<bufferStart) // check wether end of message is before end of ringbuffer
			call UartStream.send(bufferStart, &ringbuffer[BUFFERSIZE] - bufferStart);
    	else
			call UartStream.send(bufferStart, bufferEnd - bufferStart);
	}
	
	void startRxTx() {
		// start sending or receiving
		atomic {
			if (!rxreq) {
					sending = TRUE;
					sendBuf();
			}
#ifndef	NOSHARE
			else
				call RxCTSPin.clr();
#endif
		}
	}

	/**
	* we have the UART
	* start sending / receiving
	**/
	event void Resource.granted() {
		// call Msp430UartControl.setModeDuplex(); // not necessary anymore
		call Leds.led1On();
		adjustEmergencytimeout();
		startRxTx();
	}
	
	void stop() {
#ifndef NOSHARE
		call Leds.led1Off();
		while (!call HplMsp430Usart.isTxEmpty());
		atomic {
			call Resource.release();
			requested=FALSE;
		}
		// signal DSN.led(0);
#endif
	}
	

  /**
   * A byte of data is about to be transmitted, ie. the TXBuffer is
   * empty and ready to accept next byte.
   */
   
  async event void UartStream.sendDone(uint8_t * buf, uint16_t len, error_t error) {
  	if (error==SUCCESS) {
  		bufferStart+=len;
  		if (bufferStart==&ringbuffer[BUFFERSIZE])
  			bufferStart=&ringbuffer[0];
  		if (bufferStart == bufferEnd) { // check, if there is more data to be sent
  			atomic { sending = FALSE; }		
			if (!rxreq) { // if not, is there something to be received?
				stop();
			}
#ifndef 	NOSHARE
			else {
				call RxCTSPin.clr();
			}
#endif
  		}
  		else {
			// send next chunk of message
			sendBuf();
		}	
  	}
  }

	async command void DSN.logInt(uint32_t nn) {
		atomic {
			if (nptr<LOG_NR_BUFFERSIZE) {
				n[nptr++]=nn;
			}
		}
	}
	
	/**
	* this function makes sure that the USART resource is requested only once
	*
	**/
	void requestUSART() {
#ifdef NOSHARE
		atomic {
			if (!sending)
				startRxTx();
		}
#else
		atomic {
			if (!requested) {
				call Resource.request();
				requested=TRUE;
			}
		}
#endif
	}
	
	command error_t DSN.log(void * msg) {
		storeMsg((uint8_t *)msg);
		if ((!call Timer.isRunning()) & (running)) // else just buffer
			requestUSART();
		return SUCCESS;
	}
	
	command error_t DSN.logHexStream(uint8_t* msg, uint8_t len) {
		uint8_t i, val;
		for (i=0;i<len;i++) {
			val=msg[i]>>4;
			if (val > 9) storeByte(val-10+65); 
			else storeByte(val+48); 
			
			val=msg[i]&0x0F;
			if (val > 9) storeByte(val-10+65); 
			else storeByte(val+48);
		}
		return call DSN.log("\n");
	}
	
	command error_t DSN.logError(void * msg) {
		storeMsgNr("E ", 2);
		return call DSN.log(msg);
	}
	
	command error_t DSN.logWarning(void * msg) {
		storeMsgNr("W ", 2);
		return call DSN.log(msg);
	}
	
	command error_t DSN.logInfo(void * msg) {
		storeMsgNr("I ", 2);
		return call DSN.log(msg);
	}
	
	command error_t DSN.logDebug(void * msg) {
		storeMsgNr("D ", 2);
		return call DSN.log(msg);
	}
	
    command error_t DSN.logLen(void * msg, uint8_t len) {
    	storeMsgNr("D ", 2);
    	storeMsgNr(msg, len);
		return call DSN.log("\n");
    }
  	
  	
  	radio_header_t* getHeader( message_t* msg ) {
    	return (radio_header_t*)( msg->data - sizeof(radio_header_t) );
	}

	command error_t DSN.logPacket(message_t * msg) {
		radio_header_t * header = getHeader( msg );
   		storeMsgNr("D ",2); // log as debug message
		storeMsgHex( (uint8_t *) header, sizeof(radio_header_t));
		storeMsgNr("|",1);
		storeMsgHex( (uint8_t *) msg->data, call Packet.payloadLength(msg));
		return call DSN.log("\n");
	}
  
	task void ReceivedTask() {
  		uint8_t rxlen_tmp;
  		atomic {
  			rxlen_tmp=rxlen;
  			rxlen=0;
  		}
	  	signal DSN.receive(rxbuffer, rxlen_tmp);
	}
  
	/**
	* A byte of data has been received.
	*/
   
  	async event void UartStream.receivedByte(uint8_t data) {
  		if (data==LOG_DELIMITER) {
  			// last byte received
  			rxreq=FALSE;
#ifndef NOSHARE
	  		call RxCTSPin.set();
#endif
  			if (bufferStart != bufferEnd)
  				sendBuf();
  			else
  				stop();
  			rxbuffer[rxlen++]=LOG_DELIMITER;
  			post ReceivedTask();
  		}
  		else {
  			rxbuffer[rxlen++]=data;
  		}
	}

#ifndef	NOSHARE
	async event void RxRTSInt.fired() {
		rxreq=TRUE;
		rxlen=0;
		call Leds.led0Toggle();
		requestUSART();
	}
#endif

	event void Timer.fired() {
		atomic {
#ifdef NOSHARE
			call Resource.request();
#else
			if (bufferStart != bufferEnd)
				requestUSART();
#endif
		}
	}
	
	command error_t DSN.stopLog(){
#ifndef PERMANENT_LOGGING
		atomic {
			running=FALSE;
		}
		stop();
#endif
		return SUCCESS;
	}
	
	command error_t DSN.startLog(){
#ifndef PERMANENT_LOGGING
		running=TRUE;
		atomic if (bufferStart != bufferEnd)
			requestUSART();
#endif
		return SUCCESS;
	}
	
	void adjustEmergencytimeout () {
		if (emergencyLogEnabled) {
			call EmergencyTimer.startOneShot(emergencyTimeout);
		}
	}
	
	command void DSN.emergencyLogEnable(uint32_t timeout) {
		emergencyLogEnabled=TRUE;
		emergencyTimeout=timeout;
		call EmergencyTimer.startOneShot(emergencyTimeout);
	}
	
	command void DSN.emergencyLogDisable() {
		emergencyLogEnabled=FALSE;
		call EmergencyTimer.stop();
	}
	
	command error_t DSN.emergencyLogAdd(void * pointer, uint8_t numBytes, uint8_t * description) {
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
		call DSN.emergencyLogDisable();
		call DSN.startLog();
		call DSN.logInt(call LocalTime.get());
		call DSN.log("Emergency dump at %i:\n");
		for (i=0;i<numEmergencyVars;i++) {
			storeMsgNull(emergencyVar[i].description);
			storeMsgNull(" [");
			storeMsgHex((uint8_t *) emergencyVar[i].pointer, emergencyVar[i].length);
			call DSN.log("]");
		}
	}	
	
	async event void UartStream.receiveDone( uint8_t* buf, uint16_t len, error_t error ) {
	}
	
	event void RadioControl.startDone(error_t error) {}
	event void RadioControl.stopDone(error_t error) {}
}
