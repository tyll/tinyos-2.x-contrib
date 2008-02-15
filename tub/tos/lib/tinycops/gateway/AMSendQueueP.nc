/* 
 * Copyright (c) 2007, Technische Universitaet Berlin
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
#include "AMSendQueue.h"
generic module AMSendQueueP(uint8_t entries)
{
  provides interface AMSend;
  uses {
    interface Boot;
    interface Queue<message_t*> as MsgQueue;
    interface Queue<am_squeue_entry_t> as SendQueue;
    interface AMSend as SubSend;
  }
} implementation {
  message_t msgPool[entries];

  event void Boot.booted()
  {
    uint8_t i;
    for (i=0; i<entries; i++)
      call MsgQueue.enqueue(&msgPool[i]);
  }

  void task sendTask()
  {
    if (call SendQueue.size()){
      am_squeue_entry_t squeue_entry = call SendQueue.head();
      call SubSend.send(squeue_entry.addr, squeue_entry.msg, squeue_entry.len);
    }
  }

  command error_t AMSend.send(am_addr_t addr, message_t* msg, uint8_t len)
  {
    if (call MsgQueue.size()){
      am_squeue_entry_t squeue_entry;
      message_t* m = call MsgQueue.dequeue();
      memcpy(m, msg, ((uint8_t*) msg->data - (uint8_t*) msg) + len);
      squeue_entry.addr = addr;
      squeue_entry.msg = m;
      squeue_entry.len = len;
      call SendQueue.enqueue(squeue_entry);
      post sendTask();
      signal AMSend.sendDone(msg, SUCCESS); // move into a separate task?
      return SUCCESS;
    }
    return FAIL;
  }

  event void SubSend.sendDone(message_t* msg, error_t error)
  {
    if (error == SUCCESS){
      am_squeue_entry_t squeue_entry = call SendQueue.dequeue();
      call MsgQueue.enqueue(squeue_entry.msg);
    }
    if (call SendQueue.size())
      post sendTask();
  }

  command error_t AMSend.cancel(message_t* msg)
  { 
    return FAIL; // TODO
  }

  command uint8_t AMSend.maxPayloadLength()
  {
    return call SubSend.maxPayloadLength();
  }

  command void* AMSend.getPayload(message_t* msg, uint8_t len)
  {
    return call SubSend.getPayload(msg,len);
  }
}
    
