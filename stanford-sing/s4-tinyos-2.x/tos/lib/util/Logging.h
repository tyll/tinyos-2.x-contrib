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

#ifndef _NOGEO_LOG
#define _NOGEO_LOG

/*
 * The logging is done in message_t packets
 *
 */
#include "BVR.h"

enum {
  //Constants
  AM_S4_LOG_MSG = 60,
  AM_BVR_LOG_MSG = 61,

  SELF_LOG_INTERVAL = 60000u,
  UART_LOG_INTERVAL = 60000u,
};

enum {
  //Packets
  LOG_SEND_BEACON = 1,
  LOG_RECEIVE_BEACON = 3,
  LOG_SEND_ROOT_BEACON = 2,
  LOG_RECEIVE_ROOT_BEACON = 4,
  LOG_SEND_LINK_INFO = 5,
  LOG_RECEIVE_LINK_INFO = 6,
  LOG_SEND_APP_MSG = 7,
  LOG_RECEIVE_APP_MSG = 8,
  //Link table
  LOG_ADD_LINK = 10,       //0x0A
  LOG_CHANGE_LINK = 11,    //0x0B
  LOG_DROP_LINK = 12,      //0x0C
  //Neighbor table (neighbor's coordinates)
  LOG_ADD_NEIGHBOR = 20,   //14
  LOG_CHANGE_NEIGHBOR = 21,//15
  LOG_DROP_NEIGHBOR = 22,  //16
  //State
  LOG_CHANGE_COORDS = 30,  //1E
  LOG_CHANGE_COORD = 31,   //1F
  //Routing
  LOG_ROUTE_START      = 39,  //27
  LOG_ROUTE_FAIL_STUCK_0 = 40,  //28
  LOG_ROUTE_FAIL_STUCK  = 42,  //2A
  LOG_ROUTE_FAIL_BEACON = 41, //29
  //LOG_ROUTE_SAME_COORDS = 42, //2A
  LOG_ROUTE_SUCCESS = 43,     //2B
  LOG_ROUTE_FAIL_NO_LOCAL_BUFFER = 44,  //2C
  LOG_ROUTE_FAIL_NO_QUEUE_BUFFER = 45,  //2D
  LOG_ROUTE_INVALID_STATUS = 46,     //2E
  LOG_ROUTE_TO_SELF        = 47,     //2F
  LOG_ROUTE_STATUS_NEXT_ROUTE = 38, //26
  LOG_ROUTE_BUFFER_ERROR = 37,      //25
  LOG_ROUTE_SENT_NORMAL_OK = 32,          //20
  LOG_ROUTE_SENT_FALLBACK_OK = 33,          //21
  LOG_ROUTE_RECEIVED_OK = 34,      //22
  LOG_ROUTE_RECEIVED_DUPLICATE = 35,  //23
  //Logging for Scoped Flood
  LOG_ROUTE_BCAST_START =        64,  //40
  LOG_ROUTE_STATUS_BCAST_RETRY = 65,  //41
  LOG_ROUTE_STATUS_BCAST_FAIL =  66,  //42
  LOG_ROUTE_SENT_BCAST_OK =      67,  //43
  LOG_ROUTE_RECEIVED_BCAST_OK =  68,  //44
  LOG_ROUTE_BCAST_END_SCOPE =    69,  //45
  LOG_ROUTE_BCAST_ERROR_TIMER_FAILED = 70,  //46
  LOG_ROUTE_BCAST_ERROR_TIMER_PENDING = 71, //47
  //Logging self logging
  LOG_LOGGER_STATS = 50,      //32
  LOG_UART_COMM_STATS = 51,   //33
  //Logging For QueuedSendM

  LOG_LRX_SEND = 101,
  LOG_LRX_RECEIVE = 102,
  LOG_LRX_SXFER_START = 103,
  LOG_LRX_SXFER_FINISH = 104,
  LOG_LRX_RXFER_START = 105,
  LOG_LRX_RXFER_FINISH = 106,

  //Logging temporary - for debugging
  LOG_DBG1 = 129,         //81
  LOG_DBG2 = 130,         //82
  LOG_DBG3 = 131,         //83
  //Logging for retransmit test
  LOG_ROUTE_RETRANSMIT_SUCCESS = 132, //84
  LOG_ROUTE_RETRANSMIT_FAIL = 133, //85

};

