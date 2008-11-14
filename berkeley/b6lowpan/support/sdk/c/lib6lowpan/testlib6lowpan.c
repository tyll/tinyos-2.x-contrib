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
#include "lib6lowpan.h"
#include "lib6lowpanIP.h"
#if 0
#include <time.h>
#endif


// bcast header, seqno is 2
uint8_t pkt1 [] = {0x50, 0xda};

// mesh header, 0xf hops left from 0xa to 0xb
uint8_t pkt2 [] = {0xbf, 0x0, 0xa, 0x0, 0xb};

// frag1 header, blank
uint8_t pkt3 [] = {0xc0, 0x0, 0x0, 0x0, 0x0};

// fragn header, blank
uint8_t pkt4 [] = {0xe0, 0x0, 0x0, 0x0, 0x0};

// mesh followed by bcast header
uint8_t pkt5 [] = {0xbf, 0x0, 0xa, 0x0, 0xb, 0x50, 0x2};

// frag1 header.  Size = 64, tag 0xbabe
uint8_t pkt6 [] = {0xc0, 0x40, 0xba, 0xbe};

// fragN header.  Size = 64, tag 0xbabe, offset 0xfe
uint8_t pkt7 [] = {0xe0, 0x40, 0xba, 0xbe, 0xfe};

// mesh, bcast, fragn
uint8_t pkt8 [] = {0xbf, 0x0, 0xa, 0x0, 0xb, 0x50, 0xda, 0xe0, 0x40, 0xba, 0xbe, 0xfe};

// only IP headers
// 0x0a hops left.
uint8_t pkt9 [] = {0x42, 0xfb, 0x0a};

// IP only: next is 0xfa
uint8_t pkt10[] = {0x42, 0xf9, 0x0a, 0xfa};  

// IP only: next is 0xfa, TC=0x2, FL = 0x1ab, src prefix
uint8_t pkt11[] = {0x42, 0x71, 0x0a, 
                   0xf1, 0x12, 0x23, 0x34, 0x45, 0x56, 0x67, 0x78,
                   0x02, 0x00, 0x1a, 0xb0, 0x2f, 0xa0 };  

// IP only: next is 0xfa, TC=0x2, FL = 0x1ab, src prefix
uint8_t pkt12[] = {0x42, 0xe1, 0x0a, 
                   0xf1, 0x12, 0x23, 0x34, 0x45, 0x56, 0x67, 0x78,
                   0x02, 0x00, 0x1a, 0xb0, 0x2f, 0xa0 };  

// IP only: next is 0xfa, TC=0x2, FL = 0x1ab, src prefix
// this is basically a full IP packet of 41 bytes.
uint8_t pkt13[] = {0x42, 0x01, 0x0a, 
                   0xf1, 0x12, 0x23, 0x34, 0x45, 0x56, 0x67, 0x78,
                   0xaa, 0xbb, 0xcc, 0xdd, 0xee, 0xff, 0x00, 0x11,
                   0xfe, 0xed, 0xdc, 0xcb, 0xba, 0xa9, 0x98, 0x98,
                   0x10, 0x21, 0x32, 0x43, 0x54, 0x65, 0x76, 0x87,
                   0x02, 0x00, 0x1a, 0xb0, 0x2f, 0xa0 };  

// mesh, bcast, fragn, full IP these packets are not small...  as long
// as the the lowpan part skips it correctly, everything should be
// decomposable.
uint8_t pkt14 [] = {0xbf, 0x0, 0xa, 0x0, 0xb, 0x50, 0xda, 0xe0, 0x40, 0xba, 0xbe, 0xfe,
                    0x42, 0x01, 0x0a, 
                    0xf1, 0x12, 0x23, 0x34, 0x45, 0x56, 0x67, 0x78,
                    0xaa, 0xbb, 0xcc, 0xdd, 0xee, 0xff, 0x00, 0x11,
                    0xfe, 0xed, 0xdc, 0xcb, 0xba, 0xa9, 0x98, 0x98,
                    0x10, 0x21, 0x32, 0x43, 0x54, 0x65, 0x76, 0x87,
                    0x02, 0x00, 0x1a, 0xb0, 0x2f, 0xa0 };  

