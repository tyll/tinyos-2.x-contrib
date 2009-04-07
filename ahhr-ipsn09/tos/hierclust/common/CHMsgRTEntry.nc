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
 * A routing table entry in a distance vector message.
 *
 * @param nx_rt_entry_T   the network type of a routing table entry
 *
 * @author Konrad Iwanicki &lt;iwanicki@few.vu.nl&gt;
 */
interface CHMsgRTEntry<nx_rt_entry_T> {

    /**
     * Returns the size of a routing table entry.
     * @return the size of a routing table entry in bytes
     */
    command uint8_t getByteSize();

    /**
     * Returns the level of a routing table entry.
     * @param entry the entry for which the level is returned
     * @return the level of a routing table entry
     */
    command uint8_t getLevel(nx_rt_entry_T const * entry);

    /**
     * Sets the level of a routing table entry.
     * @param entry the entry for which the level is set
     * @param level the level to be set
     */
    command void setLevel(nx_rt_entry_T * entry, uint8_t level);

    /**
     * Returns the head of a routing table entry.
     * @param entry the entry for which the head is returned
     * @return the head of a routing table entry
     */
    command uint16_t getHead(nx_rt_entry_T const * entry);

    /**
     * Sets the head of a routing table entry.
     * @param entry the entry for which the head is set
     * @param head the head to be set
     */
    command void setHead(nx_rt_entry_T * entry, uint16_t head);

    /**
     * Returns the hop count of a routing table entry.
     * @param entry the entry for which the hop count is returned
     * @return the hop count of a routing table entry
     */
    command uint8_t getNumHops(nx_rt_entry_T const * entry);

    /**
     * Sets the hop count of a routing table entry.
     * @param entry the entry for which the hop count is set
     * @param numHops the hop count to be set
     */
    command void setNumHops(nx_rt_entry_T * entry, uint8_t numHops);

    /**
     * Returns the sequence number of a routing table entry.
     * @param entry the entry for which the sequence number is returned
     * @return the sequence number of a routing table entry
     */
    command ch_rt_entry_seq_no_t getSeqNo(nx_rt_entry_T const * entry);

    /**
     * Sets the sequence number of a routing table entry.
     * @param entry the entry for which the sequence number is set
     * @param advertSeqNo the sequence number to be set
     */
    command void setSeqNo(nx_rt_entry_T * entry, ch_rt_entry_seq_no_t advertSeqNo);

    /**
     * Returns the adjacency flag.
     * @param entry the entry for which the adjacency flag is returned
     * @return <code>TRUE</code> if the adjacency flag is set, <code>FALSE</code>
     *         if the adjacency flag is clear
     */
    command bool getAdjacencyFlag(nx_rt_entry_T const * entry);

    /**
     * Sets the adjacency flag.
     * @param entry the entry for which the adjacency flag is set
     * @param flag the value of the flag to be set
     */
    command void setAdjacencyFlag(nx_rt_entry_T * entry, bool flag);

}
