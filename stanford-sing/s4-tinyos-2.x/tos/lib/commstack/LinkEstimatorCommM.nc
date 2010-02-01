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
includes LinkEstimator;
includes ReverseLinkInfo;

module LinkEstimatorCommM {
  provides {
    interface Init;
    interface StdControl;
    interface FreezeThaw;
    interface AMSend[ uint8_t am];
    interface Receive[uint8_t am];
  }
  uses {
    interface StdControl as BottomStdControl;
    interface Init as BottomStdControlInit;
    interface AMSend as BottomSendMsg[ uint8_t am ];
    interface Receive as BottomReceiveMsg[ uint8_t am ];

    interface Timer<TMilli> as MinRateTimer;
    interface Random;
    
    interface LinkEstimator;
    interface StdControl as LinkEstimatorControl;
    interface Init as LinkEstimatorControlInit;
#ifdef TOSSIM
#else  
    interface CC2420Packet;
#endif
    interface Packet;
    interface AMPacket;

#ifdef SERIAL_LOGGING    
    interface AMPacket as SerialActiveMessagePacket;
    interface AMSend as SerialAMSend;
#endif
  }
}
implementation {
  
  bool filter_by_strength;

  uint32_t reverse_period;
  uint32_t reverse_jitter;
  uint8_t reverse_info_index; //This tells the linke estimator at which index to
                              //start when filling the ReverseLinkInfo.

  bool state_is_active;

  message_t send_buffer;
  ReverseLinkMsg * link_msg_ptr;
  ReverseLinkInfo link_info_buf;
  bool send_buffer_busy;
  
  uint8_t reverse_msg_length;
  
  bool initialized = FALSE;

    //inline functions
  inline uint8_t getRssi(message_t* m) {
#ifdef TOSSIM
         return *((uint8_t*)(m->metadata)+1);
#else
         return call CC2420Packet.getRssi(m);
#endif
  }


  command error_t Init.init()  {
    error_t err;
  
    state_is_active = TRUE;
    filter_by_strength = LINK_ESTIMATOR_FILTER_BY_STRENGTH;
    reverse_info_index = 0;
    reverse_period = I_REVERSE_LINK_PERIOD;
    reverse_jitter = I_REVERSE_LINK_JITTER;
    reverseLinkInfoInit(&link_info_buf);
    send_buffer_busy = FALSE;
    link_msg_ptr = (ReverseLinkMsg *)&send_buffer.data[0];
    reverse_msg_length = sizeof(ReverseLinkMsg);
    call LinkEstimatorControlInit.init();
    err = call BottomStdControlInit.init();
    
    initialized = TRUE;
    
    return err;
  }

  command error_t StdControl.start()  {
    if (!initialized) {
      call Init.init();
    }
  
    state_is_active = TRUE;
    call MinRateTimer.startOneShot(reverse_period);
    call LinkEstimatorControl.start();
    return call BottomStdControl.start();
  }

  command error_t StdControl.stop()  {
    call MinRateTimer.stop();
    call LinkEstimatorControl.stop();
    return call BottomStdControl.stop();
  }
 
  command error_t FreezeThaw.thaw() {
    dbg("BVR-debug","LinkEstimatorCommM$thaw\n");
    state_is_active = TRUE;
    call MinRateTimer.startOneShot(reverse_period);
    return SUCCESS;
  }

  command error_t FreezeThaw.freeze() {
    dbg("BVR-debug","LinkEstimatorCommM$freeze\n");
    call MinRateTimer.stop();
    state_is_active = FALSE;
    return SUCCESS;
  } 

  command error_t AMSend.send[ uint8_t am ]( uint16_t addr, message_t* msg, uint8_t length )  {
     dbg("BVR-debug","LinkEstimatorCommM$AMSend am=%d\n", am);

    return call BottomSendMsg.send[ am ]( addr, msg, length );
  }
  
  command void* AMSend.getPayload[ uint8_t am ]( message_t* msg, uint8_t len )  {
    return call BottomSendMsg.getPayload[ am ]( msg, len );
  }
    
  command uint8_t AMSend.maxPayloadLength[ uint8_t am ](  )  {
    return call BottomSendMsg.maxPayloadLength[ am ](  );
  }
  
  command error_t AMSend.cancel[ uint8_t am ]( message_t* msg )  {
      return call BottomSendMsg.cancel[ am ]( msg );
  }

  event void BottomSendMsg.sendDone[ uint8_t am ]( message_t* msg, error_t success )  {
    dbg("BVR-debug","LinkEstimatorCommM$sendDone: result:%d\n",success);
    if (msg == &send_buffer) {
      dbg("BVR-debug", "LinkEstimatorCommM:sendDone, packet (%p) is from us. result=%s\n",msg,(success==SUCCESS)?"ok":"failure");
      send_buffer_busy = FALSE;
      return ;
    } 
    return signal AMSend.sendDone[ am ]( msg, success );
  }

  event message_t* BottomReceiveMsg.receive[ uint8_t am ]( message_t* msg, void* payload, uint8_t len )  {
    bool found = FALSE;
    bool stored = FALSE;
    LEHeader* link_header_ptr = (LEHeader*)&msg->data[0];
    uint8_t reverse_quality;
    uint8_t reverse_expiration;
    uint8_t idx;
    
    if (link_header_ptr->last_hop == call AMPacket.address()) {
      dbg("BVR-debug", "LinkEstimatorCommM: received packet from ourselves!!! (%p)\n",msg);
      return msg;
    }

    //this will only use as estimates the packets that have a signal strength
    //better than SIGNAL_STRENGTH_FILTER_THRESHOLD
    if (  state_is_active && 
         (!filter_by_strength ||          
         (filter_by_strength && getRssi(msg) < SIGNAL_STRENGTH_FILTER_THRESHOLD)) /* &&          
         link_header_ptr->last_hop != call SerialActiveMessagePacket.address() */) {

      dbg("BVR-debug", "LinkEstimatorCommM: packet will be used for link estimation (strength:%d)\n",
                       getRssi(msg));
      link_msg_ptr = (ReverseLinkMsg*)&msg->data[0];

      found = (call LinkEstimator.find(link_header_ptr->last_hop, &idx) == SUCCESS);
      
      dbg("BVR-debug", "LinkEstimatorCommM.receive: Found or not %d\n", found);
      
      if (!found) {        
        stored = (call LinkEstimator.store(link_header_ptr->last_hop, 
                         link_header_ptr->seqno, getRssi(msg), &idx) == SUCCESS);
      } else {
        call LinkEstimator.updateSeqno(idx, link_header_ptr->seqno);
        call LinkEstimator.updateStrength(idx, getRssi(msg));
      }
      if (found || stored) {
        if (am == AM_LE_REVERSE_LINK_ESTIMATION_MSG) {
          reverseLinkInfoFromMsg(&link_info_buf, link_msg_ptr);
          
          dbg("S4-debug", "before reverseLinkInfoGetQuality:  %x %d rliPtr->num_elements=%d\n", &link_info_buf, call AMPacket.address(), link_info_buf.num_elements);
          if (reverseLinkInfoGetQuality(&link_info_buf, call AMPacket.address(),&reverse_quality) == SUCCESS) {
            reverse_expiration = (link_info_buf.total_links / link_info_buf.num_elements + 1) * 3;
            dbg("BVR-debug","LinkEstimatorCommM: links: %d received: %d expiration:%d\n",
                link_info_buf.total_links, link_info_buf.num_elements, reverse_expiration);
            call LinkEstimator.updateReverse(idx, reverse_quality, reverse_expiration);
          } else {
            call LinkEstimator.ageReverse(idx);
          }
        }
      } else {
        //msg does not fit in cache. will send up the stack anyway
        dbg("BVR-debug","LinkEstimatorCommM: neighbor (%d) cannot be stored now\n",link_header_ptr->last_hop);
      }
    } else {
      dbg("BVR-debug", "LinkEstimatorCommM: packet not used for link estimation (strength:%d)\n",
                       getRssi(msg));
    }
    dbg("BVR-debug","LinkEstimatorCommM: received message from:%d seqno:%d AM:%d strength:%d found:%d stored:%d\n",
          link_header_ptr->last_hop, link_header_ptr->seqno, am, getRssi(msg),found, stored);
    return signal Receive.receive[ am ]( msg, payload, len );
  }

  event void MinRateTimer.fired() {
    int32_t jitter;
    uint32_t interval;
    
    dbg("BVR-debug", "LinkEstimatorCommM.MinRateTimer.fired\n");

    if (!state_is_active) {
      return ;
    }

    jitter = ((call Random.rand32()) % reverse_jitter) - (reverse_jitter >> 1);
    interval = reverse_period + jitter;
    //schedule the next timer
    call MinRateTimer.startOneShot( interval);

    //see if we need to send the reverse beacon, or if we
    //  must send the reverse link information anyway
    dbg("BVR-debug","LinkEstimatorCommM:MinRateTimer$fired: will send packet\n");
    //ok, we send a packet if no one will! :)
    if (!send_buffer_busy) {
      //prepare packet
      link_msg_ptr = (ReverseLinkMsg*)&send_buffer.data[0];
      reverseLinkInfoReset(&link_info_buf);
      call LinkEstimator.setReverseLinkInfo(&link_info_buf,&reverse_info_index);
      reverseLinkInfoToMsg(&link_info_buf,link_msg_ptr);
      
      if (call BottomSendMsg.send[AM_LE_REVERSE_LINK_ESTIMATION_MSG](TOS_BCAST_ADDR,
                               &send_buffer, reverse_msg_length) == SUCCESS) {
        send_buffer_busy = TRUE;
        dbg("BVR-debug", "LinkEstimatorCommM:MinRateTimer$fired: successfully enqueued send\n");
      } else {
        dbg("BVR-debug", "LinkEstimatorCommM:MinRateTimer$fired: cannot send, send returned fail\n"); 
      }
    } else {
      dbg("BVR-debug", "LinkEstimatorCommM:MinRateTimer$fired: cannot send, buffer is busy\n");
    } 
    return ;    
  }

  event error_t LinkEstimator.canEvict(uint16_t addr) {
    return SUCCESS;
  }

  default event void AMSend.sendDone[ uint8_t am ]( message_t* msg, error_t success )  {
    return ;
  }

  default event message_t* Receive.receive[ uint8_t am ]( message_t* msg,void* payload, uint8_t len)  {
    return msg;
  }

#ifdef SERIAL_LOGGING  
  event void SerialAMSend.sendDone( message_t* msg, error_t success )  {
      return ;
  }
#endif


  
} //end of implementation  
