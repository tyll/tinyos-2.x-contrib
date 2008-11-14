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
#ifndef _IP_H_
#define _IP_H_

/*
 * define message structures for internet communication
 *
 */

#ifdef PC
#include <linux/if_tun.h>
#endif

#include "6lowpan.h"

enum {
  /*
   * The time, in binary milliseconds, after which we stop waiting for
   * fragments and report a failed receive.  We 
   */
  FRAG_EXPIRE_TIME = 4096,
};


/*
 * Definition for internet protocol version 6.
 * RFC 2460
 */
struct ip6_hdr {
  uint8_t   vlfc[4];
  uint16_t  plen;      /* payload length */
  uint8_t   nxt_hdr;       /* next header */
  uint8_t   hlim;      /* hop limit */
  ip6_addr_t src_addr; /* source address */
  ip6_addr_t dst_addr; /* destination address */
} __attribute__((packed));

#define IPV6_VERSION            0x6
#define IPV6_VERSION_MASK       0xf0


// AT: Needed to add this to fix some compile problems.  Only a HACK
#define IPv6_VERSION		0x6

/*
 * Extension Headers
 */

struct ip6_ext {
  uint8_t nxt_hdr;
  uint8_t len;
  uint8_t data[0];
};

/*
 * icmp
 */
struct  icmp6_hdr {
  uint8_t        type;     /* type field */
  uint8_t        code;     /* code field */
  uint16_t       cksum;    /* checksum field */
};

enum {
    ICMP_TYPE_ECHO_DEST_UNREACH     = 1,
    ICMP_TYPE_ECHO_PKT_TOO_BIG      = 2, 
    ICMP_TYPE_ECHO_TIME_EXCEEDED    = 3,
    ICMP_TYPE_ECHO_PARAM_PROBLEM    = 4,
    ICMP_TYPE_ECHO_REQUEST          = 128,
    ICMP_TYPE_ECHO_REPLY            = 129,
    ICMP_TYPE_ROUTER_SOL            = 133,
    ICMP_TYPE_ROUTER_ADV            = 134,
    ICMP_TYPE_NEIGHBOR_SOL          = 135,
    ICMP_TYPE_NEIGHBOR_ADV          = 136,
    ICMP_NEIGHBOR_HOPLIMIT          = 255,

    ICMP_CODE_HOPLIMIT_EXCEEDED     = 0,
    ICMP_CODE_ASSEMBLY_EXCEEDED     = 1,
};

/*
 * Udp protocol header.
 */
struct udp_hdr {
    uint16_t srcport;               /* source port */
    uint16_t dstport;               /* destination port */
    uint16_t len;                   /* udp length */
    uint16_t chksum;                /* udp checksum */
};


enum {
  TCP_FLAG_FIN = 0x1,
  TCP_FLAG_SYN = 0x2,
  TCP_FLAG_RST = 0x4,
  TCP_FLAG_PSH = 0x8,
  TCP_FLAG_ACK = 0x10,
  TCP_FLAG_URG = 0x20,
  TCP_FLAG_ECE = 0x40,
  TCP_FLAG_CWR = 0x80,
};

struct tcp_hdr {
  uint16_t srcport;
  uint16_t dstport;
  uint32_t seqno;
  uint32_t ackno;
  uint8_t offset;
  uint8_t flags;
  uint16_t window;
  uint16_t chksum;
  uint16_t urgent;
};

struct ip_metadata {
  hw_addr_t sender;
  uint8_t   lqi;
  uint8_t   padding[1];
};

enum {
  T_INVAL_NEIGH =  0xef,
  T_SET_NEIGH = 0xee,
};

struct flow_id {
  uint16_t src;
  uint16_t dst;
  uint16_t id;
  uint16_t seq;
  uint16_t nxt_hdr;
};


/*
 * These are data structures to hold IP messages.  We used a linked
 * list of headers so that we can easily add extra headers with no
 * copy.  Every split_ip_msg contains a full IPv6 header (40 bytes),
 * but it is placed at the end of the struct so that on the PC side we
 * can read() a message straight into one of these structs, and then
 * just set up the header chain.
 *
 */
struct generic_header {
#ifdef PC
  int payload_malloced:1;
#endif
  uint8_t len;
  union {
    // this could be an eumeration of all the valid headers we can have here.
    struct ip6_ext *ext;
    struct source_header *sh;
    struct udp_hdr *udp;
    struct rinstall_header *rih;
    struct topology_header *th;
    uint8_t *data;
  } hdr;
  struct generic_header *next;
};

struct split_ip_msg {
  struct generic_header *headers;
  uint16_t data_len;
  uint8_t *data;
#ifdef PC
  struct ip_metadata metadata;
#ifdef DBG_TRACK_FLOWS
  struct flow_id id;
#endif
  // this must be last so we can read() straight into the end of the buffer.
  struct tun_pi pi;
#endif
  struct ip6_hdr hdr;
  uint8_t next[0];
};

struct sockaddr_in6 {
  uint16_t sin_port;
  ip6_addr_t sin_addr;
};

/*
 * parse a string representation of an IPv6 address
 */ 
void inet6_aton(char *addr, ip6_addr_t dest);

#endif
