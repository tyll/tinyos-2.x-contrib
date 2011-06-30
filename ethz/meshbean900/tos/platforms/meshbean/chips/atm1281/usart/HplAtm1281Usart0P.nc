/*
 * Copyright (c) 2006 Arch Rock Corporation
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
 * - Neither the name of the Arch Rock Corporation nor the names of
 *   its contributors may be used to endorse or promote products derived
 *   from this software without specific prior written permission.
 *
 * THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS
 * ``AS IS'' AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT
 * LIMITED TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS
 * FOR A PARTICULAR PURPOSE ARE DISCLAIMED.  IN NO EVENT SHALL THE
 * ARCH ROCK OR ITS CONTRIBUTORS BE LIABLE FOR ANY DIRECT, INDIRECT,
 * INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES
 * (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR
 * SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION)
 * HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT,
 * STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE)
 * ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED
 * OF THE POSSIBILITY OF SUCH DAMAGE
 */

/**
 * @author Alec Woo <awoo@archrock.com>
 * @author Jonathan Hui <jhui@archrock.com>
 * @author Philipp Sommer <sommer@tik.ee.ethz.ch> (Atmega1281 port)
 */

/*
 * Copyright (c) 2004-2005 Crossbow Technology, Inc.  All rights reserved.
 *
 * Permission to use, copy, modify, and distribute this software and its
 * documentation for any purpose, without fee, and without written agreement is
 * hereby granted, provided that the above copyright notice, the following
 * two paragraphs and the author appear in all copies of this software.
 * 
 * IN NO EVENT SHALL CROSSBOW TECHNOLOGY OR ANY OF ITS LICENSORS BE LIABLE TO 
 * ANY PARTY FOR DIRECT, INDIRECT, SPECIAL, INCIDENTAL, OR CONSEQUENTIAL 
 * DAMAGES ARISING OUT OF THE USE OF THIS SOFTWARE AND ITS DOCUMENTATION, EVEN
 * IF CROSSBOW OR ITS LICENSOR HAS BEEN ADVISED OF THE POSSIBILITY OF SUCH 
 * DAMAGE. 
 *
 * CROSSBOW TECHNOLOGY AND ITS LICENSORS SPECIFICALLY DISCLAIM ALL WARRANTIES,
 * INCLUDING, BUT NOT LIMITED TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY 
 * AND FITNESS FOR A PARTICULAR PURPOSE. THE SOFTWARE PROVIDED HEREUNDER IS 
 * ON AN "AS IS" BASIS, AND NEITHER CROSSBOW NOR ANY LICENSOR HAS ANY 
 * OBLIGATION TO PROVIDE MAINTENANCE, SUPPORT, UPDATES, ENHANCEMENTS, OR 
 * MODIFICATIONS.
 */

/** 
 * Private component of the Atmega128 serial port HPL.
 *
 * @author Martin Turon <mturon@xbow.com>
 * @author David Gay
 */

#include <Atm1281Usart.h>

module HplAtm1281Usart0P {
  
  provides interface HplAtm1281Usart as HplUsart;
  provides interface HplAtm1281UsartInterrupts as UsartInterrupts;

  uses interface GeneralIO as SCK;
  uses interface GeneralIO as MOSI;
  uses interface GeneralIO as MISO;
  uses interface Atm128Calibrate;
  uses interface McuPowerState;
}

