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

// ########### platform dependent (with msp430 cpu)
// tmote
#if defined(PLATFORM_TELOSB)
typedef cc2420_header_t radio_header_t;	// tmote cc2420
#ifndef USART
#define USART 0
#endif
#endif

// tinynode
#if defined(PLATFORM_TINYNODE)
typedef xe1205_header_t radio_header_t; // tinynode xe1205
#ifndef USART
#define USART 1
#endif
#endif

// ########### end platform dependent (with msp430 cpu)

#ifndef 	BUFFERSIZE
#define 	BUFFERSIZE 1024
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
