#include <stdio.h>
#include <pthread.h>
#include <stdlib.h>
#include <stdint.h>
//#include <curses.h>

#include <ctype.h>
#include <limits.h>
#include <string.h>

#include <sys/types.h>

#include "sfsource.h"

#ifndef TOSH_DATA_LENGTH
#define TOSH_DATA_LENGTH 29
#define BUNDLE_ACK_DATA_LENGTH	TOSH_DATA_LENGTH-2
#endif

#ifndef _REENTRANT
#define _REENTRANT
#endif

#ifndef FALSE
#define FALSE 0
#endif
 
#ifndef TRUE
//#define TRUE (! FALSE)
#define TRUE -1
#endif

#define SRC_ADDR	1


#define	AM_BEGIN_TRAVERSAL_MSG 17
#define	AM_GO_NEXT_MSG 18
#define	AM_GET_NEXT_CHUNK 19
#define	AM_GET_BUNDLE_MSG 20
#define	AM_DELETE_BUNDLE_MSG 21
#define	AM_END_DATA_COLLECTION_SESSION 22
#define	AM_BUNDLE_INDEX_ACK 23

///////////////////////////////////////////////////////////////////////////////////////////////////
// TYPEDEFS
///////////////////////////////////////////////////////////////////////////////////////////////////

typedef struct TOS_Msg
{
	uint16_t addr;
	uint8_t type;
	uint8_t group;
	uint8_t length;
	int8_t data[TOSH_DATA_LENGTH];
	uint16_t crc;
} TOS_Msg;

typedef uint8_t bool;

///////////////////////////////////////////////////////////////////////////////////////////////////
// TINYOS COMM STRUCTS
///////////////////////////////////////////////////////////////////////////////////////////////////
typedef struct BeginTraversalMsg {
	uint16_t src_addr;
	uint8_t seq_num;
} BeginTraversalMsg_t;

typedef struct GoNextMsg {
	uint16_t src_addr;
	uint8_t seq_num;
} GoNextMsg_t;

typedef struct GetBundleMsg {
	uint16_t src_addr;
	uint8_t seq_num;
} GetBundleMsg_t;

typedef struct DeleteBundleMsg {
	uint16_t src_addr;
	uint8_t seq_num;
} DeleteBundleMsg_t;

typedef struct BundleIndexAck {
	uint16_t src_addr;
	bool success;
	uint8_t seq_num;
	char data[BUNDLE_ACK_DATA_LENGTH];
} BundleIndexAck_t;

typedef struct GetNextChunk{
	uint16_t src_addr;
	uint8_t seq_num;
} GetNextChunk_t;

typedef struct EndCollectionSession{
	uint16_t src_addr;
	uint8_t seq_num;
} EndCollectionSession_t;

///////////////////////////////////////////////////////////////////////////////////////////////////
// WRAPPERS
///////////////////////////////////////////////////////////////////////////////////////////////////
typedef struct w_BT {
	uint16_t addr;
	uint8_t type;
	uint8_t group;
	uint8_t length;
	uint16_t src_addr;
	uint8_t seq_num;
} w_BT_t;


typedef struct w_GN {
	uint16_t addr;
	uint8_t type;
	uint8_t group;
	uint8_t length;
	uint16_t src_addr;
	uint8_t seq_num;
} w_GN_t;

typedef struct w_GB {
	uint16_t addr;
	uint8_t type;
	uint8_t group;
	uint8_t length;
	uint16_t src_addr;
	uint8_t seq_num;
} w_GB_t;

typedef struct w_DB {
	uint16_t addr;
	uint8_t type;
	uint8_t group;
	uint8_t length;
	uint16_t src_addr;
	uint8_t seq_num;
} w_DB_t;

typedef struct w_GNC {
	uint16_t addr;
	uint8_t type;
	uint8_t group;
	uint8_t length;
	uint16_t src_addr;
	uint8_t seq_num;
} w_GNC_t;

typedef struct w_ECS {
	uint16_t addr;
	uint8_t type;
	uint8_t group;
	uint8_t length;
	uint16_t src_addr;
	uint8_t seq_num;
} w_ECS_t;


typedef struct gen_msg {
	uint16_t addr;
	uint8_t type;
	uint8_t group;
	uint8_t length;
	uint16_t src_addr;
	uint8_t seq_num;
} gen_msg_t;

#pragma pack(1)
typedef struct TOS_write
{
	int fd;
	int mote_addr;
} TOS_write_t;

#define TOS_MSG_SIZE 2*sizeof(uint16_t) + 4*sizeof(uint8_t)

void* get_packet( gen_msg_t *tos)
{
	void *ret = malloc(TOS_MSG_SIZE);
	
	int offset = 0;
	memcpy(ret+offset, &tos->addr, sizeof(uint16_t) );
	offset += sizeof(uint16_t);
	memcpy(ret+offset, &tos->type, sizeof(uint8_t) );
	offset += sizeof(uint8_t);
	memcpy(ret+offset, &tos->group, sizeof(uint8_t) );
	offset += sizeof(uint8_t);
	memcpy(ret+offset, &tos->length, sizeof(uint8_t) );
	offset += sizeof(uint8_t);
	memcpy(ret+offset, &tos->src_addr, sizeof(uint16_t) );
	offset += sizeof(uint16_t);
	memcpy(ret+offset, &tos->seq_num, sizeof(uint8_t) );
	
	return ret;
}

