/*
 * Copyright (c) 2005-2006 Rincon Research Corporation
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
 * - Neither the name of the Rincon Research Corporation nor the names of
 *   its contributors may be used to endorse or promote products derived
 *   from this software without specific prior written permission.
 *
 * THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS
 * ``AS IS'' AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT
 * LIMITED TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS
 * FOR A PARTICULAR PURPOSE ARE DISCLAIMED.  IN NO EVENT SHALL THE
 * RINCON RESEARCH OR ITS CONTRIBUTORS BE LIABLE FOR ANY DIRECT, INDIRECT,
 * INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES
 * (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR
 * SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION)
 * HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT,
 * STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE)
 * ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED
 * OF THE POSSIBILITY OF SUCH DAMAGE
 */

#include "priority.h"

module PriorityQueueP 
{

  provides interface AMSend[ am_id_t amId ];
  provides interface AmRegistry[ am_id_t amId ];
  
  uses interface AMSend as SubSend[ am_id_t amId ];
  uses interface State;
  uses interface Leds;
}

implementation 
{
/*
  message_t* queue[ QUEUE_SIZE ];
  uint8_t priorities[ QUEUE_SIZE ];
  uint8_t amIds[ QUEUE_SIZE ];
  uint8_t addresses[ QUEUE_SIZE ]; 
  uint8_t lengths[ QUEUE_SIZE ];
 */
  queue_t queue[ QUEUE_SIZE ];
  uint8_t index = 0;
  message_t* curSend;
  message_t* cancel_msg;
  uint8_t cancel_id;
  
  enum 
  {
    S_IDLE = 0,
    S_SENDING_REG = 1,
    S_SENDING_QUEUE = 2,
  };
  
  /********************** Local Functions ***********************/
  error_t deleteMsg(message_t* msg);
  task void sendNextMsg();
  task void sendCancel();
  
  /************************* AMSend commands *********************/
  command error_t AMSend.send[ am_id_t amId ](am_addr_t addr, message_t* msg, uint8_t len)
  {
    priority_t p;
    queue_t* q;
    p = signal AmRegistry.configure[ amId ](msg);
    //if the queue is full, return fail
    if(index == QUEUE_SIZE)
    {
      return FAIL;
    }
    
    //queue it up
    q = &queue[index];
    atomic
    { 
      q -> msg = msg;
      q -> amId = amId;
      q -> addr = addr;
      q -> len = len;
      q -> priority = p;
      
      /*
      queue[index] = msg;
      amIds[index] = amId;
      addresses[index] = addr;
      lengths[index] = len;
      priorities[index] = p;
      */
      index++;
    }
    if(index == 1)  //it is the only message in the queue, send immediately
    {
      return call SubSend.send[ amId ](addr, msg, len);
    }
    return SUCCESS;
  }
  
  command error_t AMSend.cancel[ am_id_t amId ](message_t* msg)
  {
    error_t e;
    if(curSend == msg)
    {
      return call SubSend.cancel[ amId ](msg); //will this always signal out a sendDone event 
      											//TODO write unit test to test this case
    }
    else
    {
      //according to interface, if successfully canceled, still need to signal
      //senddone event as a fail???
      e = deleteMsg(msg);
      if(e == SUCCESS)
      {
        atomic
        {
          cancel_msg = msg;
          cancel_id = amId;
        }
        post sendCancel();
      }
      return e;
    }
     
  }
  
  command uint8_t AMSend.maxPayloadLength[ am_id_t amId ]()
  {
    return call SubSend.maxPayloadLength[ amId ]();
  }
  
  command void* AMSend.getPayload[ am_id_t amId ](message_t* msg, uint8_t len)
  {
    return call SubSend.getPayload[ amId ](msg, len);
  }
  
  /**************** SubSend Events **********************/
  event void SubSend.sendDone[ am_id_t amId ](message_t* msg, error_t error)
  {
    deleteMsg(msg);
    if(index != 0)
    {
      post sendNextMsg();
    }
    else
    {
      call State.toIdle();
    }
    signal AMSend.sendDone[ amId ](msg, error);
  }
  
  /***************** Local Functions ***********************/
  error_t deleteMsg( message_t* msg )
  {
    
    uint8_t i, j, curIndex;
    queue_t* q;
    queue_t* q1;
    atomic
    {
      curIndex = index;
      for(i = 0; i < index; i++)
      {
        //if this is the one to delete
        if( msg == queue[ i ].msg){ //TODO: Is it best to work off msg ptr or am type????
        						 // can two different am types share the same message_t??
          //move all other messages up the in queue
          for(j = i + 1; j < index; j++){
            q = &queue[ j ];
            q1 = &queue[ j - 1 ]; 
            
            memcpy(q1, q, sizeof(queue_t));
            //q1 -> msg = q -> msg;
      	  	//q1 -> amId = q -> amId;
      		//q1 -> addr = q -> addr;
      		//q1 -> len = q -> len;
      		//q1 -> priorities[j - 1] = priorities[j];
      		
          }
          index--;
          break;
        }
      }
    }
    if(i == curIndex)
    {
      return FAIL;
    }
    else
    {
      return SUCCESS;
    }
    
  }
  
 /***************** Tasks *******************************/ 
  task void sendNextMsg()
  {
    uint8_t i, high_priority;
    queue_t* q;
    high_priority = P_LOWEST;
    q = &queue; //if nothing is higher than p lowest, return the first message;
    atomic
    {
      for(i = 0; i < index; i++)
      {
        if(queue[ i ].priority > high_priority)
        {
          high_priority = queue[ i ].priority;
          q = &queue[ i ];
        }      
      }
    }
    if(call SubSend.send[ q -> amId ](q -> addr, q -> msg, q -> len) != SUCCESS)
    {
      post sendNextMsg();
    }   
  
  }
  
  task void sendCancel(){
  
    uint8_t amId;
    uint8_t msg;
    atomic
    {
      amId = cancel_id;
      msg = cancel_msg;
    }
    signal AMSend.sendDone[ amId ](msg, ECANCEL);
  }
  
  /*************** Default AmRegistry ******************/
  default event priority_t AmRegistry.configure[ am_id_t id ]( message_t* msg )
  {
    return P_LOWEST;
  }

}


