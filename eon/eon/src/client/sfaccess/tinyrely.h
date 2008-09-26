#ifndef _TINYRELY_H_
#define _TINYRELY_H_

#include "teloscomm.h"
#include <stdint.h>
#include <pthread.h>

typedef uint8_t bool;
#define TRUE 1
#define FALSE 0

#ifndef TOSH_DATA_LENGTH
#define TOSH_DATA_LENGTH 28
#endif

#ifndef RELY_HEADER_LENGTH
#define RELY_HEADER_LENGTH  6
#endif

#ifndef RELY_PAYLOAD_LENGTH
#define RELY_PAYLOAD_LENGTH (TOSH_DATA_LENGTH-RELY_HEADER_LENGTH)
#endif


#ifndef RELY_MAX_CONNECTIONS
#define RELY_MAX_CONNECTIONS  5
#endif

#ifndef RELY_UID_INVALID
#define RELY_UID_INVALID  0
#endif

#ifndef RELY_IDX_INVALID
#define RELY_IDX_INVALID  -1
#endif

#define RELY_TIME_STEP      300
#define RELY_CONN_TIMEOUT   15000  //reset connection if no 
#define RELY_SEND_TIMEOUT 	100 // * RELY_ACKTIMER ms
#define RELY_RESEND_TIMEOUT 20 // * RELY_ACKTIMER ms

#define RELY_REQ_TIMEOUT	5000
#define RELY_GRANULARITY	200
#define RELY_ACKTIMER		5
#define RELY_TIMEOUT_COUNT	((RELY_REQ_TIMEOUT / RELY_GRANULARITY)+1)

typedef void (*recv_callback_t)(int id, uint8_t *data, int length);

typedef struct ConnStr {
  bool valid;
  pthread_mutex_t mutex;
  pthread_mutex_t rxmutex;
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
  recv_callback_t callback;
} ConnStr;



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

#define CONNMSGSIZE 6
#define RELYMSGSIZE (6 + RELY_PAYLOAD_LENGTH)
#define ACKMSGSIZE 	6


enum {
  TOS_BCAST_ADDR = 0xffff,
  TOS_UART_ADDR = 0x007e,
};

int tinyrely_init(const char* host, int port);
int tinyrely_destroy();
int tinyrely_connect(recv_callback_t callback, int address);
int tinyrely_send(int id, const uint8_t *data, int length);
int tinyrely_close(int id);

#endif
