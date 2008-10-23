// ex: set tabstop=2 shiftwidth=2 expandtab syn=c:
// $Id$

/*
 * "Copyright (c) 2000-2003 The Regents of the University  of California.
 * All rights reserved.
 *
 * Permission to use, copy, modify, and distribute this software and its
 * documentation for any purpose, without fee, and without written agreement is
 * hereby granted, provided that the above copyright notice, the following
 * two paragraphs and the author appear in all copies of this software.
 *
 * IN NO EVENT SHALL THE UNIVERSITY OF CALIFORNIA BE LIABLE TO ANY PARTY FOR
 * DIRECT, INDIRECT, SPECIAL, INCIDENTAL, OR CONSEQUENTIAL DAMAGES ARISING OUT
 * OF THE USE OF THIS SOFTWARE AND ITS DOCUMENTATION, EVEN IF THE UNIVERSITY OF
 * CALIFORNIA HAS BEEN ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
 *
 * THE UNIVERSITY OF CALIFORNIA SPECIFICALLY DISCLAIMS ANY WARRANTIES,
 * INCLUDING, BUT NOT LIMITED TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY
 * AND FITNESS FOR A PARTICULAR PURPOSE.  THE SOFTWARE PROVIDED HEREUNDER IS
 * ON AN "AS IS" BASIS, AND THE UNIVERSITY OF CALIFORNIA HAS NO OBLIGATION TO
 * PROVIDE MAINTENANCE, SUPPORT, UPDATES, ENHANCEMENTS, OR MODIFICATIONS."
 *
 * Copyright (c) 2002-2003 Intel Corporation
 * All rights reserved.
 *
 * This file is distributed under the terms in the attached INTEL-LICENSE
 * file. If you do not find these files, copies can be found by writing to
 * Intel Research Berkeley, 2150 Shattuck Avenue, Suite 1300, Berkeley, CA,
 * 94704.  Attention:  Intel License Inquiry.
 */

/*
 * Authors:  Rodrigo Fonseca
 * Date Last Modified: 2005/05/26
 */

/*
 * Authors:  Feng Wang, Univ. of Texas at Austin, CS Department
 * Date Last Modified: 2006/03/02
 */

#ifdef BEACON_ELECTION
#include "CBRouting_unslotted.h"
#endif

#ifndef S4_ROUTING_H
#define S4_ROUTING_H

#include "AM.h"
#include "util.h"
#include "topology.h"
#include "LinkEstimator.h"

#include "coordinates.h"


enum {
  AM_S4_APP_MSG    = 55,//0x37
  AM_S4_APP_P_MSG  = 54,//0x36
  AM_S4_BEACON_MSG = 56,//0x38

//added by Feng Wang

#ifdef LOCAL_DV
  // new type for distance vector msg
  AM_DV_MSG = 201,//0xc9
#endif

  // added for MIG
  AM_S4_RAW_MSG    = 202,//0xca

#ifdef FAILURE_RECOVERY
  AM_FRREQ_MSG      = 203,//0xcb
  AM_FRREP_MSG      = 204,//0xcb
#endif
};

#ifndef S4_APP_DATA_LENGTH
#define  S4_APP_DATA_LENGTH 1
#endif

//added by Feng Wang

//maximum number of beacon retransmissions
#ifndef MAX_BEACON_SEND_RETRIES
#define MAX_BEACON_SEND_RETRIES 5
#endif

#ifdef CRROUTING
//maximum cluster size
#ifndef MAX_CLUSTER_SIZE
#ifdef PLATFORM_PC

#if defined(N1000) && defined(B8)
#define MAX_CLUSTER_SIZE 500
#elif defined(N1000) && (defined(B16) || defined(B24))
#define MAX_CLUSTER_SIZE 300
#elif defined(N1000) || defined(N500)
#define MAX_CLUSTER_SIZE 200
#endif
#if defined(N2000)
#define MAX_CLUSTER_SIZE 300
#endif
#if defined(N3000)
#define MAX_CLUSTER_SIZE 400
#endif
#if defined(N4000)
#define MAX_CLUSTER_SIZE 500
#endif
#if defined(N100)
#define MAX_CLUSTER_SIZE 50
#endif

#else
#define MAX_CLUSTER_SIZE 100
#endif

#endif
#endif

#ifdef RELIABLE_BCAST

//maximum number of pending beacon broadcast
#ifndef MAX_PENDING_BEACON
#ifdef PLATFORM_PC
#define MAX_PENDING_BEACON 20
#else
#define MAX_PENDING_BEACON 5
#endif
#endif

//maximum number of pending cluster broadcast
#ifndef MAX_PENDING_DV
#ifdef PLATFORM_PC
#define MAX_PENDING_DV 50
#else
#define MAX_PENDING_DV 10
#endif
#endif

