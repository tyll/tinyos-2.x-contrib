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
 * A generic implementation of the <code>NxVector</code> interface.
 *
 * @param el_type_t the type of the elements of the vector
 * @param LEN_BITS  the number of bits for the vector length
 *
 * @author Konrad Iwanicki &lt;iwanicki@few.vu.nl&gt;
 */
generic module NxVectorGenericC(
        typedef el_type_t @integer(), uint8_t LEN_BITS, uint8_t EL_BITS) {
    provides {
        interface NxVector<el_type_t>;
    }
}
implementation {

    enum {
        /** the mask used for the length */
        LEN_MASK = (1 << LEN_BITS) - 1
    };

    // ----------------------- Interface NxVector -------------------------
    command inline uint8_t NxVector.getByteLen(uint8_t len) {
        return (uint8_t)(((uint16_t)LEN_BITS
            + (uint16_t)len * (uint16_t)EL_BITS + 7) >> 3);
    }



    command inline uint8_t NxVector.getMaxLen() {
        return (uint8_t)(((uint16_t)1 << (uint16_t)LEN_BITS) - (uint16_t)1);
    }



    command inline uint8_t NxVector.getLen(nx_vect_t const * v) {
        return v->data[0] & (uint8_t)LEN_MASK;
    }



    command inline void NxVector.setLen(nx_vect_t * v, uint8_t len) {
#ifdef TOSSIM
        if (len > (uint8_t)LEN_MASK) {
            dbgerror("ERROR", "Vector length %hhu too big " \
                "(max=%hhu)!\n", len, (uint8_t)LEN_MASK);
            return;
        }
#endif
        v->data[0] = (v->data[0] & (~(uint8_t)LEN_MASK))
            | (len & (uint8_t)LEN_MASK);

    }



    command el_type_t NxVector.getEl(nx_vect_t const * v, uint8_t i) {
        el_type_t  res;
        uint16_t   fi = LEN_BITS + EL_BITS * i;
        uint16_t   li = fi + EL_BITS;
        uint8_t    j, cnt;
        uint8_t    buf;
#ifdef TOSSIM
        if (i >= call NxVector.getLen(v)) {
            dbgerror("ERROR", "Element index %hhu exceeds the " \
                "vector length %hhu!\n", i, call NxVector.getLen(v));
            return (el_type_t)0;
        }
#endif
        if (EL_BITS >= 8 || (fi >> 3) < (li >> 3)) {
            // extract the first byte that may not be full
            buf = v->data[fi >> 3];
            buf = buf >> (uint8_t)(fi & 7);
            cnt = 8 - (uint8_t)(fi & 7);
            res = (el_type_t)buf;
            // extract all the full bytes
            for (i = (fi >> 3) + 1, j = (li >> 3); i < j; ++i) {
                buf = v->data[i];
                res |= (el_type_t)buf << cnt;
                cnt += 8;
            }
            // extract the last byte that may not be full
            if ((li & 7) > 0) {
                buf = v->data[li >> 3];
                buf &= (((uint8_t)1 << (uint8_t)(li & 7)) - 1);
                res |= (el_type_t)buf << cnt;
            }
        } else {
            buf = v->data[fi >> 3];
            buf &= (((uint8_t)1 << (uint8_t)(li & 7)) - 1);
            buf = buf >> (uint8_t)(fi & 7);
            res = (el_type_t)buf;
        }
        return res;
    }



    command void NxVector.setEl(nx_vect_t * v, uint8_t i, el_type_t val) {
        uint16_t   fi = LEN_BITS + EL_BITS * i;
        uint16_t   li = fi + EL_BITS;
        uint8_t    j;
        uint8_t    buf, mask;
#ifdef TOSSIM
        if (i >= call NxVector.getLen(v)) {
            dbgerror("ERROR", "Element index %hhu exceeds the " \
                "vector length %hhu!\n", i, call NxVector.getLen(v));
            return;
        }
        if (val > ((el_type_t)1 << EL_BITS) - 1) {
            dbgerror("ERROR", "Element value %d exceeds the " \
                "number of bits %hhu!\n", val, (uint8_t)EL_BITS);
            return;
        }
#endif
        if (EL_BITS >= 8 || (fi >> 3) < (li >> 3)) {
            // set the first byte that may not be full
            mask = (uint8_t)0xff << (uint8_t)(fi & 7);
            buf = v->data[fi >> 3];
            buf = (buf & ~mask)
                | ((((uint8_t)(val & 0xff)) << (fi & 7)) & mask);
            v->data[fi >> 3] = buf;
            val = val >> (8 - (fi & 7));
            // set all the full bytes
            for (i = (fi >> 3) + 1, j = (li >> 3); i < j; ++i) {
                v->data[i] = (uint8_t)(val & 0xff);
                val = val >> 8;
            }
            // set the last byte that may not be full
            if ((li & 7) > 0) {
                buf = v->data[li >> 3];
                mask = (((uint8_t)1 << (uint8_t)(li & 7)) - 1);
                buf = (buf & ~mask)
                    | (((uint8_t)(val & 0xff)) & mask);
                v->data[li >> 3] = buf;
            }
        } else {
            mask = (((uint8_t)1 << (uint8_t)(fi & 7)) - 1);
            mask ^= (((uint8_t)1 << (uint8_t)(li & 7)) - 1);
            buf = v->data[fi >> 3];
            buf = (buf & ~mask)
                | ((((uint8_t)(val & 0xff)) << (fi & 7)) & mask);
            v->data[fi >> 3] = buf;
        }
    }
}

