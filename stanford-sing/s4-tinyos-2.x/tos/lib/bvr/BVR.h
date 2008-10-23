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
#ifdef BEACON_ELECTION
#include "CBRouting_unslotted.h"
#endif

#ifndef BVR_ROUTING_H
#define BVR_ROUTING_H

#include "AM.h"
#include "util.h"
#include "topology.h"
#include "LinkEstimator.h"

#ifndef S4_ROUTING_H
#include "S4.h"
#endif

#include "coordinates.h"


enum {
  AM_BVR_APP_MSG    = 55,//0x37
  AM_BVR_APP_P_MSG  = 54,//0x36
  AM_BVR_BEACON_MSG = 56,//0x38
  BVR_UART_ADDR = 57,

};

#ifndef BVR_APP_DATA_LENGTH
#define  BVR_APP_DATA_LENGTH 1
#endif





typedef nx_struct {
  nx_uint8_t valid;
  nx_uint16_t parent;
  nx_uint8_t last_seqno;
  nx_uint8_t hops;
  nx_uint8_t combined_quality; //stores the quality combined quality from the parent up to the root
#ifdef ETX_TOLERANCE
  nx_uint8_t tolerance;
#endif
} BVRRootBeacon;


#include "coordinate_table_entry.h"

enum {
  BVR_APP_MODE_FALLBACK_MASK = 0x80
};



typedef nx_struct {
  nx_uint8_t data[BVR_APP_DATA_LENGTH];
}  BVRData;


/* Used for AM_BVR_APP_MSG, carries application data multihop.
 * BVRRouter uses this structure for storing the multihop routing data
 */

typedef nx_struct {       //for AM_BVR_APP_MSG, carries application data multihop
  nx_uint8_t hopcount;
  Coordinates dest;
  nx_uint16_t dest_id;
  nx_uint16_t  origin;       //the originator of the message
  nx_uint8_t mode;           //most significant bit: fallback? other 7: current mode
  nx_uint16_t fallback_thresh; //the value of the main metric when entering fallback
  nx_uint16_t msg_id;
  BVRData data;
} BVRAppData;

/* This struct is the same as the above but has an extra field - slot - that
   allows parametrization of the interface provided by BVRRouter */
typedef nx_struct {       //for AM_BVR_APP_P_MSG, carries application data multihop
  nx_uint8_t hopcount;
  Coordinates dest;
  nx_uint16_t dest_id;
  nx_uint16_t  origin;       //the originator of the message
  nx_uint8_t mode;           //most significant bit: fallback? other 7: current mode
  nx_uint16_t fallback_thresh; //the value of the main metric when entering fallback
  nx_uint8_t slot;           //added for demultiplexing
  nx_uint16_t msg_id;
  BVRData data;
}  BVRAppPData;




//sizeof = 3 + MAX_ROOT_BEACONS*3. For B=5, 3 + 15 = 18 bytes.
//For B=8, 3+24 = 27, B=12, 3+36 = 39
typedef nx_struct {
  nx_uint16_t seqno;        //the sequence number of my beacon messages
  BeaconInfo beacons[MAX_ROOT_BEACONS] ;
}  BVRBeaconMsgData;


//size: 4 + sizeof(BeaconMsgData). B=5, 22; B=8, 31, B=12, 43
typedef nx_struct BVR_Beacon_Msg {
  LEHeader header;
  BVRBeaconMsgData type_data;
}  BVRBeaconMsg;


typedef nx_struct BVR_Raw_Msg {
  LEHeader header;
} BVRRawMsg;


typedef nx_struct BVR_App_Msg{
  LEHeader header;
  BVRAppData type_data;
}  BVRAppMsg;

typedef nx_struct BVR_App_P_Msg{
  LEHeader header;
  BVRAppPData type_data;
}  BVRAppPMsg;


/***/
#endif  //BVR_ROUTING_H
