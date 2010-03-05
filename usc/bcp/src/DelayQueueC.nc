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
 *  A general delay queue component, whose queue has a bounded size.
 *  Elements inside the queue are inserted with an associated age,
 *  and the age increases with each call to DelayQueue.Age(uint8_t age_p);
 *  Dequeues select the oldest packet in the queue (pointed to by head);
 *  This is a modified version of Queue.nc.
 *
 *  @author Philip Levis
 *  @author Geoffrey Mainland
 *  @author Scott Moeller
 *  @date   $Date$
 */
 
generic module DelayQueueC(typedef queue_t, uint8_t QUEUE_SIZE) {
  provides interface DelayQueue<queue_t>;
}
implementation{

  queue_t ONE_NOK queue[QUEUE_SIZE];
  uint8_t age[QUEUE_SIZE];
  uint8_t head = 0;
  uint8_t tail = 0;
  uint8_t size = 0;
  
  command bool DelayQueue.empty() {
    return size == 0;
  }

  command uint8_t DelayQueue.size() {
    return size;
  }

  command uint8_t DelayQueue.maxSize() {
    return QUEUE_SIZE;
  }

  command queue_t DelayQueue.head() {
    return queue[head];
  }

  void printQueue() {
#ifdef TOSSIM
    int i, j;
    dbg("DelayQueueC", "head <-");
    for (i = head; i < head + size; i++) {
      dbg_clear("DelayQueueC", "[");
      for (j = 0; j < sizeof(queue_t); j++) {
        uint8_t v = ((uint8_t*)&queue[i % QUEUE_SIZE])[j];
        dbg_clear("DelayQueueC", "%0.2hhx", v);
      }
      dbg_clear("DelayQueueC", "] ");
    }
    dbg_clear("DelayQueueC", "<- tail\n");
#endif
  }  
	
  command queue_t DelayQueue.dequeue() {
    queue_t t = call DelayQueue.head();
    dbg("DelayQueueC", "%s: size is %hhu\n", __FUNCTION__, size);
    if (!call DelayQueue.empty()) {
      head++;
      if (head == QUEUE_SIZE) head = 0;
      size--;
      printQueue();
    }
    return t;
  }

  command error_t DelayQueue.enqueue(queue_t newVal, uint8_t age_p) {
  	int i,j;
  	age[tail] = 0;
    if (call DelayQueue.size() < call DelayQueue.maxSize()) {
      dbg("DelayQueueC", "%s: size is %hhu\n", __FUNCTION__, size);
      // Find the insertion point
      for( i=head; i<= head+size; i++ )
      {
        if(age[i % QUEUE_SIZE]< age_p)
        {
          dbg("DelayQueueC", "%s: inserting new element at index %d\n", __FUNCTION__, i-head);
          // Shift everything down from this point
          // onward.
          for( j = head+size; j > i; j-- )
          {
            queue[j % QUEUE_SIZE] = queue[(j-1) % QUEUE_SIZE];
            age[j % QUEUE_SIZE] = age[(j-1) % QUEUE_SIZE];
          }
          // Insert the new element
          queue[i % QUEUE_SIZE] = newVal;
          age[i % QUEUE_SIZE]   = age_p;
          
          // Terminate the for
          i = head+size+1;          
        }
      }

      tail++;
      if (tail == QUEUE_SIZE) tail = 0;
      size++;
      printQueue();
      return SUCCESS;
    }
    else {
      return FAIL;
    }
  }
  
  command queue_t DelayQueue.element(uint8_t idx) {
    idx += head;
    idx %= QUEUE_SIZE;
    return queue[idx];
  }  
  
  command void DelayQueue.age(uint8_t age_p)
  {
  	int i;
  	uint8_t newAge;
  	for (i = head; i < tail; i++) {
  	  newAge = age[i];
  	  newAge += age_p;
  	  if(newAge <= age[i])
  	    newAge = 0xFF;
  	  age[i] = newAge;
  	}
  }
  
  command uint16_t DelayQueue.getTotalAge()
  {
    int i;
    uint16_t retVal = 0;
  	for (i = head; i < head+size; i++ )
  	{
  	  retVal += age[i];
  	}
  	return retVal;
  }
  
  command uint8_t DelayQueue.getHeadAge()
  {
    return age[head];
  }
}