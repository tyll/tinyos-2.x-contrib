#ifndef USERVARIABLES_H_
#define USERVARIABLES_H_

#define NUM_TURTLES	15





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
bool g_connected = FALSE;
bool g_active = FALSE;



enum
{
	CONNECTION_EVENT_TIMEOUT = 15
};

char __connection_turtle_map[NUM_TURTLES]; //maps turtle index to an actual turtle address
char connARR[NUM_TURTLES];

void clearConnnectionInformation()
{
	int i;
	for (i = 0; i < NUM_TURTLES; i++)  
	{
		connARR[i] = 0;
		__connection_turtle_map[i] = -1;
	}
}

uint16_t getTurtleVersionIdx (uint16_t turtle_addr)
{
	int i;

    // Go through the index map
	for (i = 0; i < NUM_TURTLES; i++)
	{
		if (turtle_addr == __connection_turtle_map[i])
		{
			return i;
		}
	}
	
	// It's not in the table... look for a free slot
	for (i = 0; i < NUM_TURTLES; i++)
	{
		if (__connection_turtle_map[i] == -1)
		{
			__connection_turtle_map[i] = turtle_addr;
			return i;
		}
	}
}


#endif
