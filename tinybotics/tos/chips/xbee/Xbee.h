/*
 * Copyright (c) 2005-2006 Arch Rock Corporation
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
 * - Neither the name of the Arch Rock Corporation nor the names of
 *   its contributors may be used to endorse or promote products derived
 *   from this software without specific prior written permission.
 *
 * THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS
 * ``AS IS'' AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT
 * LIMITED TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS
 * FOR A PARTICULAR PURPOSE ARE DISCLAIMED.  IN NO EVENT SHALL THE
 * ARCHED ROCK OR ITS CONTRIBUTORS BE LIABLE FOR ANY DIRECT, INDIRECT,
 * INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES
 * (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR
 * SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION)
 * HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT,
 * STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE)
 * ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED
 * OF THE POSSIBILITY OF SUCH DAMAGE
 *
 * Copyright (c) 2007 University of Padova
 * Copyright (c) 2007 Orebro University
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
 * - Neither the name of the the copyright holders nor the names of
 *   their contributors may be used to endorse or promote products derived
 *   from this software without specific prior written permission.
 *
 * THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS
 * ``AS IS'' AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT
 * LIMITED TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS
 * FOR A PARTICULAR PURPOSE ARE DISCLAIMED.  IN NO EVENT SHALL THE COPYRIGHT
 * HOLDERS OR THEIR CONTRIBUTORS BE LIABLE FOR ANY DIRECT, INDIRECT,
 * INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES
 * (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR
 * SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION)
 * HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT,
 * STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE)
 * ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED
 * OF THE POSSIBILITY OF SUCH DAMAGE.
 */

/*
 * XBee packet format (CC2420-like)
 *
 * @author Jonathan Hui <jhui@archrock.com>
 * @author David Moss
 * @author Mirko Bordignon <mirko.bordignon@ieee.org>
 */

#ifndef __XBEE_H__
#define __XBEE_H__

#include "AM.h"

/* header - we take into account possible usage of 64-bit addressing modes in the future*/

enum xbee_api_enums {
  XBEE_API_MODEM_STATUS = 0x8A,
  XBEE_API_AT_COMMAND = 0x08,
  XBEE_API_AT_COMMAND_QUEUE = 0x09,
  XBEE_API_AT_COMMAND_RESPONSE = 0x88,
  XBEE_API_TX_64BIT = 0x00,
  XBEE_API_TX_16BIT = 0x01,
  XBEE_API_TX_STATUS = 0x89,
  XBEE_API_RX_64BIT = 0x80,
  XBEE_API_RX_16BIT = 0x81,
};

enum xbee_ascii_enums {
  ASCII_A = 0x41,
  ASCII_C = 0x43,
  ASCII_D = 0x44,
  ASCII_H = 0x48,
  ASCII_I = 0x49,
  ASCII_L = 0x4C,
  ASCII_M = 0x4D,
  ASCII_P = 0x50,
  ASCII_Y = 0x59,
  ASCII_T = 0x54,
};

#define XBEE_16BIT_ADDRESSING

#ifdef XBEE_16BIT_ADDRESSING
  #define ADDRESS_LENGTH 2
  #define XBEE_API_TX XBEE_API_TX_16BIT
#endif
#ifdef XBEE_64BIT_ADDRESSING
  #define ADDRESS_LENGTH 8
  #define XBEE_API_TX XBEE_API_TX_64BIT
#endif

// the active message (AM) format
typedef nx_struct xbee_header {
  nx_uint8_t api;

#ifdef XBEE_16BIT_ADDRESSING
  nx_uint8_t opt[4];
#endif

#ifdef XBEE_64BIT_ADDRESSING
  nx_uint8_t opt[10];
#endif

  /** I-Frame 6LowPAN interoperability byte */
#ifdef XBEE_IFRAME_TYPE
  nx_uint8_t network;
#endif

  nx_am_id_t type;
} xbee_header_t;

typedef nx_struct xbee_footer {
} xbee_footer_t;

typedef nx_struct xbee_metadata {
  nx_uint8_t length;
  //nx_uint8_t dsn;      // sequence numer = frame id
  nx_bool ack;             // TRUE=packet was acked
  nx_bool ack_req;         // TRUE=ack requested for this packet
  nx_uint8_t rssi;

  /** Packet Link Metadata */
#ifdef PACKET_LINK
  nx_uint16_t maxRetries;
  nx_uint16_t retryDelay;
#endif

} xbee_metadata_t;

typedef nx_struct xbee_packet_t {
  xbee_header_t header;
  nx_uint8_t data[];
} xbee_packet_t;


// the service and status message (SM) format
// (status reports, module configuration, op status, etc)

typedef nx_struct xbee_service_header {
  nx_uint8_t api;
} xbee_service_header_t;

typedef nx_struct xbee_service_packet_t {
  xbee_service_header_t header;
  nx_uint8_t data[];
} xbee_service_packet_t;


// the payload structure of a status message
/*
typedef nx_struct statusMsg {
  nx_uint8_t frameID;
  nx_uint8_t status;
} statusMsg;
*/

#ifndef TOSH_DATA_LENGTH
#define TOSH_DATA_LENGTH 28
#endif

#ifndef XBEE_DEF_CHANNEL
#define XBEE_DEF_CHANNEL 26
#endif

#ifndef XBEE_DEF_RFPOWER
#define XBEE_DEF_RFPOWER 4  // 0 dBm, as CC2420's default
#endif

/**
 * Ideally, your receive history size should be equal to the number of
 * RF neighbors your node will have
 */
#ifndef RECEIVE_HISTORY_SIZE
#define RECEIVE_HISTORY_SIZE 4
#endif

/** 
 * The 6LowPAN ID has yet to be defined for a TinyOS network.
 */
#ifndef TINYOS_6LOWPAN_NETWORK_ID
#define TINYOS_6LOWPAN_NETWORK_ID 0x0
#endif



// message_t type dispatch

enum {
  XBEE_ACTIVE_MESSAGE_ID = 0,
  XBEE_TX_STATUS_MESSAGE_ID = 1,
  XBEE_AT_STATUS_MESSAGE_ID = 2,
  XBEE_SERVICE_MESSAGE_ID = 3,
  XBEE_UNKNOWN_ID = 255,
};

#endif
