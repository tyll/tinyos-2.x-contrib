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
    interface Send[radio_id_t radioId];
    interface Csma[am_id_t amId];
    interface Backoff as InitialBackoff[am_id_t amId];
    interface Backoff as CongestionBackoff[am_id_t amId];
    interface SplitControl[radio_id_t radioId];
  }
  
  uses {
    interface Resource;
    interface AsyncSend[radio_id_t id];
    interface Alarm<T32khz,uint32_t> as BackoffTimer;
    
    interface GpioInterrupt as EnergyInterrupt[radio_id_t radioId];
    interface GpioInterrupt as RxInterrupt[radio_id_t radioId];
    interface GeneralIO as EnergyIo[radio_id_t radioId];
    interface GeneralIO as Csn[radio_id_t radioId];
    
    interface BlazeRegister as MCSM1;
    interface BlazeRegister as IOCFG2;
    
    interface BlazeRegister as PKTSTATUS;
    interface BlazeStrobe as SIDLE;
    
    interface BlazePacket;
    interface BlazePacketBody;
    interface BlazeRegister as PaReg;
    interface BlazeRegSettings[radio_id_t radioId];
    
    interface ReceiveMode;
    
    interface Random;
    interface State;
    interface Leds;
  }
}

implementation {

  /** The radio we're servicing */
  radio_id_t myRadio;
  
  /** The message we're sending */
  message_t *myMsg;
  
  
  /** The amount of time to currently backoff initially */
  uint16_t myInitialBackoff;
  
  /** The amount of time to currently backoff during congestion */
  uint16_t myCongestionBackoff;
  
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
  command error_t SplitControl.start[radio_id_t radioId]() {
    signal SplitControl.startDone[radioId](SUCCESS);
    return SUCCESS;
  }
 
  /**
   * If we're busy, stop being busy so we can shut off this radio.
   * Assume that if we're sending, we're trying to shut off the radio that
   * we're sending to. Also assume that there's a SplitControlManager
   * on top that will prevent the application layer from trying to send
   * another packet after we've shut down.
   */
  command error_t SplitControl.stop[radio_id_t radioId]() {
    if(!call State.isIdle()) {
      call State.forceState(S_STOPPING);

    } else {
      signal SplitControl.stopDone[radioId](SUCCESS);
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
  command error_t Send.send[radio_id_t id](message_t* msg, uint8_t len) {
    if(call State.requestState(S_SENDING) != SUCCESS) {
      return FAIL;
    }
    
    atomic {
      myMsg = msg;
      myRadio = id;
    }
    
    requestCca();
    
    if(!useCca) {
      call State.forceState(S_FORCING);
      call Resource.request();
      
    } else {
      call State.forceState(S_START_INITIAL_BACKOFF);
      call Resource.request();
    }
    
    return SUCCESS;
  }

  command error_t Send.cancel[radio_id_t id](message_t* msg) {
    message_t *atomicMsg;
    atomic atomicMsg = myMsg;
    
    if(!call State.isIdle() && (msg == atomicMsg)) {
      call State.forceState(S_CANCEL);
      return SUCCESS;
    }
   
    return FAIL;
  }

  command uint8_t Send.maxPayloadLength[radio_id_t id]() { 
    return TOSH_DATA_LENGTH;
  }

  command void *Send.getPayload[radio_id_t id](message_t* msg, uint8_t len) {
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
  async event void RxInterrupt.fired[radio_id_t radioId]() {
    atomic {
      if(call State.isState(S_BACKOFF) || call State.isState(S_START_INITIAL_BACKOFF)) { 
        if(energyDetectEnabled) {
          call BackoffTimer.stop();
          disableEnergyDetect();
          call Resource.release();
          post delayedRequestResource();
        }
      }
    }
  }
  
  async event void EnergyInterrupt.fired[radio_id_t radioId]() {
    atomic {
      energyInterruptFired = TRUE;
    }
  }
  
  
  /***************** AsyncSend Events ****************/
  async event void AsyncSend.sendDone[radio_id_t id](error_t error) {
    atomic myError = error;
    post sendDone();
  }
  
  /***************** Backoff Commands ****************/
  /**
   * Must be called within a requestInitialBackoff event
   * @param backoffTime the amount of time in some unspecified units to backoff
   */
  async command void InitialBackoff.setBackoff[am_id_t amId](uint16_t backoffTime) {
    atomic myInitialBackoff = backoffTime + 1;
  }
  
  /**
   * Must be called within a requestCongestionBackoff event
   * @param backoffTime the amount of time in some unspecified units to backoff
   */
  async command void CongestionBackoff.setBackoff[am_id_t amId](uint16_t backoffTime) {
    atomic myCongestionBackoff = backoffTime + 1;
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
      if(call Resource.isOwner()) {
        runSpiOperations();
        
      } else {
        call Resource.request();
      }
    }
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
    if(call AsyncSend.send[myRadio](myMsg, TRUE, (call BlazePacketBody.getMetadata(myMsg))->rxInterval) != SUCCESS) {
      if(call State.isState(S_CANCEL) || call State.isState(S_STOPPING)) {
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
    
    call Csn.clr[myRadio]();
    if(call BlazePacket.getPower(myMsg) > 0) {
      // Set the radio back to default PA settings
      call PaReg.write(call BlazeRegSettings.getPa[myRadio]());
    }
    call Csn.set[myRadio]();
    
    if(energyDetectEnabled) {
      disableEnergyDetect();
    }
    
    call Resource.release();
    
    if(call State.isState(S_STOPPING)) {
      signal SplitControl.stopDone[myRadio](SUCCESS);
    }
    
    call State.toIdle();
    signal Send.sendDone[myRadio](myMsg, atomicError);
  }
  
  task void delayedRequestResource() {
    if(call Resource.request() != SUCCESS) {
      post delayedRequestResource();
    }
  }
  
  /***************** Functions ****************/
  void runSpiOperations() {
    uint8_t pktstatus;
    
    switch(call State.getState()) {
      case S_START_INITIAL_BACKOFF:
        call State.forceState(S_BACKOFF);
        enableEnergyDetect();
        initialBackoff();
        break;
        
      case S_BACKOFF:
        if(!energyDetectEnabled) {
          enableEnergyDetect();
          congestionBackoff();
          
        } else if(energyInterruptFired) {
          disableEnergyDetect();
          
          call Csn.clr[myRadio]();
          call PKTSTATUS.read(&pktstatus);
          if(!(pktstatus & 0x20) && !(pktstatus & 0x08)) {
            // Make sure our carrier-sense line is really valid by kicking in 
            // and out of RX mode, as long as we aren't receiving a packet.
            // We have to do this because of a hardware carrier-sense problem
            // related to manually duty cycling the radio in the presence of
            // nearby transmitters.
            call SIDLE.strobe();
            call ReceiveMode.blockingSrx(myRadio);
          }
          
          call Csn.set[myRadio]();
          
          call Resource.release();
          call Resource.request();
          
        } else {
          // Energy detects were enabled and the energy interrupt didn't fire.
          // Attempt to send the message
          disableEnergyDetect();
          
          call Csn.set[myRadio]();
          call Csn.clr[myRadio]();
          
          if(call BlazePacket.getPower(myMsg) > 0) {
            // This packet has custom PA settings
            call PaReg.write(call BlazePacket.getPower(myMsg));
          }
          
          call Csn.set[myRadio]();
          
          if(call AsyncSend.send[myRadio](myMsg, FALSE, (call BlazePacketBody.getMetadata(myMsg))->rxInterval) != SUCCESS) {
            call Csn.clr[myRadio]();
            if(call BlazePacket.getPower(myMsg) > 0) {
              // Set the PA back to default for whatever ack's are taking place
              call PaReg.write(call BlazeRegSettings.getPa[myRadio]());
            }
            call Csn.set[myRadio]();
            
            call Resource.release();
            call Resource.request();
          }
        }
        break;
        
      case S_FORCING:
        if(energyDetectEnabled) {
          disableEnergyDetect();
        }
      
        call Csn.clr[myRadio]();
        if(call BlazePacket.getPower(myMsg) > 0) {
          // This packet has custom PA settings
          call PaReg.write(call BlazePacket.getPower(myMsg));
        }
        call Csn.set[myRadio]();
        
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
   * DEBUG
  task void rxBlinky() {
    int8_t rssi;
    bool set;
    if(energyDetectEnabled) {
      if(call EnergyIo.get[0]()) {
        call Leds.led0On();
      } else {
        call Leds.led0Off();
      }
    } else {
      call Leds.led0Off();
    }
    
    post rxBlinky();
  }
  */
  
    
  /**
   * You must own the SPI bus resource before beginning energy detects.
   */
  void enableEnergyDetect() {  
    energyInterruptFired = FALSE;
    energyDetectEnabled = TRUE;
    
    call Csn.clr[myRadio]();
    // The EnergyIo right now represents CHIP_RDY.
    
#if BLAZE_ENABLE_WHILE_LOOP_LEDS
      call Leds.set(7);
#endif

    while(call EnergyIo.get[myRadio]());
    
    
#if BLAZE_ENABLE_WHILE_LOOP_LEDS
      call Leds.set(0);
#endif

#if BLAZE_ENABLE_TIMING_LEDS
    call Leds.led3On();
#endif
    
    call EnergyInterrupt.enableRisingEdge[myRadio]();
    
    // Carrier sense
    call IOCFG2.write(0x0E);  // Carrier-Sense
    call Csn.set[myRadio]();
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
    call Csn.clr[myRadio]();
    call EnergyInterrupt.disable[myRadio]();
    call IOCFG2.write(0x29);
    call Csn.set[myRadio]();
  }
  
  
  /**
   * Decide whether or not to use CCA for this transmission.
   * When complete, the useCca variable will read TRUE to use CCA and FALSE
   * to not use software CCA. 
   */
  void requestCca() {
    atomic useCca = TRUE;
    signal Csma.requestCca[(call BlazePacketBody.getHeader(myMsg))->type](myMsg);
  }
  
  /**
   * Obtain an inital backoff amount.
   * When complete, the variable myInitialBackoff will be filled with the
   * correct amount of initial backoff time to use
   */
  void requestInitialBackoff() {
    atomic myInitialBackoff =  
        call Random.rand16() % (0x1F * BLAZE_BACKOFF_PERIOD) + 
            BLAZE_MIN_INITIAL_BACKOFF;
            
    signal InitialBackoff.requestBackoff[(call BlazePacketBody.getHeader(myMsg))->type](myMsg);
  }
  
  /**
   * Obtain a congestion backoff amount
   * When complete, the variable myCongestionBackoff will be filled with the
   * correct amount of congestion backoff time to use.
   */
  void requestCongestionBackoff() {
    uint16_t fairnessBackoff;
    /*
     * As more congestion backoffs occur, we are waiting longer. This node
     * should have a higher priority on the channel than nodes that
     * haven't been waiting as long
     */
    if(BLAZE_MIN_INITIAL_BACKOFF > (totalCongestionBackoffs * 2)) {
      fairnessBackoff = BLAZE_MIN_INITIAL_BACKOFF - (totalCongestionBackoffs * 2);
      
    } else {
      fairnessBackoff = 0;
    }
    
    atomic myCongestionBackoff = 
        call Random.rand16() % (0x7 * BLAZE_BACKOFF_PERIOD)
            + BLAZE_MIN_BACKOFF + fairnessBackoff;
    
    signal CongestionBackoff.requestBackoff[(call BlazePacketBody.getHeader(myMsg))->type](myMsg);
  }
  
  
  /**
   * Backoff for the initial backoff period of time
   */
  void initialBackoff() {
    uint16_t atomicBackoff;
    energyInterruptFired = FALSE;
    totalCongestionBackoffs = 0;
    requestInitialBackoff();
    atomic atomicBackoff = myInitialBackoff;
    call BackoffTimer.start( atomicBackoff );
  }
  
  /**
   * Backoff because of a congested channel
   */
  void congestionBackoff() {
    uint16_t atomicBackoff;
    energyInterruptFired = FALSE;
    totalCongestionBackoffs++;
    if(totalCongestionBackoffs > 1024) {
      totalCongestionBackoffs = 1024;
    }
    requestCongestionBackoff();
    atomic atomicBackoff = myCongestionBackoff;
    call BackoffTimer.start( atomicBackoff );
  }
  
  
  /***************** Defaults ****************/
  default event void Send.sendDone[radio_id_t id](message_t* msg, error_t error) { }
  
  default async command error_t AsyncSend.send[radio_id_t id](void *msg, bool force, uint16_t preamble) { }
  
  default async event void InitialBackoff.requestBackoff[am_id_t amId](message_t *msg) { }
  default async event void CongestionBackoff.requestBackoff[am_id_t amId](message_t *msg) { }
  default async event void Csma.requestCca[am_id_t amId](message_t *msg) { }
  
  default event void SplitControl.startDone[radio_id_t radioId](error_t error) { }
  default event void SplitControl.stopDone[radio_id_t radioId](error_t error) { }
  
  default command blaze_init_t *BlazeRegSettings.getDefaultRegisters[ radio_id_t id ]() { return NULL; }
  default command uint8_t BlazeRegSettings.getPa[ radio_id_t id ]() { return 0xC0; }
  
  default async command void Csn.set[ radio_id_t id ](){}
  default async command void Csn.clr[ radio_id_t id ](){}
  default async command void Csn.toggle[ radio_id_t id ](){}
  default async command bool Csn.get[ radio_id_t id ](){ return 0; }
  default async command void Csn.makeInput[ radio_id_t id ](){}
  default async command bool Csn.isInput[ radio_id_t id ](){ return 0; }
  default async command void Csn.makeOutput[ radio_id_t id ](){}
  default async command bool Csn.isOutput[ radio_id_t id ](){ return 0; }
  
  default async command void EnergyIo.set[ radio_id_t id ](){}
  default async command void EnergyIo.clr[ radio_id_t id ](){}
  default async command void EnergyIo.toggle[ radio_id_t id ](){}
  default async command bool EnergyIo.get[ radio_id_t id ](){ return 0; }
  default async command void EnergyIo.makeInput[ radio_id_t id ](){}
  default async command bool EnergyIo.isInput[ radio_id_t id ](){ return 0; }
  default async command void EnergyIo.makeOutput[ radio_id_t id ](){}
  default async command bool EnergyIo.isOutput[ radio_id_t id ](){ return 0; }
  
  
  
  default async command error_t RxInterrupt.enableRisingEdge[radio_id_t id]() {
    return FAIL;
  }
  
  default async command error_t RxInterrupt.enableFallingEdge[radio_id_t id]() {
    return FAIL;
  }
  
  default async command error_t RxInterrupt.disable[radio_id_t id]() {
    return FAIL;
  }
  
  
  
  default async command error_t EnergyInterrupt.enableRisingEdge[radio_id_t id]() {
    return FAIL;
  }
  
  default async command error_t EnergyInterrupt.enableFallingEdge[radio_id_t id]() {
    return FAIL;
  }
  
  default async command error_t EnergyInterrupt.disable[radio_id_t id]() {
    return FAIL;
  }
  
  
}


