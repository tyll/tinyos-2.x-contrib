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
 * Manage the CC2500 SPI connection
 * @author Jared Hill
 * @author David Moss
 * @author Roland Hendel
 */
 
#include "Blaze.h"
#include "CC2500.h"
#include "AM.h"

module CC2500ControlP {

  provides {
    interface Init as SoftwareInit;
    interface BlazeRegSettings;
    interface BlazeConfig;
  }

  uses {
    interface ActiveMessageAddress;
    interface BlazeCommit;
    interface SplitControlManager[radio_id_t radioId];
    interface Leds;
  }
}

implementation {

  /** The personal area network address for this radio */
  uint16_t panAddress;
  
  /** TRUE if address recognition is enabled */
  bool addressRecognition;
  
  /** TRUE if PAN recognition is enabled */
  bool panRecognition;
  
  /** TRUE if we should auto-acknowledge packets if an ack is requested */
  bool autoAck;
    
  /** Default register values. Change the configuration by editing CC2500.h */
  uint8_t regValues[] = {
      CC2500_CONFIG_IOCFG2, 
      CC2500_CONFIG_IOCFG1, 
      CC2500_CONFIG_IOCFG0,
      CC2500_CONFIG_FIFOTHR, 
      CC2500_CONFIG_SYNC1, 
      CC2500_CONFIG_SYNC0, 
      CC2500_CONFIG_PKTLEN,
      CC2500_CONFIG_PKTCTRL1, 
      CC2500_CONFIG_PKTCTRL0, 
      CC2500_CONFIG_ADDR, 
      CC2500_CONFIG_CHANNR,
      CC2500_CONFIG_FSCTRL1, 
      CC2500_CONFIG_FSCTRL0, 
      CC2500_CONFIG_FREQ2, 
      CC2500_CONFIG_FREQ1,
      CC2500_CONFIG_FREQ0, 
      CC2500_CONFIG_MDMCFG4, 
      CC2500_CONFIG_MDMCFG3, 
      CC2500_CONFIG_MDMCFG2,
      CC2500_CONFIG_MDMCFG1, 
      CC2500_CONFIG_MDMCFG0, 
      CC2500_CONFIG_DEVIATN, 
      CC2500_CONFIG_MCSM2,
      CC2500_CONFIG_MCSM1, 
      CC2500_CONFIG_MCSM0, 
      CC2500_CONFIG_FOCCFG,
      CC2500_CONFIG_BSCFG,
      CC2500_CONFIG_AGCTRL2,
      CC2500_CONFIG_AGCTRL1,
      CC2500_CONFIG_AGCTRL0,
  };
  
  
  /***************** Prototypes ****************/
  uint8_t freqToChannel( uint32_t freq );
  uint32_t channelToFreq( uint8_t chan );
  uint32_t toFreqRegValues(float desiredFrequencyMhz);
  uint32_t getFreqReg();
  void putFreqReg(uint32_t freqx);
  
  task void commit();
  
  /***************** SoftwareInit Commands ****************/
  command error_t SoftwareInit.init() {
    // Our header dest is an nxle. Match up our 8-bit address with it.
    regValues[BLAZE_ADDR] = call ActiveMessageAddress.amAddress();
    panAddress = TOS_AM_GROUP;
    
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
    return CC2500_PA;
  }
  
  /***************** BlazeConfig Commands ****************/
  
  /**
   * If changes have been made to the chip's configuration, those changes are
   * currently stored in the microcontroller.  This command will commit those 
   * changes to hardware.  It must be called for the changes to take effect.
   * @return SUCCESS if the changes will be committed.
   */
  command error_t BlazeConfig.commit() {
    if(call SplitControlManager.isOn[CC2500_RADIO_ID]()) {
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
    if(on) {
      regValues[BLAZE_PKTCTRL1] |= 0x3;
    } else {
      regValues[BLAZE_PKTCTRL1] &= 0xFC;
    }
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
    atomic panRecognition = on;
  }
  
  /**
   * @return TRUE if PAN address recognition is enabled
   */
  async command bool BlazeConfig.isPanRecognitionEnabled() {
    bool atomicPanEnabled;
    atomic atomicPanEnabled = panRecognition;
    return atomicPanEnabled;
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
    if(freq < 2112 || freq > 2500) {
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
    float multiplier = ((float) CC2500_CRYSTAL_MHZ / (float) 65536);
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
    // We have to convert our base frequency in MHz to kHz
    if((freqKhz > (call BlazeConfig.getBaseFrequency() * 1000) + (CC2500_CHANNEL_WIDTH * 255)) 
        || (freqKhz < (call BlazeConfig.getBaseFrequency() * 1000))){
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
    if(chan < CC2500_CHANNEL_MIN || chan > CC2500_CHANNEL_MAX) {
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
  
  
  /***************** ActiveMessageAddress Events ****************/
  async event void ActiveMessageAddress.changed() {   
    regValues[BLAZE_ADDR] = call ActiveMessageAddress.amAddress();
    atomic panAddress = call ActiveMessageAddress.amGroup();
    post commit();
  }
  
  /***************** BlazeCommit Events ****************/
  event void BlazeCommit.commitDone() {
    signal BlazeConfig.commitDone();
  }
   
  /***************** SplitControlManager Events ****************/
  event void SplitControlManager.stateChange[radio_id_t radioId]() {
  }
  
  /***************** Functions ****************/
  uint8_t freqToChannel( uint32_t freq ){
  
    uint32_t offset;
    uint32_t rem;
    uint8_t chann;
    offset = freq - (call BlazeConfig.getBaseFrequency() * 1000);  // MHz->kHz
    rem = offset % CC2500_CHANNEL_WIDTH;
    chann = (uint8_t)(offset / CC2500_CHANNEL_WIDTH); 
    if(rem > (CC2500_CHANNEL_WIDTH >> 1)){
      chann++;    
    }
    return chann;     
  
  }
  
  uint32_t channelToFreq( uint8_t chan ) {
    uint32_t offset;
    offset = (uint32_t)(((uint32_t)chan) * CC2500_CHANNEL_WIDTH);
    return offset + (call BlazeConfig.getBaseFrequency() * 1000);  // MHz->kHz
  }
  
  /**
   * Calculate the FREQx registers based on a desired frequency.
   * Your crystal must be specified correctly in the CC2500.h file.
   * @param desiredFrequencyMhz something like 2145
   * @return the contents of the FREQ2,1,0 registers all combined
   */
  uint32_t toFreqRegValues(float desiredFrequencyMhz) {
    float divisor = (float) CC2500_CRYSTAL_MHZ / (float) 65536;
    return (uint32_t) (desiredFrequencyMhz / divisor);
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
  
  
 
  /**
   * Out of async context
   */
  task void commit() {
    if(call SplitControlManager.isOn[CC2500_RADIO_ID]()) {
      call BlazeCommit.commit();
    }
  }
  
  /***************** Defaults ****************/
  default event void BlazeConfig.commitDone() {}
}
