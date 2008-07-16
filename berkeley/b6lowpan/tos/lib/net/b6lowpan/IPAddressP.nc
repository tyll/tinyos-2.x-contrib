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

#include <6lowpan.h>

// defined in lib6lowpan
extern ip6_addr_t my_address;
extern uint8_t globalPrefix;

module IPAddressP {
  provides interface IPAddress;

  uses interface ActiveMessageAddress;
} implementation {

  command hw_addr_t IPAddress.getShortAddr() {
    return TOS_NODE_ID;
  }

  command void IPAddress.setShortAddr(hw_addr_t newAddr) {
    TOS_NODE_ID = newAddr;
    call ActiveMessageAddress.setAddress(call ActiveMessageAddress.amGroup(), newAddr);
  }

  command ip6_addr_t *IPAddress.getIPAddr() {
    my_address[14] = TOS_NODE_ID >> 8;
    my_address[15] = TOS_NODE_ID & 0xff;
    return &my_address;
  }

  command void IPAddress.setPrefix(uint8_t *pfx) {
    int i;
    for (i = 0; i < 8; i++)
      my_address[i] = pfx[i];
    globalPrefix = 1;
  }

  command bool IPAddress.haveAddress() {
    return globalPrefix;
  }

  async event void ActiveMessageAddress.changed() {

  }

}
