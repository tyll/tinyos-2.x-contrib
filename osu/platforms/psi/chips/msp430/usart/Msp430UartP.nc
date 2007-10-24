/**
 * Copyright (c) 2005-2006 Arch Rock Corporation
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
 * @author Jonathan Hui <jhui@archrock.com>
 * @author Vlado Handziski <handzisk@tkn.tu-berlin.de>
 * @version $Revision$ $Date$
 */
 
/**
 * Copyright (c) 2007 - The Ohio State University.
 * All rights reserved.
 *
 * Permission to use, copy, modify, and distribute this software and its
 * documentation for any purpose, without fee, and without written agreement is
 * hereby granted, provided that the above copyright notice, the following
 * two paragraphs, and the author attribution appear in all copies of this
 * software.
 *
 * IN NO EVENT SHALL THE OHIO STATE UNIVERSITY BE LIABLE TO ANY PARTY FOR
 * DIRECT, INDIRECT, SPECIAL, INCIDENTAL, OR CONSEQUENTIAL DAMAGES ARISING OUT
 * OF THE USE OF THIS SOFTWARE AND ITS DOCUMENTATION, EVEN IF THE OHIO STATE
 * UNIVERSITY HAS BEEN ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
 *
 * THE OHIO STATE UNIVERSITY SPECIFICALLY DISCLAIMS ANY WARRANTIES,
 * INCLUDING, BUT NOT LIMITED TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY
 * AND FITNESS FOR A PARTICULAR PURPOSE.  THE SOFTWARE PROVIDED HEREUNDER IS
 * ON AN "AS IS" BASIS, AND THE OHIO STATE UNIVERSITY HAS NO OBLIGATION TO
 * PROVIDE MAINTENANCE, SUPPORT, UPDATES, ENHANCEMENTS, OR MODIFICATIONS.

	@author 
	Lifeng Sang  <sangl@cse.ohio-state.edu>
	Anish Arora  <anish@cse.ohio-state.edu>	
	$Date$
	
	Porting TinyOS to Intel PSI motes
 */
 

#include<Timer.h>

//Lifeng
#include "Msp430PSI.h"

generic module Msp430UartP() {

  provides interface Resource[ uint8_t id ];
  provides interface ResourceConfigure[ uint8_t id ];
  provides interface Msp430UartControl as UartControl[ uint8_t id ];
  provides interface UartStream;
  provides interface UartByte;
  
  uses interface Resource as UsartResource[ uint8_t id ];
  uses interface Msp430UartConfigure[ uint8_t id ];
  uses interface HplMsp430Usart as Usart;
  uses interface HplMsp430UsartInterrupts as UsartInterrupts;
  uses interface Counter<T32khz,uint16_t>;
  uses interface Leds;

}

