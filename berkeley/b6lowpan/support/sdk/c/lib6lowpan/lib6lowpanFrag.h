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
#ifndef LIB6LOWPANFRAG_H_
#define LIB6LOWPANFRAG_H_

#include "IP.h"


typedef struct {
  uint16_t tag;            /* datagram label */
  uint16_t size;           /* the size of the packet we are reconstructing */
  ip_msg_t *buf;            /* the reconstruction location */
  uint16_t bytes_rcvd;     /* how many bytes from the packet we have
                              received so far */
  uint8_t timeout;
} reconstruct_t;

typedef struct {
  uint16_t tag;    /* the label of the datagram */
  uint16_t offset; /* how far into the packet we have sent, in bytes */
} fragment_t;



/*
 *  this function writes the next fragment which needs to be sent into
 *  the buffer passed in.  It updates the structures in process to
 *  reflect how much of the packet has been sent so far.
 *
 *  if the packet does not require fragmentation, this function will
 *  not insert a fragmentation header and will merely compress the
 *  headers into the packet.
 *
 */
uint8_t getNextFrag(ip_msg_t *msg, fragment_t *progress, uint8_t *buf, uint16_t len);


/*
 *  this function will copy the fragmented data located at pkt into
 *  the buffers allocated in the reconstruction structure.  This
 *  function should not be passed packets without fragmentation
 *  headers.
 *
 */
uint8_t addFragment(packed_lowmsg_t *lowmsg, reconstruct_t *recon);


enum {
  T_FAILED1 = 0,
  T_FAILED2 = 1,
  T_UNUSED =  2,
  T_ACTIVE =  3,
  T_ZOMBIE =  4,
};

#endif
