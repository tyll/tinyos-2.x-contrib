/*
 * Copyright (c) 2005-2006 Rincon Research Corporation
 * All rights reserved.
 *
 * Redistribution and use in source and binary forms, with or without
 * modification, are permitted provided that the following conditions
 * are met:
 * - Redistributions of source code must retain the above copyright
 *   notice, this list of conditions and the following disclaimer.
 * - Redistributions in binary form must reproduce the above copyright
 *   notice, this list of conditions and the following disclaimer in the
 *   documentation and/or other materials provided with the
 *   distribution.
 * - Neither the name of the Rincon Research Corporation nor the names of
 *   its contributors may be used to endorse or promote products derived
 *   from this software without specific prior written permission.
 *
 * THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS
 * ``AS IS'' AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT
 * LIMITED TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS
 * FOR A PARTICULAR PURPOSE ARE DISCLAIMED.  IN NO EVENT SHALL THE
 * RINCON RESEARCH OR ITS CONTRIBUTORS BE LIABLE FOR ANY DIRECT, INDIRECT,
 * INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES
 * (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR
 * SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION)
 * HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT,
 * STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE)
 * ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED
 * OF THE POSSIBILITY OF SUCH DAMAGE
 */

#include "Blaze.h"
#include "Acknowledgements.h"
#include "Fcf.h"

/**
 * This module takes care of manipulating the FCF byte to specify the 
 * type of outbound packet.  It also manipulates the FCF byte to include
 * acknowledgements, and waits for an acknowledgement before signaling
 * sendDone() if it needs to.
 *
 * Acknowledgments MUST be checked immediately at sendDone() before
 * the next packet is sent since we don't allocate space in the message_t
 * to store the wasAcked boolean.  If we need to store each ack response
 * in the message, the FCF byte would be the place to do it.
 *
 * @author David Moss
 */
 
module AcknowledgementsP {
  provides {
    interface Send[radio_id_t radioId];
    interface PacketAcknowledgements;
  }
  
  uses {
    interface BlazePacketBody;
    interface Send as SubSend[radio_id_t radioId];
    interface ChipSpiResource;
    interface Alarm<T32khz,uint32_t> as AckWaitTimer;
    interface AckReceive;
    
    interface Leds;
  }
}

