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
 * This module performs energy-based receive checks, and manages when the
 * radio is on and off to keep it duty cycling while performing system 
 * functions.
 *
 * @author David Moss
 */
 
#include "PowerCycle.h"
#include "Blaze.h"

module PowerCycleP {
  provides {
    interface Init;
    interface PowerCycle;
    interface SplitControl;
    interface Receive;
    interface Send;
    interface SystemLowPowerListening;
  }

  uses {
    interface Send as SubSend;
    interface Receive as SubReceive;
    interface SplitControl as SubControl;
    interface LowPowerListening;
    interface PacketAcknowledgements;
    interface AMPacket;
    
    interface Timer<TMilli> as OnTimer;
    interface Timer<TMilli> as OffTimer;
    
    interface State as SendState;
    
    interface GpioInterrupt as RxInterrupt;
    interface GeneralIO as Csn;
    interface Resource;
    interface BlazeRegister as PKTSTATUS;
    
    interface Leds;
  }
}

implementation {
  
  
  /**
   * Radio Power, Check State, and Duty Cycling State
   */
  enum {
    S_OFF, // off by default
    S_TURNING_ON,
    S_ON,
    S_TURNING_OFF,
  };
  
  enum {
    NO_RADIO = 0xFF,
  };
  
  
  /** The current period of the duty cycle, equivalent of wakeup interval */
  uint16_t sleepInterval;
  
  /** TRUE if we just received a message (?) */
  bool received;
    
  /** TRUE if this module is sending a message */
  bool sending;
  
  /** Tracks some number of times we've seen a transmitter, or not */
  uint8_t transmitterQuality;
  
  /** TRUE if we are to perform preamble quality detects on out */
  bool testPreambleQuality;
  
  /** State of the radio power */
  uint8_t radioPowerState;
  
  /** State of the split control interface */
  uint8_t splitControlState;
  
  /** Programmable time the radio is on after a valid packet reception */
  uint16_t delayAfterActivity;
  
  /** Storage for the system-wide wakeup interval */
  uint16_t systemWakeupInterval;
  
  /***************** Prototypes ****************/
  task void carrierSense();
  
  void startOffTimer();
  
  bool finishSplitControlRequests();
  bool isDutyCycling();

  void receiveCheck();

  void beginStart();
  void beginStop();  
  void startDone();
  void stopDone();
  
  bool transmitterFound();
  void attemptToTurnOff();
  
  /***************** Init Commands *****************/ 
  command error_t Init.init() {
    sleepInterval = 0;
    
    splitControlState = S_OFF;
    received = FALSE;
    sending = FALSE;
    delayAfterActivity = DELAY_AFTER_ACTIVITY;
    
    return SUCCESS;
  }
  
  /***************** PowerCycle Commands ****************/
  /**
   * Set the sleep interval, in binary milliseconds
   * @param sleepIntervalMs the sleep interval in [ms]
   */
  command void PowerCycle.setSleepInterval(uint16_t sleepIntervalMs) {
    uint16_t originalSleepInterval = sleepInterval;
    sleepInterval = sleepIntervalMs;
    
    if(splitControlState == S_ON) {
      if(!originalSleepInterval && sleepIntervalMs) {
        // We were always on, now lets duty cycle
        beginStop();
        return;
      }
      
      if(!sleepInterval && (radioPowerState == S_OFF)) {
        /*
         * Leave the radio on permanently if sleepInterval == 0 and the radio is 
         * supposed to be enabled
         */
        beginStart();
      }
    }
  }
  
  /**
   * @return the sleep interval in [ms]
   */
  command uint16_t PowerCycle.getSleepInterval() {
    return sleepInterval;
  }
  
  /***************** SystemLowPowerListening Commands ***************/
  command void SystemLowPowerListening.setDefaultRemoteWakeupInterval(uint16_t intervalMs) {
    systemWakeupInterval = intervalMs;
  }
  
  command void SystemLowPowerListening.setDelayAfterReceive(uint16_t intervalMs) {
    delayAfterActivity = intervalMs;
  }

  command uint16_t SystemLowPowerListening.getDefaultRemoteWakeupInterval() {
    return systemWakeupInterval;
  }
  
  command uint16_t SystemLowPowerListening.getDelayAfterReceive() {
    return delayAfterActivity;
  }
  
  /***************** SplitControl Commands ****************/
  command error_t SplitControl.start() {
    if(splitControlState != S_OFF) {
      return FAIL;
    }
    
    // Radio was off, now has been told to turn on or duty cycle.
    splitControlState = S_TURNING_ON;
    
    beginStart();
    
    return SUCCESS;
  }
  
  command error_t SplitControl.stop() {
    if(splitControlState != S_ON) {
      return FAIL;
    }
    
    splitControlState = S_TURNING_OFF;
    
    beginStop();
    return SUCCESS;
  }
  
  /***************** Send Commands ****************/
  /**
   * Each call to this send command gives the message a single
   * DSN that does not change for every copy of the message
   * sent out.  For messages that are not acknowledged, such as
   * a broadcast address message, the receiving end does not
   * signal receive() more than once for that message.
   */
  command error_t Send.send(message_t *msg, uint8_t len) {
    if(sending) {
      return FAIL;
    }
    
#if BLAZE_ENABLE_LPL_LEDS
    call Leds.led2On();
#endif
 
    sending = TRUE;
    
    beginStart();
    
    return SUCCESS;
  }
  
  command error_t Send.cancel(message_t *msg) {
    return FAIL;
  }
  
  command uint8_t Send.maxPayloadLength() {
    return call SubSend.maxPayloadLength();
  }

  command void *Send.getPayload(message_t* msg, uint8_t len) {
    return call SubSend.getPayload(msg, len);
  }
  
  /***************** SubSend Events ****************/
  event void SubSend.sendDone(message_t *msg, error_t error) {
#if BLAZE_ENABLE_LPL_LEDS
    call Leds.led2Off();
#endif
    startOffTimer();
    sending = FALSE;
    signal Send.sendDone(msg, error);
  } 
  
  /***************** SubReceive Events ****************/
  event message_t *SubReceive.receive(message_t *msg, void *payload, uint8_t len) {
#if BLAZE_ENABLE_LPL_LEDS
    call Leds.led0Toggle();
#endif

    if(isDutyCycling()) {
      if(radioPowerState != S_ON) {
        beginStart();
      }
    
      startOffTimer();
    }
    
    return signal Receive.receive(msg, payload, len);
  }
  
  /***************** Timer Events ****************/
  event void OnTimer.fired() {
    if(isDutyCycling()) {
      if(radioPowerState == S_OFF && !sending) {
        beginStart();
        received = FALSE;
        
      } else {
        // Someone else turned on the radio, try again in awhile
        call OnTimer.startOneShot(sleepInterval);
      }
    }
  }
  
  /**
   * We are done with the short delay following any activity. Perform
   * another receive check, and if the channel is free, go back to sleep.
   */
  event void OffTimer.fired() {
    receiveCheck();
  }
  
  /***************** SubControl Events ****************/
  event void SubControl.startDone(error_t error) {
    startDone();
  }
  
  event void SubControl.stopDone(error_t error) {
    stopDone();
  }
  
  /***************** RxInterrupt Events ****************/
  async event void RxInterrupt.fired() {
    atomic received = TRUE;
  }
  
  /***************** Resource Events *****************/
  event void Resource.granted() {
    post carrierSense();
  }
  
  
  /***************** Tasks ****************/
  task void carrierSense() {
    if(sending || received) {
      // Keep the radio on for a bit.  The system is doing something.
      // A send will trigger a sendDone which will continue with startOffTimer()
      call Resource.release();
      
      if(received) {
        // Leave it on for awhile and then turn off.
        startOffTimer();
      }
      
    } else if(!transmitterFound()) {
      if(transmitterQuality == 0) {
        call Resource.release();
        attemptToTurnOff();
        
      } else {
        transmitterQuality--;
        post carrierSense();
      }
    
    } else {
      transmitterQuality++;
      call Resource.release();
      if(transmitterQuality > TRANSMITTER_QUALITY_THRESHOLD) {
        transmitterQuality = TRANSMITTER_QUALITY_THRESHOLD;
        testPreambleQuality = TRUE;
      }
      
      // Keep doing checks until the anomaly goes away.
      call Resource.request();
    }
    
  }
    
  /***************** Functions ****************/
  /**
   * Start the off timer, leaving the radio on for a short period of time
   * before doing another receive check and possibly going back to sleep.
   */
  void startOffTimer() {
    if(isDutyCycling()) {
      received = FALSE;
      if(!delayAfterActivity) {
        receiveCheck();
      } else {
        call OffTimer.startOneShot(delayAfterActivity);
      }
    }
  }
  
  /**
   * @return TRUE if the radio should be actively duty cycling
   */
  bool isDutyCycling() {
    return (sleepInterval > 0) && (splitControlState == S_ON);
  }
  
  
  /**
   * @return TRUE if we successfully handled a SplitControl request
   */
  bool finishSplitControlRequests() {
    if(splitControlState == S_TURNING_OFF) {
      if(radioPowerState != S_OFF) {
        beginStop();
        return TRUE;
      }
      
      splitControlState = S_OFF;
      signal SplitControl.stopDone(SUCCESS);
      return TRUE;
      
    } else if(splitControlState == S_TURNING_ON) {
      if(radioPowerState != S_ON) {
        beginStart();
        return TRUE;
      }
      
      // Starting while we're duty cycling first turns off the radio
      splitControlState = S_ON;
      signal SplitControl.startDone(SUCCESS);
      return TRUE;
    }
    
    return FALSE;
  }
  
  /**
   * Entry point for starting the radio
   */
  void beginStart() {
    error_t error;
   
    call OffTimer.stop();
    
    error = call SubControl.start();
    
    if(error == EALREADY) {
      startDone();
    }
  }
  
  /** 
   * Entry point for stopping the radio
   */
  void beginStop() {
    if(sending) {
      // Don't turn the radio off
      return;
    }
    
    call OnTimer.stop();
    
    if(call SubControl.stop() == EALREADY) {
      stopDone(); 
    }
  }
  
  /**
   * The radio started
   */
  void startDone() {
    error_t error;
    
    radioPowerState = S_ON;
    
#if BLAZE_ENABLE_LPL_LEDS
    call Leds.led3On();
#endif
    
    if(isDutyCycling() && !sending) {
      receiveCheck();
    }
    
    if(sending) {
      error = call SubSend.send(RADIO_STACK_PACKET, 0);
      if(error != SUCCESS) {
        startOffTimer();
        sending = FALSE;
        signal Send.sendDone(RADIO_STACK_PACKET, error);
      }
    }
    
    // Trying to increase receive check speed by skipping this function.
    if(splitControlState != S_ON) {
      finishSplitControlRequests();
    }
  }
  
  /**
   * The radio stopped
   */
  void stopDone() {
    radioPowerState = S_OFF;
    
#if BLAZE_ENABLE_LPL_LEDS
    call Leds.led3Off();
    call Leds.set(0);
#endif
    
    if(finishSplitControlRequests()) {
      // Don't duty cycle anymore.
      return;
      
    } else if(sending) {
      // Not sure if or why we turn off intermittently when we're sending, but 
      // make sure CSMA exits properly and turn that radio back on.
      call SubSend.cancel(RADIO_STACK_PACKET);
      beginStart();
      
    } else if(isDutyCycling()) {
      call OnTimer.startOneShot(sleepInterval);
    }
  }
  
  
  /**
   * Attempt to perform a receive check.
   */
  void receiveCheck() {
    received = FALSE;
    transmitterQuality = 0;
    testPreambleQuality = FALSE;
   
    if(call Resource.immediateRequest() != SUCCESS) {
      call Resource.request();
    } else {
      post carrierSense();
    }
  }

  /**
   * Call this only when we own the SPI bus
   * @return TRUE if there there is a transmitter on the channel
   */
  bool transmitterFound() {
    uint8_t pktstatus;
    uint8_t fail = 0;
    
    call Csn.clr();
    
#if BLAZE_ENABLE_WHILE_LOOP_LEDS
      call Leds.set(8);
#endif

    // Wait for RSSI to be valid.  We have seen the radio get stuck here
    // saying CS and CCA are both invalid => RSSI is invalid.
    do {
      fail++;
      call PKTSTATUS.read(&pktstatus);
    } while(!(pktstatus & 0x50) && fail != 0);
    
    if(fail == 0) {
      return FALSE;
    }
    
#if BLAZE_ENABLE_WHILE_LOOP_LEDS
      call Leds.set(0);
#endif
    
    call Csn.set();
    
    // CS = 0x40
    // PQT_REACHED = 0x20
    // CCA = 0x10
    
    if(testPreambleQuality) {
      // Byte Detect
      return (pktstatus & 0x20);
      
    } else {
      // Energy Detect
      return (pktstatus & 0x40);
    }
  }
  
  
  /**
   * Attempt to turn the radio off, but make sure it's safe to do so first.
   * If we can't turn the radio off, then we're busy doing something, and
   * we should back off and try again later.
   */
  void attemptToTurnOff() {
    if(call OffTimer.isRunning()) {
      return;
    }
    
    if(splitControlState == S_ON && isDutyCycling()) {
      
      if(!sending && !received) {
        beginStop();
        return;
      }
      
      startOffTimer();
    }
  }
  
  /**************** Defaults ****************/  
  
}


