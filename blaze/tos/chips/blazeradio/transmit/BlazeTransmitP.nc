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
 * @author Jared Hill
 */
 
/**
 * This Module assumes it already has control of the Spi Bus when called
 * It also assumes the radio is on and configured properly
 */
 
#include "IEEE802154.h"
#include "Blaze.h"
#include "AM.h"
#include "InterruptState.h"

module BlazeTransmitP {

  provides {
    interface AsyncSend[ radio_id_t id ];
    interface AsyncSend as AckSend[ radio_id_t id ];
  }
  
  uses {
    interface GeneralIO as Csn[ radio_id_t id ];
    interface GpioInterrupt as TxInterrupt[ radio_id_t id ];
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
    interface State as InterruptState;

    interface Leds;
    
    //interface DebugPins as Pins;
  }
}

  
implementation {

  enum {
    S_IDLE,
    
    S_LOAD_PACKET,
    S_LOAD_ACK,
    
    S_TX_PACKET,
    S_TX_ACK,
  };
  
  /***************** Global Variables ****************/
  uint8_t m_id;
  
  /***************** Local Functions ****************/
  error_t load(uint8_t id, void *msg);
  error_t transmit(uint8_t id, bool force);
  
  
  /***************** AsyncSend Commands ****************/
  /**
   * Load a packet into the TX FIFO
   * @param msg Any type of message where the first byte is the length
   *    of the rest of the bytes in the message not including the length byte
   */
  async command error_t AsyncSend.load[ radio_id_t id ](void *msg) {
    if(call State.requestState(S_LOAD_PACKET) != SUCCESS) {
      return FAIL;
    }
    
    return load(id, msg);
  }
  
  /**
   * Transmit the packet loaded into the TX FIFO.
   * @return SUCCESS if the packet is being sent. 
   *     FAIL if we're doing something else
   *     EBUSY if the channel is busy (when hardware CCA is enabled)
   */
  async command error_t AsyncSend.send[ radio_id_t id ]() {
    
    if(call State.requestState(S_TX_PACKET) != SUCCESS) {
      return FAIL;
    }

    return transmit(id, FALSE);
  }
  
  
  /***************** AsyncSend Commands ****************/
  /**
   * Load a packet into the TX FIFO.  Should only be accessed by BlazeReceiveP
   * This will force the packet to go through, even if hardware CCA is enabled.
   * @param msg Any type of message where the first byte is the length
   *    of the rest of the bytes in the message not including the length byte
   */
  async command error_t AckSend.load[ radio_id_t id ](void *msg) {
    if(call State.requestState(S_LOAD_ACK) != SUCCESS) {
      return FAIL;
    }
    
    return load(id, msg);
  }
  
  /**
   * Transmit the acknowledgement already in the TX FIFO.  
   * Should only be accessed by BlazeReceiveP
   */
  async command error_t AckSend.send[ radio_id_t id ]() {
    if(call State.requestState(S_TX_ACK) != SUCCESS) {
      return FAIL;
    }
    
    return transmit(id, TRUE);
  }
  

  
  
  /***************** TXFIFO Events ****************/
  async event void TXFIFO.writeDone( uint8_t* tx_buf, uint8_t tx_len,
                                     error_t error ) {
    
    uint8_t id;
    uint8_t state;
    
    atomic id = m_id;
    
    call Csn.set[ id ]();
    
    state = call State.getState();
    call State.toIdle();
    
    if(state == S_LOAD_PACKET) {
      signal AsyncSend.loadDone[ id ](tx_buf, error);
    } else {
      signal AckSend.loadDone[ id ](tx_buf, error);
    }
  }

  async event void TXFIFO.readDone( uint8_t* tx_buf, uint8_t tx_len, 
      error_t error ) {
  }
  
  
  /***************** TxInterrupt Events ****************/
  /**
   * Because we had the falling edge enabled, if this is our event,
   * the packet is finished transmitting. In the future, timestamping can
   * occur on the rising edge.
   */
  async event void TxInterrupt.fired[ radio_id_t id ]() {
    if(call InterruptState.isState(S_INTERRUPT_RX)) {
      return;
    }
  }
  
  /***************** Local Functions ****************/
  /**
   * Load a message into the TX FIFO
   */
  error_t load(uint8_t id, void *msg) {
    uint8_t status;
    atomic m_id = id;
    
    call Csn.clr[ id ]();
    
    // TODO is the status check & SRX necessary?  Remove it and run some tests.
    status = call RadioStatus.getRadioStatus();
    if (status == BLAZE_S_RXFIFO_OVERFLOW) {
      call SFRX.strobe();
    } else if (status == BLAZE_S_TXFIFO_UNDERFLOW) {
      call SFTX.strobe();
    }
    
    call SRX.strobe();
    
    /* 
     * The length byte in the packet is already correct - it represents the
     * number of bytes in the packet *AFTER* the length byte, not included CRC
     *
     * So in order to also get that length byte transmitted we gotta add one 
     * byte to the transmit length. 
     */
     
    
    call TXFIFO.write(msg, (call BlazePacketBody.getHeader(msg))->length + 1);
    return SUCCESS;
  }
  
  /**
   * Transmit the given message through the given radio ID
   * @param id the radio id
   * @param force TRUE to force the packet to go through, even if CCA fails the
   *     first few times
   */
  error_t transmit(uint8_t id, bool force) {
    uint8_t state;
    atomic m_id = id;
        
    call Csn.clr[ id ]();
    
    /*
     * Put the radio in RX mode if it's not already. This covers the
     * frequency / synthesizer startup and calibration
     */
    while(call RadioStatus.getRadioStatus() != BLAZE_S_RX) {
      call SFRX.strobe();
      call SRX.strobe();
    }
    
    /*
     * Attempt to transmit.  If the radio goes into TX mode, then our transmit
     * is occurring.  Otherwise, there was something on the channel that
     * prevented CCA from passing
     */
    call STX.strobe();
    
    if(force) {
      while(call RadioStatus.getRadioStatus() != BLAZE_S_TX) {
        // Keep trying until the channel is clear enough for this to go through
        call STX.strobe();
      }
    
    } else {
      if((state = call RadioStatus.getRadioStatus()) != BLAZE_S_TX) {
        // CCA failed
        call State.toIdle();
        call Csn.set[ id ]();
        return EBUSY;
      }
    }
    
    /*
     * Our radio must go back into RX mode after a transmit. Wait until
     * the status byte tells us we're in the RX mode, or if there
     * was an overflow/underflow, fix it and make sure we're 
     * back in RX mode by the time this is done.
     */
    while((state = call RadioStatus.getRadioStatus()) != BLAZE_S_RX) {
      if (state == BLAZE_S_RXFIFO_OVERFLOW) {
        call SFRX.strobe();
        call SRX.strobe();
      }
      
      if (state == BLAZE_S_TXFIFO_UNDERFLOW) {
        call SFTX.strobe();
        call SRX.strobe();
      }
    }
    
    /*
     * Deselect the radio hardware, set our state back to idle, signal done
     */
    call Csn.set[ id ]();
    
    state = call State.getState();
    call State.toIdle();
    
    if(state == S_TX_PACKET) {
      signal AsyncSend.sendDone[ id ]();
    
    } else if(state == S_TX_ACK) {
      signal AckSend.sendDone[ id ]();
    }
    
    return SUCCESS;
  }
  
  
  /***************** Defaults ****************/
  default async command void Csn.set[ radio_id_t id ](){}
  default async command void Csn.clr[ radio_id_t id ](){}
  default async command void Csn.toggle[ radio_id_t id ](){}
  default async command void Csn.makeInput[ radio_id_t id ](){}
  default async command void Csn.makeOutput[ radio_id_t id ](){}
  
  default async event void AsyncSend.sendDone[ radio_id_t id ]() {}
  default async event void AsyncSend.loadDone[ radio_id_t id ](void *msg, error_t error) {}
  
  default async event void AckSend.sendDone[ radio_id_t id ]() {}
  default async event void AckSend.loadDone[ radio_id_t id ](void *msg, error_t error) {}
  
  
  default async command error_t TxInterrupt.enableRisingEdge[radio_id_t id]() {
    return FAIL;
  }
  
  default async command error_t TxInterrupt.enableFallingEdge[radio_id_t id]() {
    return FAIL;
  }
  
  default async command error_t TxInterrupt.disable[radio_id_t id]() {
    return FAIL;
  }
  
  
}


