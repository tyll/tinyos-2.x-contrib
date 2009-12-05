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
 * Manage the CC1100 SPI connection
 * @author Jared Hill
 * @author David Moss
 * @author Roland Hendel
 */
 
#include "Blaze.h"
#include "CC1100.h"
#include "AM.h"

module CC1100ControlP {

  provides {
    interface Init as SoftwareInit;
    interface BlazeRegSettings;
    interface BlazeConfig;
  }

  uses {
    interface SplitControlManager;
    interface BlazeCommit;
    interface Leds;
  }
}

implementation {

  /** TRUE if address recognition is enabled */
  norace bool addressRecognition;
  
  /** TRUE if PAN recognition is enabled */
  norace bool panRecognition;
  
  /** TRUE if we should auto-acknowledge packets if an ack is requested */
  norace bool autoAck;
  
  
  /** Default register values. Change the configuration by editing CC1100.h */
  uint8_t regValues[] = {
      CC1100_CONFIG_IOCFG2, 
      CC1100_CONFIG_IOCFG1, 
      CC1100_CONFIG_IOCFG0,
      CC1100_CONFIG_FIFOTHR, 
      CC1100_CONFIG_SYNC1, 
      CC1100_CONFIG_SYNC0, 
      CC1100_CONFIG_PKTLEN,
      CC1100_CONFIG_PKTCTRL1, 
      CC1100_CONFIG_PKTCTRL0, 
      CC1100_CONFIG_ADDR, 
      CC1100_CONFIG_CHANNR,
      CC1100_CONFIG_FSCTRL1, 
      CC1100_CONFIG_FSCTRL0, 
      CC1100_CONFIG_FREQ2, 
      CC1100_CONFIG_FREQ1,
      CC1100_CONFIG_FREQ0, 
      CC1100_CONFIG_MDMCFG4, 
      CC1100_CONFIG_MDMCFG3, 
      CC1100_CONFIG_MDMCFG2,
      CC1100_CONFIG_MDMCFG1, 
      CC1100_CONFIG_MDMCFG0, 
      CC1100_CONFIG_DEVIATN, 
      CC1100_CONFIG_MCSM2,
      CC1100_CONFIG_MCSM1, 
      CC1100_CONFIG_MCSM0, 
      CC1100_CONFIG_FOCCFG,
      CC1100_CONFIG_BSCFG,
      CC1100_CONFIG_AGCTRL2,
      CC1100_CONFIG_AGCTRL1,
      CC1100_CONFIG_AGCTRL0,
      CC1100_CONFIG_WOREVT1,
      CC1100_CONFIG_WOREVT0,
      CC1100_CONFIG_WORCTRL,
      CC1100_CONFIG_FREND1,
      CC1100_CONFIG_FREND0,
      CC1100_CONFIG_FSCAL3,
      CC1100_CONFIG_FSCAL2,
      CC1100_CONFIG_FSCAL1,
      CC1100_CONFIG_FSCAL0,
      CC1100_CONFIG_RCCTRL1,
      CC1100_CONFIG_RCCTRL0,
      CC1100_CONFIG_FSTEST,
      CC1100_CONFIG_PTEST,
      CC1100_CONFIG_AGCTST,
      CC1100_CONFIG_TEST2,
      CC1100_CONFIG_TEST1,
      CC1100_CONFIG_TEST0,
  };
  

  
  /***************** Prototypes ****************/
  uint8_t freqToChannel( uint32_t freq );
  uint32_t channelToFreq( uint8_t chan );
  uint32_t toFreqRegValues(float desiredFrequencyHz);
  uint32_t getFreqReg();
  void putFreqReg(uint32_t freqx);
  
  /***************** SoftwareInit Commands ****************/
  command error_t SoftwareInit.init() {    
#if defined(NO_ACKNOWLEDGEMENTS)
    autoAck = FALSE;
#else
    autoAck = TRUE;
#endif

#if defined(NO_ADDRESS_RECOGNITION)
    call BlazeConfig.setAddressRecognition(FALSE);
#else
    call BlazeConfig.setAddressRecognition(TRUE);
#endif


#if defined(NO_PAN_RECOGNITION)
    panRecognition = FALSE;
#else
    panRecognition = TRUE;
#endif
    
    return SUCCESS;
  }
  
  /***************** BlazeInit Commands ****************/
  command uint8_t *BlazeRegSettings.getDefaultRegisters() {
    return regValues;
  }

  command uint8_t BlazeRegSettings.getPa() {
    return CC1100_PA;
  }
  
  /***************** BlazeConfig Commands ****************/
  /**
   * If changes have been made to the chip's configuration, those changes are
   * currently stored in the microcontroller.  This command will commit those 
   * changes to hardware.  It must be called for the changes to take effect.
   * @return SUCCESS if the changes will be committed.
   */
  command error_t BlazeConfig.commit() {
    if(call SplitControlManager.isOn()) {
      return call BlazeCommit.commit();
      
    } else {
      // These changes will be automatically committed next time you turn it on.
      return EOFF;
    }
  }
  
  /**
   * @param on TRUE to turn address recognition on, FALSE to turn it off
   * You must call sync() after this to propagate changes to hardware
   */
  command void BlazeConfig.setAddressRecognition(bool on) {
    atomic addressRecognition = on;
  }
  
  /**
   * @return TRUE if address recognition is enabled
   */
  async command bool BlazeConfig.isAddressRecognitionEnabled() {
    return addressRecognition;
  }
  
  /** 
   * @param on TRUE if we should only accept packets from other nodes in our PAN
   */
  command void BlazeConfig.setPanRecognition(bool on) {
    panRecognition = on;
  }
  
  /**
   * @return TRUE if PAN address recognition is enabled
   */
  async command bool BlazeConfig.isPanRecognitionEnabled() {
    return panRecognition;
  }
  
  /**
   * Sync must be called for acknowledgement changes to take effect
   * @param enableAutoAck TRUE to enable auto acknowledgements
   * @param hwAutoAck TRUE to default to hardware auto acks, FALSE to
   *     default to software auto acknowledgements
   */
  command void BlazeConfig.setAutoAck(bool enableAutoAck) {
    atomic autoAck = enableAutoAck;  
  }
  
  /**
   * @return TRUE if auto acks are enabled
   */
  async command bool BlazeConfig.isAutoAckEnabled() {
    bool atomicAckEnabled;
    atomic atomicAckEnabled = autoAck;
    return atomicAckEnabled;
  }
  
  /**
   * Set the base frequency. The unit depends on the type of chip you're using:
   *  > CC2500 is in MHz, so you'd say "2145" for 2145 MHz.  
   *  > CC1100 is in Hz, so you'd say "315000000" for 315 MHz.
   *
   * You'll need to commit these changes when you're done.
   * 
   * @param freq The desired frequency
   * @return EINVAL if there's a problem
   */ 
  command error_t BlazeConfig.setBaseFrequency(uint32_t freq) {
    if(freq < 300000000 || freq > 950000000) {
      return EINVAL;
    }
    
    putFreqReg(toFreqRegValues((float) freq));
    return SUCCESS;
  }
  
  /**
   * Get the base frequency, in whatever unit the radio uses. 
   *  > CC2500 uses MHz
   *  > CC1100 uses Hz
   * @return the base frequency
   */
  command uint32_t BlazeConfig.getBaseFrequency() {
    uint32_t freqReg = getFreqReg();
    float multiplier = ((float) CC1100_CRYSTAL_HZ / (float) 65536);
    return (uint32_t) (multiplier * freqReg);
  }
  
  /** 
   * This command is used to set the (approximate) frequency the radio.
   * It uses the assumed base frequency, the assumed channel width and the changes the 
   * value in the channel register.  
   * @param freqKhz - the desired frequency in Khz to set the radio to
   * @reutrn - FAIL if desired frequency is not in range, else SUCCESS
   */
  command error_t BlazeConfig.setChannelFrequencyKhz( uint32_t freqKhz ) {
    // We have to convert our base frequency in Hz to kHz
    if((freqKhz > (call BlazeConfig.getBaseFrequency() / 1000) + (CC1100_CHANNEL_WIDTH * 255)) 
        || (freqKhz < (call BlazeConfig.getBaseFrequency() / 1000))){
      return EINVAL;
    } 
    
    regValues[BLAZE_CHANNR] = freqToChannel(freqKhz);
    return SUCCESS;
  }
  
  /** 
   * This command is used to get the current (approximate) frequency the radio is set to in KHz.
   * It uses the assumed base frequency, the assumed channel width and the current value in the 
   * channel register to calculate this.  
   * @return approx. frequency in KHz
   */
  command uint32_t BlazeConfig.getChannelFrequencyKhz() {
    return channelToFreq(regValues[BLAZE_CHANNR]);
  }
  
  /** 
   * This command sets the value of the channel register on the radio
   * @param chan - the value of the channel
   * @return EINVAL if the channel is out of bounds
   */
  command error_t BlazeConfig.setChannel( uint8_t chan ) {
    if(chan < CC1100_CHANNEL_MIN || chan > CC1100_CHANNEL_MAX) {
      return EINVAL;
    }
    
    regValues[BLAZE_CHANNR] = chan;
    return SUCCESS;
  }
  
  /** 
   * This command returns the value of the channel register on the radio
   * @return the value of the channel register
   */
  command uint8_t BlazeConfig.getChannel() {
    return regValues[BLAZE_CHANNR];
  }
  
  
  /***************** BlazeCommit Events ****************/
  event void BlazeCommit.commitDone() {
    signal BlazeConfig.commitDone();
  }
 
  /***************** SplitControlManager Events ****************/
  event void SplitControlManager.stateChange() {
  }
  
  /***************** Functions ****************/
  uint8_t freqToChannel( uint32_t freq ) {
    uint32_t offset;
    uint32_t rem;
    uint8_t chann;
    offset = freq - (call BlazeConfig.getBaseFrequency() / 1000); // Hz->kHz
    rem = offset % CC1100_CHANNEL_WIDTH;
    chann = (uint8_t)(offset / CC1100_CHANNEL_WIDTH); 
    if(rem > (CC1100_CHANNEL_WIDTH >> 1)){
      chann++;    
    }
    return chann;
  }
  
  uint32_t channelToFreq( uint8_t chan ){
    uint32_t offset;
    offset = (uint32_t)(((uint32_t)chan) * CC1100_CHANNEL_WIDTH);
    return offset + (call BlazeConfig.getBaseFrequency() / 1000); // Hz->kHz
  }
  
  /**
   * Calculate the FREQx registers based on a desired frequency.
   * Your crystal must be specified correctly in the CC1100.h file.
   * @param desiredFrequencyHz something like 315000000
   * @return the contents of the FREQ2,1,0 registers all combined
   */
  uint32_t toFreqRegValues(float desiredFrequencyHz) {
    float divisor = ((float) CC1100_CRYSTAL_HZ / (float) 65536);
    return (uint32_t) (desiredFrequencyHz / divisor);
  }
  
  /**
   * @return the contents of the FREQx registers combined
   */
  uint32_t getFreqReg() {
    return (((uint32_t) regValues[BLAZE_FREQ2]) << 16) 
        | (((uint32_t) regValues[BLAZE_FREQ1]) << 8) 
        | (((uint32_t) regValues[BLAZE_FREQ0]));
  }
  
  /**
   * Fill the FREQx registers with the given frequency register setting.
   */
  void putFreqReg(uint32_t freqx) {
    regValues[BLAZE_FREQ2] = freqx >> 16;
    regValues[BLAZE_FREQ1] = freqx >> 8;
    regValues[BLAZE_FREQ0] = freqx;
  }
    
  /***************** Defaults ****************/
  default event void BlazeConfig.commitDone() {}
}
