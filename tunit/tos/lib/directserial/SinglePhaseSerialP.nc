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

#include "AM.h"
#include "message.h"
#include "crc.h"
#include "Serial.h"


/**
 * Send a message single phase over the serial port.  Signals sendDone before
 * it even has the opportunity to return SUCCESS. 
 * @author David Moss
 */
module SinglePhaseSerialP {
  provides {
    interface Send;
  }
  
  uses {
    interface UartByte;
  }
}

implementation {

  /** CRC of the outbound packet */
  nx_uint16_t myCrc;
  
  /***************** Prototypes ****************/
  void send(uint8_t byte, bool crc);
  void sendEscaped(uint8_t byte, bool crc);
  serial_header_t* getHeader(message_t* msg);
  
  /***************** Send Commands ****************/
  command error_t Send.send(message_t* msg, uint8_t len) {
    int i;
    uint8_t *header = (uint8_t *) getHeader(msg);
    uint8_t *payload = (uint8_t *) msg->data;
    
    // SYNC
    send(0x7E, FALSE);
    
    // HDLC HEADER
    // Begin CRC checking after the sync byte is sent.
    myCrc = 0;
    
    // No Ack:
    send(0x45, TRUE);
    
    // TOS_SERIAL_ACTIVE_MESSAGE type:
    send(0x0, TRUE);
    
    
    // HEADER
    for(i = 0; i < sizeof(serial_header_t); i++) {
      sendEscaped((uint8_t) *(header), TRUE);
      header++;
    }
    
    // PAYLOAD
    for(i = 0; i < len; i++) {
      sendEscaped((uint8_t) *(payload), TRUE);
      payload++;
    }
    
    // CRC
    sendEscaped(myCrc, FALSE);
    sendEscaped(myCrc >> 8, FALSE);
    
    // SYNC
    send(0x7E, FALSE);
    
    // DONE
    signal Send.sendDone(msg, SUCCESS);
    return SUCCESS;
  }

  command error_t Send.cancel(message_t* msg) {
    return FAIL;
  }

  command uint8_t Send.maxPayloadLength() {
    return TOSH_DATA_LENGTH;
  }

  command void *Send.getPayload(message_t* msg, uint8_t len) {
    if(len <= TOSH_DATA_LENGTH) {
      return msg->data;
    } else {
      return NULL;
    }
  }
  
 
  /***************** Functions ****************/ 
  /**
   * Escape bytes that affect HDLC, and send the data
   *  0x7E becomes 0x7D 0x5E
   *  0x7D becomes 0x7D 0x5D
   * 
   * @param byte the byte to send escaped
   * @param crc add this byte to our running crc
   */
  void sendEscaped(uint8_t byte, bool crc) {
    if(byte == 0x7E) {
      send(0x7D, crc);
      send(0x5E, crc);
      
    } else if(byte == 0x7D) {
      send(0x7D, crc);
      send(0x5D, crc);
      
    } else {
      send(byte, crc);
    }
  }
  
  /**
   * Send a byte of data, unescaped
   * @param byte the byte to send escaped
   * @param crc add this byte to our running crc
   */
  void send(uint8_t byte, bool crc) {
    if(crc) {
      myCrc = crcByte(myCrc, byte);
    }
    
    call UartByte.send(byte);
  }
  
  serial_header_t* getHeader(message_t* msg) {
    return (serial_header_t*)(msg->data - sizeof(serial_header_t));
  }

}


