/* $Id$ */
/*
 * Copyright (c) 2006 Stanford University.
 * All rights reserved.
 *
 * Redistribution and use in source and binary forms, with or without
 * modification, are permitted provided that the following conditions
 * are met:
 * - Redistributions of source code must retain the above copyright
 *   notice, this list of conditions and the following disclaimer.
 * - Redistributions in binary form must reproduce the above copyright
 *   notice, this list of conditions and the following disclaimer in the
 *   documentation and/or other materials provided with the
 *   distribution.
 * - Neither the name of the Stanford University nor the names of
 *   its contributors may be used to endorse or promote products derived
 *   from this software without specific prior written permission.
 *
 * THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS
 * ``AS IS'' AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT
 * LIMITED TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS
 * FOR A PARTICULAR PURPOSE ARE DISCLAIMED.  IN NO EVENT SHALL STANFORD
 * UNIVERSITY OR ITS CONTRIBUTORS BE LIABLE FOR ANY DIRECT, INDIRECT,
 * INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES
 * (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR
 * SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION)
 * HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT,
 * STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE)
 * ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED
 * OF THE POSSIBILITY OF SUCH DAMAGE.
 */

/**
 *  A Specialied Queue for use with BCP.  Provides control
 *   of the BCP Forwarding Engine through use of queue size
 *   thresholds set by the routing engine.
 *
 *  @author Philip Levis
 *  @author Geoffrey Mainland
 *  @author Scott Moeller
 *  @date   $Date$
 */

#include "Bcp.h"
   
module BcpSendQueueP {
  provides{
  	/*
  	 * The Forwarder will Start the SendQueue operation.
  	 *  This prevents the loss of activate / deactivate
  	 *  messages. 
  	 */
    interface StdControl as SendQueueControl; 

    interface Init;
  	
    // The Queue interface will connect to the forwarding Engine
    interface Queue<fe_queue_entry_t*>;  
    
    // The ForwarderControl interface allows activation and deactivation
    //  of the forwarding activities.
    interface BcpSendQueueForwarderIF as SendQueueForwarderIF;
  }
  
  uses{
    // Connects to the Queue Module
    interface Queue<fe_queue_entry_t*> as SubQueue;

    // Used for delay queue computations
    interface Timer<TMilli> as Timer;    
    
    // The QueueControl interface will connect to the Routing Engine
    interface BcpRouterSendQueueIF as RouterSendQueueIF;    

    // The BcpDebugIF is used for logging at the application layer
    interface BcpDebugIF;
  }
}

