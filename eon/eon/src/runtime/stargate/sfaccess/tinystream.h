#ifndef _TINYSTREAM_H_
#define _TINYSTREAM_H_

#include "teloscomm.h"
#include "tinyrely.h"





int tinystream_init(const char* host, int port);
int tinystream_close();
int tinystream_connect();
int tinystream_close_connection(int id);
int tinystream_read(int id, uint8_t *buf, int length);
int tinystream_write(int id, const uint8_t *buf, int length);
//allow you to peek at the next byte in the buffer
int tinystream_peek(int id, uint8_t *byte);

#endif
