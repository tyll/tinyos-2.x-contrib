/* 
 * Copyright (c) 2008, University of Twente (UTWENTE), the Netherlands.
 * All rights reserved.
 *
 * Redistribution and use in source and binary forms, with or without
 * modification, are permitted provided that the following conditions
 * are met:
 * - Redistributions of source code must retain the above copyright notice,
 *   this list of conditions and the following disclaimer.
 * - Redistributions in binary form must reproduce the above copyright
 *   notice, this list of conditions and the following disclaimer in the
 *   documentation and/or other materials provided with the distribution.
 * - Neither the name of the University of Twente (UTWENTE)
 *   nor the names of its contributors may be used to 
 *   endorse or promote products derived from this software without 
 *   specific prior written permission.
 * 
 * THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS
 * "AS IS" AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT
 * LIMITED TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR
 * A PARTICULAR PURPOSE ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT
 * OWNER OR CONTRIBUTORS BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL,
 * SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED
 * TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA,
 * OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY
 * OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT
 * (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE
 * USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
 *
 * ========================================================================
 */

/**
 * Interface for physical parameter settings (bw, bitrate, power) 
 * on the nRF905 radio. 
 *
 * @author Leon Evers
 */

interface nRF905PhyConf {

#include "nRF905.h"

  /**
   * Tune the nRF905 to operate on a preset channel.
   *
   * @param preset Channel index as defined in nRF905.h
   * @return SUCCESS if configuration done ok, error status otherwise.
   */
  command error_t tunePreset(nrf905_channelpreset_t preset);

  /**
   * Set the output power of the nRF905.
   *
   * @param pow Power index as defined in nRF905.h
   * @return SUCCESS if configuration done ok, error status otherwise.
   */
  async command error_t setRFPower(nrf905_txpower_t txpow);
	
  /**
   * Set the raw communication bitrate. The frequency deviation and receiver 
   * filter bandwidth are also set to appropriate values for the bitrate. Advanced users 
   * can still override the freq. dev and bw values with the individual functions below.
   *
   * @param value_ Bitrate  (min 1190 bps, max 152340 bps)
   * @return SUCCESS if configuration done ok, error status otherwise.
   */
  command error_t setBitrate(nrf905_bitrate_t bitrate);

  /** 
   * Get the time (in us) to send/receive a byte at current bit rate.
   *
   * @return time (in us).
   */
  async command uint16_t getByteTime_us();

}