//maximum number of re-broadcasts for reliability
#ifndef MAX_REBCAST
#define MAX_REBCAST 3
#endif

#endif

#ifdef MULTIPLE_BEACON
#ifndef MAX_BEACON_VECTOR_SIZE
#if defined(N500) || defined(N1000) || defined(N2000) || defined(N3000) || defined(N4000)
//maximum size of beacon vector (assume 56 bytes max TOSH_DATA_LENGTH)
#define MAX_BEACON_VECTOR_SIZE 12
//maximum size of beacon vector (assume 130 bytes max TOSH_DATA_LENGTH)
//#define MAX_BEACON_VECTOR_SIZE 30
#else
//maximum size of beacon vector (assume 29 bytes max TOSH_DATA_LENGTH)
#define MAX_BEACON_VECTOR_SIZE 8
#endif
#endif
#endif

#ifdef LOCAL_DV
#ifndef MAX_VECTOR_SIZE
#if defined(N500) || defined(N1000) || defined(N2000) || defined(N3000) || defined(N4000)
//maximum size of distance vector (assume 56 bytes max TOSH_DATA_LENGTH)
#define MAX_VECTOR_SIZE 8
//maximum size of distance vector (assume 130 bytes max TOSH_DATA_LENGTH)
//#define MAX_VECTOR_SIZE 20
#else
//maximum size of distance vector (assume 29 bytes max TOSH_DATA_LENGTH)
#define MAX_VECTOR_SIZE 4
#endif
#endif
#endif

#define SCOPE_LIFETIME 6

#ifdef PLATFORM_PC

#if defined(N100) || defined(N500) || defined(N1000)
#define MAX_BEACON_ROUND 60
#define MAX_DV_ROUND 20
#endif
#ifdef N2000
#define MAX_BEACON_ROUND 80
#define MAX_DV_ROUND 30
#endif
#ifdef N3000
#define MAX_BEACON_ROUND 100
#define MAX_DV_ROUND 40
#endif
#ifdef N4000
#define MAX_BEACON_ROUND 120
#define MAX_DV_ROUND 40
#endif

#else
#define MAX_BEACON_ROUND 60
#define MAX_DV_ROUND 20
#endif

//added by Feng Wang on Oct 4, only accept new seqno if greater by SEQNO_DISTANCE
#define SEQNO_DISTANCE 10

//I_ stands for Initial
//Timings
enum {
  I_DELAY_TIMER = 250,  //delay for forwarding beacon messages
  I_DELAY_CMD_TIMER = 25,  //delay for forwarding beacon messages
  I_RADIO_SETTING = 64, //mica2dot testbed:192 is fine. 0x70 for mica2's?
  I_BEACON_INTERVAL = 10000u,
  I_RADIO_CMD = 255, //default power setting for command packets
#ifdef SHORT_INTERVAL
  INTERVAL_MUL = 1,
#endif
#ifdef MEDIUM_INTERVAL
  INTERVAL_MUL = 6,
#endif
#ifdef LONG_INTERVAL
  INTERVAL_MUL = 36,
#endif
  I_BEACON_JITTER = 10000u,
  I_BEACON_START = 10000u,

  I_BEACON_UPDATE_INTERVAL = 10000u,
#ifdef RELIABLE_BCAST
  I_BEACON_RELIABILITY_CHECK_INTERVAL = 20, //!!! in SECONDS, not ms!!!
#endif

#ifdef FAILURE_RECOVERY
  I_WAIT_FR = 250,  //is 200ms long enough?
  FR_CW = 100,
#endif

  //added by Feng Wang on Mar 16
#ifdef CHECK_LINK
  I_CHECK_LINK_INTERVAL = 10000u, //check link condition every 30s
  WAIT_BEACON_ROUNDS = 6,
#endif
};

enum {
  PARENT_SWITCH_THRESHOLD = 15, //20% (was 30)
};

enum {
#ifdef PLATFORM_PC
  NOT_ROOT_BEACON = 65535,
#else
  NOT_ROOT_BEACON = 255,
#endif
};

typedef struct {
  bool valid;
  uint16_t parent;
  uint8_t last_seqno;
  uint8_t hops;
  uint8_t combined_quality; //stores the quality combined quality from the parent up to the root

  uint16_t nodeid;
#ifdef ETX_TOLERANCE
  uint8_t tolerance;
#endif

#ifdef DELETE_OLD_ENTRY
  uint16_t sent_time; //needed to calculate age if we want to delete old entries
#endif

  /* add two flags "updated" & "bcastlost",
   * to specify whether this entry has been updated since last bcast,
   * or whether the bcast is "lost" (i.e. having not overheard
   * re-broadcast from sufficiently many neighbors).
   * Each time BeaconUpdateTimer expires,
   * we only need to broadcast those entries w/ these flags being true,
   * while each time BeaconTimer expires,
   * we broadcast all valid entries.
   */
  bool updated;

#ifdef RELIABLE_BCAST
  bool bcastlost;
#endif

#ifdef SHOW_BEACONID
  uint16_t nodeid;
#endif
} S4RootBeacon;

