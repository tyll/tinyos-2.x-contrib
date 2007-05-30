/* packet-802_15_4.h
 * Definitions for cc2420 packet dissector
 * Copyright 2007, Philipp Huppertz <huppertz@tkn.tu-berlin.de>
 *
 * $Id$
 *
 * Wireshark - Network traffic analyzer
 * By Gerald Combs <gerald@wireshark.org>
 * Copyright 1998 Gerald Combs
 *
 * This program is free software; you can redistribute it and/or
 * modify it under the terms of the GNU General Public License
 * as published by the Free Software Foundation; either version 2
 * of the License, or (at your option) any later version.
 * 
 * This program is distributed in the hope that it will be useful,
 * but WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 * GNU General Public License for more details.
 * 
 * You should have received a copy of the GNU General Public License
 * along with this program; if not, write to the Free Software
 * Foundation, Inc., 51 Franklin Street, Fifth Floor, Boston, MA  02110-1301, USA.*/
    
#ifndef PACKET_CC2420_H
#define PACKET_CC2420_H

/* header length of cc2420 1 byte length + 2 byte (crc, rssi, lqi) */
#define CC2420_HEADER_LEN 3

/* offset off length field */
#define CC2420_HEADER_LENGTH_OFFSET 1

/* describes the standard serial AM type to registrate with */
#define CC2420_STANDARD_AM_TYPE 0xD7

/* standard channel of cc2420 radio */
#define CC2420_CHANNEL 26
    
static void dissect_cc2420(tvbuff_t *tvb, packet_info *pinfo, proto_tree *tree);

#endif
