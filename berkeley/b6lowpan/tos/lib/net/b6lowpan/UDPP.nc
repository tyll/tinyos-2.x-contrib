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

/*
 * This is not the interface applications want to use.  They probably
 * want to use UDPClientC or UDPServerC.
 *
 * This component provides parameterized send and receive interfaces
 * which take care of the UDP checksum.
 *
 */

#include <in_cksum.h>
#include <lib6lowpan.h>
#include <6lowpan.h>
#include <IP.h>
#include "PrintfUART.h"

module UDPP {
  provides {
    interface UDPReceive[uint16_t localPort];
    interface UDPSend[uint16_t localProt];

    interface BasicPacket;
    interface UDPPacket;

    interface BufferPool;
  }
  uses {
    interface IPAddress;
    interface IPReceive as SubReceive;
    interface IPSend as SubSend;
    interface BasicPacket as SubPacket;
    interface BufferPool as SubBufPool;
  }
  
} implementation {

  event ip_msg_t *SubReceive.receive(ip_msg_t *msg, void *payload, uint16_t len) {
    // check the checksum.
    struct udp_hdr *udp = (struct udp_hdr *)payload;
    struct sockaddr from;
    memcpy(from.sin_addr, msg->hdr.src_addr, 16);
    from.sin_port = udp->srcport;
    return (ip_msg_t *)signal UDPReceive.receive[ntoh16(udp->dstport)](&from, msg,
                                                                       payload + sizeof(struct udp_hdr),
                                                                       len - sizeof(struct udp_hdr));
  }

  command error_t UDPSend.send[uint16_t localPort](struct sockaddr *dest,
                                                   ip_msg_t *msg, uint16_t len) {
    vec_t cksum_vec[4];
    uint32_t ck_hdr[2];
    struct udp_hdr *udp_hdr = call SubPacket.getPayload(msg);
    int i;

    memcpy(msg->hdr.dst_addr, dest->sin_addr, 16);
    memcpy(msg->hdr.src_addr, *(call IPAddress.getIPAddr()), 16);

    printfUART("UDP send from: ");
    for (i = 0; i < 16; i ++)
      printfUART("0x%x ", msg->hdr.src_addr[i]);
    printfUART("\n");


    udp_hdr->srcport = hton16(localPort);
    udp_hdr->dstport = dest->sin_port;
    udp_hdr->len = hton16(len + sizeof(struct udp_hdr));
    udp_hdr->chksum = 0;

    cksum_vec[0].ptr = (uint8_t *)msg->hdr.src_addr;
    cksum_vec[0].len = 16;
    cksum_vec[1].ptr = (uint8_t *)msg->hdr.dst_addr;
    cksum_vec[1].len = 16;
    cksum_vec[2].ptr = (uint8_t *)ck_hdr;
    cksum_vec[2].len = 8;
    ck_hdr[0] = hton32(len + sizeof(struct udp_hdr));
    ck_hdr[1] = hton32(IANA_UDP);
    cksum_vec[3].ptr = (uint8_t *)udp_hdr;
    cksum_vec[3].len = len + sizeof(struct udp_hdr);

    udp_hdr->chksum = hton16(in_cksum(cksum_vec, 4));

    return call SubSend.send((ip_msg_t *)msg, len + sizeof(struct udp_hdr));
                       
  }
  event void SubSend.sendDone(ip_msg_t *msg, error_t error) {
    struct udp_hdr *hdr = (struct udp_hdr *)call SubPacket.getPayload(msg);
    printfUART("udp: sendDone: 0x%x\n", ntoh16(hdr->srcport));
    signal UDPSend.sendDone[ntoh16(hdr->srcport)](msg, error);
  }

  default event void UDPSend.sendDone[uint16_t port](ip_msg_t *msg, error_t error) {
    printfUART("default UDP sendDone\n");
  }
  default event ip_msg_t *UDPReceive.receive[uint16_t port](struct sockaddr *dest, ip_msg_t *msg,
                                                            void *payload, uint16_t len) {
    return msg;
  }

   // return a pointer to the payload region of an IP Packet
  command void *BasicPacket.getPayload(ip_msg_t *msg) {
    return (void *)(((uint8_t *)(call SubPacket.getPayload(msg))) + sizeof(struct udp_hdr));
  }

  // return the length of this particular IP packet; this is the
  // amount which will be written out over the wire.
  command uint16_t BasicPacket.getPayloadLength(ip_msg_t *msg) {
    return call SubPacket.getPayloadLength(msg) - sizeof(struct udp_hdr);
  }

  // return the maximum length that can safely be written after the pointer
  // returned by getPayload
  command uint16_t BasicPacket.getMaxPayload(ip_msg_t *msg) {
    return call SubPacket.getMaxPayload(msg) - sizeof(struct udp_hdr);
  }

  command struct udp_hdr *UDPPacket.getHeader(ip_msg_t *msg) {
    return (struct udp_hdr *)(call SubPacket.getPayload(msg));
  }

  command ip_msg_t *BufferPool.get(buffer_size_t sz) {
    return call SubBufPool.get(sz + sizeof(ip_msg_t) + sizeof(struct udp_hdr));
  }

  command void BufferPool.put(ip_msg_t *buf) {
    call SubBufPool.put(buf);
  }
}
