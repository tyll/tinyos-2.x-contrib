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

#warning "Using SPI-only Usart0P implementation on USCI0"

#include "msp430usart.h"
/**
 * Implementation of USART0 lowlevel functionality - stateless.
 * Setting a mode will by default disable USART-Interrupts.
 *
 * @author: Jan Hauer <hauer@tkn.tu-berlin.de>
 * @author: Jonathan Hui <jhui@archedrock.com>
 * @author: Vlado Handziski <handzisk@tkn.tu-berlin.de>
 * @author: Joe Polastre
 * @author: Philipp Huppertz <huppertz@tkn.tu-berlin.de>
 * @version $Revision$ $Date$
 */

module HplMsp430Usart0P {
  provides interface HplMsp430Usart as Usart;
  provides interface HplMsp430UsartInterrupts as Interrupts;
  provides interface HplMsp430I2CInterrupts as I2CInterrupts;
  
  //uses interface HplMsp430I2C as HplI2C;
  uses interface HplMsp430GeneralIO as SIMO;
  uses interface HplMsp430GeneralIO as SOMI;
  uses interface HplMsp430GeneralIO as UCLK;
  uses interface HplMsp430GeneralIO as URXD;
  uses interface HplMsp430GeneralIO as UTXD;
}

implementation
{
#define TYPE_UCB0TCTL0 uint8_t
  MSP430REG_NORACE(UCB0TCTL0);
#define TYPE_UCB0TCTL1 uint8_t
  MSP430REG_NORACE(UCB0TCTL1);
#define TYPE_UCB0BR0 uint8_t
  MSP430REG_NORACE(UCB0BR0);
#define TYPE_UCB0BR1 uint8_t
  MSP430REG_NORACE(UCB0BR1);
#define TYPE_UCB0MCTL uint8_t
  MSP430REG_NORACE(UCB0MCTL);
#define TYPE_UCB0STAT uint8_t
  MSP430REG_NORACE(UCB0STAT);
#define TYPE_UCB0RXBUF uint8_t
  MSP430REG_NORACE(UCB0RXBUF);
#define TYPE_UCB0TXBUF uint8_t
  MSP430REG_NORACE(UCB0TXBUF);

  MSP430REG_NORACE(IE2);
  MSP430REG_NORACE(IFG2);
  
  TOSH_SIGNAL(USCI0RX_VECTOR) {
    uint8_t temp = UCB0RXBUF;
    signal Interrupts.rxDone(temp);
  }
  
  TOSH_SIGNAL(USCI0TX_VECTOR) {
#if 0
    if ( call HplI2C.isI2C() )
      signal I2CInterrupts.fired();
    else
#endif
    call Usart.clrTxIntr();
    signal Interrupts.txDone();
  }
  
  async command void Usart.resetUsart(bool reset) {
    if (reset) {
      SET_FLAG(UCB0CTL1, UCSWRST);
    }
    else {
      CLR_FLAG(UCB0CTL1, UCSWRST);
    }
  }

  async command bool Usart.isSpi() {
    atomic {
      //return (U0CTL & SYNC) && (ME1 & USPIE0);
      return (UCB0CTL0 & UCSYNC) != 0;
    }
  }

  async command bool Usart.isUart() {
    return FALSE;
  }

  async command msp430_usartmode_t Usart.getMode() {
    if (call Usart.isUart())
      return USART_UART;
    else if (call Usart.isSpi())
      return USART_SPI;
    else
      return USART_NONE;
  }

  async command void Usart.enableUart() { }
  async command void Usart.disableUart() { }
  async command void Usart.enableUartTx() { }
  async command void Usart.disableUartTx() { }
  async command void Usart.enableUartRx() { }
  async command void Usart.disableUartRx() { }

  async command void Usart.enableSpi() {
    atomic {
      call SIMO.selectModuleFunc();
      call SOMI.selectModuleFunc();
      call UCLK.selectModuleFunc();
    }
    //ME1 |= USPIE0;   // USART0 SPI module enable
  }

  async command void Usart.disableSpi() {
    atomic {
      //ME1 &= ~USPIE0;   // USART0 SPI module disable
      call SIMO.selectIOFunc();
      call SOMI.selectIOFunc();
      call UCLK.selectIOFunc();
    }
  }
  
  void configSpi(msp430_spi_union_config_t* config) {
    //// U0CTL = (config->spiRegisters.uctl & ~I2C) | SYNC | SWRST;
    //U0CTL = (config->spiRegisters.uctl) | SYNC | SWRST;  
    //U0TCTL = config->spiRegisters.utctl;

    //call Usart.setUbr(config->spiRegisters.ubr);
    //call Usart.setUmctl(0x00);

    // MSB first, per Spansion and MotePlatformC -- and F1611 d/s
    // PH=1, PL=0 per default F1611 config -- 1611/2618 fcns are the same
    UCB0CTL0 = UCSYNC | UCMST | UCMSB | UCCKPH;
    UCB0CTL1 = UCSSEL1; // SMCLK
    UCB0BR0  = 2;       // divide by 2, like F1611
    UCB0BR1  = 0;
    UCB0STAT = 0;       // clear UCLISTEN
  }

  async command void Usart.setModeSpi(msp430_spi_union_config_t* config) {
    atomic {
      call Usart.resetUsart(TRUE);
      call Usart.disableIntr();
      call Usart.clrIntr();
      call Usart.disableUart();
      configSpi(config);
      call Usart.enableSpi();
      call Usart.resetUsart(FALSE);
    }    
    return;
  }

  async command void Usart.setModeUart(msp430_uart_union_config_t* config) { }

  async command bool Usart.isTxIntrPending(){
    if (IFG2 & UCB0TXIFG){
      return TRUE;
    }
    return FALSE;
  }

  async command bool Usart.isRxIntrPending(){
    return (IFG2 & UCB0RXIFG) ? TRUE : FALSE;
  }

  async command void Usart.clrTxIntr(){
    CLR_FLAG( IFG2, UCB0TXIFG );
  }

  async command void Usart.clrRxIntr() {
    CLR_FLAG( IFG2, UCB0RXIFG );
  }

  async command void Usart.clrIntr() {
    CLR_FLAG( IFG2, UCB0RXIFG | UCB0TXIFG );
  }

  async command void Usart.disableRxIntr() {
    CLR_FLAG( IE2, UCB0RXIE );
  }

  async command void Usart.disableTxIntr() {
    CLR_FLAG( IE2, UCB0TXIE );
  }

  async command void Usart.disableIntr() {
    CLR_FLAG( IE2, UCB0TXIE | UCB0RXIE );
  }

  async command void Usart.enableRxIntr() {
    atomic {
      CLR_FLAG( IFG2, UCB0RXIFG );
      SET_FLAG( IE2, UCB0RXIE );
    }
  }

  async command void Usart.enableTxIntr() {
    atomic {
      CLR_FLAG( IFG2, UCB0TXIFG );
      SET_FLAG( IE2, UCB0TXIE );
    }
  }

  async command void Usart.enableIntr() {
    atomic {
      CLR_FLAG( IFG2, UCB0TXIFG | UCB0RXIFG );
      SET_FLAG( IE2, UCB0TXIE | UCB0RXIE );
    }
  }

  async command void Usart.tx(uint8_t data) {
    atomic UCB0TXBUF = data;
  }

  async command uint8_t Usart.rx() {
    uint8_t value;
    atomic value = UCB0RXBUF;
    return value;
  }

  default async event void I2CInterrupts.fired() {}
  //default async command bool HplI2C.isI2C() { return FALSE; }
  //default async command void HplI2C.clearModeI2C() {};
}

