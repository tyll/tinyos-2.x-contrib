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

#include "BufferPool.h"

generic module BufferPoolP() {
  provides interface BufferPool[uint8_t nxt_hdr];
  uses interface Pool<small_t> as SmallPool;
  uses interface Pool<med_t> as MedPool;
  uses interface Pool<large_t> as LargePool;
} implementation {

  command ip_msg_t *BufferPool.get[uint8_t nxt_hdr](buffer_size_t size) {
    ip_msg_t *ret;

    if (size <= BUFFER_SMALL_SIZE) {
      ret = (ip_msg_t *)call SmallPool.get();
      if (ret != NULL) {
        ret->b_len = BUFFER_SMALL_SIZE;
        ret->hdr.nxt_hdr = nxt_hdr;
        ret->hdr.hlim = 0;
        return ret;
      }
    }
    
    if (size <= BUFFER_MED_SIZE) {
      ret = (ip_msg_t *)call MedPool.get(); 
      if (ret != NULL) {
        ret->b_len = BUFFER_MED_SIZE;
        ret->hdr.nxt_hdr = nxt_hdr;
        ret->hdr.hlim = 0;
        return ret;
      }
    }    
    if (size <= BUFFER_LARGE_SIZE) {
      ret = (ip_msg_t *)call LargePool.get(); 
      if (ret != NULL) {
        ret->b_len = BUFFER_LARGE_SIZE;
        ret->hdr.nxt_hdr = nxt_hdr;
        ret->hdr.hlim = 0;
        return ret;
      }
    }
    return NULL;
  }

  command void BufferPool.put[uint8_t nxt_hdr](ip_msg_t *buf) {
    if (buf == NULL) return;
    switch (buf->b_len) {
    case BUFFER_SMALL_SIZE:
      call SmallPool.put((small_t *)buf); break;
    case BUFFER_MED_SIZE:
      call MedPool.put((med_t *)buf); break;
    case BUFFER_LARGE_SIZE:
      call LargePool.put((large_t *)buf); break;
    }
    return;
  }
}
