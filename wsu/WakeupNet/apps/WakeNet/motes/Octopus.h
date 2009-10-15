// $Id$

/*									tab:4
 * Copyright (c) 2007 University College Dublin.
 * All rights reserved.
 *
 * Permission to use, copy, modify, and distribute this software and its
 * documentation for any purpose, without fee, and without written agreement is
 * hereby granted, provided that the above copyright notice and the following
 * two paragraphs appear in all copies of this software.
 *
 * IN NO EVENT SHALL UNIVERSITY COLLEGE DUBLIN BE LIABLE TO ANY
 * PARTY FOR DIRECT, INDIRECT, SPECIAL, INCIDENTAL, OR CONSEQUENTIAL DAMAGES
 * ARISING OUT OF THE USE OF THIS SOFTWARE AND ITS DOCUMENTATION, EVEN IF 
 * UNIVERSITY COLLEGE DUBLIN HAS BEEN ADVISED OF THE POSSIBILITY OF
 * SUCH DAMAGE.
 *
 * UNIVERSITY COLLEGE DUBLIN SPECIFICALLY DISCLAIMS ANY WARRANTIES,
 * INCLUDING, BUT NOT LIMITED TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY
 * AND FITNESS FOR A PARTICULAR PURPOSE.  THE SOFTWARE PROVIDED HEREUNDER IS
 * ON AN "AS IS" BASIS, AND UNIVERSITY COLLEGE DUBLIN HAS NO
 * OBLIGATION TO PROVIDE MAINTENANCE, SUPPORT, UPDATES, ENHANCEMENTS, OR
 * MODIFICATIONS.
 *
 * Authors:	Raja Jurdak, Antonio Ruzzelli, Samuel Boivineau and Alessio Barbirato
 * Date created: 2007/09/07
 *
 */

/**
 * @author Raja Jurdak, Antonio Ruzzelli, Samuel Boivineau and Alessio Barbirato
 */

#ifndef OCTOPUS_H
#define OCTOPUS_H

#include "AM.h"

#define SEND_TASK if(!root) \
					post collectSendTask(); \
				else \
					post serialSendTask();
enum {
	AM_OCTOPUS_COLLECTED_MSG = 0x93,
	AM_OCTOPUS_BROADCAST_MSG = 0x71,
	AM_OCTOPUS_SENT_MSG = 0x65,
	
	NO_REPLY = 0x00,
	//Xiaogang 20090413  add sensor type
	READING_SIZE = 3,
	READING_LIGHT = 0x01,
	READING_ACC = 0x02,
	READING_HUMIDITY = 0x03,
	READING_TEMPERATURE = 0x04,
	READING_ENERGY=0x05,
	READING_ADC = 0x06,
	READING_BATTERY= 0x07,
	READING_DEFAULT=0x08,
	
	BATTERY_AND_MODE_REPLY = 0x20,
	PERIOD_REPLY = 0x40,
	THRESHOLD_REPLY = 0x60,
	SLEEP_DUTY_CYCLE_REPLY = 0x80,
	AWAKE_DUTY_CYCLE_REPLY = 0xA0,
	REPLY_MASK = 0xE0,
	MODE_MASK = 0x01,
	SLEEP_MASK = 0x02,
	SLEEPING = 0x02,
	AWAKE = 0x00,
	SET_MODE_AUTO_REQUEST = 1,
	SET_MODE_QUERY_REQUEST = 2,
	SET_PERIOD_REQUEST = 3,
	SET_THRESHOLD_REQUEST = 4,
	GET_STATUS_REQUEST = 5,
	SLEEP_REQUEST = 6,
	WAKE_UP_REQUEST = 7,
	GET_PERIOD_REQUEST = 8,
	GET_THRESHOLD_REQUEST = 9,
	GET_READING_REQUEST = 10,
	GET_SLEEP_DUTY_CYCLE_REQUEST = 11,
	GET_AWAKE_DUTY_CYCLE_REQUEST = 12,
	SET_SLEEP_DUTY_CYCLE_REQUEST = 13,
	SET_AWAKE_DUTY_CYCLE_REQUEST = 14,
	BROADCAST_DIS_KEY = 42,
	BOOT_REQUEST = 15,
	MAX_ID = 16,
	MODE_AUTO = 1,
	MAX_NUM_NODES = 41,
	MODE_QUERY = 0, 
	WAIT_TIME=10,
	MAX_QUEUE=64,
	SLEEP_TIME=1000,

	LIGHT_SLEEP_THRESHOLD = 60,
	//LIGHT_WAKEUP_THRESHOLD = 200, //disable light wakeup, 8 should be set for wakeup 
	LIGHT_WAKEUP_THRESHOLD = 2, 
	ADC_THRESHOLD = 200,
	//make ADC always wake-on
	//ADC_THRESHOLD = 1,
		
	//active mode
	INST_BYTE_ADC0 = 0x10,
	INST_BYTE_ADC1 = 0x90,
	//sleep mode
	//INST_BYTE_ADC0 = 0x20,
	//INST_BYTE_ADC1 = 0xA0,

	REF_VOLTAGE_50 = 50,
	REF_VOLTAGE_25 = 25,

	ENERGY_REPORT_TIME = 1000*5//*60*5
};

#include "OctopusConfig.h"

/*
 * 	Structure of message collected through the network by the gateway
 */
typedef nx_struct octopus_collected_msg {
	nx_am_addr_t moteId; /* Mote id of sending mote. */
	nx_uint8_t count; /* The readings are samples count * NREADINGS onwards */
	//nx_uint16_t reading;
	//xg 20090413 increase sensing data size, acc, etc
	nx_uint16_t reading[READING_SIZE];

	//nx_uint16_t hops;
	nx_uint16_t quality;
	nx_am_addr_t parentId;
	//reuse reply field, label sensor type
	nx_uint8_t reply;
	nx_uint8_t lqi;
	nx_uint8_t rssi;
} octopus_collected_msg_t;

/*
	Structure of message sent over the network by the gateway
	Each message is composed of :
		its type (setThreshold, setPeriod, getPeriod, etc)
		some parameters needed, according to the request
		
	List of requests
	================
	
	type (8 bits)					parameters	(16 bits)	reply (8 bits)		reading (16 bits)

	SET_MODE_AUTO_REQUEST			none					none				none
	SET_NUM_NODES_REQUEST			none					none				none
	SET_MODE_QUERY_REQUEST			none					none				none
	SET_PERIOD_REQUEST				period (16 bits)		none				none
	SET_THRESHOLD_REQUEST			threshold (8 bits)		none				none
	GET_STATUS_REQUEST				none					mode (1 bit)		battery
	GET_PERIOD_REQUEST				none					none				period
	GET_THRESHOLD_REQUEST			none					none				threshold
	GET_READING_REQUEST				none					none				reading
	SLEEP_REQUEST					none					none				none
	GET_SLEEP_DUTY_CYCLE_REQUEST	none					none				sleepDutyCycle
	WAKE_UP_REQUEST					none					none				none
	GET_AWAKE_DUTY_CYCLE_REQUEST	none					none				awakeDutyCycle
	SET_SLEEP_DUTY_CYCLE_REQUEST	sleepDutyCycle			none				none
	SET_AWAKE_DUTY_CYCLE_REQUEST	awakeDutyCycle			none				none
	
!	add an option to choose if the mote starts sleeping or not
	a mote sleeping doesn't reply to a status request ?
*/

typedef nx_struct octopus_sent_msg {
	nx_am_addr_t targetId;
	nx_uint8_t request;
	nx_uint16_t parameters;
} octopus_sent_msg_t;

#endif
