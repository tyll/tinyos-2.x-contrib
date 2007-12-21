/*
 * Copyright (c) 2007 nxtmote project
 * All rights reserved. 
 * Redistribution and use in source and binary forms, with or without
 * modification, are permitted provided that the following conditions are
 * met:
 *	Redistributions of source code must retain the above copyright
 * notice, this list of conditions and the following disclaimer.
 *	Redistributions in binary form must reproduce the above copyright
 * notice, this list of conditions and the following disclaimer in the
 * documentation and/or other materials provided with the distribution.
 *  
 *   Neither the name of nxtmote project nor the names of its
 * contributors may be used to endorse or promote products derived from
 * this software without specific prior written permission.
 *
 * THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS
 * ``AS IS'' AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT
 * LIMITED TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR
 * A PARTICULAR PURPOSE ARE DISCLAIMED.  IN NO EVENT SHALL THE ARCHED
 * ROCK OR ITS CONTRIBUTORS BE LIABLE FOR ANY DIRECT, INDIRECT,
 * INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING,
 * BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS
 * OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND
 * ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR
 * TORT (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE
 * USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH
 * DAMAGE.
 */
/**
 * BlueCore 4 Hal Interface.
 * @author Rasmus Ulslev Pedersen
 * Based on NXT files.
 */
 
#include "c_comm.h"
#include "c_comm.iom" 
 
interface HalBt {

  /**
   * Send a message.
   * 
   * @param msg  Message to send.
   */
  command error_t sendMsg(uint8_t* msg);
  
  command UWORD cCommReq(UBYTE Cmd, UBYTE Param1, UBYTE Param2, UBYTE Param3, UBYTE *pName, UWORD *pRetVal);
  
  //Use with care
  command void getFullControl(VARSCOMM** ppVarsComm, IOMAPCOMM** ppIOMapComm);
  
  command UBYTE getNxtIndex();
  
  event void btUpdateEvent(UBYTE ActiveUpdate, UBYTE UpdateState);
  
  event void dataReceived();
  
  //Make method for cCommPinCode
  
}
