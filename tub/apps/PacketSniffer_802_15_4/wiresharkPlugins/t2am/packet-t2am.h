/* packet-t2sam.h
 * Definitions for TinyOs2 Serial Active Message
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
    
#ifndef PACKET_T2AM_H
#define PACKET_T2AM_H

/* standard serial packet type for TOS2 AM */
#define T2_AM_SERIAL_TYPE 0x0

/* serial am header length is 7 bytes */
#define T2_AM_HEADER_LEN 7
    
#define T2_AM_HEADER_DEST_LEN 2
#define T2_AM_HEADER_SRC_LEN  2 
#define T2_AM_HEADER_LENGTH_LEN 1
#define T2_AM_HEADER_GROUP_LEN 1
#define T2_AM_HEADER_TYPE_LEN 1
    

#define T2_AM_HEADER_DEST_OFFSET 0
#define T2_AM_HEADER_SRC_OFFSET (T2_AM_HEADER_DEST_OFFSET + T2_AM_HEADER_DEST_LEN)
#define T2_AM_HEADER_LENGTH_OFFSET (T2_AM_HEADER_SRC_OFFSET + T2_AM_HEADER_SRC_LEN)
#define T2_AM_HEADER_GROUP_OFFSET (T2_AM_HEADER_LENGTH_OFFSET + T2_AM_HEADER_LENGTH_LEN)
#define T2_AM_HEADER_TYPE_OFFSET (T2_AM_HEADER_GROUP_OFFSET  + T2_AM_HEADER_GROUP_LEN)
#define T2_AM_DATA_OFFSET (T2_AM_HEADER_TYPE_OFFSET + T2_AM_HEADER_TYPE_LEN)
    
static void dissect_t2am(tvbuff_t *tvb, packet_info *pinfo, proto_tree *tree);

#endif
