/* 
 * Copyright (c) 2006, Technische Universitaet Berlin
 * All rights reserved.
 *
 * Redistribution and use in source and binary forms, with or without
 * modification, are permitted provided that the following conditions
 * are met:
 * - Redistributions of source code must retain the above copyright notice,
 *   this list of conditions and the following disclaimer.
 * - Redistributions in binary form must reproduce the above copyright
 *   notice, this list of conditions and the following disclaimer in the
 *   documentation and/or other materials provided with the distribution.
 * - Neither the name of the Technische Universitaet Berlin nor the names
 *   of its contributors may be used to endorse or promote products derived
 *   from this software without specific prior written permission.
 *
 * THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS
 * "AS IS" AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT
 * LIMITED TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR
 * A PARTICULAR PURPOSE ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT
 * OWNER OR CONTRIBUTORS BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL,
 * SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED
 * TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA,
 * OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY
 * OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT
 * (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE
 * USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
 *
 * - Revision -------------------------------------------------------------
 * $Revision$
 * $Date$
 * @author: Jan Hauer <hauer@tkn.tu-berlin.de>
 * ========================================================================
 */

#include "StdPublisher.h"
#include "TinyCOPS.h"
#include "Attributes.h"
generic module TrickleWrapperC(typedef buffer_t)
{
  provides {
    interface Packet;
    interface Send as SendSubscription;
    interface Receive as ReceiveSubscription;
  }
  uses {
    interface Boot;
    interface StdControl as SubStdControl;
    interface AMPacket;
    interface DisseminationValue<buffer_t>;
    interface DisseminationUpdate<buffer_t>;
  }
} implementation {
  
  buffer_t tableEntry;
  message_t buf;
  message_t *bufPtr = &buf;

  event void Boot.booted()
  {
    call SubStdControl.start();
  }  
  
  command error_t SendSubscription.send(message_t* msg, uint8_t len)
  {
    call DisseminationUpdate.change((buffer_t*) msg->data);
    signal SendSubscription.sendDone(msg, SUCCESS);
    return SUCCESS;
  }
  command error_t SendSubscription.cancel(message_t* msg){ return FAIL; }
  command uint8_t SendSubscription.maxPayloadLength(){ return sizeof(buffer_t); }
  command void* SendSubscription.getPayload(message_t* msg, uint8_t len)
  { 
    if (len > call SendSubscription.maxPayloadLength())
      return 0;
    else
      return msg->data;
  }
    
  event void DisseminationValue.changed()
  {
    const subscription_t *subscription = (const subscription_t *) call DisseminationValue.get();
    uint8_t size = MAX_SUBSCRIPTION_SIZE;
    dbg("TrickleWrapper", "Received subscription: source = %d client = %d\n",subscription->source,subscription->clientID);
    memcpy(bufPtr->data, subscription, size);
    call AMPacket.setType(bufPtr, AM_DISSEMINATION_MESSAGE);
    bufPtr = signal ReceiveSubscription.receive(bufPtr, bufPtr->data, size);
  }

  default event message_t* ReceiveSubscription.receive(
      message_t* msg, void* payload, uint8_t len)
  {
    return msg;
  }

  command void Packet.clear(message_t* msg){ memset(msg, 0, sizeof(buffer_t)); }
  command uint8_t Packet.payloadLength(message_t* msg){ return sizeof(buffer_t);}
  command void Packet.setPayloadLength(message_t* msg, uint8_t len){return;}
  command uint8_t Packet.maxPayloadLength(){ return sizeof(buffer_t);}
  command void* Packet.getPayload(message_t* msg, uint8_t len)
  {
    if (len > call SendSubscription.maxPayloadLength())
      return 0;
    else
      return msg->data;
  }
  
}

