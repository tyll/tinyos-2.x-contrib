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

#include <lib6lowpanFrag.h>

enum {
  N_PARENTS = 3,
  N_EPOCHS = 1,
};

struct epoch_stats {
  uint8_t success;
  uint8_t total;
};

enum {
  T_RANK_MASK     = 0x03,
  T_VALID_OFFSET  = 2,
  T_VALID_MASK    = 1 << T_VALID_OFFSET,
  T_MARKED_OFFSET = 3,
  T_MARKED_MASK   = 1 << T_MARKED_OFFSET,
};

struct route_entry {
  // bit fields go first
  uint8_t flags;
  // the other fields
  hw_addr_t neighbor;
  uint8_t hops;
  uint16_t costEstimate;
  uint16_t linkEstimate;
  struct epoch_stats stats[N_EPOCHS];
}
#ifdef MIG
 __attribute__((packed));
#else
 ;
#endif


typedef enum {
  S_FORWARD,
  S_REQ,
} send_type_t;

typedef struct {
  hw_addr_t dest;
  uint8_t   retries;
  uint8_t   delay;
} send_policy_t;


typedef struct {
  ip_msg_t *msg;
  uint16_t len;
  fragment_t frag;
  send_policy_t dest;
  send_type_t type;
  uint8_t attempt;
} send_entry_t;

typedef nx_struct {
  nx_uint16_t sent;
  nx_uint16_t forwarded;
  nx_uint8_t rx_drop;
  nx_uint8_t tx_drop;
  nx_uint8_t fw_drop;
  nx_uint8_t rx_total;
  nx_uint8_t real_drop;
  nx_uint8_t hlim_drop;
  nx_uint8_t senddone_el;
} ip_statistics_t;


#ifdef MIG
typedef struct {
  uint8_t hop_limit;
  //uint8_t nvalid;
  struct route_entry parent;
  uint16_t parentmetric;
}  __attribute__((packed)) route_statistics_t;
#else
typedef nx_struct {
  nxle_uint8_t hop_limit;
/*   nxle_uint8_t nvalid; */
  nx_uint8_t parent[sizeof(struct route_entry)];
  nxle_uint16_t parentmetric;
} route_statistics_t;
#endif

typedef nx_struct {
/*   nx_uint8_t sol_rx; */
/*   nx_uint8_t sol_tx; */
/*   nx_uint8_t adv_rx; */
/*   nx_uint8_t adv_tx; */
/*   nx_uint8_t unk_rx; */
  nx_uint16_t rx;
} icmp_statistics_t;

typedef nx_struct {
  nx_uint16_t total;
  nx_uint16_t failed;
  nx_uint16_t seqno;
  nx_uint16_t sender;
} udp_statistics_t;

#endif
