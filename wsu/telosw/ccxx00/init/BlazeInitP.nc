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
    interface Init;
    interface SplitControl[ radio_id_t id ];
    interface BlazeCommit[ radio_id_t id ];
    interface RadioOnTime;
    
    interface ReceiveMode[uint8_t clientId];
  }
  
  uses {
    interface Resource as InitResource;
    interface Resource as DeepSleepResource;

    interface GeneralIO as Csn[ radio_id_t id ];
    interface GeneralIO as Gdo0_io[ radio_id_t id ];
    interface GeneralIO as Gdo2_io[ radio_id_t id ];
    interface GeneralIO as Power[ radio_id_t id ];
    interface GpioInterrupt as Gdo0_int[ radio_id_t id ];
    interface GpioInterrupt as Gdo2_int[ radio_id_t id ];
    
    interface BlazeRegSettings[ radio_id_t id ];
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
    
    interface BusyWait<TMicro, uint16_t>;
    interface Timer<TMilli>;
    
    interface BlazeRegister as PaReg;
    
    interface Leds;
  }
}

implementation {

  enum {
    NO_RADIO = 0xFF,
  };

  uint8_t m_id;
  
  uint8_t currentOperation;
  
  uint8_t srxClient;
  
  uint32_t totalRadioOnTime;
  
  uint32_t timeOn;
  
  enum {
    S_STARTING,
    S_COMMITTING,
    S_RX,
  };
  
  /***************** Prototypes ****************/
  void burstInit();
  void deepSleep();
  void shutDown();
  
  /************** SoftwareInit Commands *****************/
  command error_t Init.init() {
    uint8_t i;
    for(i = 0; i < uniqueCount(UQ_BLAZE_RADIO); i++) {
      atomic m_id = i;
      shutDown();
    }
    
    totalRadioOnTime = 0;
    timeOn = 0;
    
    m_id = NO_RADIO;
    return SUCCESS;
  }
    
  /************** SplitControl Commands**************/
  /**
   * Power on and initialize the radio.
   * It is up to higher layers to make sure this operation will be safe
   * and will not conflict with another radio in the system
   */
  command error_t SplitControl.start[ radio_id_t id ]() {
    atomic m_id = id;
    atomic currentOperation = S_STARTING;
    
    timeOn = call Timer.getNow();
    
    call Power.set[ m_id ]();
    
    burstInit();
    
    return SUCCESS;
  }
  
  /**
   * Power down and shut off the radio
   * It is up to higher layers to make sure this operation will be safe
   * and will not conflict with another radio in the system
   */
  command error_t SplitControl.stop[ radio_id_t id ]() {
    atomic m_id = id;
    
    call Gdo0_int.disable[ m_id ]();
    call Gdo2_int.disable[ m_id ]();
    
    deepSleep();
    
    return SUCCESS;
  }
  
  /***************** BlazeCommit Commands ****************/
  /** 
   * Commit register changes in RAM to hardware.
   * Note that this is not parameterized by radio to save footprint.  
   * The only radio we can commit changes to is the one that's currently 
   * turned on, indicated by m_id.
   *
   * It is up to higher layers to make sure we aren't trying to commit
   * registers to a different radio than the one currently turned on
   */  
  command error_t BlazeCommit.commit[radio_id_t id]() {
    atomic m_id = id;
    currentOperation = S_COMMITTING;    
    burstInit();
    return SUCCESS;
  }
  
  /***************** RadioOnTime Commands ****************/
  /**
   * @return the total amount of time, in binary-milliseconds, the radio has
   *     been turned on.
   */
  command uint32_t RadioOnTime.getTotalOnTime() {
    uint32_t total = totalRadioOnTime;
    
    if(timeOn > 0) {
      total += call Timer.getNow() - timeOn;
    }
    
    return total;
  }
 
  /**
   * @return the actual duty cycle % moved over two decimal places.
   *     In other words, 16.27% duty cycle will read 1627.
   */  
  command uint16_t RadioOnTime.getDutyCycle() {
    return (uint16_t) (((double) call RadioOnTime.getTotalOnTime() / (double) call Timer.getNow()) * 10000);
  }
  
  
  /***************** ReceiveMode Commands ****************/
  command void ReceiveMode.srx[uint8_t clientId](radio_id_t radioId) {
    srxClient = clientId;
    m_id = radioId;
    currentOperation = S_RX;
    
    call SIDLE.strobe();
    call SRES.strobe();
    
#if BLAZE_ENABLE_WHILE_LOOP_LEDS
      call Leds.set(4);
#endif

    while(call Gdo2_io.get[radioId]());

#if BLAZE_ENABLE_WHILE_LOOP_LEDS
      call Leds.set(0);
#endif

    call SIDLE.strobe();
    
    call RadioInit.init(BLAZE_IOCFG2, 
        call BlazeRegSettings.getDefaultRegisters[ radioId ](), 
            BLAZE_TOTAL_INIT_REGISTERS);
  }
  
  command void ReceiveMode.blockingSrx[uint8_t clientId](radio_id_t radioId) {
    uint8_t status;
    call SRX.strobe();

#if BLAZE_ENABLE_WHILE_LOOP_LEDS
      call Leds.set(5);
#endif

    while((status = call RadioStatus.getRadioStatus()) != BLAZE_S_RX) {
      call Csn.set[m_id]();
      call Csn.clr[m_id]();
      
      if (status == BLAZE_S_RXFIFO_OVERFLOW) {
        call SFRX.strobe();
        call SRX.strobe();
        
      } else if (status == BLAZE_S_TXFIFO_UNDERFLOW) {
        call SFTX.strobe();
        call SRX.strobe();
        
      } else if (status == BLAZE_S_CALIBRATE) {
        // do nothing but don't quit the loop
        
      } else if (status == BLAZE_S_SETTLING) {
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

    call Csn.set[ m_id ]();
    call Csn.clr[ m_id ]();
    
    call PaReg.write(call BlazeRegSettings.getPa[ m_id ]());
    
    call Gdo0_int.enableRisingEdge[ m_id ](); 
    
    call ReceiveMode.blockingSrx[0](m_id);
    
    call Csn.set[ m_id ]();
    
    call InitResource.release();
    
    if(currentOperation == S_STARTING) {
      signal SplitControl.startDone[ m_id ](SUCCESS);
    
    } else if(currentOperation == S_RX) {
      signal ReceiveMode.srxDone[srxClient]();
      
    } else {
      signal BlazeCommit.commitDone[ m_id ]();
    }
  }
  
  /***************** Resource Events ****************/
  event void InitResource.granted() {
    uint8_t id;
    atomic id = m_id;
    
    call Gdo0_io.makeInput[ m_id ]();
    call Gdo2_io.makeInput[ m_id ]();
    
    call Csn.set[id]();
    call Csn.clr[id]();

#if BLAZE_ENABLE_WHILE_LOOP_LEDS
      call Leds.set(6);
#endif

    while(call Gdo2_io.get[id]());
    
    
#if BLAZE_ENABLE_WHILE_LOOP_LEDS
      call Leds.set(0);
#endif

    call SIDLE.strobe();
    
    call RadioInit.init(BLAZE_IOCFG2, 
        call BlazeRegSettings.getDefaultRegisters[ id ](), 
            BLAZE_TOTAL_INIT_REGISTERS);
    // Hang onto the InitResource until RadioInit has completed
  }
  
  event void DeepSleepResource.granted() {
    uint8_t id;
        
    atomic id = m_id;
    call Csn.set[id]();
    call Csn.clr[id]();
    call SIDLE.strobe();
    call SPWD.strobe();
    call Csn.set[id]();
    call DeepSleepResource.release();
    
    shutDown();
    
    totalRadioOnTime += call Timer.getNow() - timeOn;
    timeOn = 0;

#if PRINTF_DUTY_CYCLE
    printf("Age=%lu; Radio-On=%lu; Duty=%05lu\n\r", call Timer.getNow(), totalRadioOnTime, (uint32_t) (((double) totalRadioOnTime / (double) call Timer.getNow()) * 10000));
#endif

    signal SplitControl.stopDone[m_id](SUCCESS);
  }
  

  /***************** Timer Events ****************/
  event void Timer.fired() {
    // This is only used to keep track of the radio on-time
  }
  
  /***************** Interrupts ****************/
  async event void Gdo0_int.fired[radio_id_t id]() {
  }
  
  async event void Gdo2_int.fired[radio_id_t id]() {
  }
  
  /***************** Functions ****************/
  /**
   * Split-phase
   */
  void burstInit() {
    call InitResource.request();
  }

  /**
   * Split-phase
   */
  void deepSleep() {
    call DeepSleepResource.request();
  }
  
  /**
   * Single-phase
   */
  void shutDown() {
    uint8_t id;
    atomic id = m_id;
    
    call Power.clr[ id ]();
  }
  
  
  /***************** Tasks ****************/
  
  /***************** Defaults ******************/
  default async command void Csn.set[ radio_id_t id ](){}
  default async command void Csn.clr[ radio_id_t id ](){}
  default async command void Csn.toggle[ radio_id_t id ](){}
  default async command bool Csn.get[ radio_id_t id ](){return FALSE;}
  default async command void Csn.makeInput[ radio_id_t id ](){}
  default async command bool Csn.isInput[ radio_id_t id ](){return FALSE;}
  default async command void Csn.makeOutput[ radio_id_t id ](){}
  default async command bool Csn.isOutput[ radio_id_t id ](){return FALSE;}
  
  default async command void Power.set[ radio_id_t id ](){}
  default async command void Power.clr[ radio_id_t id ](){}
  default async command void Power.toggle[ radio_id_t id ](){}
  default async command bool Power.get[ radio_id_t id ](){return FALSE;}
  default async command void Power.makeInput[ radio_id_t id ](){}
  default async command bool Power.isInput[ radio_id_t id ](){return FALSE;}
  default async command void Power.makeOutput[ radio_id_t id ](){}
  default async command bool Power.isOutput[ radio_id_t id ](){return FALSE;}

  default async command void Gdo0_io.set[ radio_id_t id ](){}
  default async command void Gdo0_io.clr[ radio_id_t id ](){}
  default async command void Gdo0_io.toggle[ radio_id_t id ](){}
  default async command bool Gdo0_io.get[ radio_id_t id ](){return FALSE;}
  default async command void Gdo0_io.makeInput[ radio_id_t id ](){}
  default async command bool Gdo0_io.isInput[ radio_id_t id ](){return FALSE;}
  default async command void Gdo0_io.makeOutput[ radio_id_t id ](){}
  default async command bool Gdo0_io.isOutput[ radio_id_t id ](){return FALSE;}
  
  default async command void Gdo2_io.set[ radio_id_t id ](){}
  default async command void Gdo2_io.clr[ radio_id_t id ](){}
  default async command void Gdo2_io.toggle[ radio_id_t id ](){}
  default async command bool Gdo2_io.get[ radio_id_t id ](){return FALSE;}
  default async command void Gdo2_io.makeInput[ radio_id_t id ](){}
  default async command bool Gdo2_io.isInput[ radio_id_t id ](){return FALSE;}
  default async command void Gdo2_io.makeOutput[ radio_id_t id ](){}
  default async command bool Gdo2_io.isOutput[ radio_id_t id ](){return FALSE;}
  
  default async command error_t Gdo0_int.enableRisingEdge[radio_id_t id]() { return FAIL; }
  default async command error_t Gdo0_int.enableFallingEdge[radio_id_t id]() { return FAIL; }
  default async command error_t Gdo0_int.disable[radio_id_t id]() { return FAIL; }
  
  default async command error_t Gdo2_int.enableRisingEdge[radio_id_t id]() { return FAIL; }
  default async command error_t Gdo2_int.enableFallingEdge[radio_id_t id]() { return FAIL; }
  default async command error_t Gdo2_int.disable[radio_id_t id]() { return FAIL; }
  
  
  default event void SplitControl.startDone[ radio_id_t id ](error_t error){}
  default event void SplitControl.stopDone[ radio_id_t id ](error_t error){}
  
  default command blaze_init_t *BlazeRegSettings.getDefaultRegisters[ radio_id_t id ]() { return NULL; }
  default command uint8_t BlazeRegSettings.getPa[ radio_id_t id ]() { return 0xC0; }
  default event void BlazeCommit.commitDone[ radio_id_t id ]() {}
  
  default event void ReceiveMode.srxDone[uint8_t clientId]() {}
  
}
