#ifndef DSN_H
#define DSN_H
#include <message.h>

enum {
	MAX_LEN = 1024,
	LOG_DELIMITER = '\n',
	MSP430_ID_ADDR = 0xfe00,
	RXBUFFERSIZE = 128,
	NO_ID = 0xffff,
	LOG_NR_BUFFERSIZE = 32,
};

typedef struct VarStruct {
	void * pointer;
	uint8_t length;
	uint8_t * description;
} VarStruct;

#ifndef 	BUFFERSIZE
#define 	BUFFERSIZE 1024
#endif

// define DBG macro
//#define DSN_DBG_MACRO

#ifdef DSN_DBG_MACRO
#ifdef dbg
	#undef dbg
#endif
#define dbg(a,b) DSN.logDebug("#b");
#endif
#endif
