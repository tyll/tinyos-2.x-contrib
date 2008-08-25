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
 * Copyright (c) 2007 Matus Harvan
 * All rights reserved
 *
 * Copyright (c) 2008 Stephen Dawson-Haggerty
 * Extensivly modified to use lib6lowpan / b6lowpan.
 *
 * Redistribution and use in source and binary forms, with or without
 * modification, are permitted provided that the following conditions are
 * met:
 *
 *     * Redistributions of source code must retain the above copyright
 *       notice, this list of conditions and the following disclaimer.
 *     * Redistributions in binary form must reproduce the above
 *       copyright notice, this list of conditions and the following
 *       disclaimer in the documentation and/or other materials provided
 *       with the distribution.
 *     * The name of the author may not be used to endorse or promote
 *       products derived from this software without specific prior
 *       written permission.
 *
 * THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS
 * "AS IS" AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT
 * LIMITED TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR
 * A PARTICULAR PURPOSE ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT
 * OWNER OR CONTRIBUTORS BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL,
 * SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT
 * LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE,
 * DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY
 * THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT
 * (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE
 * OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
 */

#include <stdio.h>
#include <stdlib.h>
#include <unistd.h>
#include <string.h>
#include <time.h>
#include <stdarg.h>
#include <termios.h>
#include <errno.h>

#include "tun_dev.h"
#include "serialsource.h"
#include "serialpacket.h"
#include "serialprotocol.h"

#include "6lowpan.h"
#include "ip.h"
#include "lib6lowpan.h"
#include "router_address.h"
#include "IEEE154.h"
#include "routing.h"
#include "configure.h"
#include "logging.h"

#define min(a,b) ( (a>b) ? b : a )
#define max(a,b) ( (a>b) ? a : b )

static char *msgs[] = {
    "unknown_packet_type",
    "ack_timeout",
    "sync",
    "too_long",
    "too_short",
    "bad_sync",
    "bad_crc",
    "closed",
    "no_memory",
    "unix_error"
};

int tun_fd;
serial_source ser_src;
extern uint8_t multicast_prefix[8];

enum {
  TOS_SERIAL_802_15_4_ID = 2,
  TOS_SERIAL_DEVCONF = 3,
};

enum {
  N_RECONSTRUCTIONS = 10,
};

/*
 * ifconfig on OpenWRT has a slightly different syntax
 *
 * This is not the right way to detect we're on that platform, but I
 * can't find a better macro.
 */ 
#ifdef __TARGET_mips__
static char* ifconfig_fmt_global = "ifconfig tun0 add %x%02x:%x%02x:%x%02x:%x%02x:%x%02x:%x%02x:%x%02x:%x%02x/64";
static char* ifconfig_fmt_llocal = "ifconfig tun0 add fe80::%x%02x/64";
#else
static char* ifconfig_fmt_global = "ifconfig tun0 inet6 add %x%02x:%x%02x:%x%02x:%x%02x:%x%02x:%x%02x:%x%02x:%x%02x/64";
static char* ifconfig_fmt_llocal = "ifconfig tun0 inet6 add fe80::%x%02x/64";
#endif

/* ------------------------------------------------------------------------- */

void stderr_msg(serial_source_msg problem)
{
    fprintf(stderr, "Note: %s\n", msgs[problem]);
}


int memclr(uint8_t *buf, int bytes) {
  int i;
  for (i = 0; i < bytes; i++) {
    buf[i] = 0;
  }
  return 0;
}

/* from contiki-2.x/tools/tunslip.c */
int ssystem(const char *fmt, ...)
{
    char cmd[128];
    va_list ap;
    va_start(ap, fmt);
    vsnprintf(cmd, sizeof(cmd), fmt, ap);
    va_end(ap);
    printf("%s\n", cmd);
    return system(cmd);
}


// #define DEBUG
#ifdef DEBUG
#define dump_serial_packet(X,Y)  __dump_serial_packet((X),(Y))

void print_ip_packet(struct split_ip_msg *msg) {
  int i;
  struct generic_header *g_hdr;
  printf("  nxthdr: 0x%x hlim: 0x%x\n", msg->hdr.nxt_hdr, msg->hdr.hlim);
  printf("  src: ");
  for (i = 0; i < 16; i++) printf("0x%x ", msg->hdr.src_addr[i]);
  printf("\n");
  printf("  dst: ");
  for (i = 0; i < 16; i++) printf("0x%x ", msg->hdr.dst_addr[i]);
  printf("\n");

  g_hdr = msg->headers;
  while (g_hdr != NULL) {
    printf("header [%i]: ", g_hdr->len);
    for (i = 0; i < g_hdr->len; i++)
      printf("0x%x ", g_hdr->hdr.data[i]);
    printf("\n");
    g_hdr = g_hdr->next;
  }

  printf("data [%i]:\n\t", msg->data_len);
  for (i = 0; i < msg->data_len; i++) {
    if (i == 0x40) {
      printf (" ...\n");
      break;
    }
    printf("0x%x ", msg->data[i]);
    if (i % 16 == 15) printf("\n\t");
    if (i % 16 == 7) printf ("  ");
  }
  printf("\n");
}
#else
#define dump_serial_packet(X,Y)  ;
#define print_ip_packet(X)
#endif

/*
 * frees the linked list structs, and their payloads if we have
 * malloc'ed them at some other point.
 *
 * does not free the payload buffer or the actual split_ip_msg struct,
 * since those are malloc'ed seperatly in this implementation.
 */
void free_split_msg(struct split_ip_msg *msg) {
  struct generic_header *cur, *next;
  cur = msg->headers;
  while (cur != NULL) {
    next = cur->next;
    if (cur->payload_malloced)
      free(cur->hdr.data);
    free(cur);
    cur = next;
  }
}


/* ------------------------------------------------------------------------- */
/*
 * the first byte the TOS serial stack sends is a dispatch byte.  One
 * dispatch value is for forwarded 802;.15.4 packets; we use a few
 * others to talk directly to the attached IPBaseStation.
 */
void handle_other_pkt(uint8_t *data, int len) {
  config_reply_t *rep;
  switch (data[0]) {
  case TOS_SERIAL_DEVCONF:
    rep = (config_reply_t *)(&data[1]);
    info("config error: 0x%x addr: 0x%x\n", rep->error, ntoh16(rep->addr));
    break;
  default:
    warn("received serial packet with unknown dispatch 0x%x\n",data[0]);
    dump_serial_packet(data, len);
  }
}

void send_configure() {
  uint8_t buf[sizeof(config_cmd_t) + 1];
  config_cmd_t *cmd = (config_cmd_t *)(&buf[1]);
  memclr(buf, sizeof(config_cmd_t) + 1);
  buf[0] = TOS_SERIAL_DEVCONF;
  cmd->cmd = CONFIG_SET_ADDR;
  cmd->data.addr = hton16((((uint16_t)my_address[14]) << 8) | ((uint16_t)my_address[15]));

  write_serial_packet(ser_src, buf, sizeof(buf));
}



/* ------------------------------------------------------------------------- */
/* handling of data arriving on the tun interface */
void write_radio_header(uint8_t *serial, hw_addr_t dest, uint16_t payload_len) {
  IEEE154_header_t *radioPacket = (IEEE154_header_t *)(serial + 1);
  radioPacket->length = payload_len + MAC_HEADER_SIZE + MAC_FOOTER_SIZE;
  // don't include the length byte
  radioPacket->fcf = hton16(0x4188);
  // dsn will get set on mote
  radioPacket->destpan = 0;
  radioPacket->dest = htole16(dest);
  // src will get set on mote 
  
  serial[0] = SERIAL_TOS_SERIAL_802_15_4_ID;
}

void send_fragments (struct split_ip_msg *msg, hw_addr_t dest) {
  int result;
  uint16_t frag_len;
  fragment_t progress;
  uint8_t serial[LOWPAN_LINK_MTU + 1];
  IEEE154_header_t *radioPacket = (IEEE154_header_t *)(serial + 1);
  uint8_t *lowpan = (uint8_t *)(radioPacket + 1);


  progress.offset = 0;
  // fill in the body
  frag_len = getNextFrag(msg, &progress, lowpan, 
                         LOWPAN_LINK_MTU - MAC_HEADER_SIZE - MAC_FOOTER_SIZE);
  // and IEEE 802.15.4 header
  write_radio_header(serial, dest, frag_len);
  // send out to the serial port.  here we include the length byte and
  // the dispatch byte: they are not included in the radio packet
  // header's length However, no crc bytes are appended.
  debug("send_fragments: about to send\n");

  result = write_serial_packet(ser_src, serial, radioPacket->length + 2);
  if (result != 0)
    result = write_serial_packet(ser_src, serial, radioPacket->length + 2);
  debug("write_serial_packet: wrote 0x%x bytes\n", radioPacket->length + 2);

  debug("send_fragments: result: 0x%x len: 0x%x\n", result, frag_len);

  while ((frag_len = getNextFrag(msg, &progress, lowpan, 
                                 LOWPAN_LINK_MTU - MAC_HEADER_SIZE - MAC_FOOTER_SIZE)) > 0) {

    //debug("frag len: 0x%x offset: 0x%x plen: 0x%x\n", frag_len, progress.offset * 8, ntoh16(ip_header->plen));

    write_radio_header(serial, dest, frag_len);

    // if this is sent too fast, the base station can't keep up.  The effect of this is
    // we send incomplete fragment.  25ms seems to work pretty well.
    // usleep(30000);
    //
    //   6-9-08 : SDH : this is a bad fix that does not address the
    //   problem.  
    //   at the very least, the serial ack's seem to be
    //   working, so we should be retrying if the ack is failing
    //   because the hardware cannot keep up.
    result = write_serial_packet(ser_src, serial, radioPacket->length + 2);
    if (result != 0)
      result = write_serial_packet(ser_src, serial, radioPacket->length + 2);

    debug("send_fragments: result: 0x%x len: 0x%x\n", result, frag_len);
  }
}

void icmp_unreachable(struct split_ip_msg *msg) {
  
}

/*
 * this function takes a complete IP packet, and sends it out to a
 * destination in the PAN.  It will insert source routing headers and
 * recompute L4 checksums as necessary.
 *
 */ 
uint8_t ip_to_pan(struct split_ip_msg *msg) {
  uint16_t dest;

  debug("ip_to_pan\n");
  print_ip_packet(msg);

  // source route as necessary
  switch (routing_is_onehop(msg)) {
  case ROUTE_MHOP:
    if (routing_insert_route(msg)) goto fail;
    break;
    
  case ROUTE_NO_ROUTE:
    info("destination unreachable!\n");
    icmp_unreachable(msg);
    return 0;
  }

  dest = routing_get_nexthop(msg);
  debug("next hop: 0x%x\n", dest);
  send_fragments(msg, dest);
  return 0;
 fail:
  error("ip_to_pan: no route to host\n");
  return 1;
}

void upd_source_route(struct source_header *sh, hw_addr_t addr) {
  if (sh->current < SH_NENTRIES(sh)) {
    sh->hops[sh->current] = leton16(addr);
    sh->current++;
  }
}

void remove_sourceroute(struct split_ip_msg *msg) {
  struct source_header *sh;
  struct generic_header *g_hdr;
  if (msg->hdr.nxt_hdr == NXTHDR_SOURCE) {
    sh = msg->headers->hdr.sh;

    upd_source_route(sh, msg->metadata.sender);
    routing_add_source_header(sh);

    msg->hdr.nxt_hdr = sh->nxt_hdr;
    msg->hdr.plen = hton16(ntoh16(msg->hdr.plen) - sh->len);

    g_hdr = msg->headers;
    msg->headers = msg->headers->next;
    free(g_hdr);
  }
}


void handle_serial_packet(struct split_ip_msg *msg) {

  if (ntoh16(msg->hdr.plen) > INET_MTU - sizeof(struct ip6_hdr)) {
    warn("handle_ip_packet: too long: 0x%x\n", ntoh16(msg->hdr.plen));
    return;
  }

  print_ip_packet(msg);
  remove_sourceroute(msg);

  if (cmpPfx(msg->hdr.dst_addr, my_address) && 
      ((msg->hdr.dst_addr[14] != my_address[14] ||
        msg->hdr.dst_addr[15] != my_address[15]))) {
      ip_to_pan(msg);
      // do routing
  } else {
    // give it to linux
    // need to remove route info here.
    tun_write(tun_fd, msg);
    debug("tun_write: wrote 0x%x bytes\n", sizeof(struct ip6_hdr) + ntoh16(msg->hdr.plen));
  }
}

void add_header_list(struct split_ip_msg *msg) {
  uint8_t nxt_hdr;
  struct generic_header *g_hdr, **g_list;
  struct ip6_ext *ext = (struct ip6_ext *)msg->next;
  uint16_t hdr_len = 0;
  nxt_hdr = msg->hdr.nxt_hdr;
  msg->headers = NULL;
  g_list = &(msg->headers);
  while (KNOWN_HEADER(nxt_hdr)) {
    g_hdr = (struct generic_header *)malloc(sizeof(struct generic_header));
    g_hdr->payload_malloced = 0;
    g_hdr->hdr.ext = ext;
    g_hdr->next = NULL;
    *g_list = g_hdr;
    g_list = &g_hdr->next;

    switch(nxt_hdr) {
    case NXTHDR_SOURCE:
      g_hdr->len = ext->len;
      
      nxt_hdr = ext->nxt_hdr;
      ext = (struct ip6_ext *)(((uint8_t *)ext) + ext->len);
      break;
    case IANA_UDP:
      // a UDP header terminates a chain of headers we can compress...
      g_hdr->len = sizeof(struct udp_hdr);
      ext = (struct ip6_ext *)(((uint8_t *)ext) + sizeof(struct udp_hdr));
      nxt_hdr = NXTHDR_UNKNOWN;
      break;
    }
    hdr_len += g_hdr->len;
  }
  msg->data = (uint8_t *)ext;
  msg->data_len = ntoh16(msg->hdr.plen) - hdr_len;
}


/*
 * read data from the tun device and send it to the serial port
 * does also fragmentation
 */
int tun_input()
{
  uint8_t buf[sizeof(struct split_ip_msg) + INET_MTU];
  struct split_ip_msg *msg = (struct split_ip_msg *)buf;
  int len;

  len = tun_read(tun_fd, (void *)(&msg->pi), INET_MTU + sizeof(struct ip6_hdr));

  if (len <= 0) {
    return 0;
  }
  debug("tun_read: read 0x%x bytes\n", len);

  if ((msg->hdr.vlfc[0] >> 4) != IPV6_VERSION) {
    warn("tun_read: discarding non-ip packet\n");
    goto fail;
  }
  if (ntoh16(msg->hdr.plen) > INET_MTU - sizeof(struct ip6_hdr)) {
    warn("tun_input: dropping packet due to length: 0x%x\n", ntoh16(msg->hdr.plen));
    goto fail;
  }
  if (msg->hdr.nxt_hdr == 0) {
    warn("tun_input: dropping packet with IPv6 options\n");
    goto fail;
  }
  
  add_header_list(msg);

  ip_to_pan(msg);

  free_split_msg(msg);
  
  return 1;
 fail:
  error("Invalid packet or version received\n");
  return 1;
}

/* ------------------------------------------------------------------------- */
/* handling of data arriving on the serial port */

reconstruct_t reconstructions [N_RECONSTRUCTIONS];

void age_reconstructions() {
  int i;
  for (i = 0; i < N_RECONSTRUCTIONS; i++) {
    // switch "active" buffers to "zombie"
    if (reconstructions[i].timeout == T_ACTIVE) {
      reconstructions[i].timeout = T_ZOMBIE;
    } else if (reconstructions[i].timeout == T_ZOMBIE) {
      reconstructions[i].timeout = T_UNUSED;
      free(reconstructions[i].buf);
      reconstructions[i].buf = NULL;
    }
  }
}


reconstruct_t *getReassembly(packed_lowmsg_t *lowmsg) {
  int i, free_spot = N_RECONSTRUCTIONS + 1;
  uint16_t mytag, size;
  if (getFragDgramTag(lowmsg, &mytag)) return NULL;
  if (getFragDgramSize(lowmsg, &size)) return NULL;
  
  for (i = 0; i < N_RECONSTRUCTIONS; i++) {
    if (reconstructions[i].timeout > T_UNUSED && reconstructions[i].tag == mytag) {
      reconstructions[i].timeout = T_ACTIVE;
      return &(reconstructions[i]);
    }
    if (reconstructions[i].timeout == T_UNUSED) free_spot = i;
  }
  // allocate a new struct for doing reassembly.
  if (free_spot != N_RECONSTRUCTIONS + 1) {
    // if we don't get the packet with the protocol in it first, we
    // don't know who to ask for a buffer, and so give up.

    reconstructions[free_spot].tag = mytag;

    reconstructions[free_spot].size = size;
    reconstructions[free_spot].buf = malloc(size + offsetof(struct split_ip_msg, hdr));
    reconstructions[free_spot].bytes_rcvd = 0;
    reconstructions[free_spot].timeout = T_ACTIVE;

    debug("checking buffer size 0x%x\n", reconstructions[free_spot].size);
    if (reconstructions[free_spot].buf == NULL) {
      reconstructions[free_spot].timeout = T_UNUSED;
      return NULL;
    }
    return &(reconstructions[free_spot]);
  }
  return NULL;
}

/* 
 * read data on serial port and send it to the tun interface
 * does fragment reassembly
 */
int serial_input() {
    packed_lowmsg_t pkt;
    IEEE154_header_t *mac_hdr;
    reconstruct_t *recon;
    struct split_ip_msg *msg;

    uint8_t *ser_data = NULL;	        /* data read from serial port */
    int ser_len = 0;                    /* length of data read from serial port */
    uint8_t shortMsg[INET_MTU];
    uint8_t *payload;
    

    int rv = 1;

    /* read data from serial port */
    ser_data = (uint8_t *)read_serial_packet(ser_src, &ser_len);

    /* process the packet we have received */
    if (ser_len && ser_data) {
      if (ser_data[0] != TOS_SERIAL_802_15_4_ID) {
        handle_other_pkt(ser_data, ser_len);
        goto discard_packet;
      }
      
      debug("serial_input: read 0x%x bytes\n", ser_len);

      mac_hdr = (IEEE154_header_t *)(ser_data + 1);

      // size is  one for the length byte, minus two for the checksum
      pkt.len = mac_hdr->length - MAC_HEADER_SIZE - MAC_FOOTER_SIZE;
      // add one for the dispatch byte.
      pkt.data = ser_data + 1 + sizeof(IEEE154_header_t);
      // for some reason these are little endian so we don't do any conversion.
      pkt.src = mac_hdr->src;
      pkt.dst = mac_hdr->dest;

      pkt.headers = getHeaderBitmap(&pkt);
      if (pkt.headers == LOWPAN_NALP_PATTERN) goto discard_packet;

      if (hasFrag1Header(&pkt) || hasFragNHeader(&pkt)) {
        unpack_info_t u_info;
        uint8_t amount_here;

        recon = getReassembly(&pkt);
        
        msg = (struct split_ip_msg *)recon->buf;
        // printf ("recon is 0x%p\n", recon);
        if (recon == NULL || recon->buf == NULL) goto discard_packet;

        if (hasFrag1Header(&pkt)) {
          if (unpackHeaders(&pkt, &u_info,
                            (uint8_t *)&msg->hdr, recon->size) == NULL) goto discard_packet;
          amount_here = pkt.len - (u_info.payload_start - pkt.data);
          ip_memcpy(u_info.header_end, u_info.payload_start, amount_here);
          recon->bytes_rcvd = sizeof(struct ip6_hdr) + u_info.payload_offset + amount_here;
        } else {
          uint8_t offset_cmpr;
          uint16_t offset;
          if (getFragDgramOffset(&pkt, &offset_cmpr)) goto discard_packet;
          offset = offset_cmpr * 8;
          payload = getLowpanPayload(&pkt);
          amount_here = pkt.len - (payload - pkt.data);

          if (offset + amount_here > recon->size) goto discard_packet;
          ip_memcpy(((uint8_t *)&msg->hdr) + offset, payload, amount_here);
          recon->bytes_rcvd += amount_here;
          
          if (recon->size == recon->bytes_rcvd) {
            // got all the fragments...
            debug ("serial: reconstruction finished\n");
            add_header_list(msg);

            msg->metadata.sender = pkt.src;

            handle_serial_packet(msg);

            recon->timeout = T_UNUSED;
            free_split_msg(msg);
            free(recon->buf);
          }
        }

      } else {
        unpack_info_t u_info;
        msg = (struct split_ip_msg *)shortMsg;
        if (unpackHeaders(&pkt, &u_info,
                          (uint8_t *)&msg->hdr, INET_MTU) == NULL) goto discard_packet;
        if (ntoh16(msg->hdr.plen) > INET_MTU - sizeof(struct ip6_hdr)) goto discard_packet;

        msg->metadata.sender = pkt.src;

        ip_memcpy(u_info.header_end, u_info.payload_start, ntoh16(msg->hdr.plen));

        add_header_list(msg);
        
        handle_serial_packet(msg);
        free_split_msg(msg);
      }
    } else {
      //printf("no data on serial port, but FD triggered select\n");
      rv = 0;
    }
  discard_packet:
    free(ser_data);
    return rv;
}


/* shifts data between the serial port and the tun interface */
int serial_tunnel(serial_source ser_src, int tun_fd)
{
    //int result;
    fd_set fs;
    time_t last_aging, current_time;
    time(&last_aging);
    int haswork = 0;

    while (1) {
	FD_ZERO(&fs);
	FD_SET(tun_fd, &fs);
	FD_SET(serial_source_fd(ser_src), &fs);


	select(tun_fd > serial_source_fd(ser_src) ?
	       tun_fd + 1 : serial_source_fd(ser_src) + 1,
	       &fs, NULL, NULL, NULL);

	/* data available on tunnel device */

        // this is a better way of polling; this way we will alternate
        // between reading from the tun and reading from the device.
        // Under heavy load, this is less likely to cause queue drops
        // in the kernel, because we are essentially doing a simple
        // version of round-robin scheduling.
        haswork = FD_ISSET(tun_fd, &fs) || FD_ISSET(serial_source_fd(ser_src), &fs);
        while (haswork) {
          haswork = 0;
          if (FD_ISSET(tun_fd, &fs))
            haswork = tun_input();

          if (FD_ISSET(serial_source_fd(ser_src), &fs))
            haswork = serial_input() || haswork;
        }
        
        if (tcdrain(serial_source_fd(ser_src)) < 0)
          error("tcdrain error: %i\n", errno);

	/* end of data available */
        time(&current_time);
        if (current_time > last_aging + (FRAG_EXPIRE_TIME / 1024)) {
          last_aging = current_time;
          age_reconstructions();
        }
    }
    /* end of while(1) */

    return 0;
}

int main(int argc, char **argv)
{
    char dev[16];
    char cmd_buf[300];
    int i;

    log_init();
    if (argc != 3) {
	fatal("usage: %s <device> <rate>\n", argv[0]);
	exit(2);
    }

    /* create the tunnel device */
    dev[0] = 0;
    tun_fd = tun_open(dev);
    if (tun_fd < 1) {
	fatal("Could not create tunnel device. Fatal.\n");
	return 1;
    } else {

      info("created tunnel device: %s\n", dev);
    }
    for (i = 0; i < N_RECONSTRUCTIONS; i++) {
      reconstructions[i].timeout = T_UNUSED;
    }

    /* open the serial port */
    ser_src = open_serial_source(argv[1], platform_baud_rate(argv[2]),
				 1, stderr_msg);
    /* 0 - blocking reads
     * 1 - non-blocking reads
     */

    if (!ser_src) {
	error("Couldn't open serial port at %s:%s\n", argv[1], argv[2]);
	exit(1);
    }
    globalPrefix = 1;
    memcpy(my_address, router_address, 16);

    /* set up the tun interface */
    ssystem("ifconfig tun0 up");
    ssystem("ifconfig tun0 mtu 1280");
    sprintf(cmd_buf, ifconfig_fmt_global,
            my_address[0],my_address[1],my_address[2],my_address[3],
            my_address[4],my_address[5],my_address[6],my_address[7],
            my_address[8],my_address[9],my_address[10],my_address[11],
            my_address[12],my_address[13],my_address[14],my_address[15]);
    ssystem(cmd_buf);
    sprintf(cmd_buf, ifconfig_fmt_llocal,
            my_address[14], my_address[15]);
    ssystem(cmd_buf);

/*     info("try:\n\tsudo ping6 -s 0 2001:0638:0709:1234::fffe:14\n" */
/* 	   "\tnc6 -u 2001:0638:0709:1234::fffe:14 1234\n\n"); */
    info("send me SIGUSR1 to dump the topology to a 'nwgraph.dot' in the cwd\n");
    info("send me SIGUSR2 to recompute and print source routes to every router\n");

    routing_init();
    send_configure();

    /* start tunneling */
    serial_tunnel(ser_src, tun_fd);

    /* clean up */
    close_serial_source(ser_src);
    //close(ser_fd);
    tun_close(tun_fd, dev);
    return 0;
}
