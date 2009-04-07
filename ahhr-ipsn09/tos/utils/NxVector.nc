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

#include "NxVector.h"

/**
 * An interface describing a vector of elements of a given type.
 * The vector is represented in the message simply as a byte array.
 *
 * @param el_type_t the type of the elements of the vector
 *
 * @author Konrad Iwanicki &lt;iwanicki@few.vu.nl&gt;
 */
interface NxVector<el_type_t> {

    /**
     * Returns the byte length of a vector of given length.
     * @param len the length of the vector (the number of elements)
     * @return the length in bytes of the vector
     */
    command uint8_t getByteLen(uint8_t len);

    /**
     * Returns the maximal length of a vector.
     * @return the maximal length of a vector of a given type (the number
     *         of elements)
     */
    command uint8_t getMaxLen();

    /**
     * Returns the length of a vector.
     * @param v the vector
     * @return the length of the vector (the number of elements)
     */
    command uint8_t getLen(nx_vect_t const * v);

    /**
     * Sets the length of a vector.
     * @param v the vector
     * @param len the new length of the vector (the number of elements)
     */
    command void setLen(nx_vect_t * v, uint8_t len);

    /**
     * Returns the <tt>i</tt>-th element of a vector.
     * @param v the vector
     * @param i the index of the element to return
     * @return the <tt>i</tt>-th element of the vector
     */
    command el_type_t getEl(nx_vect_t const * v, uint8_t i);

    /**
     * Sets the <tt>i</tt>-th element of a vector.
     * @param v the vector
     * @param i the index of the element to set
     * @param val the new value of the element
     * @param val the new value of the <tt>i</tt>-th element of the vector
     */
    command void setEl(nx_vect_t * v, uint8_t i, el_type_t val);
}

