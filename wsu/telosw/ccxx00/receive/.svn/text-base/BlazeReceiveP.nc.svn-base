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
    interface SplitControl[ radio_id_t id ];
    interface Receive[ radio_id_t id ];
    interface AckReceive;
    interface RxNotify[ radio_id_t id ];
    interface Backoff as AckBackoff[am_id_t amId];
    interface PacketCount as ReceivedPacketCount;
    interface PacketCount as OverheardPacketCount;
  }
  
  uses {
    interface AsyncSend as AckSend[ radio_id_t id ];
    interface GeneralIO as Csn[ radio_id_t id ];
    interface GeneralIO as RxIo[ radio_id_t id ];
    interface GeneralIO as ChipRdy[ radio_id_t id ];
    interface GpioInterrupt as RxInterrupt[ radio_id_t id ];
    interface BlazeConfig[ radio_id_t id ];
    interface BlazeRegSettings[ radio_id_t id ];
    
    interface BlazeFifo as RXFIFO;
    
    interface BlazeStrobe as SFRX;
    
    interface Resource;
    interface ReceiveMode;
    interface Alarm<T32khz,uint32_t> as AckGap;
    
    interface BlazePacket;
    interface BlazePacketBody;
    interface RadioStatus;
    interface ActiveMessageAddress;
    interface State;
    interface Random;
    interface Leds;
  
#if BLAZE_ENABLE_CRC_32  
    interface PacketCrc;
#endif
  }

}

