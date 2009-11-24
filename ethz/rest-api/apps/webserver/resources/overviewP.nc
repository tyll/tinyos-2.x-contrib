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

// REST includes
#include "Rest.h"

module overviewP{
	uses interface Json;
	uses interface Rest; 
	uses interface Boot; 
	

	uses interface Timer<TMilli>  as SensingTimer;
#if defined(PLATFORM_MESHBEAN900)
	uses interface Read<uint8_t>  as LightChannel1;
	uses interface Read<uint8_t>  as LightChannel2;
	uses interface Read<uint16_t>  as TempChannel;
#endif
	uses interface Device; 
}
implementation{	

	/************* Variables ***********/
	uint8_t lightValue1; 
	uint8_t lightValue2; 
	uint16_t temperatureValue; 

	/************* Boot ****************/
	event void Boot.booted(){
		call Rest.bind("mashup/info"); 
		
		call SensingTimer.startPeriodic(1000);
	}

	/**
	 * Generates the Element-Response
	 */
	void getElement(char *buf, char *element, uint16_t len){		
		uint16_t bufLen = 0; 
		uint8_t methodList[] = {JSON_METH_GET}; 
		
		call Json.createElement(buf, "Coordinates");
		call Json.addMethod(buf,methodList , 2);
		call Json.addParamString(buf, "name", call Device.getName(), 0, 1);
		call Json.addParamString(buf, "place", call Device.getPlace(), 0, 0);
		call Json.addParamInt(buf, "type", call Device.getType(), "i", 0, 0); 
#if defined(PLATFORM_MESHBEAN900)
		call Json.addParamInt(buf, "Light1", lightValue1, "i", 0, 0);
		call Json.addParamInt(buf, "Light2", lightValue2, "i", 0, 0);
		call Json.addParamInt(buf, "Temp", temperatureValue, "i", 0, 0); 
#endif
		bufLen = call Json.finishElement(buf); 
		call Rest.sendData(buf, bufLen); 
	}
		
	/**
	 * Generates the Collection-Response
	 */
	void getCollection(char *collection){
		uint16_t len; 
		
		// Add all elements one have and send them as resources
		call Json.createCollection(collection, "res"); 
		call Json.addToCollection(collection, "values", 1); 
		
		len = call Json.finishCollection(collection);
		call Rest.sendData(collection, len);
	}

	/************ REST *****************/
	event void Rest.getReceived(char *elementName, uint16_t len, char *buf){
				
		// Get the request for the collection
		if (strncmp(elementName, "*", 1) == 0)
		{
			getCollection(buf);
		}
		// Get the request for an element
		else
		{
			getElement(buf, elementName, len); 
		}
	}

	event void Rest.putReceived(char *element, uint16_t len, char *param_name, char *param_value){
	}

	event void Rest.deleteReceived(char *elementName, uint16_t len){
	}
	
	/************ SensingTimer **********/
	event void SensingTimer.fired(){
#if defined(PLATFORM_MESHBEAN900)
		call LightChannel1.read();
		call LightChannel2.read();
		call TempChannel.read(); 
#endif
	}

#if defined(PLATFORM_MESHBEAN900)
	/*********** LightChannel1 *****************/
	event void LightChannel1.readDone(error_t result, uint8_t val){
		lightValue1 = val; 
	}
	
	/*********** LightChannel2 *****************/
	event void LightChannel2.readDone(error_t result, uint8_t val){
		lightValue2 = val; 
	}

	/*********** Temperatur ********************/
	event void TempChannel.readDone(error_t result, uint16_t val){
		temperatureValue = val; 
	}
#endif
}
