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

#include <stdint.h>
#include <stdio.h>
#include <stdlib.h>
#include <6lowpan.h>
#include <lib6lowpan.h>
#include "routing.h"
#include "nwstate.h"
#include "logging.h"

static hw_addr_t my_short_addr;

hw_addr_t l2fromIP(ip6_addr_t ip) {
  return ((uint16_t)ip[14] << 8)  | ip[15];
}

/*
 * Call to setup routing tables.
 *
 */
uint8_t routing_init() {
  nw_init();
  my_short_addr = l2fromIP(my_address);
  return 0;
}

/*
 * @returns: truth value indicating if the destination of the packet
 * is a single hop, and requires no source route.
 */
uint8_t routing_is_onehop(struct split_ip_msg *msg) {
  path_t *path;
  uint8_t ret = ROUTE_NO_ROUTE;

  if (cmpPfx(msg->hdr.dst_addr, multicast_prefix))
    return ROUTE_ONEHOP;

  path = nw_get_route(my_short_addr, l2fromIP(msg->hdr.dst_addr));
  
  if (path != NULL) {
    if (path->length == 1)
      ret = ROUTE_ONEHOP;
    else
      ret = ROUTE_MHOP;
  }
  debug("routing_is_onehop: 0x%x\n", ret);
  nw_free_path(path);
  return ret;
}


/*
 * Copys the IP message at orig to the empty one at ret, inserting
 * necessary routing information.
 */
uint8_t routing_insert_route(struct split_ip_msg *orig) {
  int offset = 0;
  path_t *path = nw_get_route(my_short_addr, l2fromIP(orig->hdr.dst_addr));
  path_t *i;
  struct generic_header *g_hdr = (struct generic_header *)malloc(sizeof(struct generic_header));
  struct source_header *sh;

  if (path == NULL || path->length == 1) {
    debug("no path needed\n");
    return 1;
  }
  debug("routing_insert_route len: 0x%x\n", path->length);

  // if the packet with the source route is longer then the buffer
  // we're putting it into, drop it.
  if (ntoh16(orig->hdr.plen) + sizeof(struct source_header) + 
      (path->length * sizeof(uint16_t)) + sizeof(struct ip6_hdr) > INET_MTU) {
    warn("packet plus source header too long\n");
    return 1;
  }
  
  sh = (struct source_header *)malloc(sizeof(struct source_header) + path->length * sizeof(uint16_t));
  if (sh == NULL || g_hdr == NULL) return 1;

  sh->nxt_hdr = orig->hdr.nxt_hdr;
  sh->len = sizeof(struct source_header) + (path->length * sizeof(uint16_t));
  sh->dispatch = IP_EXT_SOURCE_DISPATCH;
  sh->current = 0;
  
  orig->hdr.nxt_hdr = NXTHDR_SOURCE;

  fprintf(stderr, "to 0x%x [%i]: ", l2fromIP(orig->hdr.dst_addr), path->length);
  for (i = path; i != NULL; i = i->next) {
    fprintf(stderr, "0x%x ", i->node);
    sh->hops[offset++] = hton16(i->node);
    
  }
  fprintf(stderr, "\n");

  orig->hdr.plen = hton16(ntoh16(orig->hdr.plen) + sh->len);

  g_hdr->payload_malloced = 1;
  g_hdr->len = sh->len;
  g_hdr->hdr.sh = sh;
  g_hdr->next = orig->headers;
  orig->headers = g_hdr;

  nw_free_path(path);

  return 0;

}

/*
 * Returns the address of the next router this packet should be send to.
 */
hw_addr_t routing_get_nexthop(struct split_ip_msg *msg) {
  hw_addr_t ret = 0xffff;;
  path_t * path;
  if (cmpPfx(msg->hdr.dst_addr, multicast_prefix))
    return ret;

  path = nw_get_route(my_short_addr, l2fromIP(msg->hdr.dst_addr));

  if (path != NULL)
    ret = path->node;

  nw_free_path(path);

  return ret;
}

void routing_add_source_header(struct source_header *sh) {
  int i;

  if ((sh->dispatch & IP_EXT_SOURCE_RECORD_MASK) != IP_EXT_SOURCE_RECORD)
    return;

  if (sh->dispatch & IP_EXT_SOURCE_INVAL_MASK) {
    info("invalidating node 0x%x\n", ntoh16(sh->hops[0]));
    nw_inval_node(ntoh16(sh->hops[0]));
  }

  for (i = 0; i < sh->current - 1; i++) {
    nw_add_incr_edge(ntoh16(sh->hops[i]), ntoh16(sh->hops[i+1]));
  }
  if (sh->current < SH_NENTRIES(sh)) {
    nw_add_incr_edge(ntoh16(sh->hops[sh->current - 1]), 
                     l2fromIP(my_address));
  }
}
