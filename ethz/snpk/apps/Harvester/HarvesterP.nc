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
    interface DSN;
    interface DsnCommand<uint16_t> as LplCommand;

    // Sensor
    interface Read<uint16_t> as TempExternalRead;
    interface Read<uint16_t> as TempInternalRead;
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
    //interface AsyncNotify;
    interface Counter<T32khz,uint32_t>;
    interface PacketAcknowledgements;
    
    interface Read<uint16_t> as ReadCpuLoad;
    interface Timer<TMilli> as LoadTimer;
    
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
  message_t sendbuf;
  message_t uartbuf;
  uint8_t * m_state;
  harvester_topology_t * tinfo;
  uint8_t sensor_sn=0, topology_sn=0, status_sn=0;
  bool sendbusy=FALSE, uartbusy=FALSE;
  error_t e=SUCCESS;
  uint16_t lplSleepInterval=LPL_INT;

  /* Current local state - interval, version and accumulated readings */
  harvester_sensor_t local;

  uint8_t reading; /* 0 to NREADINGS */

  /* When we head an Oscilloscope message, we check it's sample count. If
     it's ahead of ours, we "jump" forwards (set our count to the received
     count). However, we must then suppress our next count increment. This
     is a very simple form of "time" synchronization (for an abstract
     notion of time). */
  bool suppress_count_change;

  bool backoff_signaled=FALSE;
  uint32_t packet_send, packet_backoff, packet_senddone;
  
  uint32_t cpuLoadSum=0;
  uint16_t cpuLoadSamples=0;
  
  enum {
  	S_BOOTUP,
  	S_RUNNING
  };
  uint8_t state=S_BOOTUP;
  
  //tasks
  task void stopradio();
  task void startradio();
  
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
    	call DSN.logError("RadioControl.start() failed");
      	fatal_problem();
    }

    if (call RoutingControl.start() != SUCCESS) {
    	call DSN.logError("RoutingControl.start() failed");
    	fatal_problem();
    }
    else {
    	call CollectionLowPowerListening.setDefaultRxSleepInterval(lplSleepInterval);
    }
  }

  event void RadioControl.startDone(error_t error) {
  	if (state==S_BOOTUP) {
    	if (error != SUCCESS) {
    		call DSN.logError("RadioControl.startDone() failed");
      		fatal_problem();
    	}

    	if (
    		sizeof(harvester_sensor_t) > call SensorSend.maxPayloadLength() ||
    		sizeof(harvester_topology_t) > call TopologySend.maxPayloadLength() ||
    		sizeof(harvester_status_t) > call StatusSend.maxPayloadLength() 
    	) {
    		call DSN.logError("Radio payload length out of range");
      		fatal_problem();
    	}

    	if (call SerialControl.start() != SUCCESS) {
    		call DSN.logError("SerialControl.start() failed");
    		fatal_problem();
    	}
  	} else {
  		call RoutingControl.start();
  		call DSN.logInfo("Routing restarted.");
  	}
  }

  event void SerialControl.startDone(error_t error) {
    if (error != SUCCESS) {
    	call DSN.logError("SerialControl.startDone() failed");
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
	state=S_RUNNING;
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
  event message_t*
  SensorReceive.receive(message_t* msg, void *payload, uint8_t len) {
	void * out;
    message_t *newmsg = call UARTMessagePool.get();
    m_state=__FUNCTION__;
    if (newmsg == NULL) {
    	// drop the message on the floor if we run out of queue space.
        report_problem();
   	    call DSN.logError("UART pool full");
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
  
  event message_t*
   TopologyReceive.receive(message_t* msg, void *payload, uint8_t len) {
  	void * out;
      message_t *newmsg = call UARTMessagePool.get();
      // tinfo = call Packet.getPayload(msg, NULL); 
      m_state=__FUNCTION__;
      if (newmsg == NULL) {
      	// drop the message on the floor if we run out of queue space.
          report_problem();
     	  	call DSN.logError("UART msg pool full");
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

  event message_t*
  StatusReceive.receive(message_t* msg, void *payload, uint8_t len) {
 	void * out;
     message_t *newmsg = call UARTMessagePool.get();
     if (newmsg == NULL) {
     	// drop the message on the floor if we run out of queue space.
         report_problem();
    	  	call DSN.logError("UART msg pool full");
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
	m_state=__FUNCTION__; 
	if (uartMsg!=NULL) {
		uint8_t type=call SerialAMPacket.type(uartMsg);
		e=call SerialSend.send[type](local.id, uartMsg, call SerialPacket.payloadLength(uartMsg));
	    if (e != SUCCESS) {
    	  report_problem();
    	  call DSN.logError("UART msg to stack failed");
	    } else {
    	  uartbusy = TRUE;
    	}
    }
  }

  event void SerialSend.sendDone[am_id_t id](message_t *msg, error_t error) {
  	if (call RootControl.isRoot()) {
    	uartbusy = FALSE;
    	m_state=__FUNCTION__;
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
   	if (!sendbusy) {
		harvester_sensor_t *o = (harvester_sensor_t *)call SensorSend.getPayload(&sendbuf, sizeof(harvester_sensor_t));
		local.dsn=sensor_sn++;
		local.id=TOS_NODE_ID;
		memcpy(o, &local, sizeof(local));
		if (call SensorSend.send(&sendbuf, sizeof(local)) == SUCCESS)
	  		sendbusy = TRUE;
        else {
        	report_problem();
      		call DSN.logError("Send Sensordata radio stack failed");
        }
    }
    else {
  		call DSN.logError("Radio busy while sending SensorData");
    }  	
    if (call TempExternalRead.read() != SUCCESS)
    	fatal_problem();
  }
  
  event void SensorSend.sendDone(message_t* msg, error_t error) {
  	m_state=__FUNCTION__;
    if (error == SUCCESS)
      report_sent(msg);
    else {
      report_problem();
  	  call DSN.logError("Send Sensordata failed");
   }
    sendbusy = FALSE;
  }

  event void TempExternalRead.readDone(error_t result, uint16_t data) {
  	m_state=__FUNCTION__;
    if (result != SUCCESS) {
      data = 0xffff;
      report_problem();
    }
    local.temp_external = data;
    if (call TempInternalRead.read() != SUCCESS)
    	fatal_problem();
  }

  event void TempInternalRead.readDone(error_t result, uint16_t data) {
  	m_state=__FUNCTION__;
    if (result != SUCCESS) {
      data = 0xffff;
      report_problem();
    }
    local.temp_internal = data;
  }  
  
// #######################################
// Harvester Topology
// #######################################
  
  event void TopologyTimer.fired() {
  	am_addr_t parent;
  	uint8_t i;
  	error_t err;
  	uint8_t numNeighbours;
  	m_state=__FUNCTION__;
  	
  	if (!sendbusy) {
  		harvester_topology_t *info = (harvester_topology_t *)call TopologySend.getPayload(&sendbuf, sizeof(harvester_topology_t));
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
		packet_send=call Counter.get();
		atomic {
			backoff_signaled=FALSE;
		}
		err=call TopologySend.send(&sendbuf, sizeof(harvester_topology_t));
		if (err == SUCCESS) {
			sendbusy = TRUE;
		}
		else {
	    	report_problem();  	
	    	call DSN.logInt(err);
   			call DSN.logError("TInfo stack (%i)");
    	}
  	}
  	else {
  		//call DSN.logError("Tinf busy");
  		report_problem();
  	}
  }
    
  event void TopologySend.sendDone(message_t* msg, error_t error) {
  	m_state=__FUNCTION__;
  	if (error == SUCCESS) {
  	  packet_senddone=call Counter.get();
      report_sent(msg);
  	}
    else {
      report_problem();
  	  call DSN.logError("Send TreeInfo failed");
    }
    sendbusy = FALSE;
  }
  
// #######################################
// Harvester Status
// #######################################
  
  event void StatusTimer.fired() {
  	error_t err;
  	if (!sendbusy) {
  		harvester_status_t * status = (harvester_status_t *)call StatusSend.getPayload(&sendbuf, sizeof(harvester_status_t));
		status->id=TOS_NODE_ID;
		status->dsn=status_sn++;
		status->prog_version=IDENT_UNIX_TIME;

		err=call StatusSend.send(&sendbuf, sizeof(harvester_status_t));
		if (err == SUCCESS) {
			sendbusy = TRUE;
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
  	m_state=__FUNCTION__;
  	if (error == SUCCESS) {
      report_sent(msg);
  	}
    else {
      report_problem();
  	  call DSN.logError("Send Status failed");
    }
    sendbusy = FALSE;
  }

// #######################################
//		Reporting
// #######################################

  // Use LEDs to report various status issues.
  static void fatal_problem() { 
  	m_state=__FUNCTION__;
    call Leds.led0On(); 
    call Leds.led1On();
    call Leds.led2On();
  }

  static void report_problem() { 
  	m_state=__FUNCTION__;
  	//call Leds.led0Toggle();
  	}
  
  static void report_sent(message_t* msg) {
  	m_state=__FUNCTION__;
  	//call Leds.led1Toggle();
  	/*
  	atomic {
  		call DSN.logInt(packet_backoff-packet_send); 
  		call DSN.logInt(packet_senddone-packet_backoff);
  	}
  	call DSN.logInt(call PacketAcknowledgements.wasAcked(msg));
  	call DSN.logDebug("S %i %i %i");
  	// call DSN.logPacket(msg);
  	 */
  }
  
  static void report_received(message_t* msg) {
  	m_state=__FUNCTION__;
  	//call Leds.led2Toggle();
  	
  	/*
  	call DSN.logInt(call AMPacket.source(msg)); 
  	call DSN.logInt(call AMPacket.destination(msg));
  	call DSN.logDebug("R %i->%i");
  	*/
  } 
  
  // DSN specific
  event void DSN.receive(void *msg, uint8_t len) {
  	//call Leds.led2Toggle(); 
  	//call DSN.logInfo(msg);
  }
  
  event void LplCommand.detected(uint16_t * values, uint8_t n) {
  	if (n==1) {
  		lplSleepInterval=values[0];
  		call LowPowerListening.setLocalSleepInterval(lplSleepInterval);
  		// call CollectionLowPowerListening.setDefaultRxSleepInterval(lplSleepInterval);
  		call DSN.logInt(lplSleepInterval);
  		call DSN.logInfo("changed lpl interval to %ims");
  	}
  }
  
  //*************************
  // statistics
  //**************************
  /*
   async event void AsyncNotify.notify(){
   	if (!backoff_signaled) {
   		packet_backoff=call Counter.get();
   		backoff_signaled=TRUE;
   	}
   }
   */
   async event void Counter.overflow(){
   }
   
   event void LoadTimer.fired() {
   		call ReadCpuLoad.read();
   }
   
   event void ReadCpuLoad.readDone(error_t result, uint16_t val) {
   	  cpuLoadSum+=val;
      cpuLoadSamples++;
      if (cpuLoadSamples==30) { // calculate average each minute
      	call DSN.logInt((cpuLoadSum*10/3)/0xffff);
   		call DSN.logInfo("l %i");
      	cpuLoadSum=0;
        cpuLoadSamples=0;
      }
   }
    
  task void stopradio() {
  	error_t eval;
  	eval=call RadioControl.stop();
  	if (e != SUCCESS) {
  		call DSN.logInt(eval);
  		call DSN.logError("Radio Stop (%i)");
    	post stopradio();
    }
  }
  
  task void startradio() {
  	error_t eval;
  	eval=call RadioControl.start();
  	if (eval != SUCCESS) {
  		call DSN.logInt(eval);
  		call DSN.logError("Radio Start (%i)");
    	post startradio();
    }
  }
  
  /****************** NeighbourSyncRequest events *******/
  /*
  event void NeighbourSyncRequest.updateRequest(){
  	 call DSN.logDebug("Update synced neihbours with routing info");
  	 call CtpInfo.triggerRouteUpdate();
  }
  */
  
}

