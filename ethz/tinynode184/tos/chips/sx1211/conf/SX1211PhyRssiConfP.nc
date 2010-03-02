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
 * Implementation of SX1211PhyConf and SX1211RssiConf interfaces.
 * These are implemented jointly because the rssi measure period depends 
 * on the frequency deviation (which itself depends on bitrate).
 *
 * @author Henri Dubois-Ferriere
 */
#include "SX1211.h"

module SX1211PhyRssiConfP {

    provides interface SX1211PhyConf;
    provides interface SX1211RssiConf;
    provides interface SX1211PhySwitch;

    provides interface Init @atleastonce();
    
    provides interface Get<uint32_t> as GetTxTime;
    provides interface Get<uint32_t> as GetRxTime;

    uses interface Resource as SpiResource;
    uses interface SX1211Register as MCParam;
    uses interface SX1211Register as IRQParam;
    uses interface SX1211Register as RXParam;
    uses interface SX1211Register as TXParam;
    uses interface SX1211Register as SYNCParam;
    uses interface SX1211Register as PCKTParam;

    uses interface GeneralIO as DataPin; // only used in continuous mode, not currently supported
    uses interface GeneralIO as Irq0Pin;
    uses interface GeneralIO as Irq1Pin;
    uses interface GeneralIO as PllLockPin;

