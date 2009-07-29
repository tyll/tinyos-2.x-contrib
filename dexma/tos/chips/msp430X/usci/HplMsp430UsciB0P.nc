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
 * Implementation of USCIB0 lowlevel functionality - stateless.
 * Setting a mode will by default disable USCIB0-Interrupts.
 *
 * @author: Jan Hauer <hauer@tkn.tu-berlin.de>
 * @author: Jonathan Hui <jhui@archedrock.com>
 * @author: Vlado Handziski <handzisk@tkn.tu-berlin.de>
 * @author: Joe Polastre
 * @author: Philipp Huppertz <huppertz@tkn.tu-berlin.de>
 * @author: Xavier Orduna <xorduna@dexmatech.com>
 * @version $Revision$ $Date$
 */

module HplMsp430UsciB0P @safe() {
  provides interface HplMsp430UsciB as Usci;
  provides interface HplMsp430UsciInterrupts as Interrupts;
  
  uses interface HplMsp430GeneralIO as SIMO;
  uses interface HplMsp430GeneralIO as SOMI;
  uses interface HplMsp430GeneralIO as UCLK;
  uses interface HplMsp430UsciRawInterrupts as UsciRawInterrupts;
}

implementation
{
  MSP430REG_NORACE(IE2);
  MSP430REG_NORACE(IFG2);
  MSP430REG_NORACE(UCB0CTL0);
  MSP430REG_NORACE(UCB0CTL1);
  MSP430REG_NORACE(UCB0TXBUF);
  
  async event void UsciRawInterrupts.rxDone(uint8_t temp) {
    signal Interrupts.rxDone(temp);
  }

  async event void UsciRawInterrupts.txDone() {
    signal Interrupts.txDone();
  }
  
  /* Control registers */
  async command void Usci.setUctl0(msp430_uctl0_t control) {
    UCB0CTL0=uctl02int(control);
  }

  async command msp430_uctl0_t Usci.getUctl0() {
    return int2uctl0(UCB0CTL0);
  }

  async command void Usci.setUctl1(msp430_uctl1_t control) {
    UCB0CTL1=uctl12int(control);
  }

  async command msp430_uctl1_t Usci.getUctl1() {
    return int2uctl1(UCB0CTL0);
  }

  async command void Usci.setUbr(uint16_t control) {
    atomic {
      UCB0BR0 = control & 0x00FF;
      UCB0BR1 = (control >> 8) & 0x00FF;
    }
  }

  async command uint16_t Usci.getUbr() {
    return (UCB0BR1 << 8) + UCB0BR0;
  }

  async command void Usci.setUmctl(uint8_t control) {
    //UCB0MCTL=control;
  }

  async command uint8_t Usci.getUmctl() {
    //return UCB0MCTL;
  }

  async command void Usci.setUstat(uint8_t control) {
    UCB0STAT=control;
  }

  async command uint8_t Usci.getUstat() {
    return UCB0STAT;
  }

  /* Operations */
  async command void Usci.resetUsci(bool reset) {
    if (reset) {
      UCB0CTL1 |= UCSWRST;
    }
    else {
      CLR_FLAG(UCB0CTL1, UCSWRST);
    }
  }

  async command bool Usci.isSpi() {
    atomic {
      return (UCB0CTL0 & UCMST & UCSYNC & UCCKPL & UCMSB);
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
    UCB0CTL0 |= UCMST+UCSYNC+UCCKPL+UCMSB;    //3-pin, 8-bit SPI master
    UCB0CTL1 |= UCSSEL_2+UCSWRST;                     // SMCLK   
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
    if (IFG2 & UCB0TXIFG){
      return TRUE;
    }
    return FALSE;
  }

  async command bool Usci.isRxIntrPending(){
    if (IFG2 & UCB0RXIFG){
      return TRUE;
    }
    return FALSE;
  }

  async command void Usci.clrTxIntr(){
    IFG2 &= ~UCB0TXIFG;
  }

  async command void Usci.clrRxIntr() {
    IFG2 &= ~UCB0RXIFG;
  }

  async command void Usci.clrIntr() {
    IFG2 &= ~(UCB0TXIFG | UCB0RXIFG);
  }

  async command void Usci.disableRxIntr() {
    IE2 &= ~UCB0RXIE;
  }

  async command void Usci.disableTxIntr() {
    IE2 &= ~UCB0TXIE;
  }

  async command void Usci.disableIntr() {
      IE2 &= ~(UCB0TXIE | UCB0RXIE);
  }

  async command void Usci.enableRxIntr() {
    atomic {
      IFG2 &= ~UCB0RXIFG;
      IE2 |= UCB0RXIE;
    }
  }

  async command void Usci.enableTxIntr() {
    atomic {
      IFG2 &= ~UCB0TXIFG;
      IE2 |= UCB0TXIE;
    }
  }

  async command void Usci.enableIntr() {
    atomic {
      IFG2 &= ~(UCB0TXIFG | UCB0RXIFG);
      IE2 |= (UCB0TXIE | UCB0RXIE);
    }
  }

  async command void Usci.tx(uint8_t data) {
    atomic UCB0TXBUF = data;
  }

  async command uint8_t Usci.rx() {
    uint8_t value;
    atomic value = UCB0RXBUF;
    return value;
  }


// I2c opperations
  async command bool Usci.isI2C(){
    atomic {
      return (UCB0CTL0 & UCMODE_2 & UCSYNC);
    }  
  }
  
  async command void Usci.clearModeI2C(){
  
  }
  
  void configI2C(msp430_i2c_union_config_t* config) {
    UCB0CTL0 |= UCSYNC+UCMODE_2;    //i2c mode synchronous
    UCB0CTL1 |= UCSSEL_2+UCSWRST;                     // SMCLK   
    //call Usci.setUbr(config->i2cRegisters.ubr);
    call Usci.setUmctl(0x00);
  }
    
  async command void Usci.setModeI2C( msp430_i2c_union_config_t* config ){
    atomic {
      call Usci.resetUsci(TRUE);
      configI2C(config);
      call Usci.enableSpi();
      call Usci.resetUsci(FALSE);
      call Usci.clrIntr();
      call Usci.disableIntr();
    }    
    return;
  }
  
  // U0CTL
  async command void Usci.setMasterMode(){
  	UCB0CTL0 |= UCMST;
  }
  
  async command void Usci.setSlaveMode(){
    UCB0CTL0 &= ~UCMST;
  }
  
  async command void Usci.enableI2C(){
    atomic {
      call SIMO.selectModuleFunc(); 
      call SOMI.selectModuleFunc();
      call UCLK.selectModuleFunc();
    }  
  }
  
  async command void Usci.disableI2C(){
    atomic {
      call SIMO.selectIOFunc();
      call SOMI.selectIOFunc();
      call UCLK.selectIOFunc();
    }  
  }
  
  async command bool Usci.getTransmitReceiveMode(){
    atomic {
      return (UCB0CTL1 & UCTR);
    }   
  }
  
  async command void Usci.setTransmitMode(){
  	UCB0CTL1 |= UCTR;
  }
  
  async command void Usci.setReceiveMode(){
  	UCB0CTL1 &= ~UCTR;
  }
  
  async command bool Usci.getStopBit(){
  	atomic return (UCB0CTL1 & UCTXSTP);
  }
  
  async command void Usci.setStopBit(){
    UCB0CTL1 |= UCTXSTP;
  }
  
  async command bool Usci.getStartBit(){
  	atomic return (UCB0CTL1 & UCTXSTT);
  }
  
  async command void Usci.setStartBit(){
  	UCB0CTL1 &= ~UCTXSTT;
  }
  
  // I2COA
  async command uint16_t Usci.getOwnAddress(){
  	return 0;
  }
  
  async command void Usci.setOwnAddress( uint16_t addr ){
  	return;
  }

  async command void Usci.disableGeneralCall(){
  	UCB0I2COA &= ~UCGCEN;
  }
  
  async command void Usci.enableGeneralCall(){
  	UCB0I2COA |= UCGCEN;
  }
  
  //no register found
  //async command void disableOwnAddress();
  //async command void enableOwnAddress();

  
  // I2CSA
  async command uint16_t Usci.getSlaveAddress(){
  	return UCB0I2CSA; 
  }
  
  async command void Usci.setSlaveAddress( uint16_t addr ){
  	UCB0I2CSA = addr;
  }
  
  // UCBxI2CIE
  async command void Usci.disableStartDetect(){
  	UCB0I2CIE &= ~UCSTTIE;
  }
  
  async command void Usci.enableStartDetect(){
    UCB0I2CIE |= UCSTTIE;
  }
  
  async command void Usci.disableStopDetect(){
  	UCB0I2CIE &= ~UCSTPIE;
  }
  
  async command void Usci.enableStopDetect(){
    UCB0I2CIE |= UCSTPIE;
  }
  
  async command void Usci.disableNoAck(){
  	UCB0I2CIE &= ~UCNACKIE;
  }
  
  async command void Usci.enableNoAck(){
    UCB0I2CIE |= UCNACKIE;
  }
  
  async command void Usci.disableArbitrationLost(){
  	UCB0I2CIE &= ~UCALIE;
  }
  
  async command void Usci.enableArbitrationLost(){
    UCB0I2CIE |= UCALIE;
  }

 

 
}
