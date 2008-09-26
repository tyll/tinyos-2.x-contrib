#include "tinystream.h"
#include <string.h>
#include <unistd.h>

#define TS_BUFSIZE  5000

uint8_t ts_buffer[TS_BUFSIZE];
pthread_mutex_t read_mutex = {0, 0, 0, PTHREAD_MUTEX_RECURSIVE_NP, __LOCK_INITIALIZER};
int bufhead = 0;
int buftail = 0;
bool all_abort = FALSE;

bool pushbyte(uint8_t data);
bool popbyte(uint8_t *data);

//recv callback
void tinystream_cb(int id, uint8_t *data, int length)
{
	int i, count;
	bool result = FALSE;
	
	pthread_mutex_lock(&read_mutex);
	for (i=0; i < length; i++)
	{
		result = FALSE;
		count = 0;
		while (!result)
		{
			result = pushbyte(data[i]);
			if (!result)
			{
				pthread_mutex_unlock(&read_mutex);
				count++;
				usleep(50000);//rest 50ms
				if (count > 100)
				{
					dbg(TSRC,"Callback probably deadlocked.\n");	
				}
				pthread_mutex_lock(&read_mutex);
			}			
		}
	}	
	pthread_mutex_unlock(&read_mutex);
}


bool pushbyte(uint8_t data)
{
	unsigned int nextbyte;
	
	nextbyte = (buftail + 1) % TS_BUFSIZE;
	if (nextbyte == bufhead)
	{
		//full
		dbg(TSRC,"buffer full!\n");
		return FALSE;
	}
	ts_buffer[buftail] = data;
	buftail = nextbyte;
	dbg(TSRC,"(< %02x)",data);
	return TRUE;
}

bool popbyte(uint8_t *data)
{
	if (bufhead == buftail)
	{
		//empty
		return FALSE;
	}	
	*data = ts_buffer[bufhead];
	bufhead = (bufhead + 1) % TS_BUFSIZE;
	dbg(TSRC,"(> %02x)",*data);
	return TRUE;
}

bool peekbyte(uint8_t *data)
{
	if (bufhead == buftail)
	{
		//empty
		return FALSE;
	}	
	*data = ts_buffer[bufhead];
	return TRUE;
}


int tinystream_init(const char* host, int port)
{
	all_abort = FALSE;
	pthread_mutex_lock(&read_mutex);
	memset(&ts_buffer, 0, sizeof(ts_buffer));
	bufhead = 0;
	buftail = 0;
	pthread_mutex_unlock(&read_mutex);
	return tinyrely_init(host,port);
}

int tinystream_close()
{
	all_abort = TRUE;
	return tinyrely_destroy();
}


int tinystream_connect(int address)
{
	return tinyrely_connect(tinystream_cb, address);
}

int tinystream_read(int id, uint8_t *buf, int length)
{
	int i, count;
	bool result = FALSE;
	
	pthread_mutex_lock(&read_mutex);
	dbg(TSRC,"tstream_read(%i)...",length);
	for (i=0; i < length; i++)
	{
		result = FALSE;
		count = 0;
		while (!result)
		{
			result = popbyte(&buf[i]);

			if (!result)
			{
				pthread_mutex_unlock(&read_mutex);
				if (all_abort)
				{
					return -1;
				}
				count++;
				usleep(50000);//rest 50ms
				if (count > 200 && i > 0)
				{
					dbg(TSRC,"tinyrely_read probably dead.\n");	
				}
				pthread_mutex_lock(&read_mutex);
			} else {
				dbg(TSRC," %02x ",buf[i]);
			}		
		}
	}
	dbg(TSRC,"...\n");
	pthread_mutex_unlock(&read_mutex);
	return 0;
}

int tinystream_peek(int id, uint8_t *abyte)
{
	bool result = FALSE;
	
	pthread_mutex_lock(&read_mutex);
	
	result = FALSE;
	
	while (!result)
	{
		result = peekbyte(abyte);

		if (!result)
		{
			pthread_mutex_unlock(&read_mutex);
			if (all_abort)
			{
				return -1;
			}
			usleep(50000);//rest 50ms
			
			pthread_mutex_lock(&read_mutex);
		}			
	}	
	pthread_mutex_unlock(&read_mutex);
	return 0;
}

int tinystream_write(int id, const uint8_t *buf, int length)
{
	return tinyrely_send(id, buf, length);
}

int tinystream_close_connection(int id)
{
	return tinyrely_close(id);	
}

