#ifndef TIMESYNC_H
#define TIMESYNC_H

enum {
	TIMESYNC_TABLE_MAX_ENTRIES = 8,
	TIMESYNC_TABLE_VALID_ENTRIES_LIMIT = 4,
	TIMESYNC_DEFAULT_ROOT_ID = 1,
	TIMESYNC_IGNORE_ROOT_MSG = 4,
};

typedef struct SyncPoint {
	uint32_t localTime;
	int32_t timeOffset;
} SyncPoint_t;

typedef struct TableItem {
	SyncPoint_t syncPoint;
	int32_t timeError;
	bool isEmpty;
} TableItem_t;

#endif