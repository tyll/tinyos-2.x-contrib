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
 * An implementation of the hierarchical forwarding engine.
 *
 * @author Konrad Iwanicki &lt;iwanicki@few.vu.nl&gt;
 */
module CHRoutingP {
    provides {
        interface CHRouting;
    }
    uses {
        interface CHLocalState as CHState;
        interface CHClustering;
        interface ClusterHierarchyMaintenanceConfig as CHConfig;
        interface NeighborTable as NeighborTable;
        interface NxVector<uint16_t> as MessageLabel;
        interface Random;
    }
}
implementation {

    // ----------------------- Interface CHRouting -------------------------
    command inline uint8_t CHRouting.getRoutingHeaderSize() {
        return sizeof(nx_ch_routing_message_header_t) +
            call MessageLabel.getByteLen(CH_MAX_LABEL_LENGTH);
    }



    command inline void CHRouting.clearRoutingHeader(
            nx_ch_routing_message_header_t * hdr) {
        hdr->ttl = 0;
        hdr->level = CH_MAX_LABEL_LENGTH;
        call MessageLabel.setLen((nx_ch_label_t *)(&(hdr->dstLab[0])), 0);
    }



    command inline error_t CHRouting.setRoutingHeaderDstLabelLength(
            nx_ch_routing_message_header_t * hdr, uint8_t len) {
        if (len == 0 || len > CH_MAX_LABEL_LENGTH) {
            return EINVAL;
        }
        call MessageLabel.setLen((nx_ch_label_t *)(&(hdr->dstLab[0])), len);
        return SUCCESS;
    }



    command inline uint8_t CHRouting.getRoutingHeaderDstLabelLength(
            nx_ch_routing_message_header_t const * hdr) {
        return call MessageLabel.getLen((nx_ch_label_t *)(&(hdr->dstLab[0])));
    }



    command inline error_t CHRouting.setRoutingHeaderDstLabelElement(
            nx_ch_routing_message_header_t * hdr, uint8_t i, uint16_t val) {
        if (i >= CH_MAX_LABEL_LENGTH ||
                i >= call MessageLabel.getLen((nx_ch_label_t *)(&(hdr->dstLab[0]))) ||
                val == CH_INVALID_CLUSTER_HEAD) {
            return EINVAL;
        }
        call MessageLabel.setEl(
            (nx_ch_label_t *)(&(hdr->dstLab[0])), i, val);
        return SUCCESS;
    }



    command inline uint16_t CHRouting.getRoutingHeaderDstLabelElement(
            nx_ch_routing_message_header_t const * hdr, uint8_t i) {
        if (i >= CH_MAX_LABEL_LENGTH ||
                i >= call MessageLabel.getLen((nx_ch_label_t *)(&(hdr->dstLab[0])))) {
            return CH_INVALID_CLUSTER_HEAD;
        }
        return call MessageLabel.getEl(
            (nx_ch_label_t *)(&(hdr->dstLab[0])), i);
    }



    command am_addr_t CHRouting.getNextRoutingHop(
            nx_ch_routing_message_header_t * hdr) {
        uint8_t    dstLabelLength;
        uint8_t    minLabelLength;
        uint16_t   dstNodeId;

        dstLabelLength =
            call MessageLabel.getLen((nx_ch_label_t *)(&(hdr->dstLab[0])));

        if (dstLabelLength == 0 || dstLabelLength > CH_MAX_LABEL_LENGTH) {
            dbgerror("CH|ERROR", \
                "Invalid length, %hhu, of the routing destination " \
                "label! [%s]\n", dstLabelLength, __FUNCTION__);
            return AM_BROADCAST_ADDR;
        }

        minLabelLength =
           call CHState.getLabelLength() < dstLabelLength ?
               call CHState.getLabelLength() : dstLabelLength;


        if (hdr->level >= CH_MAX_LABEL_LENGTH) {
            // The header is not initialized.
            uint8_t  i;

            dbg("CH|2", \
                "  - Initializing routing header of the message.\n");

            // Get TTL.
            for (i = 0; i < minLabelLength; ++i) {
                if (call CHState.getLabelElement(i) ==
                        call MessageLabel.getEl((nx_ch_label_t *)(&(hdr->dstLab[0])), i)) {
                    break;
                }
            }
            hdr->ttl =
                i < minLabelLength ?
                    call CHClustering.getMaxPropagationRadius(
                        i + 1,
                        call CHConfig.getMaxPathLength()) :
                    call CHClustering.getMaxPropagationRadius(
                        CH_MAX_LABEL_LENGTH,
                        call CHConfig.getMaxPathLength());
            hdr->level = dstLabelLength - 1;

            dbg("CH|2", \
                "  - Set TTL to %hhu (common level: %hhu).\n", \
                (uint8_t)hdr->ttl, \
                i < minLabelLength ? i : CH_MAX_LABEL_LENGTH);

        } else if (hdr->level >= dstLabelLength) {
            // The message was initialized,
            // but was wrong.
            dbgerror("CH|ERROR", \
                "The destination label length, %hhu, is smaller than the " \
                "resolved routing level, %hhu! [%s]\n", dstLabelLength, \
                (uint8_t)hdr->level, __FUNCTION__);
            return AM_BROADCAST_ADDR;
        }


        // Get the id of the destination node.
        dstNodeId =
            call MessageLabel.getEl((nx_ch_label_t *)(&(hdr->dstLab[0])), 0);


        if (dstNodeId == call CHState.getLabelElement(0)) {
            // Destination has been reached.
            dbg("CH|2", \
                "  - The message is destined for the present node.\n");
            hdr->ttl = 0;
            hdr->level = 0;
            return (am_addr_t)(call CHState.getLabelElement(0));


        } else if (hdr->ttl == 0) {
            // TTL has expired before reaching the destination.
            dbg("CH|2", \
                "  - The TTL counter of the message has expired. The " \
                "message should be dropped.\n");
            return AM_BROADCAST_ADDR;


        } else {
            // We have to forward the message.
            neighbor_t *      neighbor;
            ch_rt_entry_t *   rtEntry;
            uint8_t           i, j, resolvedLevel;

            // First, look up your neighbor table
            // for the destination node.
            neighbor =
                call NeighborTable.getNeighbor((am_addr_t)dstNodeId);

            if (neighbor != NULL) {
                // The neighbor has been found.
                if (call NeighborTable.getBiDirLinkQuality(neighbor) >=
                        call CHConfig.getGrayLQThreshold()) {
                    // And it has a decent link quality,
                    // so we can forward the message directly.
                    dbg("CH|2", \
                        "  - The destination node is our neighbor with " \
                        "a decent link quality. The message should be " \
                        "forwarded directly.\n");
                    hdr->ttl = hdr->ttl - 1;
                    hdr->level = 0;
                    return neighbor->llAddress;
                }
            }

            // The neighbor has not been found or
            // it has a poor link quality, we look up
            // the routing table.
            rtEntry = NULL;
            resolvedLevel = hdr->level;
            for (i = 1, j = hdr->level; i <= j; ++i) {
                uint16_t          head;

                head =
                    call MessageLabel.getEl(
                        (nx_ch_label_t *)(&(hdr->dstLab[0])), i);
                rtEntry =
                    call CHState.getRTEntryAtAnyHigherLevel(i, head);

                if (rtEntry != NULL) {
                    if (rtEntry->numHops != CH_ROUTING_NO_ROUTE_NUM_HOPS) {
                        // Some entry has been found.
                        if (head == call CHState.getLabelElement(0)) {
                            // We could not find the next hop.
                            dbg("CH|2", \
                                "  - A level-%hhu cluster head, %hu, " \
                                "has no route to any cluster heads " \
                                "at lower levels.\n", i, head);
                            rtEntry = NULL;
                        }
                        resolvedLevel = i;
                        break;
                    }
                }
            }

            if (rtEntry != NULL) {
                // resolvedLevel indicates the level at which
                // the entry has been resolved.
                dbg("CH|2", \
                    "  - Found a head node, %hu, at level %hhu. " \
                    "The message should be forwarded.\n", \
                    rtEntry->head, rtEntry->level);

                // Count the number of the next-hop candidates.
                for (i = 0, j = 0; i < CH_MAX_RT_ENTRY_NEXT_HOP_CANDIDATES; ++i) {
                    if (rtEntry->nextHops[i].addr != AM_BROADCAST_ADDR) {
                        ++j;
                    }
                }

                dbg("CH|2", \
                    "  - %hhu next-hop candidates found.\n", j);

                // Select one candidate.
                if (j == 0) {
                    dbgerror("CH|ERROR", \
                        "Internal error: For entry %hu at level %hhu, " \
                        "there is no next-hop candidate! [%s]\n", \
                        rtEntry->head, rtEntry->level, __FUNCTION__);
                    return AM_BROADCAST_ADDR;
                } else if (j > 1) {
                    j = (call Random.rand16() % j) + 1;
                }

                // Forward a message to that candidate.
                for (i = 0; i < CH_MAX_RT_ENTRY_NEXT_HOP_CANDIDATES; ++i) {
                    if (rtEntry->nextHops[i].addr != AM_BROADCAST_ADDR) {
                        --j;
                        if (j == 0) {
                            hdr->level = resolvedLevel;
                            hdr->ttl = hdr->ttl - 1;
                            dbg("CH|2", \
                                "  - The message should be forwarded to " \
                                "neighbor %hu.\n", rtEntry->nextHops[i].addr);
                            return rtEntry->nextHops[i].addr;
                        }
                    }
                }

                // NOTICE: This should never happen.
                dbgerror("CH|ERROR", \
                    "Internal error: Unreachable code reached! [%s]\n", \
                    __FUNCTION__);

                return AM_BROADCAST_ADDR;

            } else if (neighbor != NULL) {
                dbg("CH|2", \
                    "  - The routing entry was not found, but the " \
                    "destination node is our poor-quality neighbor. " \
                    "Trying to reach the neighbor directly.\n");

                hdr->ttl = hdr->ttl - 1;
                hdr->level = 0;
                return neighbor->llAddress;
            } else {
                dbg("CH|2", \
                    "  - No next hop has been found. The message " \
                    "should be dropped.\n");
                return AM_BROADCAST_ADDR;
            }
        }

        // This should not be reachable.
    }



    // ------------------- Interface NeighborTable -------------------------
    event inline void NeighborTable.neighborEvicted(am_addr_t llAddress) {
        // Do nothing.
    }
}
