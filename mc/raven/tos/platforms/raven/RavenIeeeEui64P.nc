
/*
 * Copyright (c) 2012 Martin Cerveny
 * All rights reserved.
 *
 * Redistribution and use in source and binary forms, with or without
 * modification, are permitted provided that the following conditions
 * are met:
 * - Redistributions of source code must retain the above copyright
 *   notice, this list of conditions and the following disclaimer.
 * - Redistributions in binary form must reproduce the above copyright
 *   notice, this list of conditions and the following disclaimer in the
 *   documentation and/or other materials provided with the
 *   distribution.
 * - Neither the name of INSERT_AFFILIATION_NAME_HERE nor the names of
 *   its contributors may be used to endorse or promote products derived
 *   from this software without specific prior written permission.
 *
 * THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS
 * ``AS IS'' AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT
 * LIMITED TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS
 * FOR A PARTICULAR PURPOSE ARE DISCLAIMED.  IN NO EVENT SHALL STANFORD
 * UNIVERSITY OR ITS CONTRIBUTORS BE LIABLE FOR ANY DIRECT, INDIRECT,
 * INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES
 * (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR
 * SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION)
 * HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT,
 * STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE)
 * ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED
 * OF THE POSSIBILITY OF SUCH DAMAGE.
 */

#include "IeeeEui64.h"

/**
 * EUI64 reader.
 *
 * @author Martin Cerveny
 */ 

module RavenIeeeEui64P {
	provides interface LocalIeeeEui64;
	provides interface Init as SoftwareInit;

	uses interface Boot;
	uses interface I2CPacket<TI2CBasicAddr>;
	uses interface Resource;
}

implementation {
	ieee_eui64_t eui, eui_tmp;
	#define AT24_DEVICE_ADDRESS 0x50
	#define MAC_ADDRESS_POSITION 4

	command ieee_eui64_t LocalIeeeEui64.getId() {
		atomic return eui;
	}

	command error_t SoftwareInit.init() {
		memset(eui.data, 0, sizeof(eui.data)); 	// not ready until filled
		return SUCCESS;
	}
	
	event void Boot.booted() {
		call Resource.request();
	}	

	async event void I2CPacket.readDone(error_t error, uint16_t addr, uint8_t length, uint8_t * data) {
		if(error == SUCCESS) 
			atomic memcpy(eui.data, eui_tmp.data, sizeof(eui.data));
		call Resource.release();
	}

	async event void I2CPacket.writeDone(error_t error, uint16_t addr, uint8_t length, uint8_t * data) {
		call I2CPacket.read(I2C_START | I2C_STOP, AT24_DEVICE_ADDRESS, sizeof(eui_tmp.data), eui_tmp.data);
	}

	event void Resource.granted() {
		eui_tmp.data[0] = MAC_ADDRESS_POSITION;
		call I2CPacket.write(I2C_START, AT24_DEVICE_ADDRESS, sizeof(uint8_t), (uint8_t * ) eui_tmp.data);
	}
}