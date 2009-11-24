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

module DeviceC{
	provides interface Device; 
	
	uses interface Boot; 
}
implementation{
	char nodeName[20]; 
	char place[30];
	uint8_t type;
	
	command char * Device.getName(){
		return nodeName; 
	}

	command char * Device.getPlace(){
		return place; 
	}
	
	command uint8_t Device.getType(){
		return type; 
	}

	command void Device.setName(char *myName){
		strcpy(nodeName, myName); 
	}

	command void Device.setPlace(char *myPlace){
		strcpy(place, myPlace); 
	}

	event void Boot.booted(){
		// Init data
		strcpy(nodeName, "Device"); 
		strcpy(place, "ETZ G Floor"); 
		
		// Set the type
#if defined(PLATFORM_MESHBEAN900)
		type = 1; 
#elif defined(PLATFORM_PIXIE)
		type = 2; 
#endif
	}
}