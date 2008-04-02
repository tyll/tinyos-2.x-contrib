/* 
 * Copyright (c) 2008, University of Twente (UTWENTE), the Netherlands.
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
 * - Neither the name of the University of Twente (UTWENTE)
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
 * @author Leon Evers
 *
 */

#include "Timer.h"

module nRF905PhyP {
    provides interface nRF905PhyRxTx;
    provides interface nRF905PhyRssi;

    provides interface Init @atleastonce();
    provides interface SplitControl @atleastonce();

    uses interface Resource as SpiResourceTX;
    uses interface Resource as SpiResourceRX;
    uses interface Resource as SpiResourceConfig;
    uses interface Resource as SpiResourceRssi;

    uses interface nRF905PhySwitch;
    uses interface nRF905IrqConf;
    uses interface nRF905Fifo;
    uses interface nRF905RssiConf;
    uses interface nRF905PatternConf;

    uses interface GpioInterrupt as Interrupt0;
    uses interface GpioInterrupt as Interrupt1;

    uses interface Alarm<T32khz,uint16_t> as Alarm32khz16;
#if 0
    uses interface GeneralIO as Dpin;
#endif
}
implementation {

#include "nrf905debug.h"

    char* txBuf = NULL;
    uint8_t rxFrameIndex = 0;
    uint8_t rxFrameLen = 0;
    uint8_t nextTxLen=0;
    uint8_t nextRxLen;
    char rxFrame[nrf905_mtu];
    uint8_t headerLen = 4;

    uint16_t stats_rxOverruns;

    enum {
	RSSI_RANGE_LOW=1,
	RSSI_RANGE_HIGH=2,
	RSSI_OFF=0,
    };
    uint8_t rssiRange = RSSI_OFF;
    norace uint8_t rssiL,rssiH;
    uint8_t * rLow = &rssiL;
    uint8_t * rHigh = &rssiH;


    bool enableAck = FALSE;

    typedef enum { // remember to update busy() and off(), start(), stop() if states are added
	RADIO_LISTEN=0, 
	RADIO_RX_HEADER=1, 
	RADIO_RX_PACKET=2, 
	RADIO_RX_PACKET_LAST=3, 
	RADIO_TX=4,
	RADIO_SLEEP=5, 
	RADIO_STARTING=6,
	RADIO_RSSI=7,
	RADIO_RX_ACK=8,
	RADIO_TX_ACK=9
    } phy_state_t;

    phy_state_t state = RADIO_SLEEP;


    void armPatternDetect();

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

    command error_t Init.init() 
    { 
#if 0
	call Dpin.makeOutput();
#endif
	call nRF905PhySwitch.sleepMode();
	call nRF905PhySwitch.antennaOff();
	return SUCCESS;
    }

    task void startDone() {	
	signal SplitControl.startDone(SUCCESS);
    }

    event void SpiResourceTX.granted() {  }
    event void SpiResourceRX.granted() {  }
    event void SpiResourceConfig.granted() { 
	armPatternDetect();
	call SpiResourceConfig.release();
	atomic {
	    if (state == RADIO_STARTING){
		post startDone();}
	    if (state == RADIO_RX_ACK) { 
		enableAck=FALSE; 
		signal nRF905PhyRxTx.sendFrameDone(FAIL);
	    }
	    state = RADIO_LISTEN;

	    call Interrupt0.enableRisingEdge();
	}
    }
    event void SpiResourceRssi.granted() {  }

    task void stopDone() {
	signal SplitControl.stopDone(SUCCESS);
    }

    command error_t SplitControl.start() 
    {

	    atomic {
		if (state == RADIO_LISTEN){ post startDone(); return SUCCESS;}
		if (state != RADIO_SLEEP) return EBUSY;
		state = RADIO_STARTING;
	    }
	    call nRF905PhySwitch.rxMode();
	    call nRF905PhySwitch.antennaRx();
	    
	    
	    call Alarm32khz16.start(usecs_to_jiffies(nRF905_Sleep_to_RX_Time));
	    return SUCCESS;
    }

    command error_t SplitControl.stop() 
    {
	atomic {
	    if (!call nRF905PhyRxTx.busy()) {
		
		call nRF905PhySwitch.sleepMode();
		call nRF905PhySwitch.antennaOff();
		state = RADIO_SLEEP;
		call Interrupt0.disable();
		call Interrupt1.disable();
		post stopDone();
		return SUCCESS;
	    } else return FAIL;
	}

    }

 default event void SplitControl.startDone(error_t error) { }
 default event void SplitControl.stopDone(error_t error) { }
 default async event void nRF905PhyRssi.rssiDone(uint8_t _rssi) { }

 async command bool nRF905PhyRxTx.busy() {
     atomic return (state != RADIO_LISTEN &&
		    state != RADIO_SLEEP);
 }

 async command bool nRF905PhyRxTx.off() {
     atomic return (state == RADIO_SLEEP ||
		    state == RADIO_STARTING);
 }


 async command void nRF905PhyRxTx.enableAck(bool onOff) {
     atomic enableAck = onOff;
 }


 void armPatternDetect() 
 {
     // small chance of a pattern arriving right after we arm, 
     // and IRQ0 hasn't been enabled yet, so we would miss the interrupt
     // xxx maybe this can also be addressed with periodic timer?
     call nRF905IrqConf.armPatternDetector(TRUE);
     call nRF905IrqConf.clearFifoOverrun(TRUE);  
 }

 async command void nRF905PhyRxTx.setRxHeaderLen(uint8_t l) 
 {
     if (l > 8) l = 8;
     if (!l) return;
     headerLen = l;
 }

 async command uint8_t nRF905PhyRxTx.getRxHeaderLen() {
     return headerLen;
 }

 void computeNextRxLength() 
 {
     uint8_t n = rxFrameLen - rxFrameIndex; 
    
     // for timesync and such, we want the end of the packet to coincide with a fifofull event, 
     // so that we know precisely when last byte was received 

     if (n > 16) {
	 if (n < 32) nextRxLen = n - 15; else nextRxLen = 15;
     } 
     else {
	 nextRxLen = n;
     }
 }

 command uint8_t  nRF905PhyRssi.readRxRssi() {
     return rssiTab[(rssiH<<2) |rssiL];
 }

 task void rssiDone() {

     signal nRF905PhyRssi.rssiDone( rssiTab[(rssiH<<2) |rssiL]);
 }

 void readRssi() {
     if(rssiRange ==RSSI_RANGE_LOW ) {
	 rssiRange = RSSI_RANGE_HIGH;
	 call nRF905RssiConf.getRssi(rLow);
	 call nRF905RssiConf.setRssiRange(TRUE);
	 call Alarm32khz16.start(usecs_to_jiffies(call nRF905RssiConf.getRssiMeasurePeriod_us()));
     } else {
	 call nRF905RssiConf.getRssi(rHigh);
	 call nRF905RssiConf.setRssiMode(FALSE);

	 if(state == RADIO_RSSI) {
	     armPatternDetect();
	     call SpiResourceRssi.release();
	     call Interrupt0.enableRisingEdge();
	     atomic state = RADIO_LISTEN;
	     signal nRF905PhyRssi.rssiDone( rssiTab[(rssiH<<2) |rssiL]);
	 } else { // go on with rx of packet
	     call Alarm32khz16.start(3000);
	 }
	 rssiRange = RSSI_OFF;
     }
 }


 error_t getRssi() {
     error_t err;

     err = call nRF905RssiConf.setRssiMode(TRUE);
     err = ecombine(err,call nRF905RssiConf.setRssiRange(FALSE));
     rssiRange=RSSI_RANGE_LOW;
     call Alarm32khz16.start(usecs_to_jiffies(call nRF905RssiConf.getRssiMeasurePeriod_us()));
     return err;
 }


 async command error_t nRF905PhyRssi.getRssi() {
 
     error_t err;
     atomic {
	 if (state != RADIO_LISTEN&&rssiRange==RSSI_OFF) return EBUSY;
	 if (call nRF905PhyRxTx.off()) {
	     return EOFF;
	 }
	 
	 if(call SpiResourceRssi.immediateRequest() != SUCCESS) {
	     return FAIL;
	 }

	 err=getRssi();
	 if (SUCCESS ==err) {
	     state = RADIO_RSSI;
	 }
	 return err;
     }
 }

 async command error_t nRF905PhyRxTx.sendFrame(char* data, uint8_t frameLen)  __attribute__ ((noinline)) 
 {
     error_t status;
   
     if (frameLen < 6) return EINVAL;

     atomic {
	 if (state == RADIO_SLEEP) return EOFF;

	 if (call nRF905PhyRxTx.busy()) return EBUSY;
	 if (frameLen == 0 || frameLen > nrf905_mtu + 7) return EINVAL; // 7 = 4 preamble + 3 sync
      
	 call nRF905PhySwitch.txMode(); // it takes 100us to switch from rx to tx, ie less than one byte at 76kbps
	 call Interrupt0.disable();

	 status = call SpiResourceTX.immediateRequest();
	 nrf905check(3, status);
	 if (status != SUCCESS) {
	     call nRF905PhySwitch.rxMode(); 
	     call SpiResourceConfig.request();
	     return status;
	 }
	 call nRF905PhySwitch.antennaTx();
	 state = RADIO_TX;
	 
     }


     call nRF905Fifo.write(data, frameLen);
     atomic {
	
	 txBuf = signal nRF905PhyRxTx.continueSend(&nextTxLen);
     }
     if (nextTxLen) {
	 call Interrupt0.enableFallingEdge();
     } else {
	 call Interrupt0.disable();
	 call Interrupt1.enableRisingEdge();
     }
     // cannot happen with current SPI implementation (at least with NoDma)
#if 0
     if (status != SUCCESS) {
	 nrf905error(8, status);
	 call nRF905PhySwitch.rxMode(); 
	 call nRF905PhySwitch.antennaRx();
	 call nRF905PatternConf.loadDataPatternHasBus();
	 armPatternDetect();
	 call SpiResourceTX.release();
	 atomic {
	     call Interrupt0.enableRisingEdge();
	     state = RADIO_LISTEN;
	 }
	 return status;
     }
#endif

     return SUCCESS;
 }



 uint16_t rxByte=0;

 /**
  * In transmit: nTxFifoEmpty. (ie after the last byte has been *read out of the fifo*)
  * In receive: write_byte. 
  */
 async event void Interrupt0.fired() __attribute__ ((noinline)) 
 { 
     error_t status;
    
     switch (state) {

     case RADIO_RX_ACK:
	 
	 call Alarm32khz16.stop();
     case RADIO_LISTEN:
	 rxByte=1;
	 atomic state = RADIO_RX_HEADER;
	 status = call SpiResourceRX.immediateRequest();
	 atomic {
	 if (status != SUCCESS) {
	     state = RADIO_LISTEN;
	     call Interrupt0.disable(); // because pattern detector won't be rearmed right away
	     call SpiResourceConfig.request();
	     return;
	 }
	 }
	 call Alarm32khz16.start(3000);
	 return;

     case RADIO_RX_HEADER:
	 rxByte++;
	 if (rxByte == 2) {
	     call Alarm32khz16.start(3000);
	 }
	 if (rxByte == headerLen + 1) {
	     call Interrupt0.disable();
	     call nRF905Fifo.read(rxFrame, headerLen);
	     call Interrupt1.enableRisingEdge();
	 }

	 return;

     case RADIO_TX:
	 call Interrupt0.disable(); // avoid spurious IRQ0s from nTxFifoEmpty rebounding briefly after first byte is written.
	 // note that we should really wait till writedone() to re-enable either interrupt.
	 call nRF905Fifo.write(txBuf, nextTxLen);
	 txBuf = signal nRF905PhyRxTx.continueSend(&nextTxLen);
	 if (nextTxLen) {
	     call Interrupt0.enableFallingEdge();
	 } else {
	     call Interrupt0.disable();
	     call Interrupt1.enableRisingEdge();
	 }
	 return;

     case RADIO_RSSI: // trigged while getting rssi
	 call Interrupt0.disable(); // because pattern detector won't be rearmed right away
	 return;

     default:
	 
	 return;
     }
 }



 /**
  * In transmit: TxStopped. (ie after the last byte has been *sent*)
  * In receive: Fifofull.
  */
 async event void Interrupt1.fired()  __attribute__ ((noinline)) 
 { 

     switch (state) {

     case RADIO_RX_PACKET:
	 call Interrupt1.disable(); // in case it briefly goes back to full just after we read first byte
	 call nRF905Fifo.read(&rxFrame[rxFrameIndex], nextRxLen);

	 rxFrameIndex += nextRxLen;
	 computeNextRxLength();
	 if (nextRxLen==0) {
	     state = RADIO_RX_PACKET_LAST;
	 }
	 return;

     case RADIO_RX_HEADER: // somehow the FIFO has filled before we finished reading the header bytes

	 call Interrupt1.disable();
	 call Alarm32khz16.stop();

	 signal nRF905PhyRxTx.rxFrameEnd(NULL, 0, FAIL);
	 call nRF905PatternConf.loadDataPatternHasBus();
	 armPatternDetect();
	 call SpiResourceRX.release();
	 atomic {	     
	     call Interrupt0.enableRisingEdge();
	     state = RADIO_LISTEN;
	 }
	 return;

     case RADIO_TX:

	 call Interrupt1.disable();
	 call nRF905PhySwitch.rxMode(); 
	 call nRF905PhySwitch.antennaRx();
	 if (enableAck==FALSE) {
	     call nRF905PatternConf.loadDataPatternHasBus();
	     armPatternDetect();
	     signal nRF905PhyRxTx.sendFrameDone(SUCCESS);
	     call SpiResourceTX.release();
	     atomic {
		 call Interrupt0.enableRisingEdge();
		 state = RADIO_LISTEN;
	     }
	 } else {

	     call nRF905PatternConf.loadAckPatternHasBus();
	     armPatternDetect();
	     call SpiResourceTX.release();
	     
	     call Alarm32khz16.start(usecs_to_jiffies(8000));
	     atomic {
		 call Interrupt0.enableRisingEdge();
		 state = RADIO_RX_ACK;
	     }
	 }

	 return;

     default:
	 return;
     }
 }



 async event void nRF905Fifo.readDone(error_t error) {

     switch(state) {
     case RADIO_RX_HEADER:
	 rxFrameLen = signal nRF905PhyRxTx.rxFrameBegin(rxFrame, headerLen);
	 if (rxFrameLen <= headerLen) {
	     call Interrupt1.disable();
	     call Alarm32khz16.stop();

	     signal nRF905PhyRxTx.rxFrameEnd(NULL, 0, FAIL);
	     call nRF905PatternConf.loadDataPatternHasBus();
	     armPatternDetect();
	     call SpiResourceRX.release();
	     atomic {
		 state = RADIO_LISTEN;
		 call Interrupt0.enableRisingEdge();
	     }
	     return;
	 }
	 atomic {
	     if(rssiRange==RSSI_OFF) {
		 getRssi();
	     }
	 }
	 rxFrameIndex = headerLen;
	 computeNextRxLength();
	 state = RADIO_RX_PACKET;

	 return;

     case RADIO_RX_PACKET_LAST:
	 call Alarm32khz16.stop();

	 atomic {
	     call nRF905PatternConf.loadDataPatternHasBus();
	     armPatternDetect(); 
	     state = RADIO_LISTEN;
	     call Interrupt0.enableRisingEdge();
	     call SpiResourceRX.release();
	 }
	 if( enableAck == FALSE) {
	     signal nRF905PhyRxTx.rxFrameEnd(rxFrame, rxFrameLen + headerLen, SUCCESS); 

	 } else {
	     enableAck = FALSE;
	     signal nRF905PhyRxTx.sendFrameDone(SUCCESS);
	 }

	 



	 return;

     case RADIO_RX_PACKET:

	 call Interrupt1.enableRisingEdge();
	 return;

     default:
	 nrf905check(10, FAIL);
	 return;
     }
 }

 async event void nRF905Fifo.writeDone(error_t error)  __attribute__ ((noinline)) { 

 }
   

 async event void Alarm32khz16.fired() {

     switch(state) {

     case RADIO_STARTING:
	 call SpiResourceConfig.request();	
	 return;

     case RADIO_LISTEN:
     case RADIO_RX_HEADER:
     case RADIO_RX_PACKET:
	 if (rssiRange!=RSSI_OFF) {
		 readRssi();
		 return;
	     }
	 stats_rxOverruns++;

	 signal nRF905PhyRxTx.rxFrameEnd(NULL, 0, FAIL);
	 call nRF905PatternConf.loadDataPatternHasBus();
	 armPatternDetect(); 
	 call SpiResourceRX.release();

	 atomic {
	     state = RADIO_LISTEN;
	     call Interrupt0.enableRisingEdge();
	 }

	 return;

     case RADIO_RSSI:
	     readRssi();
	 return;

     case RADIO_RX_ACK: // ack timeout

	 enableAck = FALSE;
	 call SpiResourceRX.immediateRequest();
	     
	 signal nRF905PhyRxTx.rxFrameEnd(NULL, 0, FAIL);
	
	 call nRF905PatternConf.loadDataPatternHasBus();

	 armPatternDetect();

	 call SpiResourceRX.release();
	 
	 atomic {
	     state = RADIO_LISTEN;
	     call Interrupt0.enableRisingEdge();

	 }

	 signal nRF905PhyRxTx.sendFrameDone(FAIL);
	 return;
     default:
   

	 return;
     }

 }


}



