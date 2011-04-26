#ifndef TIMESYNC_MSG_H
#define TIMESYNC_MSG_H

typedef nx_struct TtspMsg
{
	nx_uint16_t	rootID;		// rootId
	nx_uint16_t	nodeID;		// nodeId
	nx_uint8_t	seqNum;		// sequence number for the root
	nx_uint32_t	globalTime;
	nx_uint32_t localTime;
	nx_uint32_t syncPeriod;
} TtspMsg;

enum {
	TIMESYNCMSG_LEN = sizeof(TtspMsg) - sizeof(nx_uint32_t),
	AM_TTSPMSG = 133
};

#endif
