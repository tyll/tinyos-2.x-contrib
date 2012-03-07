
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
 * Commands for controlling platform coprocessor (atmega3290) via Uart0 (SIPC - serial inter-platform communication) with connected:
 *  - LCD controller 
 *  - temperature sensor
 *  - power/battery sensor
 *  - joystick (TODO: not implemened)
 *  - audio output (reproductor) (TODO: not implemened)
 *  - audio input (microphone) (TODO: not implemened)
 *  - memory storage (16mb) (TODO: not implemened)
 *  - external connectivity to:
 *     - relay interface (TODO: not implemened)
 *     - voltage sensor 0V to Vcc (TODO: not implemened)
 *     - voltage sensor with resistor divider 0V to (Vcc*5) (TODO: not implemened)
 *     - 4 user IO (TODO: not implemened)
 * 
 * @author Martin Cerveny
 */ 

#include "raven.h"

interface Raven {

	/**
	 * Command to coprocessor 
	 * 
	 * @param 'uint8_t cmd' - command (SIPC_CMD* < SIPC_CMD_ID_LCD_MAX and SIPC_CMD_ID_READ_* with answer)
	 * @return SUCCESS if the command was enqueued successfully, FAIL
	 *                 if it was not enqueued.
	 */
	command error_t cmd(uint8_t cmd);

	/**
	 * Message to LCD
	 * 
	 * @param 'const char * msg' - string to display on LCD text area
	 * @return SUCCESS if the command and string was enqueued successfully, FAIL
	 *                 if it was not enqueued.
	 */
	command error_t msg(const char * msg);

	/**
	 * Hex data to LCD
	 * 
	 * @param 'const uint16_t n' - number to display on LCD hex area
	 * @param 'const uint8_t mask' - bitmask to separate digits (SIPC_HEX*)
	 * @return SUCCESS if the command and number was enqueued successfully, FAIL
	 *                 if it was not enqueued.
	 */
	command error_t hex(const uint16_t n, const uint8_t mask);

	/**
	 * Signal answer to SIPC_CMD_ID_READ_BATTERY
	 * 
	 * @param 'uint16_t voltage' - battery voltage (in mV)
	 */
	event void battery(uint16_t voltage);

	/**
	 * Signal answer to SIPC_CMD_ID_READ_TEMPERATURE
	 * 
	 * @param 'int16_t celsius' - tempeature in celsius (-15 to 60 degree)
	 */
	event void temperature(int16_t celsius);

}