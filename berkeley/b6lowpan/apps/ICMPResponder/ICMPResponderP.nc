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

#include "in_cksum.h"
#include "PrintfUART.h"

module ICMPResponderP {
  uses interface Boot;
  uses interface SplitControl as RadioControl;
  uses interface IPSend;
  uses interface IPReceive;
  uses interface IPAddress;
  uses interface Leds;
} implementation {

  uint8_t buf[12];
  message_t message;

  event void Boot.booted() {
    call RadioControl.start();
    printfUART_init();
  }

  event void RadioControl.startDone(error_t e) {

  }

  event void RadioControl.stopDone(error_t e) {

  }

  typedef nx_struct icmp6_echo_hdr {
    nx_uint8_t        type;     /* type field */
    nx_uint8_t        code;     /* code field */
    nx_uint16_t       cksum;    /* checksum field */
    nx_uint16_t       ident;
    nx_uint16_t       seqno;
  } icmp_echo_hdr_t;

  icmp_echo_hdr_t reply;

  event void *IPReceive.getBuffer(uint16_t len) {
    return (void *)buf;
  }

  event void IPReceive.receive(ip6_addr_t *source, void *payload, uint16_t len) {
    uint8_t replen;

    icmp_echo_hdr_t *req = (icmp_echo_hdr_t *)payload;

    // for checksum calculation
    vec_t cksum_vec[4];
    uint32_t hdr[2];
    uint16_t csum;

    printfUART ("icmp type: 0x%x code: 0x%x cksum: 0x%x ident: 0x%x seqno: 0x%x\n",
                req->type, req->code, req->cksum, req->ident, req->seqno);

    call Leds.led1Toggle();

    
    if (req->type != ICMP_TYPE_ECHO_REQUEST) goto fail;

    reply.type = ICMP_TYPE_ECHO_REPLY;
    reply.code = 0;
    reply.cksum = 0;
    reply.ident = req->ident;
    reply.seqno = req->seqno;

    cksum_vec[0].ptr = (uint8_t *)(*source);
    cksum_vec[0].len = 16;
    cksum_vec[1].ptr = (uint8_t *)(*(call IPAddress.getIPAddr()));
    cksum_vec[1].len = 16;
    cksum_vec[2].ptr = (uint8_t *)hdr;
    cksum_vec[2].len = 8;
    hdr[0] = hton32(0x8);
    hdr[1] = hton32(IANA_ICMP);
    cksum_vec[3].ptr = (uint8_t *)&reply;
    cksum_vec[3].len = 8;

    reply.cksum = in_cksum(cksum_vec, 4);

    if (call IPSend.send(source, &reply, sizeof(icmp_echo_hdr_t))) goto fail;
    goto done;
  fail:
    //call Leds.led0Toggle();
  done:
    return;
  }

  event void IPSend.sendDone(void *payload, error_t error) {
  }

}
