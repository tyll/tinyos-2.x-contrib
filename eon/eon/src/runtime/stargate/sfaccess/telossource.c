
#include <stdlib.h>
#include <string.h>

#include <pthread.h>
#include "sfsource.h"
#include "telossource.h"
#include "teloscomm.h"



uint32_t platform;

uint8_t telos_dsn = 0;
pthread_mutex_t sfreadmutex = PTHREAD_MUTEX_INITIALIZER;
pthread_mutex_t sfwritemutex = PTHREAD_MUTEX_INITIALIZER;

int open_telos_source(const char *host, int port)
{
  int result;
  pthread_mutex_lock(&sfwritemutex);
  //add any telos specific code here
  result = open_sf_source(host,port);
  pthread_mutex_unlock(&sfwritemutex);
  return result;
}

extern uint32_t platform; 

int init_telos_source(int fd)

{
  int result;
  pthread_mutex_lock(&sfwritemutex);
  //add any telos specific code here
  result = init_sf_source(fd);
  pthread_mutex_unlock(&sfwritemutex);
  return result;
}

int free_telos_packet(telospacket **pkt)
{
	free((*pkt)->data);
	free(*pkt);
	*pkt = NULL;
	return 0;
}

telospacket *read_telos_packet(int fd)

{
  int length;
  telospacket *packet;
  int i;  
  const unsigned char *rawpkt;

  

  rawpkt = read_sf_packet(fd, &length);
	dbg(TSRC,"read_sf_packet returned (rawpkt=%X, length=%i).\n",(int)rawpkt, length);
	if (rawpkt == NULL)
	{
		dbg(TSRC,"rawpkt is NULL\n");
		return NULL;
	}
  
  if (length < 5)
    {
    	dbg(TSRC,"too short.\n");
      free((void*)rawpkt);
      return NULL;
    }

  packet = malloc(sizeof(telospacket));
  
  //get header information
  packet->length = rawpkt[2];
  packet->dsn = rawpkt[0];
  packet->type = rawpkt[4];
  packet->group = rawpkt[3];
  
  packet->data = malloc(packet->length);
  if (!packet->data)
  {
  	printf("Could not allocate memory!\n");
  	free(packet);
  }
  
  memcpy(packet->data, rawpkt+5, packet->length);
  free((void*)rawpkt);
  
  return packet;
}

int write_telos_packet(int fd, const telospacket *packet)
/* Effects: writes len byte packet to serial forwarder on file descriptor
     fd
   Returns: 0 if packet successfully written, -1 otherwise
*/
{
  unsigned char l;
  uint8_t *buffer;
  int result;
  int i;

  if (packet->length > 28) 
  {
  	dbg(TSRC,"packet too long! (%i bytes)\n",packet->length);
  	return -1;
  }

  buffer = malloc(packet->length + 5);
  buffer[0] = 0xff;
  buffer[1] = 0xff;
  buffer[2] = packet->type;
  //buffer[3] = telos_dsn;
  //telos_dsn++;
  buffer[3] = packet->group;
  buffer[4] = packet->length;
/*  buffer[6] = 0;
  buffer[7] = 0;
  buffer[8] = packet->type;
  buffer[9] = packet->group;*/
  memcpy(buffer+5, packet->data, packet->length);
  
  l = packet->length + 5;

	printf("Sending...");
	for (i=0; i < l; i++)
	{
		printf("%X ",buffer[i]);
	}
	printf("\n");
  pthread_mutex_lock(&sfwritemutex);
  result = write_sf_packet(fd, (void*)buffer, packet->length+5);

  pthread_mutex_unlock(&sfwritemutex);

  free((void*)buffer);

  return result;
}
