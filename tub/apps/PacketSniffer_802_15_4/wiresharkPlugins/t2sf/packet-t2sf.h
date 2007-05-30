/* packet-T2_SF.h
 * Definitions for TinyOs2 SerialForwarder Message
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
    
#ifndef PACKET_T2SF_H
#define PACKET_T2SF_H

#define T2_SF_STANDARD_TCP_PORT 9002

/* sf header length in bytes */
#define T2_SF_HEADER_LEN 2

/* number of bytes forming the length field */
#define T2_SF_LENGTH_NUM_BYTES 1
#define T2_SF_TYPE_NUM_BYTES 1

/* offset of type field */
#define T2_SF_HEADER_LENGTH_OFFSET 0
#define T2_SF_HEADER_TYPE_OFFSET 1
    
static void dissect_t2sf(tvbuff_t *tvb, packet_info *pinfo, proto_tree *tree);

#endif
