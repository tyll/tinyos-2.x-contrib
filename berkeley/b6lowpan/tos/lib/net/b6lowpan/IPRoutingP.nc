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

#include <lib6lowpanFrag.h>
#include "IPDispatch.h"
#include "PrintfUART.h"

module IPRoutingP {
  provides interface IPRouting;
  provides interface Statistics<route_statistics_t>;
  uses interface ICMP;
  uses interface IPPacket;
  uses interface Boot;

  uses interface Timer<TMilli> as SortTimer;

  uses interface Leds;
} implementation {

  uint8_t current_epoch;
  route_statistics_t stats;
  uint8_t last_hlim;

  bool soliciting, wasAbandoned;

  // this is the routing table (k parents);
  struct route_entry table[N_PARENTS];

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
    current_epoch = 0;
    soliciting = FALSE;
    // boot with this true so the router will invalidate any state
    // associated from us when it gets the first packet.
    wasAbandoned = TRUE;
    call Statistics.clear();
    call SortTimer.startPeriodic(1024L * 30);
  }
  
  command bool IPRouting.isForMe(ip_msg_t *msg) {
    return (cmpPfx(my_address, msg->hdr.dst_addr) && cmpPfx(&my_address[8], &msg->hdr.dst_addr[8])) ||
      cmpPfx(multicast_prefix, msg->hdr.dst_addr);
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
  command error_t IPRouting.getNextHop(ip_msg_t *a, uint8_t attempt, send_policy_t *ret) {
    struct route_entry *r = getEntryRank(attempt);
    struct source_header *sh = (struct source_header *)a->data;

    printfUART("attempt: 0x%x flags: 0x%x neigh: 0x%x\n", attempt, r->flags, r->neighbor);

    ret->retries = 4;
    ret->delay = 10;

    // we only use the address in the source header if the record option is not used
    // otherwise, we use normal routing.

    if (a->hdr.nxt_hdr == NXTHDR_SOURCE && (sh->dispatch & IP_EXT_SOURCE_RECORD_MASK) != IP_EXT_SOURCE_RECORD) {
      // if it's source routed, grab the next address out of the header.

      if (sh->current == sh->nentries) return FAIL;

      ret->dest = ntoh16(sh->hops[sh->current]);

      // try harder for source routed packets, since if this attempt
      // fails we will drop the packet.
      ret->retries = 6;

      printfUART("using source route\n");
      printfUART("source dispatch: 0x%x\n", sh->dispatch);


    } else if (cmpPfx(a->hdr.dst_addr, multicast_prefix)) {
      // if it's multicast, for now, we send it to the local broadcast
      ret->dest = 0xffff;
      ret->retries = 0;
      ret->delay = 0;

    } else {

      // otherwise, it's the default route.
      if (ret == NULL || r == NULL) return FAIL;
      //if (r->neighbor == a->metadata.sender) return FAIL;
      

      ret->dest = r->neighbor;
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

  command void IPRouting.reportTransmission(send_policy_t *policy, bool wasDelivered) {
    struct route_entry *r;
    if (policy == NULL) return;
    r = getEntry(policy->dest);
    if (r == NULL) return;


    r->stats[current_epoch].total++;
    if (wasDelivered) {
      r->stats[current_epoch].success++;

      // unset this here; since we successfully sent a packet towards
      // the default route.
      wasAbandoned = FALSE;
    }
    // TODO : update counters

  }

  command void IPRouting.reportAbandonment() {
    int i;

    printfUART("abandoned-- all parents failed\n");

    if (soliciting) return;
    call Leds.led1Toggle();

    // unmark all the entries
    for (i = 0; i < N_PARENTS; i++)
      table[i].flags &= ~T_MARKED_MASK;

    printTable();

    soliciting = TRUE;
    wasAbandoned = TRUE;
    call ICMP.sendSolicitations();
  }

  command bool IPRouting.wasAbandoned() {
    return wasAbandoned;
  }

  /*
   * @returns TRUE if the routing engine has established a default route.
   */
  command bool IPRouting.hasRoute() {    
    struct route_entry *re = getEntryRank(0);
    return (re != NULL);
  }

  event void SortTimer.fired() {
    sortTable();
    if (call IPRouting.getHopLimit() != last_hlim)
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

    if (!call IPRouting.hasRoute())
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

//  LocalWords:  sucuseffully