typedef nx_struct {
  nx_uint16_t parent[MAX_ROOT_BEACONS];
  //nx_uint16_t parent[N_ROOT_BEACONS];
} CoordsParents;

#ifdef FW_COORD_TABLE
#include "coordinate_table_entry.h"
#endif

/*
enum {
  S4_APP_MODE_FALLBACK_MASK = 0x80
};
*/

enum {
  MSG_VALID_RANGE8 = 128      //Valid range for sequence numbers with 8 bits
};

/*Metrics for Routing*/
enum {
  METRIC_CLOSEST_BEACON = 6,
};

typedef nx_struct {
  nx_uint8_t data[S4_APP_DATA_LENGTH];
}  S4Data;


/* Used for AM_S4_APP_MSG, carries application data multihop.
 * S4Router uses this structure for storing the multihop routing data
 */

typedef nx_struct {       //for AM_S4_APP_MSG, carries application data multihop
  nx_uint8_t hopcount;
#ifdef CRROUTING
  nx_uint8_t closest_beacon;
#endif
  nx_uint16_t dest_id;
  nx_uint16_t  origin;       //the originator of the message
  //uint8_t mode;           //most significant bit: fallback? other 7: current mode
  //uint16_t fallback_thresh; //the value of the main metric when entering fallback
  nx_uint16_t msg_id;

  //added by Feng Wang on Sept. 22, to log # of retransmissions
  nx_uint8_t rexmit_count;
  nx_uint8_t tried_hopcount;

  S4Data data;
}  S4AppData;

/* This struct is the same as the above but has an extra field - slot - that
   allows parametrization of the interface provided by S4Router */
typedef nx_struct {       //for AM_S4_APP_P_MSG, carries application data multihop
  nx_uint8_t hopcount;
#ifdef CRROUTING
  nx_uint8_t closest_beacon;
#endif
  //Coordinates dest;
  nx_uint16_t dest_id;
  nx_uint16_t  origin;       //the originator of the message
  //uint8_t mode;           //most significant bit: fallback? other 7: current mode
  //uint16_t fallback_thresh; //the value of the main metric when entering fallback
  nx_uint8_t slot;           //added for demultiplexing
  nx_uint16_t msg_id;
  S4Data data;

  //added by Feng Wang on Sept. 22, to log # of retransmissions
  nx_uint8_t rexmit_count;
  nx_uint8_t tried_hopcount;

}  S4AppPData;



/* New S4BeaconMsg that incorporates both beacon and root beacon
 * messages into one periodic transmission
 * This message will only go 1 hop away */

/* sizeof = 3 */
typedef nx_struct BeaconInfo {

#ifdef MULTIPLE_BEACON
  /* add a field specifying beacon id,
   * since now we allow to send some, not all, beacons
   */
  nx_uint8_t beacon_id;

  nx_uint16_t nodeid;
#endif

  nx_uint8_t hopcount;
  nx_uint8_t seqno;
  nx_uint8_t quality;
}  BeaconInfo;

//sizeof = 3 + MAX_BEACON_VECTOR_SIZE*3.
typedef nx_struct {
  nx_uint16_t seqno;        //the sequence number of my beacon messages
#ifndef MULTIPLE_BEACON
  BeaconInfo beacons[MAX_ROOT_BEACONS];
  //BeaconInfo beacons[N_ROOT_BEACONS];
#else
  BeaconInfo beacons[MAX_BEACON_VECTOR_SIZE];
#endif
}  S4BeaconMsgData;


//size: 4 + sizeof(BeaconMsgData).
typedef nx_struct S4_Beacon_Msg {
  LEHeader header;
  S4BeaconMsgData type_data;
}  S4BeaconMsg;


typedef nx_struct S4_Raw_Msg {
  LEHeader header;
}  S4RawMsg;


typedef nx_struct S4_App_Msg{
  LEHeader header;
  S4AppData type_data;
}  S4AppMsg;

typedef nx_struct S4_App_P_Msg{
  LEHeader header;
  S4AppPData type_data;
}  S4AppPMsg;


//added by Feng Wang

#ifdef RELIABLE_BCAST
//maintain state of pending broadcast sessions, to achieve reliable broadcast
typedef struct {
  bool occupied;  //whether this entry is occupied
  uint8_t beacon_id;
  uint8_t n_rcv;  //have overheard this many neighbors re-broadcast
  uint8_t sendtime; //time of broadcast (in seconds, upper-bounded by timeout)
  uint8_t retries;  //# of retransmissions
} PendingBeacons;
#endif

