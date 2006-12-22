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
 * Progress Indicator
 * The progress indicator uses one AM type for communication, but
 * the listeners on the computer end must listen for their particular
 * application ID through the Progress indicator library.  
 * 
 * @author David Moss
 */
 
#include "Progress.h"

module ProgressP {
  provides {
    interface Progress[app_id_t id];
  }
  
  uses {
    interface Boot;
    interface AMSend;
    interface SplitControl as SerialControl;
    interface State;
  }
}

implementation {
  
  /** The message available to spit out */
  message_t fullProgressMessage;
  
  enum {
    S_IDLE,
    S_BUSY,
  };
  
  /***************** Boot Events *****************/
  event void Boot.booted() {
    call SerialControl.start();
  }
  
  /***************** SerialControl Events ****************/
  event void SerialControl.startDone(error_t error) {
  }
  
  event void SerialControl.stopDone(error_t error) {
  }
  
  
  /***************** Progress Commands ****************/
  /**
   * A task is being updated.
   * @param completed - the amount completed so far
   * @param total - the total amount to do
   */
  command error_t Progress.update[app_id_t id](uint32_t completed, uint32_t total) {
    ProgressMsg *outMsg = (ProgressMsg *) call AMSend.getPayload(&fullProgressMessage);

    if(call State.requestState(S_BUSY) != SUCCESS) {
      return EBUSY;
    }

    outMsg->appId = id;
    
    if(completed > total) {
      // Can't go over 100%
      completed = total;
    }
      
    outMsg->total = total;
    outMsg->completed = completed;
    
    if(call AMSend.send(0, &fullProgressMessage, sizeof(ProgressMsg)) != SUCCESS) {
      call State.toIdle();
      return FAIL;
    }
    
    return SUCCESS;
  }
  
  /***************** AMSend Events ****************/
  event void AMSend.sendDone(message_t *msg, error_t error) {
    call State.toIdle();
  }
   
}


