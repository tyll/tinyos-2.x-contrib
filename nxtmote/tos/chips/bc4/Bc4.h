/*
 * Copyright (c) 2007 nxtmote project
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
 * - Neither the name of the project nor the names of
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
 * @author Rasmus Ulslev Pedersen
 */

#ifndef __BC4_H__
#define __BC4_H__

/**
 * Bc4 header.
 */
typedef nx_struct bc4_header_t {
  nxle_uint8_t length;
  nxle_uint16_t destpan; // Keeping it
  nxle_uint16_t dest;
  nx_uint8_t btdest[SIZE_OF_BDADDR];  // bt
  nxle_uint16_t src;
  nx_uint8_t btsrc[SIZE_OF_BDADDR];   // bt
  nxle_uint8_t type;
} bc4_header_t;

/**
 * bc4 Packet Footer
 */
typedef nx_struct bc4_footer_t {
} bc4_footer_t;

/**
 * BC4 Packet metadata.
 * It has the full BT address.
 */
typedef nx_struct bc4_metadata_t {
} bc4_metadata_t;


//typedef nx_struct bc4_packet_t {
//  bc4_header_t packet;
//  nx_uint8_t data[];
//} bc4_packet_t;


#ifndef TOSH_DATA_LENGTH
#define TOSH_DATA_LENGTH 28
#endif

enum {
  // size of the header not including the length byte
  BC4_HEADER_SIZE = sizeof( bc4_header_t ),// - 1,
  BC4_FOOTER_SIZE = 0,
  // MDU
  BC4_PACKET_SIZE = BC4_HEADER_SIZE + TOSH_DATA_LENGTH + BC4_FOOTER_SIZE
};

#endif
