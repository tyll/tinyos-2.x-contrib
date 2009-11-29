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
#include "HierarchicalClusteringDemo.h"


/**
 * The implementation of the hierarchical clustering demo application.
 *
 * @author Konrad Iwanicki &lt;iwanicki@few.vu.nl&gt;
 */
module HierarchicalClusteringDemoP {
    uses {
        interface Boot;

        interface Init as RandomInit;
        interface Random;

        interface Init as MaintenanceMessagePoolInit;
        interface Init as RoutingMessagePoolInit;
        interface PoolOfMessages as RoutingMessagePool;
        interface GenericQueue<hcdemo_fqueue_entry_t> as RoutingMessageQueue;
        interface Timer<TMilli> as RoutingMessageTimer;

        interface Timer<TMilli> as RoutingLEDSTimer;

        interface Init as RoutingStatsMessagePoolInit;
        interface PoolOfMessages as RoutingStatsMessagePool;

        interface Init as SequencingInit;

        interface Init as LEInit;
        interface LinkEstimatorConfig as LEConfig;
        interface LinkEstimatorControl as LEControl;

        interface Init as CHEngineInit;
        interface ClusterHierarchyMaintenanceConfig as CHEngineConfig;
        interface ClusterHierarchyMaintenanceControl as CHEngineControl;

        interface ClusterHierarchy;
        interface NxVector<uint16_t> as MessageLabel;

        interface SplitControl as RadioControl;
#ifdef HC_DEMO_USE_LPL
        interface LowPowerListening as RadioLPL;
#endif

        interface Packet as RoutingPacket;
        interface AMPacket as RoutingAMPacket;
        interface AMSend as RoutingSend;
        interface Receive as RoutingReceive;
        interface PacketAcknowledgements as RoutingAcks;

        interface Packet as RoutingStatsPacket;
        interface AMSend as RoutingStatsSend;
        interface Receive as RoutingRequestReceive;

        interface SplitControl as SerialControl;

        interface SerialStatsReporting as StatsReporting;

        interface Leds as LEDs;

#ifdef TOSSIM
#ifdef __SIM_KI__H__
        interface Timer<TMilli> as TOSSIMRouteRequestPollTimer;
#endif
#endif
    }
}
implementation {

    // ------------------------- Private members --------------------------
    /** a variable indicating whether the serial port is working */
    bool                             serialOn;
    /** a variable indicating whehter the serial port is busy sending a message */
    bool                             serialBusy;

    /** indicates whether a routing message is being sent */
    bool                             isRouting;

    /** stores sequence numbers of received messages to eliminate duplicates */
    hcdemo_duplicate_message_t       msgDuplicates[CONF_APP_MAX_ROUTING_FLOWS_FOR_DUPLICATES];

    /** the routing sequence number of the present node */
    uint16_t                         myRoutingSeqNo;

    /** the sequence number of the last routing request seen */
//    uint16_t                         lastRoutingRequestSeqNo;

    /** the number of times the LEDs will change their state (should be odd) */
    uint8_t                          ledsBlinkCountWhenRouting;


    /**
     * Turns on/off the led responsible for signaling an error.
     * @param on <code>TRUE</code> if the led is to be turned on,
     *        <code>FALSE</code> if the led is to be turned off
     */
    inline void ledErr(bool on) {
//        if (on) {
//            call LEDs.led0On();
//        } else {
//            call LEDs.led0Off();
//        }
    }



    /**
     * Starts blinking LEDs when a routing message to be forwarded
     * has been received.
     */
    inline void blinkLEDsWhenRouting() {
        ledsBlinkCountWhenRouting =
            (CONF_APP_NUM_LED_BLINKS_WHEN_ROUTING << 1) + 1;
        call RoutingLEDSTimer.startOneShot(0);
    }



    /**
     * Prints an identifier of a client.
     * @param clientId the pointer to the client identifier
     */
    inline void tossimPrintClientId(
            nx_uint8_t const * clientId) {
#ifdef TOSSIM
        uint8_t i;
        if (CLIENT_ID_BYTE_LENGTH > 0) {
            printf("%02x", (uint8_t)clientId[0]);
            for (i = 1; i < CLIENT_ID_BYTE_LENGTH; ++i) {
                printf(":%02x", (uint8_t)clientId[i]);
            }
        }
#endif
    }
    


    /**
     * Prints the reason of dropping a routing message onto a
     * standard output. This works only in TOSSIM.
     * @param src the id of the source node
     * @param seqNo the sequence number of the dropped message
     * @param numHops the number of hops the message has traveled
     * @param dstLab the pointer to the destination label
     * @param reason the reason for dropping the message
     */
    inline void tossimPrintDroppedMessage(
            uint16_t src, uint16_t seqNo, uint8_t numHops,
            nx_ch_label_t * dstLab, char const * reason) {
#ifdef TOSSIM
        printf(
            "MSG_DROPPED: src = %hu seqNo = %hu hops = %hhu node = %hu reason = %s dst = ",
            src, seqNo, numHops, TOS_NODE_ID, reason);
        if (dstLab != NULL) {
            uint8_t i, j;

            printf("%hu", call MessageLabel.getEl(dstLab, 0));
            for (i = 1, j = call MessageLabel.getLen(dstLab); i < j; ++i) {

                printf(".%hu", call MessageLabel.getEl(dstLab, i));
            }
        }
        printf("\n");
#endif //TOSSIM
    }



    /**
     * Prints info about the message forwarding.
     * This works only in TOSSIM.
     * @param src the id of the source node
     * @param seqNo the sequence number of the dropped message
     * @param numHops the number of hops the message has traveled
     * @param nextHop the next-hop neighbor
     * @param dstLab the pointer to the destination label
     */
    inline void tossimPrintForwardedMessage(
            uint16_t src, uint16_t seqNo, uint8_t numHops,
            am_addr_t nextHop, nx_ch_label_t * dstLab) {
#ifdef TOSSIM
        printf(
            "MSG_FORWARDED: src = %hu seqNo = %hu hops = %hhu node = %hu next-hop = %hu dst = ",
            src, seqNo, numHops, TOS_NODE_ID, nextHop);
        if (dstLab != NULL) {
            uint8_t i, j;

            printf("%hu", call MessageLabel.getEl(dstLab, 0));
            for (i = 1, j = call MessageLabel.getLen(dstLab); i < j; ++i) {

                printf(".%hu", call MessageLabel.getEl(dstLab, i));
            }
        }
        printf("\n");
#endif //TOSSIM
    }



    /**
     * Prints message acceptance confirmation onto a
     * standard output. This works only in TOSSIM.
     * @param src the id of the source node
     * @param seqNo the sequence number of the accepted message
     * @param numHops the number of hops the message has traveled
     */
    inline void tossimPrintAcceptedMessage(
            uint16_t src, uint16_t seqNo, uint8_t numHops) {
#ifdef TOSSIM
        printf(
            "MSG_ACCEPTED: src = %hu seqNo = %hu hops = %hhu node = %hu\n",
            src, seqNo, numHops, TOS_NODE_ID);
#endif //TOSSIM
    }


    /**
     * Reports a routing step over the serial port.
     * @param action the action taken
     * @param src the id of the source node
     * @param seqNo the sequence number of the message
     * @param numHops the number of hops the message has traveled
     * @param dstLab the pointer to the destination label
     * @param nextHop an optional next hop neighbor
     * @param clientId the identifier of the client that issued the routing
     *        request
     * @param clientSeqNo the original sequence number of the request as
     *        given by the client
     */
    void serialReportRoutingStep(
            hcdemo_routing_step_actions_t action,
            uint16_t src, uint16_t seqNo, uint8_t numHops,
            nx_ch_label_t * dstLab, am_addr_t nextHop,
            nx_uint8_t const * clientId, uint16_t clientSeqNo) {
#ifndef TOSSIM
        message_t *                          msg;
        nx_hcdemo_routing_step_msg_t *       payload;
        uint8_t                              i, j;

        msg = call RoutingStatsMessagePool.allocMessage();

        if (msg == NULL) {
            return;
        }

        payload = (nx_hcdemo_routing_step_msg_t *)(
            call RoutingStatsPacket.getPayload(msg, NULL));

        payload->action = (uint8_t)action;
        payload->numHops = numHops;
        payload->source = src;
        payload->seqNo = seqNo;
        payload->nextHop = nextHop;
        if (dstLab != NULL) {
            for (i = 0, j = call MessageLabel.getLen(dstLab); i < j; ++i) {
                payload->dstLab[i] = call MessageLabel.getEl(dstLab, i);
            }
            for (; i < CH_MAX_LABEL_LENGTH; ++i) {
                payload->dstLab[i] = CH_INVALID_CLUSTER_HEAD;
            }
        }
        if (clientId != NULL) {
            for (i = 0; i < CLIENT_ID_BYTE_LENGTH; ++i) {
                payload->clientId[i] = clientId[i];
            }
        }
        payload->clientSeqNo = clientSeqNo;

        if (call RoutingStatsSend.send(
                AM_BROADCAST_ADDR, msg,
                sizeof(nx_hcdemo_routing_step_msg_t)) != SUCCESS) {
            call RoutingStatsMessagePool.freeMessage(msg);
        }
#endif
    }



    /**
     * Checks if a message is a duplicate.
     * @param src the source node
     * @param seqNo the sequence number of the node
     * @return <code>TRUE</code> if the message is duplicate, otherwise
     *         <code>FALSE</code> (note that this does not mean that the
     *         message is not for sure a duplicate)
     */
    inline bool isRoutingMessageDuplicate(uint16_t src, uint16_t seqNo) {
        uint8_t   i, j, k;
        bool      res;

        // Find a duplicate.
        j = k = CONF_APP_MAX_ROUTING_FLOWS_FOR_DUPLICATES;
        res = FALSE;
        for (i = 0; i < CONF_APP_MAX_ROUTING_FLOWS_FOR_DUPLICATES; ++i) {
            if (msgDuplicates[i].sender == src) {
                j = i;
                if (msgDuplicates[i].seqNo < seqNo) {
                    // The message is not a duplicate.
                    msgDuplicates[i].seqNo = seqNo;
                    msgDuplicates[i].age = 0;
                } else {
                    // The message is a duplicate.
                    res = TRUE;
                    ++msgDuplicates[i].age;
                }
            } else if (msgDuplicates[i].sender != CH_INVALID_CLUSTER_HEAD) {
                ++msgDuplicates[i].age;
            } else if (k == CONF_APP_MAX_ROUTING_FLOWS_FOR_DUPLICATES) {
                k = i;
            }
        }

        // Here:
        // if (j < MAX) ==> res -- result, j - index of the sender
        // if (k < MAX) ==> k -- index of an empty slot
        // if (k == MAX) ==> all slots are occupied

        if (j < CONF_APP_MAX_ROUTING_FLOWS_FOR_DUPLICATES) {
            return res;
        }

        if (k == CONF_APP_MAX_ROUTING_FLOWS_FOR_DUPLICATES) {
            k = 0;
            for (i = 1; i < CONF_APP_MAX_ROUTING_FLOWS_FOR_DUPLICATES; ++i) {
                if (msgDuplicates[i].age > msgDuplicates[k].age) {
                    k = i;
                }
            }
        }

        msgDuplicates[k].sender = src;
        msgDuplicates[k].seqNo = seqNo;
        msgDuplicates[k].age = 0;

        return FALSE;
    }



    /**
     * Prepares and issues a routing message.
     * @param dstLabelElements a pointer to an array containing elements
     *        of the destination label
     * @param dstLabelLength the size of the array
     * @param clientId the identifier of the client that originally issued
     *        the request
     * @param clientSeqNo the sequence number the client gave to the request
     * @return <code>SUCCESS</code> if the message has been prepared
     *         successfully, otherwise an error code
     */
    error_t prepareAndRouteMessage(
        nx_uint16_t const * dstLabelElements, uint8_t dstLabelLength,
        nx_uint8_t const * clientId, uint16_t clientSeqNo);
    /**
     * Forwards a message.
     * The assumption is that the message is correct.
     * @param msg the message
     * @param payload the message payload
     * @param len the length of the message
     * @return <code>SUCCESS</code> if the message has been enqueued for
     *         forwarding, otherwise an error code is returned
     */
    error_t forwardMessage(
        message_t * message, void * payload, uint8_t len);
    /**
     * Enqueues a routing message for sending.
     * @param addr the link-layer address of the destination node
     * @param msg a pointer to the message buffer
     * @param len the length of the message
     * @param rsndCnt the number of resends if sending the message fails
     * @return an queue entry representing a message or <code>NULL</code>
     *         if there was no queue space
     */
    hcdemo_fqueue_entry_t * enqueueRoutingMessage(
        am_addr_t addr, message_t * msg, uint8_t len, uint8_t rsndCnt);
    /**
     * Requeues a routing message at the end of the queue.
     * @param qentry the queue entry with the message (must be
     *        at the head of the queue)
     * @return a new queue entry representing a message or <code>NULL</code>
     *         if there was no queue space
     */
    hcdemo_fqueue_entry_t * requeueRoutingMessage(hcdemo_fqueue_entry_t * qentry);
    /**
     * Disposes a routing message (removes it from the queue
     * and frees all memory buffers).
     * @param qentry the queue entry with the message (must be
     *        at the head of the queue)
     */
    void disposeRoutingMessage(hcdemo_fqueue_entry_t * qentry);
    /**
     * A task for sending out the messages from the queue.
     */
    task void taskPushQueue();



    // ------------------------- Interface Boot ---------------------------
    event void Boot.booted() {
        uint8_t i;

        dbg("App|1", \
            "Booting the hierarchical clustering demo " \
            "application! [%s]\n", __FUNCTION__);

        // Turn off the error LED.
        ledErr(FALSE);

        // Initialize the random number generator (IMPORTANT).
        if (call RandomInit.init() != SUCCESS) {
            dbgerror("App|ERROR", \
                "Error initializing the random number " \
                "generator! [%s]\n", __FUNCTION__);
            ledErr(TRUE);
            return;
        }

        // Initialize the maintenance message pool.
        if (call MaintenanceMessagePoolInit.init() != SUCCESS) {
            dbgerror("App|ERROR", \
                "Error initializing the maintenance message pool! [%s]\n", \
                __FUNCTION__);
            ledErr(TRUE);
            return;
        }

        // Initialize the routing message pool.
        if (call RoutingMessagePoolInit.init() != SUCCESS) {
            dbgerror("App|ERROR", \
                "Error initializing the routing message pool! [%s]\n", \
                __FUNCTION__);
            ledErr(TRUE);
            return;
        }

        // Initialize the message pool for routing statistics.
        if (call RoutingStatsMessagePoolInit.init() != SUCCESS) {
            dbgerror("App|ERROR", \
                "Error initializing the routing statistic message pool! [%s]\n", \
                __FUNCTION__);
            ledErr(TRUE);
            return;
        }

        // Initialize packet sequencing.
        if (call SequencingInit.init() != SUCCESS) {
            dbgerror("App|ERROR", \
                "Error initializing the sequencing interface! [%s]\n", \
                __FUNCTION__);
            ledErr(TRUE);
            return;
        }

        // Initialize and configure the link estimator.
        if (call LEInit.init() != SUCCESS) {
            dbgerror("App|ERROR", \
                "Error initializing the link estimator! [%s]\n", \
                __FUNCTION__);
            ledErr(TRUE);
            return;
        }
        call LEConfig.setMinMsgRecords(CONF_LE_MIN_MSG_RECORDS);
        call LEConfig.setMaxMsgRecords(CONF_LE_MAX_MSG_RECORDS);
        call LEConfig.setEvictionThreshold(CONF_LE_EVICTION_THRESHOLD);
        call LEConfig.setSelectionThreshold(CONF_LE_SELECTION_THRESHOLD);
        call LEConfig.setMaxRevLQAge(CONF_LE_MAX_REV_LQ_AGE);
        call LEConfig.setMaxForLQAge(CONF_LE_MAX_FOR_LQ_AGE);
        call LEConfig.setLQRecompPeriod(CONF_LE_LQ_RECOMP_PERIOD);
        call LEConfig.setLQRecompWeight(CONF_LE_LQ_RECOMP_WEIGHT);
        call LEConfig.setExpNumPacketsForLQ(CONF_LE_EXP_NUM_PACKETS_FOR_LQ);

        // Initialize and configure the hierarchy maintenance engine.
        if (call CHEngineInit.init() != SUCCESS) {
            dbgerror("App|ERROR", \
                "Error initializing the cluster hierarchy maintenance " \
                "engine! [%s]\n", __FUNCTION__);
            ledErr(TRUE);
            return;
        }
        call CHEngineConfig.setMaxAdvertIssuingBackoff(
            CONF_CH_MAX_ADVERT_ISSUING_BACKOFF);
        call CHEngineConfig.setMaxAdvertForwardingBackoff(
            CONF_CH_MAX_ADVERT_FORWARDING_BACKOFF);
        call CHEngineConfig.setDutyCylePeriod(
            CONF_CH_DUTY_CYCLE_PERIOD);
        call CHEngineConfig.setWhiteLQThreshold(
            CONF_CH_WHITE_LQ_THRESHOLD);
        call CHEngineConfig.setGrayLQThreshold(
            CONF_CH_GRAY_LQ_THRESHOLD);
        call CHEngineConfig.setMaxPathLength(
            CONF_CH_MAX_PATH_LENGTH);

        // Initialize the local state.
        serialOn = FALSE;
        serialBusy = FALSE;
        isRouting = FALSE;
        for (i = 0; i < CONF_APP_MAX_ROUTING_FLOWS_FOR_DUPLICATES; ++i) {
            msgDuplicates[i].sender = CH_INVALID_CLUSTER_HEAD;
        }
        myRoutingSeqNo = 0;
//        lastRoutingRequestSeqNo = 0;
        ledsBlinkCountWhenRouting = 0;

        // Start the serial interface.
        call SerialControl.start();

        // Start the radio.
        if (call RadioControl.start() != SUCCESS) {
            dbgerror("App|ERROR", \
                "Error starting the radio! [%s]\n", __FUNCTION__);
            ledErr(TRUE);
            return;
        }
    }



    // --------------------- Interface RadioControl -----------------------
    event void RadioControl.startDone(error_t err) {
        // Check if the radio was turned on correctly.
        if (err != SUCCESS) {
            // We failed to initialize the radio,
            // so let's try again, maybe it will work.
            // In any case, signal an error first.
            dbgerror("App|ERROR", \
                "The radio did not start successfully! Retrying. [%s]\n", \
                __FUNCTION__);
            ledErr(TRUE);
            call RadioControl.start();

        } else {
            // We succeeded in initializing the radio.
            dbg("App|1", \
                "The radio started successfully. [%s]\n", __FUNCTION__);

            // Clear any possible error.
            ledErr(FALSE);

            // Start the engine for cluster hierarchy maintenance.
            if (call CHEngineControl.start() != SUCCESS) {
                dbgerror("App|ERROR", \
                    "Unable to start the engine for cluster hierarchy " \
                    "maintenance! [%s]\n", __FUNCTION__);
            }

#ifdef HC_DEMO_USE_LPL
            // call RadioLPL.setLocalDutyCycle(CONF_APP_LPL_DUTY_CYCLE);
            call RadioLPL.setLocalSleepInterval(CONF_APP_LPL_CHECK_PERIOD);
#endif

        }
    }



    event void RadioControl.stopDone(error_t err) {
        // Should never happen.
        dbgerror("App|ERROR", \
            "Internal error: The radio should never be stopped! [%s]\n", \
            __FUNCTION__);
        call CHEngineControl.stop();
        isRouting = FALSE;
        ledErr(TRUE);
    }



    // -------------------- Message issuing function -----------------------
    error_t prepareAndRouteMessage(
            nx_uint16_t const * dstLabelElements, uint8_t dstLabelLength,
            nx_uint8_t const * clientId, uint16_t clientSeqNo) {
        message_t *                             msg;
        nx_ch_routing_message_header_t *        routingHdr;
        nx_hcdemo_routing_message_payload_t *   routingPld;
        uint8_t                                 len;
        uint8_t                                 i;
        error_t                                 res;

        // Increment the sequence number.
        ++myRoutingSeqNo;

        // Check if the payload is big enough.
        len =
            sizeof(nx_hcdemo_routing_message_payload_t) +
            call ClusterHierarchy.getRoutingHeaderSize();

        if (len > call RoutingPacket.maxPayloadLength()) {
            // We cannot issue a message, as the
            // maximal payload it too small.
            dbgerror("App|ERROR", \
                "Dropping message %hu from node %hu after %hhu " \
                "hops as the payload is insufficient. [%s]\n", \
                myRoutingSeqNo, call ClusterHierarchy.getLabelElement(0), \
                0, __FUNCTION__);
#ifdef TOSSIM
            tossimPrintDroppedMessage(
                call ClusterHierarchy.getLabelElement(0), myRoutingSeqNo,
                0, NULL, "INSUFFICIENT_PAYLOAD");
#endif
            serialReportRoutingStep(
                HCDEMO_ROUTING_STEP_DROPPED_INSUFFICIENT_PAYLOAD,
                call ClusterHierarchy.getLabelElement(0),
                myRoutingSeqNo,
                0,
                NULL,
                AM_BROADCAST_ADDR,
                clientId,
                clientSeqNo);
            return FAIL;
        }

        // Allocate a message buffer.
        msg = call RoutingMessagePool.allocMessage();
        if (msg == NULL) {
            // We cannot issue a message, as there
            // is not enough buffer space.
            dbg("App|1", \
                "Dropping message %hu from node %hu after %hhu " \
                "hops as there are no free message buffers. [%s]\n", \
                myRoutingSeqNo, call ClusterHierarchy.getLabelElement(0), \
                0, __FUNCTION__);
#ifdef TOSSIM
            tossimPrintDroppedMessage(
                call ClusterHierarchy.getLabelElement(0), myRoutingSeqNo,
                0, NULL, "NO_FREE_BUFFERS");
#endif
            serialReportRoutingStep(
                HCDEMO_ROUTING_STEP_DROPPED_NO_FREE_BUFFERS,
                call ClusterHierarchy.getLabelElement(0),
                myRoutingSeqNo,
                0,
                NULL,
                AM_BROADCAST_ADDR,
                clientId,
                clientSeqNo);
            return FAIL;
        }

        routingHdr = (nx_ch_routing_message_header_t *)(
            call RoutingPacket.getPayload(msg, NULL));
        routingPld = (nx_hcdemo_routing_message_payload_t *)(
            (uint8_t *)routingHdr +
            call ClusterHierarchy.getRoutingHeaderSize());

        call ClusterHierarchy.clearRoutingHeader(routingHdr);

        if (call ClusterHierarchy.setRoutingHeaderDstLabelLength(
                routingHdr, dstLabelLength) != SUCCESS) {
            // We cannot issue a message, as the
            // maximal payload it too small.
            dbgerror("App|ERROR", \
                "Dropping message %hu from node %hu after %hhu " \
                "hops as the destination address is invalid. [%s]\n", \
                myRoutingSeqNo, call ClusterHierarchy.getLabelElement(0), \
                0, __FUNCTION__);
#ifdef TOSSIM
            tossimPrintDroppedMessage(
                call ClusterHierarchy.getLabelElement(0), myRoutingSeqNo,
                0, NULL, "INVALID_DST_ADDR");
#endif
            serialReportRoutingStep(
                HCDEMO_ROUTING_STEP_DROPPED_INVALID_DST_ADDRESS,
                call ClusterHierarchy.getLabelElement(0),
                myRoutingSeqNo,
                0,
                NULL,
                AM_BROADCAST_ADDR,
                clientId,
                clientSeqNo);
            call RoutingMessagePool.freeMessage(msg);
            return FAIL;
        }

        for (i = 0; i < dstLabelLength; ++i) {
            if (call ClusterHierarchy.setRoutingHeaderDstLabelElement(
                    routingHdr, i, dstLabelElements[i]) != SUCCESS) {
                // We cannot issue a message, as the
                // maximal payload it too small.
                dbgerror("App|ERROR", \
                    "Dropping message %hu from node %hu after %hhu " \
                    "hops as the destination address is invalid. [%s]\n", \
                    myRoutingSeqNo, call ClusterHierarchy.getLabelElement(0), \
                    0, __FUNCTION__);
#ifdef TOSSIM
                tossimPrintDroppedMessage(
                    call ClusterHierarchy.getLabelElement(0), myRoutingSeqNo,
                    0, NULL, "INVALID_DST_ADDR");
#endif
                serialReportRoutingStep(
                    HCDEMO_ROUTING_STEP_DROPPED_INVALID_DST_ADDRESS,
                    call ClusterHierarchy.getLabelElement(0),
                    myRoutingSeqNo,
                    0,
                    NULL,
                    AM_BROADCAST_ADDR,
                    clientId,
                    clientSeqNo);
                call RoutingMessagePool.freeMessage(msg);
                return FAIL;
            }
        }

        routingPld->sourceId = call ClusterHierarchy.getLabelElement(0);
        routingPld->seqNo = myRoutingSeqNo;
        routingPld->numHops = 0;
        for (i = 0; i < CLIENT_ID_BYTE_LENGTH; ++i) {
            routingPld->clientId[i] = clientId[i];
        }
        routingPld->clientSeqNo = clientSeqNo;

        res = forwardMessage(msg, routingHdr, len);

        if (res != SUCCESS) {
            call RoutingMessagePool.freeMessage(msg);
        }

        return res;
    }



    // -------------------- Interface RoutingReceive -----------------------
    event message_t * RoutingReceive.receive(
            message_t * msg, void * payload, uint8_t len) {
        nx_ch_routing_message_header_t *        routingHdr;
        nx_hcdemo_routing_message_payload_t *   routingPld;
        uint8_t                                 expLength;
        message_t *                             res;

        dbg("App|1", \
            "Received a %hhu-byte routing message from node %hu. [%s]\n", \
            len, call RoutingAMPacket.source(msg), __FUNCTION__);

        expLength =
            sizeof(nx_hcdemo_routing_message_payload_t) +
            call ClusterHierarchy.getRoutingHeaderSize();

        if (expLength != len) {
            dbgerror("App|ERROR", \
                "The received message length, %hhu, is shorter than " \
                "the expected message length, %hhu! [%s]\n", \
                len, expLength, __FUNCTION__);
#ifdef TOSSIM
            tossimPrintDroppedMessage(
                CH_INVALID_CLUSTER_HEAD, 0, 0, NULL, "WRONG_LENGTH");
#endif
            serialReportRoutingStep(
                HCDEMO_ROUTING_STEP_DROPPED_INVALID_LENGTH,
                CH_INVALID_CLUSTER_HEAD,
                0,
                0,
                NULL,
                AM_BROADCAST_ADDR,
                NULL,
                0);
            return msg;
        }

        // Extract message payloads.
        routingHdr = (nx_ch_routing_message_header_t *)payload;
        routingPld = (nx_hcdemo_routing_message_payload_t *)(
            (uint8_t *)payload +
                call ClusterHierarchy.getRoutingHeaderSize());

        // Increase the message hop count.
        routingPld->numHops = routingPld->numHops + 1;

#ifdef TOSSIM
#ifndef TOSSIM_NO_DEBUG
        {
            uint8_t _ti, _tj;

            dbg("App|2", \
                "  - The message is received from %hu, has sequence " \
                "number %hu, traveled %hhu hops, and is destined for " \
                "node %hu", routingPld->sourceId, \
                routingPld->seqNo, routingPld->numHops, \
                call MessageLabel.getEl( \
                    (nx_ch_label_t *)(&(routingHdr->dstLab[0])), 0));

            for (_ti = 1, _tj = call MessageLabel.getLen((nx_ch_label_t *)(&(routingHdr->dstLab[0])));
                    _ti < _tj; ++_ti) {
                dbg_clear("App|2", \
                    ".%hu", call MessageLabel.getEl( \
                    (nx_ch_label_t *)(&(routingHdr->dstLab[0])), _ti));
            }
            dbg_clear("App|2", "\n");
        }
#endif
#endif

        if (isRoutingMessageDuplicate(
                routingPld->sourceId, routingPld->seqNo)) {
            dbg("App|1", \
                "Dropping message %hu from node %hu after %hhu hops " \
                "as it is a duplicate. [%s]\n", routingPld->seqNo, \
                routingPld->sourceId, routingPld->numHops, __FUNCTION__);
            return msg;
        }

        // Start blinking LEDs.
        blinkLEDsWhenRouting();

        // Allocate a replacement message buffer.
        res = call RoutingMessagePool.allocMessage();
        if (res == NULL) {
            // We have to drop the message,
            // as there is not enough buffer space.
            dbg("App|1", \
                "Dropping message %hu from node %hu after %hhu " \
                "hops as there are no free message buffers. [%s]\n", \
                routingPld->seqNo, routingPld->sourceId, \
                routingPld->numHops, __FUNCTION__);
#ifdef TOSSIM
            tossimPrintDroppedMessage(
                routingPld->sourceId, routingPld->seqNo, routingPld->numHops,
                (nx_ch_label_t *)(&(routingHdr->dstLab[0])),
                "NO_FREE_BUFFERS");
#endif
            serialReportRoutingStep(
                HCDEMO_ROUTING_STEP_DROPPED_NO_FREE_BUFFERS,
                routingPld->sourceId,
                routingPld->seqNo,
                routingPld->numHops,
                (nx_ch_label_t *)(&(routingHdr->dstLab[0])),
                AM_BROADCAST_ADDR,
                &(routingPld->clientId[0]),
                routingPld->clientSeqNo);
            return msg;
        }

        if (forwardMessage(msg, payload, len) == SUCCESS) {
            return res;
        } else {
            call RoutingMessagePool.freeMessage(res);
            return msg;
        }
    }



    // ------------------------ Forwarding routine -------------------------
    error_t forwardMessage(
            message_t * msg, void * payload, uint8_t len) {
        nx_ch_routing_message_header_t *        routingHdr;
        nx_hcdemo_routing_message_payload_t *   routingPld;
        am_addr_t                               nextHop;
        hcdemo_fqueue_entry_t *                 qentry;

        // Get the routing header.
        routingHdr = (nx_ch_routing_message_header_t *)payload;
        routingPld = (nx_hcdemo_routing_message_payload_t *)(
            (uint8_t *)routingHdr +
            call ClusterHierarchy.getRoutingHeaderSize());

        // Prepare for forwarding.
        nextHop = call ClusterHierarchy.getNextRoutingHop(routingHdr);

        if (nextHop == AM_BROADCAST_ADDR) {
            // We have to drop the message.
            dbg("App|1", \
                "Dropping message %hu from node %hu after %hhu " \
                "hops as no next hop exists. [%s]\n", routingPld->seqNo, \
                routingPld->sourceId, routingPld->numHops, __FUNCTION__);
#ifdef TOSSIM
            tossimPrintDroppedMessage(
                routingPld->sourceId, routingPld->seqNo, routingPld->numHops,
                (nx_ch_label_t *)(&(routingHdr->dstLab[0])),
                "NO_NEXT_HOP");
#endif
            serialReportRoutingStep(
                HCDEMO_ROUTING_STEP_DROPPED_NO_NEXT_HOP,
                routingPld->sourceId,
                routingPld->seqNo,
                routingPld->numHops,
                (nx_ch_label_t *)(&(routingHdr->dstLab[0])),
                AM_BROADCAST_ADDR,
                &(routingPld->clientId[0]),
                routingPld->clientSeqNo);
            return FAIL;
        }

        // We have a next hop, so we have to forward the message.

        // Allocate a queue entry.
        qentry =
            enqueueRoutingMessage(
                nextHop, msg, len, CONF_APP_ROUTING_MESSAGE_MAX_RESENDS);
        if (qentry == NULL) {
            // We have to drop the message,
            // as there is not enough buffer space.
            dbg("App|1", \
                "Dropping message %hu from node %hu after %hhu " \
                "hops as there is no queue space. [%s]\n", \
                myRoutingSeqNo, call ClusterHierarchy.getLabelElement(0), \
                0, __FUNCTION__);
#ifdef TOSSIM
            tossimPrintDroppedMessage(
                call ClusterHierarchy.getLabelElement(0), myRoutingSeqNo,
                0, NULL, "NO_QUEUE_SPACE");
#endif
            serialReportRoutingStep(
                HCDEMO_ROUTING_STEP_DROPPED_NO_QUEUE_SPACE,
                routingPld->sourceId,
                routingPld->seqNo,
                routingPld->numHops,
                (nx_ch_label_t *)(&(routingHdr->dstLab[0])),
                nextHop,
                &(routingPld->clientId[0]),
                routingPld->clientSeqNo);
            return FAIL;
        }

        post taskPushQueue();

        dbg("App|1", \
            "Message %hu from node %hu after %hhu hops has been " \
            "enqueued for sending. [%s]\n", routingPld->seqNo, \
            routingPld->sourceId, routingPld->numHops, __FUNCTION__);

        return SUCCESS;
    }



    // --------------------- Message queueing routines ---------------------
    hcdemo_fqueue_entry_t * enqueueRoutingMessage(
            am_addr_t addr, message_t * msg, uint8_t len, uint8_t rsndCnt) {
        hcdemo_fqueue_entry_t *  resEntry;
        uint32_t                 now;

        // Allocate a queue entry.
        resEntry = call RoutingMessageQueue.enqueue();
        if (resEntry == NULL) {
            return NULL;
        }

        // Get current time.
        now = call RoutingMessageTimer.getNow();

        // Fill in the fields.
        resEntry->addr = addr;
        resEntry->msg = msg;
        resEntry->len = len;
        resEntry->rsndCnt = rsndCnt;
        resEntry->time = now + CONF_APP_ROUTING_MESSAGE_RESEND_BACKOFF_AVG;
        if (CONF_APP_ROUTING_MESSAGE_RESEND_BACKOFF_DEV > 0) {
            // Add some jitter to the transmission time.
            uint32_t jitter =
                call Random.rand32() % CONF_APP_ROUTING_MESSAGE_RESEND_BACKOFF_DEV;
            resEntry->time += jitter;
            resEntry->time -= (CONF_APP_ROUTING_MESSAGE_RESEND_BACKOFF_DEV >> 1);
        }

        if (call RoutingMessageQueue.size() > 1) {
            // If there was already some element in the
            // queue, then update element transmission times.
            uint8_t i, n;

            uint32_t resTime = resEntry->time;
            uint32_t resRemaining = resTime - now;
            if (resRemaining > resTime) {
                resRemaining = 0;
            }

            for (i = 0, n = call RoutingMessageQueue.size() - 1; i < n; ++i) {
                hcdemo_fqueue_entry_t *  qentry;
                uint32_t                 entryRemaining;

                qentry = call RoutingMessageQueue.getElement(i);

                entryRemaining = qentry->time - now;
                if (entryRemaining > qentry->time) {
                    entryRemaining = 0;
                }

                if (entryRemaining > resRemaining) {
                    uint32_t tmp = qentry->time;

                    qentry->time = resTime;
                    resTime = tmp;
                    resRemaining = entryRemaining;
                }
            }

            resEntry->time = resTime;
        }

        return resEntry;
    }



    inline hcdemo_fqueue_entry_t * requeueRoutingMessage(
            hcdemo_fqueue_entry_t * qentry) {
        hcdemo_fqueue_entry_t *  checkEntry;
        am_addr_t                addr;
        message_t *              msg;
        uint8_t                  len;
        uint8_t                  rsndCnt;

        checkEntry = call RoutingMessageQueue.dequeue();
        if (checkEntry != NULL) {

#ifdef TOSSIM
#ifndef TOSSIM_NO_DEBUG
            if (checkEntry != qentry) {
                dbgerror("App|ERROR", \
                    "Internal error when using: requeueRoutingMessage()!\n");
            }
#endif
#endif

            addr = checkEntry->addr;
            msg = checkEntry->msg;
            len = checkEntry->len;
            rsndCnt = checkEntry->rsndCnt;

            return enqueueRoutingMessage(addr, msg, len, rsndCnt);

        } else {

#ifdef TOSSIM
#ifndef TOSSIM_NO_DEBUG
            if (checkEntry != qentry) {
                dbgerror("App|ERROR", \
                    "Internal error when using: requeueRoutingMessage()!\n");
            }
#endif
#endif

            return NULL;

        }
    }



    inline void disposeRoutingMessage(hcdemo_fqueue_entry_t * qentry) {
        hcdemo_fqueue_entry_t * checkEntry;

        call RoutingAcks.noAck(qentry->msg);
        call RoutingMessagePool.freeMessage(qentry->msg);
        checkEntry = call RoutingMessageQueue.dequeue();

#ifdef TOSSIM
#ifndef TOSSIM_NO_DEBUG
        if (checkEntry != qentry) {
            dbgerror("App|ERROR", \
                "Internal error when using: disposeRoutingMessage()!\n");
        }
#endif
#endif

    }



    // ------------------- Interface RoutingMessageTimer -------------------
    event void RoutingMessageTimer.fired() {
        hcdemo_fqueue_entry_t *                 qentry;
        nx_ch_routing_message_header_t *        routingHdr;
        nx_hcdemo_routing_message_payload_t *   routingPld;

        if (isRouting) {
            return;
        }

        qentry = call RoutingMessageQueue.head();

        if (qentry == NULL) {
            return;
        }

        routingHdr = (nx_ch_routing_message_header_t *)(
            call RoutingPacket.getPayload(qentry->msg, NULL));
        routingPld = (nx_hcdemo_routing_message_payload_t *)(
            (uint8_t *)routingHdr +
            call ClusterHierarchy.getRoutingHeaderSize());

        if (qentry->addr == call RoutingAMPacket.address()) {
            // We have to accept the message.
            dbg("App|1", \
                "Accepting message %hu from node %hu after " \
                "%hhu hops. [%s]\n", routingPld->seqNo, \
                routingPld->sourceId, routingPld->numHops, __FUNCTION__);
#ifdef TOSSIM
            tossimPrintAcceptedMessage(
                routingPld->sourceId, routingPld->seqNo, routingPld->numHops);
#endif
            serialReportRoutingStep(
                HCDEMO_ROUTING_STEP_ACCEPTED,
                routingPld->sourceId,
                routingPld->seqNo,
                routingPld->numHops,
                (nx_ch_label_t *)(&(routingHdr->dstLab[0])),
                AM_BROADCAST_ADDR,
                &(routingPld->clientId[0]),
                routingPld->clientSeqNo);

            disposeRoutingMessage(qentry);

            post taskPushQueue();

            return;
        }

        // Request an acknowledgment.
        call RoutingAcks.requestAck(qentry->msg);

        // Transmit the message.
        if (call RoutingSend.send(
                qentry->addr, qentry->msg, qentry->len) != SUCCESS) {

            --qentry->rsndCnt;

            if (qentry->rsndCnt == 0) {

                dbg("App|1", \
                    "Dropping message %hu from node %hu after %hhu " \
                    "hops as sending the message failed. [%s]\n", \
                    routingPld->seqNo, routingPld->sourceId, \
                    routingPld->numHops, __FUNCTION__);
#ifdef TOSSIM
                tossimPrintDroppedMessage(
                    routingPld->sourceId, routingPld->seqNo, routingPld->numHops,
                    (nx_ch_label_t *)(&(routingHdr->dstLab[0])),
                    "AM_SEND_FAILED");
#endif

                serialReportRoutingStep(
                    HCDEMO_ROUTING_STEP_DROPPED_AM_SEND_FAILED,
                    routingPld->sourceId,
                    routingPld->seqNo,
                    routingPld->numHops,
                    (nx_ch_label_t *)(&(routingHdr->dstLab[0])),
                    qentry->addr,
                    &(routingPld->clientId[0]),
                    routingPld->clientSeqNo);

                disposeRoutingMessage(qentry);

            } else {

                requeueRoutingMessage(qentry);

            }

            post taskPushQueue();

        } else {

            isRouting = TRUE;

        }
    }



    // -------------------------- Forwarding task --------------------------
    task void taskPushQueue() {
        hcdemo_fqueue_entry_t *                 qentry;
        uint32_t                                dt;

        qentry = call RoutingMessageQueue.head();

        if (qentry == NULL) {
            return;
        }

        dt = qentry->time - call RoutingMessageTimer.getNow();
        // NOTICE: This condition here is extremely important.
        if (dt > qentry->time) {
            dt = 0;
        }

        call RoutingMessageTimer.startOneShot(dt);
    }



    // --------------------- Interface RoutingSend -------------------------
    event void RoutingSend.sendDone(message_t * msg, error_t err) {
        hcdemo_fqueue_entry_t *                 qentry;
        nx_ch_routing_message_header_t *        routingHdr;
        nx_hcdemo_routing_message_payload_t *   routingPld;

        qentry = call RoutingMessageQueue.head();

        if (qentry == NULL || !isRouting) {
            dbgerror("App|ERROR", \
                "Internal error: Queue is empty or nothing is being " \
                "routed! [%s]\n", __FUNCTION__);
            return;
        }

        if (qentry->msg != msg) {
            dbgerror("App|ERROR", \
                "Internal error: Send done was signaled for some unknown " \
                "message! [%s]\n", __FUNCTION__);
            return;
        }

        isRouting = FALSE;

        routingHdr = (nx_ch_routing_message_header_t *)(
            call RoutingPacket.getPayload(qentry->msg, NULL));
        routingPld = (nx_hcdemo_routing_message_payload_t *)(
            (uint8_t *)routingHdr +
            call ClusterHierarchy.getRoutingHeaderSize());

        if (err == SUCCESS && call RoutingAcks.wasAcked(msg)) {
            dbg("App|1", \
                "Forwarded message %hu from node %hu after %hhu " \
                "hops to node %hu. [%s]\n", \
                routingPld->seqNo, routingPld->sourceId, \
                routingPld->numHops, qentry->addr, __FUNCTION__);
#ifdef TOSSIM
            tossimPrintForwardedMessage(
                routingPld->sourceId, routingPld->seqNo,
                routingPld->numHops, qentry->addr,
                (nx_ch_label_t *)(&(routingHdr->dstLab[0])));
#endif

            serialReportRoutingStep(
                HCDEMO_ROUTING_STEP_FORWARDED,
                routingPld->sourceId,
                routingPld->seqNo,
                routingPld->numHops,
                (nx_ch_label_t *)(&(routingHdr->dstLab[0])),
                qentry->addr,
                &(routingPld->clientId[0]),
                routingPld->clientSeqNo);

            // Clean up after the message.
            disposeRoutingMessage(qentry);

        } else {
            --qentry->rsndCnt;
            if (qentry->rsndCnt == 0) {
                dbg("App|1", \
                    "Dropping message %hu from node %hu after %hhu " \
                    "hops as there are no free message buffers [%s]\n", \
                    routingPld->seqNo, routingPld->sourceId, \
                    routingPld->numHops, __FUNCTION__);
#ifdef TOSSIM
                tossimPrintDroppedMessage(
                    routingPld->sourceId, routingPld->seqNo, routingPld->numHops,
                    (nx_ch_label_t *)(&(routingHdr->dstLab[0])),
                    "AM_SEND_FAILED");
#endif

                serialReportRoutingStep(
                    HCDEMO_ROUTING_STEP_DROPPED_AM_SEND_FAILED,
                    routingPld->sourceId,
                    routingPld->seqNo,
                    routingPld->numHops,
                    (nx_ch_label_t *)(&(routingHdr->dstLab[0])),
                    qentry->addr,
                    &(routingPld->clientId[0]),
                    routingPld->clientSeqNo);

                disposeRoutingMessage(qentry);

            } else {

                requeueRoutingMessage(qentry);
            }
        }

        post taskPushQueue();
    }



    // --------------------- Interface SerialControl ----------------------
    event inline void SerialControl.startDone(error_t err) {
        if (err == SUCCESS) {
            dbg("App|1", \
                "The serial communication was started " \
                "successfully [%s].\n", __FUNCTION__);
            serialOn = TRUE;
            serialBusy = FALSE;
        } else {
            dbg("App|1", \
                "Unable to start the serial communication [%s].\n", \
                __FUNCTION__);
        }
    }



    event inline void SerialControl.stopDone(error_t err) {
        // Should neve happen.
        dbgerror("App|ERROR", \
            "The serial should never be stopped [%s]!\n", \
            __FUNCTION__);
        ledErr(TRUE);
        if (err == SUCCESS) {
            serialOn = FALSE;
        }
    }



    // -------------------- Interface CHEngineControl ---------------------
    event inline void CHEngineControl.bookkeepingStarted() {
        dbg("App|1", \
            "The bookkeeping of the cluster hierarchy maintenance " \
            "engine is about to start. Starting lower-layer periodic " \
            "tasks first. [%s]\n", __FUNCTION__);

        // Age the neighbor table.
        call LEControl.ageLinkQualities();

        dbg("App|1", \
            "Periodic tasks finished [%s].\n", __FUNCTION__);
    }



    event inline void CHEngineControl.bookkeepingFinished() {
        dbg("App|1", \
            "The bookkeeping of the cluster hierarchy maintenance " \
            "engine has finished. Starting statistic reporting. [%s]\n", \
            __FUNCTION__);

        call LEDs.set(call ClusterHierarchy.getLevelAsHead() & 0x07);

        if (serialOn && !serialBusy) {
            if (call StatsReporting.startReporting() == SUCCESS) {
                serialBusy = TRUE;
            }
        }
    }



    // ------------------- Interface StatsReporting ----------------------
    event inline void StatsReporting.reportingDone(error_t err) {
        if (err != SUCCESS) {
            ledErr(TRUE);
        }
        serialBusy = FALSE;

        dbg("App|1", \
            "Statistic reporting has finished. [%s]\n", \
            __FUNCTION__);
    }



    // ------------------- Interface RoutingStatsSend ----------------------
    event inline void RoutingStatsSend.sendDone(message_t * msg, error_t err) {
        call RoutingStatsMessagePool.freeMessage(msg);
    }



    // ---------------- Interface RoutingRequestReceive --------------------
    event inline message_t * RoutingRequestReceive.receive(
            message_t * msg, void * payload, uint8_t len) {
        nx_hcdemo_routing_request_msg_t *  request;
        uint8_t                            dstLabLen;

        dbg("App|1", \
            "Received a routing request. [%s]\n", __FUNCTION__);

        if (len != sizeof(nx_hcdemo_routing_request_msg_t)) {
            dbgerror("App|ERROR", \
                "The routing request has a wrong size, %hhu! [%s]\n", \
                len, __FUNCTION__);
            return msg;
        }

        request = (nx_hcdemo_routing_request_msg_t *)payload;

        // NOTICE: Since we now can have multiple clients and the
        //         client-to-mote communication is reliable, we do not
        //         drop the requests we have already seen.

//         if (lastRoutingRequestSeqNo >= request->seqNo) {
//             dbg("App|1", \
//                 "The routing request %hu has been seen. Dropping it. [%s]\n", \
//                 request->seqNo, __FUNCTION__);
//             return msg;
//         }
//
//         lastRoutingRequestSeqNo = request->seqNo;

        for (dstLabLen = 0; dstLabLen < CH_MAX_LABEL_LENGTH; ++dstLabLen) {
            if (request->dstLab[dstLabLen] == CH_INVALID_CLUSTER_HEAD) {
                break;
            }
        }

        if (dstLabLen == 0) {
            dbgerror("App|ERROR", \
                "Invalid length of the destination label, %hhu! [%s]\n", \
                dstLabLen, __FUNCTION__);
            return msg;
        }

        // Start blinking LEDs.
        blinkLEDsWhenRouting();

        // Prepare the network message and forward it.
        if (prepareAndRouteMessage(
                &(request->dstLab[0]), dstLabLen,
                &(request->clientId[0]),
                request->clientSeqNo) == SUCCESS) {
            dbg("App|1", \
                "Routing request %hu processed successfully. [%s]\n", \
                (uint16_t)request->seqNo, __FUNCTION__);
        } else {
            dbg("App|1", \
                "Failed to process routing request %hu. [%s]\n", \
                (uint16_t)request->seqNo, __FUNCTION__);
        }

        return msg;
    }



    // -------------------- Interface ClusterHierarchy --------------------
    event inline void ClusterHierarchy.labelChanged(uint8_t level) {
        // Do nothing.
    }



    // ------------------- Interface RoutingMessageTimer -------------------
    // Invoked when we want to blink LEDs upon receiving a routing message.
    event inline void RoutingLEDSTimer.fired() {

        if (ledsBlinkCountWhenRouting == 0) {
            return;
        }

        --ledsBlinkCountWhenRouting;
        if (ledsBlinkCountWhenRouting == 0) {
            // Restore the normal LED state.
            call LEDs.set(call ClusterHierarchy.getLevelAsHead() & 0x07);
        } else {
            if ((ledsBlinkCountWhenRouting & 0x01) != 0) {
                // Turn off all LEDs.
                call LEDs.led0Off();
                call LEDs.led1Off();
                call LEDs.led2Off();
            } else {
                // Turn on all LEDs.
                call LEDs.led0On();
                call LEDs.led1On();
                call LEDs.led2On();
            }
            // Reschedule the timer.
            call RoutingLEDSTimer.startOneShot(
                (CONF_APP_INTERVAL_OF_LED_BLINKS_WHEN_ROUTING + 1) >> 1);
        }
    }



#ifdef TOSSIM
#ifdef __SIM_KI__H__
    // --------------- Interface TOSSIMRouteRequestPollTimer ---------------
    event inline void TOSSIMRouteRequestPollTimer.fired() {
//         sim_ki_ch_routing_request_t const *  request;
//
//         request = sim_ki_routing_dequeue_node_request(TOS_NODE_ID);
//
//         if (request != NULL) {
//             message_t                             routingReqMsg;
//             nx_hcdemo_routing_request_msg_t *     payload;
//             uint8_t                               i;
//             message_t *                           msg;
//
//             payload = (nx_hcdemo_routing_request_msg_t *)
//                 call RoutingRequestReceive.getPayload(
//                     &routingReqMsg, NULL);
//
//             payload->seqNo = request->seqNo;
//             for (i = 0; i < CH_MAX_LABEL_LENGTH; ++i) {
//                 payload->dstLab[i] = request->dstLab[i];
//             }
//
//             msg = signal RoutingRequestReceive.receive(
//                 &routingReqMsg,
//                 payload,
//                 sizeof(nx_hcdemo_routing_request_msg_t));
//
//             if (msg != &routingReqMsg) {
//                 dbgerror("App|ERROR", \
//                     "Internal error: Message buffer returned differs from " \
//                     "the one provided! Memory may be corrupted! [%s]\n", \
//                     __FUNCTION__);
//             }
//         }
    }
#endif
#endif
}
