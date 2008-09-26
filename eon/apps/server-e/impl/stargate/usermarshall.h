#ifndef USERMARSHAL_H_INCLUDED
#define USERMARSHAL_H_INCLUDED

#include "ServerE.h"

//int marshall_RequestMsg(int cid, RequestMsg data);
int unmarshall_RequestMsg(int cid, RequestMsg *data);

#endif
