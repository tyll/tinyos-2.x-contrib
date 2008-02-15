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
generic module PSNullProtocolC() {
  provides {
    interface RootControl;
    interface Send;
    interface Receive;
    interface Intercept;
    interface Packet;
    interface Get<am_id_t> as GetAMID;
  }
} implementation {

  command error_t RootControl.setRoot(){return SUCCESS;}
  command error_t RootControl.unsetRoot(){return SUCCESS;}
  command bool RootControl.isRoot(){return SUCCESS;}
  command error_t Send.send(message_t* msg, uint8_t len)
  {
    signal Send.sendDone(msg, SUCCESS);
    return SUCCESS;
  }
  command error_t Send.cancel(message_t* msg)
  {
    return SUCCESS;
  }
  command uint8_t Send.maxPayloadLength()
  {
    return TOSH_DATA_LENGTH;
  }
  command void* Send.getPayload(message_t* msg)
  {
    return msg->data;
  }
  command void* Receive.getPayload(message_t* msg, uint8_t* len)
  {
    *len = TOSH_DATA_LENGTH;
    return msg->data;
  }
  command uint8_t Receive.payloadLength(message_t* msg)
  {
    return TOSH_DATA_LENGTH;
  }

  command void Packet.clear(message_t* msg){}
  command uint8_t Packet.payloadLength(message_t* msg){return TOSH_DATA_LENGTH;}
  command void Packet.setPayloadLength(message_t* msg, uint8_t len){}
  command uint8_t Packet.maxPayloadLength(){return TOSH_DATA_LENGTH;}
  command void* Packet.getPayload(message_t* msg, uint8_t* len)
  {
    *len = TOSH_DATA_LENGTH;
    return msg->data;
  }
  command am_id_t GetAMID.get()
  {
    return 200;
  } 
}

