#ifndef RT_STRUCTS_H_INCLUDED
#define RT_STRUCTS_H_INCLUDED

#include "../nodes.h"


typedef struct rt_data
{
  uint16_t sessionID;
  uint32_t starttime;
  uint16_t weight;
  uint8_t minstate;
  uint8_t wake;
  uint32_t elapsed_us;
} rt_data;

typedef struct GenericNode
{
  rt_data _pdata;
} GenericNode;

#define RTCLOCKINTERVAL (60L * 1024L)
#define EVALINTERVAL (60L*60L * 1024L)
//#define EVALINTERVAL (60L * 1024L)

//save runtime data every hour
//#define RT_SAVE_TIME (3L * 60L * 60L * 1024L)
#define RT_SAVE_TIME (60L * 1024L)
#define RT_RECOVER_TIME (15L * 1024L)
//typedef uint8_t request_t[50];
#define LOAD_WEIGHT (0.04)

enum {
BATTERY_CAPACITY = (200LL * 360LL * 37LL * 1000LL) //uJ
};


typedef struct __runtime_state
{
  	uint16_t save_flag;
	double load_avg;
	uint8_t srcprob[NUMSOURCES];
	uint8_t prob[NUMPATHS];
	int32_t pathenergy[NUMPATHS];
	int64_t batt_reserve;
} __runtime_state_t;

__runtime_state_t __rtstate;

uint16_t *g_lastmem = (uint16_t*)3967;
uint16_t deadlocked_edge_id = 0xFFFF;
int16_t alloc_size = 0xFFFF;
uint16_t rt_clock = 0;
int save_state;
int save_retries;

void *queue_ptr = NULL;

#define MAX_SAVE_RET	10
#define SAVE_PAGE 510


//#ifdef RUNTIME_TEST
#include "AM.h"
TOS_Msg __rt_send_buf;

//#endif
#endif
