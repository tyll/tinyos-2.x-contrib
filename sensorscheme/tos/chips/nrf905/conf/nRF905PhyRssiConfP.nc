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
 * Implementation of nRF905PhyConf and nRF905RssiConf interfaces.
 * These are implemented jointly because the rssi measure period depends 
 * on the frequency deviation (which itself depends on bitrate).
 *
 * @author Leon Evers
 */


module nRF905PhyRssiConfP {

    provides interface nRF905PhyConf;
    provides interface nRF905RssiConf;
    provides interface Init @atleastonce();

    uses interface Resource as SpiResource;
    uses interface nRF905Register as MCParam0;
    uses interface nRF905Register as MCParam1;
    uses interface nRF905Register as MCParam2;
    uses interface nRF905Register as MCParam3;
    uses interface nRF905Register as MCParam4;
    uses interface nRF905Register as TXParam7;
    uses interface nRF905Register as RXParam8;
    uses interface nRF905Register as RXParam9;
}
implementation {
#include "nrf905debug.h"

    /* 
     * Default settings for initial parameters. 
     */ 
#ifndef nRF905_BITRATE_DEFAULT
#define nRF905_BITRATE_DEFAULT  76170
#endif
    //xxx/make this computed as a fun of nRF905_BITRATE_DEFAULT
#ifndef nRF905_FREQDEV_DEFAULT
#define nRF905_FREQDEV_DEFAULT  100000
#endif


    /*
     * Register calculation helper macros.
     */
#define nRF905_FREQ(value_)                     (((value_) * 100) / 50113L)
#define nRF905_EFFECTIVE_FREQ(value_)           (((int32_t)((int16_t)(value_)) * 50113L) / 100)
#define nRF905_FREQ_DEV_HI(value_)              ((nRF905_FREQ(value_) >> 8) & 0x01)
#define nRF905_FREQ_DEV_LO(value_)              (nRF905_FREQ(value_) & 0xff)
#define nRF905_FREQ_HI(value_)                  ((nRF905_FREQ(value_) >> 8) & 0xff)
#define nRF905_FREQ_LO(value_)                  (nRF905_FREQ(value_) & 0xff)
#define nRF905_BIT_RATE(value_)                 ((152340L / (value_) - 1) & 0x7f)
#define nRF905_EFFECTIVE_BIT_RATE(value_)       (152340L / ((value_) + 1))


    /**
     * Frequency bands.
     */
    enum nrf905_freq_bands {
	nRF905_Band_434 = 434000000,
	nRF905_Band_869 = 869000000,
	nRF905_Band_915 = 915000000
    };
  

    // this value is the time between rssi measurement updates, plus a buffer time.
    // we keep it cached for fast access during packet reception
    uint16_t rssi_period_us; 

    // time to xmit/receive a byte at current bitrate 
    uint16_t byte_time_us;

    // norace is ok because protected by the isOwner() calls
    norace uint8_t rxparam9 = 0xff; 
    norace uint8_t txparam7 = 0xff;

    // returns appropriate baseband filter in khz bw for given bitrate in bits/sec.
    uint16_t baseband_bw_from_bitrate(uint32_t bitrate) {
	return (bitrate * 400) /152340;
    }


    // returns appropriate freq. deviation for given bitrate in bits/sec.
    uint32_t freq_dev_from_bitrate(uint32_t bitrate) {
	return (bitrate * 6) / 5;
    }

    // returns nrf905 encoding of baseband bandwidth in appropriate bit positions
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

    // returns the period (in us) between two successive rssi measurements
    // (see xemics data sheet 4.2.3.4), as a function of frequency deviation
    uint16_t rssi_meas_time(uint32_t freqdev_hz) 
    {
	if (freqdev_hz > 20000)      // at 152kbps, equiv to 2 byte times, at 76kbps, equiv to 1 byte time, at 38kbps equiv to 4 bits, etc
	    return 100;
	else if (freqdev_hz > 10000) // at 9.6kbps, equiv to 4 byte times.
	    return 200;           
	else if (freqdev_hz > 7000)
	    return 300;
	else if (freqdev_hz > 5000)  // at 4.8kbps, equiv to 4 byte times.
	    return 400;
	else 
	    return 500;                // at 1200, equiv to 13 byte times.
    }

    task void initTask() 
    {
	atomic {
	    byte_time_us = 8000000 / nRF905_BITRATE_DEFAULT;
	    rssi_period_us = rssi_meas_time(nRF905_FREQDEV_DEFAULT) + 10;

	    nrf905check(1, call SpiResource.immediateRequest()); // should always succeed: task happens after softwareInit, before interrupts are enabled

	    call TXParam7.write(0x00); // tx power 0dbm, normal modulation & bitsync, no flitering
	    txparam7=0;

	    call MCParam0.write(0x3c | nRF905_FREQ_DEV_HI(nRF905_FREQDEV_DEFAULT)); // buffered mode, transceiver select using SW(0:1), Data output, 868mhz band, 
	    call MCParam1.write(nRF905_FREQ_DEV_LO(nRF905_FREQDEV_DEFAULT));
	    call MCParam2.write(nRF905_BIT_RATE(nRF905_BITRATE_DEFAULT));

	    call MCParam3.write(nRF905_FREQ_HI(-1000000)); // 869mhz - 1mhz = 868mhz (preset 0)
	    call MCParam4.write(nRF905_FREQ_LO(-1000000));


	    call RXParam8.write(baseband_bw_rxparam7_bits(baseband_bw_from_bitrate(nRF905_BITRATE_DEFAULT))
				| 0x0a); // calibrate & init baseband filter each time bbw changes

	    call RXParam9.write(0x00); // rssi off by default, fei off
	    rxparam9=0;
	    call SpiResource.release();
	}
    }

    command error_t Init.init() 
    {
	post initTask();
	return SUCCESS;
    }
  
    event void SpiResource.granted() {
    }

    error_t tuneManual(uint32_t freq) 
    {
	uint32_t bandCenter;
	uint8_t mcp0reg;
	uint16_t mcp34reg;
	error_t status;

	if (call SpiResource.isOwner()) return EBUSY;
	status = call SpiResource.immediateRequest();
	nrf905check(2, status);
	if (status != SUCCESS) return status;


	call MCParam0.read(&mcp0reg);

	mcp0reg &= ~0x6;

	if ((freq >= (nRF905_Band_434 + nRF905_EFFECTIVE_FREQ(0x8000)))
	    && (freq <= (nRF905_Band_434 + nRF905_EFFECTIVE_FREQ(0x7fff)))) {

	    mcp0reg |= (1 << 1);
	    bandCenter = nRF905_Band_434;

	} else if ((freq >= (nRF905_Band_869 + nRF905_EFFECTIVE_FREQ(0x8000)))
		   && (freq <= (nRF905_Band_869 + nRF905_EFFECTIVE_FREQ(0x7fff)))) {

	    mcp0reg |= (2 << 1);
	    bandCenter = nRF905_Band_869;

	} else if ((freq >= (nRF905_Band_915+ nRF905_EFFECTIVE_FREQ(0x8000)))
		   && (freq <= (nRF905_Band_915 + nRF905_EFFECTIVE_FREQ(0x7fff)))) {

	    mcp0reg |= (3 << 1);
	    bandCenter = nRF905_Band_915;

	} else {
	    call SpiResource.release();
	    return EINVAL;
	}                       


	mcp34reg = nRF905_FREQ(freq - bandCenter);

	call MCParam0.write(mcp0reg);
	call MCParam3.write(mcp34reg >> 8);
	call MCParam4.write(mcp34reg & 0xff);

	call SpiResource.release();

	return SUCCESS;
    }


    command error_t nRF905PhyConf.tunePreset(nrf905_channelpreset_t preset) 
    {
	switch(preset) {

	case nrf905_channelpreset_868mhz:
	    return tuneManual(868000000);

	case nrf905_channelpreset_869mhz:
	    return tuneManual(869000000);

	case nrf905_channelpreset_870mhz:
	    return tuneManual(870000000);

	case nrf905_channelpreset_433mhz:
	    return tuneManual(433000000);

	case nrf905_channelpreset_434mhz:
	    return tuneManual(434000000);

	case nrf905_channelpreset_435mhz:
	    return tuneManual(435000000);

	default:
	    return FAIL;
	}
    }

    async command error_t nRF905PhyConf.setRFPower(nrf905_txpower_t txpow)
    {
	error_t status;

	if (txpow > nrf905_txpower_15dbm)
	    return EINVAL;

	if (call SpiResource.isOwner()) return EBUSY;
	status = call SpiResource.immediateRequest();
	nrf905check(3, status);
	if (status != SUCCESS) return status;

	txparam7 &= ~(3 << 6);
	txparam7 |= (txpow << 6);
	call TXParam7.write(txparam7);
	call SpiResource.release();
	return SUCCESS;
    }


  

    command error_t nRF905PhyConf.setBitrate(nrf905_bitrate_t bitrate) 
    {
	uint16_t bbw;
	uint32_t freqdev;
	uint8_t rxp8reg, mcp0reg, mcp1reg, mcp2reg;
	error_t status;

	if (bitrate < nrf905_bitrate_38085 || bitrate > nrf905_bitrate_152340) return EINVAL;

	if (call SpiResource.isOwner()) return EBUSY;
	status = call SpiResource.immediateRequest();
	nrf905check(4, status);
	if (status != SUCCESS) return status;

	// receiver bandwidth
	call RXParam8.read(&rxp8reg);
	bbw = baseband_bw_from_bitrate(bitrate);
	rxp8reg &= ~0x70;
	rxp8reg |= baseband_bw_rxparam7_bits(bbw);


	// frequency deviation
	freqdev = freq_dev_from_bitrate(bitrate);
	rssi_period_us = rssi_meas_time(freqdev) + 10;

	call MCParam0.read(&mcp0reg);
	mcp0reg &= ~0x01;
	mcp0reg |= nRF905_FREQ_DEV_HI(freqdev);

	mcp1reg = nRF905_FREQ_DEV_LO(freqdev);

	mcp2reg = nRF905_BIT_RATE(bitrate);

	call RXParam8.write(rxp8reg);
	call MCParam0.write(mcp0reg);
	call MCParam1.write(mcp1reg);
	call MCParam2.write(mcp2reg);;

	atomic byte_time_us =   8000000 / bitrate;
	call SpiResource.release(); 
	return SUCCESS;
    }

    async command uint16_t nRF905PhyConf.getByteTime_us() { 
	return byte_time_us;
    }

    async command error_t nRF905RssiConf.setRssiMode(bool on) 
    {
	// must have bus
	if (on) 
	    rxparam9 |= 0x80;
	else 
	    rxparam9 &= ~0x80;
	call RXParam9.write(rxparam9);

	return SUCCESS;
    }

    async command uint16_t nRF905RssiConf.getRssiMeasurePeriod_us() {
	return rssi_period_us;
    }

    async command error_t nRF905RssiConf.setRssiRange(bool high) 
    {
	// must have bus
	if (high) {
	    rxparam9 |= 0x40;
	} else {
	    rxparam9 &= ~0x40;
	}
	call RXParam9.write(rxparam9);
	return SUCCESS;
    }

    async command error_t nRF905RssiConf.getRssi(uint8_t* rssi) 
    {
	// must have bus
	call RXParam9.read(rssi);
    
	*rssi = (*rssi >> 4) & 0x03;

	return SUCCESS;
    }

}
