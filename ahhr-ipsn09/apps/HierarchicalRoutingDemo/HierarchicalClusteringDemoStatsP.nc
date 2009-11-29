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
#include "HierarchicalClusteringDemoStats.h"


/**
 * An implementation of statistic reporting over the serial port
 * for the application demonstrating hierarchical clustering.
 *
 * @author Konrad Iwanicki &lt;iwanicki@few.vu.nl&gt;
 */
module HierarchicalClusteringDemoStatsP {
    provides {
        interface SerialStatsReporting;
    }
    uses {
        interface AMSend as SerialTrafficStatsSend;
        interface AMSend as SerialLEStatsSend;
        interface AMSend as SerialCHStatsSend;
        interface Packet as SerialPacket;

        interface NeighborTable;
        interface Iterator<neighbor_iter_t, neighbor_t>
            as NeighborTableIter;

        interface ClusterHierarchy;
        interface NxVector<am_addr_t> as CHMsgLabel;

        interface TOSSIMStats as LETossimStats;
        interface TOSSIMStats as CHTossimStats;
        interface Statistics<traffic_stats_outgoing_stats_t> as
            ProtocolOnlyOutgoingTrafficStats;
        interface Statistics<traffic_stats_incoming_stats_t> as
            ProtocolOnlyIncomingTrafficStats;
        interface Statistics<traffic_stats_outgoing_stats_t> as
            WholeStackOutgoingTrafficStats;
        interface Statistics<traffic_stats_incoming_stats_t> as
            WholeStackIncomingTrafficStats;
    }
}
implementation {
    // ------------------------- Private members -------------------------
    /** the message buffer for sending the messages over the serial interface */
    message_t           serialMessage;

    /** a variable indicating that reporting is active */
    bool                statsReportingActive = FALSE;

    /** the number of statistic message cycles */
    uint32_t            numStatsReports = 0;
    /** the index of the statistics message in the cycle */
    uint8_t             idxStatsReports;
    /** the neighbor table iterator used for statistics reporting */
    neighbor_iter_t     neighborTableIter;
    /** the next group level to be used for iteration */
    uint8_t             chLevelIter;
    /** the next group head to be used for iteration */
    uint16_t            chHeadIter;



    // Function and task prototypes.
    inline void reportTossimStats();
    task void taskSignalTossimCompletion();
    task void taskReportTrafficStats();
    task void taskReportLEStats();
    task void taskReportCHStats();



    // ----------------- Interface SerialStatsReporting ------------------
    command inline error_t SerialStatsReporting.startReporting() {
#ifdef TOSSIM
        // In TOSSIM, we simply report
        // everything immediately.
        reportTossimStats();
        post taskSignalTossimCompletion();
        return SUCCESS;
#else
        // On the motes, we use the serial
        // interface to report the stats.
        if (statsReportingActive) {
            return EBUSY;
        } else {
            statsReportingActive = TRUE;
            idxStatsReports = NX_CH_STATS_REPORT_HEADER_FLAG_LAST;
            post taskReportTrafficStats();
            return SUCCESS;
        }
#endif
    }



    default event inline void SerialStatsReporting.reportingDone(error_t err) {
        // Do nothing.
    }



    command inline bool SerialStatsReporting.isReporting() {
        return statsReportingActive;
    }



    // ---------------- Interface SerialTrafficStatsSend -----------------
    event void SerialTrafficStatsSend.sendDone(message_t * msg, error_t err) {
        dbg("App|1", \
            "The sendDone for traffic statistics serial message %x " \
            "was invoked. [%s]\n", msg, __FUNCTION__);

        if (msg == &serialMessage) {

            // Check if everything was ok.
            if (err != SUCCESS) {
                dbgerror("App|ERROR", \
                    "Error sending a serial message! " \
                    "Stopping statistic reporting! [%s]\n", __FUNCTION__);

                statsReportingActive = FALSE;
                signal SerialStatsReporting.reportingDone(err);

            } else {
                // Post the task to report more stats.
                if ((idxStatsReports &
                        NX_CH_STATS_REPORT_HEADER_FLAG_LAST) != 0) {
                    // The general statistics were finished,
                    // so starting reporting link estimator statistics.
                    post taskReportLEStats();
                } else {
                    // Continue reporting general statistics.
                    post taskReportTrafficStats();
                }
            }

        } else {
            dbgerror("App|ERROR", \
                "The sendDone message was invoked for some unknown " \
                "serial message %x instead of %x! [%s]\n", \
                msg, &serialMessage, __FUNCTION__);
            // Do not schedule anything.
        }

    }



    // ------------------ Interface SerialLEStatsSend --------------------
    event void SerialLEStatsSend.sendDone(message_t * msg, error_t err) {
        dbg("App|1", \
            "The sendDone for link estimator statistics serial " \
            "message %x was invoked. [%s]\n", msg, __FUNCTION__);

        if (msg == &serialMessage) {

            // Check if everything was ok.
            if (err != SUCCESS) {
                dbgerror("App|ERROR", \
                    "Error sending a serial message! " \
                    "Ignoring... [%s]\n", __FUNCTION__);

                statsReportingActive = FALSE;
                signal SerialStatsReporting.reportingDone(err);

            } else {
                // Post the task to report more stats.
                if ((idxStatsReports &
                        NX_CH_STATS_REPORT_HEADER_FLAG_LAST) != 0) {
                    // The link estimator statistics were finished,
                    // so starting reporting cluster hierarchy statistics.
                    post taskReportCHStats();
                } else {
                    // Continue reporting link estimator statistics.
                    post taskReportLEStats();
                }
            }

        } else {
            dbgerror("App|ERROR", \
                "The sendDone message was invoked for some unknown " \
                "serial message %x instead of %x! [%s]\n", \
                msg, &serialMessage, __FUNCTION__);
            // Do not schedule anything.
        }

    }



    // ---------------- Interface SerialCHStatsSend ----------------
    event void SerialCHStatsSend.sendDone(message_t * msg, error_t err) {
        dbg("App", \
            "The sendDone for cluster hierarchy statistics serial " \
            "message %x was invoked.\n", msg);

        if (msg == &serialMessage) {

            // Check if everything was ok.
            if (err != SUCCESS) {
                dbgerror("App", "Error sending a serial message! " \
                    "Ignoring...\n");

                statsReportingActive = FALSE;
                signal SerialStatsReporting.reportingDone(err);

            } else {
                // Post the task to report more stats.
                if ((idxStatsReports &
                        NX_CH_STATS_REPORT_HEADER_FLAG_LAST) != 0) {
                    // The cluster hierarchy statistics were finished,
                    // so indicate that statistic reporting was finished.
                    statsReportingActive = FALSE;
                    signal SerialStatsReporting.reportingDone(SUCCESS);
                } else {
                    // Continue reporting cluster hierarchy statistics.
                    post taskReportCHStats();
                }
            }

        } else {
            dbgerror("App", "The sendDone message was invoked " \
                "for some unknown serial message %x instead of %x!\n", \
                msg, &serialMessage);
            // Do not schedule anything.
        }

    }



    // ------------------- Interface NeighborTable -----------------------
    event inline void NeighborTable.neighborEvicted(am_addr_t llAddress) {
        // Do nothing.
    }



    // ------------------- Interface ClusterHierarchy -----------------------
    event inline void ClusterHierarchy.labelChanged(uint8_t level) {
        // Do nothing.
    }



    // ------------------------ Tasks and functions ----------------------
    /**
     * Reports TOSSIM stats.
     */
    inline void reportTossimStats() {
#ifdef TOSSIM
        traffic_stats_outgoing_stats_t const * outTrafficStats;
        traffic_stats_incoming_stats_t const * inTrafficStats;

        // Report link estimator statistics.
        call LETossimStats.report();
        // Report cluster hierarchy statistics.
        call CHTossimStats.report();

        // Report the incoming and outgoing traffic of PL-Gossip.
        outTrafficStats = call ProtocolOnlyOutgoingTrafficStats.getStats();
        inTrafficStats = call ProtocolOnlyIncomingTrafficStats.getStats();
        sim_ki_traffic_report_TX_traffic(
            TOS_NODE_ID, CONF_SIM_STATS_TRAFFIC_LAYER_PROTOCOL_ONLY,
            outTrafficStats->schedMessages, outTrafficStats->schedBytes);
        sim_ki_traffic_report_RX_traffic(
            TOS_NODE_ID, CONF_SIM_STATS_TRAFFIC_LAYER_PROTOCOL_ONLY,
            inTrafficStats->rxedMessages, inTrafficStats->rxedBytes);
        call ProtocolOnlyOutgoingTrafficStats.clearStats();
        call ProtocolOnlyIncomingTrafficStats.clearStats();

        // Report the incoming and outgoing traffic
        // of the whole beaconing stack.
        outTrafficStats = call WholeStackOutgoingTrafficStats.getStats();
        inTrafficStats = call WholeStackIncomingTrafficStats.getStats();
        sim_ki_traffic_report_TX_traffic(
            TOS_NODE_ID, CONF_SIM_STATS_TRAFFIC_LAYER_WHOLE_STACK,
            outTrafficStats->schedMessages, outTrafficStats->schedBytes);
        sim_ki_traffic_report_RX_traffic(
            TOS_NODE_ID, CONF_SIM_STATS_TRAFFIC_LAYER_WHOLE_STACK,
            inTrafficStats->rxedMessages, inTrafficStats->rxedBytes);
        call WholeStackOutgoingTrafficStats.clearStats();
        call WholeStackIncomingTrafficStats.clearStats();
#endif
    }



    /**
     * Signals completion of the TOSSIM reporting.
     */
    task void taskSignalTossimCompletion() {
        signal SerialStatsReporting.reportingDone(SUCCESS);
    }



    /**
     * Reports the general statistics data over the serial port.
     */
    task void taskReportTrafficStats() {
        message_t *                               msg;
        nx_ch_stats_report_traffic_msg_t *        payload;
        uint8_t                                   len, maxLen;
        traffic_stats_outgoing_stats_t const *    outTrafficStats;
        traffic_stats_incoming_stats_t const *    inTrafficStats;
        error_t                                   err;


        dbg("App|1", \
            "Reporting traffic statistics over the serial port. [%s]\n", \
            __FUNCTION__);

        msg = &serialMessage;

        // Clear the contents of the message and get the payload.
        call SerialPacket.clear(msg);

        maxLen = call SerialPacket.maxPayloadLength();
        len = sizeof(nx_ch_stats_report_traffic_msg_t);


        // Check if the statistics will fit.
        if (maxLen < len) {
            // The statistics will not fit in the message,
            // so terminate the repoting.
            dbgerror("App|ERROR", \
                "The maximal payload of a serial message (%hhu) " \
                "is smalled than the payload required for a traffic " \
                "statistics message (%hhu) [%s]!\n", maxLen, len, \
                __FUNCTION__);

            statsReportingActive = FALSE;
            signal SerialStatsReporting.reportingDone(ESIZE);

            return;
        }

        payload = (nx_ch_stats_report_traffic_msg_t *)
            call SerialPacket.getPayload(msg, NULL);


        // Start a new report, but mark that general
        // statistics consist only of one message.
        ++numStatsReports;
        idxStatsReports = 0 | NX_CH_STATS_REPORT_HEADER_FLAG_LAST;


        // Fill in the message.
        payload->statsHeader.reportNumber = numStatsReports - 1;
        payload->statsHeader.indexInSeriesAndFlags = idxStatsReports;

        outTrafficStats = call ProtocolOnlyOutgoingTrafficStats.getStats();
        inTrafficStats = call ProtocolOnlyIncomingTrafficStats.getStats();
        payload->txedMessagesCHOnly = outTrafficStats->schedMessages;
        payload->txedBytesCHOnly = outTrafficStats->schedBytes;
        payload->rxedMessagesCHOnly = inTrafficStats->rxedMessages;
        payload->rxedBytesCHOnly = inTrafficStats->rxedBytes;
        // NOTICE: Do not clear the statistics, since some messages
        //         with the reports may be lost and we do not want
        //         to lose statistics from any round, which would
        //         result in underestimating the traffic.
        // call ProtocolOnlyOutgoingTrafficStats.clearStats();
        // call ProtocolOnlyIncomingTrafficStats.clearStats();

        outTrafficStats = call WholeStackOutgoingTrafficStats.getStats();
        inTrafficStats = call WholeStackIncomingTrafficStats.getStats();
        payload->txedMessagesCHComplete = outTrafficStats->schedMessages;
        payload->txedBytesCHComplete = outTrafficStats->schedBytes;
        payload->rxedMessagesCHComplete = inTrafficStats->rxedMessages;
        payload->rxedBytesCHComplete = inTrafficStats->rxedBytes;
        // NOTICE: Do not clear the statistics, since some messages
        //         with the reports may be lost and we do not want
        //         to lose statistics from any round, which would
        //         result in underestimating the traffic.
        // call WholeStackOutgoingTrafficStats.clearStats();
        // call WholeStackIncomingTrafficStats.clearStats();


        // Send the message.
        err = call SerialTrafficStatsSend.send(AM_BROADCAST_ADDR, msg, len);

        if (err != SUCCESS) {
            // Send failed, so terminate statistic reporting.

            dbgerror("App|ERROR", \
                "Unable to send a serial message! [%s]\n", __FUNCTION__);

            statsReportingActive = FALSE;
            signal SerialStatsReporting.reportingDone(err);

        } else {
            // Sending was successful, so the
            // completion handler will be invoked.
            dbg("App|1", \
                "A %hhu byte serial message enqueued " \
                "for sending. [%s]\n", len, __FUNCTION__);
        }
    }



    /**
     * Reports the link estimator statistics over the serial port.
     */
    task void taskReportLEStats() {
        message_t *                               msg;
        uint8_t *                                 payload;
        uint8_t                                   len, maxLen;
        nx_ch_stats_report_le_neighbor_t *        msgNeighbors;
        uint8_t                                   i, n;
        error_t                                   err;

        dbg("App|1", \
            "Reporting link estimator statistics over " \
            "the serial port. [%s]\n", __FUNCTION__);

        msg = &serialMessage;

        // Clear the contents of the message and get the payload.
        call SerialPacket.clear(msg);

        maxLen = call SerialPacket.maxPayloadLength();
        len = sizeof(nx_ch_stats_report_header_t) +
            sizeof(nx_ch_stats_report_le_header_t);

        // Check if the payload is big enough.
        if (len + sizeof(nx_ch_stats_report_le_neighbor_t) > maxLen) {
            dbgerror("App|ERROR", \
                "The maximal payload of a serial message (%hhu) " \
                "is smalled than the payload required for a link " \
                "estimator statistics message (%hhu)! [%s]\n", \
                maxLen, len, __FUNCTION__);

            statsReportingActive = FALSE;
            signal SerialStatsReporting.reportingDone(ESIZE);

            return;
        }

        payload = (uint8_t *)call SerialPacket.getPayload(msg, NULL);

        if ((idxStatsReports & NX_CH_STATS_REPORT_HEADER_FLAG_LAST) != 0) {
            // This is the first link estimator stats message.
            idxStatsReports = 0;
            call NeighborTableIter.init(&neighborTableIter);
        } else {
            ++idxStatsReports;
            idxStatsReports &= NX_CH_STATS_REPORT_HEADER_INDEX_MASK;
        }

        // Compute the maximal number of neighbors and
        // get the neighbor array in the message.
        // ASSUMPTION: len      == the length of all the headers
        //             payload  == the original message payload
        n = (maxLen - len) /
            sizeof(nx_ch_stats_report_le_neighbor_t);
        msgNeighbors = (nx_ch_stats_report_le_neighbor_t *)
            (payload + len);

        // Serialize all neighbors.
        i = 0;
        while (i < n && call NeighborTableIter.hasNext(&neighborTableIter)) {
            neighbor_t *   neighbor;

            neighbor = call NeighborTableIter.next(&neighborTableIter);
            if ((neighbor->flags & NEIGHBOR_VALID) != 0) {
                msgNeighbors[i].addr = neighbor->llAddress;
                msgNeighbors[i].flq = neighbor->outLinkQ;
                msgNeighbors[i].rlq = neighbor->inLinkQ;
                ++i;
            }
        }

        // Update the message length to include
        // the serialized neighbors.
        len += sizeof(nx_ch_stats_report_le_neighbor_t) * i;

        // Check if we have more neighbors for the next message.
        if (!(call NeighborTableIter.hasNext(&neighborTableIter))) {
            idxStatsReports |= NX_CH_STATS_REPORT_HEADER_FLAG_LAST;
        }

        // Fill in the general header.
        ((nx_ch_stats_report_header_t *)
            (payload + 0))->reportNumber = numStatsReports - 1;
        ((nx_ch_stats_report_header_t *)
            (payload + 0))->indexInSeriesAndFlags = idxStatsReports;

        // Fill in the link estimator header.
        ((nx_ch_stats_report_le_header_t *)
            (payload + sizeof(nx_ch_stats_report_header_t)))->numNeighbors = i;


        // Send the message.
        err = call SerialLEStatsSend.send(AM_BROADCAST_ADDR, msg, len);

        if (err != SUCCESS) {
            // Send failed, so terminate statistic reporting.

            dbgerror("App|ERROR", \
                "Unable to send a serial message! [%s]\n", __FUNCTION__);

            statsReportingActive = FALSE;
            signal SerialStatsReporting.reportingDone(err);

        } else {
            // Sending was successful, so the
            // completion handler will be invoked.
            dbg("App|1", \
                "A %hhu byte serial message enqueued " \
                "for sending. [%s]\n", len, __FUNCTION__);
        }
    }



    /**
     * Puts a label into the message.
     * @param payload the payload to which the label will be put at offset 0
     * @param len the maximal length of the payload
     * @return the number of bytes occupied by the label or 0, which
     *         denotes that the message was too small to put the label
     */
    inline uint8_t storeAHLabel(void * payload, uint8_t len) {
        uint8_t        res, i, n = call ClusterHierarchy.getLabelLength();

        // Get the target length in bytes.
        res = call CHMsgLabel.getByteLen(n);

        // Check if there is enough space.
        if (len < res) {
            return 0;
        }

        // Put the label contents.
        call CHMsgLabel.setLen((nx_ch_label_t *)payload, n);
        for (i = 0; i < n; ++i) {
            call CHMsgLabel.setEl(
                (nx_ch_label_t *)payload,
                i,
                call ClusterHierarchy.getLabelElement(i));
        }

        return res;
    }



    /**
     * Initializes the iterator for the cluster hierarchy routing table.
     */
    inline void chRTEntryIterInit() {
        chLevelIter = 0;
        chHeadIter = 0xffff;
    }



    /**
     * Advances the iterator for the cluster hierarchy routing table.
     */
    inline void chRTEntryIterAdvance() {
        ++chHeadIter;
        if (chHeadIter == 0) {
            ++chLevelIter;
        }
    }



    /**
     * Copies the iterator for the cluster hierarchy routing table.
     */
    inline void chRTEntryIterCopy(uint8_t grpLevel, am_addr_t grpHead) {
        chLevelIter = grpLevel;
        chHeadIter = grpHead;
    }



    /**
     * Searches for the first unreported entry in the routing table.
     * @return the first unreported entry or <code>NULL</code>
     *         if such an entry does not exist
     */
    inline ch_rt_entry_t const * getFirstCHRTEntry() {
        bool                    firstRun = TRUE;
        uint8_t                 level;
        am_addr_t               head;
        ch_rt_entry_t const *   res;

        // Advance the iterator.
        chRTEntryIterAdvance();

        level = chLevelIter;
        head = chHeadIter;

        // Iterate over all levels of the hierarchy.
        while (level < CH_MAX_LABEL_LENGTH) {
            // Get the first element.
            res = call ClusterHierarchy.getFirstRTEntryAtLevel(level);

            if (firstRun) {
                // If this is the first run, skip all
                // elements that were already reported.
                firstRun = FALSE;
                while (res != NULL) {
                    if (res->head >= head) {
                        break;
                    }
                    res = call ClusterHierarchy.getNextRTEntryAtLevel(res);
                }
            }
            if (res != NULL) {
                // We have found the first element,
                // so update the iterator.
                chRTEntryIterCopy(res->level, res->head);
                return res;

            } else {
                // We could not find the first element
                // in this row, so change the row.
                ++level;
                head = 0;
            }
        }

        return NULL;
    }



    /**
     * Searches for the next unreported entry in the routing table.
     * @param pentry the current entry
     * @return the next unreported entry or <code>NULL</code>
     *         if such an entry does not exist
     */
    inline ch_rt_entry_t const * getNextCHRTEntry(
            ch_rt_entry_t const * pentry) {
        uint8_t level = pentry->level;

        pentry = call ClusterHierarchy.getNextRTEntryAtLevel(pentry);

        while (pentry == NULL) {
            ++level;
            if (level >= CH_MAX_LABEL_LENGTH) {
                return NULL;
            }
            pentry = call ClusterHierarchy.getFirstRTEntryAtLevel(level);
        }

        // pentry != NULL
        chRTEntryIterCopy(pentry->level, pentry->head);
        return pentry;
    }



    /**
     * Reports the cluster hierarchy statistics over the serial port.
     */
    task void taskReportCHStats() {
        message_t *                               msg;
        uint8_t *                                 payload;
        uint8_t                                   len, maxLen;
        uint8_t                                   i, n;
        nx_ch_stats_report_ch_rt_entry_t *        msgRTEntries;
        ch_rt_entry_t const *                     pentry;
        error_t                                   err;



        dbg("App|1", \
            "Reporting cluster hierarchy statistics over " \
            "the serial port [%s].\n", __FUNCTION__);

        msg = &serialMessage;

        // Clear the contents of the message and get the payload.
        call SerialPacket.clear(msg);

        maxLen = call SerialPacket.maxPayloadLength();
        len = sizeof(nx_ch_stats_report_header_t) +
            sizeof(nx_ch_stats_report_ch_header_t);

        // Check if the payload is big enough to hold
        // the headers and at least one routing table entry.
        if (len + sizeof(nx_ch_stats_report_ch_rt_entry_t) > maxLen) {
            dbgerror("App|ERROR", \
                "The maximal payload of a serial message (%hhu) " \
                "is smalled than the payload required for an cluster " \
                "hierarchy statistics message (%hhu)! [%s]\n", \
                maxLen, len, __FUNCTION__);

            statsReportingActive = FALSE;
            signal SerialStatsReporting.reportingDone(ESIZE);

            return;
        }

        payload = (uint8_t *)call SerialPacket.getPayload(msg, NULL);

        if ((idxStatsReports & NX_CH_STATS_REPORT_HEADER_FLAG_LAST) != 0) {
            // This is the first cluster hierarchy stats message,
            // so the label and the update vector must be stored
            // in the message.
            idxStatsReports = 0;

            chRTEntryIterInit();

            n = storeAHLabel(payload + len, maxLen - len);
            if (n == 0) {
                dbgerror("App", \
                    "The maximal payload of a serial message (%hhu) " \
                    "is to small to hold a label!\n", maxLen);

                statsReportingActive = FALSE;
                signal SerialStatsReporting.reportingDone(ESIZE);

                return;
            }

            len += n;

        } else {
            // This is not the first cluster hierarchy stats message,
            // so no label or update vector are necessary to be put
            // in the message.
            ++idxStatsReports;
            idxStatsReports &= NX_CH_STATS_REPORT_HEADER_INDEX_MASK;
        }

        // Get the number of routing entries and the entry table.
        // ASSUMPTION: len      == the length of all the headers plus
        //                         the label if present
        //             payload  == the original message payload
        n = ((maxLen - len) /
            sizeof(nx_ch_stats_report_ch_rt_entry_t));
        if (n > NX_CH_STATS_REPORT_CH_HEADER_NUM_RT_ENTRIES_MASK) {
            n = NX_CH_STATS_REPORT_CH_HEADER_NUM_RT_ENTRIES_MASK;
        }
        msgRTEntries = (nx_ch_stats_report_ch_rt_entry_t *)
            (payload + len);

        // Serialize the routing table entries.
        i = 0;
        pentry = getFirstCHRTEntry();
        while (i < n && pentry != NULL) {
            uint8_t j;
            msgRTEntries[i].level = pentry->level;
            msgRTEntries[i].head = pentry->head;
            msgRTEntries[i].numHops = pentry->numHops;
            for (j = 0; j < CH_MAX_RT_ENTRY_NEXT_HOP_CANDIDATES; ++j) {
                msgRTEntries[i].nextHops[j].addr =
                    pentry->nextHops[j].addr;
                msgRTEntries[i].nextHops[j].numHops = 0xff;
                    // pentry->nextHops[j].maintenance.phb.numHops;
            }
            ++i;
            pentry = getNextCHRTEntry(pentry);
        }

        // Compute the value of the field denoting the number of entries.
        n = i;
        if (len > sizeof(nx_ch_stats_report_header_t) +
                sizeof(nx_ch_stats_report_ch_header_t)) {
            // The report contains a label.
            n |= NX_CH_STATS_REPORT_CH_HEADER_FLAG_LABEL_PRESENT;
        }

        // Update the length field.
        len += sizeof(nx_ch_stats_report_ch_rt_entry_t) * i;

        // Check if we have more routing records to serialize.
        if (pentry == NULL) {
            idxStatsReports |= NX_CH_STATS_REPORT_HEADER_FLAG_LAST;
        }

        // Fill in the general header.
        ((nx_ch_stats_report_header_t *)
            (payload + 0))->reportNumber = numStatsReports - 1;
        ((nx_ch_stats_report_header_t *)
            (payload + 0))->indexInSeriesAndFlags = idxStatsReports;

        // Fill in the link estimator header.
        ((nx_ch_stats_report_ch_header_t *)
            (payload + sizeof(nx_ch_stats_report_header_t)))->numRTEntriesAndFlags = n;


        // Send the message.
        err = call SerialCHStatsSend.send(AM_BROADCAST_ADDR, msg, len);

        if (err != SUCCESS) {
            // Send failed, so terminate statistic reporting.

            dbgerror("App|ERROR", \
                "Unable to send a serial message. [%s]\n", __FUNCTION__);

            statsReportingActive = FALSE;
            signal SerialStatsReporting.reportingDone(err);

        } else {
            // Sending was successful, so the
            // completion handler will be invoked.
            dbg("App|1", \
                "A %hhu byte serial message enqueued " \
                "for sending. [%s]\n", len, __FUNCTION__);
        }

    }



}
