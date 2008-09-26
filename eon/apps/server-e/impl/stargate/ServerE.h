
#ifndef SERVERE_H_INCLUDED
#define SERVERE_H_INCLUDED

#include <stdint.h>
#include "runtime/rt_structs.h"

#define TOSH_DATA_LENGTH  60

#ifndef HEADER_LENGTH
#define HEADER_LENGTH  4
#endif

#ifndef DATA_HEADER_LENGTH
#define DATA_HEADER_LENGTH  8
#endif

#ifndef URL_LENGTH
#define URL_LENGTH (TOSH_DATA_LENGTH-HEADER_LENGTH)
#endif

#ifndef DATA_LENGTH
#define DATA_LENGTH (TOSH_DATA_LENGTH-DATA_HEADER_LENGTH)
#endif

typedef struct RequestMsg {
  uint16_t src;
  uint16_t suid;  //chosen by connection requestor
  uint8_t url[URL_LENGTH];
} RequestMsg;

typedef struct RedirectMsg {
  uint16_t src;
  uint16_t suid;
  uint16_t port;
  uint16_t delay_ms;
}  RedirectMsg;

typedef struct MetaMsg {
  uint16_t src;
  uint16_t suid;
  uint32_t size;
  uint16_t error;
} MetaMsg;


typedef struct DataMsg {
  uint16_t src;
  uint16_t suid;
  uint16_t segment;
  uint16_t size;
  uint8_t data[DATA_LENGTH];
} DataMsg;

typedef struct DataAck {
  uint16_t src;
  uint16_t suid;
  uint16_t segment;
} DataAck;




enum {
  AM_REQUESTMSG = 0x14,
  AM_REDIRECTMSG = 0x15,
  AM_METAMSG = 0x16,
  AM_DATAMSG = 0x17,
  AM_DATAACK = 0x18
};



typedef RequestMsg* RequestMsgPtr;
typedef RedirectMsg* RedirectMsgPtr;
typedef MetaMsg* MetaMsgPtr;
typedef DataMsg* DataMsgPtr;
typedef DataAck* DataAckPtr;

#endif
