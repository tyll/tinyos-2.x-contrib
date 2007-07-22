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
 
#include "Link_TUnitProcessing.h"
#include "crc.h"
#include "Serial.h"

/**
 * @author David Moss
 */
module TestUartP {
  uses {
    interface TestCase as TestSendStream;
    interface UartStream;
  }
}

implementation {

  message_t myMsg;

  uint8_t streamBuffer[50];
  
  uint8_t *nextByte;
  
  nx_uint16_t myCrc;
  
    
  /***************** Prototypes ****************/
  void send(uint8_t byte);
  serial_header_t* getHeader(message_t* msg);
  
  /***************** TestSendStream Events ****************/
  event void TestSendStream.run() {
    int i;
    serial_header_t *serialHeader = getHeader(&myMsg);
    uint8_t *header = (uint8_t *) getHeader(&myMsg);
    uint8_t *payload = (uint8_t *) (&myMsg)->data;
  	TUnitProcessingMsg *tunitMsg = (TUnitProcessingMsg *) payload;

    uint16_t finalCrc;
    
  	nextByte = streamBuffer;
  	
  	serialHeader->dest = 0xFFFF;
  	serialHeader->src = 0;
  	serialHeader->length = sizeof(TUnitProcessingMsg);
  	serialHeader->group = TOS_AM_GROUP;
  	serialHeader->type = AM_TUNITPROCESSINGMSG;
  	
  	tunitMsg->cmd = TUNITPROCESSING_EVENT_TESTRESULT_SUCCESS;
  	tunitMsg->id = 0;
  	tunitMsg->lastMsg = TRUE;
  	tunitMsg->failMsgLength = 0;
  	
  	
    // SYNC
    send(0x7E);
    
    // HDLC HEADER
    // Begin CRC checking after the sync byte is sent.
    myCrc = 0;
    
    // No Ack:
    send(0x45);
    
    // TOS_SERIAL_ACTIVE_MESSAGE type:
    send(0x0);
    
    
    // HEADER
    for(i = 0; i < sizeof(serial_header_t); i++) {
      send((uint8_t) *(header));
      header++;
    }
    
    // PAYLOAD
    for(i = 0; i < sizeof(TUnitProcessingMsg); i++) {
      send((uint8_t) *(payload));
      payload++;
    }
    
    finalCrc = myCrc;
    
    // CRC
    send(finalCrc);
    send(finalCrc >> 8);
    
    // SYNC
    send(0x7E);
    
  	
  	call UartStream.send(streamBuffer, nextByte - streamBuffer);
  }
  
  /****************** UartStream Events ***************/
  async event void UartStream.sendDone( uint8_t* buf, uint16_t len, error_t error ) {
    call TestSendStream.done();
  }

  async event void UartStream.receivedByte( uint8_t byte ) {
  }

  async event void UartStream.receiveDone( uint8_t* buf, uint16_t len, error_t error ) {
  }
  
  /***************** Functions ****************/
  void send(uint8_t byte) {
    myCrc = crcByte(myCrc, byte);
    *nextByte = byte;
    nextByte++;
  }
  
  serial_header_t* getHeader(message_t* msg) {
    return (serial_header_t*)(msg->data - sizeof(serial_header_t));
  }
  
  
}

