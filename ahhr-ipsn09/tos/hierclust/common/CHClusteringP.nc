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
#include "ClusterHierarchy.h"


/**
 * The implementation of the clustering functionality.
 *
 * @author Konrad Iwanicki &lt;iwanicki@few.vu.nl&gt;
 */
module CHClusteringP {
    provides {
        interface CHClustering;
    }
    uses {
        interface Random;
    }
}
implementation {
    // ------------------------ Private members ---------------------------
    enum {
        CH_NUMBER_OF_SLOTS_AT_LEVEL_ZERO = 10,
        CH_NUMBER_OF_SLOTS_AT_HIGHER_LEVELS = 2,
    };



    /**
     * Returns <code>2^i</code>.
     * If this value is greater than <code>0xff</code>, <code>0xff</code>
     * is returned.
     * @param i the exponent
     * @return <code>2^i</code>
     */
    uint8_t twoPower(uint8_t i);
    /**
     * Trims a distance value to the maximal path length.
     * @param d the distance
     * @param maxPath the maximal path length
     * @return the trimmed distance
     */
    uint8_t trimDistance(uint8_t d, uint8_t maxPath);



    // ---------------------- Interface CHClustering ----------------------
    command inline uint8_t CHClustering.getMaxPropagationRadius(
            uint8_t level, uint8_t maxPath) {
        return trimDistance(twoPower(level), maxPath);
    }



    command inline uint8_t CHClustering.getMaxJoinRadius(
            uint8_t level, uint8_t maxPath) {
        return call CHClustering.getMaxPropagationRadius(level, maxPath) >> 1;
    }



    command inline uint8_t CHClustering.generatePromotionSlotNo(
            uint8_t level, uint8_t density) {
        // NOTICE: Uniform distribution.
//         return (call Random.rand16()) %
//             (level == 0 ?
//                 CH_NUMBER_OF_SLOTS_AT_LEVEL_ZERO :
//                 CH_NUMBER_OF_SLOTS_AT_HIGHER_LEVELS);
        // NOTICE: Exponential distribution.
        uint16_t  r;
        uint16_t  m;
        uint8_t   s;

        if (level > 0) {
            return call Random.rand16() %
                CH_NUMBER_OF_SLOTS_AT_HIGHER_LEVELS;
        }

        for (m = 1, s = 0; m < density; ) {
            m <<= 1;
            ++s;
        }
        r = call Random.rand16() & (m - 1);
        while (m > 1) {
            m >>= 1;
            if (r > m) {
                return s;
            }
            --s;
        }
        return 0;
        // OPTIMIZE: So far the slots are selected uniformly or
        //           exponentially at random. In the future use selection:
        //           p_i = ( 2 * (d - s) * i ) / ( d * s * (s - 1) ) + 1 / d
        //           where:
        //           - p_i   the probability of selecting the i-th slot
        //           - d     the network density
        //           - s     the maximal number of slots at a given level
    }



    command inline bool CHClustering.canBecomeClusterHead(uint8_t level) {
        // NOTICE: Here we can put arbitrary constraints.
        //         This constraint, for instance, allows
        //         any node to become a cluster head.
        return TRUE;
    }



    // ---------------------- Function implementations --------------------
    inline uint8_t twoPower(uint8_t i) {
        return i > 7 ? 0xff : ((uint8_t)1 << i);
    }



    inline uint8_t trimDistance(uint8_t d, uint8_t maxPath) {
        return d > maxPath ? maxPath : d;
    }

}
