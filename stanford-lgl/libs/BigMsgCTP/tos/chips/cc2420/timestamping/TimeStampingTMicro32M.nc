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
*   from this software without specific prior written permission
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
 * Based on code developed at Vanderbilt University.
 * @author Brano Kusy (branislav.kusy@gmail.com)
 */ 

#include "AM.h"

module TimeStampingTMicro32M
{
    provides
    {
      interface TimeStamping<TMicro,uint32_t> as TimeStampingTMicro32;
    }
    uses
    {
        interface RadioTimeStamping;
        interface CC2420Transmit;
        interface LocalTime<TMicro> as LocalTime;
    }
}

implementation
{
  // the offset of the time-stamp field in the message, 
  // or -1 if no stamp is necessariy.
  int8_t sendStampOffset = -1;
	message_t* sendMsg;
	uint32_t receiveTime;
   
    enum{
        SEND_TIME_CORRECTION = 0,
    };

        
    //this needs to be called right after SendMsg.send() returned success, so 
    //the code in addStamp() method runs before a task in the radio stack is 
    //posted that writes to fifo -> which triggers coordinator event 
    command error_t TimeStampingTMicro32.addStamp(message_t* msg, int8_t offset)
    {
			uint8_t ret = FAIL;

			if( 0 <= offset && offset <= TOSH_DATA_LENGTH - 4  )
			{
				atomic
				{
					sendStampOffset = offset;
					sendMsg = msg;
					ret = SUCCESS;
				}
			}
			return ret;
    }
    
    async event void RadioTimeStamping.transmittedSFD( uint16_t time, message_t* p_msg ) 
    {
	    uint32_t curr_time = call LocalTime.get(); 
	    int8_t offsetCopy = -1;

			atomic
			{
			    if( sendStampOffset >= 0 && p_msg == sendMsg )
				    offsetCopy = sendStampOffset;
			}
		
			if( offsetCopy >= 0 )
			{
					nx_uint32_t nx_time;
			    nx_time = *(nx_uint32_t*)((void*)p_msg->data + offsetCopy) + curr_time;
	        call CC2420Transmit.modify( sizeof(cc2420_header_t)+offsetCopy,  (void*)&nx_time,  4);
		        
			    atomic sendStampOffset = -1;
			}
    }

    async event void RadioTimeStamping.receivedSFD( uint16_t time )
    {
	    uint32_t al_time = call LocalTime.get()+ SEND_TIME_CORRECTION; 
			atomic receiveTime = al_time;
    }

  	command uint32_t TimeStampingTMicro32.getStamp()
  	{
			uint32_t time;
			atomic time = receiveTime;
		
			return time;
    }

    async event void CC2420Transmit.sendDone( message_t* p_msg, error_t error ){}
}
