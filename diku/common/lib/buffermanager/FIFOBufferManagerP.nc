
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
 * FIFOBufferManager
 *
 * This buffer manager implements a simple queue to hold free buffer,
 * new and free call simply pop or push a pointer from the queue. The
 * queue implementation is borrowed from the TinyOS queue
 * implementation and duplicated here, since we simply want a dequeue
 * on an empty queue to return a NULL pointer.
 *
 * It is implemented as a queue and /no/ safeguards are implemented on
 * free - as a result freeFail will never be signaled.
 *
 */

/**
 * @Author:         Martin Leopold <leopold@polaric.dk>
 *
 */

generic module FIFOBufferManagerP(typedef page_t, uint8_t POOL_SIZE) {
  provides interface Init;
  provides interface BufferManager<page_t>;
  provides interface BufferManagerEvents;
} implementation {

  page_t  bufPool[POOL_SIZE];
  page_t *bufQueue[POOL_SIZE];

  uint8_t head = 0;
  uint8_t tail = 0;
  uint8_t queue_size = 0;

  /*
   * These two functions are borrowed from the TinyOS queue implementation
   */

  page_t *dequeue() {
    page_t* t = (page_t*) NULL;

    if (queue_size != 0) {
      t = bufQueue[head];
      head++;
      if (head == POOL_SIZE) head = 0;
      queue_size--;
    }
    return t;
  }

  error_t enqueue(page_t *newVal) {
    if (queue_size < POOL_SIZE) {
      bufQueue[tail] = newVal;
      tail++;
      if (tail == POOL_SIZE) tail = 0;
      queue_size++;
      return SUCCESS;
    }
    else {
      return FAIL;
    }
  }

  /**
   * Clear queue and enque all pointers
   */

  command error_t Init.init() {
    uint8_t i;
    error_t r;
    head=0;
    tail=0;
    queue_size = 0;

    for (i=0;i<POOL_SIZE;i++) {
      r |= enqueue(&bufPool[i]);
    }
    return r;
  }

  command page_t * BufferManager.get() {
    page_t *p = dequeue();
    if (p == NULL) signal BufferManagerEvents.getFail();
    return p;
  }

  command error_t BufferManager.free(page_t *p){
    return enqueue(p);
  }
    
  command uint8_t BufferManager.freeBuffers(){
    return (queue_size);
  }
 
  default event void BufferManagerEvents.getFail(){ }
  default event void BufferManagerEvents.freeFail(){ }

}
