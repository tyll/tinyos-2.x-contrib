#ifndef RT_STRUCTS_H_INCLUDED
#define RT_STRUCTS_H_INCLUDED

#include "nodes.h"


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

#define SRC_QUEUE_SIZE 3

#define RTCLOCKSEC (5L)
#define RTCLOCKINTERVAL (RTCLOCKSEC * 1024L)
#define EVALINTERVAL (60L*60L * 1024L)
//#define EVALINTERVAL (5L * 60L * 1024L)

//save runtime data every 3 hours
#define RT_SAVE_SEC  (60L * 60L * 3L)
#define RT_SAVE_TIME (RT_SAVE_SEC * 1024L)

#define RT_RECOVER_TIME (15L * 1024L)
//typedef uint8_t request_t[50];
#define LOAD_WEIGHT (0.04)


#ifndef BATTERY_SIZE
#warning 'Using default battery size (200mAhr)'
#define BATTERY_SIZE (200LL * 360LL * 37LL * 1000LL) //uJ
#else
#warning 'Using CUSTOM battery size.'
#endif

uint64_t BATTERY_CAPACITY = BATTERY_SIZE;


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
	int32_t clock;
} __runtime_state_t;

__runtime_state_t __rtstate;

//uint16_t *g_lastmem = (uint16_t*)3967;
//uint16_t deadlocked_edge_id = 0xFFFF;
//int16_t alloc_size = 0xFFFF;
uint32_t rt_clock = 0;
bool booted = TRUE;
int save_state;
int save_retries;
int16_t last_volts = 0;

void *queue_ptr = NULL;

#define MAX_SAVE_RET	10
#define SAVE_PAGE 0

#endif
