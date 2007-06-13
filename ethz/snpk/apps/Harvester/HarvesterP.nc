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
    interface Send;
    interface Receive as Snoop;
    interface Receive;
    interface AMSend as SerialSend[am_id_t id];
    interface CollectionPacket;
    interface RootControl;
    interface AMPacket;
    interface Packet;
    interface AMPacket as SerialAMPacket;
    interface Packet as SerialPacket;
    
    interface LowPowerListening;

    interface Queue<message_t *> as UARTQueue;
    interface Pool<message_t> as UARTMessagePool;

    // Miscalleny:
    interface Timer<TMilli>;
    interface Timer<TMilli> as TreeInfoTimer;
    interface Read<uint16_t>;
    interface Leds;
    
    // DSN
    interface DSNx;
    interface DsnCommand<uint16_t> as LplCommand;
    
    // TreeInfo
    interface CtpInfo;
    interface Receive as TreeInfoReceive;
    interface Send as TreeInfoSend;
    
    // for statistics
    //interface AsyncNotify;
    interface Counter<T32khz,uint32_t>;
    interface PacketAcknowledgements;
    
    interface Read<uint16_t> as ReadCpuLoad;
    interface Timer<TMilli> as LoadTimer;
    interface CC2420DutyCycle;
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
  treeinfo_t *tinfo;
  uint8_t sn=0;
  bool sendbusy=FALSE, uartbusy=FALSE;
  error_t e=SUCCESS;

  /* Current local state - interval, version and accumulated readings */
  harvester_t local;

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
  }

  event void RadioControl.startDone(error_t error) {
  	if (state==S_BOOTUP) {
    	if (error != SUCCESS) {
    		call DSN.logError("RadioControl.startDone() failed");
      		fatal_problem();
    	}

    	if (sizeof(local) > call Send.maxPayloadLength()) {
    		call DSN.logError("Radio payload length out of range");
      		fatal_problem();
    	}

    	if (call SerialControl.start() != SUCCESS) {
    		call DSN.logError("SerialControl.start() failed");
    		fatal_problem();
    	}
    	call LowPowerListening.setLocalSleepInterval(LPL_INT);
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
    else
    	call SerialControl.stop();
	state=S_RUNNING;
	// start periodic actions
	//startTimer();
    call TreeInfoTimer.startPeriodic(TREEINFO_INT);
    //call LoadTimer.startPeriodic(2048);
  }

  static void startTimer() {
  	m_state=__FUNCTION__;
    if (call Timer.isRunning()) call Timer.stop();
    call Timer.startPeriodic(SAMPLING_INTERVAL);
    reading = 0;
  }

  event void RadioControl.stopDone(error_t error) {
  	post startradio();
  }
  
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
  Receive.receive(message_t* msg, void *payload, uint8_t len) {
	void * out;
    message_t *newmsg = call UARTMessagePool.get();
    m_state=__FUNCTION__;
    if (newmsg == NULL) {
    	// drop the message on the floor if we run out of queue space.
        report_problem();
   	    call DSN.logError("UART pool full");
        return msg;
    }
    out = call SerialPacket.getPayload(newmsg, NULL);
	memcpy(out, payload, len);
    call SerialAMPacket.setType(newmsg, AM_HARVESTER);
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

  //
  // Overhearing other traffic in the network.
  //
  event message_t* 
  Snoop.receive(message_t* msg, void* payload, uint8_t len) {
  	// this function is never called with CTP underneath because 
  	// all harvester traffic is unicast and therefore rejected by the CC2420
  	// early packet rejection mechanism	
  	m_state=__FUNCTION__;
  	
    return msg;
  }

// #######################################
//	Sensor data
// #######################################
  /* At each sample period:
     - if local sample buffer is full, send accumulated samples
     - read next sample
  */
  event void Timer.fired() {
   	if (!sendbusy) {
		harvester_t *o = (harvester_t *)call Send.getPayload(&sendbuf);
		local.dsn++;
		memcpy(o, &local, sizeof(local));
		if (call Send.send(&sendbuf, sizeof(local)) == SUCCESS)
	  		sendbusy = TRUE;
        else {
        	report_problem();
      		call DSN.logError("Send Sensordata radio stack failed");
        }
    }
    else {
  		call DSN.logError("Radio busy while sending SensorData");
    }  	
    if (call Read.read() != SUCCESS)
    	fatal_problem();
  }

  event void Send.sendDone(message_t* msg, error_t error) {
  	m_state=__FUNCTION__;
    if (error == SUCCESS)
      report_sent(msg);
    else {
      report_problem();
  	  call DSN.logError("Send Sensordata failed");
   }
    sendbusy = FALSE;
  }

  event void Read.readDone(error_t result, uint16_t data) {
  	m_state=__FUNCTION__;
    if (result != SUCCESS) {
      data = 0xffff;
      report_problem();
  	  call DSN.logError("reading Sensordata failed");
    }
    local.value = data;
    call DSN.logInt(data - 3960); // temp is now give times 100
    call DSN.logDebug("Sensor value %i");
  }
  
// #######################################
//		Tree Info
// #######################################
  
  event void TreeInfoTimer.fired() {
  	am_addr_t parent;
  	uint8_t i;
  	error_t err;
  	m_state=__FUNCTION__;
  	if (!sendbusy) {
  		treeinfo_t *info = (treeinfo_t *)call Send.getPayload(&sendbuf);
  		if (call CtpInfo.getParent(&parent)==SUCCESS) {
			info->parent=parent;
			info->numNeighbours=call CtpInfo.numNeighbors();
			for (i=0;i<info->numNeighbours;i++) {
				info->neighbours[i].nodeId=call CtpInfo.getNeighborAddr(i);
				info->neighbours[i].etx=call CtpInfo.getNeighborRouteQuality(i);
			}
		}
		else {
			info->parent=0xffff;
			info->numNeighbours=0;
		}
		info->id=TOS_NODE_ID;
		info->sn=sn++;
		call LowPowerListening.setRxSleepInterval(&sendbuf, LPL_INT);
		packet_send=call Counter.get();
		atomic {
			backoff_signaled=FALSE;
		}
		err=call TreeInfoSend.send(&sendbuf, sizeof(treeinfo_t));
		if (err == SUCCESS) {
			sendbusy = TRUE;
			//call SendWatchdogTimer.startOneShot(((uint32_t)(SENDDONE_NOACK_OFFSET+2*LPL_INT))*((uint32_t)(MAX_RETRIES*2)));
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
  
 event message_t*
 TreeInfoReceive.receive(message_t* msg, void *payload, uint8_t len) {
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
    out = call SerialPacket.getPayload(newmsg, NULL);
	memcpy(out, payload, len);
    call SerialAMPacket.setType(newmsg, AM_TREEINFO);
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
  
  event void TreeInfoSend.sendDone(message_t* msg, error_t error) {
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
//		Reporting
// #######################################

  // Use LEDs to report various status issues.
  static void fatal_problem() { 
  	m_state=__FUNCTION__;
    call Leds.led0On(); 
    call Leds.led1On();
    call Leds.led2On();
    call Timer.stop();
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
  	//call Leds.led2Toggle(); 
  	call DSN.logInt(n);
  	call DSN.log("detected command with %i parameters");
  }
  
  event void CC2420DutyCycle.detected() {
  	// call DSN.log("wakeup");
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
  
}

