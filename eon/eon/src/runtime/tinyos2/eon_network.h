#ifndef EON_NETWORK_H_INCLUDED
#define EON_NETWORK_H_INCLUDED


#include "message.h"




/*enum
{
	AM_BEACONMSG = 4,
	//AM_ACCEPTMSG = 5,
	AM_PREDATA = 8,
	AM_OFFERMSG = 9,
	AM_DATAMSG = 11,
	AM_DATAACK = 12,
	AM_ARCHIVEMSG = 13,
	AM_ACKMSG = 14,
	AM_COLLECTMSG = 15,
	AM_STATUSMSG = 16,
	AM_ACTIVATEMSG = 17,
};*/




typedef struct BeaconMsg
{
	uint16_t src_addr;  //the beaconers address
	uint16_t src_delay; //the beaconers delay to the base station
	uint16_t bw; 		//the maximum number of packets that the beaconer might send you
} BeaconMsg_t;

typedef struct OfferMsg
{
	uint16_t addr;  //the responders address
	uint16_t delay; //the responders delay to the base station
	uint16_t bw; 		//the maximum number of packets that the responder might recv from you
} OfferMsg_t;

typedef struct AckMsg{
	uint8_t src;
	uint8_t idx;
	uint16_t addr;
	uint16_t min_id;
	uint16_t max_id;
}AckMsg_t;



#define DATA_MSG_HDR_LEN	6
#define DATA_MSG_DATA_LEN	(TOSH_DATA_LENGTH-DATA_MSG_HDR_LEN)
#define MAX_CONSECUTIVE_DATA_TIMEOUTS	5
#define RECV_MSG_TIMEOUT_MS		1000
#define INTERESTED_ROUNDS	3
#define INTERESTED_INTERVAL	1000
#define SEND_TIMEOUT_MS		1000
#define MAX_CONSECUTIVE_TIMEOUTS	5
#define RECV_ACK_TIMEOUT_MS		1000

#define BUNDLE_ACK_HEADER_LENGTH	6
#define BUNDLE_ACK_DATA_LENGTH	TOSH_DATA_LENGTH - BUNDLE_ACK_HEADER_LENGTH

#define PACKET_DATA_LENGTH		30
#define PACKET_HEADER_LENGTH	1
#define CHUNK_DATA_LENGTH (PACKET_DATA_LENGTH - PACKET_HEADER_LENGTH)
#define CHUNK_HEADER_LENGTH	6
#define CHUNK_PAYLOAD_LENGTH	(CHUNK_DATA_LENGTH - CHUNK_HEADER_LENGTH)

typedef nx_struct DataMsg
{
	nx_uint16_t src_addr;
	nx_uint8_t offerid;
	nx_uint8_t last;
	nx_uint8_t length;
	nx_uint16_t sequence;
	nx_uint8_t data[DATA_MSG_DATA_LEN];
}DataMsg_t;




typedef struct eon_message
{
	uint8_t data[PACKET_DATA_LENGTH];
	uint8_t length;
} eon_message_t;




#endif // EON_NETWORK_H_INCLUDED
