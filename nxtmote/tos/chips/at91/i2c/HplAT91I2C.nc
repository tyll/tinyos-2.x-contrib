/*
 * Copyright (c) 2007 Copenhagen Business School 
 * All rights reserved. 
 * Redistribution and use in source and binary forms, with or without
 * modification, are permitted provided that the following conditions are
 * met:
 *	Redistributions of source code must retain the above copyright
 * notice, this list of conditions and the following disclaimer.
 *	Redistributions in binary form must reproduce the above copyright
 * notice, this list of conditions and the following disclaimer in the
 * documentation and/or other materials provided with the distribution.
 *  
 *   Neither the name of the CBS nor the names of its
 * contributors may be used to endorse or promote products derived from
 * this software without specific prior written permission.
 *
 * THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS
 * ``AS IS'' AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT
 * LIMITED TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR
 * A PARTICULAR PURPOSE ARE DISCLAIMED.  IN NO EVENT SHALL THE ARCHED
 * ROCK OR ITS CONTRIBUTORS BE LIABLE FOR ANY DIRECT, INDIRECT,
 * INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING,
 * BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS
 * OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND
 * ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR
 * TORT (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE
 * USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH
 * DAMAGE.
 */
/**
 * The AT91 I2C HPL interface. 
 * See pages 287-303 in the At91SAM7S Series Preliminary
 * @author Rasmus Ulslev Pedersen
 */

interface HplAT91I2C
{
  /**
   * Set TWI transmit holding register.
   *
   * @param val The byte to transmit in bit 7:0.
   */
  async command void setTWITHR(uint32_t val);
  
  /**
   * Get TWI receive holding register.
   *
   * @return val The received byte.
   */
  async command uint32_t getTWIRHR();

  /**
   * Set TWI master mode register.
   *
   * @param val :
   *    AT91C_TWI_DADR   - Device address
   *    AT91C_TWI_MREAD  - Master read direction
   *    AT91C_TWI_IADRSZ - Internal Device Address (0 means no internal device addr.)
   */
  async command void setTWIMMR(uint32_t val);

  /**
   * Set TWI control register.
   *
   * @param val :
   *    AT91C_TWI_START - Send a start condition
   *    AT91C_TWI_STOP  - Send a stop condition
   *    AT91C_TWI_MSEN  - Master transfer enabled
   *    AT91C_TWI_MSDIS - Master Transfer disabled
   *    AT91C_TWI_SWRST - Software reset
   */
  async command void setTWICR(uint32_t val);

  /**
   * Set TWI status register.
   *
   * @param val :
   *    AT91C_TWI_TXCOMP - Transmission completed
   *    AT91C_TWI_RXRDY  - Receive holding register ready
   *    AT91C_TWI_TXDRY  - Transmit holding register ready
   *    AT91C_TWI_NACK   - Not acknowledged
   *    AT91C_TWI_OVRE   - Overrun Error
   *    AT91C_TWI_UNRE   - Underrun Error
   */
  async command uint32_t getTWISR();

  /**
   * Set TWI clock waveform generator register.
   *
   * @param val :
   *    AT91C_TWI_CLDIV  - Clock low divider
   *    AT91C_TWI_CHDIV  - Clock high divider
   *    AT91C_TWI_CKDIV  - Clock divider
   */
  async command void setTWICWGR(uint32_t val);

  /**
   * Set TWI interrupt enable register.
   *
   * @param val :
   *    AT91C_TWI_TXCOMP - Transmission completed
   *    AT91C_TWI_RXRDY  - Receive holding register ready
   *    AT91C_TWI_TXRDY  - Transmit holding register ready
   *    AT91C_TWI_NACK   - Not acknowledge 
   */
  async command void setTWIIER(uint32_t val);

  /**
   * Set TWI interrupt disable register.
   *
   * @param val :
   *    AT91C_TWI_TXCOMP - Transmission completed
   *    AT91C_TWI_RXRDY  - Receive holding register ready
   *    AT91C_TWI_TXRDY  - Transmit holding register ready
   *    AT91C_TWI_NACK   - Not acknowledge 
   */
  async command void setTWIIDR(uint32_t val);
  
  /**
   * Notification for an i2c event.
   */
  async event void interruptI2C();

}