implementation {

  async command error_t HplUsart.enableIntr() {
    SET_BIT(UCSR0B, RXCIE0);
    SET_BIT(UCSR0A, TXC0);
    SET_BIT(UCSR0B, TXCIE0);
    return SUCCESS;
  }
  
  async command error_t HplUsart.disableIntr() {
    CLR_BIT(UCSR0B, TXCIE0);
    CLR_BIT(UCSR0B, TXCIE0);
    return SUCCESS;
  }
  
  async command error_t HplUsart.enableTxIntr() {
    SET_BIT(UCSR0A, TXC0);
    SET_BIT(UCSR0B, TXCIE0);
    return SUCCESS;
  }
  
  async command error_t HplUsart.disableTxIntr(){
    CLR_BIT(UCSR0B, TXCIE0);
    return SUCCESS;
  }
  
  async command error_t HplUsart.enableRxIntr(){
    SET_BIT(UCSR0B, RXCIE0);
    return SUCCESS;
  }

  async command error_t HplUsart.disableRxIntr(){
    CLR_BIT(UCSR0B, RXCIE0);
    return SUCCESS;
  }
  
  async command bool HplUsart.isUart(){
    return !(READ_BIT(UCSR0C, UMSEL00) && READ_BIT(UCSR0C, UMSEL01));
  }

  async command void HplUsart.enableUart(){
    CLR_BIT(UCSR0C, UMSEL00);
    CLR_BIT(UCSR0C, UMSEL01);
    SET_BIT(UCSR0B, TXEN0);		// enable tx
    SET_BIT(UCSR0B, RXEN0);		// enable rx
    call McuPowerState.update();
  }

  async command void HplUsart.disableUart(){
    CLR_BIT(UCSR0B, TXEN0);		// disable tx
    CLR_BIT(UCSR0B, RXEN0);		// disable rx
    call McuPowerState.update();
  }
  
  async command void HplUsart.resetUsart(){
    // reset registers to their initial value
    UCSR0B = 0;
    UCSR0A = 0x20;
    UCSR0C = 0x06;
    UBRR0L = 0;
    UBRR0H = 0;
  }
  
  async command void HplUsart.setModeUart(Atm1281UartUnionConfig_t* config) {
    
    atomic {
      
      call HplUsart.resetUsart();
      UBRR0L = config->uartRegisters.UBBRL;
      UBRR0H = config->uartRegisters.UBBRH;
      UCSR0A = config->uartRegisters.UCSRA;
      UCSR0B = config->uartRegisters.UCSRB;
      UCSR0C = config->uartRegisters.UCSRC;
      
    }	
  }
  


  async command void HplUsart.enableSpi(){
    SET_BIT(UCSR0C, UMSEL00);
    SET_BIT(UCSR0C, UMSEL01);
  }

  async command void HplUsart.disableSpi(){}

  async command bool HplUsart.isSpi(){
    return (READ_BIT(UCSR0C, UMSEL00) && READ_BIT(UCSR0C, UMSEL01));
  }
  
  async command void HplUsart.setModeSpi(Atm1281SpiUnionConfig_t* config) {

    atomic {
      call HplUsart.resetUsart();
      call SCK.makeOutput();
      call MOSI.makeOutput();
      call MISO.makeInput();
      UCSR0A = config->uartRegisters.UCSRA;
      UCSR0B = config->uartRegisters.UCSRB;
      UCSR0C = config->uartRegisters.UCSRC;
      // Important: baud rate must be set after the transmitter
      // is enabled, see Atmega1281 datasheet page 234
      UBRR0L = config->uartRegisters.UBBRL;
      UBRR0H = config->uartRegisters.UBBRH;
      
    }
  }
  
  async command bool HplUsart.isTxEmpty() {
    return READ_BIT(UCSR0A, TXC0);
  }

  async command bool HplUsart.isRxEmpty(){
    return !READ_BIT(UCSR0A, RXC0);
  }
  
  async command uint8_t HplUsart.rx(){
    return UDR0;
  }

  async command void HplUsart.tx(uint8_t data) {
    atomic{
      UDR0 = data; 
      SET_BIT(UCSR0A, TXC0);
    }
  }

  async command bool HplUsart.isTxIntrPending() {
    return READ_BIT(UCSR0A, TXC0);
  }

  async command bool HplUsart.isRxIntrPending() {
    return READ_BIT(UCSR0A, RXC0);
  }

  async command void HplUsart.clrRxIntr() {
    CLR_BIT(UCSR0A, RXC0);
  }

  async command void HplUsart.clrTxIntr() {
    CLR_BIT(UCSR0A, TXC0);
  }
  
  async command void HplUsart.clrIntr() {
    CLR_BIT(UCSR0A, RXC0);
    CLR_BIT(UCSR0A, TXC0);
  }

  
  AVR_ATOMIC_HANDLER(SIG_USART0_RECV) {
    if (READ_BIT(UCSR0A, RXC0)) {
      signal UsartInterrupts.rxDone(UDR0);
    }
  }
  
  AVR_NONATOMIC_HANDLER(SIG_USART0_TRANS) {
    signal UsartInterrupts.txDone();
  }
  
  default async event void UsartInterrupts.rxDone(uint8_t data) {}
  default async event void UsartInterrupts.txDone() {}
  
}
