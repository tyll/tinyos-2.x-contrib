/*
 * Copyright (c) 2008 Rincon Research Corporation
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
 * The SyncUartStream interface is for the purpose of converting the
 * async UartStream into a synchronous interface.  This can be used
 * in applications where the baud rate is slow enough and the
 * application is of low enough priority that dropped bytes will be
 * rare and not effect a critical application.
 * 
 * @author Danny Park
 */

module SyncUartStreamP {
  uses interface UartStream;
  provides interface SyncUartStream;
}
implementation {
  uint8_t currentByte;
  
  task void receivedByteTask();
  task void droppedByteTask();
  
  async event void UartStream.receivedByte( uint8_t byte ) {
    /*
     * This statement will drop the previous byte if it has
     * not been signalled to an upper layer already.
     */
    atomic currentByte = byte;
    
    /*
      If receivedByteTask is not successfully posted that means
      that it has not run since that last post and that the
      previous byte was dropped with the above atomic statement.
    */
    if(post receivedByteTask() != SUCCESS) {
      post droppedByteTask();
    }
  }
  
  async event void UartStream.sendDone( uint8_t* buf, uint16_t len, error_t error ) {}
  
  async event void UartStream.receiveDone( uint8_t* buf, uint16_t len, error_t error ) {}
  
  task void receivedByteTask() {
    uint8_t local_byte;
    
    atomic local_byte = currentByte;
    
    signal SyncUartStream.receivedByte(local_byte);
  }
  
  /**
   * droppedByte is signalled whenever a byte is missed because of
   * the transfer from async to sync.  If bytes are being received
   * fast enough that multiple bytes are dropped before the
   * droppedByte event is signalled the event will still only be
   * signalled once.
   */
  task void droppedByteTask() {
    signal SyncUartStream.droppedByte();
  }
}
