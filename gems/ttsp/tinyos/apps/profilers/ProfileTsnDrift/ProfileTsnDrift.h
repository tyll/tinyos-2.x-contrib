#ifndef PROFILE_TSN_DRIFT_H
#define PROFILE_TSN_DRIFT_H

typedef nx_struct ReportMsg {
  nx_uint16_t srcAddr;
  nx_uint32_t refId;
  nx_uint32_t localTimestamp;
  nx_uint32_t refTimestamp;
  nx_uint32_t temperature;
} ReportMsg_t;

enum {
	AM_REPORTMSG = 181
};

#endif