// ex: set tabstop=2 shiftwidth=2 expandtab syn=c:
// $Id$

/*
 * "Copyright (c) 2000-2003 The Regents of the University  of California.
 * All rights reserved.
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
 * Copyright (c) 2002-2003 Intel Corporation
 * All rights reserved.
 *
 * This file is distributed under the terms in the attached INTEL-LICENSE
 * file. If you do not find these files, copies can be found by writing to
 * Intel Research Berkeley, 2150 Shattuck Avenue, Suite 1300, Berkeley, CA,
 * 94704.  Attention:  Intel License Inquiry.
 */

/*
 * Authors:  Rodrigo Fonseca
 * Date Last Modified: 2005/05/26
 */

#ifndef _NEXT_HOP_INFO_H
#define _NEXT_HOP_INFO_H
enum {
  BVR_MAX_NEXT_HOPS = 6,
  BVR_MAX_FALLBACK_NEXT_HOPS = 1,
};


typedef nx_struct {
  nx_uint16_t next_hops[BVR_MAX_NEXT_HOPS + BVR_MAX_FALLBACK_NEXT_HOPS];
  nx_uint16_t  distances[BVR_MAX_NEXT_HOPS];
  nx_uint8_t  n;
  nx_uint8_t  f;
  nx_uint8_t  index;
}  nextHopInfo;

void inline nextHopInfoInit(nextHopInfo *this) {
  this->n = 0;
  this->f = 0;
  this->index = 0;
}

/* Inserts the tuple <addr,distance> into nextHopInfo in the right place.
 * The current implementation will find the right place and shift the rest
 * to the right.
 */
error_t nextHopInfoAddOrdered(nextHopInfo* this, uint16_t addr,
                                  uint16_t distance, uint8_t quality) {
  int i;
  if (this == NULL || this->n == BVR_MAX_NEXT_HOPS) {
    return FAIL;
  }
}

/************************/
/* forwardRoutingBuffer */
/************************/

typedef struct {
  bool busy;
  message_t* msg;
  uint16_t min_dist;     //hold the min(incoming pkt dist, dist at this node)
  nextHopInfo next_hops;

#ifdef CRROUTING
    uint16_t next_hop;
#endif
}  forwardRoutingBuffer;

static inline void forwardRoutingBufferFree(forwardRoutingBuffer *this) {
  this->busy = FALSE;
  nextHopInfoInit(&this->next_hops);
}

static inline void forwardRoutingBufferInit(forwardRoutingBuffer *this, message_t* msg) {
  forwardRoutingBufferFree(this);
  this->msg = msg;
}



#endif
