#ifndef DSN_H
#define DSN_H

enum {
	MAX_LEN = 1024,
	LOG_DELIMITER = '\n',
	ID_ADDR = 0xfe00,
	RXBUFFERSIZE = 128,
	NO_ID = 0xffff,
	STARTUP_WAIT_TIME = 400, // milliseconds before anything is written out to uart (default 400)
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

// USART to be used for logging (0 or 1)
#ifndef USART
#define USART 0
#endif

// USART 1 on tmote has no flow control
#if USART==1
#define NOSHARE
#endif
// if defined, this prevents logStart and logStop from having an effect
//#define PERMANENT_LOGGING

// if defined, the UART is once requested and never released
//#define NOSHARE

// define DBG macro
//#define dbg(a,b) DSN.logDebug(" #b ");
/*
 * dbg: print a debugging statement preceded by the node ID.
dbg_clear: print a debugging statement which is not preceded by the node ID. This allows you to easily print out complex data types, such as packets, without interspersing node IDs through the output.
    * dbgerror: print an error statement preceded by the node ID
    * dbgerror_clear: print an error statement which is not preceded by the node ID
    * 
*/
#endif
