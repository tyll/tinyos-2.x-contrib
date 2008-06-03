
/***********************************************************************/
/* This program is free software; you can redistribute it and/or       */
/* modify it under the terms of the GNU General Public License as      */
/* published by the Free Software Foundation; either version 2 of the  */
/* License, or (at your option) any later version.                     */
/*                                                                     */
/* This program is distributed in the hope that it will be useful, but */
/* WITHOUT ANY WARRANTY; without even the implied warranty of          */
/* MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU   */
/* General Public License for more details.                            */
/*                                                                     */
/* Written and (c) by INRIA, Christophe Braillon                       */
/*                           Aurélien Francillon                       */
/* Contact <aurelien.francillon@inrialpes.fr> for comment, bug reports */
/* and possible alternative licensing of this program                  */
/***********************************************************************/
/**
 * @file   LeadtekGPS9546C.nc
 * @author Christophe Braillon
 * @author Aurelien Francillon
 * @date   Fri May  9 01:50:04 2008
 *
 * @brief Platform independent driver for leadtek gps 9546 device,
 * @todo - make the serial port configuration not dependent on atmega128 <BR>
 *       - the buffer read MTS400Sensor needs to be tinyosifed, possible to
 *         too use the READ interface ?
 *
 */


#include <Atm128Uart.h>

module LeadtekGPS9546C
{
	provides
	{
		// Interface for GPS setup
		interface Init as GPSInit;

		// Sensor interface
		interface MTS400Sensor;
	}

	uses{
		// UART used for communication
		interface HplAtm128Uart as UART1;
		interface StdControl as UART1RxControl;
	}
}

implementation
{
#define BUFFER_SIZE 100
	uint8_t buffer[2][BUFFER_SIZE];
	uint8_t buf[1] = {0x00};
	uint8_t current_buffer, current_byte, buffer_to_send, length_to_send;

	enum
	{
		CONNECT,
		DISCONNECT,
		TURN_ON,
		TURN_OFF
	};

	uint8_t internalState;

	command error_t GPSInit.init()
	{
		// Init UART communication
		atomic
		{
			current_byte = 0;
			current_buffer = 0;
		}

		call UART1RxControl.start();

		// Set UART1 baudrate to 4800bps
		// FIXME should be handled trough the UART interface
		UBRR1H = 0;
		UBRR1L = 191;
		UCSR1A = (1 << U2X);
		UCSR1C = ((1 << UCSZ1) | (1 << UCSZ0));
		UCSR1B = (1 << RXCIE) | (1 << RXEN);
		//call UART1.enableRxIntr();

		return SUCCESS;
	}


	task void signalDataReady()
	{
		atomic
		{
			signal MTS400Sensor.dataReady(buffer[buffer_to_send], length_to_send);
		}
	}

	async event void UART1.rxDone(uint8_t data)
	{
		//		call Leds.led0Toggle();
		/* If the first character is a '$' then this is
		   a new message, this means we need to signal dataReady */
		if((data == '$') && (current_byte > 1))
		{
			buffer_to_send = current_buffer;
			length_to_send = current_byte;

			post signalDataReady();

			current_byte = 0;
			current_buffer = 1 - current_buffer;
		}

		// Put the character into the buffer
		buffer[current_buffer][current_byte] = data;

		/* If buffer is not full, increment the pointer else
		   overwrite the last byte */
		if(current_byte < BUFFER_SIZE - 1)
		{
			current_byte++;
		}
	}

	// Unused events
	async event void UART1.txDone()	{}
}
