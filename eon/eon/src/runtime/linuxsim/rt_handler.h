#ifndef _RT_HANDLER_H_
#define _RT_HANDLER_H_

#include <stdint.h>
#include "rt_structs.h"

int isFunctionalState(int8_t state);

void reportError(uint16_t nodeid, uint8_t error, rt_data _pdata);


void reportExit(rt_data _pdata);

int getNextSession();
int sendPathStartPacket(int id);

unsigned int get_timer_interval(int source);


#endif
