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
#ifndef _LIB6LOWPANIP_H_
#define _LIB6LOWPANIP_H_

#include "IP.h"

/*
 * This file presents an interface for parsing IP and UDP headers in a
 * 6loWPAN packet.  
 *
 * @author Stephen Dawson-Haggerty <stevedh@cs.berkeley.edu>
 */

extern uint8_t globalPrefix;
extern ip6_addr_t my_address;
extern uint8_t multicast_prefix[8];


uint8_t cmpPfx(ip6_addr_t a, uint8_t *pfx);


int getCompressedLen(packed_lowmsg_t *pkt);
uint8_t *packHeaders(ip_msg_t *msg, uint8_t *buf, uint8_t len);
uint8_t *unpackHeaders(packed_lowmsg_t *pkt, uint8_t *dest, uint16_t len);
int packs_header(ip_msg_t *msg);

#endif