// IP only; uncompressed UDP follows
uint8_t pkt15 [] = {0x42, 0xfa, 0x0a, 0xf1, 0x12, 0x23, 0x2a, 0x00, 0x00, 0xfa, 0xad};


// IP; HC2 UDP
uint8_t pkt16 [] = {0x42, 0xfb, 0x0a, 0xff, 0x45, 0xfa, 0xad};

// UP, HC2 w/ uncompressed source port.
uint8_t pkt17 [] = {0x42, 0xfb, 0x0a, 0x70, 0xde, 0xad, 0x0f, 0xaa, 0xd0};


// some 64 bit addresses we can use.
uint8_t a64_1 [] = {0xf1, 0x12, 0x23, 0x34, 0x45, 0x56, 0x67, 0x78};
uint8_t a64_2 [] = {0xaa, 0xbb, 0xcc, 0xdd, 0xee, 0xff, 0x00, 0x11};
uint8_t a64_3 [] = {0xfe, 0xed, 0xdc, 0xcb, 0xba, 0xa9, 0x98, 0x98};
uint8_t a64_4 [] = {0x10, 0x21, 0x32, 0x43, 0x54, 0x65, 0x76, 0x87};


uint8_t buf[100];

#if 0
int randTest() {
  int place = 0;
  packed_lowmsg_t pkt;
  pkt.data = buf;
  pkt.len = 20;
  uint16_t mesh_orig, mesh_final, frag_size, frag_tag;
  uint8_t mesh_hops, bcast_seq, frag_offset;
  uint8_t mesh, bcast, frag1, fragN;
  uint16_t val16;
  uint8_t val8;
  mesh_orig = rand() % 0xffff;
  mesh_final = rand() % 0xffff;
  frag_size = rand() % 0x07ff;
  frag_tag = rand() % 0xffff;
  mesh_hops = rand() % 0x0f;
  bcast_seq = rand() % 0xff;
  frag_offset = rand() & 0xff;

  mesh = rand() % 2;
  bcast = rand() % 2;
  frag1 = (rand() % 3);
  if (frag1 == 0)
    fragN = 1;
  else 
    fragN = 0;



  setupHeaders(&pkt, mesh, bcast, frag1, fragN);
  if (mesh) {
    setMeshHopsLeft(&pkt, mesh_hops);
    setMeshOriginAddr(&pkt, mesh_orig);
    setMeshFinalAddr(&pkt, mesh_final);
  }

  if (bcast) {
    setBcastSeqno(&pkt, bcast_seq);
  }

  if (frag1) {
    setFragDgramSize(&pkt, frag_size);
    setFragDgramTag(&pkt, frag_tag);
  }

  if (fragN) {
    setFragDgramSize(&pkt, frag_size);
    setFragDgramTag(&pkt, frag_tag);
    setFragDgramOffset(&pkt, frag_offset);
  }
  // test it out.
  if (mesh) {
    if (getMeshHopsLeft(&pkt, &val8)) { place = 1; goto done;}
    if (val8 != mesh_hops) { place = 2; goto done;}
    if (getMeshOriginAddr(&pkt, &val16)) { place = 3; goto done;}
    if (val16 != mesh_orig) { place = 4; goto done;}
    if (getMeshFinalAddr(&pkt, &val16)) { place = 5; goto done;}
    if (val16 != mesh_final) { place = 6; goto done;}
  }
  if (bcast) {
    if (getBcastSeqno(&pkt, &val8)) { place = 7; goto done;}
    if (val8 != bcast_seq) { place = 8; goto done;}    
  }
  if (frag1) {
    if (getFragDgramSize(&pkt, &val16)) { place = 9; goto done;}
    if (val16 != frag_size) { place = 10; goto done;}
    if (getFragDgramTag(&pkt, &val16)) { place = 11; goto done;}
    if (val16 != frag_tag) { place = 12; goto done;}
  }
  if (fragN) {
    if (getFragDgramSize(&pkt, &val16)) { place = 13; goto done;}
    if (val16 != frag_size) { place = 14; goto done;}
    if (getFragDgramTag(&pkt, &val16)) { place = 15; goto done;}
    if (val16 != frag_tag) { place = 16; goto done;}
    if (getFragDgramOffset(&pkt, &val8)) { place = 17; goto done;}
    if (val8 != frag_offset) { place = 18; goto done;}
  }

  return 0;

 done:
  printf("\nThere was an error: place %i\n", place);
  printf(" Test headers: mesh: %i bcast: %i frag1: %i fragN: %i\n", mesh, bcast, frag1, fragN);
  if (mesh)
    printf("  mesh hops: 0x%x origin: 0x%x final: 0x%x\n", mesh_hops, mesh_orig, mesh_final);
  if (bcast)
    printf("  bcast seqno: 0x%x\n", bcast_seq);
  if (frag1)
    printf("  frag1 size: 0x%x tag: 0x%x\n", frag_size, frag_tag);
  if (fragN)
    printf("  fragN size: 0x%x tag: 0x%x offset: 0x%x\n", frag_size, frag_tag, frag_offset);
  
  printf(" Packed packet contents:\n");

  printPacket(buf, 100);
  printf("\n");
  return 1;

}
#endif

