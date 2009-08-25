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
 * This module assumes it already has full access to the SPI Bus
 * @author Jared Hill
 * @author David Moss
 * @author Roland Hendel
 */
 
#include "Blaze.h"
#include "Acknowledgements.h"
#include "Csma.h"
#include "Fcf.h"

module BlazeReceiveP {

  provides {
    interface Init;
    interface SplitControl;
    interface Receive;
    interface AckReceive;
    interface AckSendNotifier[am_addr_t destination];
  }
  
  uses {
    interface AsyncSend as AckSend;
    interface GeneralIO as Csn;
    interface GeneralIO as RxIo;
    interface GeneralIO as ChipRdy;
    interface GpioInterrupt as RxInterrupt;
    interface BlazeConfig;
    interface BlazeRegSettings;
    
    interface BlazeFifo as RXFIFO;
    
    interface BlazeStrobe as SFRX;
    
    interface Resource;
    interface ReceiveMode;
    interface Alarm<T32khz,uint16_t> as AckGap;
    
    interface BlazePacket;
    interface BlazePacketBody;
    interface RadioStatus;
    interface ActiveMessageAddress;
    interface Random;
    interface Leds;
  
#if BLAZE_ENABLE_CRC_32
    interface PacketCrc;
#endif
  }

}

implementation {
  
  /** Acknowledgement frame */
  blaze_ack_t acknowledgement;
  
  /** Default message buffer */
  message_t myMsg;
  
  /** TRUE if SplitControl.stop() was called */
  bool stopping;
  
  /** State of this component */
  uint8_t state;
  
  
  enum receive_states {
    S_IDLE,
    S_RX_LENGTH,
    S_RX_PAYLOAD,
    
    S_OFF,
  };
  
  enum {
    /** Add 2 because of RSSI and LQI hidden at the end */
    MAC_PACKET_SIZE = MAC_HEADER_SIZE + TOSH_DATA_LENGTH + MAC_FOOTER_SIZE + 2,

    /** The location of the CRC bit in the LQI byte */
    CRC_BIT = 0x80,
  };
  
  
  /***************** Prototypes ****************/
  task void receiveDone();
  
  void receive();
  void failReceive();
  void cleanUp();
  
  bool isAckPacket(blaze_header_t *header);
  bool passesAddressFilter(blaze_header_t *header);
  bool passesPanFilter(blaze_header_t *header);
  bool shouldAck(blaze_header_t *header);
  bool passesCrcFilter(void *header);
  
  uint16_t requestAckBackoff();
  
  /***************** Init Commands ****************/
  command error_t Init.init() {
    acknowledgement.length = ACK_FRAME_LENGTH;
    
    state = S_OFF;
    
    return SUCCESS;
  }
  

  /***************** SplitControl Commands ****************/
  command error_t SplitControl.start() {
    state = S_IDLE;
    signal SplitControl.startDone(SUCCESS);
    return SUCCESS;
  }
  
  command error_t SplitControl.stop() {
    atomic {
      if(!state || state == S_OFF) {
        state = S_OFF;
        call RxInterrupt.disable();
        signal SplitControl.stopDone(SUCCESS);
        
      } else {
        stopping = TRUE;
      }
    }
    
    return SUCCESS;
  }
  
  /***************** PacketCount Commands ****************/  
  
  /***************** RxInterrupt Events ****************/
  async event void RxInterrupt.fired() {
    if((call BlazeRegSettings.getDefaultRegisters())[BLAZE_IOCFG0] != 0x01) {
      return;
    }
    
#if BLAZE_ENABLE_SPI_WOR_RX_LEDS
    call Leds.led0On();
#endif
    
#if BLAZE_ENABLE_TIMING_LEDS
    call Leds.led0On();
#endif
    
    if(state != S_IDLE) {
      return;
    }
    state = S_RX_LENGTH;
    
    call RxInterrupt.disable();
    
    if(call Resource.isOwner()) {
      receive();
      
    } else {
      call Resource.request();
    }
  }
  
  /***************** Resource Events ****************/
  event void Resource.granted() {
    receive();
  }
  
  
  /***************** AckSend Events ****************/
  async event void AckSend.sendDone(error_t error) {
#if BLAZE_CSMA_LEDS
    call Leds.led3Off();
#endif

    call Csn.set();
    post receiveDone();
  }
  
  async event void AckSend.sending() {
  }
  
  /***************** RXFIFO Events ****************/
  async event void RXFIFO.readDone( uint8_t* rx_buf, uint8_t rx_len,
                                    error_t error ) {
    
    blaze_header_t *header = call BlazePacketBody.getHeader( &myMsg );
    
    //toggle csn to show done reading
    call Csn.set();
    
    switch (state) {
    case S_RX_LENGTH:
      state = S_RX_PAYLOAD;
      
      if(header->length <= MAC_PACKET_SIZE) {
        if(header->length > 0) {
          // Add 2 for the status bytes    
          call Csn.clr();
          call RXFIFO.beginRead(((uint8_t *) header) + 1, header->length + 2);
          return;
        }
      }
      
      failReceive();
      break;
      
    case S_RX_PAYLOAD:
      
      // The FCF_FRAME_TYPE bit in the FCF byte tells us if this is an ack or 
      // data.  If it's data, make sure it meets the minimum size requirement.
      if (isAckPacket(header)) {
        // This is a valid ACK packet.
        // Note that ACK packets aren't currently undergoing a CRC check,
        // and BlazeTransmitP isn't appending a CRC for ack packets.
        signal AckReceive.receive( (blaze_ack_t *) &myMsg );
        
        /** Fall through and cleanUp() */
        
      } else if(header->length >= sizeof(blaze_header_t) - 1) {
        // The amount of data in this packet is at least a valid header size
        if(passesAddressFilter(header)) {
          if(passesPanFilter(header)) {
            if(passesCrcFilter(header)) {
              
              if(shouldAck(header)) {
                // Send an ack and then receive the packet in AckSend.sendDone()
                atomic {
                  acknowledgement.fcf = FRAME_TYPE_ACK;
                  acknowledgement.dest = header->src;
                  acknowledgement.dsn = header->dsn;
                  acknowledgement.src = call ActiveMessageAddress.amAddress();
                  
                  signal AckSendNotifier.aboutToSend[header->dest](&acknowledgement);
                }
                
                call Csn.clr();
              
                #if BLAZE_CSMA_LEDS
                  call Leds.led3On();
                #endif
                
                if(call AckSend.send(&acknowledgement, TRUE, 0) != SUCCESS) {
                  
                  #if BLAZE_CSMA_LEDS
                    call Leds.led3Off();
                  #endif
                  
                  post receiveDone();
                }
                
              
                // else, drop the ack and continue at AckSend.sendDone()...
                return;
              
              } else {
                // Do not send an acknowledgement, just receive this packet
                post receiveDone();
                return;
              }
            }
          }
        }
        
        // Allow the real destination node time to acknowledge the packet 
        // without interruption from this node's transmit branch.
        call AckGap.start( requestAckBackoff() );
        return;        
      }
      
      // Didn't pass through our filters
      cleanUp();
      break;
      
    default:
      break;
    }
  }

  async event void RXFIFO.writeDone( uint8_t* tx_buf, uint8_t tx_len, error_t error ) {
  }  
  

  /***************** AckGap Alarm Events ****************/
  async event void AckGap.fired() {
    cleanUp();
  }
  
  /***************** ActiveMessageAddress Events ****************/
  async event void ActiveMessageAddress.changed() {
  }
  
  /***************** BlazeConfig Events ****************/
  event void BlazeConfig.commitDone() {
  }
  
  /***************** ReceiveMode Events ****************/
  event void ReceiveMode.srxDone() {
    cleanUp();
  }
  
  /***************** Tasks ****************/
  task void receiveDone() {
    blaze_metadata_t *metadata = call BlazePacketBody.getMetadata( &myMsg );
    uint8_t *buf = (uint8_t *) call BlazePacketBody.getHeader( &myMsg );
    uint8_t myRssi;
    uint8_t myLqi;
    
    // Remove the CRC bit from the LQI byte (0x80)
    myRssi = buf[ *buf + 1 ];
    myLqi = buf[ *buf + 2 ] & 0x7F;
    
    metadata->lqi = myLqi;
    metadata->rssi = myRssi;
    
    signal Receive.receive( &myMsg, (&myMsg)->data, *buf );
    
    cleanUp();
  }
  
  /**
   * Get out of async context
   */
  task void stopDone() {
    signal SplitControl.stopDone(SUCCESS);
  }
  
  
  /***************** Functions ****************/  
  /**
   * Receive the packet by first reading in the length byte.  The SPI
   * bus should already be allocated.
   */
  void receive() {
    call Csn.clr();
    
    // Read in the length byte
    call RXFIFO.beginRead((uint8_t *) &myMsg, 1);
  }
  
  void failReceive() {
    call Csn.clr();
    call ReceiveMode.srx();
  }
  
  
  /**
   * Clean up after a receive
   */
  void cleanUp() {
    bool stop;
    atomic {
      stop = stopping;
    }
    
    call Csn.set();
    
    if(stop) {
      // Do not re-enable interrupts
      atomic stopping = FALSE;
      state = S_OFF;
      call RxInterrupt.disable();
      call Resource.release();
      post stopDone();
      return;
    }
    
    atomic {
      state = S_IDLE;
      call RxInterrupt.enableRisingEdge();
      call Resource.release();

      if(call RxIo.get()) {
        if(!state) {
          state = S_RX_LENGTH;
          call RxInterrupt.disable();
          call Resource.request();
          return;
        }
      }
      
#if BLAZE_ENABLE_TIMING_LEDS    
      call Leds.led0Off();
#endif

#if BLAZE_ENABLE_SPI_WOR_RX_LEDS
      call Leds.led0Off();
#endif
      
    }
  }
  
  
  bool isAckPacket(blaze_header_t *header) {
    return ((header->fcf >> FCF_FRAME_TYPE ) & 7) == FRAME_TYPE_ACK;
  }
  
  bool passesAddressFilter(blaze_header_t *header) {
    return (((header->dest == call ActiveMessageAddress.amAddress())
        || (header->dest == AM_BROADCAST_ADDR)))
            || !(call BlazeConfig.isAddressRecognitionEnabled());
  }
  
  bool passesPanFilter(blaze_header_t *header) {
    return ((header->destpan == call ActiveMessageAddress.amGroup()) 
        || !(call BlazeConfig.isPanRecognitionEnabled()));
  }
  
  bool shouldAck(blaze_header_t *header) {
    return (call BlazeConfig.isAutoAckEnabled())
        && ((( header->fcf >> FCF_ACK_REQ ) & 0x01) == 1)
            && (header->dest != AM_BROADCAST_ADDR);
  }
  
  bool passesCrcFilter(void *header) {
#if BLAZE_ENABLE_CRC_32
    return call PacketCrc.verifyCrc( header );
#else
    return TRUE;
#endif
  }
  
  /**
   * Setup a default acknowledgment gap backoff, and then request any
   * an override from a higher layer.
   */
  uint16_t requestAckBackoff() {
    return call Random.rand16() % (0x7 * BLAZE_BACKOFF_PERIOD) + (BLAZE_ACK_WAIT);
  }
  
  
  /***************** Defaults ****************/
  default async event void AckSendNotifier.aboutToSend[am_addr_t destination](blaze_ack_t *ack) { }
  
}

