// ex: set tabstop=2 shiftwidth=2 expandtab syn=c:
// $Id$
                                    
/*                                                                      
 * "Copyright (c) 2000-2003 The Regents of the University  of California.  
 * All rights reserved.             
 *                                  
 * Permission to use, copy, modify, and distribute this software and its
 * documentation for any purpose, without fee, and without written agreement is
 * hereby granted, provided that the above copyright notice, the following
 * two paragraphs and the author appear in all copies of this software.
 *                                  
 * IN NO EVENT SHALL THE UNIVERSITY OF CALIFORNIA BE LIABLE TO ANY PARTY FOR
 * DIRECT, INDIRECT, SPECIAL, INCIDENTAL, OR CONSEQUENTIAL DAMAGES ARISING OUT
 * OF THE USE OF THIS SOFTWARE AND ITS DOCUMENTATION, EVEN IF THE UNIVERSITY OF
 * CALIFORNIA HAS BEEN ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
 *                                  
 * THE UNIVERSITY OF CALIFORNIA SPECIFICALLY DISCLAIMS ANY WARRANTIES,
 * INCLUDING, BUT NOT LIMITED TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY
 * AND FITNESS FOR A PARTICULAR PURPOSE.  THE SOFTWARE PROVIDED HEREUNDER IS
 * ON AN "AS IS" BASIS, AND THE UNIVERSITY OF CALIFORNIA HAS NO OBLIGATION TO
 * PROVIDE MAINTENANCE, SUPPORT, UPDATES, ENHANCEMENTS, OR MODIFICATIONS."
 *                                  
 * Copyright (c) 2002-2003 Intel Corporation
 * All rights reserved.             
 *                                  
 * This file is distributed under the terms in the attached INTEL-LICENSE     
 * file. If you do not find these files, copies can be found by writing to
 * Intel Research Berkeley, 2150 Shattuck Avenue, Suite 1300, Berkeley, CA, 
 * 94704.  Attention:  Intel License Inquiry.
 */                                 
                                    
/*                                  
 * Authors:  Rodrigo Fonseca        
 * Date: 8/8/3
 * Date Last Modified: 2005/05/26
 */

/* 
 * Buffer pool for swapping and processing of message_t buffers.
 * There is also a FIFO queue that allows in-order processing.
 * 
 * Usage in a receive cycle (in which you need swapping of buffers and
   further processing):
 * 0. include this file
 * 1. declare a variable of type BufferPool and call bufferPoolInit()
 * 2. upon receiving a buffer for processing, call bufferPoolSwap()
 *    swap returns a free buffer and enqueues the received buffer, setting it
 *    to busy.
 * 3. for processing, call processNext. This returns the first enqueued, but
 *    does not set it as free
 * 4. after processing (e.g., sendDone), call SetFree. 
 *    This returns the buffer to the pool for other uses

 * Usage if you only need to allocate and free buffers, but not swap
 * 0. include this file
 * 1. declare a variable of type BufferPool and call bufferPoolInit()
 * 2. When a buffer is needed, call bufferPoolGetFree()
 * 3. When the buffer can be freed, call bufferPoolSetFree()
 * 
 * These methods should not be used simultaneously for a given bufferPool
 * Todo: I will separate them into QueuedBufferPool and simple BufferPool

 * Other limitations: size setting is global accross buffer pools. */

enum {
  BUFFER_POOL_SIZE = 24,
  //DBG_FLAG = DBG_NONE,
};

typedef struct {
  bool busy[BUFFER_POOL_SIZE];             // flags indicating buffers in use
  uint8_t num_elements;                    // # buffers in use
  message_t buffers[BUFFER_POOL_SIZE];       // actual buffers
  message_t* bufferPtrs[BUFFER_POOL_SIZE]; // pointers to the buffers
  uint8_t processQueue[BUFFER_POOL_SIZE];  // queue for processing
  uint8_t q_first;                         // first element in queue
  uint8_t q_num_elements;                  // number of elements in queue
} BufferPool;


inline void bufferPoolDbg(BufferPool* this) {
  int i;
  dbg("BVR-flag","bufferPool: num_elements: %d, q_first: %d, q_num_elements:%d\n",
		  this->num_elements,this->q_first, this->q_num_elements);
  dbg("BVR-flag","bufferPool: ");
  for (i = 0; i < BUFFER_POOL_SIZE; i++) {
    dbg_clear("BVR-flag","[%d]:%p (%d) ",i,this->bufferPtrs[i], this->busy[i]);
  }
  dbg_clear("BVR-flag","\n");
}



//Places the integer n in the first position after the last in processQueue
//returns FAIL if queue is full, SUCCESS otherwise
inline error_t bufferPoolEnqueue(BufferPool *this, uint8_t n) {
  uint8_t pos;
  dbg("BVR-flag","bufferPool:enqueue\n");
  bufferPoolDbg(this);
  if (this->q_num_elements == BUFFER_POOL_SIZE) 
    return FAIL;

  pos = (this->q_first + this->q_num_elements) % BUFFER_POOL_SIZE;
  this->processQueue[pos] = n;
  this->q_num_elements++;
  return SUCCESS;
}

//Attributs to *n the first position in processQueue.
//returns FAIL if the queue was empty, SUCCESS otherwise
inline error_t bufferPoolDequeue(BufferPool *this, uint8_t* n) {
  if (this->q_num_elements == 0)
    return FAIL;
  *n = this->processQueue[this->q_first];
  this->q_first = (this->q_first + 1) % BUFFER_POOL_SIZE;
  this->q_num_elements--;
  dbg("BVR-flag","bufferPool: dequeueing:%d elements\n",this->q_num_elements);
  return SUCCESS;
}