void zeroPkt() {
  int i;
  for (i = 0; i < 100; i++)
    buf[i] = 0;
}

#define NTESTS 100000
int main(char **argv, int argc) {
  packed_lowmsg_t pkt;
  int i, failures = 0;

#if 0
  time_t ival;
  // unseed this if you don't want it to be deterministic
  time(&ival);
  printf("Time: %i\n", ival);
  srand(ival);
#endif


  pkt.len = 100;
  pkt.data = buf;


/*   printf("---- Start IP Compression tests\n"); */
/*   printPacket(pkt9, 3); */
/*   printPacket(pkt10, 4); */
/*   printPacket(pkt11, 17); */
/*   printPacket(pkt12, 17); */
/*   printPacket(pkt13, 41); */
/*   printPacket(pkt14, 53); */
/*   printPacket(pkt15, 11); */
/*   printPacket(pkt16, 7); */
/*   printPacket(pkt17, 9); */
  printf("---- Start IP gen tests\n");

  zeroPkt();
  // setup completly compressed IP packet.
  setupIPHeaders(&pkt, LOWMSG_HC2);
  setIPHopsLeft(&pkt, 0xfa); 
  printPacket(buf, 100);

  zeroPkt();
  // setup completly compressed IP packet.
  setupIPHeaders(&pkt, LOWMSG_HC2 | LOWMSG_SRC_PREFIX_INLINE);
  setIPProtocol(&pkt, IANA_UDP);
  setIPHopsLeft(&pkt, 0xfa);
  setIPSrcPrefix(&pkt, a64_1);
  printPacket(buf, 100);

  return;

  zeroPkt();
  // setup completly compressed IP packet.
  setupIPHeaders(&pkt, LOWMSG_HC2 | LOWMSG_DST_SUFFIX_INLINE);
  setIPHopsLeft(&pkt, 0xfa);
  setIPDstSuffix(&pkt, a64_2);
  printPacket(buf, 100);


  zeroPkt();
  // setup completly compressed IP packet.
  setupIPHeaders(&pkt, LOWMSG_HC2 | LOWMSG_DST_PREFIX_INLINE | LOWMSG_DST_SUFFIX_INLINE 
                 | LOWMSG_MESH_HDR | LOWMSG_BCAST_HDR | LOWMSG_FRAGN_HDR);

  setBcastSeqno(&pkt, 0x1f);
  setMeshHopsLeft(&pkt, 3);
  setMeshOriginAddr(&pkt, 0xa);
  setMeshFinalAddr(&pkt, 0xfb);
                
  setFragDgramSize(&pkt, 0x0ff);
  setFragDgramTag(&pkt, 0xcafe);
  setFragDgramOffset(&pkt, 0x23);

  setIPHopsLeft(&pkt, 0xfa);
  setIPDstPrefix(&pkt, a64_3);
  setIPDstSuffix(&pkt, a64_2);
  printPacket(buf, 100);

  return;

  zeroPkt();
  // setup completly compressed IP packet.
  setupIPHeaders(&pkt, LOWMSG_HC2 | LOWMSG_DST_SUFFIX_INLINE | LOWMSG_NEXTHDR_INLINE |
                 LOWMSG_TCFL_INLINE);
  setIPHopsLeft(&pkt, 0xfa);
  setIPDstSuffix(&pkt, a64_2);
  setIPTcFl(&pkt, 0xf1, 0x1babe);
  setIPProtocol(&pkt, 0xfa);
  printPacket(buf, 100);


  zeroPkt();
  // setup completly compressed IP packet.
  setupIPHeaders(&pkt, LOWMSG_HC2 | LOWMSG_DST_SUFFIX_INLINE |
                 LOWMSG_TCFL_INLINE);
  setIPHopsLeft(&pkt, 0xfa);
  setIPDstSuffix(&pkt, a64_2);
  setIPTcFl(&pkt, 0xf1, 0x1babe);
  setIPProtocol(&pkt, IANA_UDP);
  printPacket(buf, 100);


  zeroPkt();
  // ICMP.
  setupIPHeaders(&pkt, LOWMSG_DST_SUFFIX_INLINE  |
                 LOWMSG_TCFL_INLINE);
  printf("header flags 0x%x\n", pkt.headers);
  setIPHopsLeft(&pkt, 0xfa);
  setIPDstSuffix(&pkt, a64_2);
  setIPTcFl(&pkt, 0xf1, 0x1babe);
  setIPProtocol(&pkt, IANA_ICMP);

  struct icmp6_hdr *h = getIPPayload(&pkt);
  h->type = 0xf1;
  h->code = 0x2f;
  h->cksum = hton16(0xbabe);

  printPacket(buf, 100);



  zeroPkt();
  // ICMP.
  setupIPHeaders(&pkt, 0);
  setIPHopsLeft(&pkt, 0xfa);
  setIPProtocol(&pkt, IANA_ICMP);

  h = getIPPayload(&pkt);
  h->type = 0xf1;
  h->code = 0x2f;
  h->cksum = hton16(0xbabe);

  printPacket(buf, 100);


  zeroPkt();
  // setup completly compressed IP packet.
  setupIPHeaders(&pkt, LOWMSG_DST_SUFFIX_INLINE |
                 LOWMSG_TCFL_INLINE);
  setIPHopsLeft(&pkt, 0xfa);
  setIPDstSuffix(&pkt, a64_2);
  setIPTcFl(&pkt, 0xf1, 0x1babe);
  setIPProtocol(&pkt, IANA_ICMP);

  h = getIPPayload(&pkt);
  h->type = 0xf1;
  h->code = 0x2f;
  h->cksum = hton16(0xbabe);

  printPacket(buf, 100);



  zeroPkt();
  // setup completly compressed IP packet.
  setupIPHeaders(&pkt, LOWMSG_DST_SUFFIX_INLINE |
                 LOWMSG_TCFL_INLINE | LOWMSG_MESH_HDR |
                 LOWMSG_BCAST_HDR | LOWMSG_FRAGN_HDR);

  setBcastSeqno(&pkt, 0x1f);
  setMeshHopsLeft(&pkt, 3);
  setMeshOriginAddr(&pkt, 0xa);
  setMeshFinalAddr(&pkt, 0xfb);
                
  setFragDgramSize(&pkt, 0x0ff);
  setFragDgramTag(&pkt, 0xcafe);
  setFragDgramOffset(&pkt, 0x23);

  setIPHopsLeft(&pkt, 0xfa);
  setIPDstSuffix(&pkt, a64_2);
  setIPTcFl(&pkt, 0xf1, 0x1babe);
  setIPProtocol(&pkt, IANA_ICMP);

  h = getIPPayload(&pkt);
  h->type = 0xf1;
  h->code = 0x2f;
  h->cksum = hton16(0xbabe);

  printPacket(buf, 100);




  zeroPkt();
  // setup completly compressed IP packet.
  setupIPHeaders(&pkt, LOWMSG_DST_SUFFIX_INLINE | LOWMSG_HC2 |
                 LOWMSG_TCFL_INLINE | LOWMSG_MESH_HDR |
                 LOWMSG_BCAST_HDR | LOWMSG_FRAGN_HDR);

  setBcastSeqno(&pkt, 0x1f);
  setMeshHopsLeft(&pkt, 3);
  setMeshOriginAddr(&pkt, 0xa);
  setMeshFinalAddr(&pkt, 0xfb);
                
  setFragDgramSize(&pkt, 0x0ff);
  setFragDgramTag(&pkt, 0xcafe);
  setFragDgramOffset(&pkt, 0x23);

  setIPHopsLeft(&pkt, 0xfa);
  setIPDstSuffix(&pkt, a64_2);  setIPTcFl(&pkt, 0xf1, 0x1babe);
  setIPProtocol(&pkt, IANA_UDP);

  setUDPSrcPort(&pkt, 0x5);
  setUDPDstPort(&pkt, 0x6);
  setUDPChkSum(&pkt, 0xcafe);

  printPacket(buf, 100);



  zeroPkt();
  // setup completly compressed IP packet.
  setupIPHeaders(&pkt, LOWMSG_HC2 |
                 LOWMSG_TCFL_INLINE | LOWMSG_MESH_HDR |
                 LOWMSG_HC2_UDP_SRC_INLINE |
/*                  LOWMSG_HC2_UDP_LEN_INLINE | */
                 LOWMSG_BCAST_HDR);

  setBcastSeqno(&pkt, 0xaa);
  setMeshHopsLeft(&pkt, 3);
  setMeshOriginAddr(&pkt, 0xa);
  setMeshFinalAddr(&pkt, 0xfb);

/*   setFragDgramSize(&pkt, 0x0ff); */
/*   setFragDgramTag(&pkt, 0xcafe); */
/*   setFragDgramOffset(&pkt, 0xda); */

  setIPHopsLeft(&pkt, 0x11);
  if (setIPTcFl(&pkt, 0xf1, 0x1babe)) printf("Error\n");;
  setIPProtocol(&pkt, IANA_UDP);

  setUDPSrcPort(&pkt, 0x5656);
  setUDPDstPort(&pkt, 0x6);
/*   setUDPLength(&pkt, 0x4320); */
  setUDPChkSum(&pkt, 0xcafe);

  printPacket(buf, 100);

/*   setupIPHeaders(&pkt, 0 | LOWMSG_HC2 | */
/*                     // LOWMSG_TCFL_INLINE | */
/*                       LOWMSG_MESH_HDR | */
/*                       LOWMSG_HC2_UDP_SRC_INLINE | */
/*                  //  LOWMSG_HC2_UDP_LEN_INLINE | */
/*                     //                       LOWMSG_DST_PREFIX_INLINE | */
/*                     //                       LOWMSG_DST_SUFFIX_INLINE | */
/*                  LOWMSG_BCAST_HDR | LOWMSG_FRAGN_HDR); */

/*   setBcastSeqno(&pkt, 0x0); */
/*   setMeshHopsLeft(&pkt, 0xff - 0x0); */
/*   setMeshOriginAddr(&pkt, 0xa); */
/*   setMeshFinalAddr(&pkt, 0xfb); */

/*   setFragDgramSize(&pkt, 0x0ff); */
/*   setFragDgramTag(&pkt, 0xcafe); */
/*   setFragDgramOffset(&pkt, 0xda); */

/*   setIPHopsLeft(&pkt, 0x11); */
/*   //     setIPTcFl(&pkt, 0xf1, 0x1babe); */
/*   setIPProtocol(&pkt, IANA_UDP); */

/*   //     setIPDstPrefix(&pkt, &ip[0]); */
/*   //     setIPDstSuffix(&pkt, &ip[8]); */

/*   setUDPSrcPort(&pkt, 0x1 + 0xff + 0 ); */
/*   setUDPDstPort (&pkt,  0x5 ); */
/*   setUDPChkSum(&pkt, 0xcafe); */
/*   //setUDPLength(&pkt, 0x4321); */

/*   printPacket(buf, 100); */

  return 0;


  printf("---- Start hand-formed packet test ----\n");
  printPacket(pkt1, 2);
  printPacket(pkt2, 5);
  printPacket(pkt3, 5);
  printPacket(pkt4, 5);
  printPacket(pkt5, 7);
  printPacket(pkt6, 4);
  printPacket(pkt7, 5);
  printPacket(pkt8, 12);


  printf("---- Start pack generation test ----\n");

  pkt.len = 20;
  pkt.data = buf;
  zeroPkt();
  setupHeaders(&pkt, LOWMSG_MESH_HDR);
  setMeshHopsLeft(&pkt, 3);
  setMeshOriginAddr(&pkt, 0xa);
  setMeshFinalAddr(&pkt, 0xfb);
  printPacket(buf, 20);

  zeroPkt();
  setupHeaders(&pkt, LOWMSG_BCAST_HDR);
  printPacket(buf, 20);

  zeroPkt();
  pkt.headers = 0;
  setupHeaders(&pkt, LOWMSG_FRAG1_HDR);
  setFragDgramSize(&pkt, 0x309);
  setFragDgramTag(&pkt, 0x601f);
  printPacket(buf, 20);

  zeroPkt();
  setupHeaders(&pkt, LOWMSG_FRAGN_HDR);
  printPacket(buf, 20);

  zeroPkt();
  setupHeaders(&pkt, LOWMSG_MESH_HDR | LOWMSG_BCAST_HDR);
  printPacket(buf, 20);

  zeroPkt();
  setupHeaders(&pkt, LOWMSG_BCAST_HDR | LOWMSG_FRAG1_HDR);
  printPacket(buf, 20);
  
  zeroPkt();
  setupHeaders(&pkt, LOWMSG_BCAST_HDR | LOWMSG_FRAGN_HDR);
  printPacket(buf, 20);

  zeroPkt();
  setupHeaders(&pkt, LOWMSG_MESH_HDR | LOWMSG_BCAST_HDR | LOWMSG_FRAGN_HDR);

  setBcastSeqno(&pkt, 0x1f);
  setMeshHopsLeft(&pkt, 3);
  setMeshOriginAddr(&pkt, 0xa);
  setMeshFinalAddr(&pkt, 0xfb);
                
  setFragDgramSize(&pkt, 0x0ff);
  setFragDgramTag(&pkt, 0xcafe);
  setFragDgramOffset(&pkt, 0x23);
  printPacket(buf, 20);


#if 0
  printf("---- Starting random tests ----\n");
  for (i = 0; i < NTESTS; i++) {
    zeroPkt();
    if (randTest()) failures++;
  }
  printf("Failed %i/%i random tests\n", failures, NTESTS);
#endif
  return 0;
}
