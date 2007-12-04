#ifndef _CAMERA_H_
#define _CAMERA_H_

#define BASE_FRAME_ADDRESS	(0xa0000000)
#define MAX_PART_LEN		64
#define TOSH_DATA_LENGTH  MAX_PART_LEN+2

enum {
	AM_FRAME_PART = 1,
	AM_OV_DBG = 2,
	AM_PXA_DBG = 3,
	AM_CMD = 4	
};

typedef nx_struct frame_part{
	nx_uint16_t part_id;
	nx_uint8_t buf[MAX_PART_LEN];
} frame_part_t;

typedef nx_struct {
	nx_uint16_t part_id;
	nx_uint16_t send_next_n_parts;
} frame_part_request_t;

typedef nx_struct {
	nx_uint8_t cmd;
	nx_uint16_t val1;
	nx_uint16_t val2;
} cmd_msg_t;

typedef nx_struct {
	nx_uint32_t addr;
	nx_uint32_t reg_val;
} dbg_msg32_t;

typedef nx_struct {
	nx_uint8_t addr;
	nx_uint8_t reg_val;
} dbg_msg8_t;

#endif //_CAMERA_H_
