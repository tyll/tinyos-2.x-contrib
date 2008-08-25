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

#include <stdio.h>
#include <stdlib.h>
#include <stdint.h>
#include "lib6lowpan.h"
#include "lib6lowpanIP.h"
#include "lib6lowpanFrag.h"

int main(char **argv, int argc) {
  uint8_t buf[2000];
  uint8_t *payload, *i;

  struct split_ip_msg msg;
  uint8_t data[200];

  globalPrefix = 1;

  uint16_t plen = 200;

  ip_memclr((uint8_t *)&msg.hdr, 40);

  ip_memcpy(msg.hdr.src_addr, my_address, 16);
  ip_memcpy(msg.hdr.dst_addr, my_address, 16);


  msg.hdr.vlfc[0] = 6 << 4;
  msg.hdr.nxt_hdr = NXTHDR_SOURCE;
  msg.hdr.hlim = 0x64;
  msg.hdr.plen = hton16(plen);

  msg.hdr.dst_addr[0] = 0xff;
  msg.hdr.dst_addr[1] = 0xfe;
  msg.hdr.dst_addr[14]= 0x12;
  msg.hdr.dst_addr[15] = 0xfe;
  msg.headers = NULL;
  msg.data = data;
  msg.data_len = plen - 12;


  struct udp_hdr udp;
  udp.srcport = hton16(0xf0d1);
  udp.dstport = hton16(0xf0e0);
  udp.len = hton16(plen - 4);
  udp.chksum = hton16(0x9abc);

  printBuf(&udp, 8);

  struct generic_header u_p;
  u_p.len = sizeof(struct udp_hdr);
  u_p.hdr.udp = &udp;
  u_p.next = NULL;

  struct source_header source;
  source.nxt_hdr = IANA_UDP;
  source.len = sizeof(struct source_header);
  source.current = 0;

  struct generic_header s_h;
  s_h.len = sizeof(struct source_header);
  s_h.hdr.ext = &source;
  s_h.next = &u_p;
  msg.headers = &s_h;

  int j;
  for (j = 0; j < 200; j++)
    data[j] = j;

  fragment_t prog;

/*   uint8_t r_buf[2000]; */
  int rc;
/*   ip_memclr(r_buf, 1000); */

/*   packed_lowmsg_t pkt; */
/*   pkt.headers = 0; */
/*   pkt.data = buf; */


/*   reconstruct_t recon; */
  
  printBuf(&msg.hdr, 40 );
  
  
  while ((rc =getNextFrag(&msg, &prog, buf, 100)) > 0) {
    printf("n_frags: %i\n", prog.n_frags);
    printBuf(buf, rc);
  }
/*   printf ("rc: %i\n", rc); */
/*   pkt.len = rc; */

/*   pkt.headers = getHeaderBitmap(&pkt); */

/*   printf("cmprlen: 0x%x\n", getCompressedLen(&pkt)); */

/*   printBuf(buf, getCompressedLen(&pkt)); */

/*   return; */

/*   uint16_t mytag, size; */
/*   pkt.headers = getHeaderBitmap(&pkt); */
/*   printf("headers: 0x%x\n", pkt.headers); */
/*   if (getFragDgramTag(&pkt, &mytag)); */
/*   if (getFragDgramSize(&pkt, &size)); */
/*   recon.tag = mytag; */
/*   recon.size = size; */
/*   recon.buf = r_buf; */
/*   recon.bytes_rcvd = 0; */


/*   addFragment(&pkt, &recon); */
  
/*   printf ("adding fragment len: %i\n", rc); */

/*   while (rc > 0) { */
/*     ip_memclr(buf, 100); */
/*     rc = getNextFrag(msg, &prog, buf, 100); */
/*     pkt.len = rc; */
    
/*     pkt.headers = getHeaderBitmap(&pkt); */
/*     addFragment(&pkt, &recon); */
    
/*     ip_memclr(buf, 100); */
/*     printf ("adding fragment len: %i\n", rc); */
/*   } */

/*   printf("Reconstructed buffer [%i]:\n", size); */
/*   printBuf(&r_buf[10], size); */

/*   for (j = 10; j < size; j++) */
/*     if (r_buf[j] != buf1[j]) */
/*       printf("differ in byte %i (0x%x, 0x%x)\n", j - 10, buf1[j], r_buf[j]); */

  return 0;
}
