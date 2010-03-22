/*
 * Copyright (c) 2004, Technische Universitaet Berlin
 * All rights reserved.
 *
 * Redistribution and use in source and binary forms, with or without 
 * modification, are permitted provided that the following conditions 
 * are met:
 * - Redistributions of source code must retain the above copyright notice,
 *   this list of conditions and the following disclaimer.
 * - Redistributions in binary form must reproduce the above copyright 
 *   notice, this list of conditions and the following disclaimer in the 
 *   documentation and/or other materials provided with the distribution.
 * - Neither the name of the Technische Universitaet Berlin nor the names 
 *   of its contributors may be used to endorse or promote products derived
 *   from this software without specific prior written permission.
 *
 * THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS 
 * "AS IS" AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT 
 * LIMITED TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR
 * A PARTICULAR PURPOSE ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT 
 * OWNER OR CONTRIBUTORS BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, 
 * SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED 
 * TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, 
 * OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY 
 * OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT 
 * (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE 
 * USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
 *
 * - Description ----------------------------------------------------------
 * Obsolete, use HIL interface (wrappers) instead.
 * nesC will issue a warning about bind() being called asynchronously,
 * which can be ignored.
 * - Revision -------------------------------------------------------------
 * $Revision$
 * $Date$
 * @author Vlado Handziski <handzisk@tkn.tu-berlin.de>
 * @author Jan Hauer <hauer@tkn.tu-berlin.de>
 * @author: Kevin Klues <klues@tkn.tu-berlin.de>
 * ========================================================================
 */



#include "PrintfUART.h"
#include "Msp430Adc12.h"


module ADCP
{
  provides {
    
    interface Read<uint16_t> as ReadADC[uint16_t id];
    interface ADCControl;
    interface Init;

  }
  uses {
    interface Boot;
    interface Leds;
    interface SensorControl;
    interface Read<uint16_t> as AdcRead[uint16_t id];
  }
}

implementation
{
  #define DATA_QUEUE_SIZE 40
  nx_struct reading
  {
    nx_uint16_t data;
    nx_uint8_t id;
  }reading[DATA_QUEUE_SIZE];

  norace uint8_t dataindex = 0;
  norace uint8_t taskBusy = 0;

  norace int8_t queue_head;
  norace int8_t queue_tail;
  norace uint8_t queue_size;
  norace uint8_t queue[DATA_QUEUE_SIZE];

  norace uint16_t owner;


  void enqueue(uint8_t value);
  uint8_t dequeue();
  task void signalOneSensor();
  task void readADCTask();


  event void Boot.booted()
  {
    return;
  }
  
  command error_t Init.init() { 
    printfUART_init();
    return SUCCESS;
   }
  

  command error_t ADCControl.bindPort(uint8_t client, uint8_t adcPort) 
  {  

      call SensorControl.bindPort(client,adcPort);
      return SUCCESS; 
  }

  command int ADCControl.getInterrupt(uint8_t client){
	return call SensorControl.getInterrupt(client);
 }

  void enqueue(uint8_t value) {
    if (queue_tail == DATA_QUEUE_SIZE - 1) {
      atomic queue_tail = -1;
    }
    atomic {
      queue_tail++;
      queue_size++;
      queue[(uint8_t)queue_tail] = value;
    }
  }

  uint8_t dequeue() {
    if (queue_size == 0){
      return DATA_QUEUE_SIZE;
    }
    else {
      if (queue_head == DATA_QUEUE_SIZE - 1) {
        queue_head = -1;
      }
      atomic {
        queue_head++;
        queue_size--;
      }
      return queue[(uint8_t)queue_head];
    }
  }

  task void signalOneSensor() {
    uint8_t client;

    if ((client=dequeue())< DATA_QUEUE_SIZE) {
      signal ReadADC.readDone[reading[client].id](SUCCESS,reading[client].data);
      atomic taskBusy = post signalOneSensor();
    }
    else {
      atomic taskBusy = FALSE;
    }
  }

  task void readADCTask() {
	//call AdcRead.read[owner]();
  }

  command error_t ReadADC.read[uint16_t client](){

    if (client>=MAX_SENSOR_NUM) {
      return FAIL;
    }
    owner = client;
    call AdcRead.read[owner]();
    //post readADCTask();

    return SUCCESS;
  }

 event void AdcRead.readDone[uint16_t client](error_t result, uint16_t data)
 {
	
    //PXDBG(printfUART("AdcRead.readDone with data %d w client %d.\n",(int)data,(int)client));
    reading[dataindex].id = client;
    reading[dataindex].data = data;

    enqueue(dataindex);
    if (++dataindex >=DATA_QUEUE_SIZE) {
      dataindex = 0;
    }
    if (TRUE != taskBusy) {
      atomic taskBusy = post signalOneSensor();
    }
    //signal ReadADC.readDone[client](result,data);
    return;
 }




}

