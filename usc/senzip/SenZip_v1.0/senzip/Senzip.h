/*
 * @ author        Sundeep Pattem
 * @ affiliation   Autonomous Networks Research Group
 * @ institution   University of Southern California
*/

#ifndef SENZIP_H
#define SENZIP_H

#include <message.h>

#define AGG_BEACON_INTERVAL 50
#define COMP_PACKET_COUNT 20
#define MAX_NUM_CHILDREN 10

enum {
  AM_SENZIP_AGG_HEADER = 40,
  AM_SENZIP_START_MSG = 45,
  AM_TRIALLOG = 20,

};

enum {
  AGG_TABLE_SIZE = 10,
  AGG_BEACON_COUNT = 10,
};

typedef struct {
  message_t msg;
  uint16_t dest;
} agg_queue_entry_t;

typedef nx_struct senzip_agg_header {
  nx_uint8_t  type;
  nx_uint16_t src;
  nx_uint8_t  relPos;
  nx_uint8_t  hops;
  nx_uint16_t  forNode;
  nx_uint8_t  weight;
  //nx_uint16_t childIds[MAX_NUM_CHILDREN];
  //nx_uint8_t numGrandchildren[MAX_NUM_CHILDREN];
} agg_header_t;

// start

enum {
  FLOOD_START = 1,
  QUERY_PARENT_START = 2,
  REPLY_PARENT_START = 3,
};

typedef nx_struct senzip_start_msg {
  nx_uint8_t type;          
  nx_uint8_t epochNumber;
} senzip_start_msg_t;

typedef nx_struct TrialLog{
  nx_uint16_t sender;
  nx_uint16_t receiver;  
  nx_uint8_t type;
  nx_uint8_t counter;
} TrialLog;



#endif
