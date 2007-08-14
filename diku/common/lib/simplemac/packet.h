/*
  Copyright (C) 2004 Klaus S. Madsen <klaussm@diku.dk>
  Copyright (C) 2006 Marcus Chang <marcus@diku.dk>

  This program is free software; you can redistribute it and/or modify
  it under the terms of the GNU General Public License as published by
  the Free Software Foundation; either version 2 of the License, or
  (at your option) any later version.

  This program is distributed in the hope that it will be useful,
  but WITHOUT ANY WARRANTY; without even the implied warranty of
  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
  GNU General Public License for more details.

  You should have received a copy of the GNU General Public License
  along with this program; if not, write to the Free Software
  Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA  02111-1307  USA
*/


#ifndef PACKET_H
#define PACKET_H

#define PACKET_MAX_PAYLOAD 122

typedef uint16_t mac_addr_t;
typedef uint8_t ieee_mac_addr_t[8];

/* Frame types */

enum fcf_stuff {
	FCF_FT_BEACON          = 0x0000,
	FCF_FT_DATA            = 0x0001,
	FCF_FT_ACK             = 0x0002,
	FCF_FT_MAC_COMMAND     = 0x0003,
	FCF_FT_MASK            = 0x0007,

/* Frame Control Field bits */

	FCF_SECENC             = 0x0008,
	FCF_FRAMEPENDING       = 0x0010,
	FCF_ACKREQ             = 0x0020,
	FCF_INTRAPAN           = 0x0040,

/* Addressing modes */
	FCF_DST_NO_ADDR        = 0x0000,
	FCF_DST_SHORT_ADDR     = 0x0800,
	FCF_DST_LONG_ADDR      = 0x0C00,
	FCF_DST_ADDR_MASK      = 0x0C00,

	FCF_SRC_NO_ADDR        = 0x0000,
	FCF_SRC_SHORT_ADDR     = 0x8000,
	FCF_SRC_LONG_ADDR      = 0xC000,
	FCF_SRC_ADDR_MASK      = 0xC000,

	FCS_CRC_OK_MASK        = 0x80,
	FCS_CORRELATION_MASK   = 0x7F,
};

typedef struct {
  int8_t rssi;
  uint8_t correlation;
} fsc_t;

struct packet
{
	uint8_t length;

	uint16_t fcf;
	uint8_t data_seq_no;
	mac_addr_t dest;
	mac_addr_t src;

	uint8_t data[PACKET_MAX_PAYLOAD - 2 * sizeof(mac_addr_t)];

        fsc_t fcs;
#ifdef __i386__
} __attribute__ ((packed));
#else
};
#endif

typedef struct packet packet_t;

//#include "../treeRoute/treePacket.h"

#endif
