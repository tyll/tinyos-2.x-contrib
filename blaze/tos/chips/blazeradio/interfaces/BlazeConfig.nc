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
 * @author Jared Hill
 * @author David Moss
 */
 
interface BlazeConfig {

  /**
   * If changes have been made to the chip's configuration, those changes are
   * currently stored in the microcontroller.  This command will commit those 
   * changes to hardware.  It must be called before any changes made by calling
   * "set" functions within the BlazeConfig interface will take effect.
   * @return SUCCESS if the changes will be committed.
   */
  command error_t commit();
  
  /**
   * The hardware has been loaded with the currently defined configuration
   */
  event void commitDone();
  
  
  /**
   * @param on TRUE to turn address recognition on, FALSE to turn it off
   */
  command void setAddressRecognition(bool on);
  
  /**
   * @return TRUE if address recognition is enabled
   */
  async command bool isAddressRecognitionEnabled();
  
  /** 
   * @param on TRUE if we should only accept packets from other nodes in our PAN
   */
  command void setPanRecognition(bool on);
  
  /**
   * @return TRUE if PAN address recognition is enabled
   */
  async command bool isPanRecognitionEnabled();
  
  /**
   * Sync must be called for acknowledgement changes to take effect
   * @param enableAutoAck TRUE to enable auto acknowledgements
   * @param hwAutoAck TRUE to default to hardware auto acks, FALSE to
   *     default to software auto acknowledgements
   */
  command void setAutoAck(bool enableAutoAck);
  
  /**
   * @return TRUE if auto acks are enabled
   */
  async command bool isAutoAckEnabled();
  
  
  /** 
   * This command is used to set the (approximate) frequency the radio.
   * It uses the assumed base frequency, the assumed channel width and the changes the 
   * value in the channel register.  
   * @param freqKhz - the desired frequency in Khz to set the radio to
   * @reutrn - EINVAL if desired frequency is not in range, else SUCCESS
   */
  command error_t setFrequencyKhz( uint32_t freqKhz );
  
  /** 
   * This command is used to get the current (approximate) frequency the radio is set to in KHz.
   * It uses the assumed base frequency, the assumed channel width and the current value in the 
   * channel register to calculate this.  
   * @return approx. frequency in KHz
   */
  command uint32_t getFrequencyKhz();
  
  /** 
   * This command sets the value of the channel register on the radio
   * @param chan - the value of the channel
   * @return EINVAL if the desired channel is not in range, else SUCCESS
   */
  command error_t setChannel( uint8_t chan );
  
  /** 
   * This command returns the value of the channel register on the radio
   * @return the value of the channel register
   */
  command uint8_t getChannel();
  
}
