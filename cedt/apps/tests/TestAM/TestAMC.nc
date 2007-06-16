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
  Intel Research Berkeley, 2150 Shattuck Avenue, Suite 1300, Berkeley, CA, 
 * 94704.  Attention:  Intel License Inquiry.
 */
 
#include "Timer.h"

/**
 * Implementation of the TestAM application.  TestAM sends active message 
 * broadcasts at 1Hz and blinks LED 0 whenever it has sucessfully sent a 
 * broadcast. Whenever it receives one of these broadcasts from another 
 * node, it blinks LED 1.  It uses the radio HIL component <tt>ActiveMessageC</tt>, 
 * and its packets are AM type 240.  This application is useful for testing 
 * AM communication and the ActiveMessageC component.
 *
 * @author Philip Levis
 * @date   May 16 2005
 */

module TestAMC {
  uses {
    interface Leds;
    interface Boot;
    interface Receive;
    interface AMSend;
    interface Timer<TMilli> as MilliTimer;
    interface SplitControl;
  }
}
implementation {

  message_t packet;

  bool locked;
  uint8_t counter = 0;
  uint8_t rxcounter = 0;
  event void Boot.booted() {
    call SplitControl.start();
  }
  
  event void MilliTimer.fired() {
    dbg("TestAM","Timer Fired %d at %s\n",counter,sim_time_string());
    if (locked) {
      return;
     }
    else {
      uint16_t nodeid;
      switch (TOS_NODE_ID){
        case 0: nodeid = 1;break;
        case 1: nodeid = 0;break;
        default: nodeid = AM_BROADCAST_ADDR;
      }
      packet.data[1] = counter;
      packet.data[0] = TOS_NODE_ID;
      if (call AMSend.send(nodeid,&packet, 2) == SUCCESS) {
        call Leds.led0On();
	counter++;
        locked = TRUE;
      }
      else {
       dbg("TestAM","Packet sending failed\n");
      }
    }
  }

  event message_t* Receive.receive(message_t* bufPtr, 
				   void* payload, uint8_t len) {
    rxcounter++;
    dbg("TestAM","%d Packets Received\n",rxcounter);
    call Leds.led1Toggle();
    return bufPtr;
  }

  event void AMSend.sendDone(message_t* bufPtr, error_t error) {
    if (&packet == bufPtr) {
      dbg("TestAM","%d Packets Sent\n",counter);
      locked = FALSE;
      call Leds.led0Off();
    }
  }

  event void SplitControl.startDone(error_t err) {
    call MilliTimer.startPeriodic(1000);
  }

  event void SplitControl.stopDone(error_t err) {
  }

}




