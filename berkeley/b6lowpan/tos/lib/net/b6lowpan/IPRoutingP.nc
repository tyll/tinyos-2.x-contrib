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

#include "IPDispatch.h"
#include "PrintfUART.h"

module IPRoutingP {
  provides interface StdControl;
  provides interface IPRouting;
  provides interface Statistics<route_statistics_t>;
  uses interface ICMP;
  uses interface Boot;

  uses interface Timer<TMilli> as SortTimer;

  uses interface Leds;
} implementation {

  uint8_t current_epoch;
  route_statistics_t stats;
  uint8_t last_hlim;

  bool soliciting, wasAbandoned;

  enum {
    S_RUNNING,
    S_STOPPED,
  };

  uint8_t state;

  // this is the routing table (k parents);
  struct route_entry table[N_PARENTS];

  struct flow_entry flow_table[N_FLOW_ENT];
  struct neigh_entry neigh_table[N_NEIGH];

  // struct route_entry route_table[N_ROUTES];

  uint16_t adjustLQI(uint8_t val) {
    uint16_t result = (80 - (val - 50));
    result = (((result * result) >> 3) * result) >> 3;  // result = (result ^ 3) / 64
    return result;
  }

  void clearStats(struct route_entry *r) {
    int j;
    for (j = 0; j < N_EPOCHS; j++) {
      r->stats[j].total   = 1;
      r->stats[j].success = 1;
    }
  }

  event void Boot.booted() {
    int i;
    for (i = 0; i < N_PARENTS; i++) {
      table[i].flags = 0;
      clearStats(&table[i]);
    }

//     for (i = 0; i < N_ROUTES; i++) {
//       route_table[i].flags = 0;
//     }

    for (i = 0; i < N_FLOW_ENT; i++) {
      flow_table[i].flags = 0;
    }

    for (i = 0; i < N_NEIGH; i++) {
      neigh_table[i].neighbor = T_INVAL_NEIGH;
    }

    current_epoch = 0;
    soliciting = FALSE;
    // boot with this true so the router will invalidate any state
    // associated from us when it gets the first packet.
    wasAbandoned = TRUE;
    call Statistics.clear();
    call SortTimer.startPeriodic(1024L * 30);

    state = S_RUNNING;
  }

  command error_t StdControl.start() {
    state = S_RUNNING;
  }

  command error_t StdControl.stop() {
    state = S_STOPPED;
  }
  
  command bool IPRouting.isForMe(struct ip6_hdr *hdr) {
    // the destination prefix is either link-local or global, or
    // multicast (we accept all multicast packets), and the suffix is
    // me.
    return (((cmpPfx(my_address, hdr->dst_addr) || cmpPfx(linklocal_prefix, hdr->dst_addr)) 
             && cmpPfx(&my_address[8], &hdr->dst_addr[8])) 
            || cmpPfx(multicast_prefix, hdr->dst_addr));
  }

  struct route_entry *getEntryRank(uint8_t rank) {
    int i;
    for (i = 0; i < N_PARENTS; i++) {
      if ((table[i].flags & T_VALID_MASK) && (table[i].flags & T_RANK_MASK) == rank)
        return &(table[i]);
    }
    return NULL;
  }

  struct route_entry *getEntry(hw_addr_t a) {
    int i;
    for (i = 0; i < N_PARENTS; i++) {
      if (table[i].neighbor == a)
        return &(table[i]);
    }
    return NULL;
  }

  void printTable() {
    int i;
    printfUART("ind\tvalid\trank\tneigh\tmetric\trssi\n");
    for (i = 0; i < N_PARENTS; i++) {
      printfUART("0x%x\t0x%x\t0x%x\t0x%x\t0x%x\t0x%x\n", i, (table[i].flags & T_VALID_MASK), (table[i].flags & T_RANK_MASK),
                 table[i].neighbor, table[i].hops, table[i].costEstimate + table[i].linkEstimate);
    }
  }

  uint16_t getMetric(struct route_entry *r) {
    return r->costEstimate + r->linkEstimate;
  }


  // #define LQI_COMPARE

  // stupid sort of table entries...
  void sortTable() {
    uint8_t i,j, rank;
    uint32_t m1, m2;
#ifdef LQI_COMPARE
    uint32_t lg, sm, bound;
#endif
    for (i = 0; i < N_PARENTS; i++) {
      rank = 0;
      if ((table[i].flags & T_VALID_MASK) == 0) continue;
      
      for (j = 0; j < N_PARENTS; j++) {
        if (i == j) continue;
        if ((table[j].flags & T_VALID_MASK) == 0) continue;
        m1 = (uint32_t)getMetric(&table[j]);
        m2 = (uint32_t)getMetric(&table[i]);

#ifdef LQI_COMPARE
        lg = (m1 >  m2)  ? m1 : m2;
        sm = (m1 <= m2)  ? m1 : m2;
        bound = lg - (lg >> 2);

        // this is similar to what MultiHopLQI does to prevent loops,
        // but since we are sorting, it's necessary that the
        // comparison is symmetric.  Hence the change.
        // this compares the metrics: kind of hacked; 
        // it is the same thing MultiHopLQI does, as a start.
        //  use hop count as a tie breaker
        if (sm < bound) {
          if (lg == m2)
            rank ++;
        } else if (sm >= bound && sm <= lg) {
          if (table[j].linkEstimate < table[i].linkEstimate) rank++;
          if (table[j].linkEstimate == table[i].linkEstimate &&
              i < j) rank ++;
        }
#else
        if (m1 < m2 || (m1 == m2 && i < j))
          rank++;
#endif
      }
      table[i].flags &= ~T_RANK_MASK;
      table[i].flags |= rank & T_RANK_MASK;
    }
  }

  
  /*
   * return: a send policy for a given attempt, including destination and one-hop neighbor.
   *        if no default route is available, returns FAIL unless the
   *        packet is destined to a link-local address, or a
   *        all-node/all-routers local multicast group.
   *
   */
  command error_t IPRouting.getNextHop(struct ip6_hdr *hdr, struct source_header *sh,
                                       send_policy_t *ret) {
    
    // AT: Before trying the default route, we need to look for any matching flow table entries.  Code could be similar to this:
    // int i,c;
    // for (i = 0; i < N_FLOW_ENT; i++) {
    //   if (((flow_table[i].src == N_INVAL_ENT) || (flow_table[i].src == a->hdr.src_addr)) && \\
    //       ((flow_table[i].prev_hop == N_INVAL_ENT) || (flow_table[i].prev_hop == a->metadata.sender))) {
    //         if (flow_table[i].dest[0] == N_INVAL_ENT) {
    //           ret->retries = 4;
    //           ret->delay = 10;
    //           ret->dest = flow_table[i].next_hop;
    //           return SUCCESS;
    //         }
    //         for (c = 0; c < N_DEST; c++) {
    //           if (flow_table[i].dest[c] == a->hdr.dest_addr) {
    //             ret->retries = 4;
    //             ret->delay = 10;
    //             ret->dest = flow_table[i].next_hop;
    //             return SUCCESS;
    //           }
    //         }
    //   }
    // }
    //
    // This code is not the most inefficient.  For one, the source address and dest address compared here are the full 16 byte addresses.  However the flow
    //  entry table only holds 16-bit addresses, so these will have to be converted.
    //
    // Furthermore, this code has two other shortcomings: a) it is not designed to handle cases where multiple flow entries could match.  Also, b) some mechanism
    //  has to be derived for not using the same flow entry multiple times and resetting the attempt value correctly, otherwise when defaulting to the parent
    //  oriented route we'll skip over the best parent.  We need to define the semantics of the flags for each entry, and utilize these to solve these two problems.



    ret->retries = 6;
    ret->delay = 10;
    ret->current = 0;
    ret->nchoices = 1;

    // we only use the address in the source header if the record option is not used
    // otherwise, we use normal routing.

    if (hdr->nxt_hdr == NXTHDR_SOURCE && (sh->dispatch & IP_EXT_SOURCE_RECORD_MASK) != IP_EXT_SOURCE_RECORD) {
      // if it's source routed, grab the next address out of the header.

      // if (sh->current == sh->nentries) return FAIL;

      ret->dest[0] = ntoh16(sh->hops[sh->current]);

      printfUART("using source route\n");
      printfUART("source dispatch: 0x%x\n", sh->dispatch);

      
    } else if (cmpPfx(hdr->dst_addr, multicast_prefix)) {
      // if it's multicast, for now, we send it to the local broadcast
      ret->dest[0] = 0xffff;
      ret->retries = 0;
      ret->delay = 0;
    } else if (cmpPfx(hdr->dst_addr, linklocal_prefix)) {
      ret->dest[0] = (hdr->dst_addr[14] << 8) | hdr->dst_addr[15];
    } else {
      int i;
      struct route_entry *r;
      
      printfUART("flags: 0x%x neigh: 0x%x\n", r->flags, r->neighbor);
      // otherwise, it's the default route.
      ret->current = 0;
      ret->nchoices = 0;

      for (i = 0; i < N_FLOW_CHOICES; i++) {
        r = getEntryRank(i);
        if (r == NULL) break;
        // if (r->neighbor == a->metadata.sender) return FAIL;
        ret->dest[i] = r->neighbor;
        ret->nchoices++;
      }
      ret->retries = 4;
      if (ret->nchoices == 0) return FAIL;
    }
    return SUCCESS;
  }

  command uint8_t IPRouting.getHopLimit() {
    // advertise our best path to the root
    struct route_entry *r = getEntryRank(0);
    if (r != NULL)
      return (r->hops + 1);
    else return 0xf0;
  }

  command uint16_t IPRouting.getQuality() {
    struct route_entry *r = getEntryRank(0);
    if (r != NULL)
      return getMetric(r);
    else return 0xffff;
  }
  

  command void IPRouting.reportAdvertisement(hw_addr_t neigh, uint8_t hops, 
                                             uint8_t lqi, uint16_t cost) {
    int i, place = N_PARENTS;
    printfUART("report adv: 0x%x 0x%x 0x%x 0x%x\n", neigh, hops, lqi, cost);

    for (i = 0; i < N_PARENTS; i++) {
      if (table[i].neighbor == neigh && (table[i].flags & T_VALID_MASK)) {
        // if a neighbor is reporting a hop limit, update their entry
        place = i;
        break;
      } else if ((table[i].flags & T_VALID_MASK) == 0 ||
                 getMetric(&table[i]) > adjustLQI(lqi) + cost) {
        place = i;
      }
    }
    printfUART("found place: 0x%x\n", place);
    if (place < N_PARENTS) {
      printfUART("inserting... 0x%x 0x%x\n", neigh, hops);

      if ((table[place].flags & T_VALID_MASK) == 0)
        clearStats(&table[place]);

      table[place].flags |= T_VALID_MASK | T_MARKED_MASK;
      table[place].neighbor = neigh;
      table[place].hops = hops;
      table[place].costEstimate = cost;
      table[place].linkEstimate = adjustLQI(lqi);
    }
    sortTable();
    printTable();
  }

  command void IPRouting.reportReception(hw_addr_t neigh, uint8_t lqi) {
    struct route_entry *e = getEntry(neigh);
    if (e != NULL)
      e->linkEstimate = adjustLQI(lqi);
  }

  void reportAbandonment() {
    int i;

    printfUART("abandoned-- all parents failed\n");

    if (soliciting || state == S_STOPPED) return;
    call Leds.led1Toggle();

    // unmark all the entries
    for (i = 0; i < N_PARENTS; i++)
      table[i].flags &= ~T_MARKED_MASK;

    printTable();

    soliciting = TRUE;
    wasAbandoned = TRUE;
    call ICMP.sendSolicitations();
  }

  command void IPRouting.reportTransmission(send_policy_t *policy) {
    if (policy->dest[0] != HW_BROADCAST_ADDR) {
      if (policy->nchoices == policy->current) {
        reportAbandonment();
      } else {
        wasAbandoned = FALSE;
      }
    }
//     struct route_entry *r;
//     if (policy == NULL) return;
//     r = getEntry(policy->dest);
//     if (r == NULL) return;


//     r->stats[current_epoch].total++;
//     if (wasDelivered) {
//       r->stats[current_epoch].success++;

//       // unset this here; since we successfully sent a packet towards
//       // the default route.
//       wasAbandoned = FALSE;
//     }
//     // TODO : update counters

  }

  /*
   * @returns TRUE if the routing engine has established a default route.
   */
  command bool IPRouting.hasRoute() {    
    struct route_entry *re = getEntryRank(0);
    return (re != NULL);
  }

  command void IPRouting.insertRoutingHeaders(struct split_ip_msg *msg) {
    static uint8_t sh_buf[14];
    static struct generic_header record_route;
    struct source_header *sh = (struct source_header *)sh_buf;

    if (msg->hdr.nxt_hdr != IANA_UDP) return;

    // this inserts a source header with the record route option set
    // on all outgoing packets.  look how easy it is!

    sh->len = 14;
    sh->current = 0;
    sh->dispatch = IP_EXT_SOURCE_RECORD;
    if (wasAbandoned)
      sh->dispatch |= IP_EXT_SOURCE_INVAL;

    if (msg->hdr.nxt_hdr != NXTHDR_SOURCE) {
      sh->nxt_hdr = msg->hdr.nxt_hdr;
      msg->hdr.nxt_hdr = NXTHDR_SOURCE;
      record_route.hdr.ext = (struct ip6_ext *)sh;
      record_route.len = 14;
      record_route.next = msg->headers;
      msg->headers = &record_route;
    }
  }

  event void SortTimer.fired() {
    sortTable();
    if (call IPRouting.getHopLimit() != last_hlim && state == S_RUNNING)
      call ICMP.sendAdvertisements();
    last_hlim = call IPRouting.getHopLimit();
  }

  /*
   * This is called when the ICMP engine finishes sending out router solicitations.
   *
   * We will keep sending solicitations so long as we have not
   * established a default route.
   */
  event void ICMP.solicitationDone() {
    int i;

    printfUART("done soliciting\n");

    soliciting = FALSE;
    // invalidate entries where we didn't hear from them
    for (i = 0; i < N_PARENTS; i++) {
      if ((table[i].flags & T_MARKED_MASK) == 0) {
        table[i].flags &= ~T_VALID_MASK;
      }
    }

    printTable();

    if (!call IPRouting.hasRoute() && state == S_RUNNING)
      call ICMP.sendSolicitations();
  }

  command route_statistics_t *Statistics.get() {
    struct route_entry *p = getEntryRank(0);
    stats.hop_limit = call IPRouting.getHopLimit();
    if (p != NULL) {
      ip_memcpy(&stats.parent, p, sizeof(struct route_entry));
      stats.parentmetric = getMetric(p);
    }
    return &stats;
  }

  command void Statistics.clear() {
    ip_memclr((uint8_t *)&stats, sizeof(route_statistics_t));
  }
}
