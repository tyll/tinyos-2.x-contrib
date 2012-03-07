
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
 *
 */ 

#ifndef RAVEN_H
#define RAVEN_H

typedef enum {
	// Symbols
	SIPC_CMD_ID_LCD_SYMB_RAVEN_ON = 0x00,
	SIPC_CMD_ID_LCD_SYMB_RAVEN_OFF = 0x01,

	SIPC_CMD_ID_LCD_SYMB_BELL_ON = 0x02,
	SIPC_CMD_ID_LCD_SYMB_BELL_OFF = 0x03,

	SIPC_CMD_ID_LCD_SYMB_TONE_ON = 0x04,
	SIPC_CMD_ID_LCD_SYMB_TONE_OFF = 0x05,

	SIPC_CMD_ID_LCD_SYMB_MIC_ON = 0x06,
	SIPC_CMD_ID_LCD_SYMB_MIC_OFF = 0x07,

	SIPC_CMD_ID_LCD_SYMB_SPEAKER_ON = 0x08,
	SIPC_CMD_ID_LCD_SYMB_SPEAKER_OFF = 0x09,

	SIPC_CMD_ID_LCD_SYMB_KEY_ON = 0x0a,
	SIPC_CMD_ID_LCD_SYMB_KEY_OFF = 0x0b,

	SIPC_CMD_ID_LCD_SYMB_ATT_ON = 0x0c,
	SIPC_CMD_ID_LCD_SYMB_ATT_OFF = 0x0d,

	SIPC_CMD_ID_LCD_SYMB_SPACE_SUN = 0x0e,
	SIPC_CMD_ID_LCD_SYMB_SPACE_MOON = 0x0f,
	SIPC_CMD_ID_LCD_SYMB_SPACE_OFF = 0x10,

	SIPC_CMD_ID_LCD_SYMB_CLOCK_AM = 0x11,
	SIPC_CMD_ID_LCD_SYMB_CLOCK_PM = 0x12,
	SIPC_CMD_ID_LCD_SYMB_CLOCK_OFF = 0x13,

	SIPC_CMD_ID_LCD_SYMB_TRX_RX = 0x14,
	SIPC_CMD_ID_LCD_SYMB_TRX_TX = 0x15,
	SIPC_CMD_ID_LCD_SYMB_TRX_OFF = 0x16,

	SIPC_CMD_ID_LCD_SYMB_IP_ON = 0x17,
	SIPC_CMD_ID_LCD_SYMB_IP_OFF = 0x18,

	SIPC_CMD_ID_LCD_SYMB_PAN_ON = 0x19,
	SIPC_CMD_ID_LCD_SYMB_PAN_OFF = 0x1a,

	SIPC_CMD_ID_LCD_SYMB_ZLINK_ON = 0x1b,
	SIPC_CMD_ID_LCD_SYMB_ZLINK_OFF = 0x1c,

	SIPC_CMD_ID_LCD_SYMB_ZIGBEE_ON = 0x1d,
	SIPC_CMD_ID_LCD_SYMB_ZIGBEE_OFF = 0x1e,

	SIPC_CMD_ID_LCD_SYMB_ANTENNA_LEVEL_0 = 0x1f,
	SIPC_CMD_ID_LCD_SYMB_ANTENNA_LEVEL_1 = 0x20,
	SIPC_CMD_ID_LCD_SYMB_ANTENNA_LEVEL_2 = 0x21,
	SIPC_CMD_ID_LCD_SYMB_ANTENNA_OFF = 0x22,

	//SIPC_CMD_ID_LCD_SYMB_BAT // bettery symbol is controlled by ATMega3290... 

	SIPC_CMD_ID_LCD_SYMB_ENV_OPEN = 0x23,
	SIPC_CMD_ID_LCD_SYMB_ENV_CLOSE = 0x24,
	SIPC_CMD_ID_LCD_SYMB_ENV_OFF = 0x25,

	SIPC_CMD_ID_LCD_SYMB_TEMP_CELSIUS = 0x26,
	SIPC_CMD_ID_LCD_SYMB_TEMP_FAHRENHEIT = 0x27,
	SIPC_CMD_ID_LCD_SYMB_TEMP_OFF = 0x28,

	SIPC_CMD_ID_LCD_SYMB_MINUS_ON = 0x29,
	SIPC_CMD_ID_LCD_SYMB_MINUS_OFF = 0x2a,

	SIPC_CMD_ID_LCD_SYMB_DOT_ON = 0x2b,
	SIPC_CMD_ID_LCD_SYMB_DOT_OFF = 0x2c,

	SIPC_CMD_ID_LCD_SYMB_COL_ON = 0x2d,
	SIPC_CMD_ID_LCD_SYMB_COL_OFF = 0x2e,

	// Led
	SIPC_CMD_ID_LED_ON = 0x2f,
	SIPC_CMD_ID_LED_TOGGLE = 0x30,
	SIPC_CMD_ID_LED_OFF = 0x31,

	// Commands total number.
	SIPC_CMD_ID_LCD_MAX = 0x32,

	// Messages
	SIPC_CMD_ID_MSG = 0x33,		// print text message
	SIPC_CMD_ID_HEX = 0x34,		// print hex number (experimental, TODO: not fully implemented) 

	SIPC_CMD_WITH_ANSWER = 0x7f,

	//Sensor read commands
	SIPC_CMD_ID_READ_TEMPERATURE = 0x80, 
	SIPC_CMD_ID_READ_BATTERY = 0x81,
} SipcCmdId_t;

typedef enum {
	SIPC_ANSWER_ID_TEMPERATURE = 1,
	SIPC_ANSWER_ID_BATTERY = 2,
} SipcAnswerId_t;

typedef enum {
	SIPC_SOF = 0x02,	//!< Unique start of frame delimiter.
	SIPC_EOF = 0x03,	//!< Unique end of frame delimiter.
	SIPC_ESC = 0x17,	//!< Unique byte used to indicate a stuffed byte.
	SIPC_ESC_MASK = 0x40	//!< Value used to OR together with the stuffed byte.
} SipcCtl_t;

typedef enum {			// TODO: not implemented
	SIPC_HEX1 = 0x01,
	SIPC_HEX2 = 0x02,
	SIPC_HEX3 = 0x04,
	SIPC_HEX4 = 0x08,
	SIPC_HEXNONE = 0x00,
	SIPC_HEXAUTO = 0x10,
	SIPC_HEXALL = SIPC_HEX1 | SIPC_HEX2 | SIPC_HEX3 | SIPC_HEX4
} SipcHexMask_t;

#define SIPC_PACKET_SIZE (256) //!< Maximum packet size that SIPC can handle.

#endif //RAVEN_H
