/* Copyright (c) 2007, Tor Petterson <motor@diku.dk>
 * All rights reserved.
 *
 * Redistribution and use in source and binary forms, with or without modification,
 * are permitted provided that the following conditions are met:
 *
 *  - Redistributions of source code must retain the above copyright notice, this
 *    list of conditions and the following disclaimer.
 *  - Redistributions in binary form must reproduce the above copyright notice,
 *    this list of conditions and the following disclaimer in the documentation
 *    and/or other materials provided with the distribution.
 *  - Neither the name of the University of Copenhagen nor the names of its
 *    contributors may be used to endorse or promote products derived from this
 *    software without specific prior written permission.
 *
 * THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS" AND ANY
 * EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED WARRANTIES
 * OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE DISCLAIMED. IN NO EVENT
 * SHALL THE COPYRIGHT OWNER OR CONTRIBUTORS BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL,
 * SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT
 * OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION)
 * HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR
 * TORT (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE,
 * EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
 */

/*
  @author Tor Petterson <motor@diku.dk>
*/

#include "Hcs08Uart.h"

generic module HplHcs08UartP(
  uint16_t SCIxBD_addr,
  uint16_t SCIxC1_addr,
  uint16_t SCIxC2_addr,
  uint16_t SCIxC3_addr,
  uint16_t SCIxS1_addr,
  uint16_t SCIxS2_addr,
  uint16_t SCIxD_addr )
{
  provides interface HplHcs08Uart as Uart;
  uses interface Hcs08UartEvent as TX;
  uses interface Hcs08UartEvent as RX;
}
implementation
{
  #define SCIxBD (*(volatile uint16_t*)SCIxBD_addr)
  #define SCIxC1 (*(volatile uint8_t*)SCIxC1_addr)
  #define SCIxC2 (*(volatile uint8_t*)SCIxC2_addr)
  #define SCIxC3 (*(volatile uint8_t*)SCIxC3_addr)
  #define SCIxS1 (*(volatile uint8_t*)SCIxS1_addr)
  #define SCIxS2 (*(volatile uint8_t*)SCIxS2_addr)
  #define SCIxD (*(volatile uint8_t*)SCIxD_addr)
  
  async command error_t Uart.setBaudrate(uint32_t baudrate) 
  {
  	SCIxBD = busClock/(16*baudrate);
  	return SUCCESS;
  }
  
  async command error_t Uart.enable() 
  {
    SCIxC2 |= HCS08UART_TE;
    SCIxC2 |= HCS08UART_RE;
    return SUCCESS;
  }

  async command error_t Uart.disable() 
  {
    SCIxC2 &= ~HCS08UART_TE;
    SCIxC2 &= ~HCS08UART_RE;
    return SUCCESS;
  }
  
  async command error_t Uart.enableRxIntr()
  {
    SCIxC2 |= HCS08UART_RIE;
    return SUCCESS;
  }

  async command error_t Uart.disableRxIntr()
  {
    SCIxC2 &= ~HCS08UART_RIE;
    return SUCCESS;
  }
  
  async command bool Uart.isRxIntrEnabled()
  {
  	return (SCIxC2 & HCS08UART_RIE) >> 5;
  }
  
  async command error_t Uart.enableTxIntr()
  {
    SCIxC2 |= HCS08UART_TIE;
    return SUCCESS;
  }

  async command error_t Uart.disableTxIntr()
  {
    SCIxC2 &= ~HCS08UART_TIE;
    return SUCCESS;
  }
  
  async command error_t Uart.enableTcIntr()
  {
    SCIxC2 |= HCS08UART_TCIE;
    return SUCCESS;
  }

  async command error_t Uart.disableTcIntr()
  {
    SCIxC2 &= ~HCS08UART_TCIE;
    return SUCCESS;
  }
  
  async command error_t Uart.tx(uint8_t data) 
  {
    if(SCIxS1 & HCS08UART_TDRE)
    {
      SCIxD = data;
      return SUCCESS;
    }
    return EBUSY;
  }
  
  async command uint8_t Uart.rx()
  {
    return SCIxD;
  }
  
  async command bool Uart.isTxEmpty(){
    return (SCIxS1 & HCS08UART_TDRE) >> 7;
  }

  async command bool Uart.isRxEmpty(){
    return !((SCIxS1 & HCS08UART_RDRF) >> 5);
  }
  
  // We need to read the TDRE bit to clear it so we might as well test it 
  async void event TX.fired()
  {
  	if(SCIxS1 & HCS08UART_TDRE){
  	  SCIxC2 &= ~HCS08UART_TIE;
  	  signal Uart.txDone();  
  	}
  	if(SCIxS1 & HCS08UART_TC){
  	  SCIxC2 &= ~HCS08UART_TCIE;
  	  signal Uart.txComplete();  
  	}
  }
  
  async void event RX.fired()
  {
  	 if(SCIxS1 & HCS08UART_RDRF)
  	   signal Uart.rxDone(SCIxD);
  }
  
}
  