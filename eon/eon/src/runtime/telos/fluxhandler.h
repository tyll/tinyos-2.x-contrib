#ifndef FLUXHANDLER_H_INCLUDED
#define FLUXHANDLER_H_INCLUDED

#include "../marshaller.h"
#include "rt_structs.h"

bool isReadyByID (EdgeIn * edge);
result_t callEdge (EdgeIn * e);
result_t callError (uint16_t nodeid, Handle in, uint8_t error);
uint16_t getErrorWeight (uint16_t nodeid);
//void factorSGDC (uint8_t state, bool awake);
bool islocal (uint16_t nodeid);
bool doremoteenqueue (EdgeQueue * q, EdgeIn edge);
task void RemoteConsumerTask ();
task void SleepTask();

//global variables
uint8_t gStargateLoad=0;
enum {
		ASLEEP =0, 
		SLEEPY =1, 
		AWAKE  =3,
		WAKING =4,
	};
int remoteCstate = ASLEEP;
	
	



/*void
factorTime (uint16_t nodeid, uint32_t start, uint32_t end)
{
  uint32_t elapsed;
  double d_elapsed_ms;
  if (start > end)
    return;
  if (start == end)
    {
      elapsed = 1;		//round up to 1us
    }
  else
    {
      elapsed = end - start;
    }

  d_elapsed_ms = ((double) elapsed) / 1000.0;

  atomic
  {
    nodeTimeMS[nodeid] =
      (nodeTimeMS[nodeid] * (PATHRATEHISTORY - 1.0) +
       d_elapsed_ms) / ((double) PATHRATEHISTORY);
  }
}

void
factorWakeTime (uint32_t start, uint32_t end)
{
  uint32_t elapsed;
  double d_elapsed_ms;
  if (start > end)
    return;
  if (start == end)
    {
      elapsed = 1;		//round up to 1us
    }
  else
    {
      elapsed = end - start;
    }

  d_elapsed_ms = ((double) elapsed) / 1000.0;


  wakeTimeMS =
    (wakeTimeMS * (PATHRATEHISTORY - 1.0) +
     d_elapsed_ms) / ((double) PATHRATEHISTORY);

}

void
factorWeight (uint16_t pathweight)
{

  pathRate[pathweight]++;

}

void factorWake (uint16_t path, bool wake)
{

  	double val;
  	
  	if (wake)
    {
      	val = 1.0;
    }
  	else
    {
      	val = 0.0;
    }

  	wakeupProb[path] =
    	(wakeupProb[path] * (WAKEUPPROBHISTORY - 1.0) +
     	val) / ((double) WAKEUPPROBHISTORY);

}

void factorSGDC (uint8_t state, bool awake)
{

  	double val;
  	if (awake)
    {
      	val = 1.0;
    }
  	else
    {
      	val = 0.0;
    }


  	stargateDutyCycle[state] =
    	stargateDutyCycle[state] + (val -
				stargateDutyCycle[state]) / ((double) SGDCHISTORY);

}
*/
/************************************
 *  Stargate Wakeup events
 *
 *
************************************/

event result_t SGWakeup.wakeDone ()
{
  uint32_t wakeEnd;
  
  gStargateLoad = 0;
  wakeEnd = call LocalTime.read ();
  wakeWaiting = FALSE;
  
  //factorWakeTime (wakeStart, wakeEnd);
  remoteCstate = AWAKE;
  if (post RemoteConsumerTask() == TRUE)
  {
  	
  }
  return SUCCESS;
}

event result_t SGWakeup.sleepDone (result_t success)
{
	static int count = 0;
  	wakeWaiting = FALSE;
  	if (success == FAIL)
	{
		count++;
		if (count < 10)
		{
			post SleepTask();
		}		
	} else {
		count = 0;
	}
	atomic
	{
		if (!isqueueempty (&remoteQ))
		{
			remoteCstate = WAKING;
			post RemoteConsumerTask();		
		} else {
			remoteCstate = ASLEEP;
		}
	}
	
  	return SUCCESS;
}


/************************************
 *
 * EDGE Consumer/Producer functions
 *
 ************************************/


task void
LocalConsumerTask ()
{
  
  uint16_t result;
  uint16_t delay, ready;
  EdgeIn edge;

  delay = FALSE;
 
  result = dequeue (&moteQ, &edge);
  
  if (result == TRUE)
    {
    
      //Got an edge
      //is it ready
      ready = isReadyByID (&edge);

      if (!islocal (edge.node_id))
		{
		  doremoteenqueue (&remoteQ, edge);
		} else {
			
	  		if (!ready)
	    	{
	      		//not ready, put it to the back of the queue
	      		enqueue (&moteQ, edge);
	      		delay = TRUE;
	    	} else {
		      	result = callEdge(&edge);
	    	} //if
	    	
		} //if islocal
    }


 
  atomic
  {
    if (isqueueempty (&moteQ))
      {
		localCAlive = FALSE;
      }
  }//atomic

  if (localCAlive == TRUE)
    {
      if (delay == TRUE)
		{
		  //delay execution a little bit
		  call localQTimer.start (TIMER_ONE_SHOT, QUEUE_DELAY);
		}
    	  else
		{
		  post LocalConsumerTask ();
		}			//else(delay)
    }//else(still alive)
    

}				//end LocalConsumerTask


