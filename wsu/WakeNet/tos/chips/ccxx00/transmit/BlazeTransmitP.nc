
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

#include "Blaze.h"
#include "AM.h"
#include "BlazeTransmit.h"

module BlazeTransmitP {

  provides {
    interface AsyncSend;
    interface AsyncSend as AckSend;
  }
  
  uses {
    interface GeneralIO as Csn;
    interface GeneralIO as ChipRdy;
    interface GeneralIO as RxIo;
    interface BlazePacketBody;
    interface BlazeRegSettings;
    interface ReceiveMode;
    
    interface BlazeFifo as TXFIFO;
  
    interface BlazeStrobe as STX;
    interface BlazeStrobe as SFRX;
    
    interface Timer<TMilli>;
    interface RadioStatus;
    interface Leds;
    
#if BLAZE_ENABLE_CRC_32
    interface PacketCrc;
#endif
  }
}

  
implementation {
  
  /**
   * Transmit States
   */
  enum {
    S_TX_IDLE,
    
    S_TX_PACKET,
    S_TX_ACK,
  };
  
  /***************** Global Variables ****************/
  norace void *myMsg;
  bool force;
  uint8_t state;
  uint16_t duration;
    
  /***************** Prototypes ****************/
  error_t transmit();
  void finishTx();
  
  task void startTimer();
  
  /***************** AsyncSend Commands ****************/
  async command error_t AsyncSend.send(void *msg, bool forcePkt, uint16_t preambleDurationMs) {
    if(state != S_TX_IDLE) {
      return FAIL;
    }
    
    state = S_TX_PACKET;
    
#if BLAZE_ENABLE_TIMING_LEDS
    call Leds.led2On();
#endif
    
    atomic myMsg = msg;
    atomic force = forcePkt;
    atomic duration = preambleDurationMs;
    
#if BLAZE_ENABLE_CRC_32
    call PacketCrc.computeCrc( myMsg );
#endif
        
    return transmit();
  }
  
  /***************** AckSend Commands ****************/ 
  /**
   * Note that ack packets aren't currently undergoing a CRC check.
   */
  async command error_t AckSend.send(void *msg, bool forcePkt, uint16_t preambleDurationMs) {
    if(state != S_TX_IDLE) {
      return FAIL;
    }
    
    state = S_TX_ACK;
    
#if BLAZE_ENABLE_TIMING_LEDS
    call Leds.led1On();
#endif
    
    atomic myMsg = msg;
    atomic force = forcePkt;
    atomic duration = preambleDurationMs;
    
    return transmit();
  }
  
  
  /***************** TXFIFO Events ****************/
  async event void TXFIFO.writeDone( uint8_t* tx_buf, uint8_t tx_len,
                                     error_t error ) {
    
    uint16_t count = 0;
    
    if(state != S_TX_IDLE) {
      
      call Csn.set();
      call Csn.clr();

#if BLAZE_ENABLE_WHILE_LOOP_LEDS
      call Leds.set(1);
#endif

      while(call RadioStatus.getRadioStatus() != BLAZE_S_RX) {
        count++;
        call Csn.set();
        call Csn.clr();
        
        if(count == 0) {
          call ReceiveMode.srx();
          return;
        }
      }

#if BLAZE_ENABLE_WHILE_LOOP_LEDS
      call Leds.set(0);
#endif
      
      finishTx();
    }
  }
  

  async event void TXFIFO.readDone( uint8_t* tx_buf, uint8_t tx_len, 
      error_t error ) {
  }
  
  /***************** ReceiveMode Events ****************/
  event void ReceiveMode.srxDone() {
    finishTx();
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
    bool forcing;    
    uint16_t transmitDelay;
    uint16_t killSwitch;
    
    atomic {
      forcing = force;
      transmitDelay = duration;
    }
    
    /*
     * The following code was originally here to prevent the node from 
     * transmitting when it's supposed to be receiving, to increase the
     * acknowledgment success rate. 
     *
     * This block of code locks up a transceiver that is rapidly
     * receiving packets (like XMAC) while responding to some of them.
     * Although this code isn't needed here, it shows that the RxIo line is
     * high and the receive branch isn't doing anything about it.
     *
     * I'll leave this code available for now if someone wants to experiment
     * with making the BlazeReceiveP more reliable.
     *
     * For now, the RXFIFO fills up and is flushed in the next while loop, 
     * which clears the RxIo line and gets the receive branch moving again.
     *
    if(state == S_TX_PACKET && call RxIo.get()) {
#if BLAZE_ENABLE_TIMING_LEDS
      call Leds.led2Off();
#endif
      state = S_TX_IDLE;
      call Leds.led1Off();
      return FAIL;
    }
    */
    
    call Csn.clr();
    
#if BLAZE_ENABLE_WHILE_LOOP_LEDS
      call Leds.set(2);
#endif

    while(call ChipRdy.get());
    
#if BLAZE_ENABLE_WHILE_LOOP_LEDS
      call Leds.set(0);
#endif
    
    call ReceiveMode.blockingSrx();
    
    
    /*
     * Attempt to transmit.  If the radio goes into TX mode, then our transmit
     * is occurring.  Otherwise, there was something on the channel that
     * prevented CCA from passing
     */


#if BLAZE_ENABLE_WHILE_LOOP_LEDS
      call Leds.set(3);
#endif

      killSwitch = 0;
      do {
        killSwitch++;
        call STX.strobe();
        status = call RadioStatus.getRadioStatus();
        
        if(!forcing && status == BLAZE_S_RX) {
          break;
        }
        
      } while((status != BLAZE_S_TX) && killSwitch < MAX_FORCE_ATTEMPTS);
      
#if BLAZE_ENABLE_WHILE_LOOP_LEDS
      call Leds.set(0);
#endif

    
    if(status != BLAZE_S_TX) {
      // CCA failed
      call Csn.set();
      state = S_TX_IDLE;
      
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
      call TXFIFO.write(myMsg, (call BlazePacketBody.getHeader(myMsg))->length + 1);
    }
    
    return SUCCESS;
  }  
  
  /**
   * Finish up the transmission process
   */
  void finishTx() {
    uint8_t myState = state;
    state = S_TX_IDLE;
    
    call Csn.set();
    
    if(myState == S_TX_PACKET) {
#if BLAZE_ENABLE_TIMING_LEDS
      call Leds.led2Off();
#endif
      
      signal AsyncSend.sendDone(SUCCESS);
      
    } else {
#if BLAZE_ENABLE_TIMING_LEDS
      call Leds.led1Off();
#endif
      signal AckSend.sendDone(SUCCESS);
    }
  }
  
  /***************** Timer Events ****************/
  event void Timer.fired() {
    call TXFIFO.write(myMsg, (call BlazePacketBody.getHeader(myMsg))->length + 1);
  }
  
  
  /***************** Tasks ****************/
  /**
   * Move out of async context
   */
  task void startTimer() {
    uint16_t transmitDelay;
    atomic transmitDelay = duration;
    signal AsyncSend.sending();
    call Timer.startOneShot(transmitDelay + 1);
  }
  
  
  /***************** Defaults ****************/
  default async event void AsyncSend.sendDone(error_t error) {}
  default async event void AsyncSend.sending() {}
  default async event void AckSend.sendDone(error_t error) {}
  
}


