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
 * Due to hardware design and battery considerations, we can only have one radio
 * on at a time.  BlazeInit will protect this rule by storing and checking
 * the enabled radio's ID.
 *
 * Also, some platforms might support the Power pin, which controls a FET
 * switch that turns off the radio.  For platforms that don't have a Power pin,
 * the radio should go into a deep sleep mode.  On platforms that do have a 
 * power pin, the radio will enter deep sleep then turn off completely.
 * 
 * @author Jared Hill 
 * @author David Moss
 */
 
#include "Blaze.h"
#include "BlazeInit.h"

module BlazeInitP {

  provides {
    interface SplitControl;
    interface BlazeCommit;
    interface PowerNotifier;
    
    interface ReceiveMode[uint8_t clientId];
  }
  
  uses {
    interface StdControl as RadioBootstrapStdControl;
    
    interface Resource as InitResource;
    interface Resource as DeepSleepResource;

    interface GeneralIO as Csn;
    interface GeneralIO as Gdo0_io;
    interface GeneralIO as Gdo2_io;
    interface GpioInterrupt as Gdo0_int;
    interface GpioInterrupt as Gdo2_int;
    
    interface BlazeRegSettings;
    interface RadioStatus;
    
    interface RadioInit as RadioInit;
    interface BlazeStrobe as SIDLE;
    interface BlazeStrobe as SXOFF;
    interface BlazeStrobe as SPWD;
    interface BlazeStrobe as SFRX;
    interface BlazeStrobe as SFTX;
    interface BlazeStrobe as SRX;
    interface BlazeStrobe as SNOP;
    interface BlazeStrobe as SRES;
    
    interface BlazeRegister as PaReg;
    
    interface Leds;
  }
}

