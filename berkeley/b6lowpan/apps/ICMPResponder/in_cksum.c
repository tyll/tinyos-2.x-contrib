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

#include "in_cksum.h"


uint16_t in_cksum(const vec_t *vec, int veclen) {

  uint32_t sum = 0;
  uint16_t res = 0;
  uint16_t cur = 0;
  int i;


  uint8_t *w;
  
  for (; veclen != 0; vec++, veclen--) {
    if (vec->len == 0)
      continue;
    
    w = (uint8_t *)vec->ptr;
    for (i = 0; i < vec->len; i++) {
      if (i % 2 == 0) {
        cur |= ((uint16_t)w[i]) << 8;
        if (i + 1 == vec->len) {
          goto finish;
        }
      } else {
        cur |= w[i];
      finish:
        sum += cur;
        res = (sum & 0xffff) + (sum >> 16);
        cur = 0;
      }
    }
  }
  return ~res ;
}

