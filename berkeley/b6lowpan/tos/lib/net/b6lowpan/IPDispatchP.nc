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
#include <lib6lowpanFrag.h>
#include <IP.h>
#include "IPDispatch.h"
#include "PrintfUART.h"

/*
 * Provides IP layer reception to applications on motes.
 *
 * @author Stephen Dawson-Haggerty <stevedh@cs.berkeley.edu>
 */

module IPDispatchP {
  provides {
    interface IPSend[uint8_t prot];
    interface IPReceive[uint8_t prot];
    
    interface BasicPacket;
    interface IPPacket;
    interface Statistics<ip_statistics_t>;
  }
  uses {
    interface Boot;
    interface SplitControl as RadioControl;

    interface IEEE154Packet;
    interface CC2420Packet;
    interface Packet;

    interface IEEE154Send;
    interface Receive as IEEE154Receive;

    interface PacketLink;
    interface CC2420Config;


    interface Pool<send_entry_t>;
    interface Queue<send_entry_t *>;

    interface Timer<TMilli> as ExpireTimer;

    interface BufferPool;
    interface IPRouting;
    interface ICMP;

    interface Leds;
  }
} implementation {
  
  // we use a single message_t for sending; this is it.
  message_t send_msg;

  // counter for labeling fragments we ourselves are sending.
  uint16_t current_tag;

  ip_statistics_t stats;

  bool radioBusy;

  // this in theory could be arbitrarily large; however, it needs to
  // be large enough to hold all active reconstructions, and any tags
  // which we are dropping.  It's important to keep dropped tags
  // around for a while, or else there are pathological situations
  // where you continually allocate buffers for packets which will
  // never complete.
  enum {
    N_RECONSTRUCTIONS = 5,
  };

  // table of packets we are currently receiving fragments from.
  reconstruct_t reconstructions[N_RECONSTRUCTIONS];

  error_t enqueueSend(ip_msg_t *msg, send_type_t type);

  
  event void Boot.booted() {
    int i;
    call Statistics.clear();
    for (i = 0; i < N_RECONSTRUCTIONS; i++) {
      reconstructions[i].timeout = T_UNUSED;
      reconstructions[i].buf = NULL;
    }
    current_tag = 0;
    radioBusy = FALSE;

    call ExpireTimer.startPeriodic(FRAG_EXPIRE_TIME);

    printfUART("starting\n");

    return;
  }

  void enableAcks() {
    call CC2420Config.setAutoAck(TRUE, TRUE);
    call CC2420Config.sync();
  }

  event void RadioControl.startDone(error_t error) {
    if (error == SUCCESS)
      call ICMP.sendSolicitations();
    enableAcks();
    // enable acks, default to hw acks
  }

  event void RadioControl.stopDone(error_t error) {

  }
  event void CC2420Config.syncDone(error_t error) {
  }
  /*
   *  Receive-side code.
   */ 

  /*
   * Logic which must process every received IP datagram.
   *
   *  Each IP packet may be consumed and/or forwarded.
   */
  void receive(ip_msg_t *msg) {
    ip_msg_t *newBuf;
    struct ip6_hdr *ip;
    bool put_buf = FALSE;

    // this updates the source and destination addresses if the packet is being
    // source routed.
    // updateFromSourceRoute(msg);
    
    ip = &(msg->hdr);
    
    if (call IPRouting.isForMe(msg)) {
    
      printfUART("consuming packet\n");

      newBuf = signal IPReceive.receive[call IPPacket.getNxtHdr(msg)]
        (msg, call BasicPacket.getPayload(msg),
         call BasicPacket.getPayloadLength(msg));
      call BufferPool.put(newBuf);
    } else { 

      put_buf = TRUE;

      if (msg->hdr.hlim > 0) {
        msg->hdr.hlim--;
        if (msg->hdr.hlim == 0) {
          stats.hlim_drop++;
          printfUART("dropping packet due to TTL\n");
          call ICMP.sendTimeExceeded(msg);
        } else {

          // DON'T forward multicast messages for now.
          if (!cmpPfx(msg->hdr.dst_addr, multicast_prefix)) {
            printfUART("Forwarding packet\n");
            if (enqueueSend(msg, S_FORWARD) == SUCCESS) {
              put_buf = FALSE;
            } else stats.fw_drop++;
          }
        }
      }
    }

    if (put_buf)
      call BufferPool.put(msg);
  }

  /*
   * Bulletproof recovery logic is very important to make sure we
   * don't get wedged with no free buffers.
   * 
   * The table is managed as follows:
   *  - unused entries are marked T_UNUSED
   *  - entries which 
   *     o have a buffer allocated
   *     o have had a fragment reception before we fired
   *     are marked T_ACTIVE
   *  - entries which have not had a fragment reception during the last timer period
   *     and were active are marked T_ZOMBIE
   *  - zombie receptions are deleted: their buffer is freed and table entry marked unused.
   *  - when a fragment is dropped, it is entered into the table as T_FAILED1.
   *     no buffer is allocated
   *  - when the timer fires, T_FAILED1 entries are aged to T_FAILED2.
   * - T_FAILED2 entries are deleted.  Incomming fragments with tags
   *     that are marked either FAILED1 or FAILED2 are dropped; this
   *     prevents us from allocating a buffer for a packet which we
   *     have already dropped fragments from.
   *
   */ 
  event void ExpireTimer.fired() {
    int i;
    for (i = 0; i < N_RECONSTRUCTIONS; i++) {
      // switch "active" buffers to "zombie"
      switch (reconstructions[i].timeout) {
      case T_ACTIVE:
        reconstructions[i].timeout = T_ZOMBIE; break; // age existing receptions
      case T_FAILED1:
        reconstructions[i].timeout = T_FAILED2; break; // age existing receptions
      case T_ZOMBIE:
      case T_FAILED2:
        // deallocate the space for reconstruction
        call BufferPool.put(reconstructions[i].buf);
        reconstructions[i].timeout = T_UNUSED;
        reconstructions[i].buf = NULL;
        break;
      }
    }
  }

  /*
   * allocate a structure for recording information about incomming fragments.
   */
  reconstruct_t *getReassembly(packed_lowmsg_t *lowmsg) {
    int i, free_spot = N_RECONSTRUCTIONS + 1;
    uint16_t mytag, size;
    if (getFragDgramTag(lowmsg, &mytag)) return NULL;
    if (getFragDgramSize(lowmsg, &size)) return NULL;

    printfUART("looking up frag tag: 0x%x size: 0x%x\n", mytag, size);

    for (i = 0; i < N_RECONSTRUCTIONS; i++) {
      printfUART("%i 0x%x 0x%x\n", i, reconstructions[i].timeout, reconstructions[i].tag);
      if (reconstructions[i].timeout > T_UNUSED && reconstructions[i].tag == mytag) {
        reconstructions[i].timeout = T_ACTIVE;
        printfUART("found struct\n");
        return &(reconstructions[i]);
        // if we have already tried and failed to get a buffer, we
        // need to drop remaining fragments.
      } else if (reconstructions[i].timeout < T_UNUSED && reconstructions[i].tag == mytag) {
        return NULL;
      }
      if (reconstructions[i].timeout == T_UNUSED) free_spot = i;
    }
    // allocate a new struct for doing reassembly.
    if (free_spot != N_RECONSTRUCTIONS + 1) {

      reconstructions[free_spot].tag = mytag;
      reconstructions[free_spot].size = size;
      reconstructions[free_spot].buf = call BufferPool.get(size + offsetof(ip_msg_t, hdr));
      reconstructions[free_spot].bytes_rcvd = 0;
      reconstructions[free_spot].timeout = T_ACTIVE;

      if (reconstructions[free_spot].buf == NULL) {
        reconstructions[free_spot].timeout = T_FAILED1;
        return NULL;
      }
      return &(reconstructions[free_spot]);
    }
    return NULL;
  }
  
  /*
   * This is called before a receive on packets with a source routing header.
   *
   * it updates the path stored in the header to remove our address
   * and include our predicessor.
   */
  void updateSourceRoute(ip_msg_t *msg, hw_addr_t prev) {
    struct source_header *sh;
    if (msg == NULL || msg->hdr.nxt_hdr != NXTHDR_SOURCE) return;
    sh = (struct source_header *)msg->data;

    if (sh->current == sh->nentries) return;
    sh->hops[sh->current] = hton16(prev);
    sh->current++;


    printfUART("source origin is 0x%x\n", sh->hops[0]);
  }

  void handleFrag(packed_lowmsg_t *lowmsg, uint8_t lqi) {
    reconstruct_t *reassembly = getReassembly(lowmsg);
    if (reassembly == NULL || reassembly->buf == NULL) return;

    // add the sender: needed for source routing 
    reassembly->buf->metadata.sender = lowmsg->src;
    reassembly->buf->metadata.lqi    = lqi;

    if (addFragment(lowmsg, reassembly)) {
      updateSourceRoute(reassembly->buf, reassembly->buf->metadata.sender);
      // hand off receive processing
      receive(reassembly->buf);
      reassembly->timeout = T_UNUSED;
    }

    // signal failure to release buffer
  }

  event message_t *IEEE154Receive.receive(message_t *msg, void *payload, uint8_t len) {
    packed_lowmsg_t lowmsg;
    ip_msg_t *buf_str;
    struct ip6_hdr *ip;
    uint16_t unpacked_len;
    uint8_t *lowpan_payload;

    // set up the ip message structaddFragment
    lowmsg.data = payload;
    lowmsg.len  = len;
    lowmsg.src  = call IEEE154Packet.source(msg);
    lowmsg.dst  = call IEEE154Packet.destination(msg);

    stats.rx_total++;

    printfUART("Rcv len: 0x%x src: 0x%x dst: 0x%x\n", lowmsg.len, lowmsg.src, lowmsg.dst);

    call IPRouting.reportReception(call IEEE154Packet.source(msg),
                                   call CC2420Packet.getLqi(msg));

    lowmsg.headers = getHeaderBitmap(&lowmsg);
    if (lowmsg.headers == LOWPAN_NALP_PATTERN) {
      printfUART("ERROR: bitmap set failed\n");
      goto fail;
    }

    // consume it
    if (hasMeshHeader(&(lowmsg))) {
      // TODO : pass to forwarding engine 
      
      // this will either indicate that the message has reached it's
      // destination or else send it off.
      goto done;
    }
    if (hasFrag1Header(&(lowmsg)) || hasFragNHeader(&(lowmsg))) {
      handleFrag(&lowmsg, call CC2420Packet.getLqi(msg));
      goto done;
    }
    // otherwise, it's a single packet message. we unpack it and deliver it from here.

    // this is actually an upper bound on how long the packet will be
    // it's using the fact that the longest compressed next header field is the UDP.
    unpacked_len = sizeof(struct ip6_hdr) + sizeof(struct udp_hdr)
      + len - getCompressedLen(&lowmsg);
    buf_str = call BufferPool.get(unpacked_len);
    if (buf_str == NULL) {
      printfUART("ERROR: no buffer available\n");
      goto fail;
    }

    ip = (struct ip6_hdr *)(&buf_str->hdr);

    // now it's really ours with no fragmentation.
    // unpack the IP header
    lowpan_payload = unpackHeaders(&lowmsg, (uint8_t *)ip, unpacked_len);
    if (lowpan_payload == NULL) {
      call BufferPool.put(buf_str);
      printfUART("ERROR: IP header unpack failed\n");
      goto fail;
    }

    // copy the rest of the packet
    ip_memcpy(buf_str->data + packs_header(buf_str),
              lowpan_payload, lowmsg.len - (lowpan_payload - lowmsg.data));
    
    buf_str->metadata.sender = lowmsg.src;
    buf_str->metadata.lqi    = call CC2420Packet.getLqi(msg);

    // and deliver it to upper layers.
    updateSourceRoute(buf_str, lowmsg.src);
    receive(buf_str);
    
    goto done;

  fail:
    stats.rx_drop++;
  done:
    return msg;
  }


  /*
   * Send-side functionality
   */ 

  void senddone(send_entry_t *q, error_t error) {
    // if the send was requested by the application on this mote, signal the result.
    if (q->type == S_REQ) {
      printfUART("req nxtHdr: 0x%x\n", call IPPacket.getNxtHdr(q->msg));
      signal IPSend.sendDone[call IPPacket.getNxtHdr(q->msg)](q->msg, error);
      stats.sent++;
    } else {
      // otherwise, it's a forward request.  We just need to deallocate the buffer.
      call BufferPool.put(q->msg);
      stats.forwarded++;
    }
    
    // hit this if we've gone through all the parents and didn't get
    // an ack from anyone.
    if (error == FAIL && q->dest.dest != 0xffff) {
      if (q->dest.dest != 0xffff)
        call IPRouting.reportAbandonment();
    }


    call Queue.dequeue();
    call Pool.put(q);
  }

  task void sendTask() {
    uint16_t payload_length;
    send_entry_t *q = call Queue.head();

    if (call Queue.empty()) return;
    
    if (radioBusy) return;

    if ((payload_length = getNextFrag(q->msg, &(q->frag), 
                                      call Packet.getPayload(&send_msg, call Packet.maxPayloadLength()),
                                      call Packet.maxPayloadLength())) > 0) {
 
      printfUART("sending to 0x%x len 0x%x sent: 0x%x ip plen: 0x%x frag_len 0x%x 0x%x\n", 
                 q->dest.dest, payload_length, q->frag.offset, ntoh16(q->msg->hdr.plen), sizeof(struct ip6_hdr), 
                 ntoh16(q->msg->hdr.plen) + sizeof(struct ip6_hdr) - q->frag.offset);
      
      // do the send...
      call PacketLink.setRetries(&send_msg, q->dest.retries);
      call PacketLink.setRetryDelay(&send_msg, q->dest.delay);

      printfUART("to: 0x%x retries: 0x%x\n", q->dest.dest, q->dest.retries);

      if (call IEEE154Send.send(q->dest.dest, &send_msg, payload_length) != SUCCESS)
        goto fail;
      radioBusy = TRUE;
    } else goto fail;

    return;
  fail:
    // signal failure and recover the queue entry.
    senddone(q, EINVAL);

    post sendTask();
    
    stats.tx_drop++;

    printfUART("sendTask() failed\n");
  }

  error_t enqueueSend(ip_msg_t *msg, send_type_t type) {
    send_entry_t *q = call Pool.get();
    if (q == NULL) { 
      return EBUSY;
    }

    // make sure this packet is routable; if not we can reject it
    // at admission.
    if (call IPRouting.getNextHop(msg, 0, &(q->dest)) != SUCCESS) {
      call Pool.put(q);
      printfUART("IPRouting returned no next hop\n");
      return FAIL;
    }

    q->msg =  msg;
    q->len =  ntoh16(msg->hdr.plen) + sizeof(struct ip6_hdr);
    q->frag.offset = 0;
    q->type = type;
    q->attempt = 0;

    call Queue.enqueue(q);
    post sendTask();
    return SUCCESS;
  }

  /*
   * Injection point of IP datagrams.  This is only called for packets
   * being sent from this mote; packets which are being forwarded
   * never lave the stack and so never use this entry point.
   *
   * @msg an IP datagram with header fields (except for length)
   * @plen the length of the data payload added after the headers.
   */
  command error_t IPSend.send[uint8_t prot](ip_msg_t *msg, uint16_t len) {

    if (msg->hdr.hlim != 0xff)
      msg->hdr.hlim = call IPRouting.getHopLimit();

    if (msg->hdr.nxt_hdr == NXTHDR_SOURCE) {
      struct source_header *sh = (struct source_header *)msg->data;

      // all packets sent through this interface will have this sent
      // to prevent us from routing on them;  
      sh->dispatch |= IP_EXT_SOURCE_RECORD;
      sh->current = 0;
      // the "prev" hop will be set by the receiver.
      len += sizeof(struct source_header) + sh->nentries * sizeof(hw_addr_t);
    }
    msg->metadata.sender = TOS_NODE_ID;
    msg->hdr.plen = hton16(len);

    printfUART("doing IP send\n");

    return enqueueSend(msg, S_REQ);
  }

  event void IEEE154Send.sendDone(message_t *msg, error_t error) {
    // if the queue is empty we are in a bad state.
    send_entry_t *q = call Queue.head();
    bool delivered = call PacketLink.wasDelivered(msg);
    radioBusy = FALSE;
    if (call Queue.empty()) return;

    printfUART("send done: 0x%x\n", error);
    call IPRouting.reportTransmission(&q->dest, delivered);

    // it is important that all cases are caught by one of these conditions.

    // a send is finished if
    //  * offset == the packet length AND  radio report success AND (got ack || is BCAST)
    //  * out of retries

    if (error == SUCCESS && q->frag.offset == q->len && (delivered || q->dest.dest == 0xFFFF) ) {
      // in this case, we sent all fragments, and they were all delivered
      senddone(q, SUCCESS);
    } 
    // - the send failed in the stack
    // - the send was not acked
    else if (error == SUCCESS && !delivered) {
    // the radio stack tried to deliver the packet without error, but
    // we did not receive an ACK.  If we are not out of retries, try a
    // different next hop.
      if (++(q->attempt) < N_PARENTS) {
        if (q->dest.dest != 0xffff &&
            call IPRouting.getNextHop(q->msg, q->attempt, &(q->dest)) == SUCCESS) {
          q->frag.offset = 0;
        } else {
          senddone(q, FAIL);
          stats.real_drop++;
        }
      } else {
        senddone(q, FAIL);
        stats.real_drop++;
      }

      stats.fw_drop++;
    } else {
      stats.senddone_el++;
    }

    // otherwise we fall through and try to deliver the same packet again.

    post sendTask();
  }

  /*
   * BasicPacket interface; provides generic packet functions.
   */

  command void *BasicPacket.getPayload(ip_msg_t *msg) {
    struct source_header *sh;
    if (msg->hdr.nxt_hdr == NXTHDR_SOURCE) {
      sh = (struct source_header *)msg->data;
      return (void *)(((uint8_t *)msg->data) +             // skip the IP header
                      sizeof(struct source_header)         // the fixed fields 
                      + (sh->nentries * sizeof(hw_addr_t)));  // and the address list
    } else return (void *)msg->data;
        
  }

  command uint16_t BasicPacket.getPayloadLength(ip_msg_t *msg) {
    // return the length of he payload region of the packet,
    // not including any extension headers
    return ntoh16(msg->hdr.plen) - (((uint8_t *)(call BasicPacket.getPayload(msg))) - msg->data);
  }

  command uint16_t BasicPacket.getMaxPayload(ip_msg_t *msg) {
    return msg->b_len - (((uint8_t *)(call BasicPacket.getPayload(msg))) - msg->data);
  }

  /*
   * IP-packet specific accessor methods
   */
  command struct ip6_hdr *IPPacket.getHeader(ip_msg_t *msg) {
    return &msg->hdr;
  }

  command void IPPacket.addSourceHeader(ip_msg_t *msg, uint8_t nentries, bool record) {
    struct source_header *sh = (struct source_header *)msg->data;
    sh->dispatch = IP_EXT_SOURCE_DISPATCH;
    
    if (record == TRUE) 
      sh->dispatch |= IP_EXT_SOURCE_RECORD;
    // if we have resolicited parents, we need to inform the base so
    // that it can invalidate the old state.  This is set in IPRouting
    // when we call reportAbandondment.  
    // It is reset once we successfully sent a packet towards the
    // default route.
    if (call IPRouting.wasAbandoned())
      sh->dispatch |= IP_EXT_SOURCE_INVAL;

    sh->nxt_hdr = msg->hdr.nxt_hdr;;
    msg->hdr.nxt_hdr = NXTHDR_SOURCE;
    sh->current = 0;
    sh->nentries = nentries;
    printfUART("packed dispatch: 0x%x\n", sh->dispatch);
  }

  command uint8_t IPPacket.getNxtHdr(ip_msg_t *msg) {
    struct source_header *sh = (struct source_header *)msg->data;
    if (msg->hdr.nxt_hdr != NXTHDR_SOURCE) return msg->hdr.nxt_hdr;
    return sh->nxt_hdr;
  }

  command struct ip_metadata *IPPacket.getMetadata(ip_msg_t *msg) {
    return &msg->metadata;
  }



  event void ICMP.solicitationDone() {

  }

  /*
   * Statistics interface
   */

  command ip_statistics_t *Statistics.get() {
    return &stats;
  }

  command void Statistics.clear() {
    ip_memclr((uint8_t *)&stats, sizeof(ip_statistics_t));
  }

  /*
   * defaults
   */
  default event void IPSend.sendDone[uint8_t prot](ip_msg_t *payload, error_t error) {
    
  }

  default event ip_msg_t *IPReceive.receive[uint8_t prot](ip_msg_t *buf, void *payload, uint16_t len) {
    return buf;
  }

}
