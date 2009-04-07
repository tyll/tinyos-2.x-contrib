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
 * An implementation of a layer in the communication stack that is
 * responsible for augmenting the messages with the link quality
 * information.
 *
 * This module is based on the default link estimation method in
 * TinyOS&nbsp;2.0.0 implemented by Omprakash Gnawali, which can be found
 * in <tt>tos/lib/net/le</tt> of the TinyOS 2.0.0 source code.
 * The paper describing the method was published in:
 * A. Woo, T. Tong, and D. Culler, ``Taming the underlying challenges
 * of reliable multihop routing in sensor networks.'' In <i>SenSys'03:
 * Proceedings of the First ACM Int'l Conf. on Embedded Networked Sensor
 * Systems</i>, Los Angeles, CA, USA, November 2003, pp. 14-27.
 *
 * However, this module involves some different solutions are used in
 * many places, for instance, for aging entries in the neighbor table.
 *
 * IMPORTANT NOTICE: This is estimator is put together with the framework
 * sources for compatibility with different sensor node platforms.
 * In particular, it differs from the estimator which was used to evaluate
 * the hierarchical routing framework in our paper: K. Iwanicki and M. van
 * Steen, ``On Hierarchical Routing in Wireless Sensor Networks.''
 * In <i>IPSN'09: Proceedings of the Eighth ACM/IEEE Int'l Conf. on
 * Information Processing in Sensor Networks</i>, San Francisco, CA, USA,
 * April 2009. Therefore, your results may vary.
 *
 * @author Konrad Iwanicki &lt;iwanicki@few.vu.nl&gt;
 */
