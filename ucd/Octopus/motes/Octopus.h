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
 * Authors:	Raja Jurdak, Antonio Ruzzelli, and Samuel Boivineau
 * Date created: 2007/09/07
 *
 */

/**
 * @author Raja Jurdak, Antonio Ruzzelli, and Samuel Boivineau
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
	SET_NUM_NODES_REQUEST = 16,
	MODE_AUTO = 1,
	MAX_NUM_NODES = 41,
	MODE_QUERY = 0 // useful ?

};

#include "OctopusConfig.h"

/*
 * 	Structure of message collected through the network by the gateway
 */

typedef nx_struct octopus_collected_msg {
	nx_am_addr_t moteId; /* Mote id of sending mote. */
	nx_uint16_t count; /* The readings are samples count * NREADINGS onwards */
	nx_uint16_t reading;
	//nx_uint16_t hops;
	nx_uint16_t quality;
	nx_am_addr_t parentId;
	nx_uint8_t reply;
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
