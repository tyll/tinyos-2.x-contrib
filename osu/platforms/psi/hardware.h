#ifndef _H_hardware_h
#define _H_hardware_h

#include "msp430hardware.h"
//#include "MSP430ADC12.h"
//#include "CC2420Const.h"
//#include "AM.h"


/**
 * Copyright (c) 2007 - The Ohio State University.
 * All rights reserved.
 *
 * Permission to use, copy, modify, and distribute this software and its
 * documentation for any purpose, without fee, and without written agreement is
 * hereby granted, provided that the above copyright notice, the following
 * two paragraphs, and the author attribution appear in all copies of this
 * software.
 *
 * IN NO EVENT SHALL THE OHIO STATE UNIVERSITY BE LIABLE TO ANY PARTY FOR
 * DIRECT, INDIRECT, SPECIAL, INCIDENTAL, OR CONSEQUENTIAL DAMAGES ARISING OUT
 * OF THE USE OF THIS SOFTWARE AND ITS DOCUMENTATION, EVEN IF THE OHIO STATE
 * UNIVERSITY HAS BEEN ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
 *
 * THE OHIO STATE UNIVERSITY SPECIFICALLY DISCLAIMS ANY WARRANTIES,
 * INCLUDING, BUT NOT LIMITED TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY
 * AND FITNESS FOR A PARTICULAR PURPOSE.  THE SOFTWARE PROVIDED HEREUNDER IS
 * ON AN "AS IS" BASIS, AND THE OHIO STATE UNIVERSITY HAS NO OBLIGATION TO
 * PROVIDE MAINTENANCE, SUPPORT, UPDATES, ENHANCEMENTS, OR MODIFICATIONS.

	@author 
	Lifeng Sang  <sangl@cse.ohio-state.edu>
	Anish Arora  <anish@cse.ohio-state.edu>	
	$Date$
	
	Porting TinyOS to Intel PSI motes
 */
 

/******************************************
Port 1
*******************************************/
TOSH_ASSIGN_PIN(SPI_CS0, 1, 7);
TOSH_ASSIGN_PIN(GPIO_17, 1, 6);
TOSH_ASSIGN_PIN(IM2_INTR, 1, 5);
TOSH_ASSIGN_PIN(RED_LED, 1, 4);
TOSH_ASSIGN_PIN(SPI_CS1_INT, 1, 3);
TOSH_ASSIGN_PIN(RADIO_SFD, 1, 2);
TOSH_ASSIGN_PIN(PROG_RX, 1, 1);
TOSH_ASSIGN_PIN(RADIO_FIFO, 1, 0);
//TOSH_ASSIGN_PIN(RADIO_GIO0, 1, 0);



/******************************************
Port 2
*******************************************/
TOSH_ASSIGN_PIN(RADIO_CCA, 2, 7);
//TOSH_ASSIGN_PIN(RADIO_GIO1, 2, 7);
TOSH_ASSIGN_PIN(RADIO_FIFOP, 2, 6);
TOSH_ASSIGN_PIN(RADIO_ROSC, 2, 5);
TOSH_ASSIGN_PIN(SPI_NIRQ, 2, 4);
TOSH_ASSIGN_PIN(YELLOW_LED, 2, 3);
TOSH_ASSIGN_PIN(PROG_TX, 2, 2);
TOSH_ASSIGN_PIN(GPIO_25_INT, 2, 1);
TOSH_ASSIGN_PIN(GPIO_24_INT, 2, 0);


/******************************************
Port 3
*******************************************/
TOSH_ASSIGN_PIN(IM2_FF_RXD, 3, 7);
TOSH_ASSIGN_PIN(IM2_FF_TXD, 3, 6);
TOSH_ASSIGN_PIN(IM2_STD_RXD, 3, 5);
TOSH_ASSIGN_PIN(IM2_STD_TXD, 3, 4);
TOSH_ASSIGN_PIN(COMM_SPI_I2C_CLK, 3, 3);
TOSH_ASSIGN_PIN(RADIO_SO, 3, 2);
TOSH_ASSIGN_PIN(COMM_SPI_I2C_DATA, 3, 1);
TOSH_ASSIGN_PIN(RADIO_CSN, 3, 0);


