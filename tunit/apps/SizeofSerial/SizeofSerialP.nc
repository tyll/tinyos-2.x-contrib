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
 

module SizeofSerialP {
  uses {
    interface Boot;
    interface AMSend as SerialEventSend;
    interface Receive as SerialReceive;
    interface SplitControl as SerialSplitControl;
  }
}

implementation {
  
  /***************** Prototypes ****************/
  void no_op();
  
  /***************** Boot Events ****************/
  event void Boot.booted() {
    call SerialSplitControl.start();
  }
  
  /***************** SerialSplitControl Events ****************/
  event void SerialSplitControl.startDone(error_t error) {
  }
  
  event void SerialSplitControl.stopDone(error_t error) {
  }
  
  /***************** Receive Events ****************/
  event message_t *SerialReceive.receive(message_t *msg, void *payload, uint8_t len) {
    no_op();
    return msg;
  }
  
  /***************** Send Events ****************/
  event void SerialEventSend.sendDone(message_t *msg, error_t error) {
    no_op();
  }
  
  
  /***************** Tasks ****************/  
  task void sendEventMsg() {
    message_t myMsg;
    if(call SerialEventSend.send(0, &myMsg, 0) != SUCCESS) {
      post sendEventMsg();
    }
  }
  
  
  /***************** Functions ****************/
  void no_op() {
    int i;
    i = 0;
    return;
  }
}
