// $Id$

/*									tab:4
 * "Copyright (c) 2000-2005 The Regents of the University  of California.  
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
 
#include <Ieee154.h>
#include <IeeeEui64.h>

#include "Timer.h"
#include "RadioCountToLeds.h"
#include "printfUART.h"
 
/**
 * Implementation of the RadioCountToLeds application. RadioCountToLeds 
 * maintains a 4Hz counter, broadcasting its value in an AM packet 
 * every time it gets updated. A RadioCountToLeds node that hears a counter 
 * displays the bottom three bits on its LEDs. This application is a useful 
 * test to show that basic AM communication and timers work.
 *
 * @author Philip Levis
 * @date   June 6 2005
 */

module RadioCountToLedsC @safe() {
  uses {
    interface Leds;
    interface Send;
    interface Timer<TMilli> as MilliTimer;
    interface SplitControl;
    interface LocalIeeeEui64;
    interface CC2420PacketBody;

    interface Ieee154Packet;
  }
}
implementation {
nx_struct ieee154_header_base {
  nxle_uint8_t length;
  nxle_uint16_t fcf;
  nxle_uint8_t dsn;
  nxle_uint16_t destpan;
};

  message_t packet;

  bool locked;
   uint16_t counter = 0;
   ieee_eui64_t m_dest = {{0x00, 0x12, 0x6d, 0x45, 0x50, 0x79, 0xd6, 0x9a}};
   // ieee_eui64_t m_dest = {{0xff, 0xff, 0xff, 0xff, 0xff, 0xff, 0xff, 0xff}};

   // ieee_eui64_t m_dest = {{0xed, 0x51, 0x7a, 0x50, 0x45, 0x6d, 0x12, 0x00}};
   // ieee_eui64_t m_dest = {{0x0, 0x12, 0x6d, 0x45, 0x50, 0x7a, 0x51, 0xed}};

  event void SplitControl.startDone(error_t err) {
    printfUART("StartDone\n");
    if (err == SUCCESS && TOS_NODE_ID == 1) {
      call MilliTimer.startPeriodic(250);
    }
    else {
      call SplitControl.start();
    }
  }

  event void SplitControl.stopDone(error_t err) {
    // do nothing
  }

  uint8_t *writeHeader(uint8_t * buf) {
    nx_struct ieee154_header_base *hdr = (nx_struct ieee154_header_base *)(buf);

    nxle_uint16_t *dest = (nxle_uint16_t *)(buf + sizeof(nx_struct ieee154_header_base));
    ieee_eui64_t  *src  = (ieee_eui64_t *)(dest + 1);

/*     ieee_eui64_t  *dst  = (ieee_eui64_t *)(buf + sizeof(nx_nx_struct ieee154_header_base)); */
/*     ieee_eui64_t  *src  = (ieee_eui64_t *)(dst + 1); */
    
    hdr->fcf = (IEEE154_ADDR_EXT << IEEE154_FCF_SRC_ADDR_MODE) |
      (IEEE154_ADDR_SHORT << IEEE154_FCF_DEST_ADDR_MODE);

    hdr->destpan = TOS_AM_GROUP;
    //*dst    = m_dest;
    *dest   = IEEE154_BROADCAST_ADDR;
    *src    = call LocalIeeeEui64.getId();

    printfUART("send fcf: 0x%x (%p)\n", hdr->fcf, hdr);

    return (uint8_t *)(src + 1);
  }
  
  event void MilliTimer.fired() {
    counter++;
    dbg("RadioCountToLedsC", "RadioCountToLedsC: timer fired, counter is %hu.\n", counter);
    call Leds.led0Toggle();
    if (locked) {
      return;
    }
    else {
      uint8_t *payload = call Send.getPayload(&packet, sizeof(radio_count_msg_t) +  
                                              sizeof(nx_struct ieee154_header_base) + 10);
      radio_count_msg_t* rcm = (radio_count_msg_t *)writeHeader(payload);

      rcm->network = 27;
      rcm->counter = counter;
      printfUART("sending val: %i\n", counter);
      if (call Send.send(&packet, (uint8_t *)(rcm + 1) - payload) == SUCCESS) {
	dbg("RadioCountToLedsC", "RadioCountToLedsC: packet sent.\n", counter);	
        call Leds.led2Toggle();
	locked = TRUE;
      } else {
        printfUART("Send failed!\n");
      }
    }
  }


  event void Send.sendDone(message_t* bufPtr, error_t error) {
    ieee154_addr_t addr;
    printfUART("sendDone: %i\n", error);
    if (&packet == bufPtr) {
      locked = FALSE;
      call Ieee154Packet.source(bufPtr, &addr); 
      printfUART("source mode: %i addr: %x %x\n", addr.ieee_mode,
                 addr.i_laddr.data[0], addr.i_laddr.data[1]);
      call Ieee154Packet.destination(bufPtr, &addr);
      printfUART("dest mode: %i addr: %x %x\n", addr.ieee_mode,
                 addr.i_laddr.data[0], addr.i_laddr.data[1]);
    }
  }
}




