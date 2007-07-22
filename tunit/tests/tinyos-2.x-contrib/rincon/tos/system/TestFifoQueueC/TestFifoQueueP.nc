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

/**
 * @author David Moss
 */
 
#include "message.h"
#include "AM.h"
#include "TestCase.h"

module TestFifoQueueP {
  uses {
    interface FifoQueue<uint16_t> as Fifo;
    interface FifoQueue<message_t *> as MsgQueue;
    
    interface TestCase as TestNqDq;
    interface TestCase as TestFill;
    interface TestCase as TestBadDq;
    interface TestCase as TestMsgQueue;
  }
}

implementation {
  
  /** 
   * Queue up 2 elements and dequeue them, verifying things along the way
   */
  event void TestNqDq.run() {
    uint16_t dequeueLocation;
    
    if(call Fifo.enqueue(2) != SUCCESS) {
      assertFail("Could not enqueue 2");
    }
    
    if(call Fifo.enqueue(4) != SUCCESS) {
      assertFail("Could not enqueue 4");
    }
    
    assertEquals("Incorrect number of enqueues", 2, call Fifo.size());
    
    if(call Fifo.dequeue(&dequeueLocation, sizeof(dequeueLocation)) != SUCCESS) {
      assertFail("Could not dequeue 2");
    } else {
      assertEquals("Dequeue != 2", 2, dequeueLocation);
    }
    
    if(call Fifo.dequeue(&dequeueLocation, sizeof(dequeueLocation)) != SUCCESS) {
      assertFail("Could not dequeue 4");
      
    } else {
      assertEquals("Dequeue != 4", 4, dequeueLocation);
    }
    
    call Fifo.reset();
    call TestNqDq.done();
  }
  
  /**
   * Test filling up our queue completely, make sure we can't go over, then
   * dequeue the queue completely and make sure we can't keep dequeuing.
   * Verify all values as we dequeue them.
   */
  event void TestFill.run() {
    int i;
    uint16_t dequeueLocation;
    for(i = 0; i < call Fifo.maxSize(); i++) {
      if(call Fifo.enqueue(i) != SUCCESS) {
        assertFail("Could not enqueue");
      }
    }
    
    if(call Fifo.enqueue(i+1) == SUCCESS) {
      assertFail("Enqueued too many");
    }
    
    assertEquals("Not filled", call Fifo.maxSize(), call Fifo.size());
    assertFalse("Says it's empty", call Fifo.isEmpty());
    assertTrue("Says it's not full", call Fifo.isFull());
    
    for(i = 0; i < call Fifo.maxSize(); i++) {
      if(call Fifo.dequeue(&dequeueLocation, sizeof(dequeueLocation)) != SUCCESS) {
        assertFail("Could not dequeue");
        
      } else {
        assertEquals("Wrong value", dequeueLocation, (uint16_t) i);
      }
    }
    
    assertTrue("Say it's not empty", call Fifo.isEmpty());
    if(call Fifo.dequeue(&dequeueLocation, sizeof(dequeueLocation)) == SUCCESS) {
      assertFail("Dequeued more values than we enqueued");
    }
    
    call TestFill.done();
  }
  
  
  /**
   * Test enqueueing an element and dequeueing it into a location that is too
   * small
   */
  event void TestBadDq.run() {
    uint8_t dequeueLocation;
    
    call Fifo.reset();
    if(call Fifo.enqueue(0xFFFF) != SUCCESS) {
      assertFail("Could not enqueue 0xFFFF");
      call TestBadDq.done();
      return;
    }
    
    assertFalse("Overflow on dequeue", call Fifo.dequeue(&dequeueLocation, sizeof(dequeueLocation)) == SUCCESS);
    call TestBadDq.done();
  }
  
  /** 
   * Test the ability to store and retrieve messages
   */
  event void TestMsgQueue.run() {
    message_t msg1;
    message_t msg2;
    
    message_t *dequeue1;
    message_t *dequeue2;
    
    assertTrue("1. Could not enqueue msg", call MsgQueue.enqueue(&msg1) == SUCCESS);
    assertTrue("1. Could not dequeue msg", call MsgQueue.dequeue(&dequeue1, sizeof(dequeue1)) == SUCCESS);
    assertTrue("2. Could not enqueue msg", call MsgQueue.enqueue(&msg2) == SUCCESS);
    assertTrue("2. Could not dequeue msg", call MsgQueue.dequeue(&dequeue2, sizeof(dequeue2)) == SUCCESS);
    assertTrue("dequeue1 != &msg1", dequeue1 == &msg1);
    assertTrue("dequeue2 != &msg2", dequeue2 == &msg2);
    call TestMsgQueue.done();
  }
  
  
  /***************** Fifo Events ***************/
  event void Fifo.available() {
  }
  
  event void MsgQueue.available() {
  }
}

