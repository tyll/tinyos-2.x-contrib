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
 * uses solely local asynchronous state exchanges between neighboring
 * nodes. In other words, it combines update propagation with hierarchical
 * distance-vector.
 *
 * More information on such protocols can be found in:
 * K. Iwanicki and M. van Steen, ``Multi-hop Cluster Hierarchy Maintenance
 * in Wireless Sensor Networks: A Case for Gossip-Based Protocols.''
 * In <i>EWSN'09: Proceedings of the Sixth European Conference on Wireless
 * Sensor Networks</i>, Cork, Ireland, February 11-13, 2009,
 * Springer-Verlag LNCS vol. 5432, pp. 102-117.
 *
 * @author Konrad Iwanicki &lt;iwanicki@few.vu.nl&gt;
 */
module PeriodicHierarchicalDistanceVectorP {
    provides {
        interface Init;
        interface ClusterHierarchyMaintenanceControl as Control;
        interface ClusterHierarchy;
        interface TOSSIMStats;
    }
    uses {
        interface ClusterHierarchyMaintenanceConfig as Config;
        interface NxVector<uint16_t> as SubMsgLabel;
        interface NxVector<uint16_t> as SubMsgUpdateVect;
        interface CHMsgRTEntry<nx_ch_phdv_msg_rt_entry_t> as SubMsgRTEntry;

        interface NeighborTable as NeighborTable;
        interface Iterator<neighbor_iter_t, neighbor_t>
            as NeighborTableIter;

        interface Timer<TMilli> as MainTimer;

        interface AMSend as HeartbeatSend;
        interface Packet as HeartbeatPacket;
        interface AMPacket as HeartbeatAMPacket;
        interface Receive as HeartbeatReceive;

        interface CHLocalState as CHState;
        interface Init as CHStateInit;
        interface CHClustering;
        interface CHRouting;
        interface CHStateDebug;

        interface PoolOfMessages as MsgPool;

        interface Random as Random;
    }
}
implementation {

    // --------------------------- Configuration ---------------------------
    enum {
        /**
         * the maximal number of heartbeat message allowed in a single
         * round, 0 indicates that a node sends as many heartbeats as necessary
         * to transmit the whole routing table
         */
        MAX_HEARTBEATS_PER_ROUND = 0,
        /** the maximal number of rounds between subsequent label update vector broadcasts */
        MAX_NUM_ROUNDS_WITHOUT_LABEL_UPDATE_BROADCAST = 3,
        /** the invalid value for counters used to defer label operations */
        INVAL_CNT_VAL = 0xffff,
        /** the maximal value of counters used to defer label operations */
        MAX_CNT_VAL = INVAL_CNT_VAL - 1,
        /** a value representing an invalid number of hops (NO ROUTE) */
        NO_ROUTE_NUM_HOPS = CH_ROUTING_NO_ROUTE_NUM_HOPS,
        /** the additional number of rounds an entry may remain unrefreshed */
        RT_ENTRY_TTL_TOLERANCE = 3,
        /** the additional number of rounds a no-route entry is kept */
        RT_ENTRY_NO_ROUTE_TTL_BONUS = 3,
        /** the number of rounds a next hop candidate may be unrefreshed */
        RT_ENTRY_NEXT_HOP_TTL_TOLERANCE = 4,
        /**
         * the number of additional rounds a node waits when promoting
         * itself for a level-1 cluster head
         */
        ADDITIONAL_ROUNDS_FOR_FIRST_PROMOTION = 1,
    };



    // -------------------------- Private members --------------------------
    /** indicates whether the component is active */
    bool                       isActive = FALSE;
    /** indicates whether we are shutting down the component */
    bool                       shuttingDown = FALSE;

    /** the number of heartbeat messages sent so far in the present round */
    uint8_t                    numHeartbeatsInRound;
    /** the total number of heartbeat messages to send in the present round */
    uint8_t                    maxHeartbeatsInRound;
    /** the time the round was started */
    uint32_t                   roundStartTime;

    /**
     * the group head of the last entry that was selected
     * from the routing table for a heartbeat message
     */
    uint16_t                   lselRTGrpHead;
    /**
     * the level of the last entry that was selected
     * from the routing table for a heartbeat message
     */
    uint8_t                    lselRTGrpLevel;
    /** indicates whether the node's label has changed since the last round */
    bool                       hasLabelChanged;
    /**
     * the number of rounds that passed since the label updates were
     * last broadcast
     */
    uint8_t                    numRoundsSinceLabelUpdateBroadcast;

    /** the sequence number for the cluster advertisements */
    ch_rt_entry_seq_no_t       advertSeqNo = 0;

    /** the counter used to defer spawning a new super-group */
    uint16_t                   labExtCnt;
    /** the update counter */
    ch_phdv_ucnt_t             labUpdateCnt = 0;
    /** the update vector */
    ch_phdv_ucnt_t             labUpdateVect[CH_MAX_LABEL_LENGTH];




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
     * Debugs the local update vector.
     */
    void dbgLocalUpdateVect();
    /**
     * Debugs the label from a hearbeat message.
     * @param msgLabel the message label
     */
    void dbgMessageLabel(nx_ch_label_t * msgLabel);
    /**
     * Debugs the update vector from a heartbeat message.
     * @param msgUpdateVect the message update vector
     */
    void dbgMessageUpdateVect(nx_vect_t * msgUpdateVect);
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
     * Computes the number of heartbeat messages that will be sent
     * in the current round.
     * @return the number of heartbeat messages to send in the current
     *         round
     */
    uint8_t computeNumHeartbeatMessagesPerRound();
    /**
     * Schedules the main timer.
     * Based on the current state of the node, the timer can be scheduled
     * in order to transmit an advert, or to perform bookkeeping at
     * the end of a round.
     */
    void scheduleMainTimer();
    /**
     * Adopts any updates that are carried within the label from
     * a received heartbeat message.
     * @param mLabel the label from the message
     * @param mUpdateVect the update vector for the label
     * @param mLabelLength the length of the label
     * @return the minimal common level of the node's labels
     */
    uint8_t labAdoptUpdates(
        nx_ch_label_t * mLabel, nx_vect_t * mUpdateVect, uint8_t mLabelLength);
    /**
     * Checks if one update counter is older than the other.
     * @param uc1 the first update counter
     * @parma uc2 the second update counter
     * @return <code>TRUE</code> if the first update counter is older than
     *         the second, otherwise <code>FALSE</code>
     */
    bool labIsUpdateCounterOlder(ch_phdv_ucnt_t uc1, ch_phdv_ucnt_t uc2);
    /**
     * Advances the label update counter by one.
     * @return the new counter value
     */
    ch_phdv_ucnt_t labAdvanceUpdateCounter();
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
     * Attempts to issue a heartbeat message.
     * @return the status of the operation
     */
    error_t issueHeartbeat();
    /**
     * Selects and stores routing table entries in a message.
     * <b>ASSUMPTION:</b> <code>lselRTGrpLevel</code> > 0
     * @param payload the payload from which the entries can be stored
     * @param maxEntries the maximal number of routing entries to store
     * @return the number of routing entries stored (<maxEntries)
     */
    uint8_t storeRTEntriesInMessage(
            nx_ch_phdv_msg_rt_entry_t * payload, uint8_t maxEntries);
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
     * Updates routes with the information carried in a received heartbeat
     * message.
     * @param neighbor the neighbor from which the heartbeat message was
     *        received
     * @param mRT the array of routing table entries
     * @param mLabel the message label
     * @param mRTLength the length of the array
     * @param minCommonLevel the minimal common level of the node's label
     *        and the message label
     * @param mLabelLength the length of the message label
     */
    void rtUpdateRoutes(
        neighbor_t * neighbor,
        nx_ch_phdv_msg_rt_entry_t * mRT,
        nx_ch_label_t * mLabel,
        uint8_t mRTLength,
        uint8_t minCommonLevel,
        uint8_t mLabelLength);
    /**
     * Refreshes an entry for a cluster.
     * @param head      the identifier of the cluster head
     * @param level     the level at which the entry should be refreshed
     * @param numHops   the number of hops from the cluster head
     * @param radius    the propagation radius of the advertisement
     * @param seqNo     the sequence number of the cluster advertisement
     * @param nextHop   the link-layer address of the next hop neighbor
     * @param adjacent  the adjacency flag of the entry
     * @param create    <code>TRUE</code> if the entry should be created if
     *                  it does not exist
     */
    void rtRefreshEntry(
            uint16_t head, uint8_t level,
            uint8_t numHops, uint8_t radius, ch_rt_entry_seq_no_t seqNo,
            am_addr_t nextHop, bool adjacent, bool create);
    /**
     * Refreshes the next hop candidate of a routing table entry.
     * @param pentry the entry to consider
     * @param nextHop the link-layer address of the next hop candidate
     * @param numHops the number of hops to take
     * @param adjacent <code>TRUE</code> if the entry represents
     *        an adjacent cluster
     * @param create <code>TRUE</code> if the new next hop candidate
     *        may be created
     * @param fresher <code>TRUE</code> if the new candidate represents
     *        a fresher sequence number
     */
    void rtRefreshEntryNextHop(
            ch_rt_entry_t * pentry, am_addr_t nextHop, uint8_t numHops,
            bool adjacent, bool create, bool fresher);
    /**
     * Returns a join candidate for the node.
     * @param headLevel the level on which the node is a head
     * @return a join candidate or <code>NULL</code> if such a candidate
     *         does not exist
     */
    ch_rt_entry_t * rtGetJoinCandidate(uint8_t headLevel);
    /**
     * Returns the distance to the furthest head at a given level.
     * @param level the level
     * @return the furthest distance to a cluster head at a given level;
     *         if the routing table at this level is empty, the maximal
     *         propagation radius for the level is returned
     */
    uint8_t rtGetMaxDistanceAtLevel(uint8_t level);
    /**
     * Ages and cleans the routing table.
     */
    void rtAgeAndClean();
    /**
     * Adds an entry representing the present node's cluster
     * to the routing table.
     */
    void rtRefreshMyRoutingEntry();
    /**
     * Processes a received heartbeat message.
     * The message can be used to update the node's label
     * and routing table.
     * @param neighbor the neighbor from which the message was received
     * @param msg the message
     * @param payload the message payload
     * @param len the length of the message
     * @return the pointer to the buffer that should be returned to
     *         lower layers; it can be different than <code>msg</code>,
     *         for instance, if the message is further forwarded
     */
    message_t * processReceivedHeartbeat(
            neighbor_t * neighbor, message_t * msg,
            uint8_t * payload, uint8_t len);
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



    // -------------------------- Interface Init ---------------------------
    command inline error_t Init.init() {
        error_t res;

        dbg("CH|1", \
            "Initializing the periodic hierarchical DV engine " \
            "for cluster hierarchy maintenance. [%s]\n", __FUNCTION__);

        res = resetState();

        return res;
    }



    // ------------------------- Interface Control -------------------------
    command error_t Control.start() {
        dbg("CH|1", \
            "Starting the periodic hierarchical DV engine for " \
            "cluster hierarchy maintenance. [%s]\n", __FUNCTION__);

        isActive = TRUE;

        call MainTimer.startOneShot(
            call Random.rand32() % call Config.getDutyCylePeriod());

        dbg("CH|1", \
            "The periodic hierarchical DV engine for cluster hierarchy " \
            "maintenance has been started successfully. [%s]\n", \
            __FUNCTION__);

        return SUCCESS;
    }



    command error_t Control.stop() {
        error_t res;

        dbg("CH|1", \
            "Stopping the periodic hierarchical DV engine for " \
            "cluster hierarchy maintenance. [%s]\n", __FUNCTION__);

        shuttingDown = TRUE;

        call MainTimer.stop();

        isActive = FALSE;
        shuttingDown = FALSE;

        res = resetState();

        dbg("CH|1", \
            "The periodic hierarchical DV engine for cluster hierarchy " \
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



    // -------------------- Interface ClusterHierarchy ---------------------
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



    // ----------------------- Interface MainTimer -------------------------
    event inline void MainTimer.fired() {
        dbg("CH|1", \
            "The main timer of the cluster hierarchy maintenance engine " \
            "has fired. [%s]\n", __FUNCTION__);

        // Check if the purpose of the timer is to send
        // an advert, or to do bookkeeping.
        if (numHeartbeatsInRound == 0) {
            post taskPerformBookkeeping();
            signal Control.bookkeepingStarted();

        } else {
            issueHeartbeat();
            scheduleMainTimer();
        }


        dbg("CH|1", \
            "Leaving the handler of the main timer for the cluster " \
            "hierarchy maintenance engine. [%s]\n", __FUNCTION__);
    }



    // -------------------- Interface HeartbeatSend ------------------------
    event inline void HeartbeatSend.sendDone(message_t * msg, error_t err) {
        // Free the message buffer.
        call MsgPool.freeMessage(msg);
    }



    // ------------------- Interface HeartbeatReceive ----------------------
    event message_t * HeartbeatReceive.receive(
            message_t * msg, void * payload, uint8_t len) {
        neighbor_t *  neighbor;

        dbg("CH|1", \
            "The cluster hierarchy maintenance engine received a %hhu-byte " \
            "heartbeat message %x. [%s]\n", len, msg, __FUNCTION__);

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
            call HeartbeatAMPacket.source(msg), \
            call Config.getGrayLQThreshold());

        // Find a node that sent sent us a message
        neighbor =
            rtLookupNeighbor(
                call HeartbeatAMPacket.source(msg),
                call Config.getGrayLQThreshold());

        if (neighbor != NULL) {
            // The neighbor exists and has a fair link.
            dbg("CH|2", \
                "  - The neighbor has been found. " \
                "Starting processing the message.\n");

            msg =
                processReceivedHeartbeat(
                    neighbor, msg, (uint8_t *)payload, len);

        } else {

            dbg("CH|2", \
                "  - A neighbor with link-layer address %hu does not " \
                "exist in the node's neighbor table or its link quality " \
                "is below the threshold %hhu.\n", \
                call HeartbeatAMPacket.source(msg), \
                call Config.getGrayLQThreshold());
        }

        dbg("CH|1", \
            "Finished processing the received message. Returning " \
            "message buffer %x to the lower layers. [%s]\n", \
            msg, __FUNCTION__);

        return msg;
    }



    // ------------------- Interface NeighborTable -------------------------
    event void NeighborTable.neighborEvicted(am_addr_t llAddress) {
        // NOTICE: This method is not strictly necessary, as the unrefreshed
        //         next-hop candidates are removed from the routing table
        //         entries. However, we may want to keep this method here.
        uint8_t  level;

        dbg("CH|1", \
            "Lower layers have signaled the cluster hierarchy maintenance " \
            "engine that neighbor %hu is no longer alive. [%s]\n", \
            llAddress, __FUNCTION__);

        for (level = 1; level < CH_MAX_LABEL_LENGTH; ++level) {
            ch_rt_entry_t *  pcurr =
                call CHState.getFirstRTEntryAtLevel(level);
            while (pcurr != NULL) {

                if (pcurr->numHops != NO_ROUTE_NUM_HOPS) {
                    bool      noCandidate;
                    uint8_t   i;

                    noCandidate = TRUE;
                    for (i = 0; i < CH_MAX_RT_ENTRY_NEXT_HOP_CANDIDATES; ++i) {
                        if (pcurr->nextHops[i].addr == llAddress) {
                            pcurr->nextHops[i].addr = AM_BROADCAST_ADDR;
                        } else if (pcurr->nextHops[i].addr != AM_BROADCAST_ADDR) {
                            noCandidate = FALSE;
                        }
                    }

                    if (noCandidate) {
                        // We have to remove a routing entry
                        // as it does not contain any hops.
                        dbg("CH|2", \
                            "  - No next hop for a routing entry %hu at " \
                            "level %hhu.\n", pcurr->head, pcurr->level);
                        pcurr->numHops = NO_ROUTE_NUM_HOPS;
                        pcurr->maintenance.phdv.ttl += RT_ENTRY_NO_ROUTE_TTL_BONUS;
                    }
                }

                pcurr = call CHState.getNextRTEntryAtLevel(pcurr);
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
//                 if (pentry->numHops != NO_ROUTE_NUM_HOPS) {
//                     // We only report entries that do have routes.
//                     uint8_t j;
// 
//                     n = 0;
//                     for (j = 0; j < CH_MAX_RT_ENTRY_NEXT_HOP_CANDIDATES &&
//                                 n < SIM_KI_AREAHIER_MAX_NEXT_HOP_CANDIDATES; ++j) {
//                         if (pentry->nextHops[j].addr != AM_BROADCAST_ADDR) {
//                             nextHopsToReport[n].addr =
//                                 pentry->nextHops[j].addr;
//                             nextHopsToReport[n].numHops =
//                                 pentry->nextHops[j].maintenance.phb.numHops;
//                             ++n;
//                         }
//                     }
//                     sim_ki_areahier_report_rt_entry(
//                         TOS_NODE_ID,
//                         pentry->level,
//                         pentry->head,
//                         pentry->numHops,
//                         0,
//                         n,
//                         nextHopsToReport);
//                 }
//                 pentry = call CHState.getNextRTEntryAtLevel(pentry);
//             }
//         }
// 
//         // Finish reporting node data.
//         sim_ki_areahier_finish_reporting_node_data(TOS_NODE_ID);
// #endif
#endif
    }



    // ------------------------------- Tasks -------------------------------
    task void taskPerformBookkeeping() {
        dbg("CH|1", \
            "Starting bookkeeping of the hierarchy maintenance " \
            "engine. [%s]\n", __FUNCTION__);

        rtAgeAndClean();

        repairHierarchyErrors();

        repairHierarchyIncompleteness();

        rtRefreshMyRoutingEntry();

        post taskAfterBookkeeping();

        dbg("CH|1", \
            "Bookkeeping of the hierarchy maintenance engine has " \
            "finished. [%s]\n", __FUNCTION__);

        ++numRoundsSinceLabelUpdateBroadcast;

//         if (MAX_HEARTBEATS_PER_ROUND == 0) {
//             // If we transmit the whole routing state
//             // in a round, then reset the selected indices.
//             lselRTGrpLevel = 1;
//             lselRTGrpHead = 0;
//         }

        maxHeartbeatsInRound = computeNumHeartbeatMessagesPerRound();
        roundStartTime = call MainTimer.getNow();

        scheduleMainTimer();
    }



    task void taskAfterBookkeeping() {
        signal Control.bookkeepingFinished();
    }



    // ----------------- Private function implementations ------------------
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



    inline void dbgLocalUpdateVect() {
#ifdef TOSSIM
#ifndef TOSSIM_NO_DEBUG
        uint8_t   i;

        dbg("CH|Raw", "Local update vector:");
        for (i = 0; i < call CHState.getLabelLength(); ++i) {
            dbg_clear("CH|Raw", " %hu", labUpdateVect[i]);
        }
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



    inline void dbgMessageUpdateVect(nx_vect_t * msgUpdateVect) {
#ifdef TOSSIM
#ifndef TOSSIM_NO_DEBUG
        uint8_t i, len;

        dbg("CH|Raw", "Message update vector:");
        len = call SubMsgUpdateVect.getLen(msgUpdateVect);
        for (i = 0; i < len; ++i) {
            dbg_clear("CH|Raw", " %hu", \
                call SubMsgUpdateVect.getEl(msgUpdateVect, i));
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
        error_t  res;
        uint8_t  i;

        // Renitialize the local state common for all
        // the hierarchy maintenance algorithms.
        res = call CHStateInit.init();
        if (res != SUCCESS) {
            return res;
        }

        // Initialize message scheduling information.
        numHeartbeatsInRound = 0;
        maxHeartbeatsInRound = 1;

        // Initialize information of the transmitted routing entries.
        lselRTGrpLevel = 1;
        lselRTGrpHead = 0;
        hasLabelChanged = TRUE;
        numRoundsSinceLabelUpdateBroadcast = 0;

        // Initialize promotion counters.
        labExtCnt = INVAL_CNT_VAL;

        // Initialize the update vector.
        labUpdateVect[0] = labAdvanceUpdateCounter();
        for (i = 1; i < CH_MAX_LABEL_LENGTH; ++i) {
            labUpdateVect[i] = 0;
        }

        // Print the new label, so that hierarchy
        // maintenance can be visualized.
        printLabelChange();

        return SUCCESS;
    }



    inline uint8_t computeNumHeartbeatMessagesPerRound() {
        if (MAX_HEARTBEATS_PER_ROUND > 0) {
            return MAX_HEARTBEATS_PER_ROUND;
        } else if (call CHState.getRTSize() == 0) {
            return 1;
        } else {
            // NOTICE: We are optimistic in our calculations.
            uint8_t minOverheadPerMessage;
            uint8_t maxRTEntriesPerMessage;

            minOverheadPerMessage =
                sizeof(nx_ch_phdv_heartbeat_msg_hdr_t) +
                call SubMsgLabel.getByteLen(call CHState.getLabelLength());

            maxRTEntriesPerMessage =
                (call HeartbeatPacket.maxPayloadLength() -
                    minOverheadPerMessage) /
                        call SubMsgRTEntry.getByteSize();

            if (maxRTEntriesPerMessage == 0) {
                dbgerror("CH|ERROR", \
                    "Internal error: The payload of a heartbeat message " \
                    "is too small! [%s]\n", __FUNCTION__);
                return 1;
            }

            return (call CHState.getRTSize() + maxRTEntriesPerMessage - 1) /
                maxRTEntriesPerMessage;
        }
    }



    inline void scheduleMainTimer() {
        uint32_t    eventTime;
        uint32_t    dt;

        if (numHeartbeatsInRound < maxHeartbeatsInRound) {

            dt = (call Config.getDutyCylePeriod()) / maxHeartbeatsInRound;

            if (dt == 0) {
                dt = 1;
            }

            eventTime =
                roundStartTime +
                numHeartbeatsInRound * dt;

            eventTime +=
                call Random.rand32() % dt;

            ++numHeartbeatsInRound;

        } else {
            eventTime =
                roundStartTime +
                (call Config.getDutyCylePeriod());

            numHeartbeatsInRound = 0;
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



    inline uint8_t labAdoptUpdates(
            nx_ch_label_t * mLabel,
            nx_vect_t * mUpdateVect,
            uint8_t mLabelLength) {

        uint8_t   res;
        uint8_t   minLabelLength;
        uint8_t   commonLevel;
        uint8_t   labelChangedLevel;
        uint8_t   differingLevel;

        dbg("CH|2", \
            "  - Adopting any label updates.\n");

        dbgLocalLabel();
        dbgMessageLabel(mLabel);
        dbgLocalUpdateVect();
        dbgMessageUpdateVect(mUpdateVect);

        // Get the minimal label length.
        minLabelLength =
            mLabelLength < call CHState.getLabelLength() ?
                mLabelLength : call CHState.getLabelLength();

        // Find the common level of the nodes.
        for (commonLevel = 0; commonLevel < minLabelLength; ++commonLevel) {
            if (call CHState.getLabelElement(commonLevel) ==
                    call SubMsgLabel.getEl(mLabel, commonLevel)) {
                break;
            }
        }

        res = commonLevel;
        if (res >= minLabelLength) {
            res = CH_MAX_LABEL_LENGTH;
        }

        dbg("CH|3", \
            "    * The minimal common level of the nodes is %hhu.\n", \
            commonLevel);

#ifdef TOSSIM
#ifndef TOSSIM_NO_DEBUG
        // Sanity check.
        if (commonLevel == 0) {
            dbgerror("CH|ERROR", \
                "The nodes have similar identifiers %hu! [%s]\n", \
                call CHState.getLabelElement(commonLevel), __FUNCTION__);
            return res;
        }
#endif
#endif

        labelChangedLevel = CH_MAX_LABEL_LENGTH;
        while (commonLevel < minLabelLength) {
            // Find the differing level.
            for (differingLevel = commonLevel;
                    differingLevel < minLabelLength;
                    ++differingLevel) {
                if (labUpdateVect[differingLevel] !=
                        call SubMsgUpdateVect.getEl(
                            mUpdateVect, differingLevel)) {
                    break;
                }
            }

            dbg("CH|3", \
                "    * The labels differ at level %hhu.\n", \
                differingLevel);

#ifdef TOSSIM
#ifndef TOSSIM_NO_DEBUG
            // Sanity check.
            if (differingLevel >= minLabelLength &&
                    mLabelLength != call CHState.getLabelLength()) {
                    dbgerror("CH|ERROR", \
                        "Update vectors match, but their " \
                        "lengths do not (%hhu != %hhu)! [%s]\n", \
                        mLabelLength, call CHState.getLabelLength(), \
                        __FUNCTION__);
                    return res;
            }
#endif
#endif

            if (differingLevel < minLabelLength) {
                // There is some difference between the nodes.
                if (labIsUpdateCounterOlder(
                        labUpdateVect[differingLevel],
                        call SubMsgUpdateVect.getEl(
                            mUpdateVect, differingLevel))) {
                    uint8_t level;

                    dbg("CH|3", \
                        "    * Our label is older.\n");

                    // The local update vector is older,
                    // so adopt the updates.
                    // NOTICE: We can improve this algorithm.
                    call CHState.setLabelLength(mLabelLength);
                    minLabelLength = mLabelLength;
                    for (level = differingLevel;
                            level < mLabelLength;
                            ++level) {
                        call CHState.setLabelElement(
                            level,
                            call SubMsgLabel.getEl(mLabel, level));
                        labUpdateVect[level] =
                            call SubMsgUpdateVect.getEl(mUpdateVect, level);
                    }

                    // Mark that the label has changed.
                    if (labelChangedLevel > differingLevel + 1) {
                        labelChangedLevel = differingLevel + 1;
                    }

                }

                // NOTICE: If we improve the algorithm, this will go out.
                commonLevel = minLabelLength;

                dbg("CH|3", \
                    "    * Adopted label updates to level %hhu.\n", \
                    commonLevel);

            } else {
                // The node update vectors match perfectly.
                commonLevel = differingLevel;

                dbg("CH|3", \
                    "    * It is not necessary to adopt any updates.\n");
            }
        }

        // If the label has changed, signal this event.
        if (labelChangedLevel < CH_MAX_LABEL_LENGTH) {
            dbg("CH|2", \
                "  - Signaling a label change at level %hhu.\n", \
                labelChangedLevel);

            hasLabelChanged = TRUE;

            signal ClusterHierarchy.labelChanged(labelChangedLevel);

            printLabelChange();
        }

        dbgLocalLabel();
        dbgMessageLabel(mLabel);
        dbgLocalUpdateVect();
        dbgMessageUpdateVect(mUpdateVect);
        
        return res;
    }



    inline bool labIsUpdateCounterOlder(
            ch_phdv_ucnt_t uc1, ch_phdv_ucnt_t uc2) {
        // NOTICE: We may do the same wrapping as with sequence numbers.
        return uc1 < uc2;
    }



    inline ch_phdv_ucnt_t labAdvanceUpdateCounter() {
        // NOTICE: we may do the same wrapping as with sequence numbers.
        return ++labUpdateCnt;
    }



    inline void labCut(uint8_t len) {
        dbg("CH|CHANGE", \
            "Label cut to length %hhu.\n", len);

        call CHState.setLabelLength(len);
        labUpdateVect[len - 1] = labAdvanceUpdateCounter();
        
        hasLabelChanged = TRUE;

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
        labUpdateVect[len - 1] = labAdvanceUpdateCounter();
        labUpdateVect[len] = 0;

        hasLabelChanged = TRUE;

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



    error_t issueHeartbeat() {
        message_t *                msg;
        uint8_t *                  payload;
        uint8_t                    len;
        uint8_t                    numEntriesAndFlags;
        uint8_t                    n;
        uint8_t                    i;

        dbg("CH|1", \
            "Preparing a heartbeat message (label changed: %s; rounds " \
            "since label: %hhu; last RT level: %hhu, last RT " \
            "head: %hu). [%s]\n", hasLabelChanged ? "yes" : "no", \
            numRoundsSinceLabelUpdateBroadcast, lselRTGrpLevel, lselRTGrpHead, \
            __FUNCTION__);

        // Get the minimal required length.
        len = sizeof(nx_ch_phdv_heartbeat_msg_hdr_t) +
                call SubMsgLabel.getByteLen(call CHState.getLabelLength()) +
                call SubMsgRTEntry.getByteSize();

        // Adjust the length based on whether we
        // have to send the label.
        if (hasLabelChanged ||
                numRoundsSinceLabelUpdateBroadcast >=
                    MAX_NUM_ROUNDS_WITHOUT_LABEL_UPDATE_BROADCAST) {
            len +=
                call SubMsgUpdateVect.getByteLen(call CHState.getLabelLength());
            numEntriesAndFlags =
                NX_CH_PHDV_HEARTBEAT_MSG_HDR_LABEL_UPDATE_PRESENT_FLAG;
        } else {
            numEntriesAndFlags = 0;
        }

        // Check if we have enough payload.
        if (len > call HeartbeatPacket.maxPayloadLength()) {
            dbgerror("CH|ERROR", \
                "Message payload (%hhu) is too small to hold a  " \
                "%hhu-byte heartbeat message! [%s]\n", \
                call HeartbeatPacket.maxPayloadLength(), len, __FUNCTION__);
            return FAIL;
        }

        // Yes, so compute the number of routing
        // entries we can store.
        n = ((call HeartbeatPacket.maxPayloadLength()) - len) /
                (call SubMsgRTEntry.getByteSize()) + 1;
        if (n > NX_CH_PHDV_HEARTBEAT_MSG_HDR_NUM_ENTRIES_MASK) {
            n = NX_CH_PHDV_HEARTBEAT_MSG_HDR_NUM_ENTRIES_MASK;
        }

        // The payload is big enough,
        // so allocate the message buffer.
        msg = call MsgPool.allocMessage();
        if (msg == NULL) {
            dbgerror("CH|ERROR", \
                "Message pool is full! Unable to allocate a " \
                "heartbeat message! [%s]\n", __FUNCTION__);
            return EBUSY;
        }

        dbg("CH|2", \
            "  - Allocated a message buffer (max. num. rt entries: %hhu). " \
            "Filling in the message.\n", n);

        payload = (uint8_t *)call HeartbeatPacket.getPayload(msg, NULL);
        len = sizeof(nx_ch_phdv_heartbeat_msg_hdr_t);

        // Store the label.
        call SubMsgLabel.setLen(
            (nx_ch_label_t *)(payload + len),
            call CHState.getLabelLength());
        for (i = 0; i < call CHState.getLabelLength(); ++i) {
            call SubMsgLabel.setEl(
                (nx_ch_label_t *)(payload + len),
                i,
                call CHState.getLabelElement(i));
        }

        dbg("CH|2", \
            "  - Stored a %hhu-byte label.\n", \
            call SubMsgLabel.getByteLen( \
                call CHState.getLabelLength()));

        len += call SubMsgLabel.getByteLen(call CHState.getLabelLength());

        // Store the update vector if necessary.
        if ((numEntriesAndFlags &
                NX_CH_PHDV_HEARTBEAT_MSG_HDR_LABEL_UPDATE_PRESENT_FLAG) != 0) {

            call SubMsgUpdateVect.setLen(
                (nx_vect_t *)(payload + len),
                call CHState.getLabelLength());
            for (i = 0; i < call CHState.getLabelLength(); ++i) {
                call SubMsgUpdateVect.setEl(
                    (nx_vect_t *)(payload + len),
                    i,
                    labUpdateVect[i]);
            }

            dbg("CH|2", \
                "  - Stored a %hhu-byte update vector.\n", \
                call SubMsgUpdateVect.getByteLen( \
                    call CHState.getLabelLength()));

            len += call SubMsgUpdateVect.getByteLen(call CHState.getLabelLength());

            numRoundsSinceLabelUpdateBroadcast = 0;

        }

        // Store routing table entries.
        n =
            storeRTEntriesInMessage(
                (nx_ch_phdv_msg_rt_entry_t *)(payload + len), n);

        dbg("CH|2", \
            "  - Stored %hhu %hhu-byte routing entries (%hhu bytes in " \
            "total).\n", n, call SubMsgRTEntry.getByteSize(), \
            (call SubMsgRTEntry.getByteSize()) * n);

        len += (call SubMsgRTEntry.getByteSize()) * n;

        // Store the header.
        numEntriesAndFlags |= n;
        ((nx_ch_phdv_heartbeat_msg_hdr_t *)payload)->numEntriesAndFlags =
            numEntriesAndFlags;

        dbg("CH|2", \
            "  - Stored a %hhu-byte header.\n", \
            sizeof(nx_ch_phdv_heartbeat_msg_hdr_t));

        dbg("CH|1", \
            "Enqueueing a %hhu-byte heartbeat message for sending. [%s]\n", \
            len, __FUNCTION__);

        dbgRawMessage(msg);

        {
            error_t   error;

            error = call HeartbeatSend.send(AM_BROADCAST_ADDR, msg, len);

            if (error != SUCCESS) {
                dbgerror("CH|ERROR", \
                    "Unable to enqueue a message for sending! [%s]\n", \
                    __FUNCTION__);

                // Free the allocated message buffer.
                call MsgPool.freeMessage(msg);

            } else {
                dbg("CH|1", \
                    "The heartbeat message has been equeued for sending. [%s]\n", \
                    __FUNCTION__);

                hasLabelChanged = FALSE;
            }

            return error;
        }
    }



    inline uint8_t storeRTEntriesInMessage(
            nx_ch_phdv_msg_rt_entry_t * payload, uint8_t maxEntries) {

        ch_rt_entry_t *    pcurr;
        uint8_t            numSelected;
        bool               isLevelRepeated;
        uint8_t            level;

        // ASSUMPTION:   lselRTGrpLevel > 0
        // ASSUMPTION:   maxEntries > 0

        // Initialize iteration.
        numSelected = 0;
        isLevelRepeated = FALSE;
        level = lselRTGrpLevel;

        // Find the entry with a given group head or one
        // with the minimal greater value.
        pcurr = call CHState.getFirstRTEntryAtLevel(level);
        while (pcurr != NULL) {
            if (pcurr->head >= lselRTGrpHead) {
                break;
            }
            pcurr = call CHState.getNextRTEntryAtLevel(pcurr);
        }

        // Iterate over all levels.
        do {
            // Iterate over all entries at the level.
            while (pcurr != NULL) {

                if (isLevelRepeated && pcurr->head >= lselRTGrpHead) {
                    // The entry has already been visited.
                    break;
                }

                // Mark the next entry to visit.
                lselRTGrpHead = pcurr->head + 1;

                if (pcurr->numHops < pcurr->maintenance.phdv.radius ||
                        pcurr->level == CH_MAX_LABEL_LENGTH - 1 ||
                        pcurr->numHops == NO_ROUTE_NUM_HOPS) {
                    dbg("CH|3", \
                        "    * Storing a routing entry at level %hhu with " \
                        "head node %hu, %hhu hops, radius of %hhu, and seq. " \
                        "no. %u.\n", pcurr->level, pcurr->head, pcurr->numHops, \
                        pcurr->maintenance.phdv.radius, \
                        (unsigned int)pcurr->maintenance.phdv.seqNo);

                    // NOTICE: If there is no route, the number of hops
                    //         is automatically set to NO_ROUTE_NUM_HOPS,
                    //         so the no route info is picked by other nodes.

                    call SubMsgRTEntry.setLevel(
                        &(payload[numSelected]),
                        pcurr->level);
                    call SubMsgRTEntry.setHead(
                        &(payload[numSelected]),
                        pcurr->head);
                    call SubMsgRTEntry.setNumHops(
                        &(payload[numSelected]),
                        pcurr->numHops);
                    call SubMsgRTEntry.setSeqNo(
                        &(payload[numSelected]),
                        pcurr->maintenance.phdv.seqNo);
                    call SubMsgRTEntry.setAdjacencyFlag(
                        &(payload[numSelected]),
                        pcurr->maintenance.phdv.adjacent);

                    ++numSelected;

                    if (numSelected >= maxEntries) {
                        break;
                    }
                }

                pcurr = call CHState.getNextRTEntryAtLevel(pcurr);

            }

            // Check if this is the time to finish.
            if (numSelected >= maxEntries || isLevelRepeated) {
                break;
            }

            // Go to the next level and fetch the first element.
            ++level;
            if (level >= CH_MAX_LABEL_LENGTH) {
                level = 1;
            }
            if (level == lselRTGrpLevel) {
                isLevelRepeated = TRUE;
            }
            pcurr = call CHState.getFirstRTEntryAtLevel(level);

        } while (TRUE);

        // Mark the last visited level.
        lselRTGrpLevel = level;

        return numSelected;
    }



    message_t * processReceivedHeartbeat(
            neighbor_t * neighbor, message_t * msg,
            uint8_t * payload, uint8_t len) {

        nx_ch_label_t *              mLabel;
        nx_vect_t *                  mUpdateVect;
        nx_ch_phdv_msg_rt_entry_t *  mRT;
        uint8_t                      mLabelLength;
        uint8_t                      numRTEntries;
        uint8_t                      labelUpdatePresent;
        uint8_t                      minCommonLevel;

        // Check if the payload can hold the header.
        if (len < sizeof(nx_ch_phdv_heartbeat_msg_hdr_t) +
                    call SubMsgLabel.getByteLen(1)) {
            dbgerror("CH|ERROR", \
                "Message length %hhu is too small for the header! [%s]\n", \
                len, __FUNCTION__);
            return msg;
        }

        // Extract the data from the header.
        numRTEntries =
            ((nx_ch_phdv_heartbeat_msg_hdr_t *)payload)->numEntriesAndFlags;
        labelUpdatePresent =
            numRTEntries & NX_CH_PHDV_HEARTBEAT_MSG_HDR_LABEL_UPDATE_PRESENT_FLAG;
        numRTEntries &= NX_CH_PHDV_HEARTBEAT_MSG_HDR_NUM_ENTRIES_MASK;

        dbg("CH|2", \
            "  - The message contains a label and %hhu routing entries, " \
            "and %s the update vector.\n", numRTEntries, \
            labelUpdatePresent ? "contains" : "does not contain");

        // Get label length.
        mLabel = (nx_ch_label_t *)(
            payload + sizeof(nx_ch_phdv_heartbeat_msg_hdr_t));
        mLabelLength = call SubMsgLabel.getLen(mLabel);

        // Check if the message length is ok.
        if (mLabelLength == 0 || mLabelLength > CH_MAX_LABEL_LENGTH) {
            dbgerror("CH|ERROR", \
                "The label length %hhu is outside the interval " \
                "[1..%hhu]! [%s]\n", mLabelLength, \
                CH_MAX_LABEL_LENGTH - 1, __FUNCTION__);
            return msg;
        }

        if (labelUpdatePresent) {
            // The message contains the update vector.

            // Check if the message size is ok.
            if (len != sizeof(nx_ch_phdv_heartbeat_msg_hdr_t) +
                    call SubMsgLabel.getByteLen(mLabelLength) +
                    call SubMsgUpdateVect.getByteLen(mLabelLength) +
                    numRTEntries * call SubMsgRTEntry.getByteSize()) {
                dbgerror("CH|ERROR", \
                    "The message length %hhu does match the expected " \
                    "message length %hhu! [%s]\n", len, \
                    sizeof(nx_ch_phdv_heartbeat_msg_hdr_t) + \
                    call SubMsgLabel.getByteLen(mLabelLength) + \
                    call SubMsgUpdateVect.getByteLen(mLabelLength) + \
                    numRTEntries * call SubMsgRTEntry.getByteSize(), \
                    __FUNCTION__);
                return msg;
            }

            // Get the update vector.
            mUpdateVect = (nx_vect_t *)(
                (uint8_t *)mLabel + call SubMsgLabel.getByteLen(mLabelLength));

            // Check if the length of the update vector is ok.
            if (call SubMsgUpdateVect.getLen(mUpdateVect) != mLabelLength) {
                dbgerror("CH|ERROR", \
                    "The length of the label %hhu does match the length " \
                    "of the update vector %hhu! [%s]\n", mLabelLength, \
                    call SubMsgUpdateVect.getLen(mUpdateVect), \
                    __FUNCTION__);
                return msg;
            }

            // Get the routing table.
            mRT = (nx_ch_phdv_msg_rt_entry_t *)(
                (uint8_t *)mUpdateVect +
                call SubMsgUpdateVect.getByteLen(mLabelLength));

            minCommonLevel =
                labAdoptUpdates(mLabel, mUpdateVect, mLabelLength);

        } else {
            // The label update is not present in the message.

            // Check if the message size is ok.
            if (len != sizeof(nx_ch_phdv_heartbeat_msg_hdr_t) +
                    call SubMsgLabel.getByteLen(mLabelLength) +
                    numRTEntries * call SubMsgRTEntry.getByteSize()) {
                dbgerror("CH|ERROR", \
                    "The message length %hhu does match the expected " \
                    "message length %hhu! [%s]\n", len, \
                    sizeof(nx_ch_phdv_heartbeat_msg_hdr_t) + \
                    call SubMsgLabel.getByteLen(mLabelLength) + \
                    numRTEntries * call SubMsgRTEntry.getByteSize(), \
                    __FUNCTION__);
                return msg;
            }

            mUpdateVect = NULL;

            mRT = (nx_ch_phdv_msg_rt_entry_t *)(
                (uint8_t *)mLabel + call SubMsgLabel.getByteLen(mLabelLength));

            for (minCommonLevel = 0,
                    labelUpdatePresent =
                        call CHState.getLabelLength() < mLabelLength ?
                            call CHState.getLabelLength() : mLabelLength;
                    minCommonLevel < labelUpdatePresent;
                    ++minCommonLevel) {
                if (call CHState.getLabelElement(minCommonLevel) ==
                        call SubMsgLabel.getEl(mLabel, minCommonLevel)) {
                    break;
                }
            }

            if (minCommonLevel >= labelUpdatePresent) {
                minCommonLevel = CH_MAX_LABEL_LENGTH;
            }

        }

        rtUpdateRoutes(
            neighbor, mRT, mLabel, numRTEntries, minCommonLevel, mLabelLength);

        return msg;
    }



    inline void rtUpdateRoutes(
            neighbor_t * neighbor,
            nx_ch_phdv_msg_rt_entry_t * mRT,
            nx_ch_label_t * mLabel,
            uint8_t mRTLength,
            uint8_t minCommonLevel,
            uint8_t mLabelLength) {
        am_addr_t    neighborAddress;
        bool         createFlag;
        uint8_t      i;

        dbg("CH|2", \
            "  - Refreshing the routing table of a node with %hhu " \
            "entries received in the heartbeat message.\n", mRTLength);

        dbgLocalRoutingTable();

        neighborAddress = neighbor->llAddress;
        createFlag =
            call NeighborTable.getBiDirLinkQuality(neighbor) >=
                call Config.getWhiteLQThreshold();

        // Simply refresh all routing table entries.
        for (i = 0; i < mRTLength; ++i) {
            uint16_t head =
                call SubMsgRTEntry.getHead(&(mRT[i]));
            uint8_t  level =
                call SubMsgRTEntry.getLevel(&(mRT[i]));
            bool adjacent =
                level >= minCommonLevel &&
                    call SubMsgRTEntry.getAdjacencyFlag(&(mRT[i]));
            if (level < mLabelLength) {
                adjacent = adjacent ||
                    head == call SubMsgLabel.getEl(mLabel, level);
            }
            rtRefreshEntry(
                head,
                level,
                call SubMsgRTEntry.getNumHops(&(mRT[i])),
                call CHClustering.getMaxPropagationRadius(
                    level, call Config.getMaxPathLength()),
                call SubMsgRTEntry.getSeqNo(&(mRT[i])),
                neighborAddress,
                adjacent,
                createFlag);
        }

        dbg("CH|2", \
            "  - The routing table has been refreshed.\n");

        dbgLocalRoutingTable();
    }



    void rtRefreshEntry(
            uint16_t head,
            uint8_t level,
            uint8_t numHops,
            uint8_t radius,
            ch_rt_entry_seq_no_t seqNo,
            am_addr_t nextHop,
            bool adjacent,
            bool create) {

        ch_rt_entry_t *       pentry;

        dbg("CH|3", \
            "    * Refreshing %hu routing table entry at level %hhu with " \
            "%hhu hops, %hhu-hop radius, seq. no. %u, " \
            "next hop %hu, the adjacency flag %s, and the create flag %s.\n", \
            head, level, numHops, radius, (unsigned int)seqNo, nextHop, \
            adjacent ? "set" : "NOT set", create ? "set" : "NOT set");

        // Check the number of hops.
        if (numHops >= radius && numHops != NO_ROUTE_NUM_HOPS &&
                level < CH_MAX_LABEL_LENGTH - 1) {
            dbg("CH|3", \
                "    * Dropping the entry as its hop count has expired.\n");
            return;
        }

        // Check the level.
        if (level == 0 || level >= CH_MAX_LABEL_LENGTH) {
            dbgerror("CH|ERROR", \
                "Invalid level %hhu of a routing table entry! " \
                "Accepted values: 1..%hhu. [%s]\n", \
                level, CH_MAX_LABEL_LENGTH - 1, __FUNCTION__);
            return;
        }

        // Check the head.
        if (head == CH_INVALID_CLUSTER_HEAD) {
            dbgerror("CH|ERROR", \
                "Invalid cluster head identifier! [%s]\n", __FUNCTION__);
            return;
        }

        // The entry is ok, so look it up in the routing table.
        pentry = rtLookupEntryAtAnyLevel(head);

        if (pentry == NULL) {

            dbg("CH|3", \
                "    * The entry does not exist in the routing table.\n");

            if (create && numHops != NO_ROUTE_NUM_HOPS) {
                // The create flag is set and this is not
                // no-route information, so create an entry.
                pentry = call CHState.putRTEntry(level, head);
                if (pentry != NULL) {
                    uint8_t i;

                    // Fill in the entry data.
                    // The 'level' and 'head' fields are filled in
                    // by the call CHState.putRTEntry() call.
                    pentry->numHops = numHops + 1;
                    pentry->maintenance.phdv.seqNo = seqNo;
                    pentry->maintenance.phdv.radius = radius;
                    pentry->maintenance.phdv.ttl = radius +
                        RT_ENTRY_TTL_TOLERANCE;
                    pentry->maintenance.phdv.adjacent = adjacent;

                    // Fill in the sole next-hop candidate.
                    pentry->nextHops[0].addr = nextHop;
                    pentry->nextHops[0].maintenance.phdv.ttl =
                        RT_ENTRY_NEXT_HOP_TTL_TOLERANCE;
                    pentry->nextHops[0].maintenance.phdv.adjacent =
                        adjacent;
                    for (i = 1; i < CH_MAX_RT_ENTRY_NEXT_HOP_CANDIDATES; ++i) {
                        pentry->nextHops[i].addr = AM_BROADCAST_ADDR;
                    }

                    dbg("CH|3", \
                        "    * The new entry was created.\n");

                } else {
                    dbgerror("CH|ERROR", \
                        "Out of memory! Unable to create a routing " \
                        "table entry! [%s]\n", __FUNCTION__);
                }

            } else {
                dbg("CH|3", \
                    "    * The new entry could not be created as the " \
                    "CREATE flag was not set or the entry was " \
                    "poissoned.\n");
            }

        } else {
            bool fresher;

            dbg("CH|3", \
                "    * The entry exists in the routing table at level " \
                "%hhu with %hhu hops, %hhu-hop radius, seq. no. %u, and " \
                "ttl of %hhu.\n", pentry->level, pentry->numHops, \
                pentry->maintenance.phdv.radius, \
                (unsigned int)pentry->maintenance.phdv.seqNo, \
                pentry->maintenance.phdv.ttl);

            fresher =
                !rtEntrySeqNoIsOlderOrEqual(
                    seqNo, pentry->maintenance.phdv.seqNo);

            // Check if the new entry is fresher than the old entry.
            if (fresher) {

                dbg("CH|3", \
                    "    * The new entry has a fresher sequence number.\n");

                // If necessary, change the level of the routing entry.
                if (level != pentry->level) {

                    dbg("CH|3", \
                        "    * Repositioning the entry from level %hhu " \
                        "to level %hhu.\n", pentry->level, level);

                    pentry = call CHState.changeRTEntryLevel(pentry, level);
                }

                // Update the entry data.
                pentry->maintenance.phdv.seqNo = seqNo;
                pentry->maintenance.phdv.radius = radius;
                pentry->maintenance.phdv.ttl = radius +
                    RT_ENTRY_TTL_TOLERANCE;

                dbg("CH|3", \
                    "    * Updated the seq. no. of the entry.\n");
            }

            // Refresh the next hop candidate of the entry.
            rtRefreshEntryNextHop(
                pentry, nextHop, numHops, adjacent, create, fresher);
        }
    }



    inline void rtRefreshEntryNextHop(
            ch_rt_entry_t * pentry, am_addr_t nextHop, uint8_t numHops,
            bool adjacent, bool create, bool fresher) {

        if (numHops == NO_ROUTE_NUM_HOPS) {
            // The message entry represents no-route information.
            // If we have the same route through the 'nextHop'
            // neighbor we have to remove the route.
            dbg("CH|3", \
                "    * The received entry represents NO_ROUTE information.\n");

            if (pentry->numHops != NO_ROUTE_NUM_HOPS) {
                // We do have some routes, so look if the
                // 'nextHop' is one of our next hop candidates.
                uint8_t  i;
                bool     noRoute;

                noRoute = TRUE;
                for (i = 0; i < CH_MAX_RT_ENTRY_NEXT_HOP_CANDIDATES; ++i) {
                    if (pentry->nextHops[i].addr == nextHop) {
                        pentry->nextHops[i].addr = AM_BROADCAST_ADDR;
                        dbg("CH|3", \
                            "    * The neighbor was our next hop, " \
                            "so we removed a route via the neighbor.\n");
                    } else if (pentry->nextHops[i].addr != AM_BROADCAST_ADDR) {
                        noRoute = FALSE;
                    }
                }

                if (noRoute) {
                    // The neighbor was the only next hop on our route
                    // so now we have no other route.
                    pentry->numHops = NO_ROUTE_NUM_HOPS;
                    pentry->maintenance.phdv.ttl +=
                        RT_ENTRY_NO_ROUTE_TTL_BONUS;

                    dbg("CH|3", \
                        "    * We no longer have a route to cluster %hu " \
                        "at level %hhu.\n", pentry->head, pentry->level);
                } else {
                    dbg("CH|3", \
                        "    * We do have alternative routes however.\n");
                }

            } else {
                dbg("CH|3", \
                    "    * We do not have a route to %hu at level %hhu " \
                    "anyway, so nothing happens.\n", pentry->head, \
                    pentry->level);
            }

        } else {
            // The message entry contains valid route information.
            // Depending on our state, we have to update the route.
            dbg("CH|3", \
                "    * The received entry represents a valid route.\n");

            // Account for the hop taken.
            ++numHops;

            if (pentry->numHops == NO_ROUTE_NUM_HOPS) {
                // We do not have a route to the specified entry
                // so check what we can do.
                if (create && fresher) {
                    // We can create the new route as the
                    // received entry is of both high quality
                    // and a fresher sequence number.
                    pentry->numHops = numHops;
                    pentry->nextHops[0].addr = nextHop;
                    pentry->nextHops[0].maintenance.phdv.ttl =
                        RT_ENTRY_NEXT_HOP_TTL_TOLERANCE;
                    pentry->nextHops[0].maintenance.phdv.adjacent =
                        adjacent;
                    // NOTICE: this below is not necessary.
                    // for (i = 1; i < CH_MAX_RT_ENTRY_NEXT_HOP_CANDIDATES; ++i) {
                    //     pentry->nextHops[i].addr = AM_BROADCAST_ADDR;
                    // }

                    dbg("CH|3", \
                        "    * The entry replaced NO_ROUTE information.\n");

                } else {
                    dbg("CH|3", \
                        "    * The entry could not replace NO_ROUTE " \
                        "information as it was of poor link quality or " \
                        "did not contain a fresher sequence number.\n");
                }

            } else if (pentry->numHops > numHops  &&
                    (adjacent || !pentry->maintenance.phdv.adjacent)) {
                // Our current entry corresponds to a worse-quality
                // route, so check if we can adopt the new route.
                if (create) {
                    // We can replace the route.
                    uint8_t i;

                    dbg("CH|3", \
                        "    * Improved the route from %hhu to " \
                        "%hhu hops.\n", pentry->numHops, numHops);

                    pentry->numHops = numHops;
                    pentry->nextHops[0].addr = nextHop;
                    pentry->nextHops[0].maintenance.phdv.ttl =
                        RT_ENTRY_NEXT_HOP_TTL_TOLERANCE;
                    pentry->nextHops[0].maintenance.phdv.adjacent =
                        adjacent;
                    for (i = 1; i < CH_MAX_RT_ENTRY_NEXT_HOP_CANDIDATES; ++i) {
                        pentry->nextHops[i].addr = AM_BROADCAST_ADDR;
                    }

                } else {
                    dbg("CH|3", \
                        "    * Could not improve the route from %hhu to " \
                        "%hhu hops, as the received entry was of poor " \
                        "link quality.\n", pentry->numHops, numHops);
                }

            } else {
                // The received entry if of the same or worse
                // link quality than the existing entry, but
                // we still have to look up the next hop
                // candidate in our list.
                uint8_t i;

                for (i = 0; i < CH_MAX_RT_ENTRY_NEXT_HOP_CANDIDATES; ++i) {
                    if (pentry->nextHops[i].addr == nextHop) {
                        break;
                    }
                }

                if (i < CH_MAX_RT_ENTRY_NEXT_HOP_CANDIDATES) {
                    // The candidate is present in our list, so
                    // check if we refresh it, or we remove it.
                    if (pentry->numHops >= numHops) {
                        // The route length of the candidate is the same,
                        // so we refresh it.
                        pentry->nextHops[i].maintenance.phdv.ttl =
                            RT_ENTRY_NEXT_HOP_TTL_TOLERANCE;
                        pentry->nextHops[i].maintenance.phdv.adjacent =
                            adjacent;

                        dbg("CH|3", \
                            "    * The next-hop candidate was " \
                            "refreshed.\n");
                    } else {
                        // The route length of the candidate is longer
                        // than it was before, so we remove the candidate
                        // or degrade our route if this is the only
                        // candidate.
                        uint8_t j;

                        for (j = 0; j < CH_MAX_RT_ENTRY_NEXT_HOP_CANDIDATES; ++j) {
                            if (pentry->nextHops[j].addr != nextHop &&
                                    pentry->nextHops[j].addr !=
                                        AM_BROADCAST_ADDR) {
                                break;
                            }
                        }

                        if (j < CH_MAX_RT_ENTRY_NEXT_HOP_CANDIDATES) {
                            // This is not the only candidate, so
                            // remove it.
                            pentry->nextHops[i].addr = AM_BROADCAST_ADDR;

                            dbg("CH|3", \
                                "    * Removed the route via the neighbor " \
                                "due to excessive length, but there " \
                                "still are routes left.\n");
                        } else {
                            // This is the only candidate, so degrade the
                            // route length.
                            dbg("CH|3", \
                                "    * Degraded the route from %hhu to " \
                                "%hhu hops.\n", pentry->numHops, numHops);

                            pentry->numHops = numHops;
                            pentry->nextHops[i].maintenance.phdv.ttl =
                                RT_ENTRY_NEXT_HOP_TTL_TOLERANCE;
                            pentry->nextHops[i].maintenance.phdv.adjacent =
                                adjacent;
                        }
                    }

                } else {
                    // The candidate is not present in our list,
                    // but if the entry quality is not worse
                    // we can use the candidate as an alternative
                    // next hop.
                    if (pentry->numHops >= numHops) {
                        for (i = 0; i < CH_MAX_RT_ENTRY_NEXT_HOP_CANDIDATES; ++i) {
                            if (pentry->nextHops[i].addr ==
                                    AM_BROADCAST_ADDR) {
                                break;
                            }
                        }
                        if (i < CH_MAX_RT_ENTRY_NEXT_HOP_CANDIDATES) {
                            // There is some empty slot, so we can
                            // use it for the candidate.
                            pentry->nextHops[i].addr = nextHop;
                            pentry->nextHops[i].maintenance.phdv.ttl =
                                RT_ENTRY_NEXT_HOP_TTL_TOLERANCE;
                            pentry->nextHops[i].maintenance.phdv.adjacent =
                                adjacent;

                            dbg("CH|3", \
                                "    * The received entry was used as an " \
                                "alternative next-hop candidate.\n");
                        } else {
                            // There is no free slot.
                            dbg("CH|3", \
                                "    * Although the received entry was of " \
                                "the same quality as our route, it was " \
                                "dropped due to lack of route space.\n");
                        }
                    } else {
                        // The entry quality was worse, so we drop
                        // the candidate.
                        dbg("CH|3", \
                            "    * The received entry was dropped due " \
                            "to being of worse quality than our route.\n");
                    }
                }

            }
        }

        // Update the adjacency flag.
        {
            uint8_t  k;

            for (k = 0; k < CH_MAX_RT_ENTRY_NEXT_HOP_CANDIDATES; ++k) {
                if (pentry->nextHops[k].addr != AM_BROADCAST_ADDR &&
                        pentry->nextHops[k].maintenance.phdv.adjacent) {
                    break;
                }
            }

            pentry->maintenance.phdv.adjacent =
                k < CH_MAX_RT_ENTRY_NEXT_HOP_CANDIDATES;
        }
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
                if (pcurr->numHops <= joinRadius &&
                        pcurr->numHops != NO_ROUTE_NUM_HOPS &&
                        pcurr->maintenance.phdv.adjacent) {
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



    inline uint8_t rtGetMaxDistanceAtLevel(uint8_t level) {
        ch_rt_entry_t *  pcurr;
        uint8_t          res;

        if (level == 0) {
            return call CHClustering.getMaxPropagationRadius(
                level, call Config.getMaxPathLength());
        }

        res = 0;
        for (pcurr = call CHState.getFirstRTEntryAtLevel(level);
                pcurr != NULL;
                pcurr = call CHState.getNextRTEntryAtLevel(pcurr)) {
            if (pcurr->head != call CHState.getLabelElement(0) &&
                    pcurr->numHops != NO_ROUTE_NUM_HOPS &&
                    res < pcurr->numHops) {
                res = pcurr->numHops;
            }
        }

        if (res != 0) {
            return res;
        }

        // NOTICE: Can we try a zero here?
        res =
            call CHClustering.getMaxPropagationRadius(
                level, call Config.getMaxPathLength());

        return res;
    }



    void rtAgeAndClean() {
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

                // Age the next-hop candidates of an entry.
                if (pcurr->numHops != NO_ROUTE_NUM_HOPS) {
                    uint8_t   j;
                    bool      noCandidate;
                    bool      adjacent;

                    noCandidate = TRUE;
                    adjacent = FALSE;
                    for (j = 0; j < CH_MAX_RT_ENTRY_NEXT_HOP_CANDIDATES; ++j) {
                        if (pcurr->nextHops[j].addr != AM_BROADCAST_ADDR) {
                            --pcurr->nextHops[j].maintenance.phdv.ttl;
                            if (pcurr->nextHops[j].maintenance.phdv.ttl == 0) {
                                // The TTL of a next-hop candidate expired,
                                // so remove the candidate.
                                pcurr->nextHops[j].addr = AM_BROADCAST_ADDR;
                            } else {
                                noCandidate = FALSE;
                                if (pcurr->nextHops[j].maintenance.phdv.adjacent) {
                                    adjacent = TRUE;
                                }
                            }
                        }
                    }

                    pcurr->maintenance.phdv.adjacent = adjacent;

                    if (noCandidate) {
                        // There is no route for an entry.
                        pcurr->numHops = NO_ROUTE_NUM_HOPS;
                        pcurr->maintenance.phdv.ttl += RT_ENTRY_NO_ROUTE_TTL_BONUS;
                        dbg("CH|3", \
                            "    * Entry for %hu at level %hhu has no " \
                            "more next-hop candidates.\n", pcurr->head, \
                            pcurr->level);
                    }
                }

                // Age the entry itself.
                --pcurr->maintenance.phdv.ttl;

                if (pcurr->maintenance.phdv.ttl == 0) {
                    // The entry has timed out.
                    dbg("CH|3", \
                        "    * Removing an entry for %hu at level %hhu.\n", \
                        pcurr->head, pcurr->level);

                    if (pcurr->numHops != NO_ROUTE_NUM_HOPS) {
                        dbg("CH|3", \
                            "    * STRANGE: The entry did not have the " \
                            "NO_ROUTE flag set?\n");
                    }

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



    void rtRefreshMyRoutingEntry() {
        uint8_t           headLevel;

        headLevel = call CHState.getLevelAsHead();

        if (headLevel > 0) {
            ch_rt_entry_t *  pentry;

            pentry =
                rtLookupEntryAtAnyLevel(
                    call CHState.getLabelElement(0));

            if (pentry == NULL) {
                dbg("CH|2", \
                    "  - Creating my routing entry at level %hhu.\n",
                    headLevel);

                pentry =
                    call CHState.putRTEntry(
                        headLevel, call CHState.getLabelElement(0));

            } else if (pentry->level != headLevel) {
                dbg("CH|2", \
                    "  - Refreshing and repositioning my routing entry " \
                    "from level %hhu to level %hhu.\n", \
                    pentry->level, headLevel);

                pentry =
                    call CHState.changeRTEntryLevel(
                        pentry, headLevel);
            } else {
                dbg("CH|2", \
                    "  - Refreshing my routing entry.\n");

            }

            // Fill in the entry data.
            if (pentry != NULL) {
                uint8_t   advertRadius;
                uint8_t   i;

                // Get the propagation radius of the entry.
                advertRadius =
                    call CHClustering.getMaxPropagationRadius(
                        headLevel, call Config.getMaxPathLength());
                if (headLevel == CH_MAX_LABEL_LENGTH - 1) {
                    // We are the top level head, so do not
                    // bound the propagation radius.
                    advertRadius = call Config.getMaxPathLength();
                } else if (headLevel + 1 < call CHState.getLabelLength()) {
                    // Check if our superhead is more hops
                    // away than we expect it to be.
                    ch_rt_entry_t const *   pSuperHead =
                        rtLookupEntryAtAnyHigherLevel(
                            headLevel + 1,
                            call CHState.getLabelElement(headLevel + 1));

#ifdef TOSSIM
#ifndef TOSSIM_NO_DEBUG
                    // Sanity check: the conditions should be enforced
                    // by the hierarchy maintenance routines.
                    if (pSuperHead == NULL) {
                        dbgerror("CH|ERROR", \
                            "Internal error: Superhead is NULL! [%s]\n", \
                            __FUNCTION__);
                        return;
                    }
                    if (pSuperHead->numHops == NO_ROUTE_NUM_HOPS) {
                        dbgerror("CH|ERROR", \
                            "Internal error: Superhead is unreachable! [%s]\n", \
                            __FUNCTION__);
                        return;
                    }
#endif
#endif
                    if (pSuperHead->numHops > advertRadius) {
                        advertRadius = pSuperHead->numHops;
                    }
                }

                // Fill in the entry data.
                // The 'level' and 'head' fields are filled in
                // by the call CHState.putRTEntry() call.
                pentry->numHops = 0;
                pentry->maintenance.phdv.seqNo = ++advertSeqNo;
                pentry->maintenance.phdv.radius = advertRadius;
                pentry->maintenance.phdv.ttl = RT_ENTRY_TTL_TOLERANCE;
                pentry->maintenance.phdv.adjacent = TRUE;
                // Fill in the sole next-hop candidate.
                pentry->nextHops[0].addr =
                    call HeartbeatAMPacket.address();
                pentry->nextHops[0].maintenance.phdv.ttl =
                    RT_ENTRY_NEXT_HOP_TTL_TOLERANCE;
                for (i = 1; i < CH_MAX_RT_ENTRY_NEXT_HOP_CANDIDATES; ++i) {
                    pentry->nextHops[i].addr = AM_BROADCAST_ADDR;
                }

            } else {
                dbgerror("CH|ERROR", \
                    "Out of memory! Unable to create a routing " \
                    "table entry! [%s]\n", __FUNCTION__);
            }

        } // if we are level->0 cluster head

    }



    void repairHierarchyErrors() {
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
                dbg("CH|3", \
                    "    * The super head does not exist. " \
                    "Performing label cut.\n");

                labCut(headLevel + 1);

            } else if (pSuperHead->numHops == NO_ROUTE_NUM_HOPS ||
                    !pSuperHead->maintenance.phdv.adjacent) {
                // The super head is not reachable,
                // so we have to cut the label.
                dbg("CH|3", \
                    "    * The super head is not reachable. " \
                    "Performing label cut.\n");

                labCut(headLevel + 1);

            // NOTICE: We do not detect this condition, as
            //         we relaxed the routing table properties
            //         when issuing an advert (looking up the
            //         radius of a superhead).
            } else if (pSuperHead->numHops >
                    call CHClustering.getMaxJoinRadius(
                        headLevel + 1, call Config.getMaxPathLength())) {

                dbg("CH|3", \
                    "    * The super head is too far (%hhu hops " \
                    "whereas only %hhu hops is allowed). " \
                    "Performing label cut.\n", pSuperHead->numHops, \
                    call CHClustering.getMaxJoinRadius( \
                        headLevel + 1, call Config.getMaxPathLength()));

                labCut(headLevel + 1);

            } else {
                // We have found the super head,
                // so everything is ok.

                if (pSuperHead->level >= call CHState.getLabelLength()) {
                    // The update from our super head has not reached us,
                    // but we know how to fill out the label.
                    uint8_t i, j;

#ifdef TOSSIM
#ifndef TOSSIM_NO_DEBUG
                    if (pSuperHead->head !=
                            call CHState.getLabelElement(
                                call CHState.getLabelLength() - 1)) {
                        dbgerror("CH|ERROR", \
                            "Node label is corrupted! [%s]\n", \
                            __FUNCTION__);
                    }
#endif
#endif

                    j = call CHState.getLabelLength() - 1;
                    call CHState.setLabelLength(pSuperHead->level + 1);
                    for (i = j + 1; i < call CHState.getLabelLength(); ++i) {
                        call CHState.setLabelElement(i, pSuperHead->head);
                        labUpdateVect[i] = labUpdateVect[j];
                    }

#ifdef TOSSIM
#ifndef TOSSIM_NO_DEBUG
                    if (labUpdateVect[j] != 0) {
                        dbgerror("CH|ERROR", \
                            "Node update vector is corrupted! [%s]\n", \
                            __FUNCTION__);
                    }
#endif
#endif

                    ++labUpdateVect[j];

                    dbg("CH|3", \
                        "    * Augmented the label with %hu from level " \
                        "%hhu to level %hhu.\n", pSuperHead->head, j + 1, \
                        call CHState.getLabelLength() - 1);
                }

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



    void repairHierarchyIncompleteness() {
        uint8_t           headLevel;

        // Get the level of a node as the head.
        headLevel = call CHState.getLevelAsHead();

        dbg("CH|2", \
            "  - Checking for hierarchy incompleteness " \
            "(my level as head: %hhu; label length: %hhu).\n", \
            headLevel, call CHState.getLabelLength());

        dbgLocalLabel();


        if (checkForPossiblePromotion(headLevel)) {
            // We are the top level head, so we may
            // have to perform a label extension.
            ch_rt_entry_t * pJoinCandidate;

            pJoinCandidate = rtGetJoinCandidate(headLevel);

            if (pJoinCandidate != NULL && headLevel > 0) {
                // We are level->0 head, so as soon as we have
                // a join candidate, we try to join it.
                dbg("CH|3", \
                    "    * A join candidate %hu within %hhu hops found. " \
                    "Performing label extension.\n", \
                    pJoinCandidate->head, pJoinCandidate->numHops);

                labExtCnt = INVAL_CNT_VAL;

                labExtend(pJoinCandidate->head);

            } else if (labExtCnt == INVAL_CNT_VAL) {
                // Our suppression counter is inactive, so
                // we have to start it.
                uint8_t    radius;
                uint8_t    slot;

                dbg("CH|3", \
                    "    * Incompleteness detected.\n");

                radius = rtGetMaxDistanceAtLevel(headLevel);

                dbg("CH|3", \
                    "    * Initiating promotion to level %hhu " \
                    "(advert radius: %hhu).\n", headLevel + 1, radius);

                slot =
                    call CHClustering.generatePromotionSlotNo(
                        headLevel,
                        call NeighborTable.getNumNeighbors());

                dbg("CH|3", \
                    "    * Drawn a random slot %hhu.\n", slot);

                labExtCnt = (uint16_t)slot * (uint16_t)radius;
                if (headLevel == 0) {
                    labExtCnt += ADDITIONAL_ROUNDS_FOR_FIRST_PROMOTION;
                }

                dbg("CH|3", \
                    "    * Set promotion counter to %hu.\n", labExtCnt);

            } else if (labExtCnt == 0) {
                // Our suppression counter just fired,
                // so we have to extend the label or
                // join some cluster.
                labExtCnt = INVAL_CNT_VAL;

                dbg("CH|3", \
                    "    * The counter to defer spawning a supergroup " \
                    "just fired.\n");

                if (pJoinCandidate != NULL) {
                    // This can happen when we are a level-0 head.
                    dbg("CH|3", \
                        "    * A join candidate %hu within %hhu hops found. " \
                        "Performing label extension.\n", \
                        pJoinCandidate->head, pJoinCandidate->numHops);

                    labExtend(pJoinCandidate->head);

                } else if (call CHClustering.canBecomeClusterHead(headLevel + 1)) {

                    dbg("CH|3", \
                        "    * A join candidate not found. Promoting myself.\n");

                    labExtend(call CHState.getLabelElement(0));

                } else {
                    dbg("CH|3", \
                        "    * A join candidate not found. Not allowed to " \
                        "promote myself. Doing nothing.\n");
                }

            } else {
                // Our suppression counter is ticking, so
                // the only thing to do is decrementing it.
                --labExtCnt;

                dbg("CH|3", \
                    "    * The counter to defer spawning a supergroup " \
                    "decreased to %hu.\n", labExtCnt);
            }

        } else {
            // We are not the top level head, so nothing has to
            // be done.
            labExtCnt = INVAL_CNT_VAL;
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
                if (pentry->head != call CHState.getLabelElement(0) &&
                        pentry->numHops != NO_ROUTE_NUM_HOPS) {
                    return TRUE;
                }
            } // for each entry in the row
        } // for each row

        return FALSE;

    }
}
