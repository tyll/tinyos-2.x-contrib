/* ex: set tabstop=2 shiftwidth=2 expandtab syn=c:*/
/* $Id$ */

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

includes AM;

module FilterLocalCommM {
  provides {
    interface StdControl;
    interface Init;
    /*interface SendMsg[ uint8_t am];
    interface ReceiveMsg[uint8_t am];*/
    interface AMSend[ uint8_t am];
    interface Receive[uint8_t am];
  }
  uses {
    interface StdControl as BottomStdControl;
    interface Init as BottomStdControlInit;
    
    
    interface AMSend as BottomSendMsg[ uint8_t am ];
    interface Receive as BottomReceiveMsg[ uint8_t am ];
    interface AMPacket;
    interface Packet;
  }
}
implementation {
  bool initialized = FALSE;

  command error_t Init.init()  {
    error_t err = call BottomStdControlInit.init();
    initialized = TRUE;
    
    return err;
  }

  command error_t StdControl.start()  {
    if (!initialized) {
      call Init.init();
    }
    return call BottomStdControl.start();
  }

  command error_t StdControl.stop()  {
    return call BottomStdControl.stop();
  }
  
  command error_t AMSend.send[ uint8_t am ]( uint16_t addr, message_t* msg, uint8_t length )  {
    dbg("BVR-debug","FilterLocalCommM$AMSend$send am=%d\n", am);

    return call BottomSendMsg.send[ am ]( addr,  msg, length );
  }
  
  command error_t AMSend.cancel[ uint8_t am ]( message_t* msg )  {
    return call BottomSendMsg.cancel[ am ]( msg );
  }
  
  command void* AMSend.getPayload[ uint8_t am ]( message_t* msg, uint8_t len )  {
    return call BottomSendMsg.getPayload[ am ]( msg, len );
  }
  
  command uint8_t AMSend.maxPayloadLength[ uint8_t am ](  )  {
      return call BottomSendMsg.maxPayloadLength[ am ](  );
  }

  event void BottomSendMsg.sendDone[ uint8_t am ]( message_t* msg, error_t success )  {
    dbg("BVR-temp","FilterLocalCommM$sendDone: result:%d\n",success);
    signal AMSend.sendDone[ am ]( msg, success );
  }

  //This is the only thing this module does: it filters messages which are not
  //for this node, in case the GenericComm being used is
  //GenericCommPromiscuous

  event message_t* BottomReceiveMsg.receive[ uint8_t am ](message_t* msg, void* payload, uint8_t len )  {
    if (call AMPacket.destination(msg) == call AMPacket.address() || call AMPacket.destination(msg) == TOS_BCAST_ADDR) {
      dbg("BVR-debug","FilterLocalCommM: addr:%d. Receive.\n",call AMPacket.destination(msg));
      return signal Receive.receive[ am ]( msg, payload, len );
    }
    dbg("BVR-debug","FilterLocalCommM: addr:%d. Drop.\n", call AMPacket.destination(msg));
    return msg;
  }


  default event void AMSend.sendDone[ uint8_t am ]( message_t* msg, error_t success )  {
    return;
  }

  default event message_t* Receive.receive[ uint8_t am ]( message_t* msg, void* payload, uint8_t len)  {
    return msg;
  }

} //end of implementation  
