#ifndef _RT_MARSHALL_H_
#define _RT_MARSHALL_H_


#include "rt_structs.h"
#include "../usermarshall.h"

#define TYPE_START  0
#define TYPE_END    1
#define TYPE_UINT8  2
#define TYPE_UINT16 3
#define TYPE_UINT32 4
#define TYPE_INT8   5
#define TYPE_INT16  6
#define TYPE_INT32  7

#define MARSH_OK   0
#define MARSH_ERR  1
#define MARSH_FULL 2
#define MARSH_WAIT 3
#define MARSH_TYPE 4


int unmarshall_start(int cid, uint16_t *nodeid);
int unmarshall_end(int cid, uint16_t *nodeid);
int unmarshall_session(int cid, rt_data *_pdata);
int unmarshall_uint8_t(int cid, uint8_t *data);
int unmarshall_int8_t(int cid, int8_t *data);
int unmarshall_uint16_t(int cid, uint16_t *data);
int unmarshall_int16_t(int cid, int16_t *data);
int unmarshall_uint32_t(int cid, uint32_t *data);
int unmarshall_int32_t(int cid, int32_t *data);

int unmarshall_bool(int cid, bool *data);
int unmarshall_request_t(int cid, request_t* data);

int marshall_start(int cid, uint16_t nodeid);
int marshall_session(int cid, rt_data _pdata);
int marshall_int8_t(int cid, int8_t data);
int marshall_uint8_t(int cid, uint8_t data);
int marshall_int16_t(int cid, int16_t data);
int marshall_uint16_t(int cid, uint16_t data);
int marshall_int32_t(int cid, int32_t data);
int marshall_uint32_t(int cid, uint32_t data);
int marshall_char(int cid, char data);
int marshall_bool(int cid, bool data);
int marshall_request_t(int cid, request_t data);

#endif
