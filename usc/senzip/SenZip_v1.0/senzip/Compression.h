/*
 * @ author        Sundeep Pattem
 * @ affiliation   Autonomous Networks Research Group
 * @ institution   University of Southern California
*/

#ifndef _COMPRESSION_H
#define _COMPRESSION_H

#include <message.h>

#define COMP_RX_DELAY 1000
#define LOST_PKT_THRESHOLD 2

#define SEND_TASK_DELAY 100

#define NUM_MEASUREMENTS 3
#define MAX_SEQ_NUM 256

#define BIT_WIDTH 16
#define BIT_ALLOCATION 5
#define QUANTIZATION_FACTOR (1<<BIT_ALLOCATION)


enum {
  AM_SENZIP_COMP_MSG = 33,
};

/* aggregation */

enum {
  UP = 1,
  DOWN = 2,
  NOT_FOUND = 0xFF,
};

/* initial inputs to routing */
enum {
  ETX = 1,
  UPSTREAM_HOPS = 1,
  DOWNSTREAM_HOPS = 1,
};

/* beacon types */
enum {
  ADD = 1,
  DELETE = 2,
  SEND_PARENT_INFO = 3,
  PARENT_INFO = 4,
  ALL_INFO = 5,
};

typedef struct {
  uint16_t  currParent;
  uint16_t  prevParent;
  uint8_t   hopCount;
  uint8_t   numChildren;
} self_info;

/* aggregation table */

typedef struct {
  uint16_t  id;
  uint8_t   bitAllocation;
  uint8_t   currentSeqNo;
  uint8_t   memoryIndex;
} node_info;

typedef struct {
  uint8_t   upstrOneHopNbrhoodSize;
  uint8_t   downstrOneHopNbrhoodSize;
} weight_attr;

struct table_entry {
  node_info       nodeInfo; 
  weight_attr     weight;
  uint8_t         upstrFurtherHops;
  uint8_t         downstrFurtherHops;
  struct table_entry *upstrNeighborEntry[MAX_NUM_CHILDREN];
  struct table_entry *downstrNeighborEntry[MAX_NUM_CHILDREN];
}; 

typedef struct table_entry agg_table_entry_t;

typedef struct {
  agg_table_entry_t *parent;
  uint8_t offset;
} entry_position;


/* compression */

enum {
  TEMPORAL_ONLY = 1,
  SPATIO_TEMPORAL = 2,
};

enum {
  RAW = 10,
  FULL = 11,
  COEFF_M1 = 1,
};

enum {
  PARENT = 1,
  ADD_CHILD = 2,
  DELETE_CHILD = 3,
};


enum {
  CHILD = 1,
  GRANDCHILD = 2,
};

typedef struct {
  bool parent;
  bool child;
} changes;

typedef struct {
  int16_t partial[2*(BIT_WIDTH/BIT_ALLOCATION)*NUM_MEASUREMENTS];
  int16_t full[2*NUM_MEASUREMENTS];
} buffer_t;

typedef struct {
  uint8_t id;
  uint8_t count;
  uint8_t base;
  uint8_t seqNum;
  uint8_t lastSeqHeard;
  int16_t min;
  int16_t max;
  bool mark;
  buffer_t *store;
} buffer_entry_t;


typedef struct {
  message_t msg;
} comp_queue_entry_t;

typedef nx_struct senzip_comp_msg {
  nx_int16_t data[NUM_MEASUREMENTS];
  nx_uint8_t type;
  nx_uint8_t src;
  nx_uint8_t parent;
  nx_uint8_t seq;
  nx_int16_t max;
  nx_int16_t min;
} comp_msg_t;


#endif
