
/*
 * Copyright (c) 2006 Stanford University.
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
 * - Neither the name of the Stanford University nor the names of
 *   its contributors may be used to endorse or promote products derived
 *   from this software without specific prior written permission.
 *
 * THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS
 * ``AS IS'' AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT
 * LIMITED TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS
 * FOR A PARTICULAR PURPOSE ARE DISCLAIMED.  IN NO EVENT SHALL STANFORD
 * UNIVERSITY OR ITS CONTRIBUTORS BE LIABLE FOR ANY DIRECT, INDIRECT,
 * INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES
 * (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR
 * SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION)
 * HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT,
 * STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE)
 * ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED
 * OF THE POSSIBILITY OF SUCH DAMAGE.
 */

/*
 *  Header file that declares the AM types, message formats, and
 *  constants for the TinyOS reference implementation of the
 *  Collection Tree Protocol (CTP), as documented in TEP 123.
 *
 *  @author Philip Levis
 */

#ifndef CTP_H
#define CTP_H

#warning "Using IndustrialCtp"

#include "AM.h"

#define UQ_CTP_CLIENT "CtpSenderC.CollectId"

typedef nx_uint8_t nx_ctp_options_t;

typedef uint8_t ctp_options_t;

typedef uint8_t collection_id_t;

typedef nx_uint8_t nx_collection_id_t;


/** Number of entries in the neighbor table */
#ifndef NEIGHBOR_TABLE_SIZE
#define NEIGHBOR_TABLE_SIZE 20
#endif

#ifndef FORWARD_COUNT
#define FORWARD_COUNT 12
#endif

#ifndef CACHE_SIZE
#define CACHE_SIZE 5
#endif


/* 
 * These timings are in milliseconds, and are used by
 * ForwardingEngineP. Each pair of values represents a range of
 * [OFFSET - (OFFSET + WINDOW)]. The ForwardingEngine uses these
 * values to determine when to send the next packet after an
 * event. FAIL refers to a send fail (an error from the radio below),
 * NOACK refers to the previous packet not being acknowledged,
 * OK refers to an acknowledged packet, and LOOPY refers to when
 * a loop is detected.
 *
 * The default value works well with networks implementing low power listening.
 * If you are not implementing low power listening, try a value of 4 for 
 * CC2420 radios.
 */

#ifndef FORWARD_PACKET_TIME
#define FORWARD_PACKET_TIME 1024
#endif

enum {
  SENDDONE_FAIL_OFFSET      =                       512,
  SENDDONE_NOACK_OFFSET     = FORWARD_PACKET_TIME  << 2,
  SENDDONE_OK_OFFSET        = FORWARD_PACKET_TIME  << 2,
  LOOPY_OFFSET              = FORWARD_PACKET_TIME  << 4,
  SENDDONE_FAIL_WINDOW      = SENDDONE_FAIL_OFFSET  - 1,
  LOOPY_WINDOW              = LOOPY_OFFSET          - 1,
  SENDDONE_NOACK_WINDOW     = SENDDONE_NOACK_OFFSET - 1,
  SENDDONE_OK_WINDOW        = SENDDONE_OK_OFFSET    - 1,
  CONGESTED_WAIT_OFFSET     = FORWARD_PACKET_TIME  << 2,
  CONGESTED_WAIT_WINDOW     = CONGESTED_WAIT_OFFSET - 1,
};


/* 
 * The number of times the ForwardingEngine will try to 
 * transmit a packet before giving up if the link layer
 * supports acknowledgments. If the link layer does
 * not support acknowledgments it sends the packet once.
 */
enum {
  MAX_RETRIES = 30
};



enum {
    // AM types:
    AM_CTP_DATA    = 23,
    AM_CTP_ROUTING = 24,
    AM_CTP_DEBUG   = 25,

    // CTP Options:
    CTP_OPT_PULL      = 0x80, // TEP 123: P field
    CTP_OPT_ECN       = 0x40, // TEP 123: C field
};

typedef nx_struct {
  nx_ctp_options_t    options;
  nx_uint8_t          thl;
  nx_uint16_t         etx;
  nx_am_addr_t        origin;
  nx_uint8_t          originSeqNo;
  nx_collection_id_t  type;
  nx_uint8_t          data[0];
} ctp_data_header_t;

typedef nx_struct {
  nx_ctp_options_t    options;
  nx_am_addr_t        parent;
  nx_uint16_t         etx;
  nx_uint8_t          data[0];
} ctp_routing_header_t;

#endif