module LinkEstimatorP {
    provides {
        interface Init;
        interface LinkEstimatorConfig as Config;

        interface NeighborTable;
        interface Iterator<neighbor_iter_t, neighbor_t>
            as NeighborTableIter;
        interface LinkEstimatorControl;

        interface Packet;
        interface AMSend;
        interface Receive as SnoopAndReceive;

        interface TOSSIMStats;
    }
    uses {
        interface Packet as SubPacket;
        interface AMPacket as SubAMPacket;
        interface AMSend as SubAMSend;
        interface Receive as SubSnoopAndReceive;
        interface Sequencing as SubSequencing;
        interface SequencingPacket as SubSequencingPacket;
    }
}
implementation {

    // --------------------------- Configuration --------------------------
    /**
     * The compile-time configuration.
     */
    enum STATIC_CONFIGURATION {
        /** the maximal number of possible neighbors */
        MAX_NUM_NEIGHBORS = DEF_MAX_NUM_NEIGHBORS
    };



    /**
     * The run-time configuration.
     */
    typedef struct {
        uint8_t   minMsgRecords;        // the minimal number of link
                                        // estimator records in a message
        uint8_t   maxMsgRecords;        // the maximal number of link
                                        // estimator records in a message
                                        // or zero denoting no limit
        uint8_t   evictionThreshold;    // the threshold for evicting
                                        // nodes from the neighbor table
                                        // if we lack space for new entries
        uint8_t   selectionThreshold;   // the threshold for selecting
                                        // nodes from the neighbor table
                                        // to put is a message
        uint8_t   maxRevLQAge;          // the maximal age of a reverse
                                        // link quality value
        uint8_t   maxForLQAge;          // the maximal age of a forward
                                        // link quality value
        uint8_t   lqRecompPeriod;       // the number of rounds every each
                                        // we recompute the reverse link
                                        // qualities
        uint8_t   lqRecompWeight;       // the weight used for recomputing
                                        // the new reverse link quality:
                                        // (oldLQ * x + measuredLQ *
                                        //    (255 - x)) / 255
        uint8_t   expNumPacketsForLQ;   // the expected number of packets
                                        // used for estimating the link
                                        // quality
    } config_t;


    /**
     * The default run-time configuration.
     */
    enum DEFAULT_DYNAMIC_CONFIGURATION {
        DEF_MIN_MSG_RECORDS = 5,
        DEF_MAX_MSG_RECORDS = 10,
        DEF_EVICTION_THRESHOLD = 128,
        DEF_SELECTION_THRESHOLD = 153,
        DEF_MAX_REV_LQ_AGE = 8,
        DEF_MAX_FOR_LQ_AGE = 16,
        DEF_LQ_RECOMP_PERIOD = 4,
        DEF_LQ_RECOMP_WEIGHT = 191, // 1/4 * 255
        DEF_EXP_NUM_PACKETS_FOR_LQ = DEF_LQ_RECOMP_PERIOD
    };



    // ------------------------- Private members --------------------------
    // the neighbor table
    neighbor_t neighbors[MAX_NUM_NEIGHBORS];
    // the number of valid neighbors in the neighbor table
    uint8_t    numValidNeighbors;

    // the index of the next neighbor that will be sent in the next message
    uint8_t    nextNeighborIdxToSend;
    // the counter for the link quality recomputation periods
    uint8_t    lqRecompCnt;

    // indicates the next neighbor to check for eviction
    // if equal to MAX_NUM_NEIGHBORS, no neighbors are supposed
    // to be evicted.
    uint8_t    nextNeighborIdxToEvict;

    // the run-time configuration
    config_t   config = {
        minMsgRecords : DEF_MIN_MSG_RECORDS,
        maxMsgRecords : DEF_MAX_MSG_RECORDS,
        evictionThreshold : DEF_EVICTION_THRESHOLD,
        selectionThreshold : DEF_SELECTION_THRESHOLD,
        maxRevLQAge : DEF_MAX_REV_LQ_AGE,
        maxForLQAge : DEF_MAX_FOR_LQ_AGE,
        lqRecompPeriod : DEF_LQ_RECOMP_PERIOD,
        lqRecompWeight : DEF_LQ_RECOMP_WEIGHT,
        expNumPacketsForLQ : DEF_EXP_NUM_PACKETS_FOR_LQ,
    };



    /*
     * Initializes the state.
     */
    inline void resetState() {
        uint8_t i;
        for (i = 0; i < MAX_NUM_NEIGHBORS; ++i) {
            neighbors[i].flags = 0;
        }
        numValidNeighbors = 0;
        nextNeighborIdxToSend = 0;
        lqRecompCnt = 0;
        nextNeighborIdxToEvict = MAX_NUM_NEIGHBORS;
    }



    /**
     * Prints a raw message.
     * @param msg the message to be printed
     * @param len the length of the message
     */
    void printRawMessage(message_t * msg, uint8_t len) {
#ifdef TOSSIM
#ifndef TOSSIM_NO_DEBUG
        uint8_t * d;
        uint8_t   i;

        d = (uint8_t *)msg->data;
        dbg("LE", "Raw message:");
        for (i = 0; i < len; ++i) {
            dbg_clear("LE", " %hhx", d[i]);
        }
        dbg_clear("LE", ".\n");
#endif
#endif
    }



    /**
     * Prints the neighbor table.
     */
    void printNeighborTable() {
#ifdef TOSSIM
#ifndef TOSSIM_NO_DEBUG
        uint8_t  i;

        dbg("LE", "Neighbor table (size = %hhu):\n", numValidNeighbors);
        for (i = 0; i < MAX_NUM_NEIGHBORS; ++i) {
            if ((neighbors[i].flags & NEIGHBOR_VALID) != 0) {
                dbg("LE", "  [addr=%hx, flags=", neighbors[i].llAddress);
                if ((neighbors[i].flags & NEIGHBOR_INIT) != 0) {
                    dbg_clear("LE", "I");
                }
                if ((neighbors[i].flags & NEIGHBOR_MATURE) != 0) {
                    dbg_clear("LE", "M");
                }
                if ((neighbors[i].flags & NEIGHBOR_PINNED) != 0) {
                    dbg_clear("LE", "P");
                }
                dbg_clear("LE", ", seq=%hhu, rcv=%hhu, drp=%hhu", \
                    neighbors[i].seqNo, neighbors[i].rcvCnt, \
                    neighbors[i].drpCnt);
                dbg_clear("LE", ", RQ=%hhu, RA=%hhu", \
                    neighbors[i].inLinkQ, neighbors[i].inAge);
                dbg_clear("LE", ", FQ=%hhu, FA=%hhu]\n", \
                    neighbors[i].outLinkQ, neighbors[i].outAge);
            }
        }
#endif
#endif
    }



    /*
     * Searches for a neighbor with a given link-layer address.
     * @param llAddress the link layer address to search for
     * @return the index of the neighbor if it was found or
     *         <code>MAX_NUM_NEIGHBORS</code> if such a neighbor does
     *         not exist
     */
    uint8_t findNeighborByAddr(am_addr_t llAddress) {
        uint8_t i;
        for (i = 0; i < MAX_NUM_NEIGHBORS; ++i) {
            if (neighbors[i].llAddress == llAddress &&
                    (neighbors[i].flags & NEIGHBOR_VALID) != 0) {
                return i;
            }
        }
        return MAX_NUM_NEIGHBORS;
    }



    /**
     * Allocates a neighbor assuming that it does not exist.
     * @return the index of the neighbor if it was allocated or
     *         <code>MAX_NUM_NEIGHBORS</code> no suitable slot was found
     */
    uint8_t allocateNeighbor() {
        uint8_t candIdx, candLQ;
        uint8_t i;

        candIdx = MAX_NUM_NEIGHBORS;
        candLQ = 0xff;
        for (i = 0; i < MAX_NUM_NEIGHBORS; ++i) {
            if ((neighbors[i].flags & NEIGHBOR_VALID) == 0) {
                // The entry is not valid so it immediately
                // becomes our candidate.
                return i;
            } else if ((neighbors[i].flags & NEIGHBOR_MATURE) == 0) {
                // The entry is not mature, so let's give it a chance.
                // Do nothing.
            } else if ((neighbors[i].flags & NEIGHBOR_PINNED) != 0) {
                // The entry is pinned, so we simply cannot remove it.
                // Do nothing.
            } else if (call NeighborTable.getBiDirLinkQuality(
                        &(neighbors[i])) < candLQ) {
                // We have found a possible candidate for our neighbor.
                candIdx = i;
                candLQ =
                    call NeighborTable.getBiDirLinkQuality(&(neighbors[i]));
            }
        }
        if (candIdx < MAX_NUM_NEIGHBORS &&
                candLQ < call Config.getEvictionThreshold()) {
            // There was no free slot, but we found a possible candidate
            // that will be eventually evicted.
            return candIdx;
        } else {
            // There was neither free slot nor a possible candidate
            // to evict.
            return MAX_NUM_NEIGHBORS;
        }
    }



    /**
     * Evicts marked neighbors.
     */
    task void taskEvictMarkedNeighbors() {
        uint8_t i;

        if (nextNeighborIdxToEvict >= MAX_NUM_NEIGHBORS) {
            // There is nobody to be evicted.
            return;
        }

        dbg("LE", "Evicting marked neighbors starting from " \
            "index %hhu.\n", nextNeighborIdxToEvict);

        // Find the neighbor to evict.
        for (i = nextNeighborIdxToEvict; i < MAX_NUM_NEIGHBORS; ++i) {
            if ((neighbors[i].flags & NEIGHBOR_TO_EVICT) != 0) {
                break;
            }
        }

        if (i < MAX_NUM_NEIGHBORS) {
            dbg("LE", "Evicting neighbor %hu (index %hhu).\n", \
                neighbors[i].llAddress, i);

            // Found the neighbor, so evict it.
            neighbors[i].flags = 0;
            signal NeighborTable.neighborEvicted(
                neighbors[i].llAddress);

            // Repost the task.
            nextNeighborIdxToEvict = i + 1;
            if (nextNeighborIdxToEvict >= MAX_NUM_NEIGHBORS) {
                nextNeighborIdxToEvict = 0;
            }
            post taskEvictMarkedNeighbors();

        } else {
            // No neighbor was found at the end, so start from
            // the beginning.
            for (i = 0; i < nextNeighborIdxToEvict; ++i) {
                if ((neighbors[i].flags & NEIGHBOR_TO_EVICT) != 0) {
                    break;
                }
            }

            if (i < nextNeighborIdxToEvict) {
                dbg("LE", "Evicting neighbor %hu (index %hhu).\n", \
                    neighbors[i].llAddress, i);

                // Found the neighbor, so evict it.
                neighbors[i].flags = 0;
                signal NeighborTable.neighborEvicted(
                    neighbors[i].llAddress);

                // Repost the task.
                nextNeighborIdxToEvict = i + 1;
                // NOTICE: No check for i is necessary here.
                post taskEvictMarkedNeighbors();

            } else {
                // No neighbor was found.
                nextNeighborIdxToEvict = MAX_NUM_NEIGHBORS;
            }
        }

    }



    /**
     * Updates the forward link quality information of a neighbor.
     * @param idx the index of the neighbor to update
     * @param hdr the header of the message
     * @param footer the footer of the message
     */
    void updateForwardLinkQuality(
            uint8_t idx, nx_le_header_t * hdr, nx_le_footer_t * footer) {
        am_addr_t myLLAddr;
        uint8_t   i, n;

        myLLAddr = call SubAMPacket.address();

        for (i = 0, n = (hdr->numRecordsAndFlags
                    & LE_HEADER_NUM_RECORDS_MASK);
                i < n; ++i) {

            if (footer->records[i].llAddress == myLLAddr) {
                neighbors[idx].outLinkQ = footer->records[i].lqIn;
                neighbors[idx].outAge = 0;
                break;
            }

        }
    }



    /**
     * Initializes a neighbor at a given index with
     * a given link-layer address.
     * @param idx the index of the neighbor to initialize
     * @param sender the sender of the message
     * @param hdr the header of the received message
     * @param footer the footer of the received message
     */
    void initNeighbor(
            uint8_t idx, am_addr_t sender,
            nx_le_header_t * hdr, nx_le_footer_t * footer,
            sequencing_seqno_t seqNo) {
        // Check if the neighbor was previously valid.
        if ((neighbors[idx].flags & NEIGHBOR_VALID) == 0) {
            ++numValidNeighbors;
        }
        // Initialize the neighbor.
        neighbors[idx].llAddress = sender;
        neighbors[idx].flags = (NEIGHBOR_VALID | NEIGHBOR_INIT);
        neighbors[idx].seqNo = seqNo;
        neighbors[idx].rcvCnt = 1;
        neighbors[idx].drpCnt = 0;
        neighbors[idx].inLinkQ = 0;
        neighbors[idx].inAge = 0;
        neighbors[idx].outLinkQ = 0;
        neighbors[idx].outAge = 0xff;
        // Update forward link quality
        updateForwardLinkQuality(idx, hdr, footer);
    }



    /**
     * Updates a neighbor with a given index after receiving a message
     * from that neighbor.
     * @param idx the index of the neighbor in the neighbor table
     * @param hdr the header of the received message
     * @param footer the footer of the received message
     */
    void updateNeighbor(
            uint8_t idx, nx_le_header_t * hdr, nx_le_footer_t * footer,
            sequencing_seqno_t seqNo) {
        // Update the neighbor.
        neighbors[idx].flags &= ~(NEIGHBOR_SUSPECTED | NEIGHBOR_PENALIZED);
        ++neighbors[idx].rcvCnt;
        neighbors[idx].drpCnt += seqNo - neighbors[idx].seqNo - 1;
        neighbors[idx].seqNo = seqNo;
        neighbors[idx].inAge = 0;
        // Update forward link quality
        updateForwardLinkQuality(idx, hdr, footer);
    }



    /**
     * Invalidates a neighbor at a given index.
     * <b>ASSUMPTION:</b> The neighbor was valid!
     * @param idx the index of the neighbor
     * @param neighbor the neighbor to invalidate
     */
    inline void invalidateNeighbor(uint8_t idx, neighbor_t * neighbor) {
        neighbor->flags = NEIGHBOR_TO_EVICT;
        --numValidNeighbors;
        if (nextNeighborIdxToEvict == MAX_NUM_NEIGHBORS) {
            nextNeighborIdxToEvict = idx;
            post taskEvictMarkedNeighbors();
        }
    }



    /**
     * Augments a message with the header and the footer information.
     * Actually only the link estimator records are added to the footer.
     * @param msg the message to be augmented
     * @param len the length of this message
     * @return the new length of the message
     */
    uint8_t augmentMessageWithLEInfo(message_t * msg, uint8_t len) {
        nx_le_header_t * hdr;
        nx_le_footer_t * footer;
        uint8_t          maxRecords;
        uint8_t          stopAtIdx;
        uint8_t          i, j;
        uint8_t *        oldPayload;

        dbg("LE", "Augmenting a %hhu-byte message with LE data.\n", len);

        // Get the LE header and footer.
        oldPayload = (uint8_t *)call SubPacket.getPayload(msg, NULL);
        hdr = (nx_le_header_t *)oldPayload;
        footer = (nx_le_footer_t *)(oldPayload + sizeof(nx_le_header_t) + len);

        // Compute the maximal number of LE records we can add.
        maxRecords = (call SubPacket.maxPayloadLength()
                - sizeof(nx_le_header_t) - len - sizeof(nx_le_footer_t)) /
            sizeof(nx_link_record_t);
        if (maxRecords > LE_HEADER_NUM_RECORDS_MASK) {
            maxRecords = LE_HEADER_NUM_RECORDS_MASK;
        }
        if (call Config.getMaxMsgRecords() > 0 &&
                maxRecords > call Config.getMaxMsgRecords()) {
            maxRecords = call Config.getMaxMsgRecords();
        }

        dbg("LE", "  - Trying to add %hhu LE records:\n", maxRecords);

        // Start adding records.
        stopAtIdx = nextNeighborIdxToSend - 1;
        if (stopAtIdx >= MAX_NUM_NEIGHBORS) {
            stopAtIdx = MAX_NUM_NEIGHBORS - 1;
        }
        for (i = nextNeighborIdxToSend, j = 0;
                i != stopAtIdx && j < maxRecords;
                i = (i + 1) % MAX_NUM_NEIGHBORS) {
            if ((neighbors[i].flags & NEIGHBOR_VALID) != 0 &&
                    neighbors[i].inLinkQ >=
                        call Config.getSelectionThreshold()) {
                footer->records[j].llAddress = neighbors[i].llAddress;
                footer->records[j].lqIn = neighbors[i].inLinkQ;
                ++j;
                dbg("LE", "    * %hhu added (%hx, %hhu)\n", j, \
                    neighbors[i].llAddress, neighbors[i].inLinkQ);
            }
        }
        nextNeighborIdxToSend = i;

        // Update the header.
        hdr->numRecordsAndFlags = 0; // no flags yet
        hdr->numRecordsAndFlags |= j; // j <= LE_HEADER_NUM_RECORDS_MASK

        // Compute the new packet size.
        i = sizeof(nx_le_header_t) + len + sizeof(nx_le_footer_t) +
            + sizeof(nx_link_record_t) * j;

        dbg("LE", "Message extended with LE data to %hhu bytes.\n", i);

        return i;
    }



    /**
     * Extracts the link estimator info from a received message
     * and updates the local structures.
     * @param msg the received message
     * @param payload the payload of the received message
     * @param len the length of the received message
     * @return the new length of the message (after choping the
     *         link estimator information), or 0xff denoting that
     *         the message was invalid
     */
    uint8_t extractLEInfoFromAMessage(
            message_t * msg, uint8_t * payload, uint8_t len) {
        nx_le_header_t * hdr;
        nx_le_footer_t * footer;
        am_addr_t        sender;
        sequencing_seqno_t   seqNo;
        uint8_t          numRecords;
        uint8_t          nidx;


        dbg("LE", "Extracting LE data from a %hhu-byte message.\n", len);

        printNeighborTable();

        // Get the header and the footer and check if they are correct.
        if (len < sizeof(nx_le_header_t) + sizeof(nx_le_footer_t)) {

            dbgerror("ERROR", "The length of the message %hhu is smaller " \
                "than the minimal length %hhu!\n", len, \
                sizeof(nx_le_header_t) + sizeof(nx_le_footer_t));

            return 0xff;

        } else {

            len -= (sizeof(nx_le_header_t) + sizeof(nx_le_footer_t));

        }

        hdr = (nx_le_header_t *)payload;
        numRecords = hdr->numRecordsAndFlags & LE_HEADER_NUM_RECORDS_MASK;
        if (len < sizeof(nx_link_record_t) * numRecords) {

            dbgerror("ERROR", "The length of the message %hhu and the " \
                "length of LE records %hhu do not match!\n", len, \
                sizeof(nx_link_record_t) * numRecords);

            return 0xff;

        } else {

            len -= sizeof(nx_link_record_t) * numRecords;

        }
        footer = (nx_le_footer_t *)(payload + sizeof(nx_le_header_t) + len);


        // Get the sender of the message.
        sender = call SubAMPacket.source(msg);

        // Get the sequence number.
        seqNo = call SubSequencingPacket.getSeqNo(msg);


        dbg("LE", "  - A message from neighbor %hx with #%hhu and " \
            "%hhu LE records.\n", sender, seqNo, numRecords);


        // Find an update the neigbhor that sent this message.
        nidx = findNeighborByAddr(sender);
        if (nidx < MAX_NUM_NEIGHBORS) {

            dbg("LE", "  - Neighbor %hx found at index %hhu.\n", \
                sender, nidx);

            updateNeighbor(nidx, hdr, footer, seqNo);

            dbg("LE", "  - Neighbor %hx at index %hhu updated.\n", \
                sender, nidx);

        } else {

            nidx = allocateNeighbor();

            if (nidx >= MAX_NUM_NEIGHBORS) {

                dbg("LE", "  - Neighbor %hx not found. Failed to " \
                    "allocate a slot for that neighbor.\n", sender);

                // Do nothing more.

            } else if ((neighbors[nidx].flags & (NEIGHBOR_VALID | NEIGHBOR_TO_EVICT)) == 0) {

                dbg("LE", "  - Neighbor %hx not found. Allocated " \
                    "an empty slot %hhu for that neighbor.\n", \
                    sender, nidx);

                initNeighbor(nidx, sender, hdr, footer, seqNo);

                dbg("LE", "  - Neighbor %hx at index %hhu initialized.\n", \
                    sender, nidx);

            } else {

                dbg("LE", "  - Neighbor %hx not found. Evicting " \
                    "neighbor %hx from slot %hhu.\n", \
                    sender, neighbors[nidx].llAddress, nidx);

                signal NeighborTable.neighborEvicted(
                    neighbors[nidx].llAddress);

                dbg("LE", "  - Neighbor %hx at index %hhu evicted.\n", \
                    neighbors[nidx].llAddress, nidx);

                initNeighbor(nidx, sender, hdr, footer, seqNo);

                dbg("LE", "  - Neighbor %hx at index %hhu initialized.\n", \
                    sender, nidx);

            }

        }

        printNeighborTable();

        dbg("LE", "LE data extracted leaving a %hhu-byte payload.\n", len);

        return len;
    }



    /**
     * Integrates the new link quality with the old value.
     * @param neighbor the pointer to the neighbor
     * @param lq the current link quality
     */
    inline void integrateLinkQuality(neighbor_t * neighbor, uint8_t lq) {
        neighbor->inLinkQ = (uint8_t)(
            ((uint16_t)call Config.getLQRecompWeight() *
                (uint16_t)neighbor->inLinkQ +
                (uint16_t)(255 - call Config.getLQRecompWeight()) * lq) /
                    255);
    }



    /**
     * Ages the neighbor table at the end of a period.
     */
    void ageNeighborTable() {
        neighbor_t *  n;
        uint8_t       expMsgs;
        uint8_t       currentLQ;
        uint8_t       i;

        dbg("LE", "Starting to age the neighbor table.\n");

        printNeighborTable();

        // Change the quality recomputation period.
        ++lqRecompCnt;
        if (lqRecompCnt >= call Config.getLQRecompPeriod()) {
            lqRecompCnt = 0;
            dbg("LE", "In the link quality recomputation period.\n");
        } else {
            dbg("LE", "The link quality recomputation period in " \
                "%hhu rounds.\n", \
                call Config.getLQRecompPeriod() - lqRecompCnt);
        }

        for (i = 0; i < MAX_NUM_NEIGHBORS; ++i) {
            if ((neighbors[i].flags & NEIGHBOR_VALID) != 0) {
                n = &(neighbors[i]);

                dbg("LE", "  - Neighbor %hu (idx=%hhu):\n", \
                    n->llAddress, i);

                // Increment the age of the entry.
                ++(n->inAge);
                ++(n->outAge);
                if (n->inAge > call Config.getMaxRevLQAge() ||
                        n->outAge > call Config.getMaxForLQAge()) {
                    // The age of the entry is too high, so we have
                    // to remove the entry.
                    invalidateNeighbor(i, n);

                    dbg("LE", "    * The neighbor was invalidated.\n");

                } else if (lqRecompCnt == 0) {
                    // The neighbor was ok.
                    if ((n->flags & NEIGHBOR_INIT) != 0) {
                        // This is a new entry, so we do not do much
                        // except for cleaning the flags.
                        n->flags &= ~NEIGHBOR_INIT;
                        n->rcvCnt = 0;
                        n->drpCnt = 0;
                        n->inLinkQ = 127;

                        dbg("LE", "    * Reset the INIT flag for " \
                            "the neighbor.\n");

                    } else {
                        // This entry has already been here for a while.

                        // Check if the neighbor was mature.
                        if ((n->flags & NEIGHBOR_MATURE) == 0) {
                            // The neighbor was not mature before.
                            n->flags |= NEIGHBOR_MATURE;
                        }

                        // Compute the new link quality
                        expMsgs = n->rcvCnt + n->drpCnt;
                        if (expMsgs <
                                call Config.getExpNumPacketsForLQ()) {
                            // NOTICE: The -1 is here to compensate for
                            //         some random jitter in message
                            //         transmission times.
                            expMsgs =
                                call Config.getExpNumPacketsForLQ() - 1;
                        }

                        if (expMsgs > 0) {
                            // There were some messages received
                            // in this period, so calculate the
                            // link quality in a straightforward way.
                            currentLQ = (uint8_t)(
                                ((uint16_t)n->rcvCnt * (uint16_t)255) /
                                    (uint16_t)expMsgs);

                            dbg("LE", "    * CurrentLQ=%hhu OldLQ=%hhu " \
                                "Weight=%hhu.\n", currentLQ, n->inLinkQ, \
                                call Config.getLQRecompWeight());

                            integrateLinkQuality(n, currentLQ);

                            dbg("LE", "    * NewLQ=%hhu.\n", n->inLinkQ);

                        } else if ((n->flags & NEIGHBOR_SUSPECTED) == 0) {
                            // There were no messages received in
                            // this period, but the neighbor was not
                            // suspected, so make it suspected, but
                            // give it one more chance.
                            n->flags |= NEIGHBOR_SUSPECTED;

                            dbg("LE", "    * NewLQ=OldLQ=%hhu InAge=%hhu.\n", \
                                n->inLinkQ, n->inAge);

                        } else {
                            // There were no messages received and the
                            // neighbor was suspected.
                            currentLQ = 0;

                            dbg("LE", "    * CurrentLQ=%hhu OldLQ=%hhu " \
                                "Weight=%hhu.\n", currentLQ, n->inLinkQ, \
                                call Config.getLQRecompWeight());

                            integrateLinkQuality(n, currentLQ);

                            if ((n->flags & NEIGHBOR_PENALIZED) == 0) {
                                // If the guy have not used his
                                // chance while being suspected,
                                // penalize him just now.
                                n->flags |= NEIGHBOR_PENALIZED;
                                integrateLinkQuality(n, currentLQ);
                            }

                            dbg("LE", "    * NewLQ=%hhu.\n", n->inLinkQ);
                        }


                        n->rcvCnt = 0;
                        n->drpCnt = 0;

                    } // (The neighbor was mature.)
                }
            } // (The neighbor was valid.)
        }

        dbg("LE", "Finished aging the neighbor table.\n");

        printNeighborTable();

    }



    // ------------------------- Interface Init ---------------------------
    command error_t Init.init() {
        dbg("LE", "Initializing the link estimator.\n");

        resetState();

        return SUCCESS;
    }



    // ------------------------ Interface Config --------------------------
    command inline uint8_t Config.getMinMsgRecords() {
        return config.minMsgRecords;
    }



    command inline void Config.setMinMsgRecords(uint8_t n) {
        dbg("LE", "Changing the minimal number of LE records in a " \
            "message from %hhu to %hhu.\n", config.minMsgRecords, n);
        config.minMsgRecords = n;
    }



    command inline uint8_t Config.getMaxMsgRecords() {
        return config.maxMsgRecords;
    }



    command inline void Config.setMaxMsgRecords(uint8_t n) {
        dbg("LE", "Changing the maximal number of LE records in a " \
            "message from %hhu to %hhu.\n", config.maxMsgRecords, n);
        config.maxMsgRecords = n;
    }



    command inline uint8_t Config.getEvictionThreshold() {
        return config.evictionThreshold;
    }



    command inline void Config.setEvictionThreshold(uint8_t t) {
        dbg("LE", "Changing the link quality threshold for eviction " \
            "of entries from a neighbor table from %hhu to %hhu.\n", \
            config.evictionThreshold, t);
        config.evictionThreshold = t;
    }



    command uint8_t Config.getSelectionThreshold() {
        return config.selectionThreshold;
    }



    command void Config.setSelectionThreshold(uint8_t t) {
        dbg("LE", "Changing the link quality threshold for selection " \
            "of entries for messages from %hhu to %hhu.\n", \
            config.selectionThreshold, t);
        config.selectionThreshold = t;
    }



    command inline uint8_t Config.getMaxRevLQAge() {
        return config.maxRevLQAge;
    }



    command inline void Config.setMaxRevLQAge(uint8_t age) {
        dbg("LE", "Changing the maximal age of a reverse link quality " \
            "value from %hhu to %hhu.\n", config.maxRevLQAge, age);
        config.maxRevLQAge = age;
    }



    command inline uint8_t Config.getMaxForLQAge() {
        return config.maxForLQAge;
    }



    command inline void Config.setMaxForLQAge(uint8_t age) {
        dbg("LE", "Changing the maximal age of a forward link quality " \
            "value from %hhu to %hhu.\n", config.maxForLQAge, age);
        config.maxForLQAge = age;
    }



    command inline uint8_t Config.getLQRecompPeriod() {
        return config.lqRecompPeriod;
    }



    command inline void Config.setLQRecompPeriod(uint8_t period) {
        dbg("LE", "Changing the reverse link quality recomputation " \
            "period from %hhu to %hhu.\n", config.lqRecompPeriod, period);
        config.lqRecompPeriod = period;
    }



    command inline uint8_t Config.getLQRecompWeight() {
        return config.lqRecompWeight;
    }



    command inline void Config.setLQRecompWeight(uint8_t weight) {
        dbg("LE", "Changing the reverse link quality recomputation " \
            "weight from %hhu to %hhu.\n", config.lqRecompWeight, weight);
        config.lqRecompWeight = weight;
    }



    command inline uint8_t Config.getExpNumPacketsForLQ() {
        return config.expNumPacketsForLQ;
    }



    command inline void Config.setExpNumPacketsForLQ(uint8_t n) {
        dbg("LE", "Changing the expected number of packets used for " \
            "the link estimator from %hhu to %hhu.\n", \
            config.expNumPacketsForLQ, n);
        config.expNumPacketsForLQ = n;
    }



    // -------------------- Interface NeighborTable -----------------------
    command inline uint8_t NeighborTable.getNumNeighbors() {
        return numValidNeighbors;
    }



    command neighbor_t * NeighborTable.getNeighbor(am_addr_t llAddress) {
        uint8_t idx = findNeighborByAddr(llAddress);
        if (idx < MAX_NUM_NEIGHBORS) {
            return &(neighbors[idx]);
        }
        return NULL;
    }



    command uint8_t NeighborTable.getBiDirLinkQuality(neighbor_t * n) {
        return n->outLinkQ < n->inLinkQ ? n->outLinkQ : n->inLinkQ;
    }



    command uint8_t NeighborTable.getForwardLinkQuality(neighbor_t * n) {
        return n->outLinkQ;
    }



    command uint8_t NeighborTable.getReverseLinkQuality(neighbor_t * n) {
        return n->inLinkQ;
    }



    command error_t NeighborTable.pinNeighbor(neighbor_t * n) {
        n->flags |= NEIGHBOR_PINNED;
        return SUCCESS;
    }



    command error_t NeighborTable.unpinNeighbor(neighbor_t * n) {
        n->flags &= ~NEIGHBOR_PINNED;
        return SUCCESS;
    }



    command bool NeighborTable.isNeighborPinned(neighbor_t * n) {
        return (n->flags & NEIGHBOR_PINNED) != 0;
    }



    default event void NeighborTable.neighborEvicted(am_addr_t llAddress) {
        // Do nothing.
    }



    // ------------------ Interface NeighborTableIter ---------------------
    command inline void NeighborTableIter.init(neighbor_iter_t * iter) {
        for (iter->index = 0;
                iter->index < MAX_NUM_NEIGHBORS;
                ++(iter->index)) {
            if ((neighbors[iter->index].flags & NEIGHBOR_VALID) != 0) {
                break;
            }
        }
    }



    command inline bool NeighborTableIter.hasNext(neighbor_iter_t * iter) {
        return iter->index < MAX_NUM_NEIGHBORS;
    }



    command inline neighbor_t * NeighborTableIter.next(
            neighbor_iter_t * iter) {
        neighbor_t * res;

        if (iter->index >= MAX_NUM_NEIGHBORS) {
            return NULL;
        }

        res = &(neighbors[iter->index]);
        do {
            ++(iter->index);
            if (iter->index >= MAX_NUM_NEIGHBORS) {
                break;
            }
        } while ((neighbors[iter->index].flags & NEIGHBOR_VALID) == 0);
        return res;
    }



    // ------------------ Interface LinkEstimatorControl ------------------
    command void LinkEstimatorControl.reset() {
        dbg("LE", "Reseting the link estimator [%s].\n", __FUNCTION__);

        resetState();

        dbg("LE", "The link estimator has been reset [%s].\n", __FUNCTION__);
    }



    command void LinkEstimatorControl.ageLinkQualities() {
        dbg("LE", "Entering the LE layer to age the neighbor table [%s].\n", \
            __FUNCTION__);

        ageNeighborTable();

        dbg("LE", "Leaving the LE layer after aging the neighbor " \
            "table [%s].\n", __FUNCTION__);
    }



    // ------------------------ Interface Packet --------------------------
    command void Packet.clear(message_t* msg) {
        nx_le_header_t * hdr;

        call SubPacket.clear(msg);

        // Make sure that the number of entries in the footer is zero.
        hdr = (nx_le_header_t *)(call SubPacket.getPayload(msg, NULL));
        hdr->numRecordsAndFlags = 0;
    }



    command uint8_t Packet.payloadLength(message_t* msg) {
        uint8_t          payloadLen;
        nx_le_header_t * hdr;

        hdr =
            (nx_le_header_t *)(call SubPacket.getPayload(
                msg, &payloadLen));

        return payloadLen
            - sizeof(nx_le_header_t)
            - sizeof(nx_le_footer_t)
            - sizeof(nx_link_record_t) *
                (LE_HEADER_NUM_RECORDS_MASK & hdr->numRecordsAndFlags);
    }



    command void Packet.setPayloadLength(message_t* msg, uint8_t len) {
        nx_le_header_t * hdr =
            (nx_le_header_t *)(call SubPacket.getPayload(msg, NULL));

        call SubPacket.setPayloadLength(msg, len
            + sizeof(nx_le_header_t)
            + sizeof(nx_le_footer_t)
            + sizeof(nx_link_record_t) *
                (LE_HEADER_NUM_RECORDS_MASK & hdr->numRecordsAndFlags));
    }



    command uint8_t Packet.maxPayloadLength() {
        return call SubPacket.maxPayloadLength()
            - sizeof(nx_le_header_t)
            - sizeof(nx_le_footer_t)
            - sizeof(nx_link_record_t)
                * (config.minMsgRecords & LE_HEADER_NUM_RECORDS_MASK);
    }



    command void* Packet.getPayload(message_t* msg, uint8_t* len) {
        uint8_t *        payload;
        nx_le_header_t * hdr;

        payload = call SubPacket.getPayload(msg, len);
        hdr = (nx_le_header_t *)payload;

        if (len != NULL) {
            *len = *len
                - sizeof(nx_le_header_t)
                - sizeof(nx_le_footer_t)
                - sizeof(nx_link_record_t) *
                    (LE_HEADER_NUM_RECORDS_MASK & hdr->numRecordsAndFlags);
        }

        return payload + sizeof(nx_le_header_t);
    }



    // ------------------------ Interface AMSend --------------------------
    command error_t AMSend.send(
            am_addr_t addr, message_t * msg, uint8_t len) {
        dbg("LE", "Packet to send %x enters the LE layer [%s].\n", \
            msg, __FUNCTION__);

        len = augmentMessageWithLEInfo(msg, len);

        printRawMessage(msg, len);

        return call SubAMSend.send(addr, msg, len);
    }



    command error_t AMSend.cancel(message_t* msg) {
        return call SubAMSend.cancel(msg);
    }



    event void SubAMSend.sendDone(message_t* msg, error_t error) {
        dbg("LE", "Packet to send %x leaves the LE layer [%s].\n", \
            msg, __FUNCTION__);

        signal AMSend.sendDone(msg, error);
    }



    command uint8_t AMSend.maxPayloadLength() {
        return call Packet.maxPayloadLength();
    }



    command void* AMSend.getPayload(message_t* msg) {
        return call Packet.getPayload(msg, NULL);
    }



    // ------------------- Interface SnoopAndReceive ----------------------
    event message_t* SubSnoopAndReceive.receive(
            message_t* msg, void* payload, uint8_t len) {

        dbg("LE", "Packet received %x enters the LE layer [%s].\n", \
            msg, __FUNCTION__);

        printRawMessage(msg, len);

        len = extractLEInfoFromAMessage(msg, payload, len);

        if (len == 0xff) {

            dbg("LE", "Dropping packet %x without LE data [%s].\n", \
                msg, __FUNCTION__);

            return msg;
        } else {
            payload = (uint8_t *)payload + sizeof(nx_le_header_t);

            dbg("LE", "Packet received %x leaves the LE layer [%s].\n", \
                msg, __FUNCTION__);

            return signal SnoopAndReceive.receive(msg, payload, len);
        }
    }



    command void* SnoopAndReceive.getPayload(message_t* msg, uint8_t* len) {
        return call Packet.getPayload(msg, len);
    }



    command uint8_t SnoopAndReceive.payloadLength(message_t* msg) {
        return call Packet.payloadLength(msg);
    }



    // --------------------- Interface SubSequencing -----------------------
    event inline void SubSequencing.seqNoOverflow() {
        // Do nothing.
    }



    // ---------------------- Interface TOSSIMStats -----------------------
    command void TOSSIMStats.report() {
#ifdef TOSSIM
//         uint8_t  i, lq;
// 
//         sim_ki_le_start_reporting_node_data(TOS_NODE_ID);
//         for (i = 0; i < MAX_NUM_NEIGHBORS; ++i) {
//             if ((neighbors[i].flags & NEIGHBOR_VALID) != 0) {
//                 lq = call NeighborTable.getBiDirLinkQuality(&neighbors[i]);
//                 sim_ki_le_report_node_neighbor(
//                     TOS_NODE_ID, neighbors[i].llAddress,
//                     neighbors[i].inLinkQ, neighbors[i].outLinkQ, lq);
//             }
//         }
//         sim_ki_le_finish_reporting_node_data(TOS_NODE_ID);
#endif
    }

}

