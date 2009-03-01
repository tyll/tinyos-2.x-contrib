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

#include "LM73.h"

generic module LM73LogicP() {
	
  provides interface LM73[ uint8_t client];
  provides interface SplitControl;
	
  uses interface Resource as I2CResource;
  uses interface I2CPacket<TI2CBasicAddr>;
	
}

implementation {
	
  uint8_t state = LM73_IDLE;
  uint8_t buffer[2];
  uint8_t clientId;
	
  task void failedTask() {

    switch(state) {

      case LM73_STARTUP:
	signal SplitControl.startDone(FAIL);
	break;

      case LM73_SHUTDOWN:
	signal SplitControl.stopDone(FAIL);
	break;

      case LM73_READ_TEMP:
	signal LM73.readTemperatureDone[clientId](0, FAIL);
	break;
    }
  }
	
  task void readDoneTask() {
    if (state==LM73_READ_TEMP) {
      uint16_t value = buffer[0];
      value = value << 8 | buffer[1];
      signal LM73.readTemperatureDone[clientId](value, SUCCESS);
    }
  }
	
	
  task void writeDoneTask() {
    if (state==LM73_READ_TEMP) {
      if (call I2CPacket.read(I2C_START | I2C_STOP, LM73_ADDRESS, 2, (uint8_t*)&buffer)!=SUCCESS) {
        call I2CResource.release();
	post failedTask();	
      }
      return;	
    }
    else if (state==LM73_STARTUP) signal SplitControl.startDone(SUCCESS);
    else if (state==LM73_SHUTDOWN) signal SplitControl.startDone(SUCCESS);

    call I2CResource.release();
  }


  command error_t SplitControl.start() {
    state = LM73_STARTUP;
    return call I2CResource.request();
  }

  command error_t SplitControl.stop() {
    state = LM73_SHUTDOWN;
    return call I2CResource.request();
  }

  command error_t LM73.readTemperature[uint8_t client]() {
    state = LM73_READ_TEMP;
    clientId = client;
    return call I2CResource.request();
  }
	
  event void I2CResource.granted() {
		
    uint8_t length = 1;
    uint8_t flag = I2C_START;
		
    switch(state) {
    
      case LM73_READ_TEMP:
        buffer[0] = LM73_TEMP_REG;
        break;

      case LM73_STARTUP:
	buffer[0] = LM73_CONF_REG;
        buffer[1] = LM73_POWER_UP_CMD;
        flag |= I2C_STOP;
        length = 2;
        break;
	
      case LM73_SHUTDOWN:
        buffer[0] = LM73_CONF_REG;
        buffer[1] = LM73_POWER_DOWN_CMD;
        flag |= I2C_STOP;
        break;
    }
		
    if (call I2CPacket.write(flag, LM73_ADDRESS, length, (uint8_t*)&buffer)!=SUCCESS) {
      post failedTask();
    }
  }

  async event void I2CPacket.writeDone(error_t error, uint16_t addr, uint8_t length, uint8_t *data){
    if (call I2CResource.isOwner()==FALSE) return;
    if (error==SUCCESS) post writeDoneTask();
    else post failedTask();
  }

  async event void I2CPacket.readDone(error_t error, uint16_t addr, uint8_t length, uint8_t *data){
    if (call I2CResource.isOwner()==FALSE) return;
    call I2CResource.release();
    if (error==SUCCESS) post readDoneTask();
    else post failedTask();
  }
	
	
  default event void SplitControl.startDone(error_t result) {}
  default event void SplitControl.stopDone(error_t result) {}
  default event void LM73.readTemperatureDone[uint8_t client](uint16_t value, error_t result) {}
	
}
