/* 
 * Copyright (c) 2006, Ecole Polytechnique Federale de Lausanne (EPFL),
 * Switzerland.
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
 * - Neither the name of the Ecole Polytechnique Federale de Lausanne (EPFL) 
 *   nor the names of its contributors may be used to 
 *   endorse or promote products derived from this software without 
 *   specific prior written permission.
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
 * ========================================================================
 */

/*
 * @author Henri Dubois-Ferriere
 *
 */
#include "SX1211.h"
#include "message.h"

interface SX1211PhyRxTx {

  /**
   * Send a buffer. This call will be followed up with continueSend() events 
   * (see below) until the client module indicates that there is nothing left to send.
   *
   * @param data a pointer to an array of bytes to send
   * @param len length of the array (6 <= len <= 16)
   * @return error SUCCESS if the operation initiated successfully, otherwise EOFF, EBUSY, EINVAL, or FAIL.
   *
   */
    async command error_t sendFrame(char* data, uint8_t len, pattern_t preamble);

  /** 
   * Signalled by the Phy layer to fetch more bytes to send. 
   *
   * @param len pointer to length field indicating number of bytes in next send. If 0, nothing more to send.
   * @return pointer to bytes to be sent. If NULL, nothing more to send.
   * 
   */
    // async event char* continueSend(uint8_t* len);

  /**
   * Signalled after the last buffer has been sent, where the 'last buffer' is the one following which
   * the client module returned NULL to continueSendBuf().
   *
   */
  async event void sendFrameDone(uint16_t timestamp, error_t err);



  /**
   * Signalled at end of a frame reception.
   *
   * @param data pointer to frame (at first byte of header)
   * @param len length of frame 
   * @param timestamp 16-bit 32 kHz timestamp
   * @param status SUCCESS if packet received ok, ERROR if packet reception was aborted.
   *
   */
  async event message_t * rxFrameEnd(message_t* data, uint8_t len, uint16_t timestamp, error_t status);


  /** 
   * Set header size, ie number of bytes at start of packet to be read and passed along 
   * with the rxFrameBegin() event.
   *
   * @param len length of header, 2 <= len <= 8
   *
   */
  async command void setRxHeaderLen(uint8_t len);

  /**
   * Get the current header size.
   *
   * @return header size
   *
   */
  async command uint8_t getRxHeaderLen();


  /** 
   * Check busy/idle state of phy.
   *
   * @return TRUE if phy is sending or receiving a packet, FALSE otherwise.
   *
   */
  async command bool busy();

  /** 
   * Check on/off state of phy.
   *
   * @return TRUE if phy is idle, standby, starting, or stopping, FALSE otherwise.
   *
   */
  async command bool off();



  async command void enableAck(bool onOff);

}
