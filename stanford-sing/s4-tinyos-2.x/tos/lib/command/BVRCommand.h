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

#ifndef BVRCMD_H
#define BVRCMD_H

#include "BVR.h"

enum {
  AM_BVR_COMMAND_MSG = 57,             //0x39
  AM_BVR_COMMAND_RESPONSE_MSG = 58,    //0x3A
};

/* Commands and Responses: this is the CBRMsg.type_data.control.type field */
/* Commands must be idempotent: this is because the sender not getting
 *                              an acknowledgment can be because the message
 *                              was dropped in the forward or reverse path, and
 *                              it is impossible for the sender to distinguish
 *                              these. It will retry in any case.*/
enum {
   BVR_CMD_HELLO = 0,           //Ack:0 //just a message to acknowledge presence
   BVR_CMD_LED_ON = 1,          //Ack:1 //yellow led on
   BVR_CMD_LED_OFF = 2,         //Ack:1 //yellow led off
   BVR_CMD_SET_ROOT_BEACON = 3, //Ack:1 //args: byte_arg:root_id. If NOT_ROOT_BEACON, disables root
   BVR_CMD_IS_ROOT_BEACON = 4,  //Ack:1
   BVR_CMD_ROOT_BEACON_START = 21, //Ack:1 //no args : starts the root beacon timer if node is a beacon
   BVR_CMD_ROOT_BEACON_STOP = 22,  //Ack:1 //no args : stops the root beacon timer if node is a beacon
   BVR_CMD_SET_COORDS = 5,      //Ack:1 //args: coords
   BVR_CMD_GET_COORDS = 6,      //Ack:1 //returnst: coords
   BVR_CMD_SET_RADIO_PWR = 7,   //Ack:1 //args: byte_arg
   BVR_CMD_GET_RADIO_PWR = 8,   //Ack:1 //returns: byte_arg
   BVR_CMD_GET_INFO = 9,        //Ack:1 //gets args.info
   BVR_CMD_GET_NEIGHBOR = 10,   //Ack:1 //args: byte_arg: index //retrieves information about 1 neighbor
   BVR_CMD_GET_NEIGHBORS = 11,  //Ack:1 //args: byte_arg: index //gets list of neighbors (partitioned, if > 9)
   BVR_CMD_GET_LINK_INFO = 12,  //Ack:1 //args: byte_arg: index //returns
   BVR_CMD_GET_LINKS = 13,      //Ack:1 //args: byte_arg: index //returns list of links known (partitioned, if > 9)
   BVR_CMD_GET_ID = 14,         //Ack:1 //get the identity of the mote in reply
   BVR_CMD_GET_ROOT_INFO = 15,  //Ack:1 // args: byte_arg = index
   BVR_CMD_FREEZE = 16,         //Ack:1 //stop updating, expiring, broadcasting info
   BVR_CMD_RESUME = 17,         //Ack:1 //resume
   BVR_CMD_REBOOT = 18,         //Ack:0 //reboot the mote
   BVR_CMD_RESET = 19,          //Ack:0 //reboot the mote and clear eeprom
   BVR_CMD_READ_LOG = 20,       //Ack:1 //logline in reply
   BVR_CMD_SET_RETRANSMIT = 23, //Ack:1 //args: byte_arg: QueuedSendM retransmit count
   BVR_CMD_GET_RETRANSMIT = 24, //Ack:1 //returns: byte_arg, current QueuedSendM retransmit count
   BVR_CMD_APP_ROUTE_TO = 30,   //Ack:1 //args: args.dest
};

enum {
  CMD_MASK_MORE_FRAGS = 1,
  CMD_MASK_ACK = 2
};

//Currently this can be at most 21 bytes (29 (TOS) - 8 from CBRMsg)

typedef nx_struct BVRCommandArgs {
  nx_uint8_t seqno; // this is the application sequence number
  nx_uint8_t flags; // flags masked by CMD_MASK_*
  nx_union {
    nx_uint8_t byte_arg;
    nx_uint16_t short_arg;
    Coordinates coords;
    nx_struct {
      Coordinates coords;
      nx_uint8_t neighbors;
      nx_uint8_t links;
      nx_uint8_t is_root_beacon;
      nx_uint8_t power;
    }  info;
    nx_struct {
      Coordinates coords;
      nx_uint16_t addr;
      nx_uint8_t mode;
    }  dest;
    nx_struct {
      nx_uint16_t install_id;
      nx_uint32_t compile_time;
    }  ident;
    CoordinateTableEntry neighbor_info;
    BVRRootBeacon root_info;
    LinkNeighbor link_info;
  }  args;
}  BVRCommandArgs, *BVRCommandArgs_ptr;


/* Used for AM_BVR_COMMAND_[RESPONSE_]MSG, carries commands and responses
 */
typedef nx_struct {
  nx_uint8_t hopcount;
  nx_uint16_t origin;
  nx_uint8_t type;
  BVRCommandArgs data;
}  BVRCommandData;

typedef nx_struct BVR_Command_Msg{
  LEHeader header;
  BVRCommandData type_data;
}  BVRCommandMsg;

typedef nx_struct BVR_Command_Response_Msg{
  LEHeader header;
  BVRCommandData type_data;
}  BVRCommandResponseMsg;

//Currently this can be at most 21 bytes (29 (TOS) - 8 from CBRMsg)

enum {
  AM_S4_COMMAND_MSG = 57,             //0x39
  AM_S4_COMMAND_RESPONSE_MSG = 58,    //0x3A
};

/* Commands and Responses: this is the CBRMsg.type_data.control.type field */
/* Commands must be idempotent: this is because the sender not getting
 *                              an acknowledgment can be because the message
 *                              was dropped in the forward or reverse path, and
 *                              it is impossible for the sender to distinguish
 *                              these. It will retry in any case.*/
