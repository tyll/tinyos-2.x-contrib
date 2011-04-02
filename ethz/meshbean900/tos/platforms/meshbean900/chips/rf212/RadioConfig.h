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

#include <MicaTimer.h>
#include <RF212DriverLayer.h>

enum
{
	/**
	 * This is the value of the TRX_CTRL_0 register
	 * which configures the output pin currents and the CLKM clock
	 */
	RF212_TRX_CTRL_0_VALUE = 0,

	/**
	 * This is the value of the TRX_CTRL_2 register which configures the 
	 * data rate and modulation type. Use the constants from RF212DriverLayer.h
	 */
	RF212_TRX_CTRL_2_VALUE = RF212_DATA_MODE_BPSK_20,
	//RF212_TRX_CTRL_2_VALUE = RF212_DATA_MODE_BPSK_40, 
	//RF212_TRX_CTRL_2_VALUE = RF212_DATA_MODE_OQPSK_SIN_RC_100, 
	//RF212_TRX_CTRL_2_VALUE = RF212_DATA_MODE_OQPSK_SIN_RC_400, 
	//RF212_TRX_CTRL_2_VALUE = RF212_DATA_MODE_OQPSK_SIN_250, 
	//RF212_TRX_CTRL_2_VALUE = RF212_DATA_MODE_OQPSK_SIN_1000, 

	/**
	 * This is the default value of the CCA_MODE field in the PHY_CC_CCA register
	 * which is used to configure the default mode of the clear channel assesment
	 */
	RF212_CCA_MODE_VALUE = RF212_CCA_MODE_3,

	/**
	 * This is the value of the CCA_THRES register that controls the
	 * energy levels used for clear channel assesment
	 */
	RF212_CCA_THRES_VALUE = 0x77,
};

/* This is the default value of the TX_PWR field of the PHY_TX_PWR register. */
#ifndef RF212_DEF_RFPOWER
#define RF212_DEF_RFPOWER	0x65
#endif

/* This is the default value of the CHANNEL field of the PHY_CC_CCA register. */
#ifndef RF212_DEF_CHANNEL
#define RF212_DEF_CHANNEL	1
#endif

/* The number of microseconds a sending MESHBEAN900 mote will wait for an acknowledgement */
#ifndef SOFTWAREACK_TIMEOUT
#define SOFTWAREACK_TIMEOUT	5000
#endif

/**
 * This is the timer type of the radio alarm interface
 */
typedef TThree TRadio;
typedef uint16_t tradio_size;

/**
 * The number of radio alarm ticks per one microsecond
 */
#define RADIO_ALARM_MICROSEC	1L

/**
 * The base two logarithm of the number of radio alarm ticks per one millisecond
 */
#define RADIO_ALARM_MILLI_EXP	10

#endif//__RADIOCONFIG_H__
