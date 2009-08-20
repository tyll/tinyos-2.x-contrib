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
#include "RadioStackPacket.h"

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
    
    interface GpioInterrupt as EnergyInterrupt;
    interface GpioInterrupt as RxInterrupt;
    interface GeneralIO as EnergyIo;
    interface GeneralIO as Csn;
    
    interface BlazeRegister as IOCFG2;
    
    interface BlazeRegister as PKTSTATUS;
    interface BlazeStrobe as SIDLE;
    
    interface BlazePacket;
    interface BlazePacketBody;
    interface BlazeRegSettings;
    
    interface ReceiveMode;
    
    interface Timer<TMilli> as TimeoutTimer;
    
    interface Random;
    interface Leds;
  }
}

implementation {
  
  /** The amount of time to backoff */
  norace uint16_t myBackoff;
  
  /** TRUE if the current packet should use clear channel assessments */
  bool useCca;
  
  /** Error to pass back in sendDone */
  error_t myError;

  /** TRUE if the energy interrupt fired */
  bool energyInterruptFired;
  
  /** TRUE if the energy detection is turned on */
  bool energyDetectEnabled;
  
  /** Total number of congestion backoffs on the current transmission */
  uint16_t totalCongestionBackoffs;
  
  /** State of this component */
  uint8_t state;
  
  enum {
    S_IDLE,
    S_SENDING,
    S_START_INITIAL_BACKOFF,
    S_BACKOFF,
    S_FORCING,
    S_CANCEL,
    S_STOPPING,
  };
  
  /***************** Tasks ****************/
  task void forceSend();
  task void sendDone();
  task void delayedRequestResource();
  
  void runSpiOperations();
  void enableEnergyDetect();
  void disableEnergyDetect();
  
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
    if(state) {
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
    if(state) {
      return FAIL;
    }
    
    state = S_START_INITIAL_BACKOFF;
    
    requestCca();
    
    if(!useCca) {
      state = S_FORCING;
      
    } else {
      call TimeoutTimer.startOneShot(BLAZE_CSMA_TIMEOUT);
    }
    
    call Resource.request();    
    return SUCCESS;
  }

  command error_t Send.cancel(message_t* msg) {
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
    atomic {
      runSpiOperations();
    }
  }
  
  /***************** Interrupt Events ****************/
  async event void RxInterrupt.fired() {
    atomic {
      if(state == S_BACKOFF || state == S_START_INITIAL_BACKOFF) { 
        if(energyDetectEnabled) {
          call BackoffTimer.stop();
          disableEnergyDetect();
          call Resource.release();
          post delayedRequestResource();
        }
      }
    }
  }
  
  async event void EnergyInterrupt.fired() {
    atomic energyInterruptFired = TRUE;
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
    myBackoff = backoffTime + 1;
  }
  
  /**
   * Must be called within a requestCongestionBackoff event
   * @param backoffTime the amount of time in some unspecified units to backoff
   */
  async command void CongestionBackoff.setBackoff[am_id_t amId](uint16_t backoffTime) {
    myBackoff = backoffTime + 1;
  }
  
  /***************** CSMA Commands ****************/
  /**
   * Must be called within a requestCca event
   * @param cca TRUE to use cca for the outbound packet, FALSE to not use CCA
   */
  async command void Csma.setCca[am_id_t amId](bool cca) {
    atomic useCca = cca;
  }
  

  /***************** BackoffTimer Events ****************/
  async event void BackoffTimer.fired() {
    atomic {

#if BLAZE_CSMA_LEDS
      call Leds.led0Off();
      call Leds.led1Off();
#endif

      if(call Resource.isOwner()) {
        runSpiOperations();
        
      } else {
        call Resource.request();
      }
    }
  }
  
  /***************** TimeoutTimer Events ****************/
  event void TimeoutTimer.fired() {
    state = S_CANCEL;
  }
  
  
  /***************** ReceiveMode Events ****************/
  event void ReceiveMode.srxDone() {
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
    call Csn.set();
    call Csn.clr();
    
    if(call AsyncSend.send(RADIO_STACK_PACKET, TRUE, (call BlazePacketBody.getMetadata(RADIO_STACK_PACKET))->rxInterval) != SUCCESS) {
      
      call Csn.set();
      
      if(state == S_CANCEL || state == S_STOPPING) {
        atomic myError = ECANCEL;
        post sendDone();
        
      } else {
        call Csn.clr();
        call SIDLE.strobe();
        call ReceiveMode.blockingSrx();
        call Csn.set();
        post forceSend();
      }
    }
  }
  
  task void sendDone() {
    error_t atomicError;
    atomic atomicError = myError;
    
    call TimeoutTimer.stop();
    
    if(energyDetectEnabled) {
      disableEnergyDetect();
    }
    
    call Resource.release();
    
    if(state == S_STOPPING) {
      signal SplitControl.stopDone(SUCCESS);
    }
    
    state = S_IDLE;
    signal Send.sendDone(RADIO_STACK_PACKET, atomicError);
  }
  
  task void delayedRequestResource() {
    if(call Resource.request() != SUCCESS) {
      post delayedRequestResource();
    }
  }
  
  /***************** Functions ****************/
  void runSpiOperations() {
    uint8_t pktstatus;
    
    switch(state) {
      case S_START_INITIAL_BACKOFF:
        state = S_BACKOFF;
        enableEnergyDetect();
        initialBackoff();
        break;
        
      case S_BACKOFF:
        if(!energyDetectEnabled) {
          enableEnergyDetect();
          congestionBackoff();
          
        } else if(energyInterruptFired) {
          disableEnergyDetect();
          
          call Csn.clr();
          call PKTSTATUS.read(&pktstatus);
          if(!(pktstatus & 0x20) && !(pktstatus & 0x08)) {
            // Make sure our carrier-sense line is really valid by kicking in 
            // and out of RX mode, as long as we aren't receiving a packet.
            // We have to do this because of a hardware carrier-sense problem
            // related to manually duty cycling the radio in the presence of
            // nearby transmitters.
            call SIDLE.strobe();
            call ReceiveMode.blockingSrx();
          }
          
          call Csn.set();
          
          call Resource.release();
          call Resource.request();
          
        } else {
          // Energy detects were enabled and the energy interrupt didn't fire.
          // Attempt to send the message
          disableEnergyDetect();
          
#if BLAZE_CSMA_LEDS          
          call Leds.led2On();
#endif

          if(call AsyncSend.send(RADIO_STACK_PACKET, FALSE, (call BlazePacketBody.getMetadata(RADIO_STACK_PACKET))->rxInterval) != SUCCESS) {

#if BLAZE_CSMA_LEDS
            call Leds.led2Off();
#endif
            
            call SIDLE.strobe();
            call ReceiveMode.blockingSrx();
            
            call Csn.set();
            
            call Resource.release();
            call Resource.request();
          }
        }
        break;
        
      case S_FORCING:
        if(energyDetectEnabled) {
          disableEnergyDetect();
        }
        
        post forceSend();
        break;
        
      case S_CANCEL:
        /** Fall Through */
     
      case S_STOPPING:
        if(energyDetectEnabled) {
          disableEnergyDetect();
        }
        
        myError = ECANCEL;
        post sendDone();
        break;
        
      default:
        break; 
    }
    
  }
  
    
  /**
   * You must own the SPI bus resource before beginning energy detects.
   */
  void enableEnergyDetect() {  
    energyInterruptFired = FALSE;
    energyDetectEnabled = TRUE;
    
    call Csn.clr();
    // The EnergyIo right now represents CHIP_RDY.
    
#if BLAZE_ENABLE_WHILE_LOOP_LEDS
      call Leds.set(7);
#endif

    while(call EnergyIo.get());
    
#if BLAZE_ENABLE_WHILE_LOOP_LEDS
      call Leds.set(0);
#endif

#if BLAZE_ENABLE_TIMING_LEDS
    call Leds.led3On();
#endif
    
    call EnergyInterrupt.enableRisingEdge();
    
    // Carrier sense
    call IOCFG2.write(0x0E);  // Carrier-Sense
    
    if(call EnergyIo.get()) {
      atomic energyInterruptFired = TRUE;
    }
    
    call Csn.set();
  }
  
  /**
   * You must own the SPI bus resource before ending energy detects
   */
  void disableEnergyDetect() {

#if BLAZE_ENABLE_TIMING_LEDS
    call Leds.led3Off();
#endif
    
    energyInterruptFired = FALSE;
    energyDetectEnabled = FALSE;
    call Csn.clr();
    call EnergyInterrupt.disable();
    call IOCFG2.write(0x29);
    call Csn.set();
  }
  
  
  /**
   * Decide whether or not to use CCA for this transmission.
   * When complete, the useCca variable will read TRUE to use CCA and FALSE
   * to not use software CCA. 
   */
  void requestCca() {
    atomic useCca = TRUE;
    signal Csma.requestCca[(call BlazePacketBody.getHeader(RADIO_STACK_PACKET))->type](RADIO_STACK_PACKET);
  }
  
  /**
   * Obtain an inital backoff amount.
   * When complete, the variable myBackoff will be filled with the
   * correct amount of initial backoff time to use
   */
  void requestInitialBackoff() {
     myBackoff = call Random.rand16() % (0x1F * BLAZE_BACKOFF_PERIOD) + 
            BLAZE_MIN_INITIAL_BACKOFF;
    
    signal InitialBackoff.requestBackoff[(call BlazePacketBody.getHeader(RADIO_STACK_PACKET))->type](RADIO_STACK_PACKET);
  }
  
  /**
   * Obtain a congestion backoff amount
   * When complete, the variable myBackoff will be filled with the
   * correct amount of congestion backoff time to use.
   */
  void requestCongestionBackoff() {
    uint16_t fairnessBackoff;
    /*
     * As more congestion backoffs occur, we are waiting longer. This node
     * should have a higher priority on the channel than nodes that
     * haven't been waiting as long
     */
    if(BLAZE_MIN_INITIAL_BACKOFF > (totalCongestionBackoffs * BLAZE_BACKOFF_PERIOD)) {
      fairnessBackoff = BLAZE_MIN_INITIAL_BACKOFF - (totalCongestionBackoffs * BLAZE_BACKOFF_PERIOD);
      
    } else {
      fairnessBackoff = 0;
    }
    
    myBackoff = call Random.rand16() % (0x7 * BLAZE_BACKOFF_PERIOD)
            + BLAZE_MIN_BACKOFF + fairnessBackoff;
    
    signal CongestionBackoff.requestBackoff[(call BlazePacketBody.getHeader(RADIO_STACK_PACKET))->type](RADIO_STACK_PACKET);
  }
  
  
  /**
   * Backoff for the initial backoff period of time
   */
  void initialBackoff() {
    energyInterruptFired = FALSE;
    totalCongestionBackoffs = 0;
    requestInitialBackoff();
    
#if BLAZE_CSMA_LEDS
    call Leds.led0On();
#endif

    call BackoffTimer.start( myBackoff );
  }
  
  /**
   * Backoff because of a congested channel
   */
  void congestionBackoff() {
    energyInterruptFired = FALSE;
    totalCongestionBackoffs++;
    
    if(totalCongestionBackoffs > 1024) {
      totalCongestionBackoffs = 1024;
    }
    
    requestCongestionBackoff();
    
#if BLAZE_CSMA_LEDS
    call Leds.led1On();
#endif

    call BackoffTimer.start( myBackoff );
  }
  
  
  /***************** Defaults ****************/
  default async event void InitialBackoff.requestBackoff[am_id_t amId](message_t *msg) { }
  default async event void CongestionBackoff.requestBackoff[am_id_t amId](message_t *msg) { }
  default async event void Csma.requestCca[am_id_t amId](message_t *msg) { }
    
}


