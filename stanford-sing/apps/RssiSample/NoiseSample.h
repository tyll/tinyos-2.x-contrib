/******************************************************************
    NoiseSample.h created by HyungJune Lee (abbado@stanford.edu)
 ******************************************************************/

#ifndef _NOISESAMPLE_H_
#define _NOISESAMPLE_H_


enum
{
	ALARM_PERIOD = 32, //i.e. 1KHz
	AM_SERIAL_ID = 6,
	BUF_SIZE = 512,
	TOTAL_SIZE = 1048576,
	FLASH_ADDR = 0x00,
};

typedef nx_struct rssi_sample_msg {
	nx_uint16_t NodeId;
	nx_uint32_t SeqNo;
	nx_uint8_t RssiVal;
} rssi_sample_msg;

#endif