typedef nx_struct {
  nx_uint8_t type;
  nx_uint16_t total;
}  LogEntrySentDV;

typedef nx_struct {
  nx_uint8_t type;
  nx_uint16_t total;
}  LogEntrySentBV;

typedef nx_struct {
  nx_uint8_t type;
  nx_uint16_t total;
}  LogEntrySentData;

typedef nx_struct {
  nx_uint8_t type;
  nx_uint16_t total;
} LogEntryRTState;






/*Packets*/
//Send a coordinate beacon with coordinate info
typedef nx_struct {
  nx_uint8_t type;
  nx_uint8_t seqno;
}  LogEntrySendBeacon;

typedef nx_struct {
  nx_uint8_t type;
  nx_uint8_t seqno;
  nx_uint16_t from;
}  LogEntryReceiveBeacon;

typedef nx_struct {
  nx_uint8_t type;
  nx_uint8_t seqno;
  nx_uint8_t hopcount;
}  LogEntrySendRootBeacon;

typedef nx_struct {
  nx_uint8_t type;             //LOG_RECEIVE_ROOT_BEACON
  nx_uint8_t id;               //which beacon
  nx_uint8_t seqno;
  nx_uint8_t hopcount;         //how distant
  nx_uint16_t last_hop;        //from
  nx_uint8_t quality;          //combined_quality
}   LogEntryReceiveRootBeacon;

typedef nx_struct {
  nx_uint8_t type;
  nx_uint8_t id;              //the message id from the application data, if it makes sense
  nx_uint16_t to;             //next hop
  nx_uint8_t mode;            //fallback or not
  nx_uint8_t fallback_thresh; //threshold to return to normal mode, if in fallback
  Coordinates dest;        //final destination
}  LogEntrySendAppMsg;

typedef nx_struct {
  nx_uint8_t type;
  nx_uint8_t id;
  nx_uint8_t result;  //whether this will be forwarded, received, or failed
}  LogEntryReceiveAppMsg;

/*Events*/
typedef nx_struct {
  nx_uint8_t type;
  LinkNeighbor link;
}  LogEntryChangeLink;

typedef nx_struct {
  nx_uint8_t type;
  nx_uint16_t addr;
}  LogEntryDropLink;


typedef nx_struct {
  nx_uint8_t type;
  CoordinateTableEntry neighbor;
}  LogEntryChangeNeighbor;

typedef nx_struct {
  nx_uint8_t type;
  nx_uint16_t addr;
}  LogEntryDropNeighbor;

//Packet type: 1E
typedef nx_struct {
  nx_uint8_t type;
  Coordinates Coords;
  CoordsParents parents;
}  LogEntryUpdateCoordinates;

//Packet type: 1F
typedef nx_struct {
  nx_uint8_t type;
  nx_uint8_t beacon;
  nx_uint8_t hopcount;
  nx_uint16_t parent;
  nx_uint8_t combined_quality;
}  LogEntryUpdateCoordinate;

typedef nx_struct {
  nx_uint8_t type;
  nx_uint16_t id;
  nx_uint16_t origin_addr;
  nx_uint16_t dest_addr;
  nx_uint8_t hopcount;
  Coordinates dest_coords;
  Coordinates my_coords;
}  LogEntryRouteReport;

//For link_level retransmission test
typedef nx_struct {
  nx_uint8_t type;
  nx_uint16_t id;
  nx_uint16_t origin_addr;
  nx_uint16_t dest_addr;
  nx_uint8_t hopcount;
  nx_uint16_t next_hop;
  nx_uint8_t retransmit_count;
}  LogEntryRetransmitReport;

typedef nx_struct {
  nx_uint8_t type;
  nx_uint8_t free_pos;
  nx_uint8_t max_queue;
  nx_uint32_t stat_received; // A total requests received
  nx_uint32_t stat_written;  // B total successfully written
  nx_uint32_t stat_no_buffer;  // C total failed no buffer
  nx_uint32_t stat_send_failed; // D total send failed
  nx_uint32_t stat_send_done_failed; //E total send done returned fail
  // A = B + C + D + E
}  LogEntryLoggerStats;

