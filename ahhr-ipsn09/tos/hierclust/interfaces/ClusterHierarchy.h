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

#ifndef __CLUSTER_HIERARCHY__H__
#define __CLUSTER_HIERARCHY__H__

#include <AM.h>
#include <message.h>
#include "NxVector.h"
#include "Sequencing.h"
#include "LinkEstimator.h"


/**
 * This file contains data types associated with a recursive cluster
 * hierarchy. These data types may be shared between different algorithms
 * for maintaining the hierarchy.
 *
 * @author Konrad Iwanicki &lt;iwanicki@few.vu.nl&gt;
 */



// *************************** Local structures ***************************
// CTCONFIG: The logarithm of the maximal length of a label.
#ifndef DEF_CH_MAX_LABEL_LOGLENGTH
#define DEF_CH_MAX_LABEL_LOGLENGTH 4
#endif //DEF_CH_MAX_LABEL_LOGLENGTH
// ENDCTCONFIG

// CTCONFIG: The maximal length of a label.
#ifndef DEF_CH_MAX_LABEL_LENGTH
#define DEF_CH_MAX_LABEL_LENGTH  ((1 << (DEF_CH_MAX_LABEL_LOGLENGTH)) - 1)
#endif //DEF_CH_MAX_LABEL_LENGTH
// ENDCTCONFIG

// CTCONFIG: The maximal number of entries in a node's routing table.
#ifndef DEF_CH_MAX_NUM_RT_ENTRIES
#define DEF_CH_MAX_NUM_RT_ENTRIES 100
#endif //DEF_CH_MAX_NUM_RT_ENTRIES
// ENDCTCONFIG

// CTCONFIG: The maximal number of the next hop candidates for a routing
//           table entry of a cluster hierarchy.
#ifndef DEF_CH_MAX_RT_ENTRY_NEXT_HOP_CANDIDATES
#define DEF_CH_MAX_RT_ENTRY_NEXT_HOP_CANDIDATES 4
#endif //DEF_MAX_RT_ENTRY_NEXT_HOP_CANDIDATES
// ENDCTCONFIG



enum {
    /** the logarithm from the maximal label length */
    CH_MAX_LABEL_LOGLENGTH = DEF_CH_MAX_LABEL_LOGLENGTH,

#if (((DEF_CH_MAX_LABEL_LENGTH) <= ((1 << (DEF_CH_MAX_LABEL_LOGLENGTH)) - 1)) \
        & (DEF_CH_MAX_LABEL_LENGTH) > 1)
    /** the maximal label length */
    CH_MAX_LABEL_LENGTH = DEF_CH_MAX_LABEL_LENGTH,
#else
    /** the maximal label length */
    CH_MAX_LABEL_LENGTH = ((1 << CH_MAX_LABEL_LOGLENGTH) - 1),
#endif

    /** the maximal number entries in the routing table */
    CH_MAX_NUM_RT_ENTRIES = DEF_CH_MAX_NUM_RT_ENTRIES,

    /** the maximal number of candidates of a routing entry for the next hop */
    CH_MAX_RT_ENTRY_NEXT_HOP_CANDIDATES = DEF_CH_MAX_RT_ENTRY_NEXT_HOP_CANDIDATES,

};

// Invalid identifier of the cluster head.
#ifdef CH_INVALID_CLUSTER_HEAD
#error Redefinition of 'CH_INVALID_CLUSTER_HEAD'!
#else
#define CH_INVALID_CLUSTER_HEAD     (0xffff)
#endif

// The number of hops that represents no-route information.
#ifdef CH_ROUTING_NO_ROUTE_NUM_HOPS
#error Redefinition of 'CH_ROUTING_NO_ROUTE_NUM_HOPS'!
#else
#define CH_ROUTING_NO_ROUTE_NUM_HOPS  (0xff)
#endif

/**
 * Maintenance data of a next hop candidate of a routing table entry
 * in periodic hierarchical beaconing maintenance algorithm.
 */
typedef struct {
    uint8_t                       numHops;  // the number of hops to the
                                            // head of the cluster
} ch_rt_entry_next_hop_maintenance_phb_t;

/**
 * Maintenance data of a next hop candidate of a routing table entry
 * in periodic hierarchical distance-vector maintenance algorithm.
 */
