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
interface BlazePower {

  /**
   * Restart the chip.  All registers come up in their default settings.
   * @return FAIL if the given radio is not the one in use
   *     SUCCESS if the command will go through
   */
  async command error_t reset();

  /**
   * Stop the oscillator. 
   * @return FAIL if the given radio is not the one in use
   *     SUCCESS if the command will go through
   */
  async command error_t deepSleep();
  
  
  /**
   * Completely power down radios on platforms that have a power pin
   * This doesn't need to return an error_t because it doesn't need to
   * secure the SPI bus for the radio, and the radio doesn't have to be
   * in any special mode.
   */
  async command void shutdown();


  /**
   * @return TRUE if the parameterized radio id is currently turned on
   */
  async command bool isOn();
  

  /**
   * The radio has now been reset
   */
  event void resetComplete();
  
  
  /**
   * The radio is now in deep sleep 
   */
  event void deepSleepComplete();
      
  
  
}
