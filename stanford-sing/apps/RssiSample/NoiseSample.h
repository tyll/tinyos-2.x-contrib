/******************************************************************
    NoiseSample.h created by HyungJune Lee (abbado@stanford.edu)
 ******************************************************************/

#ifndef _NOISESAMPLE_H_
#define _NOISESAMPLE_H_


enum
{
	ALARM_PERIOD = 32, //i.e. 1KHz
	AM_RSSI_SAMPLE_MSG = 6,
	BUF_SIZE = 512,
	TOTAL_SIZE = 1024,
	FLASH_ADDR = 0x00,
};

typedef nx_struct rssi_sample_msg {
	nx_uint16_t nodeId;
	nx_uint32_t seqNo;
	nx_uint8_t rssiVal;
} rssi_sample_msg;

#endif
