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
 * This module assumes it already has full access to the Spi Bus
 * @author Jared Hill
 * @author David Moss
 * @author Roland Hendel
 */
 
#include "Blaze.h"

module BlazeReceiveP {

  provides {
    interface Receive[ radio_id_t id ];
    interface ReceiveController[ radio_id_t id ];
    interface AckReceive;
        
    interface Init;
  }
  
  uses {
    interface AsyncSend as AckSend[ radio_id_t id ];
    interface GeneralIO as Csn[ radio_id_t id ];
    interface GeneralIO as RxIo[ radio_id_t id ];
    interface GpioInterrupt as RxInterrupt[ radio_id_t id ];
    interface BlazeConfig[ radio_id_t id ];
   
    interface BlazeFifo as RXFIFO;
  
    interface Resource;
    interface BlazeStrobe as SFRX;
    interface BlazeStrobe as SFTX;
    interface BlazeStrobe as SRX;
    interface BlazeStrobe as SIDLE;
    
    interface BlazeRegister as RXREG;
  
    interface BlazePacket;
    interface BlazePacketBody;
    
    interface RadioStatus;
    
    interface ActiveMessageAddress;
    interface State;
    interface Leds;
    //interface DebugPins as Pins;
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

  /** The ID of the other radio waiting for its packet to be received */
  uint8_t pendingRadioRx;
  
  enum receive_states{
    S_IDLE,
    S_RX_LENGTH,
    S_RX_FCF,
    S_RX_PAYLOAD,
  };
  
  enum {
    BLAZE_RXFIFO_LENGTH = 64,
    
    // Add 2 because of RSSI and LQI hidden at the end
    MAC_PACKET_SIZE = MAC_HEADER_SIZE + TOSH_DATA_LENGTH + MAC_FOOTER_SIZE + 2,
    
    SACK_HEADER_LENGTH = 5,
    NO_RADIO_PENDING = 0xFF,
  };
  
  
  /***************** Prototypes ****************/
  task void receiveDone();
  
  void receive();
  uint8_t getStatus();
  void failReceive();
  void cleanUp();
  
  /***************** Init Commands ****************/
  command error_t Init.init() {
    atomic {
      m_msg = &myMsg;
      acknowledgement.length = ACK_FRAME_LENGTH;
      acknowledgement.fcf = IEEE154_TYPE_ACK;
      pendingRadioRx = NO_RADIO_PENDING;
    }
    return SUCCESS;
  }
  

  /***************** RxInterrupt Events ****************/
  async event void RxInterrupt.fired[ radio_id_t id ]() {
    //call Pins.set67();
    call RxInterrupt.disable[id]();
    if(call ReceiveController.beginReceive[id]() != SUCCESS) {
      atomic pendingRadioRx = id;
    }
  }
  
  /***************** ReceiveController Commands ***********************/
  async command error_t ReceiveController.beginReceive[ radio_id_t id ]() {
    
    if(call State.requestState(S_RX_LENGTH) != SUCCESS) {
      return EBUSY;
    }
    
    atomic m_id = id;
    
    if(call Resource.isOwner()) {
      receive();
      
    } else if(call Resource.immediateRequest() == SUCCESS) {
      receive();
      
    } else {
      call Resource.request();
    }
    
    return SUCCESS;
  }
  
  /***************** Resource Events ****************/
  event void Resource.granted() {
    receive();
  }
  
  
  /***************** AckSend Events ****************/
  async event void AckSend.loadDone[ radio_id_t id ](void *msg, error_t error) {
    call AckSend.send[id]();
  }
  
  async event void AckSend.sendDone[ radio_id_t id ]() {
    blaze_header_t *header = call BlazePacketBody.getHeader( m_msg );
    uint8_t rxFrameLength = header->length;
    uint8_t *buf = (uint8_t*) header;
    
    call Csn.clr[ id ]();
    
    // Add 2 for status bytes
    call RXFIFO.beginRead(buf + 1 + SACK_HEADER_LENGTH, 
          rxFrameLength - SACK_HEADER_LENGTH + 2);
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
      call State.forceState(S_RX_FCF);
      
      if(rxFrameLength + 1 > BLAZE_RXFIFO_LENGTH) {
        // Flush everything if the length is bigger than our FIFO
        //call Pins.clr65();
        failReceive();
        return;
      
      } else {
        if(rxFrameLength <= MAC_PACKET_SIZE) {
          if(rxFrameLength > 0) {
            if(rxFrameLength > SACK_HEADER_LENGTH) {
              // This packet has an FCF byte plus at least one more byte to read
              call RXFIFO.beginRead(buf + 1, SACK_HEADER_LENGTH);
            
            } else {
              // This is a bad packet because it doesn't have enough
              // bytes for a real header. Skip ack check and get it out of here.
              call State.forceState(S_RX_PAYLOAD);
              call RXFIFO.beginRead(buf + 1, rxFrameLength);
            }
                          
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
      
    case S_RX_FCF:
      call State.forceState(S_RX_PAYLOAD);
      
      // Our local address may have changed from the last packet received,
      // so set the outbound acknowledgement frame's source address each time
      //
      // Note that the destpan address is not checked before ack'ing.
      // To add in the destpan check, increase SACK_HEADER_LENGTH by 2 to
      // include reading in the destpan as part of the ack check, and
      // add the necessary logic to the horrendous if-statement below to
      // check the destpan.  Finally, add in a destpan address to the ack
      // frame if you want and set/check it appropriately.
      //
      // Finally, the length of the packet must be at least the size of
      // a TinyOS header for us to acknowledge it.
     
      if(call BlazeConfig.isAutoAckEnabled[ m_id ]()) {
        
        if (((( header->fcf >> IEEE154_FCF_ACK_REQ ) & 0x01) == 1)
            && ((header->dest == call ActiveMessageAddress.amAddress())
                || (header->dest == AM_BROADCAST_ADDR))
            && ((( header->fcf >> IEEE154_FCF_FRAME_TYPE ) & 7) == IEEE154_TYPE_DATA)
            && (header->length >= sizeof(blaze_header_t) - 1)) {
          // CSn flippage cuts off our FIFO; SACK and begin reading again
          
          acknowledgement.dest = header->src;
          acknowledgement.dsn = header->dsn;
          acknowledgement.src = call ActiveMessageAddress.amAddress();
  
          call AckSend.load[ m_id ](&acknowledgement);
          // Continues at AckSend.loadDone() and AckSend.sendDone()
          return;
        }
      }
      
      // Add 2 for the status bytes
      call RXFIFO.beginRead(buf + 1 + SACK_HEADER_LENGTH, 
            rxFrameLength - SACK_HEADER_LENGTH + 2);
      break;
      
    case S_RX_PAYLOAD:
      call Csn.set[ id ]();
            
      // The FCF_FRAME_TYPE bit in the FCF byte tells us if this is an ack or 
      // data.  If it's data, make sure it meets the minimum size requirement.
      if ((( header->fcf >> IEEE154_FCF_FRAME_TYPE ) & 7) == IEEE154_TYPE_ACK) {
        signal AckReceive.receive( header->src, header->dest, header->dsn );
        cleanUp();
        
      } else if(rxFrameLength >= sizeof(blaze_header_t) - 1) {
        // IEEE_TYPE_DATA frame
        post receiveDone();
        
      } else {
        // Didn't meet the minimum size requirement
        cleanUp();
      }
      break;
      
      
    default:
      break;
    }
  }

  async event void RXFIFO.writeDone( uint8_t* tx_buf, uint8_t tx_len, error_t error ) {
  }  
  

  /***************** ActiveMessageAddress Events ****************/
  async event void ActiveMessageAddress.changed() {
  }
  
  /***************** BlazeConfig Events ****************/
  event void BlazeConfig.commitDone[radio_id_t id]() {
  }
  
  /***************** Tasks and Functions ****************/
  task void receiveDone() {
    blaze_metadata_t *metadata = call BlazePacketBody.getMetadata( m_msg );
    uint8_t *buf = (uint8_t*) call BlazePacketBody.getHeader( m_msg );
    uint8_t rxFrameLength = buf[0];
    message_t *atomicMsg;
    uint8_t atomicId;
    
    atomic atomicId = m_id;
    
    // Note the correct CRC result is stored in the MSB of the LQI
    metadata->rssi = buf[ rxFrameLength + 1 ];
    metadata->lqi = buf[ rxFrameLength + 2 ];
    
    atomicMsg = signal Receive.receive[atomicId]( m_msg, m_msg->data, rxFrameLength );
    
    if(atomicMsg != NULL) {
      atomic m_msg = atomicMsg;
    } else {
      atomic m_msg = &myMsg;
    }
    
    cleanUp();
  }
  
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
    //call Pins.set65();
    call RXFIFO.beginRead(msg, 1);
  }
  
  void failReceive() {
    uint8_t state;
    //call Pins.set66();
    call SIDLE.strobe();
    call SFRX.strobe();
    state = call RadioStatus.getRadioStatus();
    if(state == BLAZE_S_TXFIFO_UNDERFLOW) {
      call SIDLE.strobe();
      call SFTX.strobe();
    }

    call SRX.strobe();
    //call Pins.clr66();
    cleanUp();
  }
  
  /**
   * Clean up after a receive
   */
  void cleanUp() {
    uint8_t id;
    uint8_t localPendingRx;
    atomic id = m_id;
    
    
    call Csn.set[ id ]();
    //call RxIo.makeInput[id]();
   
    if(call RxIo.get[id]()) {
      // The GPO Rx line hasn't gone low, so there is more to receive.
      call State.forceState(S_RX_LENGTH);
      receive();
      return;
      
    } else {
      atomic localPendingRx = pendingRadioRx;
      if(localPendingRx != NO_RADIO_PENDING) {
        // Switch over to the other radio
        atomic m_id = pendingRadioRx;
        atomic pendingRadioRx = NO_RADIO_PENDING;
        
        // Now re-enable interrupts on the radio we were previously servicing
        call RxInterrupt.enableRisingEdge[id]();
        call State.forceState(S_RX_LENGTH);
        receive();
        return;
      }
      
      // Re-enable the RX interrupt on this radio
      call State.toIdle();
      call Resource.release();
      call RxInterrupt.enableRisingEdge[id]();
    }
  }
  
  /***************** Defaults ****************/
  default event message_t *Receive.receive[ radio_id_t id ](message_t* msg, void* payload, uint8_t len){
    return msg;
  }
  
  default async event void AckReceive.receive( am_addr_t source, am_addr_t destination, uint8_t dsn ) {
  }
  
    
  default async command error_t AckSend.load[ radio_id_t id ](void *msg) {
    return FAIL;
  }
  
  default async command error_t AckSend.send[ radio_id_t id ]() {
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
  
  default command error_t BlazeConfig.setFrequencyKhz[ radio_id_t id ]( uint32_t freqKhz ) {
    return FAIL;
  }
  
  default command uint32_t BlazeConfig.getFrequencyKhz[ radio_id_t id ]() {
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
 
}

