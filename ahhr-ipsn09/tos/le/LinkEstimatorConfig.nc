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
 * A configuration for the link estimator. Allows its users to modify
 * some parameters of the link estimator at run-time.
 *
 * @author Konrad Iwanicki &lt;iwanicki@few.vu.nl&gt;
 */
interface LinkEstimatorConfig {
    
    /**
     * Returns the minimal number of link estimator records that
     * can be embedded in a single message.
     * @return the minimal number of link estimator records in piggybacked
     *         in a message
     */
    command uint8_t getMinMsgRecords();

    /**
     * Sets the minimal number of link estimator records that can be
     * embedded in a single message.
     * @param n the number of records to set
     */
    command void setMinMsgRecords(uint8_t n);

    /**
     * Returns the maximal number of link estimator records that
     * can be embedded in a single message.
     * @return the maximal number of link estimator records in piggybacked
     *         in a message, or zero denoting that there is no such
     *         a limit.
     */
    command uint8_t getMaxMsgRecords();

    /**
     * Sets the maximal number of link estimator records that can be
     * embedded in a single message.
     * @param n the number of records to set or zero denoting no limit
     */
    command void setMaxMsgRecords(uint8_t n);

    /**
     * Returns the quality threshold for removing a neighbor from
     * the neighbor table if there is no space to add a new neighbor.
     * @return the eviction threshold <code>0..255</code>
     */
    command uint8_t getEvictionThreshold();
    
    /**
     * Sets the quality threshold for removing a neighbor from the
     * neighbor table if there is no space to add a new neighbor.
     * The neighbors with link qualities <em>below</em> this threshold
     * will be removed.
     * @param t the eviction threshold <code>0..255</code>
     */
    command void setEvictionThreshold(uint8_t t);

    /**
     * Returns the reverse link quality threshold for putting a neighbor
     * record into a message.
     * @return the threshold for selecting a node to a message
     *         <code>0..255</code>
     */
    command uint8_t getSelectionThreshold();

    /**
     * Sets the reverse link quality threshold for putting a neighbor
     * record into a message.
     * @param t the threshold for selecting a node to a message
     *          <code>0..255</code>
     */
    command void setSelectionThreshold(uint8_t t);

    /**
     * Returns the maximal age of the reverse link quality value.
     * @return the maximal age of the reverse link quality value
     */
    command uint8_t getMaxRevLQAge();

    /**
     * Sets the maximal age of the reverse link quality value.
     * @param age the maximal age of the reverse link quality value
     */
    command void setMaxRevLQAge(uint8_t age);

    /**
     * Returns the maximal age of the forward link quality value.
     * @return the maximal age of the forward link quality value
     */
    command uint8_t getMaxForLQAge();

    /**
     * Sets the maximal age of the forward link quality value.
     * @param age the maximal age of the forward link quality value
     */
    command void setMaxForLQAge(uint8_t age);
    
    /**
     * Returns the number of rounds every which we recompute the
     * reverse link qualities.
     * @return the reverse link quality recomputation period
     */
    command uint8_t getLQRecompPeriod();

    /**
     * Sets the number of rounds every which we recompute the
     * reverse link qualities.
     * @param period the reverse link quality recomputation period
     */
    command void setLQRecompPeriod(uint8_t period);

    /**
     * Returns the weight used for recomputing the new reverse link
     * quality based on the old value and the measured value.
     * @return the weight used for recomputing the reverse link quality
     */
    command uint8_t getLQRecompWeight();

    /**
     * Sets the weight used for recomputing the new reverse link
     * quality based on the old value and the measured value.
     * @return weight the weight to be set
     */
    command void setLQRecompWeight(uint8_t weight);
    
    /**
     * Returns the expected number of messages a node should receive
     * during the period between two subsequent recomputations of link
     * qualities.
     * @return the expected number of packets that should be received
     *         during two subsequent recomputations of link qualities
     */
    command uint8_t getExpNumPacketsForLQ();

    /**
     * Sets the expected number of messages a node should receive
     * during the period between two subsequent recomputations of link
     * qualities.
     * @param n the expected number of packets that should be received
     *        during two subsequent recomputations of link qualities
     */
    command void setExpNumPacketsForLQ(uint8_t n);
}

