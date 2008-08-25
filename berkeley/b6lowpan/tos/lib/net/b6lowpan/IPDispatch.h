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

enum {
  N_PARENTS = 3,
  N_EPOCHS = 1,
  N_RECONSTRUCTIONS = 2,
  N_FORWARD_ENT = 3,
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

enum {
  // store the top-k neighbors.  This could be a poor topology
  // formation critera is very dense networks.  we may be able to
  // really use the fact that the "base" has infinite memory.
  N_NEIGH = 5,
  N_FLOW_ENT = 6,
  N_FLOW_CHOICES = 2,
  T_INVAL_NEIGH = 0xfffe,
};

typedef struct {
  hw_addr_t dest[N_FLOW_CHOICES];
  uint8_t   current:4;
  uint8_t   nchoices:4;
  uint8_t   retries;
  uint8_t   delay;
} send_policy_t;

typedef struct {
  send_policy_t policy;
  uint8_t frags_sent;
  bool failed;
  uint8_t refcount;
} send_info_t;

typedef struct {
  send_info_t *info;
  message_t  *msg;
} send_entry_t;

typedef struct {
  uint8_t timeout;
  hw_addr_t l2_src;
  uint16_t old_tag;
  uint16_t new_tag;
  send_info_t *s_info;
} forward_entry_t;

// Need to add another entry to avoid useless padding
//  Or can make sure that the flow_table has an even
//  number of entries.
struct flow_entry {
  uint8_t flags;
  cmpr_ip6_addr_t dest;
  cmpr_ip6_addr_t next_hops[N_FLOW_CHOICES];
};

struct neigh_entry {
  hw_addr_t neighbor;
  uint16_t linkEstimate;
};

struct route_table {
  uint8_t flags;
  uint8_t path_len;
  cmpr_ip6_addr_t dest;
  cmpr_ip6_addr_t hops[5];
};

typedef enum {
  S_FORWARD,
  S_REQ,
} send_type_t;


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
  nx_uint8_t fragpool;
  nx_uint8_t sendinfo;
  nx_uint8_t sendentry;
  nx_uint8_t sndqueue;
  nx_uint8_t encfail;
  nx_uint16_t heapfree;
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
