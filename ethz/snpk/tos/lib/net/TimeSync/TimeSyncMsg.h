/*
 * Copyright (c) 2007, ETH Zuerich
 * All rights reserved.
 * Author: Min Guo
 */

#ifndef TIMESYNCMSG_STRUCT
#define TIMESYNCMSG_STRUCT

typedef nx_struct TimeSyncMsg
{

    nx_uint16_t   rootID;          // the node id of the synchronization root
    nx_uint8_t    seqNum;          // sequence number for the root
    nx_int32_t    offsetAverage;
    nx_uint32_t   localAverage;
    nx_int8_t     skewInt;
    nx_uint32_t   skewFloat;
    nx_uint32_t   sendingTime;     // the local time when the message is prepared for sending
    nx_uint16_t   dummyOffset;     // the real local time when the message is sent

} TimeSyncMsg;

enum {
    AM_TIMESYNCMSG = 0xEE,
};

#endif
