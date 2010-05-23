/*
 * WMTP - Wireless Modular Transport Protocol
 *
 * Copyright (c) 2008 Luis D. Pedrosa and IT - Instituto de Telecomunicacoes
 *
 * This library is free software; you can redistribute it and/or
 * modify it under the terms of the GNU Lesser General Public
 * License as published by the Free Software Foundation; either
 * version 2.1 of the License, or (at your option) any later version.
 *
 * This library is distributed in the hope that it will be useful,
 * but WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the GNU
 * Lesser General Public License for more details.
 *
 * You should have received a copy of the GNU Lesser General Public
 * License along with this library; if not, write to the Free Software
 * Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA 02111-1307 USA
 *
 * Address:
 * Instituto Superior Tecnico - Taguspark Campus
 * Av. Prof. Dr. Cavaco Silva, 2744-016 Porto Salvo
 *
 * E-Mail:
 * luis.pedrosa@tagus.ist.utl.pt
 */

#ifndef __TESTWMTP_H__
#define __TESTWMTP_H__

#define LOGGER_DURATION 60
#define LOGGER_PERIOD (1024*2)
#define LOGGER_NUM_MONITORED_CONNECTIONS 3
#define LOGGER_WAIT_TIME 30720

enum {
	AM_EVENTMSG = 8,
};

// Event structure
typedef nx_struct EventRecord {
	nx_uint32_t time;
	nx_uint16_t nodeAddress;                            			 // The local node's address;
	nx_uint8_t minQueueAvailability;                    			 // Minimum queue availability.
	nx_uint16_t sntWmtpMsgCnt;                          			 // Number of sent WMTP Msgs.
	nx_uint16_t rcvdWmtpMsgCnt;                         			 // Number of received WMTP Msgs.
	nx_uint16_t genMsgCnt;                              			 // Number of generated messages.
	nx_uint16_t rcvdMsgCnts[LOGGER_NUM_MONITORED_CONNECTIONS]; // Number of received messages.
} EventRecord_t;

typedef nx_struct EventMsg {
	EventRecord_t EventRecord;
} EventMsg_t;

#define REPORTER_PERIOD 10240
#define REPORTER_NUM_MONITORED_CONNECTIONS 8

#endif // #define __TESTWMTP_H__