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

struct ip_metadata {
  hw_addr_t sender;
  uint8_t   lqi;
  uint8_t   padding[1];
};

typedef struct {
  uint16_t b_len;
  struct ip_metadata metadata;
#ifdef PC
  // if using the /dev/net/tun interface, add space for the strut pi
  // which comes before the actual packet.
  struct tun_pi pi;
#endif
  struct ip6_hdr hdr;
  uint8_t data[0];
} ip_msg_t;

typedef struct {
  uint16_t b_len;
  struct ip6_hdr ip_hdr;
  struct udp_hdr udp_hdr;
  uint8_t data[0];
} udp_msg_t;

#ifndef PC
struct sockaddr {
  uint16_t sin_port;
  ip6_addr_t sin_addr;
};

/*
 * parse a string representation of an IPv6 address
 */ 
void inet6_aton(char *addr, ip6_addr_t dest);
#endif

#endif
