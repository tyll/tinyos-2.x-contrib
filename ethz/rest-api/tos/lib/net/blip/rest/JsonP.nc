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

// Standard includes
#include <stdio.h>
#include <string.h>

// Rest includes
#include "Rest.h"

module JsonP{
	provides 
	{
		interface Json;
	}
}
implementation{
	
	/************ Element *****************/
	command void Json.createElement(char * jsonElement, char *deviceName){
		// Update the device name
		strcat(jsonElement, "{\"device\": \"");
		strcat(jsonElement, deviceName);
		strcat(jsonElement, "\", ");
	}

	command void Json.addMethod(char * jsonElement, uint8_t method[], uint8_t len){
		
		uint8_t i;
		char meth [2]; 
		
		strcat(jsonElement, "\"method\": [");
		
		for (i = 0; i < len; i++)
		{
			switch (method[i])
			{
				case JSON_METH_GET:
					meth[0] = 'G'; meth[1] = '\0';   
					break; 
					
				case JSON_METH_PUT:
					meth[0] = 'U'; meth[1] = '\0';
					break;
					
				case JSON_METH_POST:
					meth[0] = 'O'; meth[1] = '\0';
					break;
				
				case JSON_METH_DEL:
					meth[0] = 'D'; meth[1] = '\0';
					break;  	
				default: 
					break; 
			}
			
			if (i > 0)
				strcat(jsonElement, ", ");
				
			strcat(jsonElement, "\"");
			strcat(jsonElement, meth);
			strcat(jsonElement, "\"");
		}
		
		strcat(jsonElement, "], ");
	}
	
	command void Json.addParamInt(char * jsonElement, char *name, uint16_t value, char *type, uint8_t update, uint8_t first){
		char temp[10]; 
		
		if (first)
		{
			strcat(jsonElement,"\"param\": ["); 
		}
		else
		{
			strcat(jsonElement,", "); 
		}
		
		// Add the name value
		strcat(jsonElement, "{\"n\": \"");
		strcat(jsonElement, name);
		strcat(jsonElement, "\"");
		
		// Add the value
		strcat(jsonElement, ", \"v\": ");
		sprintf(temp, "%d", value); 
		strcat(jsonElement, temp);	
			
		// Add the type
		strcat(jsonElement, ", \"t\": \"");
		strcat(jsonElement, type);
		strcat(jsonElement, "\"");
		
		// Add the updatable {0,1}
		strcat(jsonElement, ", \"u\": ");
		sprintf(temp, "%d", update); 
		strcat(jsonElement, temp);
		strcat(jsonElement, "}");	
	}
	
	command void Json.addParamFloat(char * jsonElement, char *name, float value, uint8_t update, uint8_t first){
		char temp[15]; 
		
		if (first)
		{
			strcat(jsonElement,"\"param\": ["); 
		}
		else
		{
			strcat(jsonElement,", "); 
		}
		
		// Add the name value
		strcat(jsonElement, "{\"n\": \"");
		strcat(jsonElement, name);
		strcat(jsonElement, "\"");
		
		// Add the value
		strcat(jsonElement, ", \"v\": ");

		sprintf(temp, "%ld.%06ld\n", (long int)value, (long int)((value - (long int)value) * 1000000)); 
		strcat(jsonElement, temp);	
			
		// Add the type
		strcat(jsonElement, ", \"t\": \"f\"");
		
		// Add the updatable {0,1}
		strcat(jsonElement, ", \"u\": ");
		sprintf(temp, "%d", update); 
		strcat(jsonElement, temp);
		strcat(jsonElement, "}");	
	}
	
	command void Json.addParamString(char * jsonElement, char *name,  char *value, uint8_t update, uint8_t first){
		char temp[5]; 
		
		if (first)
		{
			strcat(jsonElement,"\"param\": ["); 
		}
		else
		{
			strcat(jsonElement,", "); 
		}
		
		// Add the name value
		strcat(jsonElement, "{\"n\": \"");
		strcat(jsonElement, name);
		strcat(jsonElement, "\"");
		
		// Add the value
		strcat(jsonElement, ", \"v\": \"");
		strcat(jsonElement, value);	
		strcat(jsonElement, "\"");
			
		// Add the type
		strcat(jsonElement, ", \"t\": \"s\"");
		
		// Add the updatable {0,1}
		strcat(jsonElement, ", \"u\": ");
		sprintf(temp, "%d", update); 
		strcat(jsonElement, temp);
		strcat(jsonElement, "}");	
	}
	
	command uint16_t Json.finishElement(char *jsonElement){
		strcat(jsonElement, "]}");
		return((uint16_t)strlen(jsonElement)); 
	}
	
	/************ Collection *****************/
	command void Json.createCollection(char *col, char *name) {
		// Update the device name
		strcat(col, "{\"");
		strcat(col, name);
		strcat(col, "\": [");
	} 
	 
	command void Json.addToCollection(char *col, char *elem, uint8_t first) {
		
		if (first)
		{
			strcat(col,"\""); 
		}
		else
		{
			strcat(col,", \""); 
		}
		
		strcat(col, elem);
		strcat(col,"\"");
	}
	
	command uint16_t Json.finishCollection(char *col) {
		strcat(col,"]}");
		return (uint16_t)strlen(col);  
	}	
}