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

generic module TSL2550LogicP() {
  
  provides interface TSL2550[ uint8_t client];
  provides interface SplitControl;
  
  uses interface Boot;
  uses interface Resource as I2CResource;
  uses interface I2CPacket<TI2CBasicAddr>;
  
}

implementation {
  
  uint8_t cmd;
  uint8_t adc_value;
  uint8_t clientId;
  
  task void failedTask() {
    switch(cmd) {
    
      case TSL2550_POWER_UP:
        signal SplitControl.startDone(FAIL);
        break;

      case TSL2550_POWER_DOWN:
        signal SplitControl.stopDone(FAIL);
        break;
      
      case TSL2550_READ_ADC_0:
        signal TSL2550.readChannel0Done[clientId](0, FAIL);
        break;
      
      case TSL2550_READ_ADC_1:
        signal TSL2550.readChannel1Done[clientId](0, FAIL);
        break;
    }
  }
  
  task void readDoneTask() {
    if (cmd==TSL2550_READ_ADC_0) signal TSL2550.readChannel0Done[clientId](adc_value, SUCCESS);
    else if (cmd==TSL2550_READ_ADC_1) signal TSL2550.readChannel1Done[clientId](adc_value, SUCCESS);
  }
  
  
  task void writeDoneTask() {
    if (cmd==TSL2550_READ_ADC_0 || cmd==TSL2550_READ_ADC_1) {
      if (call I2CPacket.read(I2C_START | I2C_STOP, TSL2550_ADDRESS, sizeof(adc_value), &adc_value)!=SUCCESS) {
        call I2CResource.release();
        post failedTask();  
      }
      return;  
    }
    else if (cmd==TSL2550_POWER_UP) signal SplitControl.startDone(SUCCESS);
    else if (cmd==TSL2550_POWER_DOWN) signal SplitControl.startDone(SUCCESS);

    call I2CResource.release();
  }


  command error_t SplitControl.start(){
    cmd = TSL2550_POWER_UP;
    return call I2CResource.request();
  }

  command error_t SplitControl.stop(){
    cmd = TSL2550_POWER_DOWN;
    return call I2CResource.request();
  }

  
  command error_t TSL2550.readChannel0[uint8_t client](){
    cmd = TSL2550_READ_ADC_0;
    clientId = client;
    return call I2CResource.request();
  }
  
  command error_t TSL2550.readChannel1[uint8_t client](){
    cmd = TSL2550_READ_ADC_1;
    clientId = client;
    return call I2CResource.request();
  }
  

  event void I2CResource.granted(){
    if (call I2CPacket.write(I2C_START | I2C_STOP, TSL2550_ADDRESS, sizeof(cmd), &cmd)!=SUCCESS) {
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
  

  event void Boot.booted(){
    call SplitControl.start();
  }
  
  default event void SplitControl.startDone(error_t result) {}
  default event void SplitControl.stopDone(error_t result) {}
  
  default event void TSL2550.readChannel0Done[uint8_t client](uint8_t value, error_t result) {}
  default event void TSL2550.readChannel1Done[uint8_t client](uint8_t value, error_t result) {}

}
