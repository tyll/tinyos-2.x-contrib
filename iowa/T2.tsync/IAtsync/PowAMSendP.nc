/*
* Copyright (c) 2007 University of Iowa 
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
* - Neither the name of The University of Iowa  nor the names of
*   its contributors may be used to endorse or promote products derived
*   from this software without specific prior written permission.
*
* THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS
* ``AS IS'' AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT
* LIMITED TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS
* FOR A PARTICULAR PURPOSE ARE DISCLAIMED.  IN NO EVENT SHALL STANFORD
* UNIVERSITY OR ITS CONTRIBUTORS BE LIABLE FOR ANY DIRECT, INDIRECT,
* INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES
* (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR
* SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION)
* HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT,
* STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE)
* ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED
* OF THE POSSIBILITY OF SUCH DAMAGE.
*/

/**
 * Timesync suite of interfaces, components, testing tools, and documents.
 * @author Ted Herman
 * Development supported in part by NSF award 0519907. 
 */
//--EOCpr712 (do not remove this line, which terminates copyright include)

#include "Tnbrhood.h"

generic module PowAMSendP(uint8_t mid) { 
  provides interface AMSend; 
  uses {
    interface AMSend as RelaySend;
    interface CC2420Packet;
    interface PowConQS;
    interface Leds;
    }
  }

implementation {
  
  // power control wrapper for AMSend 
  command error_t AMSend.send(
    uint16_t address, message_t* msg, uint8_t length) {
    error_t r;
    if (! (call PowConQS.status()) ) {  
       signal RelaySend.sendDone(msg,SUCCESS);
       return SUCCESS; 
       }
    call CC2420Packet.setPower(msg,CC2420_RADIO_POWER);
    r = call RelaySend.send(address,msg,length);
    if (r == SUCCESS) call PowConQS.setIOPending(TRUE);
    return r;
    }
  command error_t AMSend.cancel(message_t* m) {
    return call RelaySend.cancel(m); }
  command uint8_t AMSend.maxPayloadLength() {
    return call RelaySend.maxPayloadLength(); }
  command void* AMSend.getPayload(message_t* m, uint8_t l) {
    return call RelaySend.getPayload(m,l); }
  // command void* AMSend.getPayload(message_t* m) {
  //    return call RelaySend.getPayload(m); }
  event void RelaySend.sendDone(message_t* m, error_t r) {
    //error_t v;
    call PowConQS.setIOPending(FALSE);
    signal AMSend.sendDone(m,r);
    if ( !(call PowConQS.status()) ) { 
       call PowConQS.startPowerDown();
       }
    }
  default event void AMSend.sendDone(message_t* msg, error_t err) { }
  }

