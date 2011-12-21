/*
 * Copyright (c) 2007 Washington University in St. Louis
 * and the University of Southern California.
 * All rights reserved.
 *
 * Permission to use, copy, modify, and distribute this software and its
 * documentation for any purpose, without fee, and without written agreement is
 * hereby granted, provided that the above copyright notice, the following
 * two paragraphs and the author appear in all copies of this software.
 *
 * IN NO EVENT SHALL WASHINGTON UNIVERSITY IN ST. LOUIS OR THE
 * UNIVERSITY OF SOUTHERN CALIFORNIA BE LIABLE TO ANY PARTY FOR DIRECT,
 * INDIRECT, SPECIAL, INCIDENTAL, OR CONSEQUENTIAL DAMAGES ARISING OUT
 * OF THE USE OF THIS SOFTWARE AND ITS DOCUMENTATION, EVEN IF WASHINGTON
 * UNIVERSITY IN ST. LOUIS OR THE UNIVERSITY OF SOUTHERN CALIFORNIA HAS
 * BEEN ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
 *
 * WASHINGTON UNIVERSITY IN ST. LOUIS AND THE UNIVERSITY OF SOUTHERN
 * CALIFORNIA SPECIFICALLY DISCLAIM ANY WARRANTIES, INCLUDING, BUT NOT
 * LIMITED TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR
 * A PARTICULAR PURPOSE.  THE SOFTWARE PROVIDED HEREUNDER IS ON AN "AS
 * IS" BASIS, AND WASHINGTON UNIVERSITY IN ST. LOUIS HAS NO OBLIGATION
 * TO PROVIDE MAINTENANCE, SUPPORT, UPDATES, ENHANCEMENTS, OR
 * MODIFICATIONS." 
 *
 */

/*
 * Portions of this file are derived from the files PhyConst.h 
 * and ScpConst.h from the original implementation of SCP by the 
 * University of Southern California. These files are under the 
 * following license:
 *
 ******
 *
 * Copyright (C) 2005 the University of Southern California.
 * All rights reserved.
 *
 * This program is free software; you can redistribute it and/or modify it
 * under the terms of the GNU Lesser General Public License as published by
 * the Free Software Foundation; either version 2.1 of the License, or (at
 * your option) any later version.
 *
 * This program is distributed in the hope that it will be useful, but
 * WITHOUT ANY WARRANTY; without even the implied warranty of MERCHANTABILITY
 * or FITNESS FOR A PARTICULAR PURPOSE. See the GNU Lesser General Public
 * License for more details.
 *
 * You should have received a copy of the GNU Lesser General Public License
 * along with this program; if not, write to the Free Software Foundation,
 * Inc., 51 Franklin St, Fifth Floor, Boston, MA 02110-1301, USA.
 *
 * In addition to releasing this program under the LGPL, the authors are
 * willing to dual-license it under other terms. You may contact the authors
 * of this project by writing to Wei Ye, USC/ISI, 4676 Admirality Way, Suite
 * 1001, Marina del Rey, CA 90292, USA.
 *
 *****
 *
 * The authors at USC have given a special exemption of their license
 * to allow those contents to be included here.
 *
 */

#ifndef __SCPCONSTANTS_H
#define __SCPCONSTANTS_H

#ifdef CC2420_DEF_CHANNEL
/*
 * Authors: Wei Ye
 *
 * Physical layer parameters
 */
enum
{
	PHY_BASE_PREAMBLE_LEN = 4,
	PHY_NUM_SYNC_BYTES = 1,
	PHY_MAX_PKT_LEN = 120,
	PHY_WAKEUP_DELAY = 2,
	PHY_TX_BYTE_TIME = 32,
	PHY_MAX_CS_EXT = 3,
	PHY_CS_SAMPLE_INTERVAL = 130,
	PHY_LOADTONE_DELAY = 1,
	PHY_BASE_PRE_BYTES = PHY_BASE_PREAMBLE_LEN + PHY_NUM_SYNC_BYTES
};
#else
#error PHY constants are not defined for this radio
#endif

/*
 * Authors: Wei Ye
 *
 * SCP-MAC constants that can be used by applications
 */
enum
{
	LPL_MIN_POLL_BYTES = 1,
	LPL_MAX_POLL_BYTES = LPL_MIN_POLL_BYTES + PHY_MAX_CS_EXT,

	SCP_GUARD_TIME = 4,
	SCP_TONE_CONT_WIN = 7,
	SCP_PKT_CONT_WIN = 15,
	SCP_NUM_HI_RATE_POLL = 3,
	
	// TODO: fix once RTS/CTS is added
	DIFS = 2,
	CSMA_RTS_DURATION = 0,
	CSMA_CTS_DURATION = 0,
	CSMA_ACK_DURATION = 0,
	CSMA_PROCESSING_DELAY = 0,
	
	MAX_BASE_PKT_LEN = PHY_BASE_PRE_BYTES + PHY_MAX_PKT_LEN,
	WAKEUP_DELAY_BYTES = PHY_WAKEUP_DELAY * 1024 / PHY_TX_BYTE_TIME + 1,
	MIN_TONE_LEN = PHY_MAX_CS_EXT + WAKEUP_DELAY_BYTES + LPL_MAX_POLL_BYTES +
		SCP_GUARD_TIME,
	TX_TIME_SCHED = (SCP_TONE_CONT_WIN + 1 + PHY_MAX_CS_EXT) *
		PHY_CS_SAMPLE_INTERVAL / 1000 + 1 + PHY_LOADTONE_DELAY,
	
	MAX_TONE_TIME = PHY_TX_BYTE_TIME /* * PHY_NUMBER_OF_TONES */ *
		MAX_BASE_PKT_LEN / 1000 + 1 + PHY_LOADTONE_DELAY,
	MAX_CS_WAKEUP_TIME = PHY_WAKEUP_DELAY +
		(SCP_TONE_CONT_WIN + 1 + SCP_PKT_CONT_WIN + DIFS + PHY_MAX_CS_EXT) * PHY_CS_SAMPLE_INTERVAL / 1000 +
		1  + MIN_TONE_LEN * PHY_TX_BYTE_TIME / 1000 + 1,
	MAX_BCAST_TIME = MAX_CS_WAKEUP_TIME + MAX_TONE_TIME +
		MAX_BASE_PKT_LEN * PHY_TX_BYTE_TIME / 1000 + 1,
	MAX_UCAST_TIME = MAX_BCAST_TIME + CSMA_RTS_DURATION + CSMA_CTS_DURATION  +
		CSMA_ACK_DURATION + CSMA_PROCESSING_DELAY * 4,
	HI_RATE_POLL_PERIOD = MAX_UCAST_TIME,
};

enum
{
	S_IDLE = 0,
	S_BUFFERED = 1,
	S_STARTING = 2,
	S_PREAMBLE = 3,
	S_PACKET = 4,
	S_STOPPED = 5,
	S_BOOTING = 6,
};

enum
{
	AM_PREAMBLEPACKET = 199,
};

#endif