typedef struct {
    uint8_t                       ttl;
    bool                          adjacent;
} ch_rt_entry_next_hop_maintenance_phdv_t;

/**
 * Maintenance data of a next hop candidate of a routing table entry
 * in the hybrid maintenance algorithm.
 */
typedef struct {
    uint8_t                       ttl;
    bool                          adjacent;
} ch_rt_entry_next_hop_maintenance_hybrid_t;

/**
 * An additional structure used for maintaining the next hop candidates of
 * a hierarchical routing table.
 */
typedef union {
    /** a maintenance structure for periodic hierarchical beaconing */
    ch_rt_entry_next_hop_maintenance_phb_t      phb;
    /** a maintenance structure for periodic hierarchical DV */
    ch_rt_entry_next_hop_maintenance_phdv_t     phdv;
    /** a maintenance structure for the hybrid algorithm */
    ch_rt_entry_next_hop_maintenance_hybrid_t   hybrid;
} ch_rt_entry_next_hop_maintenance_t;



/**
 * A candidate for a next hop of a routing table entry.
 */
typedef struct {
    am_addr_t                           addr;         // the link-layer address
                                                      // of the next hop neighbor
    ch_rt_entry_next_hop_maintenance_t  maintenance;  // maintenance data
} ch_rt_entry_next_hop_t;



/** A sequence number for a routing table entry. */
typedef uint8_t                   ch_rt_entry_seq_no_t;



/**
 * Maintenance data of a routing table entry for periodic hierarchical
 * beaconing.
 */
typedef struct {
    ch_rt_entry_seq_no_t             seqNo;
    uint8_t                          ttl;
} ch_rt_entry_maintenance_phb_t;

/**
 * Maintenance data of a routing table entry for periodic hierarchical
 * distance-vector.
 */
typedef struct {
    ch_rt_entry_seq_no_t             seqNo;
    uint8_t                          radius;
    uint8_t                          ttl;
    bool                             adjacent;
} ch_rt_entry_maintenance_phdv_t;

/**
 * Maintenance data of a routing table entry for the hybrid algorithm.
 */
typedef struct {
    ch_rt_entry_seq_no_t             seqNo;
    uint8_t                          radius;
    uint8_t                          ttl;
    bool                             adjacent;
} ch_rt_entry_maintenance_hybrid_t;

/**
 * An additional structure used for maintaining the entries of
 * a hierarchical routing table.
 */
typedef union {
    /** a maintenance structure for periodic hierarchical beaconing */
    ch_rt_entry_maintenance_phb_t      phb;
    /** a maintenance structure for periodic hierarchical DV */
    ch_rt_entry_maintenance_phdv_t     phdv;
    /** a maintenance structure for the hybrid algorithm */
    ch_rt_entry_maintenance_hybrid_t   hybrid;
} ch_rt_entry_maintenance_t;



/**
 * A hierarchical routing table entry.
 */
typedef struct ch_rt_entry_t {
    uint16_t                      head;     // the unique identifier of
                                            // the head of the cluster
                                            // represented by the entry
    uint8_t                       level;    // the level of the cluster
                                            // represented by the entry
    uint8_t                       numHops;  // the number of hops of the
                                            // present node
    ch_rt_entry_next_hop_t        nextHops[CH_MAX_RT_ENTRY_NEXT_HOP_CANDIDATES];
                                            // the candidates for the next
                                            // hop routing entries
    ch_rt_entry_maintenance_t     maintenance; // an additional structure
                                            // used for maintaining the entry
    struct ch_rt_entry_t *        pnext;    // the pointer to the next
                                            // entry on the level list
                                            // or in the entry pool
} ch_rt_entry_t;



/**
 * An update counter type for periodic hierarchical distance-vector.
 */
typedef uint16_t                  ch_phdv_ucnt_t;

/**
 * An update counter type for the hybrid maintenance protocol.
 */
typedef uint16_t                  ch_hybrid_ucnt_t;



// ************************** Message structures **************************
/** The label embedded in a message. */
typedef nx_vect_t      nx_ch_label_t;
/** The sequence number as a network type. */
typedef nx_uint8_t     nx_ch_rt_entry_seq_no_t;


