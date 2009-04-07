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
 * An implementation of the common configuration for the cluster
 * hierarchy maintenance engine.
 *
 * @author Konrad Iwanicki &lt;iwanicki@few.vu.nl&gt;
 */
module CHConfigP {
    provides {
        interface ClusterHierarchyMaintenanceConfig as Config;
    }
}
implementation {

    // ------------------------- Private members --------------------------
    uint32_t   maxAdvertIssuingBackoff = ((uint32_t)1024 * (60 * 5 - 10));   // 5 minutes - 10 seconds
    uint32_t   maxAdvertForwardingBackoff = ((uint32_t)1024 * 10);           // 10 seconds
    uint32_t   dutyCyclePeriod = ((uint32_t)1024 * 60 * 5);                  // 5 minutes
    uint8_t    whiteLQThreshold = 191;                                       // 75%
    uint8_t    grayLQThreshold = 127;                                        // 50%
    uint8_t    maxPathLength = 128;                                          // 128




    // ------------------------- Interface Config -------------------------
    command inline uint32_t Config.getMaxAdvertIssuingBackoff() {
        return maxAdvertIssuingBackoff;
    }



    command inline void Config.setMaxAdvertIssuingBackoff(uint32_t period) {
#ifdef TOSSIM
        printf(
            "CONFIG|ClusterHierarchy @%lld [MaxAdvertIssuingBackoff]: %u\n",
            sim_time(), (unsigned int)period);
#endif
        maxAdvertIssuingBackoff = period;
    }



    command inline uint32_t Config.getMaxAdvertForwardingBackoff() {
        return maxAdvertForwardingBackoff;
    }



    command inline void Config.setMaxAdvertForwardingBackoff(uint32_t period) {
#ifdef TOSSIM
        printf(
            "CONFIG|ClusterHierarchy @%lld [MaxAdvertForwardingBackoff]: %u\n",
            sim_time(), (unsigned int)period);
#endif
        maxAdvertForwardingBackoff = period;
    }



    command inline uint32_t Config.getDutyCylePeriod() {
        return dutyCyclePeriod;
    }



    command inline void Config.setDutyCylePeriod(uint32_t period) {
#ifdef TOSSIM
        printf(
            "CONFIG|ClusterHierarchy @%lld [DutyCylePeriod]: %u\n",
            sim_time(), (unsigned int)period);
#endif
        dutyCyclePeriod = period;
    }



    command inline uint8_t Config.getWhiteLQThreshold() {
        return whiteLQThreshold;
    }



    command inline void Config.setWhiteLQThreshold(uint8_t t) {
#ifdef TOSSIM
        printf(
            "CONFIG|ClusterHierarchy @%lld [WhiteLQThreshold]: %hhu\n",
            sim_time(), t);
#endif
        whiteLQThreshold = t;
    }



    command inline uint8_t Config.getGrayLQThreshold() {
        return grayLQThreshold;
    }



    command inline void Config.setGrayLQThreshold(uint8_t t) {
#ifdef TOSSIM
        printf(
            "CONFIG|ClusterHierarchy @%lld [GrayLQThreshold]: %hhu\n",
            sim_time(), t);
#endif
        grayLQThreshold = t;
    }



    command inline uint8_t Config.getMaxPathLength() {
        return maxPathLength;
    }



    command inline void Config.setMaxPathLength(uint8_t l) {
#ifdef TOSSIM
        printf(
            "CONFIG|ClusterHierarchy @%lld [MaxPathLength]: %hhu\n",
            sim_time(), l);
#endif
        maxPathLength = l;
    }
}
