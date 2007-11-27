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
 * This component determines whether to send a message using the standard
 * BlazeTransmit component or some other low power listening component.
 * 
 * It must be implemented for each type of low power listening to direct
 * messages
 * 
 * @author David Moss
 */
 
#include "Blaze.h"

configuration TransmitArbiterC {
  provides {
    interface AsyncSend[ radio_id_t id ];
  }
  
  uses {
    interface AsyncSend as NoLplSend[ radio_id_t id ];
    interface AsyncSend as LplSend[ radio_id_t id ];
  }
}

implementation {

  /** True if the loaded message was an LPL message */
  bool useLpl = FALSE;
  
  /***************** AsyncSend Commands ****************/
  async command error_t AsyncSend.load[radio_id_t id](void *msg, uint16_t rxInterval) {
    useLpl = (rxInterval > 0);
    
    if(useLpl) {
      return call LplSend.load[id](msg, rxInterval);
    } else {
      return call NoLplSend.load[id](msg, rxInterval);
    }
  }
  
  async command error_t AsyncSend.send[radio_id_t id]() {
    if(useLpl) {
      return call LplSend.send[id]();
    } else {
      return call NoLplSend.send[id]();
    }
  }
  
  /***************** NoLplSend Events ****************/
  async event void NoLplSend.loadDone[radio_id_t id](error_t error) {
  }

  async event void NoLplSend.sendDone[radio_id_t id](error_t error) {
  }
  
  /***************** LplSend Events ****************/
  async event void NoLplSend.loadDone[radio_id_t id](error_t error) {
    signal AsyncSend.loadDone[id](error);
  }

  async event void NoLplSend.sendDone[radio_id_t id](error_t error) {
    signal AsyncSend.sendDone[id](error);
  }
  
  
  /***************** Defaults ****************/
  default async event void AsyncSend.loadDone[radio_id_t id](error_t error) {}

  default async event void AsyncSend.sendDone[radio_id_t id](error_t error) {}
  
}
