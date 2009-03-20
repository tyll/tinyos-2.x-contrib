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

#include "sfsource.h"
#include "serialpacket.h"
#include "serialprotocol.h"

void hexprint(uint8_t *packet, int len)
{
  int i;

  for (i = 0; i < len; i++)
    printf("%02x ", packet[i]);
}

int main(int argc, char **argv)
{
  int fd;

  if (argc != 3)
    {
      fprintf(stderr, "Usage: %s <host> <port> - dump packets from a serial forwarder\n", argv[0]);
      exit(2);
    }
  fd = open_sf_source(argv[1], atoi(argv[2]));
  if (fd < 0)
    {
      fprintf(stderr, "Couldn't open serial forwarder at %s:%s\n",
	      argv[1], argv[2]);
      exit(1);
    }
  for (;;)
    {
      int len, i;
      uint8_t *packet = read_sf_packet(fd, &len);

      if (!packet)
	exit(0);

      if (len >= 1 + SPACKET_SIZE &&
	  packet[0] == SERIAL_TOS_SERIAL_ACTIVE_MESSAGE_ID)
	{
	  tmsg_t *msg = new_tmsg(packet + 1, len - 1);

	  if (!msg)
	    exit(0);

	  printf("dest %u, src %u, length %u, group %u, type %u\n  ",
		 spacket_header_dest_get(msg),
		 spacket_header_src_get(msg),
		 spacket_header_length_get(msg),
		 spacket_header_group_get(msg),
		 spacket_header_type_get(msg));
	  hexprint((uint8_t *)tmsg_data(msg) + spacket_data_offset(0),
		   tmsg_length(msg) - spacket_data_offset(0));

	  free(msg);
	}
      else
	{
	  printf("non-AM packet: ");
	  hexprint(packet, len);
	}
      putchar('\n');
      fflush(stdout);
      free((void *)packet);
    }
}
