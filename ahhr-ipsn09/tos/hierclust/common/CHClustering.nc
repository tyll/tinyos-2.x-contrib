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
 * Clustering functionality.
 *
 * @author Konrad Iwanicki &lt;iwanicki@few.vu.nl&gt;
 */
interface CHClustering {

    /**
     * Returns the maximal propagation radius of an advertisement
     * for a cluster at a given level.
     * @param level the level of the cluster
     * @param maxPath the maximal path length in the network
     * @return the maximal propagation radius in hops
     */
    command uint8_t getMaxPropagationRadius(
            uint8_t level, uint8_t maxPath);

    /**
     * Returns the maximal join radius of a cluster at a given level.
     * Should be smaller than or equal to
     * <code>getMaxPropagationRadius(level - 1, maxPath)</code>
     * @param level the level of the cluster
     * @param maxPath the maximal path length in the network
     * @return the maximal join radius in hops
     */
    command uint8_t getMaxJoinRadius(
            uint8_t level, uint8_t maxPath);
            
    /**
     * Generates a slot which a node should take when promoting
     * itself to a higher level cluster.
     * @param level the current level of the node as a cluster head
     * @param density the average expected density of clusters at a given
     *        level
     * @return the slot number
     */
    command uint8_t generatePromotionSlotNo(uint8_t level, uint8_t density);
    
    /**
     * Checks whether the current node is allowed to become
     * a cluster head at a certain level.
     * This method may be used to prevent some nodes (e.g., ones
     * with limited energy) from becoming cluster heads.
     * @param level the level
     * @return <code>TRUE</code> if a node can promote itself to be
     *         a cluster head, otherwise <code>FALSE</code>
     */
    command bool canBecomeClusterHead(uint8_t level);

}
