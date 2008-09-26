
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

  //make sure I'm the only one reading the serial port
  //pthread_mutex_lock(&sfreadmutex);

  rawpkt = read_sf_packet(fd, &length);
	dbg(TSRC,"read_sf_packet returned (rawpkt=%X, length=%i).\n",(int)rawpkt, length);
	if (rawpkt == NULL)
	{
		dbg(TSRC,"rawpkt is NULL\n");
		return NULL;
	}
       	printf("Got data...\n");
  for (i=0; i < length; i++)
    printf("%X ", rawpkt[i]);
  printf("\nGet done.\n");
  //pthread_mutex_unlock(&sfreadmutex);

  if (length < 10)
    {
    	dbg(TSRC,"too short.\n");
      free((void*)rawpkt);
      return NULL;
    }

  packet = malloc(sizeof(telospacket));
  
  //get header information
  packet->length = rawpkt[0];
  packet->dsn = rawpkt[3];
  packet->type = rawpkt[8];
  packet->group = rawpkt[9];
  packet->addr = rawpkt[6] | (rawpkt[7] << 8);
  packet->data = malloc(packet->length);
  if (!packet->data)
  {
  	printf("Out of memory!\n");
  	free(packet);
  }
  printf("addr=%X\n",packet->addr);
  memcpy(packet->data, rawpkt+10, packet->length);
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

  if (packet->length > TOS_DATA_LENGTH) 
  {
  	dbg(TSRC,"packet too long! (%i bytes)\n",packet->length);
  	return -1;
  }

  buffer = malloc(packet->length + 10);
  buffer[0] = packet->length;
  buffer[1] = 0x01;
  buffer[2] = 0x08;
  buffer[3] = telos_dsn;
  telos_dsn++;
  buffer[4] = 0xff;
  buffer[5] = 0xff;
  buffer[6] = packet->addr & 0x0F;
  buffer[7] = (packet->addr >> 8) & 0x0F;
  buffer[8] = packet->type;
  buffer[9] = packet->group;
  memcpy(buffer+10, packet->data, packet->length);

  printf("Sending data...\n");
  for (i=0; i < packet->length + 10; i++)
    printf("%X ", buffer[i]);
  printf("\nSend done.\n");

  l = packet->length + 10;

  pthread_mutex_lock(&sfwritemutex);

  result = write_sf_packet(fd, (void*)buffer, packet->length+10);

  pthread_mutex_unlock(&sfwritemutex);

  free((void*)buffer);

  return result;
}