implementation {

  bool running = FALSE;
  bool forwarderActive = FALSE;
  uint32_t lastAgeTime;
  uint8_t  lastAgeQueueSize;
  uint32_t delayQueue_m;
  
  void computeNewDelay()
  {
    uint32_t timeDelta_m;
    uint32_t eventTime_m;
    
    dbg("SendQueue","%s: computeNewDelay()\n",__FUNCTION__);
    
    /* Increase delayQueue_m by total delay acrued
     *  since last update.
     */
    eventTime_m = call Timer.getNow();
   
    if( eventTime_m < lastAgeTime ){call BcpDebugIF.reportError(0x01);}
 
    timeDelta_m = eventTime_m - lastAgeTime;
    atomic{delayQueue_m += (timeDelta_m * lastAgeQueueSize);}
    
    // Set up for next aging
    lastAgeTime = eventTime_m;
    lastAgeQueueSize = call SubQueue.size(); // This may be out-of-date w.r.t. timestamps =(
    
    dbg("DelayQueues","%s:<totPacket,time>=<%u,%u>\n",__FUNCTION__,
         delayQueue_m, call Timer.getNow());
  
    // Enable only for debug, generates too many messages. 
    //call BcpDebugIF.reportBackpressure( call SubQueue.size(), delayQueue_m, 0x06 );
 
    return;
  }
  
  command error_t Init.init(){
    dbg("SendQueue","%s: Initializing SendQueue module.\n", __FUNCTION__);
    running = FALSE;
    lastAgeTime = 0;
    lastAgeQueueSize = 0;
    delayQueue_m = 0;
    return SUCCESS;
  }  
  
  command error_t SendQueueControl.start(){
    dbg("SendQueue","%s: Starting SendQueue module\n",__FUNCTION__);
    if( running == FALSE )
    {
      /*
       * The SendQueue was inactive, but is now active.
       */ 
      running = TRUE;
    }
    else
      dbg("WARNING","%s: SendQueue.start() called on an already started sendQueue!\n", __FUNCTION__);
      
    return SUCCESS;
  }
  
  /*
   * If we are told to stop the SendQueue, de-activate
   *  the forwarding activities too.
   */
  command error_t SendQueueControl.stop(){
  	dbg("SendQueue","%s: Stopping the SendQueue module.\n",__FUNCTION__);
    if(running == TRUE)
    {
      running = FALSE;
    }
    return SUCCESS;
  }
  
  event void Timer.fired()
  {
  }

  command fe_queue_entry_t* Queue.dequeue(){
    fe_queue_entry_t* retVal = call SubQueue.dequeue();
  
    dbg("SendQueue","%s: Queue.dequeue() called.\n",__FUNCTION__);

    if( BCP_MODE == BCP_THROUGHPUT )
    {
      uint32_t localBackpressure = call SubQueue.size();
      /*
       * Log the local backpressure 
       */
      dbg("Backpressure","%s: local Backpressure is %d@%d ms\n", __FUNCTION__, call SubQueue.size(), call Timer.getNow());
      call BcpDebugIF.reportBackpressure( localBackpressure, 0x0, 0x02 ); 
    }
    return retVal;
  }
  
  command fe_queue_entry_t* Queue.element(uint8_t idx){
    return call SubQueue.element(idx);
  }
  
  command bool Queue.empty(){
  	return call SubQueue.empty();
  }
  
  command error_t Queue.enqueue(fe_queue_entry_t* ent_p){
    error_t retVal =  call SubQueue.enqueue(ent_p);;
    
    dbg("SendQueue","%s: Queue.enqueue() called.\n",__FUNCTION__);
    
    if( BCP_MODE == BCP_THROUGHPUT )
    {
      uint32_t localBackpressure = call SubQueue.size();
      /*
       * Log the local backpressure 
       */
      dbg("Backpressure","%s: local Backpressure is %d@%d ms\n", __FUNCTION__, localBackpressure, call Timer.getNow());
      call BcpDebugIF.reportBackpressure( localBackpressure, 0x0, 0x03 ); 
    }
    return retVal;
  }
  
  command fe_queue_entry_t* Queue.head(){
    return call SubQueue.head();
  }
  
  command uint8_t Queue.maxSize(){
    return call SubQueue.maxSize();
  }
  
  command uint8_t Queue.size(){
    return call SubQueue.size();
  }
  
  /** 
   * In order for the routing engine to compute differential backlog,
   *  access is provided to the local backpressure value.
   *    
   * @return local backpressure value.
   */     
  event uint32_t RouterSendQueueIF.getBackpressure()
  {
    if(BCP_MODE == BCP_THROUGHPUT)
      return call SubQueue.size();
     else
     { 
        computeNewDelay();
        return delayQueue_m;
     }
  }
  
  command uint32_t SendQueueForwarderIF.getTotalDelay(){
  	computeNewDelay();
  	return delayQueue_m;
  }

  command uint32_t SendQueueForwarderIF.delayQueueService(uint8_t count_p)
  {
    uint32_t retVal;
    atomic{
      if( delayQueue_m < count_p*MAX_FWD_DLY )
      {
        retVal      = delayQueue_m;
        delayQueue_m = 0;
      }else{
        retVal       = count_p*MAX_FWD_DLY;
        delayQueue_m -= retVal;
      }
    }

    // Report the new backpressure level
    call BcpDebugIF.reportBackpressure( call SubQueue.size(), delayQueue_m, 0x10 );

    return retVal;
  } 

  command uint32_t SendQueueForwarderIF.delayQueueArrival(uint32_t arrivalDelay_p)
  {
    atomic{ delayQueue_m += arrivalDelay_p; }

    // Report the new backpressure level
    call BcpDebugIF.reportBackpressure( call SubQueue.size(), delayQueue_m, 0x11 );

    return delayQueue_m;
  }
}
