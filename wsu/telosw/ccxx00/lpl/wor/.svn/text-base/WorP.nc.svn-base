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
 * This is sort of the hardware presentation layer of Wake-on-Radio
 *
 * The KickTimer was integrated due to WoR issues:
 * The microcontroller tells the radio to go into WoR mode. The radio
 * says its in WoR mode, and then never signals the microcontroller
 * that a new packet has been received. This may be due to the WoR timer
 * not turning on properly in the radio (I could have sworn I stopped seeing
 * receive check signatures in the energy consumption of the radio). Without
 * the radio doing its job, there is no way for the microcontroller to know
 * something is wrong.  We could possibly turn GDO2 into an Event0 or Event1
 * signal and verify that WoR is running on the radio, but a simpler solution
 * that shouldn't require widespread code changes is to set a periodic timer
 * that kicks WoR every so often.  That's what the KickTimer is doing,
 * and if we could reliably get the radio to do its job, we'd be able to 
 * remove the kick timer that makes sure the radio is in WoR mode.
 *
 * The KickTimer should not fire if we recently received a packet, or
 * are transmitting a packet which naturally disables WoR.  The only
 * time it should fire is every WOR_KICK_TIMER seconds of inactivity.
 * 
 * @author David Moss
 */

#include "Wor.h"
#include "Blaze.h"

module WorP {
  provides {
    interface Init;
    interface Wor[radio_id_t radioId];
    
  }
  
  uses {
    interface Resource;
    interface BlazeRegister as MCSM2;
    interface BlazeRegister as WOREVT1;
    interface BlazeRegister as WOREVT0;
    interface BlazeRegister as WORCTRL;
    interface BlazeStrobe as SWOR;
    interface BlazeStrobe as SIDLE;
    interface BlazeStrobe as SRX;
    interface BlazeStrobe as SFRX;
    interface BlazeStrobe as SFTX;
    interface RadioStatus;

    interface GeneralIO as ChipRdy[radio_id_t radioId];
    interface GeneralIO as Csn[radio_id_t radioId];
    interface GpioInterrupt as RxInterrupt[radio_id_t radioId];
    
    interface Timer<TMilli> as KickTimer;
    interface Leds;

		interface BlazeRegister as PKTSTATUS;
  }
}

