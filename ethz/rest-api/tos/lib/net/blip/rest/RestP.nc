/* Copyright (c) 2009, Distributed Computing Group (DCG), ETH Zurich.
*  All rights reserved.
*
*  Redistribution and use in source and binary forms, with or without
*  modification, are permitted provided that the following conditions
*  are met:
*
*  1. Redistributions of source code must retain the above copyright
*     notice, this list of conditions and the following disclaimer.
*  2. Redistributions in binary form must reproduce the above copyright
*     notice, this list of conditions and the following disclaimer in the
*     documentation and/or other materials provided with the distribution.
*  3. Neither the name of the copyright holders nor the names of
*     contributors may be used to endorse or promote products derived
*     from this software without specific prior written permission.
*
*  THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS `AS IS'
*  AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE
*  IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE
*  ARE DISCLAIMED.  IN NO EVENT SHALL THE COPYRIGHT HOLDERS OR CONTRIBUTORS
*  BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR
*  CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO, LOSS OF USE, DATA,
*  OR PROFITS) HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN
*  CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE)
*  ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF
*  THE POSSIBILITY OF SUCH DAMAGE.
*
*  @author Lars Schor <lschor@ee.ethz.ch>
* 
*/

// HTTP includes
#include "Http.h"

// REST includes
#include "Rest.h"

module RestP{
	provides {
		interface Rest[uint8_t client]; 
	}
	uses {
		interface Http; 
		interface Json; 
	}
}
implementation{
	
	// Nr of client of the HTTP implementation
	enum {
    	N_CLIENTS = uniqueCount("REST_CLIENT"),
  	};	
  
  	// The local resources 
  	struct _restResource bindList[N_CLIENTS];
  	
  	// The GET buffer
  	char messageGET[500]; 
  	
	// current HTTP-Header length
	uint16_t _headerLen = 0; 
	
	/************ Local Functions ****************/
	
	/**
	 * Try to find a resource on this server
	 * @return client number of this resource
	 */
 	uint8_t findResource(char *resource)
 	{
 		int i = 0; 
 		for (i = 0; i < N_CLIENTS; i++)
 		{
 			if (strcmp (resource, bindList[i].value) == 0)
 				return i; 
 		}
 		
 		call Http.sendControl(HTTP_NOT_IMPLEMENTED); 
 		return 99; 
 	}

	/*************** HTTP ***********************/
	event void Http.received(void *payload, uint16_t len){
		// Encode the first line --> Check the request
		char *buf = (char *) payload;
		char *start; 
		uint16_t lenTemp = 0;
		char locPath[50], collection[50], element[20]; 
		
		// Find the start of the local path
		start = strchr(buf, '/');
		if (start == NULL) {
 			call Http.sendControl(HTTP_NOT_IMPLEMENTED);
 			return;
 		}
		lenTemp = (uint16_t) strcspn(start, " "); 
		
		if (lenTemp > 1)
		{
			// This is the full path (No / at the beginning)
			strncpy(locPath, start + 1, lenTemp - 1);
			locPath[lenTemp-1] = '\0';  
			
			// Try to find out the resource
			start = strrchr(locPath, '/');
			if (start == NULL) {
 				call Http.sendControl(HTTP_NOT_IMPLEMENTED); 
 				return;
 			}
			lenTemp = (uint16_t) strcspn(start, " ");
			strncpy(element, start + 1, lenTemp - 1);
			element[lenTemp - 1] = '\0';  
			
			// Can find out the collection
			strncpy(collection, locPath, start - locPath); 
			collection[start - locPath] = '\0';  
				
			// Standard GET Request
			if (strncmp (buf,"GET",3) == 0)
			{
				_headerLen = call Http.createHeader(messageGET, TRUE); 
				signal Rest.getReceived[findResource(collection)](element, (uint16_t)strlen(element), messageGET); 
			}
			
			// POST Request
			else if (strncmp (buf,"POST",4) == 0)
			{
				call Http.sendControl(HTTP_NOT_IMPLEMENTED); 
			}
			
			// PUT Request
			else if (strncmp (buf,"PUT",3) == 0)
			{
				// End of line of the Status line
				start = strstr(buf, END_LINE); 
				start = start + 2; 
				
				// Now we go through all parameters
				while (!(strstr(start, END_LINE) == NULL))
				{
					char paramName[20]; 
					char paramValue[20]; 
					
					// Name: goes until the colon [Doppelpunkt]
					lenTemp = (uint16_t) strcspn(start, ":");
					strncpy(paramName, start, lenTemp);
					paramName[lenTemp] = '\0';  
					
					// Value: Starts after the colon and goes until the end of the line
					start = strchr(start, ':');
					start = start + 2; // Go to the first element of the value
					lenTemp = (uint16_t) strcspn(start, "\r");
					strncpy(paramValue, start, lenTemp);
					paramValue[lenTemp] = '\0'; 
					
					
					signal Rest.putReceived[findResource(collection)](element, (uint16_t)strlen(element), paramName, paramValue); 
					
					start = strstr(start, END_LINE);
					start = start + 2; 
				}
				
				call Http.sendControl(HTTP_OK); 
			}
			
			// DELETE Request
			else if (strncmp (buf,"DELETE",6) == 0)
			{
				signal Rest.deleteReceived[findResource(collection)](element, (uint16_t)strlen(element)); 
				call Http.sendControl(HTTP_OK); 
			}
			
			// Request not supported
			else
			{
				call Http.sendControl(HTTP_NOT_IMPLEMENTED); 
			}
		}
		
		// This is a root request, return a list of all possible collections
		else
		{
			uint8_t i = 0; 
			uint16_t sendLen; 
			
			_headerLen = call Http.createHeader(messageGET, TRUE); 
			
			call Json.createCollection(messageGET, "col");
			
			for (i = 0; i < N_CLIENTS; i++)
 			{
				call Json.addToCollection(messageGET, bindList[i].value, i == 0 ? 1 : 0); 
 			}
						
			sendLen = call Json.finishCollection(messageGET);
			call Http.sendData(messageGET, sendLen - _headerLen); 
		}  
	}
	
	event void Http.sendDataDone(){
		// Not interesting, as the message is a buffer
		// But theoretically: Is not allowed to send more data before! 
	}

	/*************** REST ***********************/
	command void Rest.bind[uint8_t client](char * name){
		// TODO: check for a buffer overflow here if strlen(name) > 30
		strcpy(bindList[client].value, name); 
	}

	command void Rest.sendControl[uint8_t client](uint16_t code){
		
		uint16_t httpCode; 
		
		switch (code)
		{
			case REST_SUC:
				httpCode = HTTP_OK;  
				break; 
			case REST_NOT_IMPL: 
				httpCode = HTTP_NOT_IMPLEMENTED;  
				break; 
			default: 
				httpCode = HTTP_NOT_IMPLEMENTED;  
				break; 
		}
		
		call Http.sendControl(httpCode); 
	}

	command void Rest.sendData[uint8_t client](void *payload, uint16_t len){
		call Http.sendData(payload, len - _headerLen); 		
	}
	
	default event void Rest.getReceived[uint8_t app](char *element, uint16_t len, char* buf){}
	
	default event void Rest.putReceived[uint8_t app](char * element, uint16_t len, char *param, char *value){}
	
	default event void Rest.deleteReceived[uint8_t app](char *element, uint16_t len){}
}
