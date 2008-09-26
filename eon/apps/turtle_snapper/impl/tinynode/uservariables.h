#ifndef USERVARIABLES_H_
#define USERVARIABLES_H_

#define NUM_TURTLES	20





/**************************************************************************************************
// GLOBAL SINGLE STREAM VARIABLES
**************************************************************************************************/


// should always be accessed atomically;
enum
{
	LBFLOW_RECEIVING = 0,
	LBFLOW_IDLE = 1
};
//uint8_t listen_beacon_flow_state;
uint16_t g_addr;

//this should indicate whether or not we are in a connection event.
//bool g_connected = FALSE;
bool g_active = TRUE;
//bool g_missed_last_reading = FALSE;
bool g_in_gps = FALSE;

uint16_t g_lastAddr = 0xFFFF; //default to broadcast







#endif