enum {
   S4_CMD_HELLO = 0,           //Ack:0 //just a message to acknowledge presence
   S4_CMD_LED_ON = 1,          //Ack:1 //yellow led on
   S4_CMD_LED_OFF = 2,         //Ack:1 //yellow led off
   S4_CMD_SET_ROOT_BEACON = 3, //Ack:1 //args: byte_arg:root_id. If NOT_ROOT_BEACON, disables root
   S4_CMD_IS_ROOT_BEACON = 4,  //Ack:1
   S4_CMD_ROOT_BEACON_START = 21, //Ack:1 //no args : starts the root beacon timer if node is a beacon
   S4_CMD_ROOT_BEACON_STOP = 22,  //Ack:1 //no args : stops the root beacon timer if node is a beacon
   S4_CMD_SET_COORDS = 5,      //Ack:1 //args: coords
   S4_CMD_GET_COORDS = 6,      //Ack:1 //returnst: coords
   S4_CMD_SET_RADIO_PWR = 7,   //Ack:1 //args: byte_arg
   S4_CMD_GET_RADIO_PWR = 8,   //Ack:1 //returns: byte_arg
   S4_CMD_GET_INFO = 9,        //Ack:1 //gets args.info
   S4_CMD_GET_NEIGHBOR = 10,   //Ack:1 //args: byte_arg: index //retrieves information about 1 neighbor
   S4_CMD_GET_NEIGHBORS = 11,  //Ack:1 //args: byte_arg: index //gets list of neighbors (partitioned, if > 9)
   S4_CMD_GET_LINK_INFO = 12,  //Ack:1 //args: byte_arg: index //returns
   S4_CMD_GET_LINKS = 13,      //Ack:1 //args: byte_arg: index //returns list of links known (partitioned, if > 9)
   S4_CMD_GET_ID = 14,         //Ack:1 //get the identity of the mote in reply
   S4_CMD_GET_ROOT_INFO = 15,  //Ack:1 // args: byte_arg = index
   S4_CMD_FREEZE = 16,         //Ack:1 //stop updating, expiring, broadcasting info
   S4_CMD_RESUME = 17,         //Ack:1 //resume
   S4_CMD_REBOOT = 18,         //Ack:0 //reboot the mote
   S4_CMD_RESET = 19,          //Ack:0 //reboot the mote and clear eeprom
   S4_CMD_READ_LOG = 20,       //Ack:1 //logline in reply
   S4_CMD_SET_RETRANSMIT = 23, //Ack:1 //args: byte_arg: QueuedSendM retransmit count
   S4_CMD_GET_RETRANSMIT = 24, //Ack:1 //returns: byte_arg, current QueuedSendM retransmit count
   S4_CMD_APP_ROUTE_TO = 30,   //Ack:1 //args: args.dest
   S4_CMD_APP_ADV_ROUTE_TO = 31,   //Ack:1 //args: args.dest
   S4_CMD_GET_ROUTING_TABLE = 32,
   S4_CMD_SHUTDOWN_RADIO = 33,
   S4_CMD_SET_FR_TIMER = 34,
   S4_CMD_GET_FR_TIMER = 35,
   S4_CMD_GET_STATS = 36,       //Ack:1 get stats: control overhead, node load, routing state
};

typedef struct S4CommandArgs {
  uint8_t seqno; // this is the application sequence number
  uint8_t flags; // flags masked by CMD_MASK_*
  union {
    uint8_t byte_arg;
    uint16_t short_arg;
    Coordinates coords;
    struct {
      Coordinates coords;
      uint8_t neighbors;
      uint8_t links;
      uint8_t is_root_beacon;
      uint8_t power;
        uint16_t routing_table_size;
    } __attribute__ ((packed)) info;
    struct {
#ifdef CRROUTING
      uint8_t closest_beacon;
#endif
        uint16_t addr;
        //below is for adv_route_to
        uint8_t init_delay; //in seconds
        uint16_t n_packets;
        uint16_t interval;

      //uint8_t mode;
    } __attribute__ ((packed)) dest;
    struct {
      uint16_t install_id;
      uint32_t compile_time;
    } __attribute__ ((packed)) ident;
#ifdef FW_COORD_TABLE
    CoordinateTableEntry neighbor_info;
#endif
    S4RootBeacon root_info;
    LinkNeighbor link_info;

      //added for routing table
      struct {
          ClusterMember entry;
      } routing_table;

    struct {
      uint16_t sent_bv;
      uint16_t sent_dv;
      uint16_t sent_data;
      uint16_t routing_state;
    } stats;

  } __attribute__ ((packed)) args;
} __attribute__ ((packed)) S4CommandArgs, *S4CommandArgs_ptr;


/* Used for AM_S4_COMMAND_[RESPONSE_]MSG, carries commands and responses
 */
typedef struct {
    uint8_t hopcount;
#if defined(PLATFORM_PC) || defined(OLD_S4_COMMAND)
    uint16_t origin; //old, for simulation use only
#else
    uint16_t gateway_addr; //the gateway to forward the command
    uint16_t cmd_addr; //the real destination
#endif
    uint8_t type;
  S4CommandArgs data;
} __attribute__ ((packed)) S4CommandData;

typedef struct S4_Command_Msg{
  LEHeader header;
  S4CommandData type_data;
} __attribute__ ((packed)) S4CommandMsg;

typedef struct S4_Command_Response_Msg{
  LEHeader header;
  S4CommandData type_data;
} __attribute__ ((packed)) S4CommandResponseMsg;


#endif



