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
*  @author Philipp Sommer <sommer@tik.ee.ethz.ch>
* 
* 
*/


#include "TSL2550.h"

generic module TSL2550ReaderP() {
	
  provides interface Read<uint8_t> as Channel0;
  provides interface DeviceMetadata as Channel0Metadata;
	
  provides interface Read<uint8_t> as Channel1;
  provides interface DeviceMetadata as Channel1Metadata;
	
  uses interface Resource as Resource0;
  uses interface Resource as Resource1;
  uses interface TSL2550;
	
}


implementation {
	
	
  event void Resource0.granted(){
    if (call TSL2550.readChannel0()!=SUCCESS) {
      call Resource0.release();
      signal Channel0.readDone(FAIL, 0);
    }
  }
	
  event void Resource1.granted(){
    if (call TSL2550.readChannel1()!=SUCCESS) {
      call Resource1.release();
      signal Channel1.readDone(FAIL, 0);
    }
  }

  command error_t Channel0.read(){
    return call Resource0.request();
  }

  command error_t Channel1.read(){
    return call Resource1.request();
  }

  command uint8_t Channel0Metadata.getSignificantBits(){
    return 8;
  }

  command uint8_t Channel1Metadata.getSignificantBits(){
   return 8;
  }


  event void TSL2550.readChannel0Done(uint8_t value, error_t result){
    call Resource0.release();
    signal Channel0.readDone(result, value);				
  }
	
  event void TSL2550.readChannel1Done(uint8_t value, error_t result){
    call Resource1.release();
    signal Channel1.readDone(result, value);
  }

  default event void Channel0.readDone(error_t result, uint8_t val ) {}
  default event void Channel1.readDone(error_t result, uint8_t val ) {}

}
