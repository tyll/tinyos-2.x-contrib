
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
 * This generic buffer manager is based on the ideas proposed in The
 * Case for Buffer Allocation in TinyOS (Klaus S. Madsen) and the
 * implementation is inspired by the one used by Jan Flora in his
 * IEEE 802.15.4 stack.
 */

/**
 *        @Author:         Martin Leopold <leopold@polaric.dk>
 *
 */

interface BufferManager<page_t> {

  /**
   * Locates a free packet in the buffer-pool, and returns it. If
   * there is no free packets NULL is returned, and getFail is
   * signaled.
   *
   * @return A free packet, or NULL if no free packets exists
   */
	command page_t * get(); 

  /**
   * Returns a packet to the buffer-pool. If successful, the function
   * will return SUCCESS. Otherwise it returns FAIL, and putFailure is
   * signalled.
   *
   * @return SUCCESS, if the packet could be returned.
   */
	command error_t free(page_t* p);

  /**
   * Returns no. free buffers
   *
   * @return no free buffers
   */
	command uint8_t freeBuffers();
}
