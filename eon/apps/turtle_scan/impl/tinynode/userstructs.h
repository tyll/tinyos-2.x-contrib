#ifndef USERSTRUCTSH_H_INCLUDED
#define USERSTRUCTSH_H_INCLUDED



#include "AM.h"


//bundle types
enum
{
	BTYPE_GPSFIRST = 1,
	BTYPE_GPSSECOND = 2,
	BTYPE_TEMP_WET = 3,
	BTYPE_RTSTATE = 4,
	BTYPE_RTPATH = 5,
	BTYPE_CONN = 6,
	
};

enum
{
	TX_HI_BW = 1500,
	TX_LO_BW = 500,
};

enum
{
	RX_HI_BW = 1500,
	RX_LO_BW = 500,
};

enum
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
};

enum
{
	ACT_QUERY = 0,
	ACT_ON = 1,
	ACT_OFF = 2,
	ACT_INIT = 3,
	ACT_IDLE = 0xFF,
};



typedef struct StatusMsg
{
	uint16_t src_addr;
	uint16_t volts;
	uint32_t rt_clock;
	uint8_t act;
	uint8_t state;
	uint8_t grade;
} StatusMsg_t;


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



/*#define DATA_MSG_HDR_LEN	6
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
*/

/*typedef struct DataMsg
{
	uint16_t src_addr;
	uint8_t offerid;
	unsigned int last : 1;
	unsigned int length : 7;
	uint16_t sequence;
	uint8_t data[DATA_MSG_DATA_LEN];
}DataMsg_t;



typedef struct GpsData {
	char date[NMEA_CHARS_PER_FIELD]; //ddmmyy
	char time[NMEA_CHARS_PER_FIELD];//hhmmss.ss
	GpsFixData fix;
} GpsData_t;


typedef struct packet_t
{
	uint8_t data[PACKET_DATA_LENGTH];
	uint8_t length;
} packet_t;

typedef struct ack_t
{
	uint8_t data[PACKET_DATA_LENGTH];
	uint8_t length;
} ack_t;

typedef struct chunk_t
{
	uint8_t data[CHUNK_DATA_LENGTH];
	uint8_t length;
} chunk_t;


typedef struct chunkarr_t {
	chunk_t chunks[2];
	uint8_t num;
} chunkarr_t;





typedef struct GetPageMsg {
	uint16_t src_addr;
	uint16_t page;
} GetPageMsg_t;
*/


//TOS_Msg g_deadlock_msg;

#endif // USERSTRUCTS_H_INCLUDED
