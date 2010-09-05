/* $Id$ */
/*
 * Copyright (c) 2006 Stanford University.
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
 * - Neither the name of the Stanford University nor the names of
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
 *  A general FIFO pointer-based queue component, whose queue has a bounded size.
 *
 *  @author Lee Seng Jea
 */

 
generic module PointerQueueC(typedef queue_t, uint8_t QUEUE_SIZE) {
  provides interface PointerQueue<queue_t>;
}

implementation {
  enum { lowBuffer = (QUEUE_SIZE >> 3) };
  queue_t* queue;
  queue_t wastebin;
  uint8_t head = 0;
  uint8_t tail = 0;
  uint8_t size = 0;
  
  command bool PointerQueue.empty() {
    atomic return size == 0;
  }

  command uint8_t PointerQueue.size() {
    atomic return size;
  }

  command uint8_t PointerQueue.maxSize() {
    return QUEUE_SIZE;
  }
  command void PointerQueue.flush() {
	  atomic {
		  size = 0;
		  head = 0;
		  tail = 0;
	  }
  }
  command queue_t* PointerQueue.head() {
      return &queue[head];
  }
  command bool PointerQueue.available() {
    atomic return size < QUEUE_SIZE;
  }
  void printQueue() {
#ifdef TOSSIM
    int i, j;
    dbg("QueueC", "head <-");
    for (i = head; i < head + size; i++) {
      dbg_clear("QueueC", "[");
      for (j = 0; j < sizeof(queue_t); j++) {
	uint8_t v = ((uint8_t*)&queue[i % QUEUE_SIZE])[j];
	dbg_clear("QueueC", "%0.2hhx", v);
      }
      dbg_clear("QueueC", "] ");
    }
    dbg_clear("QueueC", "<- tail\n");
#endif
  }
  
  command void PointerQueue.dequeue() {
    dbg("QueueC", "%s: size is %hhu\n", __FUNCTION__, size);
    atomic { 
    if (size) {
	      head++;
	      if (head == QUEUE_SIZE) head = 0;
	      size--;
      }
    }
    printQueue();
  }

  async command queue_t * PointerQueue.enqueue() {

      uint8_t t; bool low = FALSE;
      atomic {
          if (!queue && !(queue = malloc(sizeof(queue_t) * QUEUE_SIZE))) {
          signal PointerQueue.bufferBlown();
          return &wastebin;
          }
	      if (size < QUEUE_SIZE) {
		      dbg("QueueC", "%s: size is %hhu\n", __FUNCTION__, size);
		      
		        t = tail++; 
		      if (tail == QUEUE_SIZE) tail = 0;
		      size++;
		      printQueue();
		      if (size + lowBuffer >  QUEUE_SIZE) low = TRUE;
	      }
	      else t = QUEUE_SIZE;
	  }
	  if (t < QUEUE_SIZE) {
	  if (low)
	  signal PointerQueue.bufferLow();
	  return &queue[t];
	  }
	  else {
	  signal PointerQueue.bufferFull(&wastebin);
	  return &wastebin;
    }
  }
  
  command queue_t * PointerQueue.element(uint8_t idx) {
    atomic {
    idx += head;
    idx %= QUEUE_SIZE;
      return &queue[idx];
      }
  }  
  default async event void PointerQueue.bufferLow() { }
  default async event void PointerQueue.bufferBlown() { }
  default async event void PointerQueue.bufferFull(queue_t * bin) { }
}
