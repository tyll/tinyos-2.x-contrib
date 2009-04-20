/*
 * Copyright (c) 2007, Vanderbilt University
 * All rights reserved.
 *
 * Permission to use, copy, modify, and distribute this software and its
 * documentation for any purpose, without fee, and without written agreement is
 * hereby granted, provided that the above copyright notice, the following
 * two paragraphs and the author appear in all copies of this software.
 * 
 * IN NO EVENT SHALL THE VANDERBILT UNIVERSITY BE LIABLE TO ANY PARTY FOR
 * DIRECT, INDIRECT, SPECIAL, INCIDENTAL, OR CONSEQUENTIAL DAMAGES ARISING OUT
 * OF THE USE OF THIS SOFTWARE AND ITS DOCUMENTATION, EVEN IF THE VANDERBILT
 * UNIVERSITY HAS BEEN ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
 * 
 * THE VANDERBILT UNIVERSITY SPECIFICALLY DISCLAIMS ANY WARRANTIES,
 * INCLUDING, BUT NOT LIMITED TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY
 * AND FITNESS FOR A PARTICULAR PURPOSE.  THE SOFTWARE PROVIDED HEREUNDER IS
 * ON AN "AS IS" BASIS, AND THE VANDERBILT UNIVERSITY HAS NO OBLIGATION TO
 * PROVIDE MAINTENANCE, SUPPORT, UPDATES, ENHANCEMENTS, OR MODIFICATIONS.
 *
 * Author: Miklos Maroti
 */

#ifndef __RADIOCONFIG_H__
#define __RADIOCONFIG_H__

 //#include <MicaTimer.h>
#include <RF230DriverLayer.h>


enum
{
	/**
	 * This is the value of the TRX_CTRL_0 register
	 * which configures the output pin currents and the CLKM clock
	 */
	RF230_TRX_CTRL_0_VALUE = 0,

	/**
	 * This is the default value of the CCA_MODE field in the PHY_CC_CCA register
	 * which is used to configure the default mode of the clear channel assesment
	 */
	RF230_CCA_MODE_VALUE = RF230_CCA_MODE_3,

	/**
	 * This is the value of the CCA_THRES register that controls the
	 * energy levels used for clear channel assesment
	 */
	RF230_CCA_THRES_VALUE = 0xC7,
};
#ifndef RF230_SLOW_SPI
#define RF230_SLOW_SPI 1
#endif
/* This is the default value of the TX_PWR field of the PHY_TX_PWR register. 0-15*/
#ifndef RF230_DEF_RFPOWER
#define RF230_DEF_RFPOWER	0
#endif

/* This is the default value of the CHANNEL field of the PHY_CC_CCA register. 11-26*/
#ifndef RF230_DEF_CHANNEL
#define RF230_DEF_CHANNEL	11
#endif


/*
 * This is the command used to calculate the CRC for the RF230 chip. 
 * TODO: Check why the default crcByte implementation is in a different endianness
 */
inline uint16_t RF230_CRCBYTE_COMMAND(uint16_t crc, uint8_t data)
{
    uint8_t lo8 = crc & 0x00FF;
    uint8_t hi8 = (crc >> 8) & 0x00FF;
    data ^= lo8; //lo8 (crc);
    data ^= data << 4;

    return ((((uint16_t)data << 8) | hi8 /*hi8 (crc)*/) ^ (uint8_t)(data >> 4) 
        ^ ((uint16_t)data << 3));

}

/**
 * This is the timer type of the radio alarm interface
 */

typedef TMicro TRadio;
/**
 * The number of alarm ticks per one second
 */
#ifdef ENABLE_STOP_MODE
#define RADIO_ALARM_SEC 10000000UL/8UL
#else
#define RADIO_ALARM_SEC 1000000UL
#endif

#define RADIO_ALARM_MICROSEC	RADIO_ALARM_SEC/1000000UL

/**
 * The base two logarithm of the number of radio alarm ticks per one millisecond
 */
#define RADIO_ALARM_MILLI_EXP	10

#endif//__RADIOCONFIG_H__
