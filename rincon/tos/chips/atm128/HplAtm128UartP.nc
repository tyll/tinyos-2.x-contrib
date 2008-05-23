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
 * @version $Revision$ $Date$
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

#warning "Including USART fixes..."

#include <Atm128Uart.h>

module HplAtm128UartP {
  
  provides interface Init as Uart0Init;
  provides interface StdControl as Uart0TxControl;
  provides interface StdControl as Uart0RxControl;
  provides interface HplAtm128Uart as HplUart0;
  provides interface HplAtm128UartConfig as HplUart0Config;
    
  provides interface Init as Uart1Init;
  provides interface StdControl as Uart1TxControl;
  provides interface StdControl as Uart1RxControl;
  provides interface HplAtm128Uart as HplUart1;
  provides interface HplAtm128UartConfig as HplUart1Config;
  
  uses interface Atm128Calibrate;
  uses interface McuPowerState;
}
implementation {

  //=== Uart Init Commands. ====================================
  command error_t Uart0Init.init() {
    Atm128UartMode_t    mode;
    Atm128UartStatus_t  stts;
    Atm128UartControl_t ctrl;
    uint16_t ubrr0;

    ctrl.bits = (struct Atm128_UCSRB_t) {rxcie:0, txcie:0, rxen:0, txen:0};
    stts.bits = (struct Atm128_UCSRA_t) {u2x:1};
    mode.bits = (struct Atm128_UCSRC_t) {ucsz:ATM128_UART_DATA_SIZE_8_BITS};

    ubrr0 = call Atm128Calibrate.baudrateRegister(PLATFORM_BAUDRATE);
    UBRR0L = ubrr0;
    UBRR0H = ubrr0 >> 8;
    UCSR0A = stts.flat;
    UCSR0C = mode.flat;
    UCSR0B = ctrl.flat;

    return SUCCESS;
  }

  command error_t Uart0TxControl.start() {
    CLR_BIT(UCSR0B, TXCIE);
    SET_BIT(UCSR0B, TXEN);
    call McuPowerState.update();
    return SUCCESS;
  }

  command error_t Uart0TxControl.stop() {
    CLR_BIT(UCSR0B, TXCIE);
    CLR_BIT(UCSR0B, TXEN);
    call McuPowerState.update();
    return SUCCESS;
  }

  command error_t Uart0RxControl.start() {
    CLR_BIT(UCSR0B, RXCIE);
    SET_BIT(UCSR0B, RXEN);
    call McuPowerState.update();
    return SUCCESS;
  }

  command error_t Uart0RxControl.stop() {
    CLR_BIT(UCSR0B, RXCIE);
    CLR_BIT(UCSR0B, RXEN);
    call McuPowerState.update();
    return SUCCESS;
  }
  
  async command error_t HplUart0.enableTxIntr() {
    SET_BIT(UCSR0B, TXCIE);
    return SUCCESS;
  }
  
  async command error_t HplUart0.disableTxIntr(){
    CLR_BIT(UCSR0B, TXCIE);
    return SUCCESS;
  }
  
  async command error_t HplUart0.enableRxIntr(){
    SET_BIT(UCSR0B, RXCIE);
    return SUCCESS;
  }

  async command error_t HplUart0.disableRxIntr(){
    CLR_BIT(UCSR0B, RXCIE);
    return SUCCESS;
  }
  
  async command bool HplUart0.isTxEmpty(){
    return READ_BIT(UCSR0A, TXC);
  }

  async command bool HplUart0.isRxEmpty(){
    return !READ_BIT(UCSR0A, RXC);
  }
  
  async command uint8_t HplUart0.rx(){
    return UDR0;
  }

  async command void HplUart0.tx(uint8_t data) {
    atomic{
      UDR0 = data; 
      SET_BIT(UCSR0A, TXC);
    }
  }
  
  AVR_ATOMIC_HANDLER(SIG_UART0_RECV) {
    if (READ_BIT(UCSR0A, RXC)) {
      signal HplUart0.rxDone(UDR0);
    }
  }
  
  AVR_NONATOMIC_HANDLER(SIG_UART0_TRANS) {
    signal HplUart0.txDone();
  }
  
  /***************************************
   * configuration
   */
  async command void HplUart0Config.getConfig(atm128_uart_config_t *cfg) {
    atomic {
      uint16_t ubrr = (((uint16_t) UBRR0H) << 8) | ((uint16_t) UBRR0L);
      uint32_t tmp;
      uint8_t  u2x = READ_BIT(UCSR0A, U2X);

      if (!u2x)
	// make it look like double speed...
	// XXX possible roundoff
	ubrr = ((ubrr + 1) << 1) - 1;
      tmp   = ((uint32_t) ubrr) + 1UL;
      tmp  *= 100UL;
      ubrr  = call Atm128Calibrate.baudrateRegister(tmp);
      ubrr += 1;

      cfg->br   = ubrr;
      cfg->u2x  = u2x;
      cfg->ucsz = (READ_BIT(UCSR0C, UCSZ1) << 1) | READ_BIT(UCSR0C, UCSZ0);
      cfg->upar = (READ_BIT(UCSR0C, UPM1) << 1) | READ_BIT(UCSR0C, UPM0);
      cfg->usb  = READ_BIT(UCSR0C, USBS);
    }
  }

  async command void HplUart0Config.setConfig(atm128_uart_config_t *cfg) {
    uint32_t tmp;
    uint16_t ubrr;
    uint8_t  rx, tx, u2x;

    atomic {
      // save interrupt state, disable interrupts
      tx = READ_BIT(UCSR0B, TXCIE);
      rx = READ_BIT(UCSR0B, RXCIE);
      CLR_BIT(UCSR0B, TXCIE);
      CLR_BIT(UCSR0B, RXCIE);

      // let tx and rx flush
      if (READ_BIT(UCSR0B, TXEN)) {
	while (!READ_BIT(UCSR0A, UDRE))
	  ;
      }
      if (READ_BIT(UCSR0B, RXEN)) {
	uint8_t dummy;
	while (READ_BIT(UCSR0A, RXC))
	  dummy = UDR0;
      }

      // get real baudrate -> reg value, correct for u2x
      tmp   = (uint32_t) cfg->br;
      tmp  *= 100UL;
      ubrr  = call Atm128Calibrate.baudrateRegister(tmp);
      if (!(u2x = cfg->u2x))
	ubrr = ((ubrr + 1) >> 1) - 1;

      // program everything up
      UBRR0H = ubrr >> 8;
      UBRR0L = ubrr & 0xff;
      UCSR0A = (UCSR0A & ~(1 << U2X)) | (u2x << U2X);
      UCSR0C = (UCSR0C & ~((1 << UPM1)    |
			   (1 << UPM0)    |
			   (1 << USBS)    |
			   (1 << UCSZ1)   |
			   (1 << UCSZ0))) |
	       ((cfg->upar << UPM0)       |
	        (cfg->usb  << USBS)       |
		(cfg->ucsz << UCSZ0));

      // restore interrupt state
      if (rx)
	SET_BIT(UCSR0B, RXCIE);
      if (tx)
	SET_BIT(UCSR0B, TXCIE);
    }
  }

  /********************************************************************/

  command error_t Uart1Init.init() {
    Atm128UartMode_t    mode;
    Atm128UartStatus_t  stts;
    Atm128UartControl_t ctrl;
    uint16_t ubrr1;
    
    ctrl.bits = (struct Atm128_UCSRB_t) {rxcie:0, txcie:0, rxen:0, txen:0};
    stts.bits = (struct Atm128_UCSRA_t) {u2x:1};
    mode.bits = (struct Atm128_UCSRC_t) {ucsz:ATM128_UART_DATA_SIZE_8_BITS};

    ubrr1 = call Atm128Calibrate.baudrateRegister(PLATFORM_BAUDRATE);
    UBRR1L = ubrr1;
    UBRR1H = ubrr1 >> 8;
    UCSR1A = stts.flat;
    UCSR1C = mode.flat;
    UCSR1B = ctrl.flat;

    return SUCCESS;
  }

  command error_t Uart1TxControl.start() {
    CLR_BIT(UCSR1B, TXCIE);
    SET_BIT(UCSR1B, TXEN);
    call McuPowerState.update();
    return SUCCESS;
  }

  command error_t Uart1TxControl.stop() {
    CLR_BIT(UCSR1B, TXCIE);
    CLR_BIT(UCSR1B, TXEN);
    call McuPowerState.update();
    return SUCCESS;
  }

  command error_t Uart1RxControl.start() {
    CLR_BIT(UCSR1B, RXCIE);
    SET_BIT(UCSR1B, RXEN);
    call McuPowerState.update();
    return SUCCESS;
  }

  command error_t Uart1RxControl.stop() {
    CLR_BIT(UCSR1B, RXCIE);
    CLR_BIT(UCSR1B, RXEN);
    call McuPowerState.update();
    return SUCCESS;
  }
  
  async command error_t HplUart1.enableTxIntr() {
    SET_BIT(UCSR1B, TXCIE);
    return SUCCESS;
  }
  
  async command error_t HplUart1.disableTxIntr(){
    CLR_BIT(UCSR1B, TXCIE);
    return SUCCESS;
  }
  
  async command error_t HplUart1.enableRxIntr(){
    SET_BIT(UCSR1B, RXCIE);
    return SUCCESS;
  }

  async command error_t HplUart1.disableRxIntr(){
    CLR_BIT(UCSR1B, RXCIE);
    return SUCCESS;
  }
  
  async command bool HplUart1.isTxEmpty() {
    return READ_BIT(UCSR1A, TXC);
  }

  async command bool HplUart1.isRxEmpty() {
    return !READ_BIT(UCSR1A, RXC);
  }
  
  async command uint8_t HplUart1.rx(){
    return UDR1;
  }

  async command void HplUart1.tx(uint8_t data) {
    atomic{
      UDR1 = data; 
      SET_BIT(UCSR1A, TXC);
    }
  }
  
  AVR_ATOMIC_HANDLER(SIG_UART1_RECV) {
    if (READ_BIT(UCSR1A, RXC))
      signal HplUart1.rxDone(UDR1);
  }
  
  AVR_NONATOMIC_HANDLER(SIG_UART1_TRANS) {
    signal HplUart1.txDone();
  }
  
  /***************************************
   * configuration
   */
  async command void HplUart1Config.getConfig(atm128_uart_config_t *cfg) {
    atomic {
      uint16_t ubrr = (((uint16_t) UBRR1H) << 8) | ((uint16_t) UBRR1L);
      uint32_t tmp;
      uint8_t  u2x = READ_BIT(UCSR1A, U2X);

      if (!u2x)
	// make it look like double speed...
	// XXX possible roundoff
	ubrr = ((ubrr + 1) << 1) - 1;
      tmp   = ((uint32_t) ubrr) + 1UL;
      tmp  *= 100UL;
      ubrr  = call Atm128Calibrate.baudrateRegister(tmp);
      ubrr += 1;

      cfg->br   = ubrr;
      cfg->u2x  = u2x;
      cfg->ucsz = (READ_BIT(UCSR1C, UCSZ1) << 1) | READ_BIT(UCSR1C, UCSZ0);
      cfg->upar = (READ_BIT(UCSR1C, UPM1) << 1) | READ_BIT(UCSR1C, UPM0);
      cfg->usb  = READ_BIT(UCSR1C, USBS);
    }
  }

  async command void HplUart1Config.setConfig(atm128_uart_config_t *cfg) {
    uint32_t tmp;
    uint16_t ubrr;
    uint8_t  rx, tx, u2x;

    atomic {

      // save interrupt state, disable interrupts
      tx = READ_BIT(UCSR1B, TXCIE);
      rx = READ_BIT(UCSR1B, RXCIE);
      CLR_BIT(UCSR1B, TXCIE);
      CLR_BIT(UCSR1B, RXCIE);

      // let tx and rx flush
      if (READ_BIT(UCSR1B, TXEN)) {
	while (!READ_BIT(UCSR1A, UDRE))
	  ;
      }
      if (READ_BIT(UCSR1B, RXEN)) {
	uint8_t dummy;
	while (READ_BIT(UCSR1A, RXC))
	  dummy = UDR1;
      }

      // get real baudrate -> reg value, correct for u2x
      tmp   = (uint32_t) cfg->br;
      tmp  *= 100UL;
      ubrr  = call Atm128Calibrate.baudrateRegister(tmp);
      if (!(u2x = cfg->u2x))
	ubrr = ((ubrr + 1) >> 1) - 1;

      // program everything up
      UBRR1H = ubrr >> 8;
      UBRR1L = ubrr & 0xff;
      UCSR1A = (UCSR1A & ~(1 << U2X)) | (u2x << U2X);
      UCSR1C = (UCSR1C & ~((1 << UPM1)    |
			   (1 << UPM0)    |
			   (1 << USBS)    |
			   (1 << UCSZ1)   |
			   (1 << UCSZ0))) |
	      ((cfg->upar << UPM0)       |
	       (cfg->usb  << USBS)       |
	       (cfg->ucsz << UCSZ0));

      // restore interrupt state
      if (rx)
	SET_BIT(UCSR1B, RXCIE);
      if (tx)
	SET_BIT(UCSR1B, TXCIE);
    }
  }

  default async event void HplUart0.txDone() {} 
  default async event void HplUart0.rxDone(uint8_t data) {}
  default async event void HplUart1.txDone() {}
  default async event void HplUart1.rxDone(uint8_t data) {}
  
}

