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
#ifndef __HIERARCHICAL_CLUSTERING_DEMO__H__
#define __HIERARCHICAL_CLUSTERING_DEMO__H__

#include <Timer.h>
#include <message.h>
#include <AM.h>
#include "TrafficStats.h"
#include "Sequencing.h"
#include "LinkEstimator.h"
#include "ClusterHierarchy.h"
#include "HierarchicalClusteringDemoStats.h"


// ************************* Static configuration *************************

// ###### Application config ######
#define CONF_APP_MAINTENANCE_MESSAGE_POOL_SIZE        8
#define CONF_APP_MAX_ROUTING_FLOWS_FOR_DUPLICATES    10
#define CONF_APP_MAX_ROUTING_FLOWS_FOR_STATS_QUEUE    \
    ((CONF_APP_MAX_ROUTING_FLOWS_FOR_DUPLICATES) + 1)
#define CONF_APP_ROUTING_MESSAGE_POOL_SIZE           10
#define CONF_APP_ROUTING_STATS_MESSAGE_POOL_SIZE      6
// the maximal number of message resends
#define CONF_APP_ROUTING_MESSAGE_MAX_RESENDS          5
// a backoff in milliseconds when forwarding a message
#define CONF_APP_ROUTING_MESSAGE_RESEND_BACKOFF_AVG  ((uint32_t)1024)
// a jitter in milliseconds when backing off before forwarding a message
#define CONF_APP_ROUTING_MESSAGE_RESEND_BACKOFF_DEV  ((uint32_t)512)
// the size of a message pool for statistic messages
#define CONF_APP_ROUTING_STATS_MESSAGE_POOL_SIZE      6
// 2% listen duty cycle
// #define CONF_APP_LPL_DUTY_CYCLE                    (200)
// or the check period in milliseconds
#define CONF_APP_LPL_CHECK_PERIOD                   256
// the number of times the LEDs should blink upon receiving a routing message
#define CONF_APP_NUM_LED_BLINKS_WHEN_ROUTING           3
// the interval (in milliseconds) between consecutive blinks
#define CONF_APP_INTERVAL_OF_LED_BLINKS_WHEN_ROUTING   512
// the polling interval (in milliseconds) for routing requests messages
#define CONF_APP_TOSSIM_ROUTING_REQ_POLL_INTERVAL   ((uint32_t)1024)


// ###### Link estimator config ######
#define CONF_LE_MIN_MSG_RECORDS           5
#define CONF_LE_MAX_MSG_RECORDS          20
// 25%
#define CONF_LE_EVICTION_THRESHOLD       64
// 55%
#define CONF_LE_SELECTION_THRESHOLD     140
// we are allowed to loose all messages in 5 periods
#define CONF_LE_MAX_REV_LQ_AGE            5
// we allow up to 10 consecutive periods to refresh forward LQ
#define CONF_LE_MAX_FOR_LQ_AGE           10
// we will recompute link qualities every 1 periods
#define CONF_LE_LQ_RECOMP_PERIOD          1
// we will use 85% weight for the historic values
// #define CONF_LE_LQ_RECOMP_WEIGHT        217
#define CONF_LE_LQ_RECOMP_WEIGHT        217
// we expect that many packets between consecutive LQ recomputations
// 1 stands for the number of messages in one period
#define CONF_LE_EXP_NUM_PACKETS_FOR_LQ \
        (CONF_LE_LQ_RECOMP_PERIOD * 1)


// ###### Hierarchy maintenance engine config ######
// 5 minutes
#define CONF_CH_DUTY_CYCLE_PERIOD                ((uint32_t)1024 * 60 * 5)
// 3 minutes without 10 seconds
#define CONF_CH_MAX_ADVERT_ISSUING_BACKOFF (CONF_CH_DUTY_CYCLE_PERIOD - 1024 * 10)
// 10 seconds
#define CONF_CH_MAX_ADVERT_FORWARDING_BACKOFF          ((uint32_t)1024 * 10)
// 75%
// #define CONF_CH_WHITE_LQ_THRESHOLD                                      191
// 85%
#define CONF_CH_WHITE_LQ_THRESHOLD                                      216
// 55%
#define CONF_CH_GRAY_LQ_THRESHOLD                                       140
#define CONF_CH_MAX_PATH_LENGTH                                          32



// *************************** Local structures ***************************
enum {
    /** the length of a client identifier */
    CLIENT_ID_BYTE_LENGTH = 8,
};


/**
 * A queue entry for routing messages to forward.
 */
typedef struct {
    am_addr_t      addr;       // destination address
    message_t *    msg;        // pointer to the message buffer
    uint8_t        len;        // the length of the message
    uint8_t        rsndCnt;    // the resend counter
    uint32_t       time;       // the time the message was enqueued
} hcdemo_fqueue_entry_t;



/**
 * A type used to check if the received routing messages are duplicates.
 */
typedef struct {
    uint16_t       sender;
    uint16_t       seqNo;
    uint8_t        age;
} hcdemo_duplicate_message_t;