implementation {
  
  uint8_t currentOperation;
  
  uint8_t srxClient;
  
  enum {
    S_STARTING,
    S_COMMITTING,
    S_RX,
  };
  
  /***************** Prototypes ****************/
  void deepSleep();
      
  /************** SplitControl Commands**************/
  /**
   * Power on and initialize the radio.
   * It is up to higher layers to make sure this operation will be safe
   * and will not conflict with another radio in the system
   */
  command error_t SplitControl.start() {
    atomic currentOperation = S_STARTING;
    
    call RadioBootstrapStdControl.start();
    
    call InitResource.request();
    
    return SUCCESS;
  }
  
  /**
   * Power down and shut off the radio
   * It is up to higher layers to make sure this operation will be safe
   * and will not conflict with another radio in the system
   */
  command error_t SplitControl.stop() {
    call Gdo0_int.disable();
    call Gdo2_int.disable();
    
    if(call DeepSleepResource.immediateRequest() != SUCCESS) {
      call DeepSleepResource.request();
    } else {
      deepSleep();
    }
    
    call RadioBootstrapStdControl.stop();
    
    return SUCCESS;
  }
  
  /***************** BlazeCommit Commands ****************/
  /** 
   * Commit register changes in RAM to hardware.
   * Note that this is not parameterized by radio to save footprint.  
   * The only radio we can commit changes to is the one that's currently 
   * turned on
   *
   * It is up to higher layers to make sure we aren't trying to commit
   * registers to a different radio than the one currently turned on
   */  
  command error_t BlazeCommit.commit() {
    currentOperation = S_COMMITTING;    
    call InitResource.request();
    return SUCCESS;
  }
  
  
  /***************** ReceiveMode Commands ****************/
  command void ReceiveMode.srx[uint8_t clientId]() {
    srxClient = clientId;
    currentOperation = S_RX;
    
    call SIDLE.strobe();
    call SRES.strobe();
    
#if BLAZE_ENABLE_WHILE_LOOP_LEDS
      call Leds.set(4);
#endif

    while(call Gdo2_io.get());

#if BLAZE_ENABLE_WHILE_LOOP_LEDS
      call Leds.set(0);
#endif

    call SIDLE.strobe();
    
    call RadioInit.init(BLAZE_IOCFG2, 
        call BlazeRegSettings.getDefaultRegisters(), 
            BLAZE_TOTAL_INIT_REGISTERS);
  }
  
  command void ReceiveMode.blockingSrx[uint8_t clientId]() {
    uint8_t status;
    uint8_t fail = 0;
    call SRX.strobe();

#if BLAZE_ENABLE_WHILE_LOOP_LEDS
      call Leds.set(5);
#endif

    while((status = call RadioStatus.getRadioStatus()) != BLAZE_S_RX) {
      fail++;
      if(fail == 0) {
        break;
      }
      
      call Csn.set();
      call Csn.clr();
      
      if ((status == BLAZE_S_RXFIFO_OVERFLOW) || (status == BLAZE_S_TXFIFO_UNDERFLOW)) {
        call SFRX.strobe();
        call SRX.strobe();
        
      } else if ((status == BLAZE_S_CALIBRATE) || (status == BLAZE_S_SETTLING)) {
        // do nothing but don't quit the loop
        
      } else {
        call SRX.strobe();
      }
    }
    
#if BLAZE_ENABLE_WHILE_LOOP_LEDS
      call Leds.set(0);
#endif

  }
  
  
  /***************** RadioInit Events ****************/
  event void RadioInit.initDone() { 

    call Csn.set();
    call Csn.clr();
    call PaReg.write(call BlazeRegSettings.getPa());
    call Gdo0_int.enableRisingEdge(); 
    call ReceiveMode.blockingSrx[0]();
    call Csn.set();
    
    signal PowerNotifier.on();
    
    call InitResource.release();
    
    if(currentOperation == S_STARTING) {
      signal SplitControl.startDone(SUCCESS);
    
    } else if(currentOperation == S_RX) {
      signal ReceiveMode.srxDone[srxClient]();
      
    } else {
      signal BlazeCommit.commitDone();
    }
  }
  
  /***************** Resource Events ****************/
  event void InitResource.granted() {
    call Gdo0_io.makeInput();
    call Gdo2_io.makeInput();
    
    call Csn.set();
    call Csn.clr();

#if BLAZE_ENABLE_WHILE_LOOP_LEDS
      call Leds.set(6);
#endif

    while(call Gdo2_io.get());
    
#if BLAZE_ENABLE_WHILE_LOOP_LEDS
      call Leds.set(0);
#endif

    call SIDLE.strobe();
    
    call RadioInit.init(BLAZE_IOCFG2, 
        call BlazeRegSettings.getDefaultRegisters(), 
            BLAZE_TOTAL_INIT_REGISTERS);
    // Hang onto the InitResource until RadioInit has completed
  }
  
  event void DeepSleepResource.granted() {
    deepSleep();
  }
  
  /***************** Interrupts ****************/
  async event void Gdo0_int.fired() {
  }
  
  async event void Gdo2_int.fired() {
  }
  
  /***************** Functions ****************/
  void deepSleep() {
    call Csn.clr();
    call SIDLE.strobe();
    call SPWD.strobe();
    call Csn.set();
    call DeepSleepResource.release();
        
    signal PowerNotifier.off();
    
    signal SplitControl.stopDone(SUCCESS);
  }
  
  /***************** Tasks ****************/
  
  /***************** Defaults ******************/  
  default command blaze_init_t *BlazeRegSettings.getDefaultRegisters() { return NULL; }
  default command uint8_t BlazeRegSettings.getPa() { return 0xC0; }
  default event void BlazeCommit.commitDone() {}
  
  default event void ReceiveMode.srxDone[uint8_t clientId]() {}
  
  default event void PowerNotifier.on() {}
  default event void PowerNotifier.off() {}
  
  default command error_t RadioBootstrapStdControl.start() { return SUCCESS; }
  default command error_t RadioBootstrapStdControl.stop() { return SUCCESS; } 
  
}
