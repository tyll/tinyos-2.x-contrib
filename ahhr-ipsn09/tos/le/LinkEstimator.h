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

#ifndef __LINK_ESTIMATOR__H__
#define __LINK_ESTIMATOR__H__

#include <message.h>
#include <AM.h>
#include "Sequencing.h"


/*
 * This file contains data types used for estimating the quality of
 * the links between nodes.
 *
 * @author Konrad Iwanicki &lt;iwanicki@few.vu.nl&gt;
 */



// *************************** Local structures ***************************

/**
 * Information about a neighbor stored by a node.
 */
typedef struct {
    am_addr_t           llAddress;     // the link-layer address of the neighbor
    uint8_t             flags;         // the flags of an entry in the neighbor
    sequencing_seqno_t  seqNo;         // the sequence number of the last packet
                                       // received from the neighbor

    uint8_t             rcvCnt;        // the number of received packtes,
                                       // since the estimates were updated for
                                       // the last time (inAge)
    uint8_t             drpCnt;        // the number of dropped packets,
                                       // since the estimates were updated for
                                       // the last time (inAge)

    uint8_t             inLinkQ;       // the inbound quality of the link
                                       // (node->self)
    uint8_t             inAge;         // the number of rounds since the last
                                       // update of the inbound link quality
                                       // and the number of neighbors

    uint8_t             outLinkQ;      // the outbound quality of the link
                                       // (self->node)
    uint8_t             outAge;        // the number of rounds since the last
                                       // update of the outbound link quality
} neighbor_t;



/**
 * Iterator over the neighbor table.
 */
typedef struct {
    uint8_t    index;            // current position of the iterator
} neighbor_iter_t;



/**
 * Possible flags of the neighbor.
 */
enum {
    // the entry contains a valid neighbor
    NEIGHBOR_VALID   = 0x01,
    // we received the first packet from the neighbor
    NEIGHBOR_INIT    = 0x02,
    // we computed the link quality for the neighbor after
    // we received enough messages
    NEIGHBOR_MATURE  = 0x04,
    // the neighbor is pinned so we cannot evict it
    NEIGHBOR_PINNED  = 0x08,
    // the neighbor is suspected of being dead,
    // as we have not receive a message from it
    // in the last round; if we do not receive
    // a message in the next round, we count as two
    // rounds with no messages; this flag is necessary
    // for dealing with random jitter to the
    // transmission times
    NEIGHBOR_SUSPECTED = 0x10,
    // the neighbor already suffered from being suspected
    NEIGHBOR_PENALIZED = 0x20,
    // the neighbor is invalid but awaits for the eviction signal
    NEIGHBOR_TO_EVICT = 0x40,
};



// CTCONFIG: The maximal number of neighbors in a node's neighbor table.
#ifndef DEF_MAX_NUM_NEIGHBORS
#define DEF_MAX_NUM_NEIGHBORS 100
#endif //DEF_MAX_NUM_NEIGHBORS
// ENDCTCONFIG



// ************************** Message structures **************************

/**
 * A link estimator header.
 */
typedef nx_struct {
    nx_uint8_t   numRecordsAndFlags;  // the number of neighbors in this
                                      // particular message
} nx_le_header_t;


/**
 * A link quality record in message.
 */
typedef nx_struct {
    nx_am_addr_t   llAddress;         // the link-layer address of a node
    nx_uint8_t     lqIn;              // the link quality from the node to
                                      // the sender of the beacon
                                      // (the reverse link quality)
} nx_link_record_t;


/**
 * A link estimator footer.
 *
 * The footer is of a variable size.
 * The 1 value is to prevent any code optimizations.
 */
typedef nx_struct {
    nx_link_record_t  records[0];  // link quality records
} nx_le_footer_t;


/**
 * Constants related to the messages.
 */
enum {
    // the mask used to obtain the number of records
    // in the link estimator footer
    LE_HEADER_NUM_RECORDS_MASK = 0x0f
};

#endif //__LINK_ESTIMATOR__H__

