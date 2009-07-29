/**
 * Copyright (c) 2009 DEXMA SENSORS SL
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
 * - Neither the name of the DEXMA SENSORS SL nor the names of
 *   its contributors may be used to endorse or promote products derived
 *   from this software without specific prior written permission.
 *
 * THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS
 * ``AS IS'' AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT
 * LIMITED TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS
 * FOR A PARTICULAR PURPOSE ARE DISCLAIMED.  IN NO EVENT SHALL THE
 * DEXMA SENSORS SL OR ITS CONTRIBUTORS BE LIABLE FOR ANY DIRECT, INDIRECT,
 * INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES
 * (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR
 * SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION)
 * HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT,
 * STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE)
 * ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED
 * OF THE POSSIBILITY OF SUCH DAMAGE
 */
 
 /*
 * Copyright (c) 2004-2005, Technische Universitaet Berlin
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
 * - Neither the name of the Technische Universitaet Berlin nor the names
 *   of its contributors may be used to endorse or promote products derived
 *   from this software without specific prior written permission.
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
 */

/**
 * Byte-level interface to control a USCI.
 * <p>The USCI B can be switched to SPI- or I2C-mode. The interface follows
 * the convention of being stateless, thus a higher layer has to maintain
 * state information. I.e. calling <code>tx</done> will transmit a byte of
 * data in the mode (SPI or I2C) the USCI has been set to before.
 *
 * @author Vlado Handziski (handzisk@tkn.tu-berlin.de)
 * @author Jan Hauer (hauer@tkn.tu-berlin.de)
 * @author Joe Polastre
 * @author Xavier Orduna <xorduna@dexmatech.com>
 * @version $Revision$ $Date$
 */

#include "msp430usci.h"

interface HplMsp430UsciB {
  
  /**
   * Sets the USCIBxCTL Control Register 0
   */
  async command void setUctl0(msp430_uctl0_t control);
  
  /**
   * Reads the USCIBxCTL Control Register 0
   */
  async command msp430_uctl0_t getUctl0();
  
  /**
   * Sets the USCIBxCTL Control Register 1
   */
  async command void setUctl1(msp430_uctl1_t control);
  
  /**
   * Reads the USCIBxCTL Control Register 1
   */
  async command msp430_uctl1_t getUctl1();
  
  /**
   * Sets the USCIBxBR0 and USCIBxBR1 Baud Rate Control Registers
   */
  async command void setUbr(uint16_t ubr);
  
  /**
   * Reads the USCIBxBR0 and USCIBxBR1 Baud Rate Control Registers
   */
  async command uint16_t getUbr();
  
  /**
   * Sets the USCIBxMCTL Modulation Control Register
   */
  async command void setUmctl(uint8_t umctl);
  
  /**
   * Reads the USCIBxMCTL Modulation Control Register
   */
  async command uint8_t getUmctl();
  
  /* maybe we have to provide acces to the status register? */
  /**
   * Sets the USCIBxSTAT Status Register
   */
  async command void setUstat(uint8_t ustat);

  /**
   * Reads the USCIBxSTAT Status Register
   */
  async command uint8_t getUstat();


  async command void resetUsci(bool reset);

  
  /**
   * Returns an enum value corresponding to the current mode of the
   * USCIA module.
   */
  async command msp430_uscimode_t getMode();
  
  /**
   * Enables the USCIA when in Spi mode.
   */
  async command void enableSpi();
  
  /**
   * Disables the USCIA when in Spi mode.
   */
  async command void disableSpi();
  
  /**
   * Returns TRUE if the USCI is set to Spi mode
   */
  async command bool isSpi();
  
  /**
   * Switches USCIA to Spi mode.
   */
  async command void setModeSpi(msp430_spi_union_config_t* config);
  
  /* Dis/enabling of UTXIFG / URXIFG */
  async command void disableRxIntr();
  async command void disableTxIntr();
  async command void disableIntr();
  async command void enableRxIntr();
  async command void enableTxIntr();
  async command void enableIntr();
  
  /**
   * TRUE if TX interrupt pending, flag must be cleared explicitly
   */
  async command bool isTxIntrPending();
  
  /**
   * TRUE if RX interrupt pending, flag must be cleared explicitly
   */
  async command bool isRxIntrPending();
  
  /**
   * Clears RX interrupt pending flag
   */
  async command void clrRxIntr();
  
  /**
   * Clears TX interrupt pending flag
   */
  async command void clrTxIntr();

  /**
   * Clears both TX and RX interrupt pending flags
   */
  async command void clrIntr();

  /**
   * Transmit a byte of data. When the transmission is completed,
   * <code>txDone</done> is generated. Only then a new byte may be
   * transmitted, otherwise the previous byte will be overwritten.
   * The mode of transmission (Uart or Spi) depends on the current
   * state of the USCIA, which must be managed by a higher layer.
   *
   * @return SUCCESS always.
   */
  async command void tx(uint8_t data);
  
  /**
   * Get current value from RX-buffer.
   *
   * @return SUCCESS always.
   */
  async command uint8_t rx();

  async command bool isI2C();
  async command void clearModeI2C();
  async command void setModeI2C( msp430_i2c_union_config_t* config );
  
  // U0CTL
  async command void setMasterMode();
  async command void setSlaveMode();
  
  async command void enableI2C();
  async command void disableI2C();
  
  async command bool getTransmitReceiveMode();
  async command void setTransmitMode();
  async command void setReceiveMode();
  
  async command bool getStopBit();
  async command void setStopBit();
  
  async command bool getStartBit();
  async command void setStartBit();
  
  // I2CDR
  //async command uint8_t getData();
  //async command void setData( uint8_t data );
  
  // I2COA
  async command uint16_t getOwnAddress();
  async command void setOwnAddress( uint16_t addr );

  async command void disableGeneralCall();
  async command void enableGeneralCall();
  
  //async command void disableOwnAddress();
  //async command void enableOwnAddress();

  
  // I2CSA
  async command uint16_t getSlaveAddress();
  async command void setSlaveAddress( uint16_t addr );
  
  // UCBxI2CIE
  async command void disableStartDetect();
  async command void enableStartDetect();
  
  async command void disableStopDetect();
  async command void enableStopDetect();
  
  //async command void disableTransmitReady();
  //async command void enableTransmitReady();
  
  //async command void disableReceiveReady();
  //async command void enableReceiveReady();
  
  async command void disableNoAck();
  async command void enableNoAck();
  
  async command void disableArbitrationLost();
  async command void enableArbitrationLost();

}
