#ifndef TEST_TTSP_H
#define TEST_TTSP_H

typedef nx_struct TestTtspMsg {
  nx_uint16_t srcAddr;
  nx_uint32_t globalTime;
  nx_uint32_t localTime;
  nx_int32_t offset;
  nx_uint32_t beaconId;
  nx_uint16_t rootId;
  nx_uint32_t syncPeriod;
  nx_uint32_t maxPrecisionError;
} TestTtspMsg_t;

typedef nx_struct BeaconTtspMsg
{
  nx_uint16_t srcAddr;
} BeaconTtspMsg_t;


enum
{
	AM_TESTTTSPMSG = 140
};

#endif