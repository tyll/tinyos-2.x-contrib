/*
 * "Copyright (c) 2008 The Regents of the University  of California.
 * All rights reserved."
 *
 * Permission to use, copy, modify, and distribute this software and its
 * documentation for any purpose, without fee, and without written agreement is
 * hereby granted, provided that the above copyright notice, the following
 * two paragraphs and the author appear in all copies of this software.
 *
 * IN NO EVENT SHALL THE UNIVERSITY OF CALIFORNIA BE LIABLE TO ANY PARTY FOR
 * DIRECT, INDIRECT, SPECIAL, INCIDENTAL, OR CONSEQUENTIAL DAMAGES ARISING OUT
 * OF THE USE OF THIS SOFTWARE AND ITS DOCUMENTATION, EVEN IF THE UNIVERSITY OF
 * CALIFORNIA HAS BEEN ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
 *
 * THE UNIVERSITY OF CALIFORNIA SPECIFICALLY DISCLAIMS ANY WARRANTIES,
 * INCLUDING, BUT NOT LIMITED TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY
 * AND FITNESS FOR A PARTICULAR PURPOSE.  THE SOFTWARE PROVIDED HEREUNDER IS
 * ON AN "AS IS" BASIS, AND THE UNIVERSITY OF CALIFORNIA HAS NO OBLIGATION TO
 * PROVIDE MAINTENANCE, SUPPORT, UPDATES, ENHANCEMENTS, OR MODIFICATIONS."
 *
 */
#ifndef _IPDISPATCH_H_
#define _IPDISPATCH_H_

#include <message.h>
#include <lib6lowpan.h>
#include <Statistics.h>

enum {
  N_NEXT_HOPS = 2,
  N_RECONSTRUCTIONS = 3,        /* number of concurrent reconstructions */
  N_CONCURRENT_SENDS = 3,       /* number of concurrent sends */
  N_FRAGMENTS = 12,             /* number of link-layer fragments to buffer */
};


typedef struct {
  // The extra 2 is because one dest could be from source route, other
  //  from the dest being a direct neighbor
  ieee154_addr_t dest[N_NEXT_HOPS];
  uint8_t   current:4;
  uint8_t   nchoices:4;
  uint8_t   retries;
  uint8_t   actRetries;
  uint16_t  delay;
} send_policy_t;

typedef struct {
  uint8_t link_fragments;
  uint8_t link_transmissions;
  uint8_t refcount;
  bool    failed;
} send_info_t;

typedef struct {
  send_info_t *info;
  message_t  *msg;
} send_entry_t;

typedef struct {
  uint8_t timeout;
  ieee154_saddr_t l2_src;
  uint16_t old_tag;
  uint16_t new_tag;
  send_info_t *s_info;
} forward_entry_t;

typedef enum {
  S_FORWARD,
  S_REQ,
} send_type_t;


#endif