implementation {

  /** ID of the radio being serviced */
  uint8_t m_id;
  
  /** Pointer to a message buffer, used for double buffering */
  message_t* m_msg;
  
  /** Acknowledgement frame */
  blaze_ack_t acknowledgement;
  
  /** Default message buffer */
  message_t myMsg;
  
  /** TRUE if SplitControl.stop() was called */
  bool stopping;
  
  /** The amount to backoff for an acknowledgment */
  uint16_t myAckBackoff;
  
  /** Total number of acks sent for the current received message */
  uint8_t totalAcks;
  
  /** Total number of packets received into this node for statistics */
  uint32_t totalPacketsReceived = 0;
  
  /** Total number of packets overheard by this node for statistics */
  uint32_t totalPacketsOverheard = 0;
  
  
  enum receive_states{
    S_IDLE,
    S_RX_LENGTH,
    S_RX_PAYLOAD,
    
    S_OFF,
  };
  
  enum {
    /** Total number of redundant acks to send */
    TOTAL_ACKS = 2,
    
    /** The length of our RX FIFO, to drop bad packets that are too large */
    BLAZE_RXFIFO_LENGTH = 64,
    
    /** Add 2 because of RSSI and LQI hidden at the end */
    MAC_PACKET_SIZE = MAC_HEADER_SIZE + TOSH_DATA_LENGTH + MAC_FOOTER_SIZE + 2,

    /** The location of the CRC bit in the LQI byte */
    CRC_BIT = 0x80,
  };
  
  
  /***************** Prototypes ****************/
  task void receiveDone();
  task void notifyRxDone();
  
  void receive();
  uint8_t getStatus();
  void failReceive();
  void cleanUp();
  
  bool isAckPacket(blaze_header_t *header, radio_id_t id);
  bool isDataPacket(blaze_header_t *header, radio_id_t id);
  bool passesAddressFilter(blaze_header_t *header, radio_id_t id);
  bool passesPanFilter(blaze_header_t *header, radio_id_t id);
  bool shouldAck(blaze_header_t *header, radio_id_t id);
  bool passesCrcFilter(void *header);
  
  void ackBackoff();
  void requestAckBackoff();
  
  /***************** Init Commands ****************/
  command error_t Init.init() {
    atomic {
      m_msg = &myMsg;
      acknowledgement.length = ACK_FRAME_LENGTH;
      acknowledgement.fcf = FRAME_TYPE_ACK;
      stopping = FALSE;
    }
    
    call State.forceState(S_OFF);
    
    return SUCCESS;
  }
  

  /***************** SplitControl Commands ****************/
  command error_t SplitControl.start[radio_id_t radioId]() {
    call State.toIdle();
    signal SplitControl.startDone[radioId](SUCCESS);
    return SUCCESS;
  }
  
  command error_t SplitControl.stop[radio_id_t radioId]() {
    bool stopDone = FALSE;

    atomic {
      if(call State.isIdle() || call State.isState(S_OFF)) {
        call State.forceState(S_OFF);
        call RxInterrupt.disable[radioId]();
        stopDone = TRUE;
      
      } else {
        stopping = TRUE;
      }
    }
    
    if(stopDone) {
      signal SplitControl.stopDone[radioId](SUCCESS);
    }
    
    return SUCCESS;
  }
  
  /***************** PacketCount Commands ****************/
  command uint32_t ReceivedPacketCount.getTotal() {
    return totalPacketsReceived;
  }
  
  command uint32_t OverheardPacketCount.getTotal() {
    return totalPacketsOverheard;
  }
  
  
  /***************** RxInterrupt Events ****************/
  async event void RxInterrupt.fired[ radio_id_t id ]() {
    if((call BlazeRegSettings.getDefaultRegisters[id]())[BLAZE_IOCFG0] != 0x01) {
      return;
    }
    
#if BLAZE_ENABLE_SPI_WOR_RX_LEDS
    call Leds.led0On();
#endif

#if BLAZE_ENABLE_TIMING_LEDS
    call Leds.led0On();
#endif
    
    if(call State.requestState(S_RX_LENGTH) != SUCCESS) {
      return;
    }
    
    call RxInterrupt.disable[id]();
    
    atomic m_id = id;
    
    if(call Resource.isOwner()) {
      receive();
      
    } else if(call Resource.immediateRequest() == SUCCESS) {
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
  async event void AckSend.sendDone[ radio_id_t id ](error_t error) {
    totalAcks++;
    
    if(totalAcks < TOTAL_ACKS) {
      call Csn.set[ id ]();
      call Csn.clr[ id ]();
      if(call AckSend.send[ id ](&acknowledgement, TRUE, 0) == SUCCESS) {
        return;
      }
    }
    
    call Csn.set[ id ]();
    
    post receiveDone();
  }
  
  /***************** RXFIFO Events ****************/
  async event void RXFIFO.readDone( uint8_t* rx_buf, uint8_t rx_len,
                                    error_t error ) {

    uint8_t *msg;
    uint8_t id;
    blaze_header_t *header;
    uint8_t rxFrameLength;
    uint8_t *buf;
    
    atomic{ 
      id = m_id; 
      msg = (uint8_t *) m_msg;
    }
    
    header = call BlazePacketBody.getHeader( (message_t *) msg );
    rxFrameLength = header->length;
    buf = (uint8_t *) header;  
    
    //toggle csn to show done reading
    call Csn.set[ id ]();  
    call Csn.clr[ id ]();
    
    switch (call State.getState()) {
    case S_RX_LENGTH:
      call State.forceState(S_RX_PAYLOAD);
      
      if(rxFrameLength + 1 > BLAZE_RXFIFO_LENGTH) {
        // Flush everything if the length is bigger than our FIFO
        
        failReceive();
        return;
      
      } else {
        if(rxFrameLength <= MAC_PACKET_SIZE) {
          if(rxFrameLength > 0) {
            // Add 2 for the status bytes
            call RXFIFO.beginRead(buf + 1, rxFrameLength + 2);
            
          } else {
            // Length == 0; start reading the next packet
            failReceive();
          }
        
        } else {
          // Length is too large; we have to flush the entire Rx FIFO
          failReceive();
        }
      }
      break;
    
    case S_RX_PAYLOAD:
      call Csn.set[ id ]();
      
      if((buf[ rxFrameLength + 2 ] & CRC_BIT) == 0) {
        // CRC check failed
        cleanUp();
        return;
      }
      
      // The FCF_FRAME_TYPE bit in the FCF byte tells us if this is an ack or 
      // data.  If it's data, make sure it meets the minimum size requirement.
      if (isAckPacket(header, id)) {    
        // This is a valid ACK packet.
        signal AckReceive.receive( header->src, header->dest, header->dsn );
        
        /** Fall through and cleanUp() */
        
      } else if(rxFrameLength >= sizeof(blaze_header_t) - 1) {
        // The amount of data in this packet is at least a valid header size
        if(isDataPacket(header, id)) {
          if(passesAddressFilter(header, id)) {
            if(passesPanFilter(header, id)) {
              if( passesCrcFilter( header ) ) {
                totalPacketsReceived++;
                
                if(shouldAck(header, id)) {
                  // Send an ack and then receive the packet in AckSend.sendDone()
                  atomic {
                    acknowledgement.dest = header->src;
                    acknowledgement.dsn = header->dsn;
                    acknowledgement.src = call ActiveMessageAddress.amAddress();
                  }
            
                  totalAcks = 0;
                
                  call Csn.clr[ id ]();
                
                  if(call AckSend.send[ id ](&acknowledgement, TRUE, 0) != SUCCESS) {
                    post receiveDone();
                  }
                
                  // else, drop the ack and continue at AckSend.sendDone()...
                  return;
                
                } else {
                  // Do not send an acknowledgement, just receive this packet
                  post receiveDone();
                  return;
                }
              } else {
                //CRC FAILED, put any debug code here
              }
            }
          }
          
          // This is a data packet that is not for me.
          // Allow the real destination node time to acknowledge the packet 
          // without interruption from this node's transmit branch.
          totalPacketsOverheard++;
          ackBackoff();
          return;
        }
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
  
  /***************** AckBackoff Commands *****************/
  async command void AckBackoff.setBackoff[am_id_t amId](uint16_t backoffTime) {
    atomic myAckBackoff = backoffTime + 1;
  }

  /***************** AckGap Alarm Events ****************/
  async event void AckGap.fired() {
    cleanUp();
  }
  
  /***************** ActiveMessageAddress Events ****************/
  async event void ActiveMessageAddress.changed() {
  }
  
  /***************** BlazeConfig Events ****************/
  event void BlazeConfig.commitDone[radio_id_t id]() {
  }
  
  /***************** ReceiveMode Events ****************/
  event void ReceiveMode.srxDone() {
    cleanUp();
  }
  
  /***************** Tasks ****************/
  task void receiveDone() {
    blaze_metadata_t *metadata = call BlazePacketBody.getMetadata( m_msg );
    uint8_t *buf = (uint8_t*) call BlazePacketBody.getHeader( m_msg );
    uint8_t rxFrameLength = buf[0];
    uint8_t myRssi;
    uint8_t myLqi;
    message_t *atomicMsg;
    uint8_t atomicId;
   
    atomic atomicId = m_id;
    
    
    // Remove the CRC bit from the LQI byte (0x80)
    myRssi = buf[ rxFrameLength + 1 ];
    myLqi = buf[ rxFrameLength + 2 ] & 0x7F;
    
    metadata->lqi = myLqi;
    metadata->rssi = myRssi;
    
    atomicMsg = signal Receive.receive[atomicId]( m_msg, m_msg->data, rxFrameLength );
    
    if(atomicMsg != NULL) {
      atomic m_msg = atomicMsg;
    } else {
      atomic m_msg = &myMsg;
    }
    
    cleanUp();
  }
  
  /**
   * Get out of async context
   */
  task void stopDone() {
    uint8_t atomicId;
    atomic atomicId = m_id;
    signal SplitControl.stopDone[atomicId](SUCCESS);
  }
  
  task void notifyRxDone() {
    uint8_t id;
    atomic id = m_id;
    if(call State.isIdle()) {
      signal RxNotify.doneReceiving[id]();
    }
  }
  
  /***************** Functions ****************/  
  /**
   * Receive the packet by first reading in the length byte.  The SPI
   * bus should already be allocated.
   */
  void receive() {
    uint8_t *msg;
    uint8_t id;
    atomic msg = (uint8_t *) m_msg;
    atomic id = m_id;
    
    call Csn.clr[ id ]();
    
    // Read in the length byte
    call RXFIFO.beginRead(msg, 1);
  }
  
  void failReceive() {
    uint8_t id;
    atomic id = m_id;
    
    call ReceiveMode.srx(id);
  }
  
  
  /**
   * Clean up after a receive
   */
  void cleanUp() {
    uint8_t id;
    bool stop;
    atomic {
      id = m_id;
      stop = stopping;
    }
    
    call Csn.set[ id ]();
    
    if(stop) {
      // Do not re-enable interrupts
      atomic stopping = FALSE;
      call State.forceState(S_OFF);
      call RxInterrupt.disable[id]();
      call Resource.release();
      post stopDone();
      return;
    }
    
    atomic {
      call State.toIdle();
      call RxInterrupt.enableRisingEdge[id]();
      call Resource.release();

      if(call RxIo.get[id]()) {
        if(call State.requestState(S_RX_LENGTH) == SUCCESS) {
          call RxInterrupt.disable[id]();
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
  
  
  bool isAckPacket(blaze_header_t *header, radio_id_t id) {
    return ((header->fcf >> FCF_FRAME_TYPE ) & 7) == FRAME_TYPE_ACK;
  }
  
  bool isDataPacket(blaze_header_t *header, radio_id_t id) {
    return ((header->fcf >> FCF_FRAME_TYPE ) & 7) == FRAME_TYPE_DATA;
  }
  
  bool passesAddressFilter(blaze_header_t *header, radio_id_t id) {
    return (((header->dest == call ActiveMessageAddress.amAddress())
        || (header->dest == AM_BROADCAST_ADDR)))
            || !(call BlazeConfig.isAddressRecognitionEnabled[id]());
  }
  
  bool passesPanFilter(blaze_header_t *header, radio_id_t id) {
    return ((header->destpan == call ActiveMessageAddress.amGroup()) 
        || !(call BlazeConfig.isPanRecognitionEnabled[id]()));
  }
  
  bool shouldAck(blaze_header_t *header, radio_id_t id) {
    return (call BlazeConfig.isAutoAckEnabled[id]())
        && ((( header->fcf >> FCF_ACK_REQ ) & 0x01) == 1);
  }
  
  bool passesCrcFilter(void *header) {
#if BLAZE_ENABLE_CRC_32
    return call PacketCrc.verifyCrc( header );
#else
    return TRUE;
#endif
  }
  
  /**
   * Keep the SPI bus resource under the control of the receive branch until
   * we know any acknowledgment for the current transmission could have gotten 
   * through.
   */
  void ackBackoff() {
    uint16_t atomicBackoff;
    requestAckBackoff();
    atomic atomicBackoff = myAckBackoff;
    call AckGap.start( atomicBackoff );
  }
  
  /**
   * Setup a default acknowledgment gap backoff, and then request any
   * an override from a higher layer.
   */
  void requestAckBackoff() {
    atomic myAckBackoff = 
        call Random.rand16() % (0x7 * BLAZE_BACKOFF_PERIOD)
              + (BLAZE_ACK_WAIT);
    
    signal AckBackoff.requestBackoff[(call BlazePacketBody.getHeader(m_msg))->type](m_msg);
  }
  
  
  /***************** Defaults ****************/
  default event message_t *Receive.receive[ radio_id_t id ](message_t* msg, void* payload, uint8_t len){
    return msg;
  }
  
  default async event void AckReceive.receive( am_addr_t source, am_addr_t destination, uint8_t dsn ) {
  }
  
  default async command error_t AckSend.send[ radio_id_t id ](void *msg, bool force, uint16_t preamble) {
    return FAIL;
  }
  
  default async command void Csn.set[ radio_id_t id ](){}
  default async command void Csn.clr[ radio_id_t id ](){}
  default async command void Csn.toggle[ radio_id_t id ](){}
  default async command bool Csn.get[ radio_id_t id ](){ return 0; }
  default async command void Csn.makeInput[ radio_id_t id ](){}
  default async command bool Csn.isInput[ radio_id_t id ](){ return 0; }
  default async command void Csn.makeOutput[ radio_id_t id ](){}
  default async command bool Csn.isOutput[ radio_id_t id ](){ return 0; }
    
  default async command void RxIo.set[ radio_id_t id ](){}
  default async command void RxIo.clr[ radio_id_t id ](){}
  default async command void RxIo.toggle[ radio_id_t id ](){}
  default async command bool RxIo.get[ radio_id_t id ](){ return 0; }
  default async command void RxIo.makeInput[ radio_id_t id ](){}
  default async command bool RxIo.isInput[ radio_id_t id ](){ return 0; }
  default async command void RxIo.makeOutput[ radio_id_t id ](){}
  default async command bool RxIo.isOutput[ radio_id_t id ](){ return 0; }
    
  
  default command error_t BlazeConfig.commit[ radio_id_t id ]() {
    return FAIL;
  }
    
  default command void BlazeConfig.setAddressRecognition[ radio_id_t id ](bool on) {
  }
  
  default async command bool BlazeConfig.isAddressRecognitionEnabled[ radio_id_t id ]() {
    return TRUE;
  }
  
  default command void BlazeConfig.setPanRecognition[ radio_id_t id ](bool on) {
  }
  
  default async command bool BlazeConfig.isPanRecognitionEnabled[ radio_id_t id ]() {
    return TRUE;
  }
  
  default command void BlazeConfig.setAutoAck[ radio_id_t id ](bool enableAutoAck) {
  }
  
  default async command bool BlazeConfig.isAutoAckEnabled[ radio_id_t id ]() {
    return TRUE;
  }
  
  default command error_t BlazeConfig.setChannelFrequencyKhz[ radio_id_t id ]( uint32_t freqKhz ) {
    return FAIL;
  }
  
  default command uint32_t BlazeConfig.getChannelFrequencyKhz[ radio_id_t id ]() {
    return 0;
  }
  
  default command error_t BlazeConfig.setChannel[ radio_id_t id ]( uint8_t chan ) {
  }
  
  default command uint8_t BlazeConfig.getChannel[ radio_id_t id ]() {
    return 0;
  }
   
  
  default async command error_t RxInterrupt.enableRisingEdge[radio_id_t id]() {
    return FAIL;
  }
  
  default async command error_t RxInterrupt.enableFallingEdge[radio_id_t id]() {
    return FAIL;
  }
  
  default async command error_t RxInterrupt.disable[radio_id_t id]() {
    return FAIL;
  }
  
  default event void SplitControl.startDone[radio_id_t radioId](error_t error) {}
  default event void SplitControl.stopDone[radio_id_t radioId](error_t error) {}
  
  default event void RxNotify.doneReceiving[radio_id_t radioId]() {}
  
  default async event void AckBackoff.requestBackoff[am_id_t amId](message_t *msg) { }
  
  
  default command uint8_t *BlazeRegSettings.getDefaultRegisters[radio_id_t radioId]() {
    return NULL;
  }
  
}

