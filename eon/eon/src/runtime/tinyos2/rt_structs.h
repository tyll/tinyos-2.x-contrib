#ifndef RT_STRUCTS_H_INCLUDED
#define RT_STRUCTS_H_INCLUDED


#include "nodes.h"
#include "eon_network.h"


#define SRC_QUEUE_SIZE 3



typedef struct rt_data
{
  uint16_t sessionID;
  uint16_t weight;
  uint8_t minstate;
} rt_data;

typedef struct GenericNode
{
  rt_data _pdata;
} GenericNode;

#define RTCLOCKINTERVAL (60L * 1024L)
#define EVALINTERVAL (60L*60L * 1024L)
//#define EVALINTERVAL (60L * 1024L)

//save runtime data every hour
#define RT_SAVE_TIME (3L * 60L * 60L * 1024L)
//#define RT_SAVE_TIME (60L * 1024L)
#define RT_RECOVER_TIME (10L * 1024L)
//typedef uint8_t request_t[50];
#define LOAD_WEIGHT (0.04)

enum {
//BATTERY_CAPACITY = (200LL * 360LL * 37LL * 1000LL), //uJ
BATTERY_CAPACITY = (600LL * 360LL * 37LL * 1000LL), //uJ
};


typedef struct __runtime_state
{
  	uint16_t save_flag;
	double load_avg;
	uint8_t srcprob[NUMSOURCES];
	uint8_t spc[NUMSOURCES];
	uint8_t prob[NUMPATHS];
	uint8_t pc[NUMPATHS];
	int32_t pathenergy[NUMPATHS];
	int64_t batt_reserve;
	uint8_t curstate;
	double curgrade;
} __runtime_state_t;



//__runtime_state_t __rtstate;

//uint16_t *g_lastmem = (uint16_t*)3967;
//uint16_t deadlocked_edge_id = 0xFFFF;
//int16_t alloc_size = 0xFFFF;
//uint16_t rt_clock = 0;
//int save_state;
//int save_retries;

//void *queue_ptr = NULL;

//#define MAX_SAVE_RET	10
//#define SAVE_PAGE 0

#endif