implementation {
  
  norace uint8_t *m_tx_buf, *m_rx_buf;
  norace uint16_t m_tx_len, m_rx_len;
  norace uint16_t m_tx_pos, m_rx_pos;
  norace uint8_t m_byte_time;
  
  
  //Lifeng Sang
  
  static inline void uart_wiggle(int dir) {  
    if (dir != 1) { // either 0 or -1
			atomic
			{
      	P2DIR |= SPI_NIRQ;
      	P2OUT &= ~SPI_NIRQ;
      }	
      //udelay(1);
    }
    if (dir != 0) { // either 1 or -1
    	atomic
    	{
	      P2OUT |= SPI_NIRQ;
	      //udelay(1);
	      P2DIR &= ~SPI_NIRQ;
	    }
    }  
}

  
  async command error_t Resource.immediateRequest[ uint8_t id ]() {
    return call UsartResource.immediateRequest[ id ]();
  }

  async command error_t Resource.request[ uint8_t id ]() {
    return call UsartResource.request[ id ]();
  }

  async command uint8_t Resource.isOwner[ uint8_t id ]() {
    return call UsartResource.isOwner[ id ]();
  }

  async command error_t Resource.release[ uint8_t id ]() {
    if ( m_rx_buf || m_tx_buf )
      return EBUSY;
    return call UsartResource.release[ id ]();
  }

  async command void ResourceConfigure.configure[ uint8_t id ]() {
  	
  	call UartControl.setModeDuplex[id]();
  }

  async command void ResourceConfigure.unconfigure[ uint8_t id ]() {
    call Usart.disableIntr();
    call Usart.disableUart();
  }

  event void UsartResource.granted[ uint8_t id ]() {
    signal Resource.granted[ id ]();
  }

  async command void UartControl.setModeRx[ uint8_t id ]() {
    msp430_uart_config_t* config = call Msp430UartConfigure.getConfig[id]();
    m_byte_time = config->ubr / 2;
    call Usart.setModeUartRx(config);
    call Usart.clrIntr();
    call Usart.enableRxIntr();   
  }
  
  async command void UartControl.setModeTx[ uint8_t id ]() {
    call Usart.setModeUartTx(call Msp430UartConfigure.getConfig[id]());
    call Usart.clrIntr();
    call Usart.enableTxIntr();
  }
  
  async command void UartControl.setModeDuplex[ uint8_t id ]() {
    msp430_uart_config_t* config = call Msp430UartConfigure.getConfig[id]();
    m_byte_time = config->ubr / 2;
    call Usart.setModeUart(config);
    call Usart.clrIntr();
    call Usart.enableIntr();
    
    //Lifeng Sang
    // signal ready to receive
    uart_wiggle(0);    
  }
  
  async command error_t UartStream.enableReceiveInterrupt() {
    call Usart.enableRxIntr();
    return SUCCESS;
  }
  
  async command error_t UartStream.disableReceiveInterrupt() {
    call Usart.disableRxIntr();
    return SUCCESS;
  }

  async command error_t UartStream.receive( uint8_t* buf, uint16_t len ) {
  	
  	uint8_t x;
  	
  	
    if ( len == 0 )
      return FAIL;
    atomic {
      if ( m_rx_buf )
					return EBUSY;
					
      m_rx_buf = buf;
      m_rx_len = len;
      m_rx_pos = 0;
      
    	// clear out the receive buffer in case data is already there  
      x = RXBUF1;
  	  IE2 |= URXIE1;  // enable interrupt to handle receive

  		uart_wiggle(-1); // signal ready to receive  
      
    }
    return SUCCESS;
  }
  
  async event void UsartInterrupts.rxDone( uint8_t data ) {
    
    if ( m_rx_buf ) {
      m_rx_buf[ m_rx_pos++ ] = data;
      if ( m_rx_pos >= m_rx_len ) {
					uint8_t* buf = m_rx_buf;
					m_rx_buf = NULL;					
					//Lifeng Sang	
					uart_wiggle(0);	
					//IE2 &= ~URXIE1;  // disable recv interrupt					
					signal UartStream.receiveDone( buf, m_rx_len, SUCCESS );
      }
    }
    else {
    	//Lifeng
    	uart_wiggle(-1);
      signal UartStream.receivedByte( data );
    }
    
    
  }
  
  async command error_t UartStream.send( uint8_t* buf, uint16_t len ) {
    if ( len == 0 )
      return FAIL;
    else if ( m_tx_buf )
      return EBUSY;
      
    /*
    while (!(P1IN & SPI_CS1_INT))
      ;*/
              
    m_tx_buf = buf;
    m_tx_len = len;
    m_tx_pos = 0;
    
    
    atomic IE2 |= UTXIE1;
        
    call Usart.tx( buf[ m_tx_pos++ ] );
    return SUCCESS;
  }
  
  async event void UsartInterrupts.txDone() {
  	
    if ( m_tx_pos < m_tx_len ) {
      call Usart.tx( m_tx_buf[ m_tx_pos++ ]);
						
      
      uart_wiggle(-1);

    }
    else {
      uint8_t* buf = m_tx_buf;
      m_tx_buf = NULL;
      
      atomic IE2 &= ~UTXIE1;
      uart_wiggle(0);
      
      signal UartStream.sendDone( buf, m_tx_len, SUCCESS );
    }
  }
  
  async command error_t UartByte.send( uint8_t data ) {
    call Usart.tx( data );
    while( !call Usart.isTxIntrPending() );
    return SUCCESS;
  }
  
  async command error_t UartByte.receive( uint8_t* byte, uint8_t timeout ) {
    
    uint16_t timeout_micro = m_byte_time * timeout + 1;
    uint16_t start;
    
    start = call Counter.get();
    while( !call Usart.isRxIntrPending() ) {
      if ( ( call Counter.get() - start ) >= timeout_micro )
	return FAIL;
    }
    *byte = call Usart.rx();
    
    return SUCCESS;

  }
  
  async event void Counter.overflow() {}
  
  default async command error_t UsartResource.isOwner[ uint8_t id ]() { return FAIL; }
  default async command error_t UsartResource.request[ uint8_t id ]() { return FAIL; }
  default async command error_t UsartResource.immediateRequest[ uint8_t id ]() { return FAIL; }
  default async command error_t UsartResource.release[ uint8_t id ]() { return FAIL; }
  default async command msp430_uart_config_t* Msp430UartConfigure.getConfig[uint8_t id]() {
    return &msp430_uart_default_config;
  }

  default event void Resource.granted[ uint8_t id ]() {}
}
