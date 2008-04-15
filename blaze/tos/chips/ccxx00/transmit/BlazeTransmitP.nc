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
 * To use this on the MSP430, DMA MUST be enabled. Also, it is highly 
 * recommended the SMCLK used for SPI is increased above its default minimum.  
 * The microcontroller must access the SPI bus at a minimum of 500 kbps or the 
 * node will lock up.
 *
 * Point your TransmitArbiterC to the BlazeTransmit instead of BlazeTransmit.
 * This will be a change specific to your workspace until we find this
 * module can work without changes to the TinyOS baseline SPI bus.
 * 
 * The radio is kicked into TX mode and then
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
#include "BlazeTransmit.h"

module BlazeTransmitP {

  provides {
    interface AsyncSend[ radio_id_t id ];
    interface AsyncSend as AckSend[ radio_id_t radioId ];
  }
  
  uses {
    interface GeneralIO as Csn[ radio_id_t id ];
    interface GeneralIO as ChipRdy[radio_id_t radioId];
    interface GeneralIO as RxIo[radio_id_t radioId];
    interface BlazePacketBody;
    interface BlazeRegSettings;
    
    interface BlazeFifo as TXFIFO;
  
    interface BlazeStrobe as SNOP;
    interface BlazeStrobe as STX;
    interface BlazeStrobe as SFTX;
    interface BlazeStrobe as SFRX;
    interface BlazeStrobe as SIDLE;
    interface BlazeStrobe as SRX;
    
    interface BlazeRegister as PaReg;
    interface BlazeRegister as TxReg;
    interface BlazeRegister as WORCTRL;
    
    interface Timer<TMilli>;
    interface RadioStatus;
    interface State;
    interface Leds;
  }
}

  
implementation {

  enum {
    S_IDLE,
    
    S_TX_PACKET,
    S_TX_ACK,
  };
  
  /***************** Global Variables ****************/
  uint8_t m_id;
  
  void *myMsg;
  bool force;
  uint16_t duration;
  
  /***************** Prototypes ****************/
  error_t transmit();
  void disableWor();
  task void startTimer();
  
  /***************** AsyncSend Commands ****************/  
  async command error_t AsyncSend.send[ radio_id_t id ](void *msg, bool forcePkt, uint16_t preambleDurationMs) {
    
    if(call State.requestState(S_TX_PACKET) != SUCCESS) {
      return FAIL;
    }
    
#if BLAZE_ENABLE_TIMING_LEDS
    call Leds.led2On();
#endif
    
    atomic m_id = id;
    atomic myMsg = msg;
    atomic force = forcePkt;
    atomic duration = preambleDurationMs;

    return transmit();
  }
  
  /***************** AckSend Commands ****************/  
  async command error_t AckSend.send[ radio_id_t id ](void *msg, bool forcePkt, uint16_t preambleDurationMs) {
    
    if(call State.requestState(S_TX_ACK) != SUCCESS) {
      return FAIL;
    }
    
#if BLAZE_ENABLE_TIMING_LEDS
    call Leds.led1On();
#endif
    
    atomic m_id = id;
    atomic myMsg = msg;
    atomic force = forcePkt;
    atomic duration = preambleDurationMs;
    
    return transmit();
  }
  
  
  /***************** TXFIFO Events ****************/
  async event void TXFIFO.writeDone( uint8_t* tx_buf, uint8_t tx_len,
                                     error_t error ) {
    
    uint8_t id;
    uint8_t status;
    uint8_t myState;
    
    if(!call State.isIdle()) {
      atomic id = m_id;
    
      call Csn.set[id]();
      call Csn.clr[id]();

#if BLAZE_ENABLE_WHILE_LOOP_LEDS
      call Leds.set(1);
#endif

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

        } else if (status == BLAZE_S_CALIBRATE) {
          // do nothing but don't quit the loop
          
        } else if (status == BLAZE_S_SETTLING) {
          // do nothing but don't quit the loop
          
        } else if (status != BLAZE_S_TX) {
          error = FAIL;
          call SRX.strobe();
        }
      }
      
#if BLAZE_ENABLE_WHILE_LOOP_LEDS
      call Leds.set(0);
#endif
      
      call Csn.set[ id ]();
      
      myState = call State.getState();
      call State.toIdle();
      
      if(myState == S_TX_PACKET) {
#if BLAZE_ENABLE_TIMING_LEDS
        call Leds.led2Off();
#endif
        signal AsyncSend.sendDone[ id ](error);
        
      } else {
#if BLAZE_ENABLE_TIMING_LEDS
        call Leds.led1Off();
#endif
        signal AckSend.sendDone[ id ](error);
      }
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
  error_t transmit() {
    uint8_t status;
    void *msg;
    uint8_t id;
    bool forcing;    
    uint16_t transmitDelay;
    int forceAttempts = 0;
    
    atomic {
      msg = myMsg;
      id = m_id;
      forcing = force;
      transmitDelay = duration;
    }
    
    // Receives take priority; don't drop acknowledgments.
    if(call State.isState(S_TX_PACKET) && call RxIo.get[id]()) {
#if BLAZE_ENABLE_TIMING_LEDS
    call Leds.led2Off();
#endif
      call State.toIdle();
      return FAIL;
    }
    
    call Csn.clr[ id ]();
    
    while(call ChipRdy.get[id]());
    
    /** Ensure WoR is disabled before attempting any transmission */
    disableWor();
    
    call Csn.set[id]();
    call Csn.clr[id]();
    
    /*
     * Put the radio in RX mode if it's not already. This covers the
     * frequency / synthesizer startup and calibration
     */

#if BLAZE_ENABLE_WHILE_LOOP_LEDS
    call Leds.set(2);
#endif

    while((status = call RadioStatus.getRadioStatus()) != BLAZE_S_RX) {
      call Csn.set[id]();
      call Csn.clr[id]();
      
      while(call ChipRdy.get[id]());
      
      if (status == BLAZE_S_RXFIFO_OVERFLOW) {
        call SFRX.strobe();
        call SRX.strobe();
        
      } else if (status == BLAZE_S_TXFIFO_UNDERFLOW) {
        call SFTX.strobe();
        call SRX.strobe();
        
      } else if (status == BLAZE_S_CALIBRATE) {
        // do nothing but don't quit the loop
        
      } else if (status == BLAZE_S_SETTLING) {
        // do nothing but don't quit the loop
        
      } else if (status == BLAZE_S_IDLE) {
        call SRX.strobe();
        
      } else {
        call SIDLE.strobe();
        call SRX.strobe();
      }
    }
#if BLAZE_ENABLE_WHILE_LOOP_LEDS
    call Leds.set(0);
#endif
    
    // Receives take priority; don't drop acknowledgments.
    // This is the last chance to abort a transmit for a receive.
    if(call State.isState(S_TX_PACKET) && call RxIo.get[id]()) {
#if BLAZE_ENABLE_TIMING_LEDS
    call Leds.led2Off();
#endif
      call Csn.set[id]();
      call State.toIdle();
      return FAIL;
    }
    
    /*
     * Attempt to transmit.  If the radio goes into TX mode, then our transmit
     * is occurring.  Otherwise, there was something on the channel that
     * prevented CCA from passing
     */
    
    if(forcing) {
      for(forceAttempts = 0; (status = call RadioStatus.getRadioStatus()) != BLAZE_S_TX
          && forceAttempts < MAX_FORCE_ATTEMPTS; forceAttempts++) {
        call STX.strobe();
      }
      
    } else {

#if BLAZE_ENABLE_WHILE_LOOP_LEDS
      call Leds.set(3);
#endif
      do {
        call STX.strobe();
        status = call RadioStatus.getRadioStatus();
      } while((status != BLAZE_S_RX) && (status != BLAZE_S_TX));
#if BLAZE_ENABLE_WHILE_LOOP_LEDS
      call Leds.set(0);
#endif
    }
    
    if(status != BLAZE_S_TX) {
      // CCA failed
      call Csn.set[ id ]();
      call State.toIdle();

#if BLAZE_ENABLE_TIMING_LEDS
      call Leds.led2Off();
      call Leds.led1Off();
#endif
      return EBUSY;
    }
      
    // CCA Passed
    if(transmitDelay > 0) {
      post startTimer();
      
    } else {
      call TXFIFO.write(msg, (call BlazePacketBody.getHeader(msg))->length + 1);
    }
    return SUCCESS;
  }
  
  
  /**
   * Disable WoR locally. 
   */
  void disableWor() {
      call WORCTRL.write(
            (1 << CCXX00_WORCTRL_RC_PD) |
            (0x7 << CCXX00_WORCTRL_EVENT1) |
            (1 << CCXX00_WORCTRL_RC_CAL) |
            (0 << CCXX00_WORCTRL_WOR_RES));
  }
  
  /***************** Timer Events ****************/
  event void Timer.fired() {
    void *msg;
    atomic msg = myMsg;
    call TXFIFO.write(msg, (call BlazePacketBody.getHeader(msg))->length + 1);
  }
  
  
  /***************** Tasks ****************/
  /**
   * Move out of async context
   */
  task void startTimer() {
    uint16_t transmitDelay;
    atomic transmitDelay = duration;
    call Timer.startOneShot(transmitDelay);
  }
  
  /***************** Defaults ****************/
  default async command void Csn.set[ radio_id_t id ](){}
  default async command void Csn.clr[ radio_id_t id ](){}
  default async command void Csn.toggle[ radio_id_t id ](){}
  default async command void Csn.makeInput[ radio_id_t id ](){}
  default async command void Csn.makeOutput[ radio_id_t id ](){}
  
  default async command void ChipRdy.set[ radio_id_t id ](){}
  default async command void ChipRdy.clr[ radio_id_t id ](){}
  default async command void ChipRdy.toggle[ radio_id_t id ](){}
  default async command bool ChipRdy.get[ radio_id_t id ](){return FALSE;}
  default async command void ChipRdy.makeInput[ radio_id_t id ](){}
  default async command bool ChipRdy.isInput[ radio_id_t id ](){return FALSE;}
  default async command void ChipRdy.makeOutput[ radio_id_t id ](){}
  default async command bool ChipRdy.isOutput[ radio_id_t id ](){return FALSE;}
  
  default async command void RxIo.set[ radio_id_t id ](){}
  default async command void RxIo.clr[ radio_id_t id ](){}
  default async command void RxIo.toggle[ radio_id_t id ](){}
  default async command bool RxIo.get[ radio_id_t id ](){ return 0; }
  default async command void RxIo.makeInput[ radio_id_t id ](){}
  default async command bool RxIo.isInput[ radio_id_t id ](){ return 0; }
  default async command void RxIo.makeOutput[ radio_id_t id ](){}
  default async command bool RxIo.isOutput[ radio_id_t id ](){ return 0; }
  
  default async event void AsyncSend.sendDone[ radio_id_t id ](error_t error) {}
  
  default async event void AckSend.sendDone[ radio_id_t id ](error_t error) {}
    
}


