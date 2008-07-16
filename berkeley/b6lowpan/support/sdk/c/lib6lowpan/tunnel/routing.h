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
#ifndef __ROUTING_H_
#define __ROUTING_H_

#include <IP.h>
#include <string.h>

enum {
  ROUTE_NO_ROUTE,
  ROUTE_ONEHOP,
  ROUTE_MHOP,
};


uint8_t routing_init();

/*
 * @returns: truth value indicating if the destination of the packet
 * is a single hop, and requires no source route.
 */
uint8_t routing_is_onehop(ip_msg_t *msg);


/*
 * Copys the IP message at orig to the empty one at ret, inserting
 * necessary routing information.
 */
uint8_t routing_insert_route(ip_msg_t *orig, ip_msg_t *ret);

/*
 * Returns the address of the next router this packet should be send to.
 */
hw_addr_t routing_get_nexthop(ip_msg_t *msg);


void routing_add_source_header(struct source_header *sh);

#endif 
