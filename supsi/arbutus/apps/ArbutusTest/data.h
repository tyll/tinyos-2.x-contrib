/*
 * Copyright (c) 2006 Intel Corporation
 * All rights reserved.
 *
 * This file is distributed under the terms in the attached INTEL-LICENSE     
 * file. If you do not find these files, copies can be found by writing to
 * Intel Research Berkeley, 2150 Shattuck Avenue, Suite 1300, Berkeley, CA, 
 * 94704.  Attention:  Intel License Inquiry.
 */

/**
 * @author David Gay
 * @author Kyle Jamieson
 * @author Phil Levis
 */

#ifndef DATA_H
#define DATA_H

#define CC2420_DEF_RFPOWER 31 //3


#include "AM.h"

enum {
  /* Default sampling period. */
    
 //30, //5,   
    
    
  DEFAULT_INTERVAL = 10240,
  WATERMARK_1=9,
  BASE_STATION_ADDRESS = 75,
  MAX_RETX = 30,
  PLAIN_RETX = 30,
    
  AM_DATA_MSG = 0x93,
  AM_STATS_MSG   = 0x88,
  AM_ENTRY_MSG   = 0x38,
      
  NODES=200,
      
  RNP_CHECK=10,
      
};

uint32_t  BEACON_PERIOD = 60;
bool useRoutingTable=FALSE;
bool onsetDetection = TRUE;
bool dynamic=FALSE;
bool LoadBalancing = FALSE;
bool constrained = FALSE;





typedef nx_struct data_msg {
  nx_uint16_t sourceaddr;
  nx_uint16_t originaddr;
  nx_uint16_t originalSequenceNumber;
  nx_uint16_t packetTransmissions;
  nx_uint16_t totalOwnTraffic;
  nx_uint16_t totalRelayedTraffic;
  nx_uint8_t hopcount;
  nx_uint16_t localLoad;
} data_msg_t;





typedef nx_struct stats_msg {
  nx_uint16_t parent;
  nx_uint16_t hopcount;
  nx_uint8_t queueOccupancy;
  nx_uint8_t controlState;
  nx_uint16_t dataTraffic_rx;
  nx_uint16_t controlTraffic_rx;
  nx_uint16_t controlTraffic_tx;
  nx_bool loop;
  nx_bool localCongestion;
  nx_bool pinParent;
} stats_msg_t;


typedef nx_struct entry_msg{
 nx_uint16_t node;  
   nx_uint8_t local_hopcount;  
 nx_uint8_t local_adjustedHopcount;    
nx_uint16_t ll_addr;
  nx_uint16_t isParent;
  nx_uint8_t preferredParent;
    nx_uint16_t formerParent;
  nx_uint16_t beaconerParent;
    nx_uint8_t beaconer_hopcount;
  nx_uint8_t lastseq;
  //nx_uint8_t rcvcnt;
  //nx_uint8_t failcnt;
  nx_uint8_t flags;
  nx_uint8_t rss;
  nx_uint8_t lqi;
  nx_uint8_t rssBottleneck;
  nx_uint8_t lqiBottleneck;
  nx_uint16_t rnp;
  nx_uint8_t freaky;
  nx_uint16_t metric;
  nx_uint8_t tableIndex;
    nx_uint8_t controlState;
} entry_msg_t;





#endif
