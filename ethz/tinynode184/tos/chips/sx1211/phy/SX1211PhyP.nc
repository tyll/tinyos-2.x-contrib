/* 
 * Copyright (c) 2006, Ecole Polytechnique Federale de Lausanne (EPFL),
 * Switzerland.
 * All rights reserved.
 *
 * Redistribution and use in source and binary forms, with or without
 * modification, are permitted provided that the following conditions
 * are met:
 * - Redistributions of source code must retain the above copyright notice,
 *   this list of conditions and the following disclaimer.
 * - Redistributions in binary form must reproduce the above copyright
 *   notice, this list of conditions and the following disclaimer in the
 *   documentation and/or other materials provided with the distribution.
 * - Neither the name of the Ecole Polytechnique Federale de Lausanne (EPFL) 
 *   nor the names of its contributors may be used to 
 *   endorse or promote products derived from this software without 
 *   specific prior written permission.
 * 
 * THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS
 * "AS IS" AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT
 * LIMITED TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR
 * A PARTICULAR PURPOSE ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT
 * OWNER OR CONTRIBUTORS BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL,
 * SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED
 * TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA,
 * OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY
 * OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT
 * (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE
 * USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
 *
 * ========================================================================
 */

/*
 * @author Henri Dubois-Ferriere
 *
 */

#include "Timer.h"
#include "sx1211debug.h"
#include "SX1211.h"
#include "message.h"

module SX1211PhyP {
    provides interface SX1211PhyRxTx;
    provides interface SX1211PhyRssi;
    provides interface SX1211PhyRxFrame;

    provides interface Init @atleastonce();
    provides interface SplitControl;

    uses interface Resource as SpiResourceTX;
    uses interface Resource as SpiResourceRX;
    uses interface Resource as SpiResourceConfig;
    uses interface Resource as SpiResourceRssi;

    uses interface SX1211PhySwitch;
    uses interface SX1211IrqConf;
    uses interface SX1211Fifo;
    uses interface SX1211RssiConf;
    uses interface SX1211PatternConf;
    uses interface SX1211PhyConf;

    uses interface GpioInterrupt as Interrupt0;
    uses interface GpioInterrupt as Interrupt1;