/** A beacon message for periodic hierarchical beaconing. */
typedef nx_struct {
    nx_uint8_t                numHops;        // the number of hops the
                                              // advert has traveled so far
    nx_ch_rt_entry_seq_no_t   advertSeqNo;    // the sequence number of
                                              // the advert
    // NOTICE: **************************************
    //         Uncomment below if we want to get information
    //         on how fast messages disseminate.
//     nx_int64_t                simCreationTime;
//     nx_int64_t                simReceiveTime;
//     nx_uint16_t               simIssuer;
    // **********************************************
    nx_uint8_t                labelBytes[0];  // the label of the issuer
                                              // variable-size payload
} nx_ch_phb_beacon_msg_t;



/** A beacon message for the hybrid maintenance algorithm. */
typedef nx_struct {
    nx_uint8_t                numHops;        // the number of hops the
                                              // advert has traveled so far
    nx_uint8_t                adjacent;       // the adjacency flag
    nx_ch_rt_entry_seq_no_t   advertSeqNo;    // the sequence number of
                                              // the advert
    // NOTICE: **************************************
    //         Uncomment below if we want to get information
    //         on how fast messages disseminate.
//     nx_int64_t                simCreationTime;
//     nx_int64_t                simReceiveTime;
//     nx_uint16_t               simIssuer;
    // **********************************************
    nx_uint8_t                varPayload[0];  // the label of the issuer
                                              // variable-size payload
} nx_ch_hybrid_beacon_msg_t;



/**
 * A definition of a routing table entry for a distance-vector message
 * that assumes that the level is described by 4 bits and the head by 12
 * bits.
 */
typedef nx_struct {
    nx_uint16_t               levelAdjHead;   // the lowest 4 bits is the
                                              // level, the next bit is the
                                              // adjacency flag, the
                                              // remaining 11 bits is the
                                              // head identifier
    nx_uint8_t                numHops;        // the number of hops the
                                              // advert has traveled so far
    nx_ch_rt_entry_seq_no_t   advertSeqNo;    // the sequence number of
                                              // the advert
} nx_ch_phdv_msg_rt_entry_4bit_level_11bit_head_t;



#if ((DEF_CH_MAX_LABEL_LOGLENGTH > 4) && (DEF_CH_MAX_LABEL_LENGTH > 15))
#error Cluster hierarchy label length is bigger than the maximal value for periodic distance-vector algorithm!
#else
/** A routing entry for periodic hierarchical distance-vector. */
typedef nx_ch_phdv_msg_rt_entry_4bit_level_11bit_head_t   nx_ch_phdv_msg_rt_entry_t;
/** A routing entry for periodic the hybrid maintenance protocol. */
typedef nx_ch_phdv_msg_rt_entry_4bit_level_11bit_head_t   nx_ch_hybrid_msg_rt_entry_t;
#endif



/**
 * The flags used for the periodic hierarchical beaconing message header.
 * See the <code>numEntriesAndFlags</code> field of the
 * <code>nx_ch_phdv_heartbeat_msg_hdr_t</code> structure.
 */
enum {
    NX_CH_PHDV_HEARTBEAT_MSG_HDR_NUM_ENTRIES_MASK = 0x7f,
    NX_CH_PHDV_HEARTBEAT_MSG_HDR_LABEL_UPDATE_PRESENT_FLAG = 0x80,
};



/**
 * A heartbeat message header for periodic hierarchical distance-vector.
 */
typedef nx_struct {
    nx_uint8_t                   numEntriesAndFlags;
} nx_ch_phdv_heartbeat_msg_hdr_t;


/**
 * A heartbeat message header for the hybrid maintenance protocol.
 */
typedef nx_struct {
    nx_uint8_t                   numEntriesAndFlags;
} nx_ch_hybrid_heartbeat_msg_hdr_t;


/**
 * A header for a message being routed.
 */
typedef nx_struct {
    nx_uint8_t              ttl;        // the TTL counter for the message
    nx_uint8_t              level;      // the level of the present landmark
    nx_uint8_t              dstLab[0];  // the label of the destination node
                                        // (variable size)
} nx_ch_routing_message_header_t;


#endif //__CLUSTER_HIERARCHY__H__
