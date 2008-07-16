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

#include <6lowpan.h>
#include <lib6lowpanFrag.h>
#include "in_cksum.h"
#include "PrintfUART.h"
#include "ICMP.h"

extern uint8_t multicast_prefix[8];

module ICMPResponderP {
  provides interface ICMP;
  provides interface Statistics<icmp_statistics_t>;
  uses interface IPSend;
  uses interface IPReceive;
  uses interface IPAddress;
  uses interface Leds;
  uses interface BufferPool;

  uses interface Timer<TMilli> as Solicitation;
  uses interface Timer<TMilli> as Advertisement;
  uses interface Random;

  uses interface IPRouting;
  uses interface BasicPacket as Packet;
  uses interface IPPacket;
} implementation {

  icmp_statistics_t stats;
  uint16_t solicitation_period;
  uint16_t advertisement_period;

  uint16_t icmp_cksum(ip_msg_t *buf, void *payload, uint16_t len) {
    vec_t cksum_vec[4];
    uint32_t hdr[2];
    int i, j;

    cksum_vec[0].ptr = (uint8_t *)(buf->hdr.src_addr);
    cksum_vec[0].len = 16;
    cksum_vec[1].ptr = (uint8_t *)(buf->hdr.dst_addr);
    cksum_vec[1].len = 16;
    cksum_vec[2].ptr = (uint8_t *)hdr;
    cksum_vec[2].len = 8;
    hdr[0] = hton32(len);
    hdr[1] = hton32(IANA_ICMP);
    cksum_vec[3].ptr = (uint8_t *)payload;
    cksum_vec[3].len = len;

    printfUART("cksum fields:\n");
    for (i = 0; i < 4; i++) {
      for (j = 0; j < cksum_vec[i].len; j++)
        printfUART("0x%x ", cksum_vec[i].ptr[j]);
      printfUART("\n");
    }


    return in_cksum(cksum_vec, 4);
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

  command void ICMP.sendTimeExceeded(ip_msg_t *msg) {
    ip_msg_t *newbuf;
    struct icmp6_hdr *i_hdr;
    uint16_t header_length = sizeof(struct ip6_hdr) // the ip header is returned
      + sizeof(struct icmp6_hdr) // an icmp header
      + 4; // and also a 4-byte empty field.
    uint16_t payload_length = 0;
    uint8_t *srcpayload = call Packet.getPayload(msg);

    if (call Packet.getPayloadLength(msg) < 64)
      payload_length = call Packet.getPayloadLength(msg);
    else
      payload_length = 64;

    newbuf = call BufferPool.get(header_length + payload_length);

    if (newbuf == NULL) return;

    i_hdr = call Packet.getPayload(newbuf);

    ip_memcpy(newbuf->hdr.src_addr, *(call IPAddress.getIPAddr()), 16);
    ip_memcpy(newbuf->hdr.dst_addr, msg->hdr.src_addr, 16);

    i_hdr->type = ICMP_TYPE_ECHO_TIME_EXCEEDED;
    i_hdr->code = ICMP_CODE_HOPLIMIT_EXCEEDED;

    ip_memclr((uint8_t *)(i_hdr + 1), 4);

    msg->hdr.plen = hton16(call Packet.getPayloadLength(msg));
    msg->hdr.nxt_hdr = call IPPacket.getNxtHdr(msg);

    // copy the IP header
    ip_memcpy(((uint8_t *)(i_hdr + 1)) + 4, &msg->hdr, sizeof(struct ip6_hdr));

    ip_memcpy(((uint8_t *)(i_hdr + 1)) + 4 + sizeof(struct ip6_hdr),
              srcpayload,
              payload_length);
    
    i_hdr->cksum = 0;
    i_hdr->cksum = hton16(icmp_cksum(newbuf, 
                                     (uint8_t *)i_hdr, payload_length + header_length));

    if (call IPSend.send(newbuf, payload_length + header_length) != SUCCESS)
      call BufferPool.put(newbuf);

  }
  /*
   * Solicitations
   */ 
  void sendSolicitation() {
    ip_msg_t *ipmsg = call BufferPool.get(sizeof(ip_msg_t) + sizeof(rsol_t));
    rsol_t *msg;
    if (ipmsg == NULL) return;
    msg = (rsol_t *)call Packet.getPayload(ipmsg);
    
    printfUART("Solicitation\n");
    //stats.sol_tx++;

    msg->type = ICMP_TYPE_ROUTER_SOL;
    msg->code = 0;
    msg->cksum = 0;
    msg->reserved = 0;
    
    // this is required for solicitation messages
    ipmsg->hdr.hlim = 0xff;

    memcpy(ipmsg->hdr.dst_addr, multicast_prefix, 8);
    ipmsg->hdr.dst_addr[15] = 2;
    memcpy(ipmsg->hdr.src_addr, *(call IPAddress.getIPAddr()), 16);

    msg->cksum = icmp_cksum(ipmsg, msg, sizeof(rsol_t));

    if (call IPSend.send(ipmsg, sizeof(rsol_t)) != SUCCESS)
      call BufferPool.put(ipmsg);
  }
  /*
   * Router advertisements
   */ 
  void handleRouterAdv(ip_msg_t *msg, void *payload, uint16_t len) {
    
    radv_t *r = (radv_t *)payload;
    pfx_t  *pfx = (pfx_t *)(r->options);
    struct ip_metadata *meta = call IPPacket.getMetadata(msg);
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
    ip_msg_t *ipmsg = call BufferPool.get(sizeof(ip_msg_t) + sizeof(radv_t) + sizeof(pfx_t) + sizeof(rqual_t));
    radv_t *r;
    pfx_t *p;
    uint16_t len = sizeof(radv_t);
    rqual_t *q;
    if (ipmsg == NULL) return;
    // don't sent the advertisement if we don't have a valid route
    if (!call IPRouting.hasRoute()) {
      call BufferPool.put(ipmsg);
      return;
    }


    //stats.adv_tx++;

    r = (radv_t *)call Packet.getPayload(ipmsg);
    p = (pfx_t *)r->options;
    q = (rqual_t *)(p + 1);
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
      call BufferPool.put(ipmsg);
      return;
    }

    if (call IPSend.send(ipmsg, len) != SUCCESS)
      call BufferPool.put(ipmsg);
  }

  event ip_msg_t *IPReceive.receive(ip_msg_t *buf, void *payload, uint16_t len) {
    icmp_echo_hdr_t *req = (icmp_echo_hdr_t *)payload;
    icmp_echo_hdr_t *reply;
    int i;

    reply = (icmp_echo_hdr_t *)payload;

    stats.rx++;

    // for checksum calculation

    printfUART ("icmp type: 0x%x code: 0x%x cksum: 0x%x ident: 0x%x seqno: 0x%x len: 0x%x\n",
                req->type, req->code, req->cksum, req->ident, req->seqno, len);


    printfUART("source:\t");
    for (i = 0; i < 16; i++) 
      printfUART("0x%x ", buf->hdr.src_addr[i]);
    printfUART("\ndest:\t");
    for (i = 0; i < 16; i++) 
      printfUART("0x%x ", buf->hdr.dst_addr[i]);
    printfUART("\n");

    if (req->type != ICMP_TYPE_ECHO_REQUEST) {
      if (req->type == ICMP_TYPE_ROUTER_ADV) {
        handleRouterAdv(buf, payload, len);
        //stats.adv_rx++;
      } else if (req->type == ICMP_TYPE_ROUTER_SOL) {
        // only reply to solicitations if we have established a default route.
        if (call IPRouting.hasRoute()) {
          call ICMP.sendAdvertisements();
        }
        //stats.sol_rx++;
      } else {
        //stats.unk_rx++;
      }
      return buf;
    }

    // swap the destinations
    memcpy(buf->hdr.dst_addr, buf->hdr.src_addr, 16);
    memcpy(buf->hdr.src_addr, *(call IPAddress.getIPAddr()), 16);

    reply->type = ICMP_TYPE_ECHO_REPLY;
    reply->code = 0;
    reply->cksum = 0;
    reply->cksum = icmp_cksum(buf, payload, len);

    if (call IPSend.send(buf, len) != SUCCESS) {
      return buf;
    }
    return NULL;
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


  
  event void IPSend.sendDone(ip_msg_t *payload, error_t error) {
    call BufferPool.put(payload);
  }


  command icmp_statistics_t *Statistics.get() {
    return &stats;
  }
  
  command void Statistics.clear() {
    ip_memclr((uint8_t *)&stats, sizeof(icmp_statistics_t));
  }
}
