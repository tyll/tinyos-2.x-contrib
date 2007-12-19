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


/**
 * Transmit large packets (> 64 bytes)
 * To use this on the MSP430, DMA MUST be enabled. Also, it is highly 
 * recommended the SMCLK used for SPI is increased above its default minimum.  
 * The microcontroller must access the SPI bus at a minimum of 500 kbps or the 
 * node will lock up.
 *
 * Point your TransmitArbiterC to the BigTransmit instead of BlazeTransmit.
 * This will be a change specific to your workspace until we find this
 * module can work without changes to the TinyOS baseline SPI bus.
 * 
 * This module differs from BlazeTransmit in that packets are not pre-loaded
 * into the radio.  Instead, the radio is kicked into TX mode and then
 * the packet is shot over the SPI bus.  The radio transmits the packet
 * directly as it's coming across the SPI bus, hence the need for at least
 * a 500 kbps SPI bus clock.
 *
 * The parameterized ID is, of course, a unique value of UQ_BLAZE_RADIO
 * which you'll find in each individual radio's header file (CC1100.h or 
 * CC2500.h).  
 *
 * @author Jared Hill
 * @author David Moss
 */

#include "IEEE802154.h"
#include "Blaze.h"
#include "AM.h"

module BigTransmitP {

  provides {
    interface AsyncSend[ radio_id_t id ];
  }
  
  uses {
    interface GeneralIO as Csn[ radio_id_t id ];
    interface BlazePacketBody;
   
    interface BlazeFifo as TXFIFO;
  
    interface BlazeStrobe as SNOP;
    interface BlazeStrobe as STX;
    interface BlazeStrobe as SFTX;
    interface BlazeStrobe as SFRX;
    interface BlazeStrobe as SIDLE;
    interface BlazeStrobe as SRX;
  
    interface BlazeRegister as TxReg;
    
    interface RadioStatus;
    interface State;
    interface Leds;
  }
}

  
implementation {

  enum {
    S_IDLE,
    
    S_TX_PACKET,
  };
  
  /***************** Global Variables ****************/
  uint8_t m_id;
  void *myMsg;
  
  /***************** Local Functions ****************/
  error_t transmit(uint8_t id);
  
  /***************** AsyncSend Commands ****************/
  async command error_t AsyncSend.load[ radio_id_t id ](void *msg, uint16_t rxInterval) {

    atomic {
      myMsg = msg;
    }
    
    signal AsyncSend.loadDone[id](SUCCESS);
    return SUCCESS;
  }
  
  /**
   * Load a packet into the TX FIFO
   * @param msg Any type of message where the first byte is the length
   *    of the rest of the bytes in the message not including the length byte
   */
  async command error_t AsyncSend.send[ radio_id_t id ]() {
    if(call State.requestState(S_TX_PACKET) != SUCCESS) {
      return FAIL;
    }
    
    return transmit(id);
  }
  
  
  /***************** TXFIFO Events ****************/
  async event void TXFIFO.writeDone( uint8_t* tx_buf, uint8_t tx_len,
                                     error_t error ) {
    
    uint8_t id;
    uint8_t status;
    
    if(!call State.isIdle()) {
      atomic id = m_id;
    
      call Csn.set[id]();
      call Csn.clr[id]();
      
      while((status = call RadioStatus.getRadioStatus()) != BLAZE_S_RX) {
        
        call Csn.set[id]();
        call Csn.clr[id]();
        
        if (status == BLAZE_S_RXFIFO_OVERFLOW) {
          error = ESIZE;
          call SFRX.strobe();
          call SRX.strobe();
          
        } else if (status == BLAZE_S_TXFIFO_UNDERFLOW) {
          error = ESIZE;
          call SFTX.strobe();
          call SRX.strobe();

        } else if (status != BLAZE_S_TX) {
          error = FAIL;
          call SRX.strobe();
        }
      }
      
      call Csn.set[ id ]();
      call State.toIdle();
      
      signal AsyncSend.sendDone[ id ](error);
    }
  }

  async event void TXFIFO.readDone( uint8_t* tx_buf, uint8_t tx_len, 
      error_t error ) {
  }

  /***************** Local Functions ****************/  
  /**
   * Transmit the given message through the given radio ID
   * @param id the radio id
   * @param force TRUE to force the packet to go through, even if CCA fails the
   *     first few times
   */
  error_t transmit(uint8_t id) {
    uint8_t state;
    uint8_t status;
    void *msg;
    
    atomic {
      msg = myMsg;
      m_id = id;
    }
    
    call Csn.clr[ id ]();
    
    status = call RadioStatus.getRadioStatus();
    
    if(status != BLAZE_S_RX) {
      if (status == BLAZE_S_RXFIFO_OVERFLOW) {
        call SFRX.strobe();
      } else if (status == BLAZE_S_TXFIFO_UNDERFLOW) {
        call SFTX.strobe();
      }
      
      call SRX.strobe();
    }
    
    /*
     * Put the radio in RX mode if it's not already. This covers the
     * frequency / synthesizer startup and calibration
     */
    while(call RadioStatus.getRadioStatus() != BLAZE_S_RX) {
      call SFTX.strobe();
      call SFRX.strobe();
      call SRX.strobe();
    }
    
    /*
     * Attempt to transmit.  If the radio goes into TX mode, then our transmit
     * is occurring.  Otherwise, there was something on the channel that
     * prevented CCA from passing
     */
    call STX.strobe();
    
    if((state = call RadioStatus.getRadioStatus()) != BLAZE_S_TX) {
      // CCA failed
      call State.toIdle();
      call Csn.set[ id ]();
      return EBUSY;
    }
    
    // CCA passed; start timer in synchronous context
    call TXFIFO.write(msg, (call BlazePacketBody.getHeader(msg))->length + 1);
    
    return SUCCESS;
  }
  
  
  /***************** Tasks ****************/
  
  /***************** Defaults ****************/
  default async command void Csn.set[ radio_id_t id ](){}
  default async command void Csn.clr[ radio_id_t id ](){}
  default async command void Csn.toggle[ radio_id_t id ](){}
  default async command void Csn.makeInput[ radio_id_t id ](){}
  default async command void Csn.makeOutput[ radio_id_t id ](){}
  
  default async event void AsyncSend.loadDone[ radio_id_t id ](error_t error) {}
  default async event void AsyncSend.sendDone[ radio_id_t id ](error_t error) {}
    
}


