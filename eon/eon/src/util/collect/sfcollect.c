#include <stdio.h>
#include <pthread.h>
#include <stdlib.h>
#include <stdint.h>
//#include <curses.h>

#include <ctype.h>
#include <limits.h>
#include <string.h>

#include <poll.h>

#include <sys/types.h>

#include "sfsource.h"

#include <time.h>

#ifndef TOSH_DATA_LENGTH
#define TOSH_DATA_LENGTH 31
#define BUNDLE_ACK_DATA_LENGTH	TOSH_DATA_LENGTH-4
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
#define	AM_DELETE_ALL_BUNDLES_MSG 22
#define	AM_END_DATA_COLLECTION_SESSION 23
#define	AM_BUNDLE_INDEX_ACK 24
#define AM_RADIO_HI_POWER 25
#define AM_RADIO_LO_POWER 26
#define AM_DEADLOCK_MSG 27
#define AM_DELETE_ALL_ACK 28

#define MAX_RETRYS	100

#define MSG_HEADER_OFFSET	5
#define MSG_DATA_OFFSET		MSG_HEADER_OFFSET+6
#define MSG_STATUS_OFFSET	MSG_HEADER_OFFSET+5
#define MSG_BUNDLE_OFFSET	MSG_HEADER_OFFSET+2
#define MSG_CHUNK_OFFSET	MSG_HEADER_OFFSET+4

#define MAX_CHUNKS	20
#define HDR_CHUNK 0xFF

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
	uint16_t bundle;
} gen_msg_t;

#pragma pack(1)
typedef struct TOS_write
{
	int fd;
	int mote_addr;
} TOS_write_t;

#define TOS_MSG_SIZE 2*sizeof(uint16_t) + 5*sizeof(uint8_t)
#define MSG_TIMEOUT 500


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
	memcpy(ret+offset, &tos->bundle, sizeof(uint8_t) );
	
	return ret;
}

/*void* mote_write(void *buf)
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
}*/