    uses interface Alarm<T32khz,uint16_t> as Alarm32khz16;
}
implementation {

    char* txBuf = NULL;
    uint8_t *frame = NULL;
    uint8_t frameLen = 0;
    uint8_t rxFrameIndex = 0;
    uint8_t rxFrameLen = 0;
    uint8_t nextTxLen=0;
    uint8_t nextRxLen;
    uint8_t rxFrameBuf[sizeof(message_t)];
    uint8_t* rxFrame = rxFrameBuf;

    uint8_t headerLen = 4;

    uint16_t stats_rxOverruns;
    uint16_t timestamp, txtimestamp;

    norace uint8_t rxPktRssi;
    norace uint8_t rxRssi;

    bool enableAck = FALSE;

    typedef enum { // remember to update busy() and off(), start(), stop() if states are added
	RADIO_LISTEN=0, 
	RADIO_RX_PACKET=1, 
	RADIO_TX=2,
	RADIO_SLEEP=3, 
	RADIO_STARTING=4,
	RADIO_RX_ACK=5,
	RADIO_RX_PACKET_DEFERRED=6,
	RADIO_RX_PACKET_DEFERRED_READOUT=7,
	RADIO_RX_PACKET_DEFERRED_OVERRUN=8,
    } phy_state_t;

    phy_state_t state = RADIO_SLEEP;


    void armPatternDetect();
    void readPacket();

    ////////////////////////////////////////////////////////////////////////////////////
    //
    // jiffy/microseconds/bytetime conversion functions.
    //
    ////////////////////////////////////////////////////////////////////////////////////

    // 1 jiffie = 1/32768 = 30.52us; 
    // we approximate to 32us for quicker computation and also to account for interrupt/processing overhead.
    inline uint32_t usecs_to_jiffies(uint32_t usecs) {
	return usecs >> 5;
    }


    command error_t Init.init() { 

	if ( call SpiResourceConfig.immediateRequest()==SUCCESS) {
	    call SX1211PhySwitch.sleepMode();
	    call SpiResourceConfig.release();
	    return SUCCESS;
	} else return FAIL;
    }

    task void startDone() {
	signal SplitControl.startDone(SUCCESS);
    }

    event void SpiResourceTX.granted() {  }
    
    event void SpiResourceRX.granted() {
    	atomic {
    		if (state == RADIO_RX_PACKET_DEFERRED)
    			state = RADIO_RX_PACKET;
    		else if (state == RADIO_RX_PACKET_DEFERRED_READOUT) {
    			readPacket();
    		}
    		else if (state == RADIO_RX_PACKET_DEFERRED_OVERRUN) {
    			call SX1211PatternConf.loadDataPatternHasBus();
    			armPatternDetect(); 
    			call SpiResourceRX.release();
    			state = RADIO_LISTEN;
    			call Interrupt0.enableRisingEdge();
    			call SpiResourceRX.release();
    		}
    		else
    			call SpiResourceRX.release();
    	}
    }
    event void SpiResourceConfig.granted() { 
	armPatternDetect();
	call SpiResourceConfig.release();
	atomic {
	    if (state == RADIO_STARTING){
		post startDone();}
	    if (state == RADIO_RX_ACK) { 
		enableAck=FALSE; 
		signal SX1211PhyRxTx.sendFrameDone(0, FAIL);
	    }
	    state = RADIO_LISTEN;

	    call Interrupt0.enableRisingEdge();
	}
    }
    event void SpiResourceRssi.granted() {  }

    task void stopDone() {

	signal SplitControl.stopDone(SUCCESS);
    }

    async event void SX1211PhySwitch.rxModeEnable() {
	  switch (state) {
	  case RADIO_STARTING:
	    armPatternDetect();
	    call SpiResourceConfig.release();
	    post startDone();
	    state = RADIO_LISTEN;
	    call Interrupt0.enableRisingEdge();
	    break;

	  case RADIO_TX:
		atomic {
			if (enableAck==FALSE) {
				armPatternDetect();
				call SpiResourceTX.release();
				state = RADIO_LISTEN;
	    		call Interrupt0.enableRisingEdge();
				signal SX1211PhyRxTx.sendFrameDone(txtimestamp, SUCCESS);
			} else {
				armPatternDetect();
				call SpiResourceTX.release();
				state = RADIO_RX_ACK;
				call Alarm32khz16.start(usecs_to_jiffies(sx1211_ack_timeout));
				call Interrupt0.enableRisingEdge();
			}
		}
	  default:
	    break;
	  }
    }
   
    command error_t SplitControl.start() {
    	atomic {
    	    if (state == RADIO_LISTEN){ post startDone(); return SUCCESS;}
    	    if (state != RADIO_SLEEP) return EBUSY;	    
    	    if ( call SpiResourceConfig.immediateRequest() == SUCCESS) {
    	    	state = RADIO_STARTING;
   	    		call SX1211PhySwitch.rxMode();
    	    	return SUCCESS;
    	    } else {
    	    	return FAIL;
    	    }
    	}
    }

    command error_t SplitControl.stop() {
	atomic {
	    if (!call SX1211PhyRxTx.busy()) {
		if ( call SpiResourceConfig.immediateRequest()==SUCCESS) {
		    call SX1211PhySwitch.sleepMode();
		    call SpiResourceConfig.release();
		    state = RADIO_SLEEP;
		    call Interrupt0.disable();
		    call Interrupt1.disable();
		    post stopDone();
		    return SUCCESS;
		} else return FAIL;
	    } else return FAIL;
	}
    }

 default event void SplitControl.startDone(error_t error) { }
 default event void SplitControl.stopDone(error_t error) { }
 
 default async event void SX1211PhyRxFrame.rxFrameStarted() { }
 default async event void SX1211PhyRxFrame.rxFrameCrcFailed() { }

 async command bool SX1211PhyRxTx.busy() {

     atomic return (state != RADIO_LISTEN &&
		    state != RADIO_SLEEP);
 }

 async command bool SX1211PhyRxTx.off() {
     atomic return (state == RADIO_SLEEP ||
		    state == RADIO_STARTING);
 }


 async command void SX1211PhyRxTx.enableAck(bool onOff) {
     atomic enableAck = onOff;
 }


 void armPatternDetect() 
 {
     // small chance of a pattern arriving right after we arm, 
     // and IRQ0 hasn't been enabled yet, so we would miss the interrupt
     // xxx maybe this can also be addressed with periodic timer?
     call SX1211IrqConf.clearFifoOverrun(TRUE);  
     call SX1211IrqConf.armPatternDetector(TRUE);

 }

 async command void SX1211PhyRxTx.setRxHeaderLen(uint8_t l) 
 {
     if (l > 8) l = 8;
     if (!l) return;
     headerLen = l;
 }

 async command uint8_t SX1211PhyRxTx.getRxHeaderLen() {
     return headerLen;
 }

 async command uint8_t SX1211PhyRssi.readRxRssi() {
     return rxPktRssi;
 }


 void readRssi() {
     rxPktRssi = call SX1211RssiConf.getRssi();
 }


 async command error_t SX1211PhyRssi.getRssi(uint8_t *val) {
 
     atomic {
	 if (call SX1211PhyRxTx.off()) {
	     return EOFF;
	 }
	 
	 if(call SpiResourceRssi.immediateRequest() != SUCCESS)
	     return FAIL;
	 readRssi();

	 call SpiResourceRssi.release();
	 *val = rxPktRssi;
	 return SUCCESS;
     }
 }

 
 async command error_t SX1211PhyRxTx.sendFrame(char* data, uint8_t _frameLen, pattern_t preamble)  __attribute__ ((noinline)) 
 {
     error_t status;
     atomic {
	 if (call SX1211PhyRxTx.busy()) return EBUSY;
	 if (_frameLen < 6 || _frameLen > sx1211_mtu + 7) return EINVAL; // 7 = 4 preamble + 3 sync
      
	 status = call SpiResourceTX.immediateRequest();
	 if (status != SUCCESS) {
	     return status;
	 }
     state = RADIO_TX;
	 call Interrupt0.disable();
	 call Interrupt1.disable();
	 frameLen = _frameLen;
	 frame = data;
	 call SX1211PhySwitch.txMode();
	 if(preamble != data_pattern) // default is to send/trig on data_pattern
	     call SX1211PatternConf.loadPatternHasBus(preamble);
     }
     return status;
 }
 
 async event void SX1211PhySwitch.txModeEnable() {
   
     atomic {
    	 switch (state) {
    	 case RADIO_TX:
    		 call Interrupt0.disable(); 
    		 call Interrupt1.enableRisingEdge();
    		 txtimestamp = call Alarm32khz16.getNow() + usecs_to_jiffies(7 * call SX1211PhyConf.getByteTime_us()); // first byte is sent after sync + preamble
#ifdef DEBUGGING_PIN_RADIO_TX_SET
    		 DEBUGGING_PIN_RADIO_TX_SET;
#endif    		 
    		 call SX1211Fifo.write(frame, frameLen);
    		 break;
    	 default:
    	 }
     }
 }


 
 uint16_t rxByte=0;

 /**
  * In transmit: nTxFifoEmpty. (ie after the last byte has been *read out of the fifo*)
  * In receive: write_byte. 
  */
 async event void Interrupt0.fired() __attribute__ ((noinline)) 
 { 
     error_t status;
     atomic {
     switch (state) {

     case RADIO_RX_PACKET_DEFERRED:
     case RADIO_RX_PACKET_DEFERRED_READOUT:
    	 state = RADIO_RX_PACKET_DEFERRED_OVERRUN;
    	 // still waiting for spi, 
    	 break;
     case RADIO_RX_ACK:
    	 call Alarm32khz16.stop();
     case RADIO_LISTEN:
	 atomic {
	     call Interrupt0.disable();
	     
	     status = call SpiResourceRX.immediateRequest();
	     if(status != SUCCESS) {
	    	 if(state==RADIO_RX_ACK) {
	    		 enableAck=FALSE;
	    		 signal SX1211PhyRxTx.sendFrameDone(0, FAIL);
	    	 }
	    	 else {
				 state = RADIO_RX_PACKET_DEFERRED;
				 timestamp = call Alarm32khz16.getNow();
				 signal SX1211PhyRxFrame.rxFrameStarted();
				 call Alarm32khz16.start(2000);	 
				 call Interrupt1.enableRisingEdge();
	    		 call SpiResourceRX.request();
	    	 }
	    	 return;
		 }
	     
	     if(state==RADIO_LISTEN) {
	    	 state = RADIO_RX_PACKET;
	    	 timestamp = call Alarm32khz16.getNow();
			 signal SX1211PhyRxFrame.rxFrameStarted();
		 }
		 else {
			 //call SpiResourceRX.release();
		 }
	     readRssi();
		 call Alarm32khz16.start(2000);	 
		 call Interrupt1.enableRisingEdge();
	 }
	 return;
	 
     default:

	 return;
     }
     }
 }

 void readPacket() {
     call SX1211Fifo.read(rxFrame, headerLen); // get the length
     rxFrameLen = rxFrame[0];
	 if (rxFrameLen <= headerLen+2 || rxFrameLen > sx1211_mtu) {
		 if(state==RADIO_RX_ACK)
			 signal SX1211PhyRxTx.sendFrameDone(txtimestamp, SUCCESS);
		 call SX1211PatternConf.loadDataPatternHasBus();
		 armPatternDetect();
		 atomic {
		     state = RADIO_LISTEN;
		     call Interrupt0.enableRisingEdge();
		 }
		 call SpiResourceRX.release();
		 return; 		 
	 }
	 call SX1211Fifo.read(&rxFrame[headerLen], rxFrameLen - headerLen + 1);
	 call SX1211PatternConf.loadDataPatternHasBus();
	 armPatternDetect(); 
	 call SpiResourceRX.release();
	 state = RADIO_LISTEN;
	 call Interrupt0.enableRisingEdge();
	 if( enableAck ) {
	     enableAck = FALSE;
	     rxFrame = (uint8_t*) signal SX1211PhyRxTx.rxFrameEnd((message_t*)rxFrame, rxFrameLen , 0, SUCCESS);
	     signal SX1211PhyRxTx.sendFrameDone(txtimestamp, SUCCESS); // senddone
	 }
	 else {
		rxFrame = (uint8_t*) signal SX1211PhyRxTx.rxFrameEnd((message_t*)rxFrame, rxFrameLen , timestamp, SUCCESS);
	 }
 }


 /**
  * In transmit: TxStopped. (ie after the last byte has been *sent*)
  * In receive: Fifofull.
  */
 async event void Interrupt1.fired()  __attribute__ ((noinline)) 
 { 
     atomic {
	 switch (state) {
	 case RADIO_RX_PACKET_DEFERRED:
		 // still waiting for spi resource
		 call Alarm32khz16.stop();
		 call Interrupt1.disable(); // in case it briefly goes back to full just after we read first byte
		 state = RADIO_RX_PACKET_DEFERRED_READOUT;
		 break;
	 case RADIO_RX_ACK:
	 case RADIO_RX_PACKET:
	     call Alarm32khz16.stop();
	     call Interrupt1.disable(); // in case it briefly goes back to full just after we read first byte
	     readPacket();
	     return;
	     
	 case RADIO_TX:
#ifdef	DEBUGGING_PIN_RADIO_TX_CLR	 
		 DEBUGGING_PIN_RADIO_TX_CLR;
#endif
	     call Interrupt1.disable();
	     call SX1211PhySwitch.rxMode();
	     if (enableAck==TRUE)
	     	call SX1211PatternConf.loadAckPatternHasBus();
	     else
	    	call SX1211PatternConf.loadDataPatternHasBus(); 
	     return;

	 default:
	     return;
	 }
     }
 }

 async event void Alarm32khz16.fired() {

     switch(state) {

     case RADIO_STARTING:
	 call SpiResourceConfig.request();	
	 return;
	 
     case RADIO_LISTEN:
     case RADIO_RX_PACKET:
     case RADIO_RX_PACKET_DEFERRED:
	 signal SX1211PhyRxFrame.rxFrameCrcFailed();
	 signal SX1211PhyRxTx.rxFrameEnd(NULL, 0, 0, FAIL);
	 call SX1211PatternConf.loadDataPatternHasBus();
	 armPatternDetect(); 
	 call SpiResourceRX.release();
	 atomic {
	     state = RADIO_LISTEN;
	     call Interrupt0.enableRisingEdge();
	 }	 
	 return;

     case RADIO_RX_ACK: // ack timeout or crc failed
    	atomic {
    		call SpiResourceRX.immediateRequest(); // EBUSY -> crc failed
    		signal SX1211PhyRxTx.sendFrameDone(txtimestamp, SUCCESS);
    		enableAck = FALSE;
    		call SX1211PatternConf.loadDataPatternHasBus();
    		armPatternDetect();
    		call SpiResourceRX.release();
    		state = RADIO_LISTEN;
    		call Interrupt0.enableRisingEdge();
    	}
     return;

     default:
	 return;
     }

 }
 
 default async event void SX1211PhyRxTx.sendFrameDone(uint16_t _timestamp, error_t err) {}; 
 default async event message_t * SX1211PhyRxTx.rxFrameEnd(message_t* data, uint8_t len, uint16_t _timestamp, error_t status) {return data;}
}



