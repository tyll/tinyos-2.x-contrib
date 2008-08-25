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

#include <lib6lowpan.h>
#include <6lowpan.h>
#include <ip_malloc.h>
#include "in_cksum.h"
#include "PrintfUART.h"
#include "ICMP.h"

extern uint8_t multicast_prefix[8];

module ICMPResponderP {
  provides interface ICMP;
  provides interface ICMPPing[uint16_t client];
  provides interface Statistics<icmp_statistics_t>;

  uses interface IP;
  uses interface IPAddress;

  uses interface Leds;

  uses interface Timer<TMilli> as Solicitation;
  uses interface Timer<TMilli> as Advertisement;
  uses interface Timer<TMilli> as PingTimer;
  uses interface LocalTime<TMilli>;
  uses interface Random;

  uses interface IPRouting;

} implementation {

  icmp_statistics_t stats;
  uint16_t solicitation_period;
  uint16_t advertisement_period;

  uint16_t ping_seq, ping_n, ping_rcv, ping_ident;
  ip6_addr_t ping_dest;

  uint16_t icmp_cksum(struct split_ip_msg *msg) {
    struct generic_header *cur;
    int n_headers = 4;
    vec_t cksum_vec[6];
    uint32_t hdr[2];

    cksum_vec[0].ptr = (uint8_t *)(msg->hdr.src_addr);
    cksum_vec[0].len = 16;
    cksum_vec[1].ptr = (uint8_t *)(msg->hdr.dst_addr);
    cksum_vec[1].len = 16;
    cksum_vec[2].ptr = (uint8_t *)hdr;
    cksum_vec[2].len = 8;
    hdr[0] = msg->data_len;
    hdr[1] = hton32(IANA_ICMP);
    cksum_vec[3].ptr = msg->data;
    cksum_vec[3].len = msg->data_len;

    cur = msg->headers;
    while (cur != NULL) {
      cksum_vec[n_headers].ptr = cur->hdr.data;
      cksum_vec[n_headers].len = cur->len;
      hdr[0] += cur->len;
      n_headers++;
      cur = cur->next;
    }
    hdr[0] = hton32(hdr[0]);

    return in_cksum(cksum_vec, n_headers);
  }


  command void ICMP.sendSolicitations() {
    uint16_t jitter = (call Random.rand16()) % TRICKLE_JITTER;
    if (call Solicitation.isRunning()) return;
    solicitation_period = TRICKLE_PERIOD;
    call Solicitation.startOneShot(jitter);
  }

  command void ICMP.sendAdvertisements() {
    uint16_t jitter = (call Random.rand16()) % TRICKLE_JITTER;
    if (call Advertisement.isRunning()) return;
    advertisement_period = TRICKLE_PERIOD;
    call Advertisement.startOneShot(jitter);
  }

  command void ICMP.sendTimeExceeded(struct ip6_hdr *hdr, unpack_info_t *u_info, uint16_t amount_here) {
    uint8_t i_hdr_buf[sizeof(struct icmp6_hdr) + 4];
    struct split_ip_msg *msg = (struct split_ip_msg *)ip_malloc(sizeof(struct split_ip_msg));
    struct generic_header g_hdr[3];
    struct icmp6_hdr *i_hdr = (struct icmp6_hdr *)i_hdr_buf;

    if (msg == NULL) return;

    printfUART("send time exceeded\n");

    msg->headers = NULL;
    msg->data = u_info->payload_start;
    msg->data_len = amount_here;

    // make sure to include the udp header if necessary
    if (u_info->nxt_hdr == IANA_UDP) {
      g_hdr[2].hdr.udp = u_info->nxt_hdr_ptr.udp;
      g_hdr[2].len = sizeof(struct udp_hdr);
      g_hdr[2].next = NULL;
      
      // since the udp headers are included in the offset we need to
      // add that length so the payload length in the encapsulated
      // packet will be correct.
      hdr->plen = hton16(ntoh16(hdr->plen) + sizeof(struct udp_hdr));
      msg->headers = &g_hdr[2];
    }
    // the fields in the packed packet is not necessarily the same as
    // the fields in canonical packet which was packed.  This is due
    // to the insertion of transient routing headers.
    hdr->nxt_hdr = u_info->nxt_hdr;
    hdr->plen = hton16(ntoh16(hdr->plen) - u_info->payload_offset);

    // the IP header is part of the payload
    g_hdr[1].hdr.data = (void *)hdr;
    g_hdr[1].len = sizeof(struct ip6_hdr);
    g_hdr[1].next = msg->headers;
    msg->headers = &g_hdr[1];

    // and is preceeded by the icmp time exceeded message
    g_hdr[0].hdr.data = (void *)i_hdr;
    g_hdr[0].len = sizeof(struct icmp6_hdr) + 4;
    g_hdr[0].next = msg->headers;
    msg->headers = &g_hdr[0];

    ip_memcpy(msg->hdr.src_addr, *(call IPAddress.getIPAddr()), 16);
    ip_memcpy(msg->hdr.dst_addr, hdr->src_addr, 16);

    i_hdr->type = ICMP_TYPE_ECHO_TIME_EXCEEDED;
    i_hdr->code = ICMP_CODE_HOPLIMIT_EXCEEDED;
    i_hdr->cksum = 0;
    ip_memclr((void *)(i_hdr + 1), 4);

    msg->hdr.nxt_hdr = IANA_ICMP;

    i_hdr->cksum = hton16(icmp_cksum(msg));

    call IP.send(msg);

    ip_free(msg);
  }
  /*
   * Solicitations
   */ 
  void sendSolicitation() {
    struct split_ip_msg *ipmsg = (struct split_ip_msg *)ip_malloc(sizeof(struct split_ip_msg) + sizeof(rsol_t));
    rsol_t *msg = (rsol_t *)(ipmsg + 1);

    if (ipmsg == NULL) return;

    printfUART("Solicitation\n");
    //stats.sol_tx++;

    msg->type = ICMP_TYPE_ROUTER_SOL;
    msg->code = 0;
    msg->cksum = 0;
    msg->reserved = 0;

    ipmsg->headers = NULL;
    ipmsg->data = (void *)msg;
    ipmsg->data_len = sizeof(rsol_t);
    
    // this is required for solicitation messages
    ipmsg->hdr.hlim = 0xff;

    ip_memclr(ipmsg->hdr.dst_addr, 16);
    memcpy(ipmsg->hdr.dst_addr, multicast_prefix, 8);
    ipmsg->hdr.dst_addr[15] = 2;
    memcpy(ipmsg->hdr.src_addr, *(call IPAddress.getIPAddr()), 16);

    msg->cksum = icmp_cksum(ipmsg);

    call IP.send(ipmsg);

    ip_free(ipmsg);
  }

  void sendPing(ip6_addr_t dest, uint16_t seqno) {
    struct split_ip_msg *ipmsg = (struct split_ip_msg *)ip_malloc(sizeof(struct split_ip_msg) + 
                                                                  sizeof(icmp_echo_hdr_t) + 
                                                                  sizeof(nx_uint32_t));
    icmp_echo_hdr_t *e_hdr = (icmp_echo_hdr_t *)ipmsg->next;
    nx_uint32_t *sendTime = (nx_uint32_t *)(e_hdr + 1);

    if (ipmsg == NULL) return;
    ipmsg->headers = NULL;
    ipmsg->data = (void *)e_hdr;
    ipmsg->data_len = sizeof(icmp_echo_hdr_t) + sizeof(nx_uint32_t);

    e_hdr->type = ICMP_TYPE_ECHO_REQUEST;
    e_hdr->code = 0;
    e_hdr->cksum = 0;
    e_hdr->ident = ping_ident;
    e_hdr->seqno = seqno;
    *sendTime = call LocalTime.get();

    memcpy(ipmsg->hdr.dst_addr, dest, 16);
    memcpy(ipmsg->hdr.src_addr, *(call IPAddress.getIPAddr()), 16);

    e_hdr->cksum = icmp_cksum(ipmsg);
    
    call IP.send(ipmsg);
    ip_free(ipmsg);
  }

  /*
   * Router advertisements
   */ 
  void handleRouterAdv(void *payload, uint16_t len, struct ip_metadata *meta) {
    
    radv_t *r = (radv_t *)payload;
    pfx_t  *pfx = (pfx_t *)(r->options);
    uint16_t cost = 0;
    rqual_t *beacon = (rqual_t *)(pfx + 1);

    if (len > sizeof(radv_t) + sizeof(pfx_t) && 
        beacon->type == ICMP_EXT_TYPE_BEACON) {
      cost = beacon->metric;
      printfUART(" * beacon cost: 0x%x\n", cost);
    } else 
        printfUART(" * no beacon cost\n");

    call IPRouting.reportAdvertisement(meta->sender, r->hlim,
                                       meta->lqi, cost);

    if (pfx->type != ICMP_EXT_TYPE_PREFIX) return;

    call IPAddress.setPrefix((uint8_t *)pfx->prefix);

    // TODO : get short address here...
  }

  void sendAdvertisement() {
    struct split_ip_msg *ipmsg = (struct split_ip_msg *)ip_malloc(sizeof(struct split_ip_msg) + 
                                                                  sizeof(radv_t) + 
                                                                  sizeof(pfx_t) +
                                                                  sizeof(rqual_t));
    uint16_t len = sizeof(radv_t);
    radv_t *r = (radv_t *)(ipmsg + 1);
    pfx_t *p = (pfx_t *)r->options;
    rqual_t *q = (rqual_t *)(p + 1);

    if (ipmsg == NULL) return;
    // don't sent the advertisement if we don't have a valid route
    if (!call IPRouting.hasRoute()) {
      ip_free(ipmsg);
      return;
    }

    r->type = ICMP_TYPE_ROUTER_ADV;
    r->code = 0;
    r->hlim = call IPRouting.getHopLimit();
    r->flags = 0;
    r->lifetime = 1;
    r->reachable_time = 0;
    r->retrans_time = 0;

    ipmsg->hdr.hlim = 0xff;
    
    if (globalPrefix) {
      len += sizeof(pfx_t);
      p->type = ICMP_EXT_TYPE_PREFIX;
      p->length = 8;
      memcpy(p->prefix, my_address, 8);
    }

    len += sizeof(rqual_t);
    q->type = ICMP_EXT_TYPE_BEACON;
    q->length = 2;
    q->metric = call IPRouting.getQuality();

    memcpy(ipmsg->hdr.src_addr, *(call IPAddress.getIPAddr()), 16);
    memcpy(ipmsg->hdr.dst_addr, multicast_prefix, 8);

    ip_memclr(&(ipmsg->hdr.dst_addr[8]), 8);
    ipmsg->hdr.dst_addr[15] = 1;

    printfUART("adv hop limit: 0x%x\n", r->hlim);

    if (r->hlim >= 0xf0) {
      ip_free(ipmsg);
      return;
    }

    r->cksum = 0;
    r->cksum = icmp_cksum(ipmsg);

    ipmsg->data = (void *)r;
    ipmsg->data_len = len;
    ipmsg->headers = NULL;

    call IP.send(ipmsg);
    ip_free(ipmsg);
  }


  event void IP.recvfrom(ip6_addr_t src, 
                         void *payload, uint16_t len, struct ip_metadata *meta) {
    icmp_echo_hdr_t *req = (icmp_echo_hdr_t *)payload;
    printfUART("icmp recv done: len: 0x%x\n", len);
    stats.rx++;
  
    // for checksum calculation
    printfUART ("icmp type: 0x%x code: 0x%x cksum: 0x%x ident: 0x%x seqno: 0x%x len: 0x%x\n",
                req->type, req->code, req->cksum, req->ident, req->seqno, len);

    switch (req->type) {
    case ICMP_TYPE_ROUTER_ADV:
        handleRouterAdv(payload, len, meta);
        //stats.adv_rx++;
        break;
    case ICMP_TYPE_ROUTER_SOL:
      // only reply to solicitations if we have established a default route.
      if (call IPRouting.hasRoute()) {
          call ICMP.sendAdvertisements();
      }
      break;
    case ICMP_TYPE_ECHO_REPLY:
      {
        nx_uint32_t *sendTime = (nx_uint32_t *)(req + 1);
        struct icmp_stats p_stat;
        p_stat.seq = req->seqno;
        p_stat.ttl = 0;// buf->hdr.hlim;
        p_stat.rtt = (call LocalTime.get()) - (*sendTime);
        signal ICMPPing.pingReply[req->ident](src, &p_stat);
        ping_rcv++;
      }
      break;
    case ICMP_TYPE_ECHO_REQUEST:
      {
        // send a ping reply.
        struct split_ip_msg msg;
        msg.headers = NULL;
        msg.data = payload;
        msg.data_len = len;
        memcpy(msg.hdr.src_addr, my_address, 16);
        memcpy(msg.hdr.dst_addr, src, 16);      
        
        req->type = ICMP_TYPE_ECHO_REPLY;
        req->code = 0;
        req->cksum = 0;
        req->cksum = icmp_cksum(&msg);
        
        // remember, this can't really fail in a way we care about
        call IP.send(&msg);
        break;
      }
    }
  }


  event void Solicitation.fired() {
    sendSolicitation();
    printfUART("solicitation period: 0x%x max: 0x%x\n", solicitation_period, TRICKLE_MAX);
    solicitation_period <<= 1;
    if (solicitation_period < TRICKLE_MAX) {
      call Solicitation.startOneShot(solicitation_period);
    } else {
      signal ICMP.solicitationDone();
    }
  }

  event void Advertisement.fired() {
    printfUART("==> Sending router advertisement\n");
    sendAdvertisement();
    advertisement_period <<= 1;
    if (advertisement_period < TRICKLE_MAX) {
      call Advertisement.startOneShot(advertisement_period);
    }
  }


  
  command error_t ICMPPing.ping[uint16_t client](ip6_addr_t target, uint16_t period, uint16_t n) {
    if (call PingTimer.isRunning()) return ERETRY;
    call PingTimer.startPeriodic(period);

    memcpy(ping_dest, target, 16);
    ping_n = n;
    ping_seq = 0;
    ping_rcv = 0;
    ping_ident = client;
  }

  event void PingTimer.fired() {
    // send a ping request
    if (ping_seq == ping_n) {
      signal ICMPPing.pingDone[ping_ident](ping_rcv, ping_n);
      call PingTimer.stop();
      return;
    }
    sendPing(ping_dest, ping_seq);
    ping_seq++;
  }



  command icmp_statistics_t *Statistics.get() {
    return &stats;
  }
  
  command void Statistics.clear() {
    ip_memclr((uint8_t *)&stats, sizeof(icmp_statistics_t));
  }

  default event void ICMPPing.pingReply[uint16_t client](ip6_addr_t source, 
                                                         struct icmp_stats *ping_stats) {
  }

  default event void ICMPPing.pingDone[uint16_t client](uint16_t n, uint16_t m) {

  }

}
