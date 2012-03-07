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

/**
 * Commands for controlling platform coprocessor (atmega3290) via Uart0 (SIPC - serial inter-platform communication).
 *
 *  @author Martin Cerveny
 */ 

#include "raven.h"

module RavenP @safe() {
	provides interface Raven;
	provides interface Init as SoftwareInit;

	uses interface UartStream;
	uses interface StdControl as UartCtl;
}

implementation {
	uint8_t escaped = FALSE;

	uint8_t txbuf[SIPC_PACKET_SIZE * 2];
	uint8_t * txt = txbuf;	// tail in buffer
	uint8_t * txnextt = txbuf;	// new tail
	uint8_t * txh = txbuf;	// head in buffer        

	uint8_t rxbuf[SIPC_PACKET_SIZE * 2];
	uint8_t * rxt = rxbuf;	// tail in buffer
	uint8_t * rxlasth = rxbuf;	// last head in buffer (used as rollback when no space during receiving)
	uint8_t * rxh = rxbuf;	// head in buffer 
	uint8_t rxcnt = 0;

	uint16_t getlength(const uint8_t * msg, uint16_t len) {
		uint16_t real_len = 0;
		while(len--) {
			switch(*msg) {
				case SIPC_SOF : ;
				case SIPC_EOF : ;
				case SIPC_ESC : ;
				real_len++;
				break;
			}
			real_len++;
		}
		return real_len;
	}

	uint16_t diff(uint8_t * b, uint8_t * e) {
		if(b <= e) 
			return(e - b);
		else 
			return(e - txbuf) + (txbuf + sizeof(txbuf) - b);
	}

	void push_raw(uint8_t data) {
		*txh++=data;
		if(txh >= (txbuf + sizeof(txbuf))) 
			txh = txbuf;
	}

	void push(uint8_t data) {
		switch(data) {
			case SIPC_SOF : ;
			case SIPC_EOF : ;
			case SIPC_ESC : ;
			push_raw(SIPC_ESC);
			push_raw(data | SIPC_ESC_MASK);
			break;
			default : push_raw(data);
		}
	}

	uint8_t pop_raw() {
		uint8_t data;
		if(rxt == rxh) 
			return SIPC_EOF;	// no more data !
		data = *rxt++;
		if(rxt >= (rxbuf + sizeof(rxbuf))) 
			rxt = rxbuf;
		return data;
	}

	uint8_t pop() {
		uint8_t data = pop_raw();
		if(data == SIPC_ESC) {
			data = pop_raw();
			data &= ~ SIPC_ESC_MASK;
		}
		return data;
	}

	void trystart() {
		if(txt == txnextt){ // idle state
			txnextt = (txh < txt ? txbuf : txh);
			call UartStream.send(txt, diff(txt, txnextt));
		}
	}

	task void received() {
		uint16_t value;
		atomic {
			if(pop_raw() != SIPC_SOF) {
				// +++ not good
			}
			switch(pop()) {
				case SIPC_ANSWER_ID_TEMPERATURE : value = pop() + 256 * pop();
				signal Raven.temperature((int16_t) value);
				break;
				case SIPC_ANSWER_ID_BATTERY : value = pop() + 256 * pop();
				signal Raven.battery(value);
				break;
			}
			if(pop_raw() != SIPC_EOF) {
				// +++ not good
			}
		}
	}

	command error_t SoftwareInit.init() {
		call UartCtl.start();
		return SUCCESS;
	}

	async event void UartStream.sendDone(uint8_t * buf, uint16_t len, error_t error) {

		atomic {
			txt = txnextt;
			if(txt != txh) {
				txnextt = (txh < txt ? txbuf : txh);
				call UartStream.send(txt, diff(txt, txnextt));
			}
		}
	}

	async event void UartStream.receivedByte(uint8_t byte) {
		atomic {
			if( ! rxh) {
				if(byte == SIPC_EOF) {
					rxh = rxlasth;
					if( ! --rxcnt) 
						call UartStream.disableReceiveInterrupt();
				}
				// recover from out of buffer space condition
				return;
			}
			if((rxh + 1 == rxt) || ((rxh + 1 >= rxbuf + sizeof(rxbuf))&& rxt == rxbuf)) {
				rxh = 0;
				// drop receiving packet, out of buffer space condition
				return;
			}
			if((byte == SIPC_SOF)&&(rxh != rxlasth)) {
				rxh = rxlasth;
				// next SOF without EOF, restart packet
			}
			*rxh++=byte;
			if(rxh >= rxbuf + sizeof(rxbuf)) 
				rxh = rxbuf;
			if(byte == SIPC_EOF) {
				rxlasth = rxh;
				if( ! --rxcnt) 
					call UartStream.disableReceiveInterrupt();
				post received();
			}
		}
	}

	async event void UartStream.receiveDone(uint8_t * buf, uint16_t len, error_t error) {
	}

	command error_t Raven.cmd(uint8_t cmd) {
		if((cmd >= SIPC_CMD_ID_LCD_MAX)&&(cmd <= SIPC_CMD_WITH_ANSWER)) 
			return FAIL;
		atomic {
			if(getlength(&cmd, 1) + 2 >= (sizeof(txbuf) - diff(txt, txh))) 
				return FAIL;
			push_raw(SIPC_SOF);
			push(cmd);
			push_raw(SIPC_EOF);
			trystart();
			if((cmd > SIPC_CMD_WITH_ANSWER)&&( ! rxcnt++)) {
				call UartStream.enableReceiveInterrupt();
			}
			return SUCCESS;
		}
	}

	command error_t Raven.msg(const char * msg) {
		uint16_t len = getlength((const uint8_t * ) msg, strlen(msg) + 1) + 2 + 1 + 4;
		char * ptr = (char * ) msg;

		atomic {
			if((len >= (sizeof(txbuf) - diff(txt, txh))) || (len > SIPC_PACKET_SIZE)) 
				return FAIL;

			push_raw(SIPC_SOF);
			push(SIPC_CMD_ID_MSG);
			while(*ptr) 
				push(*ptr++);
			push(*ptr); // null terminated string
			push_raw(SIPC_EOF);
			// TODO: sychronisation issue
			push_raw(0);
			push_raw(0);
			push_raw(0);
			push_raw(0);
			trystart();
			return SUCCESS;
		}
	}

	command error_t Raven.hex(const uint16_t n, const uint8_t mask) {
		// TODO: mask not implemented
		atomic {
			if(getlength((const uint8_t * )&n, 2) + 2 + 1 >= (sizeof(txbuf) - diff(txt, txh))) 
				return FAIL;

			push_raw(SIPC_SOF);
			push(SIPC_CMD_ID_HEX);
			push(n & 0xff);
			push((n >> 8)& 0xff);
			push_raw(SIPC_EOF);
			trystart();
			return SUCCESS;
		}
	}
}