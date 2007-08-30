/* Copyright (c) 2007 ETH Zurich.
*  All rights reserved.
*
*  Redistribution and use in source and binary forms, with or without
*  modification, are permitted provided that the following conditions
*  are met:
*
*  1. Redistributions of source code must retain the above copyright
*     notice, this list of conditions and the following disclaimer.
*  2. Redistributions in binary form must reproduce the above copyright
*     notice, this list of conditions and the following disclaimer in the
*     documentation and/or other materials provided with the distribution.
*  3. Neither the name of the copyright holders nor the names of
*     contributors may be used to endorse or promote products derived
*     from this software without specific prior written permission.
*
*  THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS `AS IS'
*  AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE
*  IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE
*  ARE DISCLAIMED.  IN NO EVENT SHALL THE COPYRIGHT HOLDERS OR CONTRIBUTORS
*  BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR
*  CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO, LOSS OF USE, DATA,
*  OR PROFITS) HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN
*  CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE)
*  ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF
*  THE POSSIBILITY OF SUCH DAMAGE.
*
*  For additional information see http://www.btnode.ethz.ch/
*
*  $Id$
* 
*/

/**
 * DSN Component for TinyOS.
 *
 * This component gives the facility to easily log messages to the Deployment Support Network
 * and receive commands.
 *
 * @author Roman Lim <rlim@ee.ethz.ch>
 *
 **/

#include "DSN.h"

module DSNP
{
	provides interface DSN;	
	provides interface DsnSend;
	provides interface DsnReceive;
	provides interface Init;
	provides interface Init as NodeIdInit;
	
	uses interface UartStream;
	uses interface Resource;
	uses interface DsnPlatform;
}

