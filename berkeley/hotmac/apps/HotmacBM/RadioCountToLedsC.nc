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
 
#include <PrintfUART.h>

#include "Timer.h"
#include "RadioCountToLeds.h"
 
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
    interface Boot;
    interface Receive;
    interface AMSend;
    interface Timer<TMilli> as MilliTimer;
    interface SplitControl as AMControl;
    interface Packet;

    interface AMPacket;
    interface Timer<TMilli> as PrintTimer;
  }
}
implementation {

  message_t packet;

  bool locked;
  uint32_t counter = 0;
  int print_count = 0;

#define SEND_RATE 250
#define MODE_FAST 1
#define MODE_SLOW 2
  // send IPI=250
#define SEND_MODE MODE_SLOW
  // send continuously from sendDone
  // #define SEND_MODE MODE_FAST

  struct {
    uint16_t src;
    uint16_t valid:1;
    uint32_t minseq;
    uint32_t maxseq;
    uint32_t rxed;
  } stats[5];

  int find_sender(uint16_t who) {
    int i, fr = -1;
    for (i = 0; i < 5; i++) {
      if (stats[i].valid) {
        if (stats[i].src == who) {
          return i;
        }
      } else {
        fr = i;
      }
    }
    if (fr >= 0) {
      stats[fr].valid = 1;
      stats[fr].src = who;
    }
    return fr;
  }

  
  event void Boot.booted() {
    printfUART_init();
    call AMControl.start();
  }

  event void AMControl.startDone(error_t err) {
    if (err == SUCCESS) {
      memset(&stats, 0, sizeof(stats));
      call PrintTimer.startPeriodic(2048);
      if ((TOS_NODE_ID % 2) == 0 ) {
#if SEND_MODE == MODE_FAST
        #error
        call MilliTimer.startOneShot(SEND_RATE);
#else
        call MilliTimer.startPeriodic(SEND_RATE);
#endif
      }
    }
    else {
      call AMControl.start();
    }
  }

  event void AMControl.stopDone(error_t err) {
    // do nothing
  }
  
  event void PrintTimer.fired() {
    int i;
    print_count++;
    printfUART("---------------------\n");
    printfUART("Time: %i\n", print_count * 2);
    printfUART("node\tpdr\n");
    for (i = 0; i < 5; i++) {
      if (stats[i].valid && stats[i].rxed) {
        printfUART("%u\t%lu/%lu\n", stats[i].src, stats[i].rxed, stats[i].maxseq - stats[i].minseq + 1);
      }
    }
    printfUART("---------------------\n\n");
  }

  task void sendTask() {
    radio_count_msg_t* rcm = (radio_count_msg_t*)call Packet.getPayload(&packet, sizeof(radio_count_msg_t));
    counter++;
    if (rcm == NULL) {
      return;
    }

    rcm->counter = counter;
    if (call AMSend.send(TOS_NODE_ID - 1, &packet, sizeof(radio_count_msg_t)) == SUCCESS) {
      dbg("RadioCountToLedsC", "RadioCountToLedsC: packet sent.\n", counter);	
      locked = TRUE;
    } else {
      counter--;
    }
  }

  event void MilliTimer.fired() {
    dbg("RadioCountToLedsC", "RadioCountToLedsC: timer fired, counter is %hu.\n", counter);
    post sendTask();
  }

  event message_t* Receive.receive(message_t* bufPtr, 
				   void* payload, uint8_t len) {
    dbg("RadioCountToLedsC", "Received packet of length %hhu.\n", len);
    if (len != sizeof(radio_count_msg_t)) {return bufPtr;}
    else {
      radio_count_msg_t* rcm = (radio_count_msg_t*)payload;

      int i = find_sender(call AMPacket.source(bufPtr));
      if (i < 0) return bufPtr;
      if (rcm->counter == 0 || rcm->counter < stats[i].maxseq) {
        stats[i].minseq = stats[i].maxseq = stats[i].rxed = 0;
        print_count = 0;
      } else {
        if (!stats[i].minseq) {
          stats[i].minseq = rcm->counter;
          print_count = 0;
        }

        stats[i].maxseq = rcm->counter;
        stats[i].rxed ++;
      }


      if (rcm->counter & 0x1) {
	call Leds.led0On();
      }
      else {
	call Leds.led0Off();
      }
      if (rcm->counter & 0x2) {
	call Leds.led1On();
      }
      else {
	call Leds.led1Off();
      }
      if (rcm->counter & 0x4) {
	call Leds.led2On();
      }
      else {
	call Leds.led2Off();
      }
      return bufPtr;
    }
  }

  event void AMSend.sendDone(message_t* bufPtr, error_t error) {
    if (&packet == bufPtr) {
      locked = FALSE;
#if SEND_MODE == MODE_FAST
#error 
      post sendTask();
#endif
    }
  }

}