typedef nx_struct {
  nx_uint8_t type;
  nx_uint16_t stat_receive_duplicate_no_buffer;     // a
  nx_uint16_t stat_receive_duplicate_send_failed;   // b
  nx_uint16_t stat_receive_total;                   // c
  nx_uint16_t stat_send_duplicate_no_buffer;        // d
  nx_uint16_t stat_send_duplicate_send_fail;        // e
  nx_uint16_t stat_send_duplicate_send_done_fail;   // f
  nx_uint16_t stat_send_duplicate_success;          // g
  nx_uint16_t stat_send_duplicate_total;            // h
  nx_uint16_t stat_send_original_send_done_fail;    // i
  nx_uint16_t stat_send_original_send_failed;       // j
  nx_uint16_t stat_send_original_success;           // k
  nx_uint16_t stat_send_original_total;             // l
}  LogEntryUARTCommStats;

typedef nx_struct {
  nx_uint8_t type;
  nx_uint16_t sender;
  nx_uint16_t sender_session_id;
  nx_uint8_t sender_msg_id;
  nx_uint16_t receiver;
  nx_uint16_t receiver_session_id;
  nx_uint8_t receiver_msg_id;
  nx_uint8_t ctrl;
  nx_uint8_t blockNum;
  nx_uint8_t subCtrl;
  nx_uint8_t state;
}  LogEntryLRXPkt;

typedef nx_struct {
  nx_uint8_t type;
  nx_uint16_t sender;
  nx_uint16_t receiver;
  nx_uint16_t session_id;
  nx_uint8_t msg_id;
  nx_uint8_t numofBlock;
  nx_uint8_t success;
  nx_uint8_t state;
}  LogEntryLRXXfer;

typedef nx_struct {
  nx_uint8_t type;
  nx_uint16_t arg1;
  nx_uint16_t arg2;
  nx_uint16_t arg3;
}  LogEntryDebug;



/* This is a union with a hack: to reuse the structs above, which are all
   assumed to have a first field type, I define the first field of the
   union to be type, so that it can be checked invariably. */
typedef nx_union {
  nx_uint8_t type;
  LogEntryReceiveRootBeacon receive_root_beacon;
  LogEntryDropLink drop_link;
  LogEntryChangeLink add_link;
  LogEntryChangeLink change_link;
  LogEntryChangeNeighbor add_neighbor;
  LogEntryChangeNeighbor change_neighbor;
  LogEntryDropNeighbor drop_neighbor;
  LogEntryUpdateCoordinates update_coordinates;
  LogEntryUpdateCoordinate update_coordinate;
  LogEntryRouteReport route_report;
  LogEntryLoggerStats logger_stats;
  LogEntryUARTCommStats UART_comm_stats;
  LogEntryLRXPkt lrx_pkt;
  LogEntryLRXXfer lrx_xfer;
  LogEntryDebug debug;
  LogEntryRetransmitReport retransmit_report;
}  BVRLogMsg;

typedef nx_struct BVR_Log_Msg{
  LEHeader header;
  BVRLogMsg log_msg;
}  BVRLogMsgWrapper;

/* This is a union with a hack: to reuse the structs above, which are all
   assumed to have a first field type, I define the first field of the
   union to be type, so that it can be checked invariably. */
typedef nx_union {
  nx_uint8_t type;

  LogEntryReceiveBeacon receive_beacon;
  LogEntryReceiveRootBeacon receive_root_beacon;
  LogEntryDropLink drop_link;
  LogEntryChangeLink add_link;
  LogEntryChangeLink change_link;
  LogEntryChangeNeighbor add_neighbor;
  LogEntryChangeNeighbor change_neighbor;
  LogEntryDropNeighbor drop_neighbor;
  LogEntryUpdateCoordinates update_coordinates;
  LogEntryUpdateCoordinate update_coordinate;
  LogEntryRouteReport route_report;
  LogEntryLoggerStats logger_stats;
  LogEntryUARTCommStats UART_comm_stats;
  LogEntryLRXPkt lrx_pkt;
  LogEntryLRXXfer lrx_xfer;
  LogEntryDebug debug;
  LogEntryRetransmitReport retransmit_report;

  //added by Feng Wang on Sept. 22, for more statistics logging
  LogEntrySentDV sent_dv;
  LogEntrySentBV sent_bv;
  LogEntrySentData sent_data;
  LogEntryRTState rt_state;

}  S4LogMsg;



typedef nx_struct S4_Log_Msg{
  LEHeader header;
  S4LogMsg log_msg;
}  S4LogMsgWrapper;

#endif
