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

// REST includes
#include "Rest.h"

module mgmLedListP{
	uses interface Json;
	uses interface Leds; 
	uses interface Rest; 
	
	uses interface Boot; 
}
implementation{	

	/**
	 * Boot
	 */
	event void Boot.booted(){
		call Rest.bind("actuators/leds"); 
	}

	/**
	 * Geenerate the Led response
	 */
	uint16_t generateLedElement(char *buf)
	{
		char name[20]; 
		uint8_t methodList[] = {JSON_METH_GET, JSON_METH_PUT, JSON_METH_DEL}; 
		
		sprintf(name, "leds");
		
		call Json.createElement(buf, name);
		call Json.addMethod(buf,methodList , 3);
		call Json.addParamInt(buf, "red", ((call Leds.get())>>0) & 1, "b", 1, 1);
		call Json.addParamInt(buf, "yellow", ((call Leds.get())>>1) & 1, "b", 1, 0);
		call Json.addParamInt(buf, "green", ((call Leds.get())>>2) & 1, "b", 1, 0);
		
		return call Json.finishElement(buf); 
	}
	
	/**
	 * Update the Leds
	 */
	void updateLedElement(uint8_t element, uint8_t status)
	{
		uint8_t oldValue = call Leds.get(); 
		
		if (status == 1)
		{
			call Leds.set(oldValue | (1 << element)); 
		}
		else
		{
			switch (element)
			{
				case 0: 
					call Leds.set(oldValue & 6); 	// = xx0
					break; 
				case 1:
					call Leds.set(oldValue & 5); 	// = x0x 
					break; 
				case 2: 
					call Leds.set(oldValue & 3); 	// = 0xx
					break; 
				default: 
					break; 
			}
		}
	}

	/**
	 * Get a specific element
	 */
	void getElement(char *element, uint16_t len, char *buf){		
		uint16_t bufLen = generateLedElement(buf);  
		call Rest.sendData(buf, bufLen); 
	}
	
	/**
	 * Get the collection
	 */	
	void getCollection(char *collection){
		uint16_t len; 
		
		call Json.createCollection(collection, "res"); 
		call Json.addToCollection(collection, "leds", 1); 
		
		len = call Json.finishCollection(collection);
		call Rest.sendData(collection, len);
	}

	/************ Http *****************/
	event void Rest.getReceived(char *elementName, uint16_t len, char* buf){
		
		// Get the request for the collection
		if (strncmp(elementName, "*", 1) == 0)
		{
			getCollection(buf);
		}
		// Get the request for an element
		else
		{
			getElement(elementName, len, buf); 
		}
	}

	event void Rest.putReceived(char *element, uint16_t len, char *param_name, char *param_value){
		// We get a parameter to update
		// This can only be a element and not a collection
		
		// This implemetation is specific to the Leds!!!! 
		if (strcmp(param_name, "red") == 0)
			updateLedElement(0, param_value[0]-48); 
		else if (strcmp(param_name, "yellow") == 0)
			updateLedElement(1, param_value[0]-48); 
		else if (strcmp(param_name, "green") == 0)
			updateLedElement(2, param_value[0]-48); 
	}

	event void Rest.deleteReceived(char *element, uint16_t len){
		call Leds.set(0); 
	}
}
