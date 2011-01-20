/*
 * "Copyright (c) 2009 Stanford University. All rights reserved.
 *
 * Permission to use, copy, modify, and distribute this software and
 * its documentation for any purpose, without fee, and without written
 * agreement is hereby granted, provided that the above copyright
 * notice, the following two paragraphs and the author appear in all
 * copies of this software.
 *
 * IN NO EVENT SHALL STANFORD UNIVERSITY BE LIABLE TO ANY
 * PARTY FOR DIRECT, INDIRECT, SPECIAL, INCIDENTAL, OR CONSEQUENTIAL
 * DAMAGES ARISING OUT OF THE USE OF THIS SOFTWARE AND ITS
 * DOCUMENTATION, EVEN IF STANFORD UNIVERSITY HAS BEEN
 * ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
 *
 * STANFORD UNIVERSITY SPECIFICALLY DISCLAIMS ANY WARRANTIES,
 * INCLUDING, BUT NOT LIMITED TO, THE IMPLIED WARRANTIES OF
 * MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE.  THE SOFTWARE
 * PROVIDED HEREUNDER IS ON AN "AS IS" BASIS, AND THE UNIVERSITY OF
 * CALIFORNIA HAS NO OBLIGATION TO PROVIDE MAINTENANCE, SUPPORT,
 * UPDATES, ENHANCEMENTS, OR MODIFICATIONS."
 *
 */

/*
 * Basestation application to collect the packets of the powernet motes.
 * This was been modified from the original BaseStation that comes with
 * TinyOS.
 *
 * @author: Maria Kazandjieva, <mariakaz@cs.stanford.edu>
 * @date: Oct 18, 2009
*/

#include "CtpDebugMsg.h"

module PowerNetBaseP {
  uses interface Boot;
  uses interface SplitControl as RadioControl;
  uses interface SplitControl as SerialControl;
  uses interface StdControl as RoutingControl;
  uses interface Send;
  uses interface Leds;
  uses interface RootControl;
  uses interface Receive;
  uses interface AMSend as UARTSend;
  uses interface CollectionPacket;
  uses interface CtpInfo;
  uses interface CtpCongestion;
  uses interface Random;
  uses interface Queue<message_t*>;
  uses interface Pool<message_t>;
  uses interface CollectionDebug;
  uses interface AMPacket;
  uses interface Packet as RadioPacket;
  uses interface Packet as UartPacket;
  uses interface AMPacket as UartAMPacket;
  uses interface AMPacket as RadioAMPacket;
}
implementation {
  task void uartEchoTask();
  message_t packet;
  message_t uartpacket;
  message_t* recvPtr = &uartpacket;
  uint8_t msglen;
  bool uartbusy = FALSE;
  bool firstTimer = TRUE;
  uint16_t seqno;
  am_addr_t src;

  event void Boot.booted() {
    call SerialControl.start();
  }
  event void SerialControl.startDone(error_t err) {
    call RadioControl.start();
  }
  event void RadioControl.startDone(error_t err) {
    if (err != SUCCESS) {
      call RadioControl.start();
    }
    else {
      call RoutingControl.start();
      if (TOS_NODE_ID % 500 == 0) {
	      call RootControl.setRoot();
      }
    }
  }

  event void RadioControl.stopDone(error_t err) {}
  event void SerialControl.stopDone(error_t err) {}	

  void failedSend() {
    dbg("App", "%s: Send failed.\n", __FUNCTION__);
    call CollectionDebug.logEvent(NET_C_DBG_1);
  }

   
  event void Send.sendDone(message_t* m, error_t err) {
  }
  

  event message_t* 
  Receive.receive(message_t* msg, void* payload, uint8_t len) {
    dbg("PowerBaseC", "Received packet at %s from node %hhu.\n", sim_time_string(), call CollectionPacket.getOrigin(msg));
    call Leds.led1Toggle();    
    if (!call Pool.size() <= (QUEUE_SIZE < 4)? 1:3)  {
      //      call CtpCongestion.setClientCongested(TRUE);
    }
    if (!call Pool.empty() && call Queue.size() < call Queue.maxSize()) {
      message_t* tmp = call Pool.get();
      src = call RadioAMPacket.source(msg);
      call Queue.enqueue(msg);
      if (!uartbusy) {
        post uartEchoTask();
      }
      return tmp;
    }

    return msg;
 }

 task void uartEchoTask() {
    dbg("Traffic", "Sending packet to UART.\n");
   if (call Queue.empty()) {
     return;
   }
   else if (!uartbusy) {
     message_t* msg = call Queue.dequeue();
     call UartPacket.clear(msg);
     call UartAMPacket.setSource(msg, src);
     dbg("Traffic", "Sending packet to UART.\n");
     if (call UARTSend.send(0xffff, msg, call RadioPacket.payloadLength(msg)) == SUCCESS) {
       uartbusy = TRUE;
     }
     else {
      call CollectionDebug.logEventMsg(NET_C_DBG_2,
				       call CollectionPacket.getSequenceNumber(msg),
				       call CollectionPacket.getOrigin(msg),
				       call AMPacket.destination(msg));
     }
   }
 }

  event void UARTSend.sendDone(message_t *msg, error_t error) {
    dbg("Traffic", "UART send done.\n");
    uartbusy = FALSE;
    call Pool.put(msg);
    if (!call Queue.empty()) {
      post uartEchoTask();
    } 
    else {
      //        call CtpCongestion.setClientCongested(FALSE);
    }
  }

  /* Default implementations for CollectionDebug calls.
   * These allow CollectionDebug not to be wired to anything if debugging
   * is not desired. */

    default command error_t CollectionDebug.logEvent(uint8_t type) {
        return SUCCESS;
    }
    default command error_t CollectionDebug.logEventSimple(uint8_t type, uint16_t arg) {
        return SUCCESS;
    }
    default command error_t CollectionDebug.logEventDbg(uint8_t type, uint16_t arg1, uint16_t arg2, uint16_t arg3) {
        return SUCCESS;
    }
    default command error_t CollectionDebug.logEventMsg(uint8_t type, uint16_t msg, am_addr_t origin, am_addr_t node) {
        return SUCCESS;
    }
    default command error_t CollectionDebug.logEventRoute(uint8_t type, am_addr_t parent, uint8_t hopcount, uint16_t metric) {
        return SUCCESS;
    }
 
}