    uses interface GpioInterrupt as PllInterrupt;
    uses interface Alarm<T32khz,uint16_t> as SwitchTimer;
    uses interface LocalTime<T32khz> as LocalTime;

}
implementation {
#include "sx1211debug.h"

	/* 
     * Default settings for initial parameters. 
     */ 
#ifndef SX1211_CHANNEL_DEFAULT
#define SX1211_CHANNEL_DEFAULT  freq_867_825
#endif	
	
#ifndef SX1211_BITRATE_DEFAULT
#define SX1211_BITRATE_DEFAULT  100000
#endif
    //xxx/make this computed as a fun of SX1211_BITRATE_DEFAULT
#ifndef SX1211_FREQDEV_DEFAULT
#define SX1211_FREQDEV_DEFAULT  133000
#endif

    /*
     * Register calculation helper macros.
     */
#define SX1211_FREQ(value_)                     (((value_) * 100) / 50113L)
#define SX1211_EFFECTIVE_FREQ(value_)           (((int32_t)((int16_t)(value_)) * 50113L) / 100)
#define SX1211_FREQ_DEV_HI(value_)              ((SX1211_FREQ(value_) >> 8) & 0x01)
#define SX1211_FREQ_DEV_LO(value_)              (SX1211_FREQ(value_) & 0xff)
#define SX1211_FREQ_HI(value_)                  ((SX1211_FREQ(value_) >> 8) & 0xff)
#define SX1211_FREQ_LO(value_)                  (SX1211_FREQ(value_) & 0xff)
#define SX1211_BIT_RATE(value_)                 ((128000L / (value_) - 1) & 0x7f)
#define SX1211_EFFECTIVE_BIT_RATE(value_)       (128000L / ((value_) + 1))


    /**
     * Frequency bands.
     */
    enum sx1211_freq_bands {
	SX1211_Band_869 = 869000000,
	SX1211_Band_915 = 915000000
    };
  
    /*
     * var for dutyCycle
     */
    uint32_t rxTime = 0;
    uint32_t txTime = 0;
    uint32_t iTime = 0;

    uint16_t sTime;

    // time to xmit/receive a byte at current bitrate 
    uint16_t byte_time_us;

    // norace is ok because protected by the isOwner() calls
    norace uint8_t mcParam0 = 0;
    // returns appropriate baseband filter in khz bw for given bitrate in bits/sec.
    uint16_t baseband_bw_from_bitrate(uint32_t bitrate) {
	return (bitrate * 400) /152340;
    }


    // returns appropriate freq. deviation for given bitrate in bits/sec.
    uint32_t freq_dev_from_bitrate(uint32_t bitrate) {
	return (bitrate * 6) / 5;
    }

    // returns sx1211 encoding of baseband bandwidth in appropriate bit positions
    // for writing into rxparam7 register
    uint8_t baseband_bw_rxparam7_bits(uint16_t bbw_khz) 
    {
	if(bbw_khz <= 10) {
	    return 0x00;
	} else if(bbw_khz <= 20) {
	    return 0x20;
	} else if(bbw_khz <= 40) {
	    return 0x40;
	} else if(bbw_khz <= 200) {
	    return 0x60;
	} else if(bbw_khz <= 400) {
	    return 0x10;
	} else return 0x10; 
    }

    task void initTask() {
	atomic {
	    byte_time_us = 8000000 / SX1211_BITRATE_DEFAULT;
	    
	    sx1211check(1, call SpiResource.immediateRequest()); // should always succeed: task happens after softwareInit, before interrupts are enabled
	
// 100 kbit/s
	    call TXParam.write(REG_TXPARAM, TX_FC_400 | TX_POWER_13DB);
	    call MCParam.write(REG_FDEV, RF_FDEV_200);
	    call MCParam.write(REG_BITRATE,RF_BITRATE_100000);
	    call RXParam.write(REG_RXPARAM1, RX1_PASSIVEFILT_987 | RX1_FC_FOPLUS400);

// 25 kbit/s
/*	    call TXParam.write(REG_TXPARAM, TX_FC_200 | TX_POWER_13DB);
	    call MCParam.write(REG_FDEV, RF_FDEV_50);
	    call MCParam.write(REG_BITRATE,RF_BITRATE_25000);
	    call RXParam.write(REG_RXPARAM1, RX1_PASSIVEFILT_378 | RX1_FC_FOPLUS100);
*/
	    // frequency
	    mcParam0 = MC1_SLEEP | MC1_BAND_868;//MC1_BAND_915H;
	    call MCParam.write(REG_MCPARAM1,  mcParam0 );

	    call MCParam.write(REG_MCPARAM2,
			       MC2_MODULATION_FSK | 
			       MC2_DATA_MODE_PACKET |
			       MC2_GAIN_IF_00);
	    
	    //FIFO
	    call MCParam.write(REG_MCPARAM6,
			       MC6_FIFO_SIZE_64 );

	    // frequency select
	    call MCParam.write(REG_R1,
	    		rpsPllTable[3*SX1211_CHANNEL_DEFAULT]);
	    call MCParam.write(REG_P1,
	    		rpsPllTable[3*SX1211_CHANNEL_DEFAULT + 1]);
	    call MCParam.write(REG_S1,
	    		rpsPllTable[3*SX1211_CHANNEL_DEFAULT + 2]);
	    call PCKTParam.write(REG_PKTPARAM1,
				 PKT1_MANCHESTER_OFF | 64);
	    call PCKTParam.write(REG_PKTPARAM3,
				 PKT3_FORMAT_VARIABLE |
				 PKT3_PREAMBLE_SIZE_24 |
				 PKT3_WHITENING_ON |
				 PKT3_CRC_ON);

	    call SpiResource.release();
	}
    }

    command error_t Init.init() 
    {
    	post initTask();
    	return SUCCESS;
    }
    
    event void SpiResource.granted() {   }

    command error_t SX1211PhyConf.setFreq(sx1211_freq_t freq, sx1211_regFreq_t reg) {
    	if (call SpiResource.isOwner()) return EBUSY;
    	if(call SpiResource.immediateRequest()!=SUCCESS) return FAIL;
    	if (reg == reg1) {
    		call MCParam.write(REG_R1, rpsPllTable[3*freq]);
    		call MCParam.write(REG_P1, rpsPllTable[3*freq+1]);
    		call MCParam.write(REG_S1, rpsPllTable[3*freq+2]);
    	} else {
    		call MCParam.write(REG_R2, rpsPllTable[3*freq] );
    		call MCParam.write(REG_P2, rpsPllTable[3*freq+1] );
    		call MCParam.write(REG_S2, rpsPllTable[3*freq+2] );
    	}
    	call SpiResource.release();
    	return SUCCESS;
    }
    
    /**
      * Set the output power of the SX1211.
      *
      * @param pow valid values from 0 (lowest, ~-8dBm) to 7 (highest, 13dBm)
      * @return SUCCESS if configuration done ok, error status otherwise.
      */
    async command error_t SX1211PhyConf.setRFPower(uint8_t _txpow) {
    	error_t status;
        uint8_t txPow;
    	if (_txpow > TX_POWER_MIN8DB)
    		return EINVAL;
    	_txpow=(~_txpow) & 0xf8;
    	if (call SpiResource.isOwner()) return EBUSY;
    	status = call SpiResource.immediateRequest();
    	if (status != SUCCESS) return status;

    	call TXParam.read(REG_TXPARAM, &txPow);
    	txPow &= ~( 0x07 <<1 );
    	txPow |= _txpow<<1;
    	call TXParam.write(REG_TXPARAM, txPow);

    	call SpiResource.release();
    	return SUCCESS;
    }

    command error_t SX1211PhyConf.setBitrate(sx1211_bitrate_t bitrate) 
    {
    	/*
    	uint16_t bbw;
    	uint32_t freqdev;
    	uint8_t rxp8reg, mcp0reg, mcp1reg, mcp2reg;
    	error_t status;

    	if (bitrate < sx1211_bitrate_38085 || bitrate > sx1211_bitrate_152340) return EINVAL;

    	if (call SpiResource.isOwner()) return EBUSY;
    	status = call SpiResource.immediateRequest();
    	sx1211check(4, status);
    	if (status != SUCCESS) return status;

    	// receiver bandwidth
    	bbw = baseband_bw_from_bitrate(bitrate);
    	rxp8reg &= ~0x70;
    	rxp8reg |= baseband_bw_rxparam7_bits(bbw);

    	// frequency deviation
    	freqdev = freq_dev_from_bitrate(bitrate);

    	mcp0reg &= ~0x01;
    	mcp0reg |= SX1211_FREQ_DEV_HI(freqdev);

    	mcp1reg = SX1211_FREQ_DEV_LO(freqdev);
    	
    	mcp2reg = SX1211_BIT_RATE(bitrate);
    	atomic byte_time_us =   8000000 / bitrate;
    	call SpiResource.release();
    	*/ 
    	return SUCCESS;
    }

    async command uint16_t SX1211PhyConf.getByteTime_us() { 
    	return byte_time_us;
    }

    async command uint8_t SX1211RssiConf.getRssi() 
    {
    	// must have bus
    	uint8_t res;
    	call RXParam.read(REG_RSSIVALUE, &res);
    	return res;
    }

    
    /*
     * SX1211PhySwitch must have the spi beforehand
     */

    norace uint8_t cState; // current transceiver state
    norace uint8_t lState; // last state; used in SwitchTimer.fired() case MC1_SYNTHESIZER to branch correctly


    void startSwitchTimer() {
	atomic {
	    call SwitchTimer.start(sTime);
	}
    }

    async command void SX1211PhySwitch.sleepMode() {
	uint32_t tmpTime;
	tmpTime = call LocalTime.get();
	if((mcParam0 & 0xE0) == MC1_TRANSMITTER) {	  
		txTime+=(tmpTime - iTime);
	} 
	if((mcParam0 & 0xE0) == MC1_RECEIVER) {
		rxTime+=(tmpTime - iTime);
	}
	mcParam0 &= 0x1F;
	mcParam0 |= MC1_SLEEP;
	call MCParam.write(REG_MCPARAM1, mcParam0 );
	call Irq0Pin.makeOutput();
	call Irq1Pin.makeOutput();
	call DataPin.makeOutput();
	call PllLockPin.makeOutput();
#ifdef DEBUGGING_PIN_RADIO_OFF	 
	    DEBUGGING_PIN_RADIO_OFF;
#endif  	
	lState = MC1_SLEEP;
    }
    
    async command void SX1211PhySwitch.standbyMode() {
	call Irq0Pin.makeOutput();
	call Irq1Pin.makeOutput();
	call DataPin.makeOutput();
	call PllLockPin.makeOutput();
	mcParam0 &= 0x1F;
	mcParam0 |= MC1_STANDBY;
    }
    
    async command void SX1211PhySwitch.rxMode() {
	
	uint32_t tmpTime;
	call Irq0Pin.makeInput();
	call Irq1Pin.makeInput();
	call DataPin.makeInput();
	call PllLockPin.makeInput();

    tmpTime = call LocalTime.get();

	if((mcParam0 & 0xE0) == MC1_TRANSMITTER) {
		txTime+=(tmpTime - iTime);
	}
	
	if((mcParam0 & 0xE0) == MC1_RECEIVER) {
		rxTime+=(tmpTime - iTime);
	}

	lState = MC1_RECEIVER;
	cState = (mcParam0 & 0xE0);
	
	switch (cState) {
	case MC1_SLEEP:
	    mcParam0 &= 0x1F;
	    mcParam0 |= MC1_STANDBY;
	    call MCParam.write(REG_MCPARAM1, mcParam0);
	    sTime = TS_OS;
	    break;

	case MC1_STANDBY:
	    mcParam0 &= 0x1F;
	    mcParam0 |= MC1_SYNTHESIZER;
	    call MCParam.write(REG_MCPARAM1, mcParam0);
	    sTime = TS_FS;
	    break;

	case MC1_SYNTHESIZER:
	    mcParam0 &= 0x1F;
	    mcParam0 |= MC1_RECEIVER;
	    
	    call MCParam.write(REG_MCPARAM1, mcParam0);
	    sTime = TS_TR;
	    break;

	case MC1_RECEIVER:
	    mcParam0 &= 0x1F;
	    mcParam0 |= MC1_RECEIVER;
	    iTime = call LocalTime.get();
#ifdef DEBUGGING_PIN_RADIO_ON	 
	    DEBUGGING_PIN_RADIO_ON;
#endif  	    
	    signal SX1211PhySwitch.rxModeEnable();
	    return;
	    call MCParam.write(REG_MCPARAM1, mcParam0);
	    sTime = TS_TR;
	    break;
	    
	case MC1_TRANSMITTER:
	    mcParam0 &= 0x1F;
	    mcParam0 |= MC1_RECEIVER;
	    call MCParam.write(REG_MCPARAM1, mcParam0);
	    sTime = TS_TR;
	    break;
	    
	}
	startSwitchTimer();
    }
    
    async command void SX1211PhySwitch.txMode() {

	uint32_t tmpTime;
	call Irq0Pin.makeInput();
	call Irq1Pin.makeInput();
	call DataPin.makeOutput();
	call PllLockPin.makeInput();
	
	if((mcParam0 & 0xE0) == MC1_RECEIVER) {
	    tmpTime = call LocalTime.get();
		rxTime+=(tmpTime - iTime);
	}

	lState = MC1_TRANSMITTER;
	cState = mcParam0 & 0xE0;
	switch (cState) {
	case MC1_SLEEP:
	    mcParam0 &= 0x1F;
	    mcParam0 |= MC1_STANDBY;
	    call MCParam.write(REG_MCPARAM1, mcParam0);
	    atomic sTime = TS_OS;
	    break;

	case MC1_STANDBY:
	    mcParam0 &= 0x1F;
	    mcParam0 |= MC1_SYNTHESIZER;
	    call MCParam.write(REG_MCPARAM1, mcParam0);
	    atomic sTime = TS_FS;
	    break;

	case MC1_SYNTHESIZER:
	    mcParam0 &= 0x1F;
	    mcParam0 |= MC1_TRANSMITTER;
	    call MCParam.write(REG_MCPARAM1, mcParam0);
	    atomic sTime = TS_TR;
	    break;

	case MC1_RECEIVER:
	    mcParam0 &= 0x1F;
	    mcParam0 |= MC1_TRANSMITTER;
	    call MCParam.write(REG_MCPARAM1, mcParam0);
	    atomic sTime = TS_RE;
	    break;

	case MC1_TRANSMITTER:
	    call PllInterrupt.disable();
	    iTime = call LocalTime.get();
#ifdef DEBUGGING_PIN_RADIO_ON	 
	    DEBUGGING_PIN_RADIO_ON;
#endif  	    
	    signal SX1211PhySwitch.txModeEnable();
	    return;
	    mcParam0 &= 0x1F;
	    mcParam0 |= MC1_TRANSMITTER;
	    call MCParam.write(REG_MCPARAM1, mcParam0);
	    atomic sTime = TS_TR;
	    break;
	}
	startSwitchTimer();
    }

    async event void SwitchTimer.fired() {

       cState = mcParam0 & 0xE0;
      
	switch (cState) {
	case MC1_SLEEP:
	    mcParam0 &= 0x1F;
	    mcParam0 |= MC1_STANDBY;
	    call MCParam.write(REG_MCPARAM1, mcParam0);
	    atomic sTime = TS_OS;
	    break;

	case MC1_STANDBY:
	    mcParam0 &= 0x1F;
	    mcParam0 |= MC1_SYNTHESIZER;
	    call MCParam.write(REG_MCPARAM1, mcParam0);
	    call PllInterrupt.enableRisingEdge();
	    atomic sTime = TS_FS;
	    break;

	case MC1_SYNTHESIZER:
	    mcParam0 &= 0x1F;
	    call PllInterrupt.disable();
	    if (lState == MC1_RECEIVER) {
		mcParam0 |= MC1_RECEIVER;
		call MCParam.write(REG_MCPARAM1, mcParam0);
		atomic sTime = TS_RE;
		break;
	    }

	    if (lState == MC1_TRANSMITTER) {
		mcParam0 |= MC1_TRANSMITTER;
		call MCParam.write(REG_MCPARAM1, mcParam0);
		atomic sTime = TS_TR;
	    }
	    break;

	case MC1_RECEIVER:
	    call PllInterrupt.disable();
	    iTime = call LocalTime.get();
#ifdef DEBUGGING_PIN_RADIO_ON	 
	    DEBUGGING_PIN_RADIO_ON;
#endif  	    
	    signal SX1211PhySwitch.rxModeEnable();
	    return;

	    
	case MC1_TRANSMITTER:
	    iTime = call LocalTime.get();
	    call PllInterrupt.disable();
#ifdef DEBUGGING_PIN_RADIO_ON	 
	    DEBUGGING_PIN_RADIO_ON;
#endif    	
	    signal SX1211PhySwitch.txModeEnable();
	    return;
	}
	startSwitchTimer();
    }

   command uint32_t GetTxTime.get() {
	   uint32_t tmp, tmpTime;
	   atomic {
		   if((mcParam0 & 0xE0) == MC1_TRANSMITTER) {
			   tmpTime = call LocalTime.get();
			   txTime+=(tmpTime - iTime);
			   iTime = tmpTime;
		   }
		   tmp = txTime;
		   txTime = 0;
	   }
	   return tmp;
   }
   
   command uint32_t GetRxTime.get() {
	   uint32_t tmp, tmpTime;
	   atomic {
		   if((mcParam0 & 0xE0) == MC1_RECEIVER) {
			   tmpTime = call LocalTime.get();
			   rxTime+=(tmpTime - iTime);
			   iTime = tmpTime;
		   }
		   tmp = rxTime;
		   rxTime = 0;
	   }
	   return tmp;
   }
   
   async command uint32_t SX1211PhySwitch.getDutyCycle(bool _Mode) {
       atomic {
       if(_Mode == FALSE)
	   return rxTime;
       else
	   return txTime;
       }
   }

   async event void PllInterrupt.fired() {
       call PllInterrupt.disable();
       if (call SwitchTimer.isRunning())
	   call SwitchTimer.stop();
       signal SwitchTimer.fired();
   }
       
}