implementation {

  enum {
    S_IDLE,
    S_SENDING_ACK,
    S_SENDING_NOACK,
    S_ACK_WAIT,
    S_SEND_DONE,
  };
  
  
  /** Message currently being sent if it requires an ack */
  message_t *myMsg;
  
  /** Need a state to know if the timer fire is ours, and for Chip SPI abort */
  uint8_t state = S_IDLE;
  
  /** Current radio ID we're servicing */
  uint8_t radioId;
  
  /** TRUE if the current message was acknowledged */
  bool wasAcked;
  
  
  /***************** Prototypes ****************/
  task void sendDone();
  void setAck(message_t *msg, bool acked);
  
  /***************** Send Commands ****************/
  /**
   * By this point, the length should already be set in the message itself.
   * @param msg the message to send
   * @param len IGNORED
   * @return SUCCESS if we're going to try to send the message.
   *     FAIL if you need to reevaluate your code
   */
  command error_t Send.send[radio_id_t id](message_t* msg, uint8_t len) {
    error_t error;
    uint8_t myState;
    atomic myState = state;
    
    if(myState != S_IDLE) {
      // Still waiting for the last ack
      return EBUSY;
    }
    
    if(((call BlazePacketBody.getHeader(msg))->fcf >> FCF_ACK_REQ) & 0x1) {
      atomic state = S_SENDING_ACK;
      
    } else {
      atomic state = S_SENDING_NOACK;
    }
    
    radioId = id;
    atomic myMsg = msg;
    
    (call BlazePacketBody.getHeader(msg))->fcf |=
        ( FRAME_TYPE_DATA << FCF_FRAME_TYPE );
    
    setAck(myMsg, FALSE);
        
    error = call SubSend.send[id](msg, len);
    
    if(error != SUCCESS) {
      atomic state = S_IDLE;
      atomic myMsg = NULL;
    }
    
    return error;
  }

  command error_t Send.cancel[radio_id_t id](message_t* msg) {
    return call SubSend.cancel[id](msg);
  }

  command uint8_t Send.maxPayloadLength[radio_id_t id]() { 
    return call SubSend.maxPayloadLength[id]();
  }

  command void *Send.getPayload[radio_id_t id](message_t* msg, uint8_t len) {
    return call SubSend.getPayload[id](msg, len);
  }
  
  
  /***************** PacketAcknowledgements Commands ****************/
  async command error_t PacketAcknowledgements.requestAck( message_t *msg ) {
    (call BlazePacketBody.getHeader( msg ))->fcf |= 1 << FCF_ACK_REQ;
    return SUCCESS;
  }
  
  async command error_t PacketAcknowledgements.noAck( message_t *msg ) {
    (call BlazePacketBody.getHeader( msg ))->fcf &= ~(1 << FCF_ACK_REQ);
    return SUCCESS;
  }
  
  /**
   * Note we do not store the acknowledgment inside the message_t struct.
   * You must call wasAcked() during sendDone() before the next message is
   * sent for it to be valid.
   */
  async command bool PacketAcknowledgements.wasAcked(message_t *msg) {
    return wasAcked;
    //return (((call BlazePacketBody.getHeader( msg ))->fcf) >> FCF_ACK_RETRIEVED) & 0x1;
  }
  
  
  /***************** BackoffTimer Events ****************/
  async event void AckWaitTimer.fired() {
    uint8_t myState;
    atomic myState = state;
    if(myState == S_ACK_WAIT) {
      // Our ack wait period expired with no luck...
      atomic state = S_SEND_DONE;
      call ChipSpiResource.attemptRelease();
      post sendDone();
    }
  }
  
  
  /***************** SubSend Events ****************/
  event void SubSend.sendDone[radio_id_t id](message_t *msg, error_t error) {
    uint8_t myState;
    atomic myState = state;
    if(myState == S_SENDING_NOACK) {
      post sendDone();
      
    } else if(myState == S_SENDING_ACK) {
      atomic state = S_ACK_WAIT;
      call AckWaitTimer.start(BLAZE_ACK_WAIT);
      
    }
  }
  
  /***************** AckReceive Events ****************/
  async event void AckReceive.receive( am_addr_t source, am_addr_t destination, uint8_t dsn ) {
    message_t *atomicMsg;
    blaze_header_t *header;
    uint8_t myState;
    
    atomic atomicMsg = myMsg;
    header = call BlazePacketBody.getHeader(atomicMsg);
    atomic myState = state;
    
    if(myState == S_ACK_WAIT) {
      if((source == header->dest || header->dest == AM_BROADCAST_ADDR) &&
          destination == header->src &&
              dsn == header->dsn) {
                
        // This is our acknowledgement
        setAck(atomicMsg, TRUE);
        
        /**
         * The rest of this would speed up the amount of time it takes to send
         * the next packet.  But it also makes channel sharing unfair, because
         * other nodes are waiting to use the channel.  You can put this back in
         * and let one node capture the channel for a short period of time, 
         * but I'll take it out to let the nodes share the channel fairly.
        
        atomic state = S_SEND_DONE;
        call AckWaitTimer.stop();
        call ChipSpiResource.attemptRelease();
        post sendDone();
         */
      }
    }
  }
  
  /***************** ChipSpiResource Events ***************/
  /**
   * The SPI bus is about to be automatically released.  Modules that aren't
   * using the SPI bus but still want the SPI bus to stick around must call
   * abortRelease() within the event.
   */
  async event void ChipSpiResource.releasing() {
    uint8_t myState;
    atomic myState = state;
    
    if(myState == S_SENDING_ACK || myState == S_ACK_WAIT) {
      // Csma is trying to release the SPI bus. Let the chip own the SPI bus
      // so it's immediately available when Receive needs it.
      call ChipSpiResource.abortRelease();
    }
  }
  
  /***************** Tasks ****************/
  task void sendDone() {
    atomic state = S_IDLE;
    signal Send.sendDone[radioId](myMsg, SUCCESS);
  }
  
  
  void setAck(message_t *msg, bool acked) {
    wasAcked = acked;
    
    /*
    if(wasAcked) {
      ((call BlazePacketBody.getHeader( msg ))->fcf) |= (1 << FCF_ACK_RETRIEVED);
    } else {
      ((call BlazePacketBody.getHeader( msg ))->fcf) &= ~(1 << FCF_ACK_RETRIEVED);
    }
    */
  }
  
  /***************** Defaults ****************/
  default command error_t SubSend.send[radio_id_t id](message_t* msg, uint8_t len) {
    return EINVAL;
  }

  default command error_t SubSend.cancel[radio_id_t id](message_t* msg) {
    return EINVAL;
  }

  default command uint8_t SubSend.maxPayloadLength[radio_id_t id]() { 
    return 0;
  }

  default command void *SubSend.getPayload[radio_id_t id](message_t* msg, uint8_t len) {
    return NULL;
  }
 
  default event void Send.sendDone[radio_id_t id](message_t *msg, error_t error) {
  }
   
}
