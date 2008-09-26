
#include <AM.h>

#ifndef TINYRELY_H_INCLUDED
#define TINYRELY_H_INCLUDED



#ifndef RELY_HEADER_LENGTH
#define RELY_HEADER_LENGTH  6
#endif

#ifndef RELY_PAYLOAD_LENGTH
#define RELY_PAYLOAD_LENGTH (TOSH_DATA_LENGTH-RELY_HEADER_LENGTH)
#endif


#ifndef RELY_MAX_CONNECTIONS
#define RELY_MAX_CONNECTIONS  3
#endif

#ifndef RELY_UID_INVALID
#define RELY_UID_INVALID  0
#endif

#ifndef RELY_IDX_INVALID
#define RELY_IDX_INVALID  -1
#endif

#define RELY_TIME_STEP      300
#define RELY_CONN_TIMEOUT   15000  //reset connection if no 
#define RELY_RESEND_TIMEOUT 500


typedef struct ConnStr {
  bool valid;
  bool pending;
  bool sending;
  bool resending;
  bool full;
  bool closing;
  uint8_t count;
  uint8_t suid;
  uint8_t duid;
  uint16_t addr;
  uint8_t txseq;
  uint8_t rxseq;
  TOS_Msg txbuf;
  TOS_Msg rxbuf;
  TOS_Msg ackbuf;
} ConnStr;

typedef struct ConnMsg {
  uint16_t src;
  uint8_t suid;  //chosen by connection requestor
  uint8_t duid;  //assigned by connection acceptor
  uint8_t type;   //CONN_TYPE_XXXX
  uint8_t ok;    //RELY_XXXXX
} __attribute((packed)) ConnMsg;

typedef struct TinyRelyMsg {
  uint16_t src;
  uint8_t suid;
  uint8_t duid;
  uint8_t seq;
  uint8_t length;
  uint8_t data[RELY_PAYLOAD_LENGTH];
} __attribute((packed)) TinyRelyMsg;

typedef struct TinyRelyAck {
  uint16_t src;
  uint8_t suid;
  uint8_t duid;
  uint8_t seq;
  uint8_t ok;    //RELY_XXXXX
} __attribute((packed)) TinyRelyAck;

enum {
  CONN_TYPE_REQUEST=0,
  CONN_TYPE_ACK = 1,
  CONN_TYPE_CLOSE = 2
};

enum {
  RELY_OK  = 0,
  RELY_DUP = 1,
  RELY_FULL= 2,
  RELY_ERR = 3
};


enum {
  AM_TINYRELYCONNECT = 0xE0,
  AM_TINYRELYMSG = 0xE1,
  AM_TINYRELYACK = 0xE2
};


typedef struct RelySegment
{
  uint8_t length;
  uint8_t data[RELY_PAYLOAD_LENGTH];
} RelySegment;

typedef ConnMsg* ConnMsgPtr;
typedef TinyRelyMsg* TinyRelyMsgPtr;
typedef TinyRelyAck* TinyRelyAckPtr;

typedef RelySegment* RelySegmentPtr;

typedef uint8_t relyresult;

#endif
