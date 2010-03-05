/**
 * TODO THIS NEEDS TESTING
 */
 
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
 * The throttle on the SPI bus lets us transmit packets that are greater than 
 * 62 bytes.
 * 
 * @author David Moss
 */

#include "Blaze.h"

module FifoThrottleP {
  provides {
    interface BlazeFifo[radio_id_t radioId];
  }
  
  uses {
    interface GeneralIO as Csn[radio_id_t radioId];
    
    interface BlazeFifo as RXFIFO;
    interface BlazeFifo as TXFIFO;
    interface BlazeRegister as RXBYTES;
    interface BlazeRegister as TXBYTES;
    
    interface Leds;
  }
}

implementation {
  
  uint8_t *myData;
  
  uint8_t total;
  
  uint8_t myLength;
  
  radio_id_t myRadio;
  
  uint8_t state;
  
  enum { 
    S_IDLE,
    S_WRITING,
    S_READING,
  };
  
  enum {
    MAX_FIFO_BYTES = 64,
    MINIMUM_THRESHOLD = 10,
  };
  
  /***************** Prototypes ****************/
  task void waitForAvailable();
  uint8_t bytesAvailable();
  
  error_t writeData(uint8_t maxBytes);
  error_t readData(uint8_t maxBytes);
    
  /***************** BlazeFifo Commands ****************/
  async command blaze_status_t BlazeFifo.beginRead[radio_id_t radioId]( uint8_t* data, uint8_t length ) {
    myRadio = radioId;
    myData = data;
    total = 0;
    myLength = length;
    state = S_READING;
    
    //call Leds.led0On();
    
    return readData(MAX_FIFO_BYTES);
  }
  
  async command blaze_status_t BlazeFifo.write[radio_id_t radioId]( uint8_t* data, uint8_t length ) {
    myRadio = radioId;
    myData = data;
    total = 0;
    myLength = length;
    state = S_WRITING;
    
    //call Leds.led1On();
    
    return writeData(MAX_FIFO_BYTES);
  }
  
  async command error_t BlazeFifo.continueRead[radio_id_t radioId]( uint8_t* data, uint8_t length ) {
    return FAIL;
  }
  
  /***************** FIFO Events ****************/
  async event void RXFIFO.readDone( uint8_t* data, uint8_t length, error_t error ) {
    total += length;
    
    if(total < myLength) {
      post waitForAvailable();
      
    } else {
      //call Leds.led0Off();
      signal BlazeFifo.readDone[myRadio](myData, total, error);
    }
  }
  
  async event void TXFIFO.writeDone( uint8_t* data, uint8_t length, error_t error ) { 
    total += length;
    
    if(total < myLength) {
      post waitForAvailable();
      
    } else {
      //call Leds.led1Off();
      signal BlazeFifo.writeDone[myRadio](myData, total, error);
    }
  }
   
  async event void RXFIFO.writeDone(uint8_t *data, uint8_t length, error_t error) {}
  async event void TXFIFO.readDone(uint8_t *data, uint8_t length, error_t error) {}
  
  /***************** Tasks and Functions ****************/
  /**
   * Wait for bytes to be available for reading or writing in the FIFO
   * before reading or writing.  We have a task here so we don't overflow
   * our stack with recursive loops.
   */
  task void waitForAvailable() {
    uint8_t available;
    while((available = bytesAvailable()) < MINIMUM_THRESHOLD);
    
    if(state == S_READING) {
      readData(available);
      
    } else {
      writeData(available);
    }
  }
  
  /**
   * @return the number of bytes available for reading, or the number of bytes
   *    available for writing
   */
  uint8_t bytesAvailable() {
    uint8_t available;
    call Csn.set[myRadio]();
    call Csn.clr[myRadio]();
    
    if(state == S_READING) {
      call RXBYTES.read(&available);
    } else {
      call TXBYTES.read(&available);
    }
    
    available &= 0x7F;
    
    if(state == S_READING) {
      return available;
    } else {
      return 64 - available;
    }
  }
  
  /**
   * Write data as much data as we can
   * @param maxBytes the max number of bytes we are allowed to write this time
   */
  error_t writeData(uint8_t maxBytes) {
    uint8_t amountToWrite;
    
    if(myLength - total > maxBytes) {
      amountToWrite = maxBytes;

    } else {
      amountToWrite = myLength - total;
    }
    
    return call TXFIFO.write(myData + total, amountToWrite);
  }
  
  /**
   * Read as much data as we can
   * @param maxBytes the max number of bytes we are allowed to read this time
   */
  error_t readData(uint8_t maxBytes) {
    uint8_t amountToWrite;
    
    if(myLength - total > maxBytes) {
      amountToWrite = maxBytes;

    } else {
      amountToWrite = myLength - total;
    }
    
    return call RXFIFO.beginRead(myData + total, amountToWrite);
  }
  
  /***************** Defaults ****************/
  default async event void BlazeFifo.readDone[radio_id_t radioId]( uint8_t* data, uint8_t length, error_t error ) { }
  default async event void BlazeFifo.writeDone[radio_id_t radioId]( uint8_t* data, uint8_t length, error_t error ) { }
  
  default async command void Csn.set[ radio_id_t id ](){}
  default async command void Csn.clr[ radio_id_t id ](){}
  default async command void Csn.toggle[ radio_id_t id ](){}
  default async command void Csn.makeInput[ radio_id_t id ](){}
  default async command void Csn.makeOutput[ radio_id_t id ](){}
  
}

