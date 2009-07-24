/*
 * Copyright (c) 2009, Vanderbilt University
 * All rights reserved.
 *
 * Permission to use, copy, modify, and distribute this software and its
 * documentation for any purpose, without fee, and without written agreement is
 * hereby granted, provided that the above copyright notice, the following
 * two paragraphs and the author appear in all copies of this software.
 * 
 * IN NO EVENT SHALL THE VANDERBILT UNIVERSITY BE LIABLE TO ANY PARTY FOR
 * DIRECT, INDIRECT, SPECIAL, INCIDENTAL, OR CONSEQUENTIAL DAMAGES ARISING OUT
 * OF THE USE OF THIS SOFTWARE AND ITS DOCUMENTATION, EVEN IF THE VANDERBILT
 * UNIVERSITY HAS BEEN ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
 * 
 * THE VANDERBILT UNIVERSITY SPECIFICALLY DISCLAIMS ANY WARRANTIES,
 * INCLUDING, BUT NOT LIMITED TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY
 * AND FITNESS FOR A PARTICULAR PURPOSE.  THE SOFTWARE PROVIDED HEREUNDER IS
 * ON AN "AS IS" BASIS, AND THE VANDERBILT UNIVERSITY HAS NO OBLIGATION TO
 * PROVIDE MAINTENANCE, SUPPORT, UPDATES, ENHANCEMENTS, OR MODIFICATIONS.
 *
 * Author: Janos Sallai
 */

#include "Dfrf.h"

generic module DfrfClientP(typedef payload_t, uint8_t uniqueLength, uint16_t bufferSize) {
  provides {
    interface StdControl;
    interface DfrfSend<payload_t>;
    interface DfrfReceive<payload_t>;
  }
  uses {
    interface DfrfControl as SubDfrfControl;
    interface DfrfSendAny as SubDfrfSend;
    interface DfrfReceiveAny as SubDfrfReceive;
  }
} implementation {

  uint8_t routingBuffer[sizeof(dfrf_desc_t) + bufferSize * (sizeof(payload_t) + sizeof(dfrf_block_t))];

  command error_t StdControl.start() {
    return call SubDfrfControl.init(sizeof(payload_t), uniqueLength, routingBuffer, sizeof(routingBuffer));
  }

  command error_t StdControl.stop() {
    call SubDfrfControl.stop();
    return SUCCESS;
  }

  command error_t DfrfSend.send(payload_t* data, uint32_t timeStamp) {
    return call SubDfrfSend.send((void*)data, timeStamp);
  }

  event bool SubDfrfReceive.receive(void *data, uint32_t timeStamp) {
    return signal DfrfReceive.receive((payload_t*)data, timeStamp);
  }

  default event bool DfrfReceive.receive(payload_t* data, uint32_t timestamp) { return TRUE; }

}

