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
 * An interface of a generic FIFO queue.
 *
 * @param tag_T the type of the elements in the queue
 *
 * @author Konrad Iwanicki &lt;iwanicki@few.vu.nl&gt;
 */
interface GenericQueue<tag_T> {

    /**
     * Clears the queue.
     */
    command void clear();

    /**
     * Checks if the queue is empty.
     * @return <code>TRUE</code> if the queue is empty, <code>FALSE</code>
     *         otherwise
     */
    command bool isEmpty();

    /**
     * Checks if the queue is full.
     * @return <code>TRUE</code> if the queue is full, <code>FALSE</code>
     *         otherwise
     */
    command bool isFull();

    /**
     * Returns the number of elements currently in the queue.
     * Always less than or equal to <code>maxSize()</code>.
     *
     * @return the number of elements in the queue
     */
    command uint8_t size();

    /**
     * Returns the maximum number of elements the queue can hold.
     * @return the maximum queue size
     */
    command uint8_t maxSize();

    /**
     * Returns the head of the queue without removing it.
     * @return the pointer to the head of the queue or <code>NULL</code>
     *         if the queue is empty
     */
    command tag_T * head();

    /**
     * Removes the head of the queue.
     * @return the pointer to the head of the queue or <code>NULL</code>
     *         if the queue was empty
     */
    command tag_T * dequeue();

    /**
     * Enqueues an element to the tail of the queue.
     * @return the pointer to the enqueued element (it can be used to
     *         fill the element with data) or <code>NULL</code> if
     *         the queue was full
     */
    command tag_T * enqueue();
    
    /**
     * Returns the <code>i</code>-th element in the queue (couting from
     * the head).
     * @param i the index of the element
     * @return the <code>i</code>-th element in the queue or
     *         <code>NULL</code> if there is no such element
     */
    command tag_T * getElement(uint8_t i);

}