event result_t localQTimer.fired ()
{
  if (!post LocalConsumerTask ())
    {
      call localQTimer.start (TIMER_ONE_SHOT, QUEUE_DELAY);
    }
  return SUCCESS;
}


task void RemoteConsumerTask ()
{
  	bool result, delay;
  	uint8_t marshall_result;
  	static EdgeIn edge;
  	uint16_t connid;
  	static bool marshalling = FALSE;
  	static int marshall_count = 0;

  	delay = FALSE;

	
  	
  	
  	
	
//  	if (!call SGWakeup.isawake ())
	if (remoteCstate == WAKING)
    {
    	wakeStart = call LocalTime.read ();
	 	wakeWaiting = TRUE;
	 		  		
	  	result = call SGWakeup.wake ();	//wake up and wait
	  	if (result == FAIL)
	  	{
	  			wakeWaiting = FALSE;
	  			delay = TRUE;
    	} else {
	  		return;
	  	}
	} 
	if (remoteCstate == AWAKE) {
    
  		if (marshalling)
		{
			
			call SGWakeup.getConnection(&connid);
			//try to marshall the edge
		  	marshall_result = encodeEdge (connid, edge, marshall_count);
		  	if (marshall_result == MARSH_OK)
		    {
		    	
		    	marshall_count++;
		    }
		  	else if (marshall_result == MARSH_DONE)
		    {
		    	
		      	//free memory
		      	call BAlloc.free ((Handle) edge.invar);
		      	//call BAlloc.free ((Handle) edge.outvar);
		      	marshalling = FALSE;
		      	marshall_count = 0;
		      	delay = TRUE;
		      		
		      	
		    }
		  	else if (marshall_result == MARSH_FULL)
		    {
		    	
		      	delay = TRUE;
		    }
		  	else
		    {
		    	
		     	//marshalling error.  Not good at all.
		      	marshalling = FALSE;
		      	marshall_count = 0;
		      	delay = TRUE;
		    }
		}
	    else
		{
			
		 	result = dequeue (&remoteQ, &edge);
		 	if (result == TRUE)
		    {
		      	//Got an edge, Stargate Bound
		      	marshalling = TRUE;
		      	marshall_count = 0;
		      	call Leds.redToggle();
		      	call SGWakeup.upLoad();
				call SleepTimer.stop ();
		      	//set up for marshalling    
	
		    }			//if got edge
		}			//else marshalling
	    
	
    }//state AWAKE

  	
  	if (remoteCstate == AWAKE)
    {
    	if (delay == TRUE)
		{
	  		//delay execution a little bit
	  		call remoteQTimer.start (TIMER_ONE_SHOT, QUEUE_DELAY * 100);
		}
      	else
		{
	  		post RemoteConsumerTask ();
		}//else(delay)
    }
 
 	
}

event result_t SGWakeup.pathDone(uint16_t path, uint32_t elapsed)
{
	
	if (call SGWakeup.getLoad() == 0)
	{
		call Leds.yellowToggle();
		call SleepTimer.start (TIMER_ONE_SHOT, 2 * 1024);	
	}	
	
	//insert path accounting stuff here
	return SUCCESS;
}

task void SleepTask()
{
	result_t res;
	static int count = 0;
	
	res = call SGWakeup.sleep();	
	if (!res)
	{
		count++;
		if (count < 4)
		{
			post SleepTask();
		}
	} else {
		count = 0;
		remoteCAlive = FALSE;
	}
}

event result_t SleepTimer.fired ()
{
	call Leds.greenToggle();
	if (remoteCstate == AWAKE && call SGWakeup.getLoad() == 0)
	{
		remoteCstate = SLEEPY;
		post SleepTask();
	}
  	return SUCCESS;
}

event result_t remoteQTimer.fired ()
{

  if (remoteCstate == AWAKE)
    {
      return SUCCESS;
    }
  if (!post RemoteConsumerTask ())
    {
      call remoteQTimer.start (TIMER_ONE_SHOT, QUEUE_DELAY * 100);
    }
  return SUCCESS;
}




bool
isFunctionalState (uint8_t state)
{
  return TRUE;
}

/*********************************
 * A wrapper for enqueue to manage
 * the posting of consumer tasks
 ********************************/
bool
dolocalenqueue (EdgeQueue * q, EdgeIn edge)
{
  bool result;

  atomic
  {
    result = enqueue (q, edge);

    if (result && localCAlive == FALSE)
      {
	localCAlive = TRUE;
	post LocalConsumerTask ();
      }
  }				//atomic
  return result;

}