#ifdef LOCAL_DV

//entry in the cluster routing table
typedef struct {
  bool valid;
#ifdef TOSSIM
  uint16_t dest;  //destination
  uint16_t parent;  //next hop
#else
    uint8_t dest;
    uint8_t parent;
#endif
  uint8_t last_seqno; //can be replaced if we have sent_time
  uint8_t hops;
  uint8_t scope;  //need to store the scope, which is required in DV msg
    //uint8_t combined_quality; //combined quality from the parent up to the root
#ifdef ETX_TOLERANCE
  uint8_t tolerance;
#endif

#ifdef DELETE_OLD_ENTRY
  uint16_t sent_time; //needed to calculate age if we want to delete old entries
#endif

  /* add two flags "updated" & "bcastlost",
   * to specify whether this entry has been updated since last bcast,
   * or whether the bcast is "lost" (i.e. having not overheard
   * re-broadcast from sufficiently many neighbors).
   * Each time ClusterUpdateTimer expires,
   * we only need to broadcast those entries w/ these flags being true,
   * while each time ClusterTimer expires,
   * we broadcast all valid entries.
   */
  bool updated;

#ifdef RELIABLE_BCAST
  bool bcastlost;
#endif
} ClusterMember;

//data structures for distance vectors

/* sizeof = 6 */
typedef nx_struct {
  /* "indx" here is for efficiency of sender,
   * so that do not need to go through the cluster
   * table to find the matching entry;
   * "source" id is still necessary,
   * because "indx" from the received dv just
   * specifies the index in the SENDER's
   * cluster routing table.
   */
  nx_uint8_t indx;
  nx_uint16_t source;  //source of dv
  nx_uint8_t hopcount; //hop count distance to source
  nx_uint8_t scope;  //scope of dv range
  nx_uint8_t seqno;
  //if having sent_time instead, it takes at least one more byte,
  //even 2 bytes probably are not long enough to represent time
  //uint16_t sent_time;
  //uint8_t quality;
}  DVInfo;

//sizeof = [2 +] MAX_VECTOR_SIZE*sizeof(DVInfo).
typedef nx_struct {
  //do we really need a seqno here?
  //a node will check DVInfo.seqno anyway
  //uint16_t seqno;        //the sequence number of my dv advertisement messages
  DVInfo dv_adv[MAX_VECTOR_SIZE]; //dv advertisements
}  DVMsgData;

//size: 4 + sizeof(DVMsgData).
typedef struct DV_Msg {
  LEHeader header;
  DVMsgData type_data;
} __attribute__ ((packed)) DVMsg;

#ifdef RELIABLE_BCAST
//maintain state of pending broadcast sessions, to achieve reliable broadcast
typedef struct {
  bool occupied;  //whether this entry is occupied
  uint8_t indx; //index in cluster routing table of SENDER!!!
  uint8_t n_rcv;  //have overheard this many neighbors re-broadcast
  uint8_t sendtime; //time of broadcast (in seconds, upper-bounded by timeout)
  uint8_t retries;  //# of retransmissions
} PendingDVs;
#endif

#endif

#ifdef FAILURE_RECOVERY
typedef nx_struct {
  //uint16_t requester_id;  //id of requester (who's trying recovery), optional
  nx_uint16_t dest_id;       //id of the destination
  nx_uint8_t closest_beacon; //id of the beacon closest to destination
  nx_uint16_t cur_next_hop;  //id of current next hop (who's failed, supposedly)
  nx_uint8_t cost;           //old cost through cur_next_hop (necessary?)
  nx_uint8_t cost_type;      //0: dest is within local cluster; 1: otherwise
}  FRReqMsgData;

//size: 4 + sizeof(FRReqMsgData).
typedef nx_struct FRReq_Msg {
  LEHeader header;
  FRReqMsgData type_data;
}  FRReqMsg;

typedef nx_struct {
  nx_uint16_t requester_id;  //id of requester
  nx_uint16_t replier_id;  //id of replier (who's claiming to recover), optional
  nx_uint8_t cost_type;    // 0: cost to closest_beacon; 1: cost to destination
  nx_uint8_t cost;           //new cost through this replier
}  FRRepMsgData;

//size: 4 + sizeof(FRRepMsgData).
typedef nx_struct FRRep_Msg {
  LEHeader header;
  FRRepMsgData type_data;
}  FRRepMsg;
#endif

typedef struct {
	uint16_t addr;
    uint16_t nextHop;
    uint8_t quality;
} NextHopTableEntry;

/***/
#endif  //S4_ROUTING_H
