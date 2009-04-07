/*
 * IMPORTANT: READ BEFORE DOWNLOADING, COPYING, INSTALLING OR USING.  By
 * downloading, copying, installing or using the software you agree to
 * this license.  If you do not agree to this license, do not download,
 * install, copy or use the software.
 *
 * Copyright (c) 2006-2008 Vrije Universiteit Amsterdam and
 * Development Laboratories (DevLab), Eindhoven, the Netherlands.
 * All rights reserved.
 *
 * Redistribution and use in source and binary forms, with or without
 * modification, are permitted provided that the following conditions
 * are met:
 * - Redistributions of source code must retain the above copyright
 *   notice, this list of conditions, the author, and the following
 *   disclaimer.
 * - Redistributions in binary form must reproduce the above copyright
 *   notice, this list of conditions, the author, and the following disclaimer
 *   in the documentation and/or other materials provided with the
 *   distribution.
 * - Neither the name of the Vrije Universiteit Amsterdam, nor the name of
 *   DevLab, nor the names of their contributors may be used to endorse or
 *   promote products derived from this software without specific prior
 *   written permission.
 *
 * THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS
 * ``AS IS'' AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT
 * LIMITED TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS
 * FOR A PARTICULAR PURPOSE ARE DISCLAIMED.  IN NO EVENT SHALL VRIJE
 * UNIVERSITEIT AMSTERDAM, DEVLAB, OR THEIR CONTRIBUTORS BE LIABLE FOR
 * ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL
 * DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR
 * SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION)
 * HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT,
 * STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE)
 * ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED
 * OF THE POSSIBILITY OF SUCH DAMAGE.
 *
 * Authors: Konrad Iwanicki
 * CVS id: $Id$
 */

/**
 * An implementation of a generic FIFO queue.
 *
 * @param tag_T     the type of the elements in the queue
 * @param MAX_SIZE  the maximal size of the queue
 *
 * @author Konrad Iwanicki &lt;iwanicki@few.vu.nl&gt;
 */
generic module GenericQueueC(typedef tag_T, uint8_t MAX_SIZE) {
    provides {
        interface GenericQueue<tag_T> as Queue;
    }
}
implementation {

    // -------------------------- Private members -------------------------
    tag_T     elems[MAX_SIZE];
    uint8_t   numElems = 0;
    uint8_t   headIdx = 0;


    // -------------------------- Interface Queue -------------------------
    command inline void Queue.clear() {
        numElems = 0;
        headIdx = 0;
    }



    command inline bool Queue.isEmpty() {
        return numElems == 0;
    }



    command inline bool Queue.isFull() {
        return numElems >= MAX_SIZE;
    }



    command inline uint8_t Queue.size() {
        return numElems;
    }



    command inline uint8_t Queue.maxSize() {
        return MAX_SIZE;
    }



    command inline tag_T * Queue.head() {
        if (numElems == 0) {
            return NULL;
        }
        return &(elems[headIdx]);
    }



    command inline tag_T * Queue.dequeue() {
        uint8_t idx = headIdx;
        if (numElems == 0) {
            return NULL;
        }
        ++headIdx;
        if (headIdx >= MAX_SIZE) {
            headIdx = 0;
        }
        --numElems;
        return &(elems[idx]);
    }



    command inline tag_T * Queue.enqueue() {
        uint8_t idx;
        if (numElems >= MAX_SIZE) {
            return NULL;
        }
        idx = (headIdx + numElems);
        if (idx >= MAX_SIZE) {
            idx -= MAX_SIZE;
        }
        ++numElems;
        return &(elems[idx]);
    }


    command inline tag_T * Queue.getElement(uint8_t i) {
        if (i >= numElems) {
            return NULL;
        }
        i += headIdx;
        if (i >= MAX_SIZE) {
            i -= MAX_SIZE;
        }
        return &(elems[i]);
    }
}
