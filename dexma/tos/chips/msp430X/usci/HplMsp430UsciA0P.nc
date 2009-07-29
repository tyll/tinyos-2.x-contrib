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

/**
 * Copyright (c) 2005-2006 Arched Rock Corporation
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
 * - Neither the name of the Arched Rock Corporation nor the names of
 *   its contributors may be used to endorse or promote products derived
 *   from this software without specific prior written permission.
 *
 * THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS
 * ``AS IS'' AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT
 * LIMITED TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS
 * FOR A PARTICULAR PURPOSE ARE DISCLAIMED.  IN NO EVENT SHALL THE
 * ARCHED ROCK OR ITS CONTRIBUTORS BE LIABLE FOR ANY DIRECT, INDIRECT,
 * INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES
 * (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR
 * SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION)
 * HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT,
 * STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE)
 * ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED
 * OF THE POSSIBILITY OF SUCH DAMAGE
 */

/**
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

#include "msp430usci.h"
/**
 * Implementation of USCIA0 lowlevel functionality - stateless.
 * Setting a mode will by default disable USCI-Interrupts.
 *
 * @author: Jan Hauer <hauer@tkn.tu-berlin.de>
 * @author: Jonathan Hui <jhui@archedrock.com>
 * @author: Vlado Handziski <handzisk@tkn.tu-berlin.de>
 * @author: Joe Polastre
 * @author: Philipp Huppertz <huppertz@tkn.tu-berlin.de>
 * @author: Xavier Orduna <xorduna@dexmatech.com>
 * @version $Revision$ $Date$
 */

module HplMsp430UsciA0P @safe() {
  provides interface HplMsp430UsciA as Usci;
  provides interface HplMsp430UsciInterrupts as Interrupts;
  
  uses interface HplMsp430GeneralIO as SIMO;
  uses interface HplMsp430GeneralIO as SOMI;
  uses interface HplMsp430GeneralIO as UCLK;
  uses interface HplMsp430GeneralIO as URXD;
  uses interface HplMsp430GeneralIO as UTXD;  
  
