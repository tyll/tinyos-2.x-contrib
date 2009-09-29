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

/**
 * Carrier Sense Multiple Access implementation
 * Rather than use an IO line to measure CCA, we rely directly on the radio
 * hardware to sample the CCA for us when attempting to transmit. 
 *
 * @author David Moss
 */
 
#include "Blaze.h"
#include "Csma.h"
#include "BlazeInit.h"

module CsmaP {
  provides {
    interface Send;
    interface Csma[am_id_t amId];
    interface Backoff as InitialBackoff[am_id_t amId];
    interface Backoff as CongestionBackoff[am_id_t amId];
    interface SplitControl;
  }
  
  uses {
    interface Resource;
    interface AsyncSend;
    interface Alarm<T32khz,uint16_t> as BackoffTimer;
    interface BlazePacket;
    interface BlazePacketBody;
    interface Random;
    interface Leds;
  }
}

implementation {

  /** The message we're sending */
  message_t *myMsg;
  
  
  /** The amount of time to currently backoff initially */
  uint16_t myBackoff;
  
  /** Error to pass back in sendDone */
  error_t myError;
    
  /** State of this component */
  uint8_t state;
  
  enum { 
    MAXIMUM_PROGRESSIVE_BACKOFF = 0x400,
  };
  
  
  enum {
    S_IDLE,
    S_SENDING,
    S_BACKOFF,
    S_FORCING,
    S_CANCEL,
    S_STOPPING,
  };
  
  /***************** Tasks ****************/
  task void forceSend();
  task void sendDone();
  
  void requestCca();
  void requestInitialBackoff();
  void requestCongestionBackoff();
  
  void initialBackoff();
  void congestionBackoff();
  
  /***************** SplitControl Commands ****************/
  command error_t SplitControl.start() {
    signal SplitControl.startDone(SUCCESS);
    return SUCCESS;
  }
 
  /**
   * If we're busy, stop being busy so we can shut off this radio.
   * Assume that if we're sending, we're trying to shut off the radio that
   * we're sending to. Also assume that there's a SplitControlManager
   * on top that will prevent the application layer from trying to send
   * another packet after we've shut down.
   */
  command error_t SplitControl.stop() {
    if(state != S_IDLE) {
      state = S_STOPPING;

    } else {
      signal SplitControl.stopDone(SUCCESS);
    }
    
    return SUCCESS;
  }
  
  /***************** Send Commands ****************/
  /**
   * By this point, the length should already be set in the message itself.
   * @param msg the message to send
   * @param len IGNORED
   * @return SUCCESS if we're going to try to send the message.
   *     FAIL if you need to reevaluate your code
   */
  command error_t Send.send(message_t* msg, uint8_t len) {
    if(state != S_IDLE) {
      return FAIL;
    }
    
    state = S_BACKOFF;
    
    atomic {
      myMsg = msg;
    }
    
    requestCca();
    
    if(!myBackoff) {
      state = S_FORCING;
      call Resource.request();
            
    } else {
      initialBackoff();
    }
    
    return SUCCESS;
  }

  command error_t Send.cancel(message_t* msg) {
    message_t *atomicMsg;
    atomic atomicMsg = myMsg;
    
    if(state != S_IDLE && (msg == atomicMsg)) {
      state = S_CANCEL;
      return SUCCESS;
    }
   
    return FAIL;
  }

  command uint8_t Send.maxPayloadLength() { 
    return TOSH_DATA_LENGTH;
  }

  command void *Send.getPayload(message_t* msg, uint8_t len) {
    if(len <= TOSH_DATA_LENGTH) {
      return msg->data;
    } else {
      return NULL;
    }
  }
  
  /***************** Resource Events ****************/
  event void Resource.granted() {
    if(state == S_BACKOFF) {
    
#if BLAZE_CSMA_LEDS
      call Leds.led2On();
#endif

      if(call AsyncSend.send(myMsg, FALSE, (call BlazePacketBody.getMetadata(myMsg))->rxInterval) != SUCCESS) {
      
#if BLAZE_CSMA_LEDS
      call Leds.led2Off();
#endif
      
        call Resource.release();
        congestionBackoff();
      }
    
    } else if(state == S_FORCING) {
      post forceSend();
      
    } else if(state == S_CANCEL || state == S_STOPPING) {
      atomic myError = ECANCEL;
      post sendDone();
    }
  }
  
  /***************** AsyncSend Events ****************/

  async event void AsyncSend.sendDone(error_t error) {
  
#if BLAZE_CSMA_LEDS
      call Leds.led2Off();
#endif
      
    atomic myError = error;
    post sendDone();
  }
  
  async event void AsyncSend.sending() {
  }
  
  /***************** Backoff Commands ****************/
  /**
   * Must be called within a requestInitialBackoff event
   * @param backoffTime the amount of time in some unspecified units to backoff
   */
  async command void InitialBackoff.setBackoff[am_id_t amId](uint16_t backoffTime) {
    atomic myBackoff = backoffTime + 1;
  }
  
  /**
   * Must be called within a requestCongestionBackoff event
   * @param backoffTime the amount of time in some unspecified units to backoff
   */
  async command void CongestionBackoff.setBackoff[am_id_t amId](uint16_t backoffTime) {
    atomic myBackoff = backoffTime + 1;
  }
  
  /***************** CSMA Commands ****************/
  /**
   * Must be called within a requestCca event
   * @param cca TRUE to use cca for the outbound packet, FALSE to not use CCA
   */
  async command void Csma.setCca[am_id_t amId](bool cca) {
    atomic myBackoff = cca;
  }
  

  /***************** BackoffTimer Events ****************/
  async event void BackoffTimer.fired() {
  
#if BLAZE_CSMA_LEDS
    if((state == S_CANCEL)
        || (state == S_STOPPING) 
        || (state == S_BACKOFF)) {
      call Leds.led0Off();
      call Leds.led1Off();
    }
#endif

    if((state == S_CANCEL) || (state == S_STOPPING)) {
      atomic myError = ECANCEL;
      post sendDone();
      return;
    }
    
    if(!(state == S_BACKOFF)) {
      // not my event to handle
      return;
    }
    
    call Resource.request();
  }
  
  
  /***************** Tasks ****************/
  /**
   * The radio is programmed up to only Tx on CCA, which we're not going
   * to change.  Plus, it would be pointless to try to transmit while something
   * is talking on the channel anyway.  So we keep trying repetitively until
   * the message sends.
   *
   * If what you're interested in is a jammer, then you need to edit 
   * some of the default register settings for this radio to disable the 
   * hardware CCA.
   */
  task void forceSend() {
    if(call AsyncSend.send(myMsg, TRUE, (call BlazePacketBody.getMetadata(myMsg))->rxInterval) != SUCCESS) {
      if((state == S_CANCEL) || (state == S_STOPPING)) {
        atomic myError = ECANCEL;
        post sendDone();
        
      } else {
        post forceSend();
      }
    }
  }
  
  task void sendDone() {
    error_t atomicError;
    atomic atomicError = myError;
       
    call Resource.release();
    
    if((state == S_STOPPING)) {
      signal SplitControl.stopDone(SUCCESS);
    }
    
    state = S_IDLE;
    signal Send.sendDone(myMsg, atomicError);
  }
  
  
  /**
   * Decide whether or not to use CCA for this transmission.
   * When complete, the myBackoff variable will read TRUE to use CCA and FALSE
   * to not use software CCA. 
   */
  void requestCca() {
    atomic myBackoff = TRUE;
    signal Csma.requestCca[(call BlazePacketBody.getHeader(myMsg))->type](myMsg);
  }
  
  /**
   * Obtain an inital backoff amount.
   * When complete, the variable myBackoff will be filled with the
   * correct amount of initial backoff time to use
   */
  void requestInitialBackoff() {
    atomic myBackoff = ( call Random.rand16() % 
        (0x1F * BLAZE_BACKOFF_PERIOD) + BLAZE_MIN_BACKOFF);
        
    signal InitialBackoff.requestBackoff[(call BlazePacketBody.getHeader(myMsg))->type](myMsg);
  }
  
  /**
   * Obtain a congestion backoff amount
   * When complete, the variable myBackoff will be filled with the
   * correct amount of congestion backoff time to use.
   */
  void requestCongestionBackoff() {
    atomic myBackoff = ( call Random.rand16() % 
        (0x7 * BLAZE_BACKOFF_PERIOD) + BLAZE_MIN_BACKOFF);
        
    signal CongestionBackoff.requestBackoff[(call BlazePacketBody.getHeader(myMsg))->type](myMsg);
  }
  
  
  /**
   * Backoff for the initial backoff period of time
   */
  void initialBackoff() {
    uint16_t atomicBackoff;
    requestInitialBackoff();
    atomic atomicBackoff = myBackoff;
    
#if BLAZE_CSMA_LEDS
    call Leds.led0On();
#endif

    call BackoffTimer.start( atomicBackoff );
  }
  
  /**
   * Backoff because of a congested channel
   */
  void congestionBackoff() {
    uint16_t atomicBackoff;

    requestCongestionBackoff();
    atomic atomicBackoff = myBackoff;

#if BLAZE_CSMA_LEDS
    call Leds.led1On();
#endif
    
    call BackoffTimer.start( atomicBackoff );
  }
  
  
  /***************** Defaults ****************/
  default event void Send.sendDone(message_t* msg, error_t error) { }
  
  default async command error_t AsyncSend.send(void *msg, bool force, uint16_t preamble) { }
  
  default async event void InitialBackoff.requestBackoff[am_id_t amId](message_t *msg) { }
  default async event void CongestionBackoff.requestBackoff[am_id_t amId](message_t *msg) { }
  default async event void Csma.requestCca[am_id_t amId](message_t *msg) { }
  
  default event void SplitControl.startDone(error_t error) { }
  default event void SplitControl.stopDone(error_t error) { }
    
}


