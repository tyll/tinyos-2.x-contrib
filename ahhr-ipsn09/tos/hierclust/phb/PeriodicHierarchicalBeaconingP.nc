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
 * An implementation of a cluster hierarchy maintenance engine that
 * uses solely periodic hierarchical beaconing.
 *
 * More information on such protocols can be found in:
 * S. Kumar, C. Alaettinoglu, and D. Estrin, ``SCalable Object-tracking
 * through Unattended Techniques (SCOUT).'' In <i>ICNP'00: Proceedings of
 * the Eighth IEEE International Conference on Network Protocols</i>,
 * Osaka, Japan, November 14-17, 2000. pp. 253-262.
 *
 * @author Konrad Iwanicki &lt;iwanicki@few.vu.nl&gt;
 */
module PeriodicHierarchicalBeaconingP {
    provides {
        interface Init;
        interface ClusterHierarchyMaintenanceControl as Control;
        interface ClusterHierarchy;
        interface TOSSIMStats;
    }
    uses {
        interface ClusterHierarchyMaintenanceConfig as Config;
        interface NxVector<uint16_t> as SubMsgLabel;

        interface NeighborTable as NeighborTable;
        interface Iterator<neighbor_iter_t, neighbor_t>
            as NeighborTableIter;

        interface Timer<TMilli> as MainTimer;
        interface Timer<TMilli> as PromotionTimer;

        interface AMSend as BeaconSend;
        interface Packet as BeaconPacket;
        interface AMPacket as BeaconAMPacket;
        interface Receive as BeaconReceive;

        interface CHLocalState as CHState;
        interface Init as CHStateInit;
        interface CHClustering;
        interface CHRouting;
        interface CHStateDebug;

        interface PoolOfMessages as MsgPool;
        interface MessagePumpControl as MsgPumpControl;

        interface Random as Random;
    }
}
implementation {


    // --------------------------- Configuration --------------------------
    enum {
        /**
         * the additional number of rounds an entry may stay in
         * the routing table after expiring
         */
        MAX_TTL_TOLERANCE = 4,
        /**
         * If non-zero, indicates that there is an exponential
         * inter-beacon period, otherwise beacons are issued
         * every period, irrespective of the level of the issuer
         */
        EXPONENTIAL_BEACON_ISSUING_PERIOD = 1,
        /**
         * the number of milliseconds that will be added to the
         * forwarding backoff when supressing cluster head promotion
         */
        BACKOFF_INCREMENT_WHEN_PROMOTING = 1024,
        /**
         * the number of additional rounds a node waits when promoting
         * itself for a level-1 cluster head
         */
        ADDITIONAL_ROUNDS_FOR_FIRST_PROMOTION = 1,
        /**
         * the maximal numbers a beacon message is resent at all levels
         * except for the level 0
         */
        NUM_RESENDS_FOR_HIGHER_LEVEL_BEACONS = 1,
    };



    // ------------------------- Private members --------------------------
    /** indicates whether the component is active */
    bool                       isActive = FALSE;
    /** indicates whether we are shutting down the component */
    bool                       shuttingDown = FALSE;

    /**
     * indicates whether some advert has been forwarded
     * in the present round
     */
    bool                       advertForwarded;
    /**
     * indicates that we want to force sending an advert
     * even if it the number of rounds passed since the last
     * advert is smaller than the advert propagation radius
     */
    bool                       forceAdvert;
    /**
     * the number of rounds that have passed since the last
     * advert with a new sequence number was generated
     */
    uint8_t                    roundsSinceAdvert;
    /**
     * indicates whether the main timer has been scheduled to
     * issue an advert in the current round
     */
    bool                       advertScheduledInRound;
    /** the time the round was started */
    uint32_t                   roundStartTime;

    /** the sequence number for the cluster advertisements */
    ch_rt_entry_seq_no_t       advertSeqNo = 0;



    /**
     * Performs bookkeeping at the end of a round.
     */
    task void taskPerformBookkeeping();
    /**
     * Signals that the bookkeeping has been finished.
     */
    task void taskAfterBookkeeping();
    /**
     * Debugs a raw message.
     * @param msg the message to be printed
     */
    void dbgRawMessage(message_t * msg);
    /**
     * Debugs the local label.
     */
    void dbgLocalLabel();
    /**
     * Debugs the label from a beacon message.
     * @param msgLabel the message label
     */
    void dbgMessageLabel(nx_ch_label_t * msgLabel);
    /**
     * Debugs the local routing table.
     */
    void dbgLocalRoutingTable();
    /**
     * Prints a label change such that the hierarchy construction
     * process can be visualized.
     */
    void printLabelChange();
    /**
     * Resets the local state of the node.
     * @return <code>SUCCESS</code> if the state has been initialized
     *         correctly, otherwise and error code
     */
    error_t resetState();
    /**
     * Attempts to issue an advert.
     */
    void issueAdvert();
    /**
     * Schedules the main timer.
     * Based on the current state of the node, the timer can be scheduled
     * in order to transmit an advert, or to perform bookkeeping at
     * the end of a round.
     */
    void scheduleMainTimer();
    /**
     * Prepares and transmits an advert.
     * @param levelAsHead the level of a node as a head
     * @return <code>SUCCESS</code> if the advert was successfully
     *         enqueued for sending, <code>EBUSY</code> if the queue
     *         for sending adverts is full, or <code>FAIL</code> if
     *         some other error occurred; if <code>SUCCESS</code>
     *         is returned, the method guarantees to schedule the
     *         next main timer event
     */
    error_t createAndTransmitAdvert(
            uint8_t levelAsHead);
    /**
     * Processes a received advert.
     * The advert can be used to update the node's label
     * and routing table. It can be also forwarded further.
     * @param neighbor the neighbor from which the message was received
     * @param msg the message
     * @param payload the message payload
     * @param len the length of the message
     * @return the pointer to the buffer that should be returned to
     *         lower layers; it can be different than <code>msg</code>,
     *         for instance, if the message is further forwarded
     */
    message_t * processAndForwardReceivedAdvert(
            neighbor_t * neighbor, message_t * msg,
            void * payload, uint8_t len);
    /**
     * Accepts an advert locally.
     * @param neighbor the neighbor from which the message was received
     * @param advertPayload the payload of the advert
     * @param msgLabel the label of the advert creator
     * @param msgLabelLen the length of the label of the advert creator
     * @param level the head level of the issuer
     * @return <code>TRUE</code> if the advert should be forwarded
     *         <code>FALSE</code> indicating otherwise
     */
    bool acceptAdvert(
            neighbor_t * neighbor,
            nx_ch_phb_beacon_msg_t * advertPayload,
            nx_ch_label_t * msgLabel, uint8_t msgLabelLen,
            uint8_t level);
    /**
     * Adopts any possible label updates from a beacon.
     */
    void labAdoptUpdatesFromBeacon(
            nx_ch_label_t * msgLabel, uint8_t msgLabelLen, uint16_t head);
    /**
     * Adopts a fresher label part received from another node.
     * @param olab the label of the other node
     * @param olen the length of the label and the update vector of
     *        another node
     * @param di the position from which the copying should start
     */
    void labCopyFrom(
            nx_ch_label_t * olab, uint8_t olen, uint8_t di);
    /**
     * Performs the label cut operation.
     * @param len the new length to cut the label to
     */
    void labCut(uint8_t len);
    /**
     * Performs the label extension operation.
     * @param el the element to extend the label with
     */
    void labExtend(uint16_t el);
    /**
     * Lookups a neighbor with a given link-layer address.
     * The bidirectional link quality to that neighbor must exceed
     * the bidirectional link-quality threshold.
     * @param addr the link layer address of the neighbor
     * @param thr the threshold to discriminate link qualities
     * @return the pointer to the neighbor or <code>NULL</code> if
     *         it does not exist
     */
    neighbor_t * rtLookupNeighbor(am_addr_t addr, uint8_t thr);
    /**
     * Lookups an entry at any level of the cluster hierarchy.
     * @param head the head of the cluster to look for
     * @return the entry or <code>NULL</code> if it does not exist
     */
    ch_rt_entry_t * rtLookupEntryAtAnyLevel(uint16_t head);
    /**
     * Lookups an entry at any level greater than or equal to
     * a given level.
     * @param level the minimal level to check
     * @param head the head of the cluster to look for
     * @return the entry or <code>NULL</code> if it does not exist
     */
    ch_rt_entry_t * rtLookupEntryAtAnyHigherLevel(
            uint8_t level, uint16_t head);
    /**
     * Checks if first sequence number of a routing table entry is equal
     * to or older than the second sequence number.
     * @param f the first sequence number
     * @param s the second sequence number
     * @return <code>TRUE</code> if the first sequence number is equal to
     *         or older than the second one, otherwise <code>FALSE</code>
     */
    bool rtEntrySeqNoIsOlderOrEqual(uint8_t f, uint8_t s);
    /**
     * Refreshes an entry for a cluster.
     * @param pentry  a pointer to the exiting entry or <code>NULL</code>
     *                if the entry does not exist in the routing table
     * @param head    the identifier of the cluster head
     * @param level   the level at which the entry should be refreshed
     * @param numHops the number of hops from the cluster head
     * @param ttl     the number of rounds the entry main remain
     *                unrefreshed
     * @param seqNo   the sequence number of the cluster advertisement
     * @param nextHop the link-layer address of the next hop neighbor
     * @param create  <code>TRUE</code> if the entry should be created if
     *                it does not exist
     * @param lq      the bidirectional link quality to the next-hop
     *                neighbor
     * @return <code>TRUE</code> if the beacon was used for updating the
     *         routing table, otherwise <code>FALSE</code>
     */
    bool rtRefreshEntry(
            ch_rt_entry_t * pentry, uint16_t head, uint8_t level,
            uint8_t numHops, uint8_t ttl, ch_rt_entry_seq_no_t seqNo,
            am_addr_t nextHop, bool create, uint8_t lq);
    /**
     * Returns a join candidate for the node.
     * @param headLevel the level on which the node is a head
     * @return a join candidate or <code>NULL</code> if such a candidate
     *         does not exist
     */
    ch_rt_entry_t * rtGetJoinCandidate(uint8_t headLevel);
    /**
     * Ages and cleans the routing table.
     */
    void rtAgeAndClean();
    /**
     * Detects and repairs any errors in the hierarchy that
     * might have occurred due to node failures or connectivity
     * changes. In essence, this method can cut the label of
     * a node.
     */
    void repairHierarchyErrors();
    /**
     * Detects if the hierarchy has converged and if not,
     * initiates repair actions that ensure convergence.
     */
    void repairHierarchyIncompleteness();
    /**
     * Checks if the hierarchy construction is not complete
     * and if the current node can try to repair this by
     * promoting itself as a higher level cluster head.
     * @param headLevel the level of the node as a head
     * @return <code>TRUE</code> if the hierarchy construction is
     *         not complete, otherwise <code>FALSE</code>
     */
    bool checkForPossiblePromotion(uint8_t headLevel);



    // -------------------------- Interface Init --------------------------
    command inline error_t Init.init() {
        error_t res;

        dbg("CH|1", \
            "Initializing the periodic hierarchical beaconing engine " \
            "for cluster hierarchy maintenance. [%s]\n", __FUNCTION__);

        res = resetState();

        return res;
    }



    // ------------------------ Interface Control -------------------------
    command error_t Control.start() {
        dbg("CH|1", \
            "Starting the periodic hierarchical beaconing engine for " \
            "cluster hierarchy maintenance. [%s]\n", __FUNCTION__);

        isActive = TRUE;

        call MainTimer.startOneShot(
            call Random.rand32() % call Config.getDutyCylePeriod());

        dbg("CH|1", \
            "The periodic hierarchical beaconing engine for cluster hierarchy " \
            "maintenance has been started successfully. [%s]\n", \
            __FUNCTION__);

        return SUCCESS;
    }



    command error_t Control.stop() {
        error_t res;

        dbg("CH|1", \
            "Stopping the periodic hierarchical beaconing engine for " \
            "cluster hierarchy maintenance. [%s]\n", __FUNCTION__);

        shuttingDown = TRUE;

        call MainTimer.stop();
        call PromotionTimer.stop();

        call MsgPumpControl.emptyQueue();

        // NOTICE: The messages from the send queue will be
        //         freed and returned back to the message pool.

        isActive = FALSE;
        shuttingDown = FALSE;

        res = resetState();

        dbg("CH|1", \
            "The periodic hierarchical beaconing engine for cluster hierarchy " \
            "maintenance has been stopped %s. [%s]\n", \
            res == SUCCESS ? "successfully" : "UNSUCCESSFULLY", \
            __FUNCTION__);

        return res;
    }



    default event inline void Control.bookkeepingStarted() {
        // Do nothing.
    }



    default event inline void Control.bookkeepingFinished() {
        // Do nothing.
    }



    // ------------------- Interface ClusterHierarchy ---------------------
    command inline uint8_t ClusterHierarchy.getLabelLength() {
        return call CHState.getLabelLength();
    }



    command inline uint16_t ClusterHierarchy.getLabelElement(uint8_t i) {
        if (i >= call CHState.getLabelLength()) {
            return CH_INVALID_CLUSTER_HEAD;
        } else {
            return call CHState.getLabelElement(i);
        }
    }



    default event inline void ClusterHierarchy.labelChanged(uint8_t level) {
        // Do nothing.
    }



    command inline uint8_t ClusterHierarchy.getLevelAsHead() {
        return call CHState.getLevelAsHead();
    }



    command inline uint8_t ClusterHierarchy.getRoutingHeaderSize() {
        return call CHRouting.getRoutingHeaderSize();
    }



    command inline void ClusterHierarchy.clearRoutingHeader(
            nx_ch_routing_message_header_t * hdr) {
        return call CHRouting.clearRoutingHeader(hdr);
    }



    command inline error_t ClusterHierarchy.setRoutingHeaderDstLabelLength(
            nx_ch_routing_message_header_t * hdr, uint8_t len) {
        return call CHRouting.setRoutingHeaderDstLabelLength(hdr, len);
    }



    command inline uint8_t ClusterHierarchy.getRoutingHeaderDstLabelLength(
            nx_ch_routing_message_header_t const * hdr) {
        return call CHRouting.getRoutingHeaderDstLabelLength(hdr);
    }



    command inline error_t ClusterHierarchy.setRoutingHeaderDstLabelElement(
            nx_ch_routing_message_header_t * hdr, uint8_t i, uint16_t val) {
        return call CHRouting.setRoutingHeaderDstLabelElement(hdr, i, val);
    }



    command inline uint16_t ClusterHierarchy.getRoutingHeaderDstLabelElement(
            nx_ch_routing_message_header_t const * hdr, uint8_t i) {
        return call CHRouting.getRoutingHeaderDstLabelElement(hdr, i);
    }



    command inline am_addr_t ClusterHierarchy.getNextRoutingHop(
            nx_ch_routing_message_header_t * hdr) {
        return call CHRouting.getNextRoutingHop(hdr);
    }



    command inline ch_rt_entry_t const * ClusterHierarchy.getFirstRTEntryAtLevel(
            uint8_t level) {
        if (level == 0 || level >= CH_MAX_LABEL_LENGTH) {
            return NULL;
        }
        return call CHState.getFirstRTEntryAtLevel(level);
    }



    command inline ch_rt_entry_t const * ClusterHierarchy.getNextRTEntryAtLevel(
            ch_rt_entry_t const * pentry) {
        if (pentry == NULL) {
            return NULL;
        }
        return call CHState.getNextRTEntryAtLevel(pentry);
    }



    // ---------------------- Interface MainTimer -------------------------
    event inline void MainTimer.fired() {
        dbg("CH|1", \
            "The main timer of the cluster hierarchy maintenance engine " \
            "has fired. [%s]\n", __FUNCTION__);

        // Check if the purpose of the timer is to send
        // an advert, or to do bookkeeping.
        if (advertScheduledInRound) {
            post taskPerformBookkeeping();
            signal Control.bookkeepingStarted();

        } else {
            issueAdvert();
            scheduleMainTimer();
        }


        dbg("CH|1", \
            "Leaving the handler of the main timer for the cluster " \
            "hierarchy maintenance engine. [%s]\n", __FUNCTION__);
    }



    // --------------------- Interface BeaconSend -------------------------
    event inline void BeaconSend.sendDone(message_t * msg, error_t err) {
        // Free the message buffer.
        call MsgPool.freeMessage(msg);
    }



    // -------------------- Interface BeaconReceive -----------------------
    event message_t * BeaconReceive.receive(
            message_t * msg, void * payload, uint8_t len) {
        neighbor_t *  neighbor;

        dbg("CH|1", \
            "Received a %hhu-byte advert message %x. [%s]\n", \
            len, msg, __FUNCTION__);

        dbgRawMessage(msg);

        if (shuttingDown || !isActive) {
            dbg("CH|1", \
                "Dropping message %x due to being inactive " \
                "or in the process of shutting down. [%s]\n", \
                msg, __FUNCTION__);
            return msg;
        }

        dbg("CH|2", \
            "  - Looking up a neighbor with link-layer address %hu " \
            "and the link quality above %hhu.\n", \
            call BeaconAMPacket.source(msg), \
            call Config.getGrayLQThreshold());

        // Find a node that sent sent us a message
        neighbor =
            rtLookupNeighbor(
                call BeaconAMPacket.source(msg),
                call Config.getGrayLQThreshold());

        if (neighbor != NULL) {
            // The neighbor exists and has a fair link.
            dbg("CH|2", \
                "  - The neighbor has been found. " \
                "Starting processing the message.\n");

            msg = processAndForwardReceivedAdvert(neighbor, msg, payload, len);

        } else {

            dbg("CH|2", \
                "  - A neighbor with link-layer address %hu does not " \
                "exist in the node's neighbor table or its link quality " \
                "is below the threshold %hhu.\n", \
                call BeaconAMPacket.source(msg), \
                call Config.getGrayLQThreshold());
        }

        dbg("CH|1", \
            "Finished processing the received message. Returning " \
            "message buffer %x to the lower layers. [%s]\n", \
            msg, __FUNCTION__);

        return msg;
    }



    // ------------------- Interface PromotionTimer ---------------------
    event inline void PromotionTimer.fired() {
        uint8_t           headLevel;

        // Get the level of a node as the head.
        headLevel = call CHState.getLevelAsHead();

        dbg("CH|1", \
            "The promotion timer of the cluster hierarchy maintenance " \
            "engine has fired (level as head: %hhu). [%s]\n", \
            headLevel, __FUNCTION__);

        dbgLocalLabel();

        // Check if the promotion is still required.
        if (checkForPossiblePromotion(headLevel)) {
            ch_rt_entry_t * pJoinCandidate;

            dbg("CH|2", \
                "  - A label extension is required.\n");

            // Check if we can join some already existing
            // higher level cluster.
            pJoinCandidate =
                rtGetJoinCandidate(headLevel);

            if (pJoinCandidate != NULL) {
                dbg("CH|2", \
                    "  - A join candidate %hu within %hhu hops found. " \
                    "Performing label extension.\n", \
                    pJoinCandidate->head, pJoinCandidate->numHops);

                labExtend(pJoinCandidate->head);

            } else if (call CHClustering.canBecomeClusterHead(headLevel + 1)) {
                dbg("CH|2", \
                    "  - A join candidate not found. Promoting myself.\n");

                labExtend(call CHState.getLabelElement(0));

                ++headLevel;
                ++advertSeqNo;

                if (createAndTransmitAdvert(headLevel) == SUCCESS) {
                    forceAdvert = FALSE;
                    roundsSinceAdvert = 0;
                    // OPTIMIZE: Uncomment the line below.
                    advertForwarded = TRUE;
                }

            } else {
                dbg("CH|2", \
                    "  - A join candidate not found. Not allowed to " \
                    "promote myself. Still waiting...\n");
            }
        }

        dbg("CH|1", \
            "The promotion timer handler of the cluster hierarchy " \
            "maintenance engine has finished (level as head: %hhu). [%s]\n", \
            headLevel, __FUNCTION__);

        dbgLocalLabel();

    }



    // ------------------- Interface NeighborTable -------------------------
    event void NeighborTable.neighborEvicted(am_addr_t llAddress) {
        uint8_t  level;

        dbg("CH|1", \
            "Lower layers have signaled the cluster hierarchy maintenance " \
            "engine that neighbor %hu is no longer alive. [%s]\n", \
            llAddress, __FUNCTION__);

        for (level = 1; level < CH_MAX_LABEL_LENGTH; ++level) {
            ch_rt_entry_t *  pprev = NULL;
            ch_rt_entry_t *  pcurr =
                call CHState.getFirstRTEntryAtLevel(level);
            while (pcurr != NULL) {
                uint8_t   n = 0;
                uint8_t   i;

                for (i = 0; i < CH_MAX_RT_ENTRY_NEXT_HOP_CANDIDATES; ++i) {
                    if (pcurr->nextHops[i].addr == llAddress) {
                        pcurr->nextHops[i].addr = AM_BROADCAST_ADDR;
                    } else if (pcurr->nextHops[i].addr != AM_BROADCAST_ADDR) {
                        ++n;
                    }
                }

                if (n == 0) {
                    // We have to remove a routing entry
                    // as it does not contain any hops.
                    dbg("CH|2", \
                        "  - Removing a routing entry for %hu at " \
                        "level %hhu.\n", pcurr->head, pcurr->level);

                    call CHState.removeRTEntryByPointers(pcurr, pprev);
                    pcurr = pprev == NULL ?
                        call CHState.getFirstRTEntryAtLevel(level) :
                        call CHState.getNextRTEntryAtLevel(pprev);
                } else {
                    // The entry is fine.
                    pprev = pcurr;
                    pcurr = call CHState.getNextRTEntryAtLevel(pcurr);

               }
            }
        }

        dbg("CH|1", \
            "Cleanup after eviction of neighbor %hu has finished. [%s]\n", \
            llAddress, __FUNCTION__);
    }



    // ---------------------- Interface TOSSIMStats -----------------------
    command void TOSSIMStats.report() {
#ifdef TOSSIM
// #ifdef __SIM_KI__H__
//         unsigned short
//             labelElemsToReport[SIM_KI_AREAHIER_MAX_LABEL_LENGTH];
//         sim_ki_areahier_rt_entry_next_hop_t
//             nextHopsToReport[SIM_KI_AREAHIER_MAX_NEXT_HOP_CANDIDATES];
//         neighbor_iter_t  iter;
//         uint8_t          i, n;
// 
//         // Start reporting.
//         sim_ki_areahier_start_reporting_node_data(TOS_NODE_ID);
// 
//         // Report the label.
//         n = call CHState.getLabelLength() < SIM_KI_AREAHIER_MAX_LABEL_LENGTH ?
//             call CHState.getLabelLength() : SIM_KI_AREAHIER_MAX_LABEL_LENGTH;
//         for (i = 0; i < n; ++i) {
//             labelElemsToReport[i] = call CHState.getLabelElement(i);
//         }
//         sim_ki_areahier_report_label(TOS_NODE_ID, n, labelElemsToReport);
// 
//         // Report the level zero row of the routing table.
//         call NeighborTableIter.init(&iter);
//         while (call NeighborTableIter.hasNext(&iter)) {
//             neighbor_t * neighbor =
//                 call NeighborTableIter.next(&iter);
//             if (call NeighborTable.getBiDirLinkQuality(neighbor) >=
//                     call Config.getGrayLQThreshold()) {
//                 nextHopsToReport[0].addr = neighbor->llAddress;
//                 nextHopsToReport[0].numHops = 1;
//                 sim_ki_areahier_report_rt_entry(
//                     TOS_NODE_ID, 0, neighbor->llAddress,
//                     1, 1, 1, nextHopsToReport);
//             }
//         }
// 
//         // Report the higher level rows of the routing table.
//         for (i = 1; i < CH_MAX_LABEL_LENGTH; ++i) {
//             ch_rt_entry_t const * pentry =
//                 call CHState.getFirstRTEntryAtLevel(i);
//             while (pentry != NULL) {
//                 uint8_t j;
// 
//                 n = 0;
//                 for (j = 0; j < CH_MAX_RT_ENTRY_NEXT_HOP_CANDIDATES &&
//                             n < SIM_KI_AREAHIER_MAX_NEXT_HOP_CANDIDATES; ++j) {
//                     if (pentry->nextHops[j].addr != AM_BROADCAST_ADDR) {
//                         nextHopsToReport[n].addr =
//                             pentry->nextHops[j].addr;
//                         nextHopsToReport[n].numHops =
//                             pentry->nextHops[j].maintenance.phb.numHops;
//                         ++n;
//                     }
//                 }
//                 sim_ki_areahier_report_rt_entry(
//                     TOS_NODE_ID,
//                     pentry->level,
//                     pentry->head,
//                     pentry->numHops,
//                     0,
//                     n,
//                     nextHopsToReport);
//                 pentry = call CHState.getNextRTEntryAtLevel(pentry);
//             }
//         }
// 
//         // Finish reporting node data.
//         sim_ki_areahier_finish_reporting_node_data(TOS_NODE_ID);
// #endif
#endif
    }



    // ------------------------------ Tasks -------------------------------
    task void taskPerformBookkeeping() {
        dbg("CH|1", \
            "Starting bookkeeping. [%s]\n", __FUNCTION__);

        rtAgeAndClean();

        repairHierarchyErrors();

        repairHierarchyIncompleteness();

        post taskAfterBookkeeping();

        dbg("CH|1", \
            "Bookkeeping has finished. [%s]\n", __FUNCTION__);

        roundStartTime = call MainTimer.getNow();
        scheduleMainTimer();
    }



    task void taskAfterBookkeeping() {
        signal Control.bookkeepingFinished();
    }



    // ----------------- Private function implementations -----------------
    inline void dbgRawMessage(message_t * msg) {
#ifdef TOSSIM
#ifndef TOSSIM_NO_DEBUG
        uint8_t * d;
        uint8_t   len;
        uint8_t   i;



        d = (uint8_t *)msg->data;
        len = ((tossim_header_t *)(d - sizeof(tossim_header_t)))->length;
        dbg("CH|Raw", "Raw message:");
        for (i = 0; i < len; ++i) {
            dbg_clear("CH|Raw", " %02hhx", d[i]);
        }
        dbg_clear("CH|Raw", ".\n");
#endif
#endif
    }



    inline void dbgLocalLabel() {
#ifdef TOSSIM
#ifndef TOSSIM_NO_DEBUG
        dbg("CH|Raw", "Local label: ");
        call CHStateDebug.tossimDbgLabel("CH|Raw");
        dbg_clear("CH|Raw", "\n");
#endif
#endif
    }



    inline void dbgMessageLabel(nx_ch_label_t * msgLabel) {
#ifdef TOSSIM
#ifndef TOSSIM_NO_DEBUG
        uint8_t i, len;

        dbg("CH|Raw", "Message label:");
        len = call SubMsgLabel.getLen(msgLabel);
        for (i = 0; i < len; ++i) {
            dbg_clear("CH|Raw", " %hu", call SubMsgLabel.getEl(msgLabel, i));
        }
        dbg_clear("CH|Raw", "\n");
#endif
#endif
    }



    inline void dbgLocalRoutingTable() {
#ifdef TOSSIM
#ifndef TOSSIM_NO_DEBUG
        dbg("CH|Raw", "Routing table: ");
        call CHStateDebug.tossimDbgRoutingTable("CH|Raw");
        dbg_clear("CH|Raw", "\n");
#endif
#endif
    }



    inline void printLabelChange() {
#ifdef TOSSIM
        printf("INFO (%hu): STATS|AreaHierarchy @%lld [label]: ",
            TOS_NODE_ID, sim_time());
        call CHStateDebug.tossimPrintLabel();
        printf("\n");
#endif
    }



    inline error_t resetState() {
        error_t res;

        // Renitialize the local state common for all
        // the hierarchy maintenance algorithms.
        res = call CHStateInit.init();
        if (res != SUCCESS) {
            return res;
        }

        // Initialize the advert information.
        advertForwarded = FALSE;
        forceAdvert = FALSE;
        roundsSinceAdvert = 0;
        advertScheduledInRound = TRUE;

        // Print the new label, so that hierarchy
        // maintenance can be visualized.
        printLabelChange();

        return SUCCESS;
    }



    void scheduleMainTimer() {
        uint32_t eventTime;
        uint32_t dt;

        if (advertScheduledInRound) {
            eventTime =
                roundStartTime +
                call Random.rand32() %
                    (call Config.getMaxAdvertIssuingBackoff());

            advertScheduledInRound = FALSE;

        } else {
            eventTime =
                roundStartTime +
                (call Config.getDutyCylePeriod());

            advertScheduledInRound = TRUE;
        }

        dt = eventTime - call MainTimer.getNow();

        // NOTICE: This condition here is extremely important.
        if (dt > eventTime) {
            dt = 0;
        }

        dbg("CH|1", \
            "Scheduling the event of the main timer for the cluster " \
            "hierarchy maintenance engine in %u milliseconds. [%s]\n", \
            dt, __FUNCTION__);

        call MainTimer.startOneShot(dt);
    }



    inline void issueAdvert() {
        uint8_t   advertRadius;
        uint8_t   levelAsHead;

        ++roundsSinceAdvert;

        levelAsHead = call CHState.getLevelAsHead();

        advertRadius =
            call CHClustering.getMaxPropagationRadius(
                levelAsHead,
                call Config.getMaxPathLength());

        dbg("CH|2", \
            "  - Last real advert was sent %hhu rounds ago and the " \
            "inter-advert interval is %hhu (level as head: %hhu; " \
            "force flag: %hhu; forward flag: %hhu).\n", \
            roundsSinceAdvert, advertRadius, levelAsHead, \
            forceAdvert ? 0x01 : 0x00, advertForwarded ? 0x01 : 0x00);

        if (forceAdvert ||
                !EXPONENTIAL_BEACON_ISSUING_PERIOD ||
                    roundsSinceAdvert >= advertRadius) {
            dbg("CH|2", \
                "  - Increasing the advert sequence number to %hhu, " \
                "since the advert round counter has expired.\n", \
                advertSeqNo + 1);

            ++advertSeqNo;
            forceAdvert = FALSE;
            roundsSinceAdvert = 0;
        } else {
            dbg("CH|2", \
                "  - The advert sequence number remains unchanged " \
                "with value %hhu.\n", advertSeqNo);
        }


        if (advertForwarded && levelAsHead == 0) {
            dbg("CH|2", \
                "  - Some advert has been forwarded in this round. " \
                "Skipping generation of an advert.\n");

        } else {
            dbg("CH|2", \
                "  - Generating and sending an advert message.\n");

            createAndTransmitAdvert(levelAsHead);
        }

        advertForwarded = FALSE;
    }



    error_t createAndTransmitAdvert(
            uint8_t levelAsHead) {
        message_t *                msg;
        nx_ch_phb_beacon_msg_t *   beaconMsg;
        uint8_t                    len;
        uint8_t                    i;

        dbg("CH|3", \
            "    * Preparing a beacon message at level %hhu.\n", levelAsHead);

        // Check if the message is big enough
        len =
            sizeof(nx_ch_phb_beacon_msg_t) +
                call SubMsgLabel.getByteLen(
                    call CHState.getLabelLength());

        if (len > call BeaconPacket.maxPayloadLength()) {
            dbgerror("CH|ERROR", \
                "Message payload (%hhu) is too small to hold a  " \
                "%hhu-byte beacon message! [%s]\n", \
                call BeaconPacket.maxPayloadLength(), len, __FUNCTION__);
            return FAIL;
        }

        // Allocate a message buffer.
        msg = call MsgPool.allocMessage();
        if (msg == NULL) {
            dbgerror("CH|ERROR", \
                "Message pool is full! Unable to allocate a " \
                "beacon message! [%s]\n", __FUNCTION__);
            return EBUSY;
        }

        dbg("CH|3", \
            "    * Allocated a message buffer (necessary payload " \
            "%hhu bytes). Filling in the message.\n", len);

        // Fill in the message.
        beaconMsg = (nx_ch_phb_beacon_msg_t *)(
            call BeaconPacket.getPayload(msg, NULL));

        beaconMsg->numHops = 0;
        beaconMsg->advertSeqNo = advertSeqNo;
        // NOTICE: ****************************************************
        //         Uncomment below if we want to get information
        //         on how fast messages disseminate.
//         beaconMsg->simCreationTime = sim_time();
//         beaconMsg->simReceiveTime = sim_time();
//         beaconMsg->simIssuer = TOS_NODE_ID;
//         if (levelAsHead > 0) {
//             sim_time_t t =
//                 ((sim_time_t)beaconMsg->simReceiveTime -
//                     (sim_time_t)beaconMsg->simCreationTime) /
//                     (sim_ticks_per_sec() / 1000LL);
//             printf("MSG_ID: %hu:%lld LEVEL: %hhu TTL: %hhu HOPS: %hhu TIME: %lld\n",
//                 beaconMsg->simIssuer, (sim_time_t)beaconMsg->simCreationTime,
//                 levelAsHead, beaconMsg->ttl, beaconMsg->numHops, t);
//         }
        // ************************************************************

        dbg("CH|3", \
            "    * Advert sequence number: %u. Serializing the " \
            "label.\n", (uint32_t)beaconMsg->advertSeqNo);

        {
            nx_ch_label_t * msgLabel =
                (nx_ch_label_t *)(&(beaconMsg->labelBytes[0]));
            call SubMsgLabel.setLen(
                msgLabel, call CHState.getLabelLength());
            for (i = 0; i < call CHState.getLabelLength(); ++i) {
                call SubMsgLabel.setEl(
                    msgLabel, i, call CHState.getLabelElement(i));
            }
        }

        dbg("CH|3", \
            "    * A %hhu-byte message ready for sending. " \
            "Enqueueing the message for sending.\n", len);

        dbgRawMessage(msg);


        // Enqueue the message for sending.
        {
            uint32_t  backoff;
            uint8_t   resendCnt;
            error_t   error;

            backoff = call MsgPumpControl.getMaxMessageBackoffPeriod();
            call MsgPumpControl.setMaxMessageBackoffPeriod(0);
            resendCnt = call MsgPumpControl.getMaxResendCount();
            call MsgPumpControl.setMaxResendCount(
                levelAsHead == 0 ? 1 : NUM_RESENDS_FOR_HIGHER_LEVEL_BEACONS);

            error = call BeaconSend.send(AM_BROADCAST_ADDR, msg, len);

            call MsgPumpControl.setMaxMessageBackoffPeriod(backoff);
            call MsgPumpControl.setMaxResendCount(resendCnt);

            if (error != SUCCESS) {
                dbgerror("CH|ERROR", \
                    "Message queue is full! Unable to enqueue a " \
                    "message for sending! [%s]\n", __FUNCTION__);

                // Free the allocated message buffer.
                call MsgPool.freeMessage(msg);

            } else {
                dbg("CH|2", \
                    "  - The advert message enqueued for sending. [%s]\n", \
                    __FUNCTION__);
            }

            return error;
        }
    }



    message_t * processAndForwardReceivedAdvert(
            neighbor_t * neighbor, message_t * msg,
            void * payload, uint8_t len) {
        nx_ch_phb_beacon_msg_t *  beaconPayload;
        nx_ch_label_t *           msgLabel;
        uint8_t                   msgLabelLen;
        uint8_t                   issuerHeadLevel;
        message_t *               res;
        uint32_t                  backoff;
        uint8_t                   resendCnt;

        // Extract message fields.
        if (len < sizeof(nx_ch_phb_beacon_msg_t) +
                call SubMsgLabel.getByteLen(1)) {
            dbgerror("CH|ERROR", \
                "Message length %hhu is too small to hold at least " \
                "%hhu-byte payload! [%s]\n", len, \
                sizeof(nx_ch_phb_beacon_msg_t) + \
                call SubMsgLabel.getByteLen(1), __FUNCTION__);
            return msg;
        }

        beaconPayload = (nx_ch_phb_beacon_msg_t *)payload;
        msgLabel = (nx_ch_label_t *)(&(beaconPayload->labelBytes[0]));
        msgLabelLen = call SubMsgLabel.getLen(msgLabel);

        // Check if the label length is correct.
        if (msgLabelLen > CH_MAX_LABEL_LENGTH || msgLabelLen == 0) {
            dbgerror("CH|ERROR", \
                "Invalid length %hhu of the label! [%s]\n", \
                msgLabelLen, __FUNCTION__);
            return msg;
        }

        // Check if there is enough information to store the label.
        if (len != sizeof(nx_ch_phb_beacon_msg_t) +
                call SubMsgLabel.getByteLen(msgLabelLen)) {
            dbgerror("CH|ERROR", \
                "Message length %hhu is invalid. It should be " \
                "%hhu bytes (including %hhu-element label)! [%s]\n", \
                len, sizeof(nx_ch_phb_beacon_msg_t) + \
                call SubMsgLabel.getByteLen(msgLabelLen), \
                msgLabelLen, __FUNCTION__);
            return msg;
        }

        // Increment the hop count.
        beaconPayload->numHops = beaconPayload->numHops + 1;
        if (beaconPayload->numHops == 0) {
            dbgerror("CH|ERROR", \
                "The hop count has overflown! [%s]\n", __FUNCTION__);
            return msg;
        }

        // Get the head level of the issuer.
        {
            uint16_t issuer;

            issuer = call SubMsgLabel.getEl(msgLabel, 0);

            for (issuerHeadLevel = 1;
                    issuerHeadLevel < msgLabelLen;
                    ++issuerHeadLevel) {
                if (call SubMsgLabel.getEl(msgLabel, issuerHeadLevel) != issuer) {
                    break;
                }
            }
            --issuerHeadLevel;
        }

        // Accept the advert locally.
        if (!acceptAdvert(
                neighbor, beaconPayload, msgLabel, msgLabelLen, issuerHeadLevel)) {
            // The advert is incorrect, so it should NOT be forwarded.
            dbg("CH|2", \
                "  - After checking, the message will not be forwarded.\n");

            return msg;
        }

        // Forward the advert.
        dbg("CH|2", \
            "  - Preparing the advert for forwarding.\n");

        // (1) Allocate a replacement message buffer.
        res = call MsgPool.allocMessage();
        if (res == NULL) {
            dbgerror("CH|ERROR", \
                "Message pool is full! Unable to allocate a " \
                "message! [%s]\n", __FUNCTION__);
            return msg;
        }

        // (2) Set the maximal backoff period and resend counter.
        backoff = call MsgPumpControl.getMaxMessageBackoffPeriod();
        call MsgPumpControl.setMaxMessageBackoffPeriod(
            call Config.getMaxAdvertForwardingBackoff());
        resendCnt = call MsgPumpControl.getMaxResendCount();
        call MsgPumpControl.setMaxResendCount(
            issuerHeadLevel == 0 ? 1 : NUM_RESENDS_FOR_HIGHER_LEVEL_BEACONS);

        // (3) Enqueue the advert message for transmission.
        if (call BeaconSend.send(
                AM_BROADCAST_ADDR, msg, len) != SUCCESS) {

            dbgerror("CH|ERROR", \
                "Unable to enqueue a message for sending [%s]!\n", \
                __FUNCTION__);

            // Free the allocated message buffer.
            call MsgPool.freeMessage(res);

            // Restore the old backoff and resend counter.
            call MsgPumpControl.setMaxMessageBackoffPeriod(backoff);
            call MsgPumpControl.setMaxResendCount(resendCnt);

            return msg;

        } else {
            dbg("CH|2", \
                "Successfully enqueued %hhu-byte message %x " \
                "for sending [%s].\n", len, msg, __FUNCTION__);

            // Restore the old backoff and resend counter.
            call MsgPumpControl.setMaxMessageBackoffPeriod(backoff);
            call MsgPumpControl.setMaxResendCount(resendCnt);

            // OPTIMIZE: Uncomment the line below.
            advertForwarded = TRUE;
        }

        // Return the replacement message buffer.
        return res;
    }



    bool acceptAdvert(
            neighbor_t * neighbor,
            nx_ch_phb_beacon_msg_t * advertPayload,
            nx_ch_label_t * msgLabel, uint8_t msgLabelLen,
            uint8_t level) {
        uint16_t               head;
        uint8_t                numHops;
        uint8_t                radius;
        ch_rt_entry_seq_no_t   seqNo;
        bool                   res;
        ch_rt_entry_t *        rtEntry;

        // Get the issuer of the beacon.
        head = call SubMsgLabel.getEl(msgLabel, 0);

        if (head == call CHState.getLabelElement(0)) {
            // We created the beacon, so we cannot accept it back.
            dbg("CH|2", \
                "  - The beacon was created by the present node. " \
                "Dropping it.\n");
            return FALSE;
        }

        // Get the remaining data from the beacon payload.
        numHops = advertPayload->numHops;
        radius =
            call CHClustering.getMaxPropagationRadius(
                level, call Config.getMaxPathLength());
        seqNo = advertPayload->advertSeqNo;

        rtEntry = NULL;

        // Check if we have seen the beacon so far.
        if (level == 0) {
            dbg("CH|2", \
                "  - The beacon has not been seen as it is at " \
                "level 0. It should NOT be forwarded, however.\n");

            // NOTICE: Since we do not do anything with level-zero
            //         beacons other than updating neighbor tables,
            //         we can safely exit the method here.
            return FALSE;

        } else {
            rtEntry = rtLookupEntryAtAnyLevel(head);

            if (rtEntry == NULL) {
                dbg("CH|2", \
                    "  - The beacon has not been seen as it is " \
                    "not present in the routing table.\n");

                res = TRUE;

            } else if (rtEntrySeqNoIsOlderOrEqual(
                    seqNo, rtEntry->maintenance.phb.seqNo)) {
                dbg("CH|2", \
                    "  - The beacon has been seen already as its " \
                    "sequence number %u is equal to or older than the " \
                    "last recorded sequence number %u. \n",
                    (uint32_t)seqNo, \
                    (uint32_t)rtEntry->maintenance.phb.seqNo);

                if (seqNo != rtEntry->maintenance.phb.seqNo ||
                        numHops > rtEntry->numHops) {
                    // The received entry is either older, or has a higher
                    // hop count than we do, so drop it without processing.
                    dbg("CH|2", \
                        "  - Dropping the beacon without processing.\n");
                    return FALSE;

                } else {
                    // The entry is of the same age and it has a
                    // comparable hop count, so we can use it as an
                    // alternative. It won't be forwarded however.
                    dbg("CH|2", \
                        "  - Dropping the beacon but WITH processing.\n");
                    res = FALSE;
                }

            } else {
                dbg("CH|2", \
                    "  - The beacon has not been seen as its " \
                    "sequence number %u is younger than the last " \
                    "sequence number %u.\n", (uint32_t)seqNo, \
                    (uint32_t)rtEntry->maintenance.phb.seqNo);

                res = TRUE;
            }

        }


        dbg("CH|2", \
            "  - Accepting a level %hhu beacon from %hu with " \
            "number of hops %hhu and radius %hhu and seqNo %u " \
            "forwarded by %hu.\n", level, head, numHops, radius, \
            (uint32_t)seqNo, neighbor->llAddress);


        // NOTICE: ****************************************************
        //         Uncomment below if we want to get information
        //         on how fast messages disseminate.
//         advertPayload->simReceiveTime = sim_time();
//         if (level > 0) {
//             sim_time_t t =
//                 ((sim_time_t)advertPayload->simReceiveTime -
//                     (sim_time_t)advertPayload->simCreationTime) /
//                     (sim_ticks_per_sec() / 1000LL);
//             printf("MSG_ID: %hu:%lld LEVEL: %hhu TTL: %hhu HOPS: %hhu TIME: %lld\n",
//                 advertPayload->simIssuer, (sim_time_t)advertPayload->simCreationTime,
//                 level, advertPayload->ttl, advertPayload->numHops, t);
//         }
        // ************************************************************

        // Adopt any possible label updates.
        if (res) {
            // Do this only if we have not seen the update.
            labAdoptUpdatesFromBeacon(msgLabel, msgLabelLen, head);
        }

        // Record the cluster advertisement stored in the beacon.
        {
            uint8_t lq;

            lq = call NeighborTable.getBiDirLinkQuality(neighbor);

            res = res &&
                rtRefreshEntry(
                    rtEntry,
                    head,
                    level,
                    numHops,
                    EXPONENTIAL_BEACON_ISSUING_PERIOD ?
                        radius + MAX_TTL_TOLERANCE : MAX_TTL_TOLERANCE,
                    seqNo,
                    neighbor->llAddress,
                    lq >= call Config.getWhiteLQThreshold(),
                    lq);
        }

        return res && numHops < radius;
    }



    inline void labAdoptUpdatesFromBeacon(
            nx_ch_label_t * msgLabel, uint8_t msgLabelLen, uint16_t head) {
        uint8_t     ci;

        dbgLocalLabel();
        dbgMessageLabel(msgLabel);

        // Find the position of the group head in my label.
        for (ci = 0; ci < call CHState.getLabelLength(); ++ci) {
            if (call CHState.getLabelElement(ci) == head) {
                break;
            }
        }

        dbg("CH|3", \
            "    * Minimal position of the head node: %hhu.\n", ci);

#ifdef TOSSIM
         // Sanity check.
         if (ci == 0) {
             dbgerror("CH|ERROR", "The nodes have similar " \
                 "identifiers %hu! [%s]\n", \
                 call CHState.getLabelElement(ci), __FUNCTION__);
         }
#endif //TOSSIM

        if (ci < call CHState.getLabelLength()) {
            // The node belongs to some group of the head node,
            // so we should update our label.
            dbg("CH|3", \
                "    * Adopting any label changes from the beacon.\n");
            labCopyFrom(msgLabel, msgLabelLen, ci);
        }

        dbgLocalLabel();
    }



    inline void labCopyFrom(
            nx_ch_label_t * olab, uint8_t olen, uint8_t di) {
        uint8_t changeLevel =
            call CHState.getLabelLength() != olen ?
                (call CHState.getLabelLength() < olen ?
                     call CHState.getLabelLength() : olen) :
                CH_MAX_LABEL_LENGTH;

        dbg("CH|CHANGE", "Label copied from length %hhu " \
            "to length %hhu.\n", call CHState.getLabelLength(), olen);

        call CHState.setLabelLength(olen);
        for (; di < olen; ++di) {
            uint16_t  oelem = call SubMsgLabel.getEl(olab, di);
            if (call CHState.getLabelElement(di) != oelem &&
                    di < changeLevel) {
                changeLevel = di;
            }
            call CHState.setLabelElement(di, oelem);
        }

        if (changeLevel < CH_MAX_LABEL_LENGTH) {
            signal ClusterHierarchy.labelChanged(changeLevel);
            printLabelChange();
           // OPTIMIZE: Comment the line below.
           // forceAdvert = TRUE;
        }
    }



    inline void labCut(uint8_t len) {
        dbg("CH|CHANGE", \
            "Label cut to length %hhu.\n", len);

        call CHState.setLabelLength(len);

        // In addition, cancel any promotion timers.
        call PromotionTimer.stop();
        // OPTIMIZE: Comment the line below.
        // forceAdvert = TRUE;

        signal ClusterHierarchy.labelChanged(len);

        printLabelChange();
    }



    inline void labExtend(uint16_t el) {
        uint8_t   len;
        dbg("CH|CHANGE", \
            "Label extension with element %hu.\n", el);

        len = call CHState.getLabelLength();
        call CHState.setLabelLength(len + 1);
        call CHState.setLabelElement(len, el);

        // In addition, cancel any promotion
        // timers and force an advert.
        call PromotionTimer.stop();
        // OPTIMIZE: Comment the line below.
        forceAdvert = TRUE;

        signal ClusterHierarchy.labelChanged(len);

        printLabelChange();
    }



    inline neighbor_t * rtLookupNeighbor(am_addr_t addr, uint8_t thr) {
        neighbor_t * res = call NeighborTable.getNeighbor(addr);
        if (res == NULL) {
            return NULL;
        }
        return call NeighborTable.getBiDirLinkQuality(res) >= thr ?
            res : NULL;
    }



//     inline ch_rt_entry_t * rtLookupEntry(
//             uint8_t level, uint16_t head) {
//         return call CHState.getRTEntry(level, head);
//     }



    inline ch_rt_entry_t * rtLookupEntryAtAnyHigherLevel(
            uint8_t level, uint16_t head) {
        return call CHState.getRTEntryAtAnyHigherLevel(level, head);
    }



    inline ch_rt_entry_t * rtLookupEntryAtAnyLevel(uint16_t head) {
        return rtLookupEntryAtAnyHigherLevel(1, head);
    }



    inline bool rtEntrySeqNoIsOlderOrEqual(uint8_t f, uint8_t s) {
        return (uint8_t)((uint8_t)s - (uint8_t)f) <= (uint8_t)127;
    }



    bool rtRefreshEntry(
            ch_rt_entry_t * pentry, uint16_t head, uint8_t level,
            uint8_t numHops, uint8_t ttl, ch_rt_entry_seq_no_t seqNo,
            am_addr_t nextHop, bool create, uint8_t lq) {
        uint8_t i;
        bool res;

        res = FALSE;

#ifdef TOSSIM
        // +++ A SANITY CHECK +++
        // NOTICE: This condition should be ensured on the
        //         call path to this method.
        // Check if the level is all right.
        if (level == 0 || level >= CH_MAX_LABEL_LENGTH) {
            dbgerror("CH|ERROR", \
                "Invalid level %hhu of a routing table entry! " \
                "Accepted values: 1..%hhu. [%s]\n", \
                level, CH_MAX_LABEL_LENGTH - 1, __FUNCTION__);
            return res;
        }
        // +++ END OF SANITY CHECK +++
#endif

        if (pentry == NULL) {
            // The entry does not exist.
            dbg("CH|3", \
                "    * An entry for cluster %hu at level %hhu does not " \
                "exist in the routing table.\n", head, level);

            if (create) {
                pentry = call CHState.putRTEntry(level, head);
                if (pentry != NULL) {
                    // The 'level' and 'head' fields are filled in
                    // by the call CHState.putRTEntry() call.
                    pentry->numHops = numHops;
                    pentry->maintenance.phb.seqNo = seqNo;
                    pentry->maintenance.phb.ttl = ttl;
                    pentry->nextHops[0].addr = nextHop;
                    pentry->nextHops[0].maintenance.phb.numHops = numHops;
                    for (i = 1; i < CH_MAX_RT_ENTRY_NEXT_HOP_CANDIDATES; ++i) {
                        pentry->nextHops[i].addr = AM_BROADCAST_ADDR;
                    }

                    dbg("CH|3", \
                        "    * The new entry has been created.\n");

                    res = TRUE;

                } else {
                    dbgerror("CH|ERROR", \
                        "Out of memory! Unable to create a routing " \
                        "table entry! [%s]\n", __FUNCTION__);
                }

            } else {
                dbg("CH|3", \
                    "    * The new entry could not be created as the " \
                    "CREATE flag was not set.\n");
            }

        } else {
            // The entry exists.
            if (seqNo != pentry->maintenance.phb.seqNo) {
                // The received advertisement is younger
                // than the entry.
                uint8_t existingNode;

                dbg("CH|3", \
                    "    * An entry for cluster %hu at level %hhu exists " \
                    "in the routing table and is older than the received " \
                    "advert.\n", head, level);

                // Check if the level is consistent.
                if (level != pentry->level) {
                    // The level is not consistent, so we
                    // must reallocate the entry to a different row.
                    dbg("CH|3", \
                        "    * The level of the received advert (%hhu) " \
                        "is inconsistent with the level of the routing " \
                        "entry (%hhu). Moving the entry to the new " \
                        "level.\n", level, pentry->level);

                    pentry = call CHState.changeRTEntryLevel(pentry, level);
                }

                for (existingNode = 0;
                        existingNode < CH_MAX_RT_ENTRY_NEXT_HOP_CANDIDATES;
                        ++existingNode) {
                    if (pentry->nextHops[existingNode].addr == nextHop) {
                        break;
                    }
                }

                // Reinitialize the entry.
                if (create ||
                        existingNode < CH_MAX_RT_ENTRY_NEXT_HOP_CANDIDATES) {
                    pentry->numHops = numHops;
                    pentry->maintenance.phb.seqNo = seqNo;
                    pentry->maintenance.phb.ttl = ttl;
                    pentry->nextHops[0].addr = nextHop;
                    pentry->nextHops[0].maintenance.phb.numHops = numHops;
                    for (i = 1; i < CH_MAX_RT_ENTRY_NEXT_HOP_CANDIDATES; ++i) {
                        pentry->nextHops[i].addr = AM_BROADCAST_ADDR;
                    }
                    res = TRUE;
                }

                dbg("CH|3", \
                    "    * The received advert has been used to refresh " \
                    "an existing entry with a new sequence number " \
                    "(%u).\n", (uint32_t)seqNo);


            } else {
                // The received advertisement is of the
                // same age as the entry.
                uint8_t        candidateIdx;

                dbg("CH|3", \
                    "    * An entry for cluster %hu at level %hhu exists " \
                    "in the routing table and is of the same age as the " \
                    "received advert.\n", head, level);

                // Check if the level is consistent.
                if (level != pentry->level) {
                    dbgerror("CH|ERROR", \
                        "The level of the received advert (%hhu) " \
                        "is inconsistent with the level of the routing " \
                        "entry (%hhu)! Dropping the advert. [%s]\n", \
                        level, pentry->level, __FUNCTION__);
                    return res;
                }

                // Check if the entry is not worse than us.
                if (pentry->numHops < numHops) {
                    dbg("CH|3", \
                        "    * The new entry represent a longer path " \
                        "than our path, so we ignore it.\n");
                    return res;
                }

                // Everything seems fine, so try to
                // find a spot for the next hop neighbor.
                candidateIdx = CH_MAX_RT_ENTRY_NEXT_HOP_CANDIDATES;
                for (i = 0; i < CH_MAX_RT_ENTRY_NEXT_HOP_CANDIDATES; ++i) {
                    if (pentry->nextHops[i].addr == nextHop) {
                        candidateIdx = CH_MAX_RT_ENTRY_NEXT_HOP_CANDIDATES;
                        break;
                    } else if (pentry->nextHops[i].addr == AM_BROADCAST_ADDR) {
                        // An empty slot.
                        candidateIdx = i;
                    } else if (pentry->nextHops[i].maintenance.phb.numHops >=
                            numHops &&
                                candidateIdx ==
                                    CH_MAX_RT_ENTRY_NEXT_HOP_CANDIDATES) {
                        neighbor_t *   neighbor;
                        neighbor =
                            call NeighborTable.getNeighbor(
                                pentry->nextHops[i].addr);
                        if (neighbor != NULL) {
                            if (call NeighborTable.getBiDirLinkQuality(neighbor) > lq) {
                                // The first worse slot.
                                candidateIdx = i;
                            }
                        }
                    }
                }

                if (candidateIdx < CH_MAX_RT_ENTRY_NEXT_HOP_CANDIDATES) {
                    // A spot was found.
                    pentry->nextHops[candidateIdx].addr =
                        nextHop;
                    pentry->nextHops[candidateIdx].maintenance.phb.numHops =
                        numHops;

                    dbg("CH|3", \
                        "    * The received advert has been used as a " \
                        "backup for the next hop neighbor.\n");

                } else {
                    // No spot was found.
                    dbg("CH|3", \
                        "    * The received advert has been ignored.\n");
                }

                res = TRUE;
            }


        }

        return res;

    }



    inline ch_rt_entry_t * rtGetJoinCandidate(uint8_t headLevel) {
        ch_rt_entry_t *   res;
        uint8_t           joinRadius;
        uint8_t           level;
        uint8_t           seenSoFar;

        res = NULL;
        seenSoFar = 0;

        joinRadius =
            call CHClustering.getMaxJoinRadius(
                headLevel + 1, call Config.getMaxPathLength());

        for (level = headLevel + 1; level < CH_MAX_LABEL_LENGTH; ++level) {
            ch_rt_entry_t *  pcurr =
                call CHState.getFirstRTEntryAtLevel(level);
            while (pcurr != NULL) {
                if (pcurr->numHops <= joinRadius) {
                    // We are in an acceptable distance from
                    // the considered cluster head.
                    if (res == NULL) {
                        res = pcurr;
                        seenSoFar = 1;
                    } else if (res->numHops > pcurr->numHops) {
                        res = pcurr;
                        seenSoFar = 1;
                    } else if (res->numHops == pcurr->numHops) {
                        // For tie breaking, we draw a random
                        // one from a uniform probability.
                        // To do that, use a harmonic distribution.
                        uint16_t r;

                        ++seenSoFar;
                        r = call Random.rand16() % seenSoFar;
                        if (r == 0) {
                            res = pcurr;
                        }
                    }
                }
                pcurr = call CHState.getNextRTEntryAtLevel(pcurr);
            }
        }

        return res;
    }



    inline void rtAgeAndClean() {
        uint8_t                i;

        dbg("CH|2", \
            "  - Starting aging and cleaning the routing table " \
            "(#entries: %hhu).\n", call CHState.getRTSize());

        dbgLocalRoutingTable();

        for (i = 1; i < CH_MAX_LABEL_LENGTH; ++i) {
            ch_rt_entry_t *  pcurr;
            ch_rt_entry_t *  pprev;

            pcurr = call CHState.getFirstRTEntryAtLevel(i);
            pprev = NULL;

            while (pcurr != NULL) {
                // Age the entry.
                --pcurr->maintenance.phb.ttl;

                if (pcurr->maintenance.phb.ttl == 0) {
                    // The entry has timed out.
                    dbg("CH|3", \
                        "    * Removing an entry for %hu at level %hhu.\n", \
                        pcurr->head, pcurr->level);

                    call CHState.removeRTEntryByPointers(pcurr, pprev);
                    pcurr = pprev == NULL ?
                        call CHState.getFirstRTEntryAtLevel(i) :
                        call CHState.getNextRTEntryAtLevel(pprev);
                } else {
                    // The entry is fine.
                    pprev = pcurr;
                    pcurr = call CHState.getNextRTEntryAtLevel(pcurr);
                }
            }
        }

        dbg("CH|2", \
            "  - Finished aging and cleaning the routing table " \
            "(#entries: %hhu).\n", call CHState.getRTSize());

        dbgLocalRoutingTable();
    }



    inline void repairHierarchyErrors() {
        uint8_t           headLevel;

        headLevel = call CHState.getLevelAsHead();

        dbg("CH|2", \
            "  - Checking for any hierarchy errors " \
            "(my level as head: %hhu; label length: %hhu).\n", \
            headLevel, call CHState.getLabelLength());

        dbgLocalLabel();

        if (headLevel + 1 < call CHState.getLabelLength()) {
            ch_rt_entry_t *   pSuperHead;
            // We are not the top-level cluster head,
            // so check if our cluster head is still alive.

            dbg("CH|3", \
                "    * We are not the top level head " \
                "(level: %hhu; top level: %hhu).\n", \
                headLevel, call CHState.getLabelLength() - 1);

            pSuperHead =
                rtLookupEntryAtAnyHigherLevel(
                    headLevel + 1,
                    call CHState.getLabelElement(headLevel + 1));

            if (pSuperHead == NULL) {
                // The super head does not exist,
                // so we have to cut the label.
                labCut(headLevel + 1);

                dbg("CH|3", \
                    "    * The super head does not exist. " \
                    "Performing label cut.\n");

            // NOTICE: We do not detect this condition, as
            //         we relaxed the routing table properties
            //         when issuing an advert (looking up the
            //         radius of a superhead).
            } else if (pSuperHead->numHops >
                    call CHClustering.getMaxJoinRadius(
                        headLevel + 1, call Config.getMaxPathLength())) {

                labCut(headLevel + 1);

                dbg("CH|3", \
                    "    * The super head is too far (%hhu hops " \
                    "whereas only %hhu hops is allowed). " \
                    "Performing label cut.\n", pSuperHead->numHops, \
                    call CHClustering.getMaxJoinRadius( \
                        headLevel + 1, call Config.getMaxPathLength()));

            } else {
                // We have found the super head,
                // so everything is ok.

                dbg("CH|3", \
                    "    * No label cut is necessary.\n");
            }

        } else {
            // We are the top-level head, so we can try
            // to seek for hierarchy optimizations.

            // NOTICE: However, we are not seeking for optimizations
            //         as in PL-Gossip, as it is not yet clear, how
            //         they should be performed according to this
            //         algorithm. We leave this as future work.
        }

        dbg("CH|2", \
            "  - Checking for hierarchy errors has finished " \
            "(label length: %hhu).\n", call CHState.getLabelLength());

        dbgLocalLabel();
    }



    inline void repairHierarchyIncompleteness() {
        uint8_t           headLevel;

        // Get the level of a node as the head.
        headLevel = call CHState.getLevelAsHead();

        dbg("CH|2", \
            "  - Checking for hierarchy incompleteness " \
            "(my level as head: %hhu; label length: %hhu).\n", \
            headLevel, call CHState.getLabelLength());

        dbgLocalLabel();

        if (!(call PromotionTimer.isRunning())) {
            dbg("CH|3", \
                "    * The promotion timer is not ticking.\n");

            if (checkForPossiblePromotion(headLevel)) {
                // Incompleteness was detected, so
                // initiate a promotion.
                uint8_t    radius;
                uint8_t    slot;
                uint32_t   timeOut;

                dbg("CH|3", \
                    "    * Incompleteness detected.\n");

                radius =
                    call CHClustering.getMaxPropagationRadius(
                        headLevel, call Config.getMaxPathLength());

                dbg("CH|3", \
                    "    * Initiating promotion to level %hhu " \
                    "(advert radius: %hhu).\n", headLevel + 1, radius);

                // Draw a random slot.
                slot =
                    call CHClustering.generatePromotionSlotNo(
                        headLevel,
                        call NeighborTable.getNumNeighbors());

                dbg("CH|3", \
                    "    * Drawn a random slot %hhu.\n", slot);

                // Compute the timeout.
                timeOut = (uint32_t)radius * (uint32_t)slot *
                    ((uint32_t)(BACKOFF_INCREMENT_WHEN_PROMOTING +
                        call Config.getMaxAdvertForwardingBackoff()));
                if (headLevel == 0) {
                    timeOut +=
                        call Config.getDutyCylePeriod() *
                        (uint32_t)ADDITIONAL_ROUNDS_FOR_FIRST_PROMOTION;
                }

                dbg("CH|3", \
                    "    * Computed a promotion timeout " \
                    "of %u milliseconds. Starting the promotion " \
                    "timer.\n", timeOut);

                // Start the promotion timer.
                call PromotionTimer.startOneShot(timeOut);


            } else {
                dbg("CH|3", \
                    "    * No incompleteness has been detected.\n");
            }

        } else {
            dbg("CH|3", \
                "    * The promotion timer has already been ticking.\n");
        }

        dbg("CH|2", \
            "  - Detecting hierarchy incompleteness finished " \
            "(label length: %hhu).\n", call CHState.getLabelLength());

        dbgLocalLabel();
    }



    bool checkForPossiblePromotion(uint8_t headLevel) {
        uint8_t   level;

        if (headLevel + 1 != call CHState.getLabelLength() ||
                call CHState.getLabelLength() >= CH_MAX_LABEL_LENGTH) {
            // We are not the top-level head or the
            // top level has already been reached.
            return FALSE;
        }

        if (headLevel == 0) {
            // We are at the very bottom, so we must
            // check our neighbor table.
            neighbor_iter_t  iter;

            dbg("CH|3", \
                "    * Looking for a neighbor that may "
                "cause label extension.\n");

            call NeighborTableIter.init(&iter);
            while (call NeighborTableIter.hasNext(&iter)) {
                neighbor_t * neighbor =
                    call NeighborTableIter.next(&iter);
                if (call NeighborTable.getBiDirLinkQuality(
                        neighbor) >=
                            call Config.getWhiteLQThreshold()) {
                    return TRUE;
                }
            }
        }

        // We still have to check the routing table.

        dbg("CH|3", \
            "    * Looking for an entry in the " \
            "routing table that may cause label " \
            "extension.\n");

        for (level = headLevel > 0 ? headLevel : 1;
                level < CH_MAX_LABEL_LENGTH;
                ++level) {
            ch_rt_entry_t *  pentry;
            for (pentry = call CHState.getFirstRTEntryAtLevel(level);
                    pentry != NULL;
                    pentry = call CHState.getNextRTEntryAtLevel(pentry)) {
                if (pentry->head !=
                        call CHState.getLabelElement(0)) {
                    return TRUE;
                }
            } // for each entry in the row
        } // for each row

        return FALSE;

    }



}