/**
 * A queue entry for serial messages.
 */
typedef struct {
    message_t *    msg;       // a pointer to the message being sent
    uint8_t        len;       // the length of the message
    am_id_t        amId;      // the AM identifier of the message
} hcdemo_serial_queue_entry_t;



// ******************* Message and storage structures *********************
enum {
    /**
     * the AM identifier for a radio beacon message used by the periodic
     * hierarchical beaconing engine for cluster hierarchy maintenance
     */
    HCDEMO_PHB_BEACON_MSG = 81,
    /**
     * the AM identifier for a radio hearbeat message used by the periodic
     * hierarchical distance-vector engine for cluster hierarchy maintenance
     */
    HCDEMO_PHDV_HEARTBEAT_MSG = 91,
    /**
     * the AM identifier for a radio beacon message used by the hybrid
     * engine for cluster hierarchy maintenance
     */
    HCDEMO_HYBRID_BEACON_MSG = 101,
    /**
     * the AM identifier for a radio hearbeat message used by the hybrid
     * engine for cluster hierarchy maintenance
     */
    HCDEMO_HYBRID_HEARTBEAT_MSG = 102,
    /**
     * the AM identifier of a message being routed
     */
    HCDEMO_ROUTING_MSG = 111,
};


typedef nx_struct {
    nx_uint16_t      sourceId;    // the id of the source node
    nx_uint16_t      seqNo;       // the sequence number for the message
    nx_uint8_t       numHops;     // the number of hops the message traveled
    nx_uint8_t       clientId[CLIENT_ID_BYTE_LENGTH]; // the identifier
                                  // of the client that issued the request
    nx_uint16_t      clientSeqNo; // the client's seq. no.
} nx_hcdemo_routing_message_payload_t;



enum {
    /** the serial message identifier for reporting the routing steps */
    AM_NX_HCDEMO_ROUTING_STEP_MSG_T = 103,
    /** the serial message identifier for receiving the routing requests */
    AM_NX_HCDEMO_ROUTING_REQUEST_MSG_T = 104,
};



typedef enum hcdemo_routing_step_actions {
    /** the message has been accepted */
    HCDEMO_ROUTING_STEP_ACCEPTED = 0,
    /** the message has been forwarded */
    HCDEMO_ROUTING_STEP_FORWARDED = 1,
    /** the message has been dropped due to insufficient payload */
    HCDEMO_ROUTING_STEP_DROPPED_INSUFFICIENT_PAYLOAD = 2,
    /** the message has been dropped due to a lack of free buffers */
    HCDEMO_ROUTING_STEP_DROPPED_NO_FREE_BUFFERS = 3,
    /** the message has been dropped due to an invalid destination address */
    HCDEMO_ROUTING_STEP_DROPPED_INVALID_DST_ADDRESS = 4,
    /** the message has been dropped due to an invalid length */
    HCDEMO_ROUTING_STEP_DROPPED_INVALID_LENGTH = 5,
    /** the message has been dropped due to a lack of the next hop */
    HCDEMO_ROUTING_STEP_DROPPED_NO_NEXT_HOP = 6,
    /** the message has been dropped due to a lack of queueing space */
    HCDEMO_ROUTING_STEP_DROPPED_NO_QUEUE_SPACE = 7,
    /** the message has been dropped due to an error in lower AM layers */
    HCDEMO_ROUTING_STEP_DROPPED_AM_SEND_FAILED = 8,
} hcdemo_routing_step_actions_t;



/**
 * A message sent over the serial port whenever a routing step was taken.
 */
typedef nx_struct nx_hcdemo_routing_step_msg_t {
    nx_uint8_t       action;      // the action taken (see the
                                  // hcdemo_routing_step_actions enum)
    nx_uint8_t       numHops;     // the number of hops the message has
                                  // traveled
    nx_uint16_t      source;      // the id of the source node
    nx_uint16_t      seqNo;       // the sequence number of the routing
                                  // message
    nx_uint16_t      dstLab[CH_MAX_LABEL_LENGTH]; // the destination label
    nx_am_addr_t     nextHop;     // an optional next hop neighbor
    nx_uint8_t       clientId[CLIENT_ID_BYTE_LENGTH]; // the identifier
                                                   // of the client that
                                                   // issued the request
    nx_uint16_t      clientSeqNo;                  // the client's seq. no.
} nx_hcdemo_routing_step_msg_t;


/**
 * A message sent over the serial port indicating a routing request.
 */
typedef nx_struct nx_hcdemo_routing_request_msg_t {
    nx_uint16_t      seqNo;                        // the proxy sequence number
    nx_uint16_t      dstLab[CH_MAX_LABEL_LENGTH];  // the destination label
    nx_uint8_t       clientId[CLIENT_ID_BYTE_LENGTH]; // the identifier
                                                   // of the client that
                                                   // issued the request
    nx_uint16_t      clientSeqNo;                  // the client's seq. no.
} nx_hcdemo_routing_request_msg_t;



#endif //__HIERARCHICAL_CLUSTERING_DEMO__H__