  uses interface HplMsp430UsciRawInterrupts as UsciRawInterrupts;
  
}
implementation
{
  MSP430REG_NORACE(IE2);
  MSP430REG_NORACE(IFG2);
  MSP430REG_NORACE(UCA0CTL0);
  MSP430REG_NORACE(UCA0CTL1);
  MSP430REG_NORACE(UCA0TXBUF);
  
  async event void UsciRawInterrupts.rxDone(uint8_t temp) {
    signal Interrupts.rxDone(temp);
  }

  async event void UsciRawInterrupts.txDone() {
    signal Interrupts.txDone();
  }
  

  /* Control registers */
  async command void Usci.setUctl0(msp430_uctl0_t control) {
    UCA0CTL0=uctl02int(control);
  }

  async command msp430_uctl0_t Usci.getUctl0() {
    return int2uctl0(UCA0CTL0);
  }

  async command void Usci.setUctl1(msp430_uctl1_t control) {
    UCA0CTL1=uctl12int(control);
  }

  async command msp430_uctl1_t Usci.getUctl1() {
    return int2uctl1(UCA0CTL0);
  }

  async command void Usci.setUbr(uint16_t control) {
    atomic {
      UCA0BR0 = control & 0x00FF;
      UCA0BR1 = (control >> 8) & 0x00FF;
    }
  }

  async command uint16_t Usci.getUbr() {
    return (UCA0BR1 << 8) + UCA0BR0;
  }

  async command void Usci.setUmctl(uint8_t control) {
    UCA0MCTL=control;
  }

  async command uint8_t Usci.getUmctl() {
    return UCA0MCTL;
  }

  async command void Usci.setUstat(uint8_t control) {
    UCA0STAT=control;
  }

  async command uint8_t Usci.getUstat() {
    return UCA0STAT;
  }

  /* Operations */
  async command void Usci.resetUsci(bool reset) {
    if (reset) {
      UCA0CTL1 |= UCSWRST;
    }
    else {
      CLR_FLAG(UCA0CTL1, UCSWRST);
    }
  }

  async command bool Usci.isSpi() {
    atomic {
      return (UCA0CTL0 & UCMST & UCSYNC & UCCKPL & UCMSB);
    }
  }

  async command msp430_uscimode_t Usci.getMode() {
    if (call Usci.isSpi())
      return USCI_SPI;
    else
      return USCI_NONE;
  }

  async command void Usci.enableSpi() {
    atomic {
      call SIMO.selectModuleFunc(); 
      call SOMI.selectModuleFunc();
      call UCLK.selectModuleFunc();
    }
  }

  async command void Usci.disableSpi() {
    atomic {
      call SIMO.selectIOFunc();
      call SOMI.selectIOFunc();
      call UCLK.selectIOFunc();
    }
  }
  
  void configSpi(msp430_spi_union_config_t* config) {
    UCA0CTL0 |= UCMST+UCSYNC+UCCKPL+UCMSB;    //3-pin, 8-bit SPI master
    UCA0CTL1 |= UCSSEL_2+UCSWRST;                     // SMCLK   
    call Usci.setUbr(config->spiRegisters.ubr);
    call Usci.setUmctl(0x00);
  }

  async command void Usci.setModeSpi(msp430_spi_union_config_t* config) {
    atomic {
      call Usci.resetUsci(TRUE);
      configSpi(config);
      call Usci.enableSpi();
      call Usci.resetUsci(FALSE);
      call Usci.clrIntr();
      call Usci.disableIntr();
    }    
    return;
  }


  async command bool Usci.isTxIntrPending(){
    if (IFG2 & UCA0TXIFG){
    //if (UC1IFG & UCA0TXIFG){
      return TRUE;
    }
    return FALSE;
  }

  async command bool Usci.isRxIntrPending(){
    if (IFG2 & UCA0RXIFG){
    //if (UC1IFG & UCA1RXIFG){
      return TRUE;
    }
    return FALSE;
  }

  async command void Usci.clrTxIntr(){
    IFG2 &= ~UCA0TXIFG;
    //UC1IFG &= ~UCBA1TXIFG;
  }

  async command void Usci.clrRxIntr() {
    IFG2 &= ~UCA0RXIFG;
    //UC1IFG &= ~UCA1RXIFG;
  }

  async command void Usci.clrIntr() {
    IFG2 &= ~(UCA0TXIFG | UCA0RXIFG);
    //UC1IFG &= ~(UCA1TXIFG | UCA1RXIFG);
  }

  async command void Usci.disableRxIntr() {
    IE2 &= ~UCA0RXIE;
    //UC1IE &= ~UCA1RXIE;
  }

  async command void Usci.disableTxIntr() {
    IE2 &= ~UCA0TXIE;
    //UC1IE &= ~UCA1TXIE
  }

  async command void Usci.disableIntr() {
      IE2 &= ~(UCA0TXIE | UCA0RXIE);
      //UC1IE &= ~(UCA1TXIE | UCA1RXIE);
  }

  async command void Usci.enableRxIntr() {
    atomic {
      IFG2 &= ~UCA0RXIFG;
      IE2 |= UCA0RXIE;
      //UC1IFG &= ~UCA1RXIFG;
      //UC1IE |= UCA1RXIE;
    }
  }

  async command void Usci.enableTxIntr() {
    atomic {
      IFG2 &= ~UCA0TXIFG;
      IE2 |= UCA0TXIE;
      //UC1IFG &= ~UCA1TXIFG;
      //UC1IE |= UCA1TXIE;
      
    }
  }

  async command void Usci.enableIntr() {
    atomic {
      IFG2 &= ~(UCA0TXIFG | UCA0RXIFG);
      IE2 |= (UCA0TXIE | UCA0RXIE);
      //UC1IFG &= ~(UCA1TXIFG | UCA1RXIFG);
      //UC1IE |= (UCA1TXIE | UCA1RXIE);
    }
  }

  async command void Usci.tx(uint8_t data) {
    atomic UCA0TXBUF = data;
    //atomic UCA1TXBUF = data;
  }

  async command uint8_t Usci.rx() {
    uint8_t value;
    atomic value = UCA0RXBUF;
    //atomic value = UCA1RXBUF;
    return value;
  }

  async command bool Usci.isUart() {
    atomic {
      return (UCA0CTL0 & ~UCMODE0 & ~UCMODE1 & ~UCSYNC);
    }
  }

  async command void Usci.enableUart() {
    atomic{
      call UTXD.selectModuleFunc();
      call URXD.selectModuleFunc();
    }
  }

  async command void Usci.disableUart() {
    atomic {
      call UTXD.selectIOFunc();
      call URXD.selectIOFunc();
    }
  }

  void configUart(msp430_uart_union_config_t* config) {
	//spi
    //UCA0CTL0 |= UCMST+UCSYNC+UCCKPL+UCMSB;    //3-pin, 8-bit SPI master
    //UCA0CTL1 |= UCSSEL_2+UCSWRST;                     // SMCLK   


    //UCA0CTL1 |= UCSSEL_2 + UCRXEIE + UCSWRST;
    //UCA0CTL0 = 0;
    UCA0CTL1 |= UCSSEL_2;

    //UCA0CTL0 = (config->uartRegisters.uctl & ~SYNC) | SWRST;
    //UCA0CTL1 = 
   
    call Usci.setUbr(config->uartRegisters.ubr);
    call Usci.setUmctl(config->uartRegisters.umctl);
  }

  async command void Usci.setModeUart(msp430_uart_union_config_t* config) {

    atomic { 
      call Usci.resetUsci(TRUE);
      configUart(config);
      call Usci.enableUart();
      call Usci.resetUsci(FALSE);
      call Usci.clrIntr();
      call Usci.disableIntr();
    }
    
    return;
  }


 
}
