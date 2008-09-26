#include "userstructs.h"
//includes userstructs;

interface ICache
{
	command result_t get(StatusMsg_t *msg);
	command result_t put(StatusMsg_t *msg);
	command result_t setStatus(int s);
	command int getStatus();
}