/******************************************
Port 4
*******************************************/
TOSH_ASSIGN_PIN(ONEWIRE, 4, 7);
TOSH_ASSIGN_PIN(IM2_SSP2_SFRM, 4, 6);
TOSH_ASSIGN_PIN(ACCEL_SLEEP_N, 4, 5);
TOSH_ASSIGN_PIN(IM2_FF_RTS, 4, 4);
TOSH_ASSIGN_PIN(IM2_FF_CTS, 4, 3);
TOSH_ASSIGN_PIN(IM2_RESET, 4, 2);
TOSH_ASSIGN_PIN(RADIO_SFD_R, 4, 1);
TOSH_ASSIGN_PIN(I2C_EN, 4, 0);



/******************************************
Port 5
*******************************************/
TOSH_ASSIGN_PIN(RADIO_RESET, 5, 7);
TOSH_ASSIGN_PIN(RADIO_VREF, 5, 6);
TOSH_ASSIGN_PIN(IM2_GPIO_94, 5, 5);
TOSH_ASSIGN_PIN(GREEN_LED, 5, 4);
TOSH_ASSIGN_PIN(UCLK0, 5, 3);
TOSH_ASSIGN_PIN(SOMI0, 5, 2);
TOSH_ASSIGN_PIN(SIMO0, 5, 1);
TOSH_ASSIGN_PIN(SPI_CS1, 5, 0);


/******************************************
Port 6
*******************************************/
TOSH_ASSIGN_PIN(TP45, 6, 7);
TOSH_ASSIGN_PIN(SPI_CS2, 6, 6);
TOSH_ASSIGN_PIN(ADC5, 6, 5);
TOSH_ASSIGN_PIN(ADC4, 6, 4);
TOSH_ASSIGN_PIN(ADC3, 6, 3);
TOSH_ASSIGN_PIN(HUM_SDA, 6, 2);
TOSH_ASSIGN_PIN(HUM_SCL, 6, 1);
TOSH_ASSIGN_PIN(HUM_PWR, 6, 0);




// No external FLASH in the PSI motes, so it doesn't really matter
TOSH_ASSIGN_PIN(FLASH_PWR, 6, 7);
TOSH_ASSIGN_PIN(FLASH_CS, 6, 7);
TOSH_ASSIGN_PIN(FLASH_HOLD, 6, 7);

//so is the humidity sensor

void HUMIDITY_MAKE_CLOCK_OUTPUT() { TOSH_MAKE_HUM_SCL_OUTPUT(); }
void HUMIDITY_MAKE_CLOCK_INPUT() { TOSH_MAKE_HUM_SCL_INPUT(); }
void HUMIDITY_CLEAR_CLOCK() { TOSH_CLR_HUM_SCL_PIN(); }
void HUMIDITY_SET_CLOCK() { TOSH_SET_HUM_SCL_PIN(); }
void HUMIDITY_MAKE_DATA_OUTPUT() { TOSH_MAKE_HUM_SDA_OUTPUT(); }
void HUMIDITY_MAKE_DATA_INPUT() { TOSH_MAKE_HUM_SDA_INPUT(); }
void HUMIDITY_CLEAR_DATA() { TOSH_CLR_HUM_SDA_PIN(); }
void HUMIDITY_SET_DATA() { TOSH_SET_HUM_SDA_PIN(); }
char HUMIDITY_GET_DATA() { return TOSH_READ_HUM_SDA_PIN(); }

#define HUMIDITY_TIMEOUT_MS          30
#define HUMIDITY_TIMEOUT_TRIES       20

enum {
  // Sensirion Humidity addresses and commands
  TOSH_HUMIDITY_ADDR = 5,
  TOSH_HUMIDTEMP_ADDR = 3,
  TOSH_HUMIDITY_RESET = 0x1E
};



// need to undef atomic inside header files or nesC ignores the directive
#undef atomic

#endif // _H_hardware_h