/*********************************
 * A wrapper for enqueue to manage
 * the posting of consumer tasks
 ********************************/
bool
doremoteenqueue (EdgeQueue * q, EdgeIn edge)
{
  bool result;

	
  atomic
  {
    result = enqueue (q, edge);

	atomic {
    	if (result && remoteCstate == ASLEEP)
    	  {
    	  		remoteCstate = WAKING;
				post RemoteConsumerTask ();
    	  }
	}
  }				//atomic
  return result;

}

/********************************
 * AUX functions
 ********************************/

uint16_t
getNextSession ()
{
  uint16_t nextid;
  atomic
  {
    nextid = session_id;
    session_id++;
  }
  return nextid;
}

result_t
handle_exit (Handle data)
{
  GenericNode **ndata = (GenericNode **) data;

  //factorWeight ((*ndata)->_pdata.weight);
  //factorWake ((*ndata)->_pdata.weight, (*ndata)->_pdata.wake);

  call BAlloc.free (data);

  return SUCCESS;
}


result_t
handle_error (uint16_t nodeid, Handle indata, uint8_t error)
{

  //add weight
  GenericNode **ndata = (GenericNode **) indata;


  (*ndata)->_pdata.weight += getErrorWeight (nodeid);

  if (error == ERR_NOMEMORY)
    {
      
    }
  if (error == ERR_QUEUE)
    {
      
    }


  //call the correct error handler
  return callError (nodeid, indata, error);
}


//CODE FOR HANDLING EDGES BETWEEN NODES
result_t
handle_edge (uint16_t nodeid,
	     Handle outdata, bool local, uint16_t edgewt)
{
  result_t result;
  Handle hin;
  Handle hout;
  EdgeIn newedge;


  
  //out becomes in.
  hin = outdata;
//needs to be done right before calling nodeCall;
/*
  //allocate next out variable
  result = call BAlloc.allocate (&hout, newoutsize);
  if (result == FAIL)
    {
      call BAlloc.free (hout);
      //error handling code

      return handle_error (nodeid, hin, ERR_NOMEMORY);
    }
*/

  //put it on the queue
  //Copy src contents to new edge
  ((GenericNode *) (*hin))->_pdata.weight += edgewt;
/*  
  ((GenericNode *) (*hout))->_pdata.sessionID =
    ((GenericNode *) (*hin))->_pdata.sessionID;
  ((GenericNode *) (*hout))->_pdata.weight =
    ((GenericNode *) (*hin))->_pdata.weight;
*/
  newedge.node_id = nodeid;
  newedge.invar = (uint8_t **) hin;
  //newedge.outvar = (uint8_t **) hout;



  if (local)
    {

      if (!dolocalenqueue (&moteQ, newedge))
	{
	  //queue is full
	  return handle_error (nodeid, hin, ERR_QUEUE);
	}
    }
  else
    {
    	
      if (!doremoteenqueue (&remoteQ, newedge))
	{	
	  //queue is full
	  return handle_error (nodeid, hin, ERR_QUEUE);
	}
    }

  return SUCCESS;
}


//CODE FOR HANDLING EDGES BETWEEN NODES
result_t
handle_src_edge (uint16_t nodeid,
		 Handle outdata,
		 uint16_t session, bool local, uint16_t edgewt)
{
  result_t result;
  Handle hin;
  Handle hout;
  EdgeIn newedge;
  uint16_t datasize;




  //allocate in variable
  datasize = call BAlloc.size (outdata);
  result = call BAlloc.allocate (&hin, datasize);
  if (result == FAIL)
    {
      //error handling code

      return handle_error (nodeid, outdata, ERR_NOMEMORY);
    }
  memcpy (*hin, *outdata, datasize);

/*
  //allocate next out variable
  result = call BAlloc.allocate (&hout, newoutsize);
  if (result == FAIL)
    {
      call BAlloc.free (hout);
      //error handling code

      return handle_error (nodeid, outdata, ERR_NOMEMORY);
    }

*/

  //put it on the queue
  //Copy src contents to new edge
  ((GenericNode *) (*hin))->_pdata.sessionID = session;
  ((GenericNode *) (*hin))->_pdata.sessionID = session;
  ((GenericNode *) (*hin))->_pdata.weight = edgewt;
  ((GenericNode *) (*hin))->_pdata.minstate = STATE_BASE;
  ((GenericNode *) (*hin))->_pdata.wake = FALSE;
  newedge.node_id = nodeid;
  newedge.invar = (uint8_t **) hin;
  //newedge.outvar = (uint8_t **) hout;

  if (local)
    {

      if (!dolocalenqueue (&moteQ, newedge))
	{
	  //queue is full
	  
	  return handle_error (nodeid, hin, ERR_QUEUE);
	}
    }
  else
    {
      if (!doremoteenqueue (&remoteQ, newedge))
	{
	  //queue is full
	  
	  return handle_error (nodeid, hin, ERR_QUEUE);
	}
    }

  return SUCCESS;
}

#endif