void mote_read(void *buf)
{
	TOS_write_t *tos = (TOS_write_t *) buf;
	
	for (;;)
	{
		int len, i;
		struct pollfd pl;
		
		pl.fd = tos->fd;
		pl.events = POLLIN;
		
		//if (poll(&pl, 1, 3000))
		if (poll(&pl, 1, 1500))
		{
			printf("about to read: \n");
		}
		else
		{
			printf("timed out \n");
		}
		
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

/*enum
{
	STATE_START_TRAVERSAL,
	STATE_GET_BUNDLE,
	STATE_GET_NEXT_CHUNK,
	STATE_G0_NEXT_BUNDLE,
	STATE_END_COLLECTION
};*/

enum
{
	STATE_WAKE,
	STATE_GET_BUNDLES,
	STATE_SLEEP,
};

bool listen_for_message(const unsigned char **packet, int fd, int *length)
{
	
	struct pollfd pl;
	int len;
	pl.fd = fd;
	pl.events = POLLIN;
	
	if (poll(&pl, 1, MSG_TIMEOUT))
	{
		// read that packet;
		*packet = read_sf_packet(fd, &len);
		
		// we got a packet but it's not the kind we were expecting...
		if ( (*packet)[2] != 24)
		{
			free(*packet);
			*packet = NULL;
			return listen_for_message(packet, fd, length);
		}
		else
		{
			//print_received_message(*packet, fd, len);
			*length = len;
			return TRUE;
		}
	}
	else
	{
		*length = -1;
		return FALSE;
	}
	//return packet;
}

void print_received_message(const unsigned char *packet, int len)
{
	int i;
	for (i = 0; i < len; i++)
	{
		if (i == MSG_HEADER_OFFSET || i == MSG_DATA_OFFSET)
			printf("| ");
		printf("%02x ", packet[i]);
	}
	printf("\n");
}

void print_data_message(const unsigned char *packet, int len, FILE *Fp)
{
	int i;
	for (i = 0; i < len; i++)
	{
		//if (i == MSG_HEADER_OFFSET || i == MSG_DATA_OFFSET)
		//	printf("| ");
		fprintf(Fp, "%02x ", packet[i]);
	}
	fprintf(Fp, "\n");
}

///////////////////////////////////////////////////////////////////////////////////////////////////
// This is where the Magic Happens
///////////////////////////////////////////////////////////////////////////////////////////////////
int main(int argc, char **argv)
{
	///////////////////////////////////////////////////////////////////////////////////////////////
	// Communication Variables
	///////////////////////////////////////////////////////////////////////////////////////////////
	
	int fd;
	int mote_addr;
	TOS_write_t tos_write;
	
	struct pollfd pl;
		
	///////////////////////////////////////////////////////////////////////////////////////////////
	// Collection Variables
	///////////////////////////////////////////////////////////////////////////////////////////////

	gen_msg_t msg;
	int state = STATE_GET_BUNDLES;
	int bundle_offset = 0;
	int num_retrys = 0;
	int total_msgs;
	uint32_t num_bundles = 0;
	uint32_t curr_nundle_num = 0;
	
	FILE *Fp;
	///////////////////////////////////////////////////////////////////////////////////////////////
	// Thread Variables
	///////////////////////////////////////////////////////////////////////////////////////////////
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
	
	Fp = fopen("data.txt", "w+");
	
	mote_addr = atoi(argv[3]);
	
	msg.addr = mote_addr;
	msg.group = 0x7d;
	msg.length = sizeof(uint16_t)+sizeof(uint8_t);
	msg.src_addr = SRC_ADDR;
	
	pl.fd = fd;
	pl.events = POLLIN;

	int chunk_vector[MAX_CHUNKS];
	int numchunks;
	
	memset(chunk_vector, 0, sizeof(chunk_vector));
	numchunks = -1;
	
	while (1337)
	{
		int w_ret;
		void *data; 
		int len;
		int i=0;
		bool done = FALSE;
		const unsigned char *packet;
		
		int timeouts;
		
		bool endfound = FALSE;
		
		
		switch (state) {
			
			case STATE_GET_BUNDLES:
				printf ("Sending GET_BUNDLE_MSG Message \n");
				msg.bundle = bundle_offset;
				msg.type = AM_GET_BUNDLE_MSG;
				msg.length = 4;
				data = get_packet(&msg);
				w_ret = write_sf_packet(fd, data, TOS_MSG_SIZE);
				timeouts = 0;
				while (!done)
				{
					printf("listen_for_message\n");
					if ( listen_for_message(&packet, fd, &len) )
					{
						printf("got packet (len=%d)\n", len);
						int pkt_bundle = (packet[MSG_BUNDLE_OFFSET+1] << 8) | packet[MSG_BUNDLE_OFFSET];
						printf("for bundle: %d (%d,%d)\n", pkt_bundle,packet[MSG_BUNDLE_OFFSET+1],packet[MSG_BUNDLE_OFFSET]);
						//is this for the bundle I'm interested in?
						if (pkt_bundle == bundle_offset)
						{
							// success?
							if (packet[MSG_STATUS_OFFSET] == 0x02)
							{
								//is it the header?
								if (packet[MSG_CHUNK_OFFSET] == HDR_CHUNK)
								{
									uint16_t turtle_num;
									uint16_t bundle_num;
									num_retrys = 0;
									timeouts = 0;
									
									
									
									printf ("Got Bundle Header \n");
									print_received_message(packet, len);
									memcpy(&turtle_num, &packet[MSG_DATA_OFFSET], sizeof(uint16_t) );
									memcpy(&bundle_num, &packet[MSG_DATA_OFFSET+2], sizeof(uint16_t) );
									fprintf(Fp, "Turtle: %d Bundle: %d\n", turtle_num, bundle_num);
								} else {
								
									//its a chunk
									num_retrys = 0;
									timeouts = 0;
									chunk_vector[packet[MSG_CHUNK_OFFSET]] = 1;
									printf ("Got a chunk : %d \n", packet[MSG_CHUNK_OFFSET]);
									print_data_message(packet, len, Fp);
									
								}
							}
							else if (packet[MSG_STATUS_OFFSET] == 0x03) // end of something
							{
								if (packet[MSG_CHUNK_OFFSET] == HDR_CHUNK)
								{
									//no valid chunk here
									num_retrys = 0;
									timeouts = 0;
									printf("Bundle is not valid.\n");
									bundle_offset++;
								} else {
									
									num_retrys = 0;
									timeouts = 0;
									endfound = TRUE;
									numchunks = packet[MSG_CHUNK_OFFSET];
									printf ("End of bundle reached : %d chunks\n", numchunks);
									//check the vector
									done = TRUE;
									int j;
									
									for (j=0; j < numchunks; j++)
									{
										if (chunk_vector[j] != 1)
										{
											done = FALSE;
											printf("X");
										} else {
											printf(".");
										}
									}
									printf("\n");
									if (done)
									{
										numchunks = -1;
										memset(chunk_vector, 0, sizeof(chunk_vector));
										bundle_offset++;
									}
									done = TRUE;
								}
							}
							else if (packet[MSG_STATUS_OFFSET] == 0x01) // end of something
							{
								printf("That's all of the bundles.\n");
								state = STATE_SLEEP;
								done = TRUE;
							}
							else // BAD 
							{
								if (num_retrys > MAX_RETRYS)
								{
									printf ("GetBundle FAILED.. EXITING \n");
									exit(0);
								}
								
								num_retrys++;
								printf ("ERROR: GetBundle failed... trying again \n");
								
							}
						}
						free(packet);
					} else {
					
						//do done check
						/*if (numchunks != -1)
						{
							done = TRUE;
							int j;
										
							for (j=0; j < numchunks; j++)
							{
								if (chunk_vector[j] != 1)
								{
									done = FALSE;
									printf("X");
								} else {
									printf(".");
								}
							}
							printf("\n");
							if (done)
							{
								numchunks = -1;
								memset(chunk_vector, 0, sizeof(chunk_vector));
								bundle_offset++;
							}
							done = TRUE;
						}*/
						
						timeouts++;
						if (timeouts > 2)
						{
							break;	
						}
					}
				}//while
				printf("Broke out\n");
				free (data);
				break;
			
			default: 
				printf("ERROR: %d is not a known state\n", state);
				exit(0);
				break;
		}
		if (w_ret == -1)
		{
			printf("error writing to socket... exiting\n");
			exit (0);
		}
	}
	
	return 0;
}










