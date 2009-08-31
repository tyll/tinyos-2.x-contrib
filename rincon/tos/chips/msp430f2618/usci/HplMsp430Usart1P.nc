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

#warning "Using UART-only Usart1P implementation on USCI1"

#include "msp430usart.h"
/**
 * Implementation of USART1 lowlevel functionality - stateless.
 * Setting a mode will by default disable USART-Interrupts.
 *
 * @author: Jan Hauer <hauer@tkn.tu-berlin.de>
 * @author: Jonathan Hui <jhui@archedrock.com>
 * @author: Vlado Handziski <handzisk@tkn.tu-berlin.de>
 * @author: Joe Polastre
 * @version $Revision$ $Date$
 */

module HplMsp430Usart1P {
  provides interface AsyncStdControl;
  provides interface HplMsp430Usart as Usart;
  provides interface HplMsp430UsartInterrupts as Interrupts;

  uses interface HplMsp430GeneralIO as SIMO;
  uses interface HplMsp430GeneralIO as SOMI;
  uses interface HplMsp430GeneralIO as UCLK;
  uses interface HplMsp430GeneralIO as URXD;
  uses interface HplMsp430GeneralIO as UTXD;
}

implementation
{
#define TYPE_UCA1TCTL0 uint8_t
  MSP430REG_NORACE(UCA1TCTL0);
#define TYPE_UCA1TCTL1 uint8_t
  MSP430REG_NORACE(UCA1TCTL1);
#define TYPE_UCA1BR0 uint8_t
  MSP430REG_NORACE(UCA1BR0);
#define TYPE_UCA1BR1 uint8_t
  MSP430REG_NORACE(UCA1BR1);
#define TYPE_UCA1MCTL uint8_t
  MSP430REG_NORACE(UCA1MCTL);
#define TYPE_UCA1STAT uint8_t
  MSP430REG_NORACE(UCA1STAT);
#define TYPE_UCA1RXBUF uint8_t
  MSP430REG_NORACE(UCA1RXBUF);
#define TYPE_UCA1TXBUF uint8_t
  MSP430REG_NORACE(UCA1TXBUF);
#define TYPE_UCA1ABCTL uint8_t
  MSP430REG_NORACE(UCA1ABCTL);
#define TYPE_UCA1IRTCTL uint8_t
  MSP430REG_NORACE(UCA1IRTCTL);
#define TYPE_UCA1IRRCTL uint8_t
  MSP430REG_NORACE(UCA1IRRCTL);

// USCI1 IE and IFG aren't in IE2 and IFG2
#define TYPE_UC1IE uint8_t
  MSP430REG_NORACE(UC1IE);
#define TYPE_UC1IFG uint8_t
  MSP430REG_NORACE(UC1IFG);

  TOSH_SIGNAL(USCI1RX_VECTOR) {
    uint8_t temp = UCA1RXBUF;
    signal Interrupts.rxDone(temp);
  }

  TOSH_SIGNAL(USCI1TX_VECTOR) {
    call Usart.clrTxIntr();
    signal Interrupts.txDone();
  }

  async command error_t AsyncStdControl.start() {
    return SUCCESS;
  }

  async command error_t AsyncStdControl.stop() {
    //call Usart.disableSpi();
    call Usart.disableUart();
    return SUCCESS;
  }

  async command void Usart.resetUsart(bool reset) {
    if (reset)
      SET_FLAG(UCA1CTL1, UCSWRST);
    else
      CLR_FLAG(UCA1CTL1, UCSWRST);
  }

  async command bool Usart.isSpi() {
    return FALSE;
  }

  async command bool Usart.isUart() {
    atomic {
      return !(UCA1CTL0 & UCSYNC);
    }
  }

  async command msp430_usartmode_t Usart.getMode() {
    if (call Usart.isUart())
      return USART_UART;
    else if (call Usart.isSpi())
      return USART_SPI;
    else
      return USART_NONE;
  }

  async command void Usart.enableUart() {
    atomic{
      call UTXD.selectModuleFunc();
      call URXD.selectModuleFunc();
    }
    //ME2 |= (UTXE1 | URXE1);   // USART1 UART module enable
  }

  async command void Usart.disableUart() {
    atomic {
      //ME2 &= ~(UTXE1 | URXE1);   // USART1 UART module enable
      call UTXD.selectIOFunc();
      call URXD.selectIOFunc();
    }
  }

  async command void Usart.enableUartTx() {
    call UTXD.selectModuleFunc();
    //ME2 |= UTXE1;   // USART1 UART Tx module enable
  }

  async command void Usart.disableUartTx() {
    //ME2 &= ~UTXE1;   // USART1 UART Tx module enable
    call UTXD.selectIOFunc();
  }

  async command void Usart.enableUartRx() {
    call URXD.selectModuleFunc();
    //ME2 |= URXE1;   // USART1 UART Rx module enable
  }

  async command void Usart.disableUartRx() {
    //ME2 &= ~URXE1;  // USART1 UART Rx module disable
    call URXD.selectIOFunc();

  }

  async command void Usart.enableSpi() { }
  async command void Usart.disableSpi() { }
  async command void Usart.setModeSpi(msp430_spi_union_config_t* config) { }

  void configUart(msp430_uart_union_config_t* config) {

    //U1CTL = (config->uartRegisters.uctl & ~SYNC) | SWRST;
    //U1TCTL = config->uartRegisters.utctl;
    //U1RCTL = config->uartRegisters.urctl;        
    
    //call Usart.setUbr(config->uartRegisters.ubr);
    //call Usart.setUmctl(config->uartRegisters.umctl);

    // Do it by hand for now...
    UCA1STAT   = 0;       // clear UCLISTEN
    UCA1ABCTL  = 0;       // no auto-baud
    UCA1IRTCTL = 0;       // disable IrDA
    UCA1IRRCTL = 0;
    UCA1CTL0   = 0;       // LSB first

#if 0
    //XXX figure out what our DCO is running at!
#warning "Clocking USCI1 from SMCLK @ 115200bps, LSB first"
    UCA1CTL1   = UCSSEL1;         // SMCLK
    UCA1MCTL   = UCBRS0; // modulation 115.2kbps @ 1 MHz
    UCA1BR0    = 9;
    UCA1BR1    = 0;
#elif CUTLASS
#warning "Clocking USCI1 from ACLK @ 9600bps, LSB first"
    UCA1CTL1   = UCSSEL0; // ACLK
    UCA1MCTL   = UCBRS1 | UCBRS0;
    UCA1BR0    = 3;
    UCA1BR1    = 0;
#elif 1
#warning "Clocking USCI1 from 1 MHz SMCLK @ 19200bps, LSB first"
    UCA1CTL1   = UCSSEL1; // SMCLK
    UCA1MCTL   = UCBRS2 | UCBRS0;
    UCA1BR0    = 54;
    UCA1BR1    = 0;
#else
#warning "Clocking USCI1 from ACLK @ 2400bps, LSB first"
    UCA1CTL1   = UCSSEL0; // ACLK
    UCA1MCTL   = UCBRS2 | UCBRS1;
    UCA1BR0    = 13;
    UCA1BR1    = 0;
#endif
  }

  async command void Usart.setModeUart(msp430_uart_union_config_t* config) {
    atomic { 
      call Usart.resetUsart(TRUE);
      //call Usart.disableSpi();
      configUart(config);
      if ((config->uartConfig.utxe == 1) && (config->uartConfig.urxe == 1)) {
      	call Usart.enableUart();
      } else if ((config->uartConfig.utxe == 0) && (config->uartConfig.urxe == 1)) {
        call Usart.disableUartTx();
        call Usart.enableUartRx();
      } else if ((config->uartConfig.utxe == 1) && (config->uartConfig.urxe == 0)){
        call Usart.disableUartRx();
        call Usart.enableUartTx();
      } else {
        call Usart.disableUart();
      }
      call Usart.resetUsart(FALSE);
      call Usart.clrIntr();
      call Usart.disableIntr();
    }
    
    return;
  }

  async command bool Usart.isTxIntrPending(){
    return (UC1IFG & UCA1TXIFG) ? TRUE : FALSE;
  }

  async command bool Usart.isRxIntrPending(){
    return (UC1IFG & UCA1RXIFG) ? TRUE : FALSE;
  }

  async command void Usart.clrTxIntr(){
    UC1IFG &= ~UCA1TXIFG;
  }

  async command void Usart.clrRxIntr() {
    UC1IFG &= ~UCA1RXIFG;
  }

  async command void Usart.clrIntr() {
    UC1IFG &= ~(UCA1TXIFG | UCA1RXIFG);
  }

  async command void Usart.disableRxIntr() {
    UC1IE &= ~UCA1RXIE;
  }

  async command void Usart.disableTxIntr() {
    UC1IE &= ~UCA1TXIE;
  }

  async command void Usart.disableIntr() {
    UC1IE &= ~(UCA1TXIE | UCA1RXIE);
  }

  async command void Usart.enableRxIntr() {
    atomic {
      UC1IFG &= ~UCA1RXIFG;
      UC1IE  |=  UCA1RXIE;
    }
  }

  async command void Usart.enableTxIntr() {
    atomic {
      UC1IFG &= ~UCA1TXIFG;
      UC1IE  |=  UCA1TXIE;
    }
  }

  async command void Usart.enableIntr() {
    atomic {
      UC1IFG &= ~(UCA1TXIFG | UCA1RXIFG);
      UC1IE  |=  (UCA1TXIE  | UCA1RXIE);
    }
  }

  async command void Usart.tx(uint8_t data) {
    atomic {
      UCA1TXBUF = data;
    }
  }

  async command uint8_t Usart.rx() {
    uint8_t value;
    atomic value = UCA1RXBUF;
    return value;
  }
}

