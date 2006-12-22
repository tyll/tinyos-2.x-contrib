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
 * ARCHED ROCK OR ITS CONTRIBUTORS BE LIABLE FOR ANY DIRECT, INDIRECT,
 * INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES
 * (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR
 * SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION)
 * HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT,
 * STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE)
 * ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED
 * OF THE POSSIBILITY OF SUCH DAMAGE
 */
 
 
/**
 * Internal Flash Viewer application
 * Allows the user to view a hex map of the internal flash from the PC.
 * @author David Moss
 */
 
#include "InternalFlashViewer.h"

module InternalFlashViewerP {
  uses {
    interface Boot;
    interface Leds;
    interface State;
    interface AMSend;
    interface Receive;
    interface Packet;
    interface SplitControl as SerialControl;
    interface DirectStorage;
    interface MessagePool;
  }
}

implementation { 
  
  /** Outbound allocated payload */
  ViewerMsg *outMsg;
  
  enum { 
    S_IDLE = 0,
    S_BUSY,
  };

  /***************** Prototypes ****************/
  /** Allocate a new message to send */
  bool newMessage();
  
  /** Execute the received command */
  void execute(ViewerMsg *message);
  
  /** Send a message over the method the command was received */
  void sendMessage();
  
  /***************** Boot Events ****************/
  event void Boot.booted() {
    call SerialControl.start();
  }
  
  /***************** SerialControl Events ****************/
  event void SerialControl.startDone(error_t error) {
  }
  
  event void SerialControl.stopDone(error_t error) {
  }
  
  
  /***************** Send Events ****************/
  event void AMSend.sendDone(message_t *msg, error_t error) {
    call State.toIdle();
  }
  
  /***************** Receive Events ****************/
  /**
   * Received a message over UART.  This is just a forward from
   * UARTComm.ReceiveMsg
   */
  event message_t *Receive.receive(message_t* msg, void* payload, uint8_t len) {
    ViewerMsg *inMsg = (ViewerMsg *) payload;
    if(inMsg->cmd > 9) {
      // This is a reply from another mote
      return msg;
    }
    
    if(call State.requestState(S_BUSY) != SUCCESS) {
      return msg;
    }
    
    execute(inMsg);
    return msg;
  }

  /***************** DirectStorage Events ****************/
  /**
   * Read is complete
   * @param addr - the address to read from
   * @param *buf - the buffer to read into
   * @param len - the amount to read
   * @return SUCCESS if the bytes will be read
   */
  event void DirectStorage.readDone(uint32_t addr, void *buf, uint32_t len, error_t error) {
    if(!error) {
      outMsg->cmd = REPLY_READ;
    } else {
      outMsg->cmd = REPLY_READ_FAILED;
    }
    outMsg->addr = addr;
    outMsg->len = len;
    sendMessage();
  }
  
  /**
   * Write is complete
   * @param addr - the address to write to
   * @param *buf - the buffer to write from
   * @param len - the amount to write
   * @return SUCCESS if the bytes will be written
   */
  event void DirectStorage.writeDone(uint32_t addr, void *buf, uint32_t len, error_t error) {
    if(!error) {
      outMsg->cmd = REPLY_WRITE;
    } else {
      outMsg->cmd = REPLY_WRITE_FAILED;
    }
    outMsg->addr = addr;
    outMsg->len = len;
    sendMessage();
  }
  
  /**
   * Erase is complete
   * @param sector - the sector id to erase
   * @return SUCCESS if the sector will be erased
   */
  event void DirectStorage.eraseDone(uint16_t sector, error_t error) {
    if(!error) {
      outMsg->cmd = REPLY_ERASE;
    } else {
      outMsg->cmd = REPLY_ERASE_FAILED;
    }
    outMsg->addr = sector;
    sendMessage();
  }
  
  /**
   * Flush is complete
   * @param error - SUCCESS if the flash was flushed
   */
  event void DirectStorage.flushDone(error_t error) {
    if(!error) {
      outMsg->cmd = REPLY_FLUSH;
    } else {
      outMsg->cmd = REPLY_FLUSH_FAILED;
    }
    sendMessage();
  }
  
  /**
   * CRC-16 is computed
   * @param crc - the computed CRC.
   * @param addr - the address to start the CRC computation
   * @param len - the amount of data to obtain the CRC for
   * @return SUCCESS if the CRC will be computed.
   */
  event void DirectStorage.crcDone(uint16_t crc, uint32_t addr, uint32_t len, error_t error) {
    if(!error) {
      outMsg->cmd = REPLY_CRC;
    } else {
      outMsg->cmd = REPLY_CRC_FAILED;
    }
    outMsg->len = crc;
    sendMessage();
  }
  
  /***************** Functions ****************/
  /**
   * Allocate and define a new message
   */
  bool newMessage() { 
    if(call MessagePool.getMessage() != NULL) {
      outMsg = (ViewerMsg *) call MessagePool.getPayload();
      memset(outMsg, 0x0, sizeof(ViewerMsg));
      return TRUE;
    }
    return FALSE;
  }
  
  /**
   * Send the message over the communications method the command
   * was received
   */
  void sendMessage() {
    call AMSend.send(0, call MessagePool.getMessage(), sizeof(ViewerMsg));
  }
  
  /**
   * Execute a command 
   */
  void execute(ViewerMsg *message) {
    if(!newMessage()) {
      call State.toIdle();
      return;
    }
    
    if(message->len > call Packet.maxPayloadLength()) {
      message->len = call Packet.maxPayloadLength();
    }
        
    switch(message->cmd) {
      case CMD_READ:
        if(call DirectStorage.read(message->addr, outMsg->data, message->len) 
            != SUCCESS) {
          outMsg->cmd = REPLY_READ_CALL_FAILED;
          sendMessage();
        }
        break;
        
      case CMD_WRITE:
        memcpy(outMsg->data, message->data, message->len);
        if(call DirectStorage.write(message->addr, message->data, message->len) 
            != SUCCESS) {
          outMsg->cmd = REPLY_WRITE_CALL_FAILED;
          sendMessage();
        }
        break;
      
      case CMD_ERASE:
        if(call DirectStorage.erase(message->addr) != SUCCESS) {
          outMsg->addr = message->addr;
          outMsg->cmd = REPLY_ERASE_CALL_FAILED;
          sendMessage();
        }
        break;
        
      case CMD_FLUSH:
        if(call DirectStorage.flush() != SUCCESS) {
          outMsg->cmd = REPLY_FLUSH_CALL_FAILED;
          sendMessage();
        }
        break;
        
     case CMD_CRC:
        if(call DirectStorage.crc(message->addr, message->len, 0) != SUCCESS) {
          outMsg->cmd = REPLY_CRC_CALL_FAILED;
          sendMessage();
        }
        break;
        
      case CMD_PING:
        outMsg->cmd = REPLY_PING;
        sendMessage();
        break;
        
      default:
        call State.toIdle();
    }
  }
}