inline uint8_t bufferPoolGetQueueSize(BufferPool *this) {
  return this->q_num_elements;
}

inline uint8_t bufferPoolGetSize(BufferPool *this) {
  return BUFFER_POOL_SIZE;
}

inline uint8_t bufferPoolGetNumberFree(BufferPool *this) {
  return (BUFFER_POOL_SIZE - this->num_elements);
}

inline message_t* bufferPoolProcessNext(BufferPool *this) {
  uint8_t n;
  dbg("BVR-flag","bufferPool:processNext\n");
  bufferPoolDbg(this);
  if (bufferPoolDequeue(this, &n) == SUCCESS) 
    return this->bufferPtrs[n];
  else 
    return NULL;
}
inline void bufferPoolInit(BufferPool* this) {
  int i;
  dbg("BVR-flag","bufferPool: init with size %d\n",BUFFER_POOL_SIZE);
  this->num_elements = 0;
  for (i = 0; i < BUFFER_POOL_SIZE; i++) {
    this->bufferPtrs[i] = &this->buffers[i];
    this->busy[i] = FALSE;
    this->q_first = 0;
    this->q_num_elements = 0;
  }
  bufferPoolDbg(this);
}

inline error_t bufferPoolGetFreePos(BufferPool* this, uint8_t *pos) {
  int i;
  uint8_t free_pos = 255;

  dbg("BVR-flag","bufferPool:getFreePos\n");
  bufferPoolDbg(this);
  if (this->num_elements == BUFFER_POOL_SIZE) {
    *pos = 0;
    return FAIL;
  }

  for (i = 0; (i < BUFFER_POOL_SIZE) && (free_pos == 255); i++) {
    if (this->busy[i] == FALSE) 
      free_pos = i; 
  }
  if (free_pos == 255) {
    dbg("BVR-flag","bufferPool: ERROR! inconsistent state. Did not find pos, but num_busy=%d\n",this->num_elements);
    call Leds.led0On();
    *pos = free_pos;
    return FAIL;
  } else {
    dbg("BVR-flag","bufferPool: returning position %d (%p)\n",free_pos,this->bufferPtrs[free_pos]);
    *pos = free_pos;
    return SUCCESS;
  }
}

// If there is a free position:
//
// 1. returns the buffer associated with the free position
// 2. stores the received buffer in the same position
// 3. sets the position as busy
// 4. enqueues the position in the processFifo queue
//
inline error_t bufferPoolSwap(BufferPool *this, message_t* *rcv) {
  uint8_t free_pos;
  message_t* temp;

  dbg("BVR-flag","bufferPool:swap. received %p\n",rcv);

  //return the same buffer if we don't have space
  if (bufferPoolGetFreePos(this, &free_pos) == FAIL) {
    dbg("BVR-flag","bufferPool: could not get free position\n");
    return FAIL;
  }

  temp = this->bufferPtrs[free_pos];
  this->bufferPtrs[free_pos] = *rcv;
  this->busy[free_pos] = TRUE;
  this->num_elements++;
  *rcv = temp;

  dbg("BVR-flag","bufferPool: swapping. rcv: %p ret: %p. num_busy:%d\n", this->bufferPtrs[free_pos], *rcv, this->num_elements);
  bufferPoolEnqueue(this, free_pos);
  bufferPoolDbg(this);
  dbg("BVR-flag","bufferPool: enqueued:%d\n",this->q_num_elements);

  return SUCCESS;
}
 
// If there is a free position:
//
// 1. returns the buffer associated with the free position
// 2. sets the position as busy
//
// if error_t is FAIL, 
//    status = 0 if buffer full
//    status = 255 if buffer inconsistent
inline error_t bufferPoolGetFree(BufferPool *this, message_t* *buffer, uint8_t *status) {
  uint8_t free_pos;

  dbg("BVR-flag","bufferPool:Get\n");

  if (bufferPoolGetFreePos(this, &free_pos) == FAIL) {
    dbg("BVR-flag","bufferPool: could not get free position\n");
    *status = free_pos;
    return FAIL;
  }

  this->busy[free_pos] = TRUE;
  this->num_elements++;
  *buffer = this->bufferPtrs[free_pos];
  
  dbg("BVR-flag","bufferPoolGet: returning free buffer [%d]=%p\n",free_pos,*buffer);
  bufferPoolDbg(this);

  return SUCCESS;
}
 

//sets the busy flag to the buffer pointed to by ptr, if it is in
//the buffer pool. 
//Returns SUCCESS if pointer in buffer pool, FAIL otherwise
inline error_t bufferPoolSetFree(BufferPool* this, message_t* ptr) {
  int i;
  uint8_t pos = 255;
  dbg("BVR-flag","bufferPool:setFree.\n");
  bufferPoolDbg(this);
  //search for the position in which ptr is stored
  for (i = 0; i < BUFFER_POOL_SIZE && pos == 255; i++) {
    if (this->bufferPtrs[i] == ptr)
      pos = i;
  }
  if (pos == 255) 
    return FAIL;
  
  this->busy[pos] = FALSE;
  this->num_elements--;
  dbg("BVR-flag","bufferPool: freeing element %p. num_busy:%d\n",ptr,this->num_elements);
  return SUCCESS;
}