implementation {

  radio_id_t focusedRadio;
  bool enabling;
  uint8_t state;
  
  struct {
    uint8_t mcsm2;
    bool worEnabled;
    uint16_t event0;
    uint8_t event1;
  } worSettings[uniqueCount(UQ_BLAZE_RADIO)];
  
  enum {
    S_IDLE,
    S_TOGGLING,
  };
  
  /***************** Prototypes ****************/
  void setupWor();
  void verifyRxMode();
  
  /***************** Init Commands ****************/
  /**
   * Testing demonstrates that event1=0x7 is actually more energy efficient 
   * than event1=0x0
   */
  command error_t Init.init() {
    int i;
    for(i = 0; i < uniqueCount(UQ_BLAZE_RADIO); i++) {
      worSettings[i].mcsm2 = 0xFE;
      worSettings[i].worEnabled = FALSE;
      worSettings[i].event0 = 0x876B;  
      worSettings[i].event1 = 0x7;
    }
    return SUCCESS;
  }
  
  
  /***************** Wor Commands ****************/
  /**
   * Enable Wake-on-Radio by turning on the RC oscillator, sleeping if no
   * carrier sense, and strobing WOR.
   *
   * Disable Wake-on-Radio by disabling the RC oscillator, staying awake 
   * regardless of carrier sense, and strobing into RX mode.
   * @param on Turn WoR on or off
   */
  command void Wor.enableWor[radio_id_t radioId](bool on) {
    if(state != S_IDLE) {
      return;
    }
    
#if BLAZE_ENABLE_SPI_WOR_RX_LEDS
      // Flicker to notify a change event was requested
      call Leds.led2Toggle();
      call Leds.led2Toggle();
#endif
    
    state = S_TOGGLING;
    
    focusedRadio = radioId;
    enabling = on;
    
    if(call Resource.isOwner()) {
      setupWor();
      
    } else if(call Resource.immediateRequest() == SUCCESS) {
      setupWor();
      
    } else {
    
#if BLAZE_ENABLE_SPI_WOR_RX_LEDS
      call Leds.led2Off();
#endif

      call Resource.release();
      state = S_IDLE;
      signal Wor.stateChange[focusedRadio](FALSE);
    }
  }
  
  command void Wor.synchronizeSettings[radio_id_t radioId]() {
    worSettings[radioId].worEnabled = FALSE;
    call Wor.enableWor[radioId](TRUE);
  }
  
  command uint16_t Wor.getEvent0Ms[radio_id_t radioId]() {
    return (((uint32_t) 750) * ((uint32_t) worSettings[radioId].event0)) / CCXX00_CRYSTAL_KHZ;
  }
  
  
  /**
   * @return TRUE if WoR is enabled for the given parameterized radio id
   */
  command bool Wor.isEnabled[radio_id_t radioId]() {
    return worSettings[radioId].worEnabled;
  }
  
  /** 
   * Calculate the EVENT0 register based on the number of milliseconds you'd
   * like to have between sleep intervals.  This is dependent upon the
   * CCXX00_CRYSTAL_KHZ preprocessor variable.
   * @param evt0_ms The desired duration between rx checks, in exact ms
   */
  command void Wor.calculateAndSetEvent0[radio_id_t radioId](uint16_t evt0_ms) {
    // Assumes WOR_RES = 0
    worSettings[radioId].event0 = ((uint32_t) evt0_ms * (uint32_t) CCXX00_CRYSTAL_KHZ) / 750;
  }
  
  
  
  /**
   * Set EVENT0 directly.
   * @param evt0 The register settings for the EVENT0 word
   */
  command void Wor.setEvent0[radio_id_t radioId](uint16_t evt0) {
    worSettings[radioId].event0 = evt0;
  }
  
  /**
   * Set the RX_TIME field in MCSM2. This sets the duty cycle percentage.
   * The default is 0.195% duty cycle (6)
   * @param rxTime The RX_TIME field value in MCSM2
   */
  command void Wor.setRxTime[radio_id_t radioId](uint8_t rxTime) {
    worSettings[radioId].mcsm2 = 
        (worSettings[radioId].mcsm2 & CCXX00_MCSM2_RX_TIME_MASK)
            | (rxTime << CCXX00_MCSM2_RX_TIME);
  }
  
  /**
   * Default is TRUE
   * @param sleepOnNoCarrier If a carrier is not detected within the first 8
   *     symbol periods, go back to sleep.
   */
  command void Wor.setRxTimeRssi[radio_id_t radioId](bool sleepOnNoCarrier) {
    worSettings[radioId].mcsm2 = 
        (worSettings[radioId].mcsm2 & CCXX00_MCSM2_RX_TIME_RSSI_MASK)
            | (sleepOnNoCarrier << CCXX00_MCSM2_RX_TIME);
  }
  
  /**
   * Default is FALSE
   * @param enablePqi Extend the on-time of the radio during an Rx check if
   *     a valid preamble has been detected.
   */
  command void Wor.setRxTimeQual[radio_id_t radioId](bool enablePqi) {
    worSettings[radioId].mcsm2 = 
      (worSettings[radioId].mcsm2 & CCXX00_MCSM2_RX_TIME_QUAL_MASK)
          | (enablePqi << CCXX00_MCSM2_RX_TIME_QUAL);
  }
  
  /** 
      // Setup EVENT0, the time betwee
   * Set the EVENT1 field in the WORCTRL register. This is how long it
   * takes to warm up and calibrate the oscillator before going into
   * Rx mode. The default is 1.38 ms startup (7).
   * @param evt1 The EVENT1 field value in WORCTRL
   */
  command void Wor.setEvent1[radio_id_t radioId](uint8_t evt1) {
    worSettings[radioId].event1 = evt1;
  }
  
  
  /***************** RxInterrupt Events ****************/
  async event void RxInterrupt.fired[radio_id_t radioId]() {
    call KickTimer.stop();
    //atomic worSettings[radioId].worEnabled = FALSE;
  }
  
  /***************** Resource Events ****************/
  event void Resource.granted() {
    setupWor();
  }
  
  /***************** KickTimer Events ****************/
  event void KickTimer.fired() {
    // Don't do anything if any other part of the radio stack is in use.
    if(call Resource.immediateRequest() == SUCCESS) {
      // Focused radio is still the last radio we enabled
      enabling = TRUE;
      setupWor();      
    }
  }
  
  /***************** Functions ****************/
  void setupWor() {
		uint8_t pktstatus;
		call PKTSTATUS.read(&pktstatus);
		if(pktstatus & 0x20)
			call Leds.led1Toggle();
		else
			call Leds.led2Toggle();

#if BLAZE_ENABLE_SPI_WOR_RX_LEDS
      // Flicker to notify the resource was granted
      call Leds.led2Toggle();
      call Leds.led2Toggle();
#endif
    
    call Csn.set[focusedRadio]();
    call Csn.clr[focusedRadio](); 
    while(call ChipRdy.get[focusedRadio]());
    
    if(enabling) {
    
#if BLAZE_ENABLE_SPI_WOR_RX_LEDS
      call Leds.led1On();
#endif

      // Enable WoR
      call SIDLE.strobe();
      call SFRX.strobe();
      call SFTX.strobe();
      
      call KickTimer.startPeriodic(WOR_KICK_TIMER);
      
			/*
      // Setup RX_TIME_RSSI, RX_TIME_QUAL, and RX_TIME        
      call MCSM2.write(worSettings[focusedRadio].mcsm2);
      // Setup EVENT0, the time between receive checks.
      call WOREVT1.write(worSettings[focusedRadio].event0 >> 8);
      call WOREVT0.write(worSettings[focusedRadio].event0);
      // Power up the RC Oscillator
      call WORCTRL.write(
          (0 << CCXX00_WORCTRL_RC_PD) |
          (worSettings[focusedRadio].event1 << CCXX00_WORCTRL_EVENT1) |
          (1 << CCXX00_WORCTRL_RC_CAL) |
          (0 << CCXX00_WORCTRL_WOR_RES));
			*/
			/*
			call MCSM2.write(0x10);
			call WOREVT1.write(0x0D);
			call WOREVT0.write(0x8A);
			call WORCTRL.write(0x38);
			*/

			call MCSM2.write(0x10);
			call WOREVT1.write(0x28);
			call WOREVT0.write(0xA0);
			call WORCTRL.write(0x38);
       
      worSettings[focusedRadio].worEnabled = TRUE;
      call SWOR.strobe();
      
    } else {
      
#if BLAZE_ENABLE_SPI_WOR_RX_LEDS
      call Leds.led1Off();
#endif
      
      // Disable WoR
      call SIDLE.strobe();
      call SFRX.strobe();
      call SFTX.strobe();
      
      call KickTimer.stop();

			/*
      // Disable RX_TIME_RSSI
      call MCSM2.write(0x0E);
      // Power down the RC oscillator
      call WORCTRL.write(
            (1 << CCXX00_WORCTRL_RC_PD) |
            (worSettings[focusedRadio].event1 << CCXX00_WORCTRL_EVENT1) |
            (1 << CCXX00_WORCTRL_RC_CAL) |
            (0 << CCXX00_WORCTRL_WOR_RES));
			*/
			call MCSM2.write(0x07);
	//		call WOREVT1.write(0x87);
	//		call WOREVT0.write(0x6b);
	//		call WORCTRL.write(0xf8);
      
      call SRX.strobe();
 //     verifyRxMode();
      
      worSettings[focusedRadio].worEnabled = FALSE;
    }
    
    call Csn.set[focusedRadio]();
    call Resource.release();
    state = S_IDLE;
    signal Wor.stateChange[focusedRadio](enabling);
  }
  
  
  void verifyRxMode() {
    uint8_t status;
    
    /**
     * TODO
     * I had the CC2500 set as the default radio, with WoR interval set to
     * 1000 ms.  Everything was fine, until I tried to disable WoR on 
     * the CC2500 radio, which occurs naturally when the radio is turned off.
     * In this while() loop, the radio responds with a bunch of 4F's, which
     * means "CALIBRATING".  It does this over and over again, and then
     * goes into IDLE mode mysteriously (when it's calibrating, we don't
     * send it any commands to go into IDLE mode).  Once in IDLE mode, the
     * loop would tell the radio SIDLE, SRX.. and we'd get the same result.
     *
     * In other words, the radio calibrates indefinitely and then gives up
     * by going into IDLE mode.  Obviously if we were disabling WoR to send a
     * packet, we wouldn't be able to send that packet due to some other lock
     * up issue.
     *
     * Not sure if this has ever occured on the CC1100 radio.
     */

#warning "Using the CC2500 give-up method for WoR"

    uint16_t giveUp = 0;
    
#if BLAZE_ENABLE_WHILE_LOOP_LEDS
    call Leds.set(5);
#endif
    while((status = call RadioStatus.getRadioStatus()) != BLAZE_S_RX) {
      giveUp++;
      if(giveUp > 1024) {
        break;
      }
      
      call Csn.set[focusedRadio]();
      call Csn.clr[focusedRadio]();
      
      while(call ChipRdy.get[focusedRadio]());
      
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
        // Disable WoR
        call SIDLE.strobe();
        
        // Disable RX_TIME_RSSI
        call MCSM2.write(0x0E);
        
        // Power down the RC oscillator
        call WORCTRL.write(
              (1 << CCXX00_WORCTRL_RC_PD) |
              (worSettings[focusedRadio].event1 << CCXX00_WORCTRL_EVENT1) |
              (1 << CCXX00_WORCTRL_RC_CAL) |
              (0 << CCXX00_WORCTRL_WOR_RES));
        
        call SRX.strobe();
      }
    }

#if BLAZE_ENABLE_WHILE_LOOP_LEDS
    call Leds.set(0);
#endif

    
    call Csn.set[focusedRadio]();
  }
  
  /***************** Defaults *****************/
  default event void Wor.stateChange[radio_id_t radioId](bool enabled) {
  }
  
  default async command void Csn.set[ radio_id_t id ](){}
  default async command void Csn.clr[ radio_id_t id ](){}
  default async command void Csn.toggle[ radio_id_t id ](){}
  default async command bool Csn.get[ radio_id_t id ](){return FALSE;}
  default async command void Csn.makeInput[ radio_id_t id ](){}
  default async command bool Csn.isInput[ radio_id_t id ](){return FALSE;}
  default async command void Csn.makeOutput[ radio_id_t id ](){}
  default async command bool Csn.isOutput[ radio_id_t id ](){return FALSE;}
  
  default async command void ChipRdy.set[ radio_id_t id ](){}
  default async command void ChipRdy.clr[ radio_id_t id ](){}
  default async command void ChipRdy.toggle[ radio_id_t id ](){}
  default async command bool ChipRdy.get[ radio_id_t id ](){return FALSE;}
  default async command void ChipRdy.makeInput[ radio_id_t id ](){}
  default async command bool ChipRdy.isInput[ radio_id_t id ](){return FALSE;}
  default async command void ChipRdy.makeOutput[ radio_id_t id ](){}
  default async command bool ChipRdy.isOutput[ radio_id_t id ](){return FALSE;}
  
  default async command error_t RxInterrupt.enableRisingEdge[radio_id_t id]() {
    return FAIL;
  }
  
  default async command error_t RxInterrupt.enableFallingEdge[radio_id_t id]() {
    return FAIL;
  }
  
  default async command error_t RxInterrupt.disable[radio_id_t id]() {
    return FAIL;
  }
  
}

