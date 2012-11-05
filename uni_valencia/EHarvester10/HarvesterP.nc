/* Copyright (c) 2007 ETH Zurich.
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
*  For additional information see http://www.btnode.ethz.ch/
*
*  $Id$
*  
*/

/**
 * @author Roman Lim
 */


/* Copyright (c) 2011 Universitat de Valencia.
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
*  For additional information see http://www.uv.es/varimos/
* 
*/

/**
 * @author Manuel Delamo
 */


#include "Timer.h"
#include "Harvester.h"
#include "CtpForwardingEngine.h"

module HarvesterP {
  uses {
    // Interfaces for initialization:
    interface Boot;
    interface SplitControl as RadioControl;
    interface SplitControl as SerialControl;
    interface StdControl as RoutingControl;
    
    // Interfaces for communication, multihop and serial:
    interface AMSend as SerialSend[am_id_t id];
    interface CollectionPacket;
    interface RootControl;
    interface AMPacket;
    interface Packet;
    interface AMPacket as SerialAMPacket;
    interface Packet as SerialPacket;
    
    interface CollectionLowPowerListening;
    interface LowPowerListening;

    interface Queue<message_t *> as UARTQueue;
    interface Pool<message_t> as UARTMessagePool;

    // Miscalleny:
    interface Timer<TMilli> as SensorTimer;
    interface Timer<TMilli> as ResetTimer;
    interface Timer<TMilli> as LedsTimer;
    interface Timer<TMilli> as SendAnteriorTimer;
    interface Timer<TMilli> as ReinicioMotaTimer;
    interface Timer<TMilli> as TimerWatchDog;
    interface Leds;

    // Sensor
    interface Read<uint16_t> as ReadExternalTemperature;
    interface Read<uint16_t> as ReadExternalHumidity;   
    interface Read<uint16_t> as ReadVoltage;
    
    interface Receive as SensorReceive;
    interface Send as SensorSend;
    
    // Topology
    interface CtpInfo;

  }
}

