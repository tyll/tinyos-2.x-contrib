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
    interface Timer<TMilli> as TopologyTimer;
    interface Timer<TMilli> as StatusTimer;
    interface Leds;
    
    // DSN
    interface DsnSend as DSN;
    interface DsnCommand<uint16_t> as LplCommand;

    // Sensor
    interface Read<uint16_t> as ReadExternalTemperature;
    interface Read<uint16_t> as ReadExternalHumidity;
    interface Read<uint16_t> as ReadInternalTemperature;
    interface Read<uint16_t> as ReadInternalHumidity;
    interface Read<uint16_t> as ReadVoltage;
    //interface Read<uint16_t> as ReadLight1;
    //interface Read<uint16_t> as ReadLight2;
    interface Receive as SensorReceive;
    interface Send as SensorSend;
    
    // Topology
    interface CtpInfo;
    interface Receive as TopologyReceive;
    interface Send as TopologySend;
    
    // Status
    interface Receive as StatusReceive;
    interface Send as StatusSend;

    // for statistics
    interface PacketAcknowledgements;
    
    // interface Read<uint16_t> as ReadCpuLoad;
    // interface Timer<TMilli> as LoadTimer;
    
    // interface NeighbourSyncRequest;
  }
}

implementation {
  task void uartSendTask();
  static void startTimer();
  static void fatal_problem();
  static void report_problem();
  static void report_sent(message_t* msg);
  static void report_received(message_t* msg);

  uint8_t uartlen;
  message_t sensorsendbuf, topologysendbuf, statussendbuf;
  message_t uartbuf;
  harvester_topology_t * tinfo;
  uint8_t sensor_sn=0, topology_sn=0, status_sn=0;
  bool sendTopologyBusy=FALSE, sendSensorBusy=FALSE, sendStatusBusy=FALSE;
  bool uartbusy=FALSE;
  error_t e=SUCCESS;
  uint16_t lplSleepInterval=LPL_INT;

  /* Current local state - interval, version and accumulated readings */
  harvester_sensor_t local;
  
// #######################################
//	Bootup
// #######################################
  // 
  // On bootup, initialize radio and serial communications, and our
  // own state variables.
  //
  event void Boot.booted() {
    local.id = TOS_NODE_ID;
    
    call DSN.logInt(call AMPacket.address());
    call DSN.logInfo("Node %i booted");

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
  }

  event void RadioControl.startDone(error_t error) {
   	if (error != SUCCESS) {
   		fatal_problem();
   	}
   	if (
   		sizeof(harvester_sensor_t) > call SensorSend.maxPayloadLength() ||
   		sizeof(harvester_topology_t) > call TopologySend.maxPayloadLength() ||
   		sizeof(harvester_status_t) > call StatusSend.maxPayloadLength() 
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
    if (INT_TOPOLOGY != 0)
    	call TopologyTimer.startPeriodic(INT_TOPOLOGY);
    if (INT_STATUS != 0)
    	call StatusTimer.startPeriodic(INT_STATUS);
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
		  report_problem();
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
  
  event message_t* TopologyReceive.receive(message_t* msg, void *payload, uint8_t len) {
	  void * out;
      message_t *newmsg = call UARTMessagePool.get();
      if (newmsg == NULL) {
    	  // drop the message on the floor if we run out of queue space.
          report_problem();
          return msg;
      }
      out = call SerialPacket.getPayload(newmsg, len);
      memcpy(out, payload, len);
      call SerialAMPacket.setType(newmsg, AM_HARVESTERTOPOLOGY);
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
      report_received(msg);
      if (uartbusy == FALSE) {
        post uartSendTask();
      }
      return msg;
  }

  event message_t* StatusReceive.receive(message_t* msg, void *payload, uint8_t len) {
	  void * out;
	  message_t *newmsg = call UARTMessagePool.get();
	  if (newmsg == NULL) {
		  // drop the message on the floor if we run out of queue space.
		  report_problem();
    	  return msg;
	  }
	  out = call SerialPacket.getPayload(newmsg, len);
	  memcpy(out, payload, len);
	  call SerialAMPacket.setType(newmsg, AM_HARVESTERSTATUS);
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
	  report_received(msg);
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
	    if (e != SUCCESS) {
    	  report_problem();
	    } else {
    	  uartbusy = TRUE;
    	}
    }
  }

  event void SerialSend.sendDone[am_id_t id](message_t *msg, error_t error) {
  	if (call RootControl.isRoot()) {
    	uartbusy = FALSE;
    	call UARTMessagePool.put(msg);
    	if (error != SUCCESS) 
	    	report_problem();
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
	error_t err;
   	if (!sendSensorBusy) {
		harvester_sensor_t *o = (harvester_sensor_t *)call SensorSend.getPayload(&sensorsendbuf, sizeof(harvester_sensor_t));
		local.dsn=sensor_sn++;
		local.id=TOS_NODE_ID;
		memcpy(o, &local, sizeof(local));
		err = call SensorSend.send(&sensorsendbuf, sizeof(local));
		if (err == SUCCESS)
			sendSensorBusy = TRUE;
        else {
        	report_problem();
        	call DSN.logInt(err);
      		call DSN.logError("SensorData:Send failed (%i)");
        }
    }
    else {
  		call DSN.logError("SensorData:Radio busy");
    }  	
   	local.light1=0;
   	local.light2=0;
    if (call ReadExternalTemperature.read() != SUCCESS)
    	fatal_problem();
  }
  
  event void SensorSend.sendDone(message_t* msg, error_t error) {
	  if (error == SUCCESS)
		  report_sent(msg);
	  else {
		  report_problem();
		  call DSN.logInt(error);
		  call DSN.logError("Sensordata:SendDone failed (%i)");
	  }
	  sendSensorBusy = FALSE;
  }

  // external Sensirion
  event void ReadExternalTemperature.readDone(error_t result, uint16_t data) {
	  if (result != SUCCESS) {
		  data = 0xffff;
		  report_problem();
	  }
	  local.light1|=result;
	  local.temp_external = data;
	  if (call ReadExternalHumidity.read() != SUCCESS)
		  fatal_problem();
  }
  
  event void ReadExternalHumidity.readDone(error_t result, uint16_t data) {
       if (result != SUCCESS) {
         data = 0xffff;
         report_problem();
       }
       local.light1|=result<<4;
       local.hum_external = data;
       if (call ReadInternalTemperature.read() != SUCCESS)
         fatal_problem();
  }
  // internal Sensirion
  event void ReadInternalTemperature.readDone(error_t result, uint16_t data) {
	  if (result != SUCCESS) {
		  data = 0xffff;
		  report_problem();
	  }
	  local.light2|=result;
	  local.temp_internal = data;
	  if (call ReadInternalHumidity.read() != SUCCESS)
		  fatal_problem();
  }
  
  event void ReadInternalHumidity.readDone(error_t result, uint16_t data) {
         if (result != SUCCESS) {
           data = 0xffff;
           report_problem();
         }
         local.light2|=result<<4;
         local.hum_internal = data;
         if (call ReadVoltage.read() != SUCCESS)
           fatal_problem();
  }
  // Voltage
  event void ReadVoltage.readDone(error_t result, uint16_t data) {
      if (result != SUCCESS) {
        data = 0xffff;
        report_problem();
      }
      local.voltage = data;
      /*if (call ReadLight1.read() != SUCCESS)
        fatal_problem(); */
  }
  /*
  // Light 1&2
  event void ReadLight1.readDone(error_t result, uint16_t data) {
      if (result != SUCCESS) {
        data = 0xffff;
        report_problem();
      }
      local.light1 = data;
      if (call ReadLight2.read() != SUCCESS)
        fatal_problem();
    }
  event void ReadLight2.readDone(error_t result, uint16_t data) {
      if (result != SUCCESS) {
        data = 0xffff;
        report_problem();
      }
      local.light2 = data;
  }*/
  
// #######################################
// Harvester Topology
// #######################################
  
  event void TopologyTimer.fired() {
  	am_addr_t parent;
  	uint8_t i;
  	error_t err;
  	uint8_t numNeighbours;
  	
  	if (!sendTopologyBusy) {
  		harvester_topology_t *info = (harvester_topology_t *)call TopologySend.getPayload(&topologysendbuf, sizeof(harvester_topology_t));
  		for (i=0;i<5;i++)
  			info->neighbour_id[i]=0xffff;
  		if (call CtpInfo.getParent(&parent)==SUCCESS) {
			info->parent=parent;
			numNeighbours = call CtpInfo.numNeighbors();
			for (i=0;i<numNeighbours;i++) {
				if (i<5)
					info->neighbour_id[i]=call CtpInfo.getNeighborAddr(i);
				if (call CtpInfo.getNeighborAddr(i)==parent)	
					info->parent_etx=call CtpInfo.getNeighborRouteQuality(i);
			}
		}
		else {
			info->parent=0xffff;
		}
		info->id=TOS_NODE_ID;
		info->dsn=topology_sn++;
		err=call TopologySend.send(&topologysendbuf, sizeof(harvester_topology_t));
		if (err == SUCCESS) {
			sendTopologyBusy = TRUE;
		}
		else {
	    	report_problem();  	
	    	call DSN.logInt(err);
	    	call DSN.logError("TreeInfo:Send failed (%i)");
    	}
  	}
  	else {
  		call DSN.logError("TreeInfo:Radio busy");
  		report_problem();
  	}
  }
      
  event void TopologySend.sendDone(message_t* msg, error_t error) {
  	if (error == SUCCESS) {
      report_sent(msg);
  	}
    else {
      report_problem();
      call DSN.logInt(error);
	  call DSN.logError("TreeInfo:SendDone failed (%i)");
    }
  	sendTopologyBusy = FALSE;
  }
  
// #######################################
// Harvester Status
// #######################################
  
  event void StatusTimer.fired() {
  	error_t err;
  	if (!sendStatusBusy) {
  		harvester_status_t * status = (harvester_status_t *)call StatusSend.getPayload(&statussendbuf, sizeof(harvester_status_t));
		status->id=TOS_NODE_ID;
		status->dsn=status_sn++;
		status->prog_version=IDENT_TIMESTAMP;

		err=call StatusSend.send(&statussendbuf, sizeof(harvester_status_t));
		if (err == SUCCESS) {
			sendStatusBusy = TRUE;
		}
		else {
	    	report_problem();  	
	    	call DSN.logInt(err);
   			call DSN.logError("Status stack (%i)");
    	}
  	}
  	else {
  		report_problem();
  	}
  }
    
  event void StatusSend.sendDone(message_t* msg, error_t error) {
  	if (error == SUCCESS) {
      report_sent(msg);
  	}
    else {
      report_problem();
  	  call DSN.logError("Send Status failed");
    }
  	sendStatusBusy = FALSE;
  }

// #######################################
//		Reporting
// #######################################

  // Use LEDs to report various status issues.
  static void fatal_problem() { 
    call Leds.led0On(); 
    call Leds.led1On();
    call Leds.led2On();
  }

  static void report_problem() { 
  	}
  
  static void report_sent(message_t* msg) {
  }
  
  static void report_received(message_t* msg) {
  } 
  
  event void LplCommand.detected(uint16_t * values, uint8_t n) {
  	if (n==1) {
  		lplSleepInterval=values[0];
  		call LowPowerListening.setLocalSleepInterval(lplSleepInterval);
  		call CollectionLowPowerListening.setDefaultRxSleepInterval(lplSleepInterval);
  		call DSN.logInt(lplSleepInterval);
  		call DSN.logInfo("changed lpl %ims");
  	}
  }
  
}

