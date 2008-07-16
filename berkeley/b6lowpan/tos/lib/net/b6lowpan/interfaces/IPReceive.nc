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

#include <IP.h>
#include "BufferPool.h"

/*
 * Buffer management is different when using IP then when using
 * default tinyos to support longer packets.
 *
 */

interface IPReceive {
  /*
   * The buffer which was previously requested by getBuffer has now
   * been filled in with application data.
   *
   * Since messages may be fragmented, it is possible for a reception
   * to fail.  In this case, source and payload will be set to NULL,
   * and len to zero.  Applications must check for this condition.
   *
   * @source a pointer to the 128-bit IPv6 address of the sender
   * @msg a pointer to the complete packet, including all headers.
   * @payload a pointer to the payload region of the message.  
   * @len the amount of valid data present in the payload
   */
  event ip_msg_t *receive(ip_msg_t *buf, void *payload, uint16_t len);

}