implementation
{
	uint8_t ringbuffer[BUFFERSIZE];
	uint8_t * bufferStart;
	uint8_t * bufferEnd;
	uint8_t rxlen=0;
	uint8_t rxbuffer[RXBUFFERSIZE];
	uint32_t n[LOG_NR_BUFFERSIZE]; // buffer for ints to print out
	uint8_t nptr=0;
	
	enum {
		S_INIT,
		S_STARTED,
		S_REQUEST_PENDING,
		S_SENDING,
	};
	
	uint8_t m_state=S_INIT;
	
	bool running=TRUE;
	bool rxreq=FALSE;
	bool UartStreamBusy=FALSE;
	
	/* prototype */
	void stop();
	void requestUSART();
	
	/**
	 * Initialization (before SoftwareInit)
	 */
	command error_t NodeIdInit.init() {
		// setup node id
		am_addr_t flashId = call DsnPlatform.getSavedId(); 
		if (flashId!=NO_ID) {
			call DsnPlatform.setNodeId(flashId); 
		}
		return SUCCESS;
	}
	
	/**
	* Initialization for the DSN Component
	* Sets up pins, buffer and node id
	**/
	command error_t Init.init() {
		call DsnPlatform.init();
		m_state=S_STARTED;
		bufferStart=&ringbuffer[0];
		bufferEnd=&ringbuffer[1];
		ringbuffer[0]=LOG_DELIMITER;
		return SUCCESS;
	}
		
	/***************************************
	 * Output Processing: Helper functions
	 * *************************************/

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
	* If msg is not terminated with LOG_DELIMITER, it is automatocally appended if delimiter=TRUE
	**/
    void storeMsg(uint8_t * msg, bool delimiter) {
    	uint16_t msgPtr=0;
		uint8_t nrPtr=0;
		uint32_t tmpN;
		uint8_t i;
		bool storedNr=FALSE;

		while (((msgPtr==0) | (msg[msgPtr-1]!=LOG_DELIMITER)) & (msg[msgPtr]!=0)) {
    		if (msg[msgPtr]=='%') {
    			atomic tmpN=n[nrPtr];
    			storedNr=FALSE;
    			switch (msg[msgPtr+1]) {
    				case 'i':
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
    					break;
    				case 'h':// hexadecimal output
    				case 'x':// hexadecimal output
    					for (i=4;i>0;i--) {
    						storeMsgHex(((uint8_t *) (&tmpN))+i-1, 1);
    					}
    					storedNr=TRUE;
    					break;
    				case 'b':// binary output
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
    					break;
    				case '%':// escaped %
    					msgPtr++;
    				default:
    					storeByte('%');
    					break;
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
    	if ((msg[msgPtr]==0) & ((msgPtr==0) | (msg[msgPtr-1]!=LOG_DELIMITER)) & delimiter)
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
    
    async command void DSN.logInt(uint32_t nn) {
		atomic {
			if (nptr<LOG_NR_BUFFERSIZE) {
				n[nptr++]=nn;
			}
		}
	}
	
	command error_t DSN.log(void * msg) {
		storeMsg((uint8_t *)msg, TRUE);
		if (running) // else just buffer
			requestUSART();
		return SUCCESS;
	}
	
	command error_t DSN.appendLog(void * msg) {
		storeMsg((uint8_t *)msg, FALSE);
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
  	
  	
  	command error_t DSN.logPacket(message_t * msg) {
		void * header = call DsnPlatform.getHeader( msg );
   		storeMsgNr("D ",2); // log as debug message
		storeMsgHex( (uint8_t *) header, call DsnPlatform.getHeaderLength());
		storeMsgNr("|",1);
		storeMsgHex( (uint8_t *) msg->data, call DsnPlatform.getPayloadLength(msg));
		return call DSN.log("\n");
	}
	
	/***************************************
	 * UARt stuff
	 * *************************************/
		
	/**
	* Sends all messages until end of ringbuffer
	**/
	task void sendBuf() {
		atomic {
			if (!UartStreamBusy && m_state==S_SENDING) {
				UartStreamBusy=TRUE;
				if (bufferEnd<bufferStart) {// check wether end of message is before end of ringbuffer
					call UartStream.send(bufferStart, &ringbuffer[BUFFERSIZE] - bufferStart);
				}
   				else
					call UartStream.send(bufferStart, bufferEnd - bufferStart);
			}
		}
	}
	
	async event void UartStream.sendDone(uint8_t * buf, uint16_t len, error_t error) {
		UartStreamBusy=FALSE;
  		if (error==SUCCESS) {
  			bufferStart+=len;
  			if (bufferStart==&ringbuffer[BUFFERSIZE])
  				bufferStart=&ringbuffer[0];
  			atomic {
  				if (bufferStart == bufferEnd) { // check, if there is more data to be sent
  					if (!call DsnPlatform.isHandshake() || !rxreq) { // if not, is there something to be received?
						stop();
					}
					else {
						call DsnPlatform.rxGrant();
					}
  				}
  				else {
					// send next chunk of message
					if (m_state==S_SENDING)
						post sendBuf();
				}
  			}	
  		}
  	}

	void stop() {
		call DsnPlatform.flushUart();
		atomic {
			if (m_state==S_SENDING) {
				call Resource.release();
				m_state=S_STARTED;
			}
		}
	}
	
	/**
	* we have the UART
	* start sending / receiving
	**/
	event void Resource.granted() {
		atomic m_state=S_SENDING;
		// start sending or receiving
		atomic {
			if (!call DsnPlatform.isHandshake() || !rxreq) {
				post sendBuf();
			}
			else
				call DsnPlatform.rxGrant();
		}
	}
		
	/**
	* this function makes sure that the USART resource is requested only once
	*
	**/
	void requestUSART() {
		atomic {
			if (m_state==S_STARTED && call Resource.request()==SUCCESS)
				m_state=S_REQUEST_PENDING;
		}
	}
	
	  
	task void ReceivedTask() {
		// PAY ATTENTION: rxbuffer is not copied, it might be overriden during this task
  		uint8_t rxlen_tmp;
  		atomic {
  			rxlen_tmp=rxlen;
  			rxlen=0;
  		}
  		signal DsnReceive.receive(rxbuffer, rxlen_tmp);
	  	signal DSN.receive(rxbuffer, rxlen_tmp);
	}
  
	/**
	* A byte of data has been received.
	*/
  	async event void UartStream.receivedByte(uint8_t data) {
  		atomic {
  			if (data==LOG_DELIMITER) {
  				// last byte received
  				rxreq=FALSE;
  				call DsnPlatform.rxRelease();
  				if ((bufferStart != bufferEnd) && running)
  					post sendBuf();
  				else if (call DsnPlatform.isHandshake())
	  				stop();
  				rxbuffer[rxlen]=0;
  				post ReceivedTask();
  			}
  			else {
  				if (rxlen < RXBUFFERSIZE-1) // last byte is reserved for LOG_DELIMITER
  					rxbuffer[rxlen++]=data;
  			}
  		}
	}

	async event void DsnPlatform.rxRequest() { // this event is only signaled when handshake is enabled
		rxreq=TRUE;
		requestUSART();
	}
	
	command error_t DSN.stopLog(){
		atomic {
			running=FALSE;
		}
		return SUCCESS;
	}
	
	command error_t DSN.startLog(){
		atomic {
			running=TRUE;
			if (bufferStart != bufferEnd)
				requestUSART();
		}
		return SUCCESS;
	}
		
	async event void UartStream.receiveDone( uint8_t* buf, uint16_t len, error_t error ) {
	}
	
 /****************** DsnSend commands *******************/
	command error_t DsnSend.log(void * msg) {return call DSN.log(msg); }
	command error_t DsnSend.appendLog(void * msg){return call DSN.appendLog(msg); }
	command error_t DsnSend.logHexStream(uint8_t* msg, uint8_t len){return call DSN.logHexStream(msg, len); }
	command error_t DsnSend.logLen(void * msg, uint8_t len){return call DSN.logLen(msg, len); }
	command error_t DsnSend.logError(void * msg){return call DSN.logError(msg); }
	command error_t DsnSend.logWarning(void * msg){return call DSN.logWarning(msg); }
	command error_t DsnSend.logInfo(void * msg){return call DSN.logInfo(msg); }
	command error_t DsnSend.logDebug(void * msg){return call DSN.logDebug(msg); }
	async command void DsnSend.logInt(uint32_t _n){return call DSN.logInt(_n); }
	command error_t DsnSend.logPacket(message_t * msg){return call DSN.logPacket(msg); }
	command error_t DsnSend.stopLog(){return call DSN.stopLog(); }
	command error_t DsnSend.startLog() 	{return call DSN.startLog(); }
 /****************** receive default events *************/
	default event void DSN.receive(void * msg, uint8_t len) {}
	default event void DsnReceive.receive(void * msg, uint8_t len) {}
}
