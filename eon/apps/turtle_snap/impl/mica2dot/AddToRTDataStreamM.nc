includes structs;

module AddToRTDataStreamM
{
	provides
	{
		interface StdControl;
		interface IAddToRTDataStream;
	}
	uses
	{
		interface IAccum;
		interface SingleStream;
		interface Leds;
		//interface Timer as WaterTimer;
		//interface StdControl as WaterControl;
		command bool getLevel(uint16_t *data);
	}
}
implementation
{
#include "rt_structs.h"
#include "fluxconst.h"

// 4 bytes per uint32_t
#define NUM_PATH_COSTS	6
// 1 byte per uint8_t
#define NUM_PATH_PROBS	24
// 1 byte per uint8_t
#define NUM_SRC_PROBS	24

typedef struct SingletonData {
	uint32_t solar;			//	4
	uint32_t consumed;		// 	4
	uint16_t volts;			//	2
	uint32_t capacity;		//	4
	int16_t temperature;	//	2
	uint8_t state;			//	1
	uint8_t	grade;			//	1
	uint16_t howwet;		//  2
	uint8_t last_lock;		//	1
	uint16_t heap_left;		//	2
} SingletonData_t;


enum
{
	STATE_SINGLETON_DATA = 0xA,
	STATE_PATH_COST = 0xB,
	//STATE_PATH_FREQ,
	STATE_SRC_PROB = 0xC,
	STATE_PATH_PROB = 0xD,
	STATE_CONN_EVENTS = 0xE
};

	AddToRTDataStream_in ** node_in;
	AddToRTDataStream_out ** node_out;

	SingletonData_t single_data;

	int state;	
	bool appended_turtle_map;
	bool append_path_cost;
	bool append_src_prob;
	bool append_path_prob;
	
	int offset;
	
	///////////////////////////////////////////////////////////////////////////////////////////////	
	//
	///////////////////////////////////////////////////////////////////////////////////////////////	
	command result_t StdControl.init ()
	{
		return SUCCESS;
	}
		
	command result_t StdControl.start ()
	{
		return SUCCESS;
	}
		
	command result_t StdControl.stop ()
	{
		return SUCCESS;
	}
	
	///////////////////////////////////////////////////////////////////////////////////////////////	
	// IAddToRTDataStream
	///////////////////////////////////////////////////////////////////////////////////////////////	
	command bool IAddToRTDataStream.ready ()
	{
	//PUT READY IMPLEMENTATION HERE
	
		return TRUE;
	}

	task void appendSingletonData()
	{
		float tmpgrade;
		state = STATE_SINGLETON_DATA;
		single_data.solar = call IAccum.getInMicroJoules();
		single_data.consumed = call IAccum.getOutMicroJoules();
		single_data.volts = call IAccum.getVoltage();
		single_data.capacity = (uint32_t) (call IAccum.getReserve() / 1000);
		single_data.temperature = call IAccum.getTemperature();
		single_data.state = curstate;
		tmpgrade = curgrade * 100.0;
		single_data.grade = (uint8_t)tmpgrade;
		single_data.last_lock = (uint8_t)alloc_size;
		single_data.heap_left = rt_clock;
		
		call getLevel(&single_data.howwet);
		
		
		
		deadlocked_edge_id = 0xa2;
		if (call SingleStream.append(&g_rt_stream, &single_data, sizeof(SingletonData_t), NULL) == FAIL)
		{
			deadlocked_edge_id = 0xa3;
			signal IAddToRTDataStream.nodeDone (node_in, node_out, ERR_USR);
			return;
		}
	} 
	
	task void appendSrcProb()
	{
		int size = sizeof(uint8_t) * NUM_SRC_PROBS;
		//call Leds.redToggle();
		
		
		if ( (offset + size) > ( sizeof(uint8_t) * NUMSOURCES ) )
		{
			append_src_prob = TRUE;
			//size = ( offset + size ) - (  sizeof(uint8_t) * NUM_SRC_PROBS );
			size = (NUMSOURCES * sizeof(uint8_t)) - offset;
		}
		
		deadlocked_edge_id = 0xa4;
		if (call SingleStream.append(&g_rt_stream, __rtstate.srcprob + offset, size, NULL) == FAIL)
		{
			deadlocked_edge_id = 0xa5;
			signal IAddToRTDataStream.nodeDone (node_in, node_out, ERR_USR);
			return;
		}
		offset += size;
	}
	
	task void appendPathProb()
	{
		int size = sizeof(uint8_t) * NUM_PATH_PROBS;
		if ( (offset + size) > ( sizeof(uint8_t) * NUMPATHS ) )
		{
			append_path_prob = TRUE;
			size = (NUMPATHS * sizeof(uint8_t)) - offset;
			//size = ( offset + size ) - (  sizeof(uint8_t) * NUM_PATH_PROBS );
		}
		deadlocked_edge_id = 0xa6;
		if (call SingleStream.append(&g_rt_stream, __rtstate.prob + offset, size, NULL) == FAIL)
		{
			deadlocked_edge_id = 0xa7;
			signal IAddToRTDataStream.nodeDone (node_in, node_out, ERR_USR);
			return;
		}
		offset += size;
	}
	
	/*
	append_src_prob 
	append_path_prob 
	
	uint8_t __rtstate.srcprob[NUMSOURCES];
	uint8_t prob[NUMPATHS];
	int32_t pathenergy[NUMPATHS];
	
	*/
	task void appendAvgPathCost()
	{
		//state = 
		
		int size = sizeof(int32_t) * NUM_PATH_COSTS;
		if ( (offset + size) > (sizeof(int32_t) * NUMPATHS) )
		{
			append_path_cost = TRUE;
			//size = (offset + size) - (sizeof(int32_t) * NUMPATHS);
			size = (NUMPATHS * sizeof(uint32_t)) - offset;
		}
		deadlocked_edge_id = 0xa8;
		if (call SingleStream.append(&g_rt_stream, ((char *)__rtstate.pathenergy) + offset, size, NULL) == FAIL)
		{
			deadlocked_edge_id = 0xa9;
			signal IAddToRTDataStream.nodeDone (node_in, node_out, ERR_USR);
			return;
		}
		offset += size;
	}
	/*
	task void appendPathFreq()
	{
		
	}
	*/
	// NOTE: This function is written with the assumption that BOTH 
	// the turtle map AND 
	// the connection array are of size less than BUNDLE_ACK_DATA_LENGTH
	task void appendConnectionEvents()
	{
		/*
			char __connection_turtle_map[NUM_TURTLES]; //maps turtle index to an actual turtle address
			char connARR[NUM_TURTLES];
		*/
		// First we append the turtle map... 
		if (appended_turtle_map == FALSE)
		{
			deadlocked_edge_id = 0xb1;
			if (call SingleStream.append(&g_rt_stream, __connection_turtle_map, sizeof(char)*NUM_TURTLES, NULL) == FAIL)
			{
				deadlocked_edge_id = 0xb2;
				signal IAddToRTDataStream.nodeDone (node_in, node_out, ERR_USR);
				return;
			}
		}
		else
		{
			deadlocked_edge_id = 0xb3;
			if (call SingleStream.append(&g_rt_stream, connARR, sizeof(char)*NUM_TURTLES, NULL) == FAIL)
			{
				deadlocked_edge_id = 0xb4;
				signal IAddToRTDataStream.nodeDone (node_in, node_out, ERR_USR);
				return;
			}
		}
		
		// Then we append the connection array
	}

/*	task void waterCheck()
  {
  	call WaterControl.start();
	call WaterTimer.start(TIMER_ONE_SHOT, 400);
	
  }
  
  event result_t WaterTimer.fired()
  {
  	bool valid;
	uint16_t level;

  	call WaterTimer.stop();
	valid = call getLevel(&level);
	call WaterControl.stop();
	
	single_data.howwet = level;
	
	post appendSingletonData();
	return SUCCESS;
  }*/
	
	
	command result_t IAddToRTDataStream.nodeCall (AddToRTDataStream_in ** in,
			AddToRTDataStream_out ** out)
	{
		node_in = in;
		node_out = out;
		
		call SingleStream.init(&g_rt_stream, FALSE);
		
		appended_turtle_map = FALSE;
		append_path_cost = FALSE;
		append_src_prob = FALSE;
		append_path_prob = FALSE;
		
		(*node_out)->num = 31; // Set the size so that it always passes the typecheck
		
		offset = 0;		
		deadlocked_edge_id = 0xa1;
		
		//post waterCheck();
		//single_data.howwet = 50;
		post appendSingletonData();
		
		return SUCCESS;
	}
	
	///////////////////////////////////////////////////////////////////////////////////////////////	
	//	SingleStream Interface Functions
	///////////////////////////////////////////////////////////////////////////////////////////////	
	event void SingleStream.nextDone(stream_t *stream_ptr, result_t res)
	{
		if (stream_ptr != &g_rt_stream)
			return;
	}

	event void SingleStream.appendDone(stream_t *stream_ptr, result_t res)
	{
		
		
		if (stream_ptr != &g_rt_stream)
			return;
		
			
		deadlocked_edge_id = 0xb5;
		if (res == SUCCESS)
		{
			
			if (state == STATE_SINGLETON_DATA) // We just finished appending the Singleton Data
			{
				//state = last_sp_call = STATE_PATH_COST;
				state = STATE_PATH_COST;
				offset = 0;
				post appendAvgPathCost();

			}
			
			else if (append_path_cost == FALSE && state == STATE_PATH_COST) 
			{
				post appendAvgPathCost();
			}
			else if (append_path_cost == TRUE && state == STATE_PATH_COST) // We just finished appending the "average path cost" Data
			{
				//call Leds.redToggle();
				offset = 0;
				//state = last_sp_call = STATE_SRC_PROB;
				state = STATE_SRC_PROB;
				post appendSrcProb();
				
			}
			
			else if (append_src_prob == FALSE && state == STATE_SRC_PROB)
			{
				post appendSrcProb();
			}
			else if (append_src_prob == TRUE && state == STATE_SRC_PROB)
			{
				offset = 0;
				//state = last_sp_call = STATE_PATH_PROB;
				state = STATE_PATH_PROB;
				post appendPathProb();
			}
			else if (append_path_prob == FALSE && state == STATE_PATH_PROB)
			{
				post appendPathProb();
			}
			else if (append_path_prob == TRUE && state == STATE_PATH_PROB)
			{
				offset = 0;
				//state = last_sp_call = STATE_CONN_EVENTS;
				state = STATE_CONN_EVENTS;
				post appendConnectionEvents();
			}
			else if (appended_turtle_map == FALSE  && state == STATE_CONN_EVENTS)
			{
				appended_turtle_map = TRUE;
				post appendConnectionEvents();
			}
			// We just finished appending the "connection events" Data 
			// AND we're done!
			else if (appended_turtle_map == TRUE && state == STATE_CONN_EVENTS) 
			{
				//call Leds.redToggle();
				//last_sp_call = 0xF;
				deadlocked_edge_id = 0xb6;
				signal IAddToRTDataStream.nodeDone (node_in, node_out, ERR_OK);
				return;
			}
			else // I don't know how this could EVER happen... but just in case.
			{
				deadlocked_edge_id = 0xb7;
				signal IAddToRTDataStream.nodeDone (node_in, node_out, ERR_USR);
			}
		}
		else // Error Out
		{
			deadlocked_edge_id = 0xb8;
			signal IAddToRTDataStream.nodeDone (node_in, node_out, ERR_USR);
		}
	}
  
}

/*
	STATE_SINGLETON_DATA,
	STATE_PATH_COST,
	STATE_PATH_FREQ,
	STATE_CONN_EVENTS
*/