void* mote_write(void *buf)
{
	TOS_write_t *tos = (TOS_write_t *) buf;
	uint8_t seq_num = 0;
	gen_msg_t msg;
	char *my_string;
	int nbytes = 100;
	int bytes_read;
	
	msg.addr = tos->mote_addr;
	msg.group = 0x7d;
	msg.length = sizeof(uint16_t)+sizeof(uint8_t);
	msg.src_addr = SRC_ADDR;
	
	printf("What would you like to do: \n");
	printf("bd: Bundle Delete \n");
	printf("gb: Get Bundle \n");
	printf("gc: Get Next Chunk \n");
	printf("bt: Begin Traversal \n");
	printf("gn: Go Next \n");
	printf("ec: End Collection Session\n");
	
	while (1)
	{
		int w_ret = 0;
		void *data; 
		my_string = (char *) malloc (nbytes + 1);
		bytes_read = getline (&my_string, &nbytes, stdin);
		
		if (my_string[0] == 's' && my_string[1] == 'n')
		{
			seq_num++;
			printf ("Sequence Number incremented: %d\n",seq_num);
		}
		if (my_string[0] == 'b' && my_string[1] == 'd')
		{
			
			msg.seq_num = seq_num;
			msg.type = AM_DELETE_BUNDLE_MSG;
			data = get_packet(&msg);
			w_ret = write_sf_packet(tos->fd, data, TOS_MSG_SIZE);
			free(data);
			
		}
		if (my_string[0] == 'g' && my_string[1] == 'b')
		{
			msg.seq_num = seq_num;
			msg.type = AM_GET_BUNDLE_MSG;
			data = get_packet(&msg);
			w_ret = write_sf_packet(tos->fd, data, TOS_MSG_SIZE);
			free(data);
		}
		if (my_string[0] == 'g' && my_string[1] == 'c')
		{
			msg.seq_num = seq_num;
			msg.type = AM_GET_NEXT_CHUNK;
			data = get_packet(&msg);
			w_ret = write_sf_packet(tos->fd, data, TOS_MSG_SIZE);
			free(data);
		}
		if (my_string[0] == 'b' && my_string[1] == 't')
		{
			msg.seq_num = seq_num;
			msg.type = AM_BEGIN_TRAVERSAL_MSG;
			data = get_packet(&msg);
			w_ret = write_sf_packet(tos->fd, data, TOS_MSG_SIZE);
			free(data);
		}
		if (my_string[0] == 'g' && my_string[1] == 'n')
		{
			msg.seq_num = seq_num;
			msg.type = AM_GO_NEXT_MSG;
			data = get_packet(&msg);
			w_ret = write_sf_packet(tos->fd, data, TOS_MSG_SIZE);
			free(data);
		}
		if (my_string[0] == 'e' && my_string[1] == 'c')
		{
			msg.seq_num = seq_num;
			msg.type = AM_END_DATA_COLLECTION_SESSION;
			data = get_packet(&msg);
			w_ret = write_sf_packet(tos->fd, data, TOS_MSG_SIZE);
			free(data);
		}
		if (w_ret == -1)
		{
			printf("error writing to socket... exiting\n");
			exit (0);
		}
		
	}
	return NULL;
}

void mote_read(void *buf)
{
	TOS_write_t *tos = (TOS_write_t *) buf;
	
	for (;;)
	{
		int len, i;
		const unsigned char *packet = read_sf_packet(tos->fd, &len);

		if (!packet)
			exit(0);
		for (i = 0; i < len; i++)
		{
			if (i == 5 || i== 9)
				printf("| ");
			printf("%02x ", packet[i]);
			
		}
		putchar('\n');
		fflush(stdout);
		free((void *)packet);
	}
}



///////////////////////////////////////////////////////////////////////////////////////////////////
// This is where the Magic Happens
///////////////////////////////////////////////////////////////////////////////////////////////////
int main(int argc, char **argv)
{
	int fd;
	int mote_addr;
	TOS_write_t tos_write;
	
	pthread_t *read_thread;
	pthread_t *write_thread;
	
	pthread_attr_t pthread_custom_attr;
	
	pthread_attr_init(&pthread_custom_attr);
	read_thread = (pthread_t *) malloc(sizeof(pthread_t));
	write_thread = (pthread_t *) malloc(sizeof(pthread_t));
	
	
	
	if (argc != 4)
	{
		
		fprintf(stderr, "Usage: %s <host> <port> <mote_addr> - dump packets from a serial forwarder %d \n", argv[0], argc);
		exit(2);
	}
	
	fd = open_sf_source(argv[1], atoi(argv[2]));
	
	if (fd < 0)
	{
		fprintf(stderr, "Couldn't open serial forwarder at %s:%s\n", argv[1], argv[2]);
		exit(1);
	}
	
	mote_addr = atoi(argv[3]);
	
	tos_write.fd = fd;
	tos_write.mote_addr = mote_addr;
	
	//mote_write( (void *) &tos_write);
	
	pthread_create(write_thread, &pthread_custom_attr, mote_write, &tos_write);
	pthread_create(read_thread, &pthread_custom_attr, mote_read, &tos_write);
	
	pthread_join(write_thread,NULL);
	pthread_join(read_thread,NULL);
	return 0;
}
