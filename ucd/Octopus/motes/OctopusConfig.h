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

#ifndef OCTOPUS_CONFIG_H
#define OCTOPUS_CONFIG_H

/* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
 *	This file includes every constant that can be defined by	 *
 *	a final user.												 *
 * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * */

/* 
	Choice of the protocol used to repatriate data to the root 
	of the network.
	Two  protocols can't have the same name, even if they are 
	not of the same type
*/
#define LOW_POWER_LISTENING
#define COLLECTION_PROTOCOL 		//  cf TEP 119: Collection.
//#define DUMMY_COLLECT_PROTOCOL	// 	not working

/* 
	Choice of the protocol used to broadcast data over the network
*/

#define DISSEMINATION_PROTOCOL		//  cf TEP 118: Dissemination.
//#define DUMMY_BROADCAST_PROTOCOL	//	not working

/*
					S E N S O R
	
	Sampling of the sensor. The unit is the milliseconds.
	
	MINIMUM_SAMPLING_PERIOD is the minimum value that should
	be broadcasted to the network to avoid congestion issues.
	A formula that can be used is, with N the number of motes 
	of the network, and MINIMUM_SAMPLING_PERIOD in ms :
	MINIMUM_SAMPLING_PERIOD = 100 * N
	
	Threshold of the sensor. A threshold of 0 means that
	the value is sent every time. Else the threshold is
	a 16-bits unsigned integer.
	
					  M O D E
	
	The user can choose either the automatic aka timer-driven
	mode (MODE_AUTO) or the manual aka request-driven mode 
	(MODE_QUERY).
	
	   S L E E P   &   A W A K E   D U T Y   C Y C L E

	The user can define the sleep duty cycle and the awake
	duty cycle in units of [percent * 100]. For example, to
	get a 0.05% duty cycle, use the value 5, and for a 100%
	duty cycle (always on), use the value 10000. 
	This is the equivalent of setting the local sleep 
	interval explicitly.
*/

enum {
	DEFAULT_SAMPLING_PERIOD = 1024,
	MINIMUM_SAMPLING_PERIOD = 1024,
	DEFAULT_THRESHOLD = 0,
	DEFAULT_MODE = MODE_AUTO,
	DEFAULT_SLEEP_DUTY_CYCLE = 2000, 	// 20%
	DEFAULT_AWAKE_DUTY_CYCLE = 9000		// 90%
};
	
#endif
