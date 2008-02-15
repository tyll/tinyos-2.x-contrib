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
#include "Ctp.h"
#include "CtpWrapper.h"
module CtpWrapperImplP {
  provides {
    interface Receive as Receive[uint8_t id];
    interface Intercept as Intercept[uint8_t id];
    interface Get<am_id_t> as GetAMID;
    interface Get<am_addr_t> as GetParent;
  } uses {
    interface Boot;
    interface StdControl as SubStdControl;
    interface Receive as SubReceive;
    interface Intercept as SubIntercept;
    interface CtpInfo;
  }
} implementation {

  event void Boot.booted()
  {
    call SubStdControl.start();
  }

  event message_t* SubReceive.receive(message_t* msg, void* payload, uint8_t len)
  {
    return signal Receive.receive[0](msg, payload, len);
  }

  default event message_t* Receive.receive[uint8_t id](message_t* msg, void* payload, uint8_t len)
  {
    return msg;
  }

  command am_id_t GetAMID.get(){ return AM_CTP_DATA;}
  command am_addr_t GetParent.get()
  {
    uint16_t val;
    call CtpInfo.getParent(&val);
    return val;
  }

  default event bool Intercept.forward[uint8_t id](message_t* msg, void* payload, uint8_t len)
  {
    return TRUE;
  }

  event bool SubIntercept.forward(message_t* msg, void* payload, uint8_t len)
  {
    return signal Intercept.forward[0](msg, payload, len);
  }
}