implementation {

  task void uartSendTask();
  static void fatal_problem();
  task void envio();
  task void acumula_datos();

  uint16_t buffer_temperatura;
  uint16_t buffer_humedad;
  uint32_t temperatura_acumulada;
  uint32_t humedad_acumulada;

  uint8_t num_medida, num_medidas_ok;

  uint8_t uartlen;
  message_t sensorsendbuf;
  message_t uartbuf;
  uint8_t sensor_sn=0;
  bool sendSensorBusy=FALSE, envioAnterior = FALSE;
  bool uartbusy=FALSE, inicio=TRUE, lectura_sensor_ok=FALSE;
  error_t e=SUCCESS;
  uint16_t lplSleepInterval=LPL_INT;

  /* Current local state - interval, version and accumulated readings */
  harvester_sensor_t local, local_anterior;
  
// #######################################
//	Bootup
// #######################################
  // 
  // On bootup, initialize radio and serial communications, and our
  // own state variables.
  //
  event void Boot.booted() {

    num_medida = 0;
    num_medidas_ok = 0;

    local.id = TOS_NODE_ID;
    local.anterior = 0;

    call ResetTimer.startOneShot(INT_RESET);
   
    call Leds.led0On();
    call Leds.led1On();
    call Leds.led2On();

    call LedsTimer.startOneShot(1024);

    // Beginning our initialization phases:
    if (call RadioControl.start() != SUCCESS) {
      	fatal_problem();
    }

    if (call RoutingControl.start() != SUCCESS) {
    	fatal_problem();
    }
    else {
    	call CollectionLowPowerListening.setDefaultRxSleepInterval(lplSleepInterval);
    }

    call ReinicioMotaTimer.startOneShot(INT_REINICIO_MOTA);

    call TimerWatchDog.startPeriodic(512);//500 ms 
    atomic{   
        WDTCTL = WDTPW + WDTHOLD;//Inicializamos el WatchDog
        WDTCTL = WDT_ARST_1000;   //Iniciamos el WatchDod 1000ms
    }
  }

  event void RadioControl.startDone(error_t error) {
   	if (error != SUCCESS) {
   		fatal_problem();
   	}
   	if (
   		sizeof(harvester_sensor_t) > call SensorSend.maxPayloadLength()
   	) {
   		fatal_problem();
   	}
   	if (call SerialControl.start() != SUCCESS) {
   		fatal_problem();
   	}
  }

  event void SerialControl.startDone(error_t error) {
    if (error != SUCCESS) {
      	fatal_problem();
    }

    // This is how to set yourself as a root to the collection layer:
    if (local.id == 0 || local.id == 111 ) {
      call RootControl.setRoot();
      call LowPowerListening.setLocalSleepInterval(0);
    }
    else {
    	call SerialControl.stop();
    	call LowPowerListening.setLocalSleepInterval(lplSleepInterval);
    }
	// start periodic actions
    if (INT_SENSOR != 0)
    	call SensorTimer.startPeriodic(INT_SENSOR);
  }

  event void RadioControl.stopDone(error_t error) { }
  
  event void SerialControl.stopDone(error_t error) { }
  
// #######################################
//	Root events
// #######################################

  //
  // Only the root will receive messages from this interface; its job
  // is to forward them to the serial uart for processing on the pc
  // connected to the sensor network.
  //
  event message_t* SensorReceive.receive(message_t* msg, void *payload, uint8_t len) {
	  void * out;
	  message_t *newmsg = call UARTMessagePool.get();
	  if (newmsg == NULL) {
		  // drop the message on the floor if we run out of queue space.
   	      return msg;
	  }
	  out = (message_t*)call SerialPacket.getPayload(newmsg, len);
	  memcpy(out, payload, len);
	  call SerialAMPacket.setType(newmsg, AM_HARVESTERSENSOR);
	  call SerialPacket.setPayloadLength(newmsg, len);

	  //Prepare message to be sent over the uart
	  if (call UARTQueue.enqueue(newmsg) != SUCCESS) {
		  // drop the message on the floor and hang if we run out of
		  // queue space without running out of queue space first (this
		  // should not occur).
		  call UARTMessagePool.put(newmsg);
		  fatal_problem();
		  return msg;
	  }
    
	  if (uartbusy == FALSE) {
		  post uartSendTask();
	  }
	  return msg;
  }

  task void uartSendTask() {
  // get packet from queue and send it
  message_t * uartMsg=call UARTQueue.dequeue();
	if (uartMsg!=NULL) {
		uint8_t type=call SerialAMPacket.type(uartMsg);
		e=call SerialSend.send[type](local.id, uartMsg, call SerialPacket.payloadLength(uartMsg));
	    if (e == SUCCESS) 
    	       uartbusy = TRUE;
    }
  }

  event void SerialSend.sendDone[am_id_t id](message_t *msg, error_t error) {
  	if (call RootControl.isRoot()) {
    	uartbusy = FALSE;
    	call UARTMessagePool.put(msg);
    	if (call UARTQueue.empty() == FALSE) {
      	// We just finished a UART send, and the uart queue is
      	// non-empty.  Let's start a new one.
      	post uartSendTask();
    	}
  	}
  }
  
/*************** Data gathering ***************************************/

// #######################################
//	Sensor data
// #######################################
  /* At each sample period:
     - if local sample buffer is full, send accumulated samples
     - read next sample
  */
  event void SensorTimer.fired() {
	
        if (call ReadExternalTemperature.read() != SUCCESS)
    	     fatal_problem();   
  }

  task void envio(){

        error_t err;
        am_addr_t parent;
        uint16_t etx;

   	if (!sendSensorBusy) {
		harvester_sensor_t *o = (harvester_sensor_t *)call SensorSend.getPayload(&sensorsendbuf, sizeof(harvester_sensor_t));
                if(!envioAnterior){
		   local.dsn=sensor_sn++;
		   local.id=TOS_NODE_ID;
                   if (call CtpInfo.getParent(&parent)==SUCCESS)
			local.padre=parent;
                   else
                        local.padre=0xFFFF;

                   if (call CtpInfo.getEtx(&etx) == SUCCESS)
                      local.etx = etx;
                   else
                      local.etx=0xFFFF; 
                        
		   memcpy(o, &local, sizeof(local));
                }
                else
                   memcpy(o, &local_anterior, sizeof(local));

		err = call SensorSend.send(&sensorsendbuf, sizeof(local));
		if (err == SUCCESS)
			sendSensorBusy = TRUE;
    }
  }
  
  event void SensorSend.sendDone(message_t* msg, error_t error) {
	  if (error == SUCCESS){
                  call ResetTimer.stop();
		  call ResetTimer.startOneShot(INT_RESET);
          }
	  sendSensorBusy = FALSE;

          if(!inicio && !envioAnterior){
             envioAnterior = TRUE;
             call SendAnteriorTimer.startOneShot(INT_SEND_ANTERIOR);
          }else{
             inicio = FALSE;
             envioAnterior = FALSE;
	  }

          
          
  }

  event void SendAnteriorTimer.fired(){

        post envio();

  }

  // external Sensirion
  event void ReadExternalTemperature.readDone(error_t result, uint16_t data) {
          lectura_sensor_ok = FALSE;

	  if (result == SUCCESS) {
             lectura_sensor_ok = TRUE;
	     buffer_temperatura = data;             
          }   

	  if (call ReadExternalHumidity.read() != SUCCESS)
	     fatal_problem();
  }
  
  event void ReadExternalHumidity.readDone(error_t result, uint16_t data) {
         if (result == SUCCESS) 
             buffer_humedad = data;
         else
            lectura_sensor_ok = FALSE;

         post acumula_datos();
  }
  
  // Voltage
  event void ReadVoltage.readDone(error_t result, uint16_t data) {

      if (!inicio){
          memcpy(&local_anterior, &local, sizeof(harvester_sensor_t));
          local_anterior.anterior = 1;
      }

      local.voltaje = 0;

      if (result == SUCCESS)
        local.voltaje = data;

      local.temperatura = temperatura_acumulada;
      local.humedad = humedad_acumulada;
                                                     
      local.num_medidas = num_medidas_ok;
      num_medida = 0;
      num_medidas_ok = 0;

      post envio();    
      
  }

  task void acumula_datos(){

       if(num_medidas_ok == 0){
          temperatura_acumulada = 0;
          humedad_acumulada = 0;
       }
       
       if(lectura_sensor_ok){
          temperatura_acumulada += buffer_temperatura;
          humedad_acumulada += buffer_humedad;
          num_medidas_ok++; 
       }

       num_medida++;

       if(num_medida == NUM_MEDIDAS)
          if(call ReadVoltage.read() != SUCCESS)
		  fatal_problem();           

  }
  
// #######################################
//		Reporting
// #######################################

  static void fatal_problem() { 
    atomic{
        WDTCTL = 0;  
        while(TRUE);
    }
  } 

// #######################################
//		Timers
// #######################################

  event void ResetTimer.fired() {

     fatal_problem();

  }

  event void LedsTimer.fired() {

     call Leds.led0Off();
     call Leds.led1Off();
     call Leds.led2Off();

  }

  event void ReinicioMotaTimer.fired(){

     fatal_problem();

  }

  event void TimerWatchDog.fired(){

        atomic{
           WDTCTL = WDTPW + WDTCNTCL;
           WDTCTL = WDT_ARST_1000;
        }
  }
  
}

