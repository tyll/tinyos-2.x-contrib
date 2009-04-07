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
 * An interface for configuring the engine for maintaining
 * the cluster hierarchy.
 *
 * @author Konrad Iwanicki &lt;iwanicki@few.vu.nl&gt;
 */
interface ClusterHierarchyMaintenanceConfig {

    /**
     * Returns the maximal backoff period when issuing an advert message.
     * @return the maximal advert issuing backoff period in milliseconds
     */
    command uint32_t getMaxAdvertIssuingBackoff();

    /**
     * Sets the maximal backoff period when issuing an advert message.
     * @param period the maximal backoff period to set
     */
    command void setMaxAdvertIssuingBackoff(uint32_t period);

    /**
     * Returns the maximal backoff period when forwarding an advert message.
     * @return the maximal advert forwarding backoff period in milliseconds
     */
    command uint32_t getMaxAdvertForwardingBackoff();

    /**
     * Sets the maximal backoff period when forwarding an advert message.
     * @param period the maximal backoff period to set
     */
    command void setMaxAdvertForwardingBackoff(uint32_t period);


    /**
     * Returns the duty cycle period.
     * @return the duty cycle period in milliseconds
     */
    command uint32_t getDutyCylePeriod();

    /**
     * Sets the duty cycle period.
     * @param period the duty cycle period to set
     */
    command void setDutyCylePeriod(uint32_t period);

    /**
     * Returns the white bidirectional link-quality threshold.
     * @return the white neighbor threshold <code>[0..255]</code>
     */
    command uint8_t getWhiteLQThreshold();

    /**
     * Sets the white bidirectional link-quality threshold.
     * @param t the white threshold to be set <code>[0..255]</code>
     */
    command void setWhiteLQThreshold(uint8_t t);

    /**
     * Returns the gray bidirectional link-quality threshold.
     * @return the gray neighbor threshold <code>[0..255]</code>
     */
    command uint8_t getGrayLQThreshold();

    /**
     * Sets the gray bidirectional link-quality threshold.
     * @param t the gray threshold to be set <code>[0..255]</code>
     */
    command void setGrayLQThreshold(uint8_t t);

    /**
     * Returns the maximal path length possible in the system.
     * @return the maximal path length in the system
     */
    command uint8_t getMaxPathLength();

    /**
     * Sets the maximal path length possible in the system.
     * @param l the maximal path length to set
     */
    command void setMaxPathLength(uint8_t l);


}
