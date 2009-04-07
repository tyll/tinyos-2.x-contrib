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
 * An interface for accessing the local state of the cluster hierarchy.
 *
 * @author Konrad Iwanicki &lt;iwanicki@few.vu.nl&gt;
 */
interface CHLocalState {

    /**
     * Returns the label length (which is also the hierarchy height).
     * @return the length of the node's label
     */
    command uint8_t getLabelLength();

    /**
     * Sets the label length.
     * @param len the length of the label to set (must be smaller than
     *        the maximal label length and greater than zero)
     */
    command void setLabelLength(uint8_t len);

    /**
     * Returns the <code>i</code>-th element of the node's label.
     * @param i the index of the element to return
     *        (must be smaller than the value of
     *        <code>getLabelLength()</code>)
     * @return the <code>i</code>-th element of the node's label
     */
    command uint16_t getLabelElement(uint8_t i);

    /**
     * Sets the <code>i</code>-th element of the node's label.
     * @param i the index of the element to set
     *        (must be smaller than the value of
     *        <code>getLabelLength()</code> and greater than one)
     * @param val the new value of the <code>i</code>-th element of the
     *        node's label
     */
    command void setLabelElement(uint8_t i, uint16_t val);

    /**
     * Returns the level of the node as a head.
     * @return the level of the node as a head
     */
    command uint8_t getLevelAsHead();

    /**
     * Returns the number of entries in the routing table.
     * @return the number of entries in the routing table
     */
    command uint8_t getRTSize();

    /**
     * Looks for a routing table entry for a cluster.
     * @param level the level of the cluster (must be greater than zero and
     *        smaller than the value of <code>getLabelLength()</code>)
     * @param head the head of the cluster
     * @return a pointer to the routing table entry or <code>NULL</code>
     *         if the entry does not exist
     */
    command ch_rt_entry_t * getRTEntry(uint8_t level, uint16_t head);

    /**
     * Adds a new routing table entry for a cluster.
     * If the entry exists already, it is returned. Otherwise, a new
     * entry is allocated from an entry pool.
     * @param level the level of the cluster (must be greater than zero and
     *        smaller than the value of <code>getLabelLength()</code>)
     * @param head the head of the cluster
     * @return a pointer to the added the routing table entry or
     *         <code>NULL</code> if the entry does not exist and the entry
     *         pool is full
     */
    command ch_rt_entry_t * putRTEntry(uint8_t level, uint16_t head);

    /**
     * Removes a routing table entry for a cluster.
     * @param level the level of the cluster (must be greater than zero and
     *        smaller than the value of <code>getLabelLength()</code>)
     * @param head the head of the cluster
     * @return the pointer to the removed entry, or <code>NULL</code> if
     *         the entry does not exist
     */
    command ch_rt_entry_t * removeRTEntry(uint8_t level, uint16_t head);

    /**
     * Removes a routing table entry for a cluster based on the pointers.
     * @param pentry a pointer to the entry to remove
     * @param pprev a pointer to the previous entry on
     *        the list or <code>NULL</code>
     */
    command void removeRTEntryByPointers(
        ch_rt_entry_t * pentry, ch_rt_entry_t * pprev);

    /**
     * Repositions an entry to a different level.
     * @param pentry a pointer to the entry to reposition
     * @param level the new level of the entry
     * @return the pointer to the repositioned entry (may be equal
     *         to <code>pentry</code>)
     */
    command ch_rt_entry_t * changeRTEntryLevel(
        ch_rt_entry_t * pentry, uint8_t level);

    /**
     * Returns a pointer to the first routing entry at a given level.
     * @param level the level
     * @return the pointer to the entry or <code>NULL</code> if no entries
     *         exist at a given level
     */
    command ch_rt_entry_t * getFirstRTEntryAtLevel(uint8_t level);

    /**
     * Returns a pointer to the next routing entry at a given level.
     * @param pentry the entry
     * @return the pointer to the entry or <code>NULL</code> if no more
     *         entries exist at a given level
     */
    command ch_rt_entry_t * getNextRTEntryAtLevel(ch_rt_entry_t const * pentry);

    /**
     * Looks up an entry at any level higher than the level given.
     * @param level the minimal level to look up an entry at
     * @param head the entry to look up
     * @return a pointer to the routing table entry or <code>NULL</code>
     *         if the entry does not exist
     */
    command ch_rt_entry_t * getRTEntryAtAnyHigherLevel(
        uint8_t level, uint16_t head);

}
