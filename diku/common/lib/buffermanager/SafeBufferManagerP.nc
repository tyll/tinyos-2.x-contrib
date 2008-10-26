
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
 * SafeBufferManager
 *
 * This buffer manager ensures that no buffer can be released twice,
 * it's slightly slower than FIFOBufferManager, but should be slightly
 * safer too.
 *
 */

/**
 * @Author:         Martin Leopold <leopold@polaric.dk>
 *
 */

generic module SafeBufferManagerP(typedef page_t, uint8_t POOL_SIZE) {
  provides interface Init;
  uses interface StdOut;
  provides interface BufferManager<page_t>;
  provides interface BufferManagerEvents;
} implementation {

  bool    bufFree[POOL_SIZE];
  page_t  bufPool[POOL_SIZE];
  uint8_t queue_size = 0;

  async event void StdOut.get(uint8_t data) { }

  command error_t Init.init() {
    uint8_t i;
    queue_size = POOL_SIZE;

    for (i=0;i<POOL_SIZE;i++) {
      bufFree[i] = TRUE;
    }
    return SUCCESS;
  }

  command page_t * BufferManager.get() {
    page_t* p = (page_t*) NULL;
    int i;
    
    for (i=0 ; i<POOL_SIZE ; i++) {
      if (bufFree[i] == TRUE) {
	bufFree[i] = FALSE;
	p = &bufPool[i];
	queue_size--;
	break;
      }
    }
/*     call StdOut.print("Get"); */
/*     call StdOut.printHexword(p); */
/*     call StdOut.print("\n"); */

    if (p == NULL) signal BufferManagerEvents.getFail();
    return p;
  }

  command error_t BufferManager.free(page_t *p){
    uint16_t page_no;

    page_no = p - bufPool;

/*     call StdOut.print("Free"); */
/*     call StdOut.printHexword(p); */
/*     call StdOut.print(" "); */
/*     call StdOut.printHexword(page_no); */

    if (bufFree[page_no] == FALSE) {
      	queue_size++;
	bufFree[page_no] = TRUE;
/* 	call StdOut.print(" OK\n"); */
	return SUCCESS;
    }
    signal BufferManagerEvents.freeFail();
    return FAIL;
  }
    
  command uint8_t BufferManager.freeBuffers(){
    return (queue_size);
  }

  default event void BufferManagerEvents.getFail(){  }
  default event void BufferManagerEvents.freeFail(){  }

}
