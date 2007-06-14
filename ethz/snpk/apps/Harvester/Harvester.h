/* Copyright (c) 2007 ETH Zurich.
*  All rights reserved.
*
*  Redistribution and use in source and binary forms, with or without
*  modification, are permitted provided that the following conditions
*  are met:
*
*  1. Redistributions of source code must retain the above copyright
*     notice, this list of conditions and the following disclaimer.
*  2. Redistributions in binary form must reproduce the above copyright
*     notice, this list of conditions and the following disclaimer in the
*     documentation and/or other materials provided with the distribution.
*  3. Neither the name of the copyright holders nor the names of
*     contributors may be used to endorse or promote products derived
*     from this software without specific prior written permission.
*
*  THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS `AS IS'
*  AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE
*  IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE
*  ARE DISCLAIMED.  IN NO EVENT SHALL THE COPYRIGHT HOLDERS OR CONTRIBUTORS
*  BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR
*  CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO, LOSS OF USE, DATA,
*  OR PROFITS) HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN
*  CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE)
*  ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF
*  THE POSSIBILITY OF SUCH DAMAGE.
*
*  For additional information see http://www.btnode.ethz.ch/
*
*  $Id$
* 
*/

/**
 * @author Roman Lim
 */

#ifndef HARVESTER_H
#define HARVESTER_H
#include <AM.h>

enum {
  /* Number of readings per message. If you increase this, you may have to
     increase the message_t size. */
  // NREADINGS = 1,
  /* Default sampling period. */
  SAMPLING_INTERVAL = 10240,
  AM_HARVESTER = 0x93,
  AM_TREEINFO = 0x94,
  TREEINFO_INT = 30000,
  LPL_INT = 150UL,
  NEIGHBOR_TABLE_SIZE = 3,
//  TX_POWER=3, /* 0 - 31, use lower values to generate multihop network in a smaller place */
};

typedef nx_struct harvester {
  nx_uint8_t dsn; /* serial number */
  nx_uint16_t id; /* Mote id of sending mote. */
  nx_uint16_t value; /* the value of the sample */
} harvester_t;

typedef nx_struct treeinfoNeighour {
	nx_am_addr_t nodeId; /* This is the current parent of the node. */
	nx_uint16_t etx;		/* linkquality to parent */ 
} nx_treeinfoNeighour_t;


typedef nx_struct treeinfo {
	nx_am_addr_t id; /* Mote id of sending mote. */
	nx_am_addr_t parent; /* This is the current parent of the node. */
	nx_uint8_t numNeighbours;
	nx_treeinfoNeighour_t neighbours[NEIGHBOR_TABLE_SIZE]; /* NEIGHBOR_TABLE_SIZE is defined in LE */
	nx_uint8_t sn;
} treeinfo_t;

#endif
