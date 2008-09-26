#ifndef _TELOSCOMM_H_
#define _TELOSCOMM_H_

#include <stdint.h>
#include <stdarg.h>
#include <stdio.h>

#define DEBUG

void hton_int16(uint8_t *buf, int16_t data);


void hton_int32(uint8_t *buf, int32_t data);

void hton_uint16(uint8_t *buf, uint16_t data);

void hton_uint32(uint8_t *buf, uint32_t data);


void ntoh_int16(uint8_t *buf, int16_t *data);


void ntoh_int32(uint8_t *buf, int32_t *data);

void ntoh_uint16(uint8_t *buf, uint16_t *data);

void ntoh_uint32(uint8_t *buf, uint32_t *data);

int dbg(int level, const char* format, ...);

enum {
	TSRC = 0,
	TRELY = 1,
	APP = 2
};



#endif
