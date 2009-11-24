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

module CoordinatesC{
	provides{
		interface Coordinates;
	}  
	
	uses{
		 interface Random;
		 interface Boot; 
		 interface ParameterInit<uint16_t> as SeedInit;
	} 
}
implementation{
	
	//latitude value between -90 and +90 degrees (clamped)
	float latitude; 
	
	//longitude value between -180 and +180 degrees (wrapped)
	float longitude; 
	
	/**
	 * Generate a random offset for the coordinates
	 */
	float getRandomOffset() {
		uint16_t randomValueInt = call Random.rand16();
		float randomValue = (float) randomValueInt;   
		randomValue /= 0xFFFF; // value is at least 1
		randomValue /= 1000; // set the offset to the correct digit
		
		return randomValue; 
	}
	
	command float Coordinates.getLatitude() {
		return latitude; 
	}
	
	command float Coordinates.getLongitude() {
		return longitude; 
	}

	command void Coordinates.setLatitude(float myLatitude) {
		latitude = myLatitude; 
	} 
	
	command void Coordinates.setLongitude(float myLongitude) {
		longitude = myLongitude; 
	}

	/**
	 * Init the coordinates to a standard value: 
	 * Mean value: ETH ETZ building
	 * Variance: A small variance
	 * As the seed is only the TOS_NODE_ID --> Not so beautiful
	 */
	event void Boot.booted(){
		call SeedInit.init(TOS_NODE_ID); 
		latitude = ((float)47.377742) + getRandomOffset(); 
		longitude = ((float)8.55274) + getRandomOffset(); 
	}	
}