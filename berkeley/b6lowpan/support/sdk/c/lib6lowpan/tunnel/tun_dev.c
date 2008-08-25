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

#include <unistd.h>
#include <fcntl.h>
#include <stdlib.h>
#include <stdio.h>
#include <string.h>
#include <syslog.h>
#include <errno.h>

#include <sys/ioctl.h>
#include <sys/socket.h>
#include <linux/if.h>
#include <linux/if_ether.h>

#include "lib6lowpan.h"
#include "tun_dev.h"



int tun_open(char *dev)
{
    struct ifreq ifr;
    int fd;

    if ((fd = open("/dev/net/tun", O_RDWR | O_NONBLOCK)) < 0)
	return -1;

    memset(&ifr, 0, sizeof(ifr));
    /* By default packets are tagged as IPv4. To tag them as IPv6,
     * thy need to be prefixed by struct tun_pi.
     */
    //ifr.ifr_flags = IFF_TUN | IFF_NO_PI;
    ifr.ifr_flags = IFF_TUN;
    if (*dev)
	strncpy(ifr.ifr_name, dev, IFNAMSIZ);

    if (ioctl(fd, TUNSETIFF, (void *) &ifr) < 0)
	goto failed;

    strcpy(dev, ifr.ifr_name);
    return fd;

  failed:
    close(fd);
    return -1;
}

int tun_close(int fd, char *dev)
{
    return close(fd);
}

/* Read/write frames from TUN device */

int tun_write(int fd, struct split_ip_msg *msg)
{
  uint8_t buf[INET_MTU + sizeof(struct tun_pi)], *packet;
  struct tun_pi *pi = (struct tun_pi *)buf;
  struct generic_header *cur;
  packet = (uint8_t *)(pi + 1);


  if (ntoh16(msg->hdr.plen) + sizeof(struct ip6_hdr) >= INET_MTU)
    return 1;

  pi->flags = 0;
  pi->proto = hton16(ETH_P_IPV6);

  memcpy(packet, &msg->hdr, sizeof(struct ip6_hdr));
  packet += sizeof(struct ip6_hdr);

  cur = msg->headers;
  while (cur != NULL) {
    memcpy(packet, cur->hdr.data, cur->len);
    packet += cur->len;
    cur = cur->next;
  }

  memcpy(packet, msg->data, msg->data_len);

  return write(fd, buf, sizeof(struct tun_pi) + sizeof(struct ip6_hdr) + ntoh16(msg->hdr.plen));
}

int tun_read(int fd, char *buf, int len)
{
  int out;
  out = read(fd, buf, sizeof(struct tun_pi) + len);

  return out - sizeof(struct tun_pi);
}
