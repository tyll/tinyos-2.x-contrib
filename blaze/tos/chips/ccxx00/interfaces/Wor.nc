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
 * Wake-on-Radio hardware configuration interface
 * @author David Moss
 */

interface Wor {

  /**
   * Enable Wake-on-Radio by turning on the RC oscillator, sleeping if no
   * carrier sense, and strobing WOR.
   *
   * Disable Wake-on-Radio by disabling the RC oscillator, staying awake 
   * regardless of carrier sense, and strobing into RX mode.
   * @param on Turn WoR on or off
   */
  command void enableWor(bool on);
  
  /**
   * @return TRUE if WoR is enabled for the given parameterized radio id
   */
  command bool isEnabled();
  
  /**
   * If WoR is enabled on the selected parameterized radio, then the 
   * radio is re-sync'd with the latest settings. Otherwise
   * we assume the radio is off and will be resync'd automatically when it's
   * turned back on.
   */
  command void synchronizeSettings();
  
  /** 
   * Calculate the EVENT0 register based on the number of milliseconds you'd
   * like to have between sleep intervals.  This is dependent upon the
   * CCXX00_CRYSTAL_KHZ preprocessor variable.
   * @param evt0_ms The desired duration between rx checks, in true ms
   */
  command void calculateAndSetEvent0(uint16_t evt0_ms);
  
  /** 
   * @return EVENT0, converted back to true milliseconds
   */
  command uint16_t getEvent0Ms();
  
  /**
   * Set EVENT0 directly. Default is 1 second sleep interval on a 26 MHz xosc.
   * @param evt0 The register settings for the EVENT0 word
   */
  command void setEvent0(uint16_t evt0);
  
  /**
   * Set the RX_TIME field in MCSM2. This sets the duty cycle percentage.
   * The default is 0.195% duty cycle (6)
   * @param rxTime The RX_TIME field value in MCSM2
   */
  command void setRxTime(uint8_t rxTime);
  
  /**
   * @param sleepOnNoCarrier If a carrier is not detected within the first 8
   *     symbol periods, go back to sleep.
   */
  command void setRxTimeRssi(bool sleepOnNoCarrier);
  
  /**
   * @param enablePqi Extend the on-time of the radio during an Rx check if
   *     a valid preamble has been detected.
   */
  command void setRxTimeQual(bool enablePqi);
  
  /**
   * Set the EVENT1 field in the WORCTRL register. This is how long it
   * takes to warm up and calibrate the oscillator before going into
   * Rx mode. The default is 1.38 ms startup (7).
   * @param evt1 The EVENT1 field value in WORCTRL
   */
  command void setEvent1(uint8_t evt1);


  /** 
   * WoR just got enabled or disabled
   * @bool enabled TRUE if WoR is now turned on, FALSE if it's off
   */
  event void stateChange(bool enabled);
  
}

