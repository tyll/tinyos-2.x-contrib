#ifndef USERSTRUCTSH_H_INCLUDED
#define USERSTRUCTSH_H_INCLUDED

#include "gps.h"
#include "SingleStream.h"
#include "AM.h"
#include "uservariables.h"

enum
{
	AM_BEACONMSG = 4,
	AM_INTERESTEDMSG = 5,
	AM_ACK_MSG = 6,
	AM_ACK_MSG_ACK = 8,
	AM_OFFERMSG = 9,
	AM_OFFERACK = 10,
	AM_DATAMSG = 11,
	AM_DATAACK = 12,
	
	//NOTE: Eeach command has unique ID (seq num)
	AM_BEGIN_TRAVERSAL_MSG = 17,
	AM_GO_NEXT_MSG = 18,
	AM_GET_NEXT_CHUNK = 19,
	AM_GET_BUNDLE_MSG = 20,
	AM_DELETE_BUNDLE_MSG = 21,
	AM_DELETE_ALL_BUNDLES_MSG = 22,
	AM_END_DATA_COLLECTION_SESSION = 23,
	AM_BUNDLE_INDEX_ACK = 24,
	AM_RADIO_HI_POWER = 25,
	AM_RADIO_LO_POWER = 26,
	AM_DEADLOCK_MSG = 27,
	AM_DELETE_ALL_ACK = 28,
	
		
};

typedef struct BeaconMsg
{
	uint8_t version_num;
	uint16_t src_addr;
} BeaconMsg_t;

typedef struct OfferMsg
{
	uint16_t src_addr;
	uint16_t turtle_addr;
	uint16_t bundle;
	uint8_t offerid;
} OfferMsg_t;

typedef struct OfferAck
{
	uint16_t src_addr;
	uint16_t turtle_addr;
	uint16_t bundle;
	uint8_t offerid;
	uint8_t ok;
} OfferAck_t;

typedef struct InterestedMsg
{
	uint16_t src_addr;
} InterestedMsg_t; 

typedef struct InterestedAck
{
	uint16_t src_addr;
}InterestedAck_t;

typedef struct AckArrayPacket{
	uint16_t src_addr;
	int16_t packet_num;
	uint16_t packet_total;
	uint16_t turtle_addr;
	uint8_t start;
	uint8_t end;
}AckArrayPacket_t;

typedef struct AckArrayAck{
	uint16_t src_addr;
	int16_t packet_num;
}AckArrayAck_t;

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


typedef struct DataMsg
{
	uint16_t src_addr;
	uint8_t offerid;
	unsigned int last : 1;
	unsigned int length : 7;
	uint16_t sequence;
	uint8_t data[DATA_MSG_DATA_LEN];
}DataMsg_t;


typedef struct DataAck
{
	uint16_t src_addr;
	uint8_t offerid;
	uint16_t sequence;
}DataAck_t;

typedef struct GpsData {
	char date[NMEA_CHARS_PER_FIELD]; //ddmmyy
	char time[NMEA_CHARS_PER_FIELD];//hhmmss.ss
	GpsFixData fix;
} GpsData_t;

typedef struct Bundle {
	stream_t stream;
	uint16_t turtle_num;
	uint16_t bundle_num;
} Bundle_t;

/*
	//NOTE: Eeach command has unique ID (seq num)
	AM_BEGIN_TRAVERSAL_MSG = 17,
	AM_GO_NEXT_MSG = 18
	AM_GET_BUNDLE_MSG = 19,
	AM_DELETE_BUNDLE_MSG_ACK = 20,
	AM_BUNDLE_INDEX_ACK
*/

/*typedef struct BeginTraversalMsg {
	uint16_t src_addr;
	uint8_t seq_num;
} BeginTraversalMsg_t;

typedef struct GoNextMsg {
	uint16_t src_addr;
	uint8_t seq_num;
} GoNextMsg_t;
*/
typedef struct GetBundleMsg {
	uint16_t src_addr;
	uint16_t bundle;
} GetBundleMsg_t;

typedef struct DeleteBundleMsg {
	uint16_t src_addr;
	uint16_t bundle;
} DeleteBundleMsg_t;

typedef struct DeleteAllBundlesMsg {
	uint16_t src_addr;
} DeleteAllBundlesMsg_t;


typedef struct BundleIndexAck 
{
 	uint16_t src_addr;
	uint16_t bundle;
	uint8_t chunk;
 	uint8_t flags; //x,x,x,x,x,x,success,end
 	char data[BUNDLE_ACK_DATA_LENGTH];
} BundleIndexAck_t;
// 
// typedef struct GetNextChunk{
// 	uint16_t src_addr;
// 	uint8_t seq_num;
// } GetNextChunk_t;
// 
// typedef struct EndCollectionSession{
// 	uint16_t src_addr;
// 	uint8_t seq_num;
// } EndCollectionSession_t;


//???What are these for?


	
stream_t g_rt_stream;


TOS_Msg g_deadlock_msg;

#endif // NODES_H_INCLUDED
