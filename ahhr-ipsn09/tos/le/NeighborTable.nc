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
#include "LinkEstimator.h"

/**
 * An interface used for managing neighbors.
 *
 * A neighbor is represented by the <code>neighbor_t</code> type.
 * It is uniquely identified by its link-layer address.
 *
 * For a given neighbor we are able to retrieve link qualities in either
 * direction.
 *
 * @author Konrad Iwanicki &lt;iwanicki@few.vu.nl&gt;
 */
interface NeighborTable {
    
    /**
     * Returns the number of valid neighbors in the neighbor table.
     * @return the number of valid neighbors in the neighbor table
     */
    command uint8_t getNumNeighbors();

    /**
     * Searches for a neighbor with a given link-layer address.
     * @param llAddress the link-layer address of the neighbor
     * @return the pointer to the found neighbor or <code>NULL</code> if
     *         a neighbor with a given link layer address does not exist
     */
    command neighbor_t * getNeighbor(am_addr_t llAddress);

    /**
     * Returns the bidirectional link quality to a given neighbor.
     * @param n the given neighbor
     * @return the quality of the link self<->neighbor <code>0..255</code>
     *         (where <code>0</code> - bad and <code>255</code> - perfect)
     */
    command uint8_t getBiDirLinkQuality(neighbor_t * n);

    /**
     * Returns a forward link quality to a given neighbor.
     * @param n the given neighbor
     * @return the quality of the link self->neighbor <code>0..255</code>
     *         (where <code>0</code> - bad and <code>255</code> - perfect)
     */
    command uint8_t getForwardLinkQuality(neighbor_t * n);

    /**
     * Returns a backward link quality to a given neighbor.
     * @param n the given neighbor
     * @return the quality of the link neighbor->self <code>0..255</code>
     *         (where <code>0</code> - bad and <code>255</code> - perfect)
     */
    command uint8_t getReverseLinkQuality(neighbor_t * n);

    /**
     * Pins a neigbhor in the neighbor table such that it
     * cannot be evicted.
     * @param n the neighbor to be pinned
     * @return <code>SUCCESS</code> if the neighbor was successfully
     *         pinned, otherwise <code>FAIL</code> and the pinned/unpinned
     *         state of the neighbor remains unchanged
     */
    command error_t pinNeighbor(neighbor_t * n);

    /**
     * Unpins a neighbor in the neighbor table such that
     * it can be evicted at any time.
     * @param n the neigbhor to be unpinned
     * @return <code>SUCCESS</code> if the neighbor was successfully
     *         unpinned, otherwise <code>FAIL</code> and the pinned/unpinned
     *         state of the neighbor remains unchanged
     */
    command error_t unpinNeighbor(neighbor_t * n);

    /**
     * Checks whether a neighbor is pinned.
     * @param the neighbor to check
     * @return <code>TRUE</code> if the neighbor is pinned, otherwise
     *         <code>FALSE</code>
     */
    command bool isNeighborPinned(neighbor_t * n);

    /**
     * An event called when a neighbor was evicted from the
     * neighbor table.
     * @param llAddress the link-layer address of the evicted neighbor
     */
    event void neighborEvicted(am_addr_t llAddress);

}

