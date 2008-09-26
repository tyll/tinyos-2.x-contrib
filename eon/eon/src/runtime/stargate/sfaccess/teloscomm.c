
#include "teloscomm.h"
#include <pthread.h>

pthread_mutex_t mutex = PTHREAD_MUTEX_INITIALIZER;

const char *dbglevel[] = {"TELOSSOURCE","TINYRELY","APP"};

void hton_int16(uint8_t *buf, int16_t data)
{
  buf[0] = data & 0x00ff;
  buf[1] = (data >> 8) & 0x00ff;
}

void hton_int32(uint8_t *buf, int32_t data)
{
  buf[0] = data & 0x00ff;
  buf[1] = (data >> 8) & 0x00ff;
  buf[2] = (data >> 16) & 0x00ff;
  buf[3] = (data >> 24) & 0x00ff;
}

void hton_uint16(uint8_t *buf, uint16_t data)
{
  hton_int16(buf,data);
}

void hton_uint32(uint8_t *buf, uint32_t data)
{
  hton_int32(buf,data);
}

void ntoh_int16(uint8_t *buf, int16_t *data)
{
	*data = buf[0] | (buf[1] << 8);
}


void ntoh_int32(uint8_t *buf, int32_t *data)
{
	*data = ((int32_t)buf[0]) | 
			(((int32_t)buf[1]) << 8) | 
			(((int32_t)buf[2]) << 16) | 
			(((int32_t)buf[3]) << 24);
}

void ntoh_uint16(uint8_t *buf, uint16_t *data)
{
	ntoh_int16(buf,(int16_t*)data);
}

void ntoh_uint32(uint8_t *buf, uint32_t *data)
{
	ntoh_int32(buf,(int32_t*)data);
}



int dbg(int level, const char* format, ...)
{
	int val = 0;
#ifdef DEBUG
	va_list ap;
	
	pthread_mutex_lock(&mutex);
	va_start(ap, format);
	val = vprintf(format, ap);
	va_end(ap);
	pthread_mutex_unlock(&mutex);
#endif
	return val;
}
