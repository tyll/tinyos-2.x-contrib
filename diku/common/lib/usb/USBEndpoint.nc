/*
 * Copyright (c) 2008 Polaric
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
 * - Neither the name of Polaric nor the names of its contributors may
 *   be used to endorse or promote products derived from this software
 *   without specific prior written permission.
 *
 * THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND
 * CONTRIBUTORS ``AS IS'' AND ANY EXPRESS OR IMPLIED WARRANTIES,
 * INCLUDING, BUT NOT LIMITED TO, THE IMPLIED WARRANTIES OF
 * MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE
 * DISCLAIMED.  IN NO EVENT SHALL POLARIC OR ITS CONTRIBUTORS BE
 * LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL,
 * EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT
 * LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS
 * OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER
 * CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT,
 * STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE)
 * ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF
 * ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
 */

/**
 *
 * @author Martin Leopold <leopold@polaric.dk>
 */

/**
 * USBEndpoint - generic USB endpoint abstraction.
 *
 * Packets are returned in a two step process, first a receiveReady
 * event is generated asking for a buffer, when the packet has been
 * copied to the buffer a receiveDone event is generated.
 *
 * This approach is chosen for two reasons: Fist the size of the
 * packets returned from USB is potentially unbounded for example when
 * transferring a large object (e.g. a file, an image, etc.). Second
 * if an application transferring only small amounts of data at a
 * time, then defining a fixed buffer size will waste the leftovers
 * that are not used by the application, consider for example the CDC
 * application that transfers bytes one at a time, defining a say 40
 * byte buffer size will waste 39 bytes for each of the pre-allocated
 * buffers.

 * Hence defining a one-size-fits-all buffer that suits all
 * applications seems difficult and we let the decision be up to the
 * application - it could for example use a new/free buffer management
 * scheme that provides buffers of sufficient size.
 */

interface USBEndpoint {
  
  /**
   * Sends the content of the buffer to the host device (USB IN).
   *
   * The command assumes transfer of ownership meaning that the
   * calling device shall not change the buffer between send and
   * sendDone.
   */
    command error_t send(uint8_t* pkt, uint16_t pkt_len);
    event void sendDone(uint8_t* pkt);

  /**
   * receiveReady
   *
   * First event in the two step process of receiving packet - this
   * event holds up reception, and must be completed quickly.
   *
   * When a packet is received, a receiveReady event is generated
   * indicating the ammount data that is ready, the handler must
   * return a pointer to a buffer that can accomodate at least this
   * ammount of data. Further it must indicate with the return value
   * whether the packet can be handled (if not it will be discarded).
   *
   * @param recv_len The ammount of byte ready
   *
   * @return next_buf A pointer to a buffer of at least size recv_len
   * @return error_t Is the buffer valid?
   */
  async event error_t receiveReady(uint16_t recv_len, uint8_t **next_buf);

  /**
   * receiveDone
   *
   * Second part in receiving a packet
   *
   * Returns the bytes previously announced in receiveReady.
   */

  async event void receiveDone(uint16_t recv_len, uint8_t *recv_pkt);

/*   command void enable(); */
/*   command void disable(); */


    
}
