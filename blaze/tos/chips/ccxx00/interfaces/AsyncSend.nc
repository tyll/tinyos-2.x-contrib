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

#include "message.h"

interface AsyncSend {


  /**
   * Attempt to transmit a message.  The first byte of *msg must be the length
   * of the rest of the packet, not including the length byte.
   * 
   * @param msg The first byte is the length byte of the rest of the packet,
   *     not including the length byte itself.
   * @param force TRUE to force this packet to be sent, i.e. an acknowledgment
   * @param preambleDurationMs The duration of the preamble in milliseconds,
   *     0 to send to a full power listener.
   * 
   * @return SUCCESS if the transmission will occur
   *         EBUSY if the channel is already in use
   *         FAIL if something else is already using the transmit module
   */
  async command error_t send(void *msg, bool force, uint16_t preambleDurationMs);
  
  
  /**
   * Send is complete.
   * @param error SUCCESS if the message was sent
   *              ESIZE if there was a TX or RX FIFO underflow
   *              EBUSY if the channel wasn't clear.
   */
  async event void sendDone(error_t error);
  
}

