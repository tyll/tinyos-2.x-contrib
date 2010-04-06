/*
 * SenZip trial app module
 *
 * @ author        Sundeep Pattem
 * @ affiliation   Autonomous Networks Research Group
 * @ institution   University of Southern California
*/

#include "SenZipApp.h"

module SenZipC {
  uses {
    interface Boot;
    interface SplitControl as RadioControl;
    interface StdControl as RoutingControl;
    interface Leds;
    interface RootControl;
    interface Send;
    
    interface Timer<TMilli> as MeasurementTimer;
    interface Set<uint16_t> as Measurements;
    interface Read<uint16_t> as Temperature;   
    interface StartGathering;    
    interface Receive as SubReceive;
    interface Receive as BaseReceive;
    interface AMSend as BaseSend;
    interface Packet as BasePacket;
    interface Queue<message_t*> as SendQueue;
    interface Pool<message_t> as QEntryPool;
  }
}

implementation {
  
  message_t packet;
  bool sending = FALSE;
  
  task void sendTask();

  event void Boot.booted() {
    call RadioControl.start();
  }
  
  event void RadioControl.startDone(error_t err) {
    if (err != SUCCESS)
      call RadioControl.start();
    else {
      call RoutingControl.start();
      if (TOS_NODE_ID == SINK_NODE_ID) { 
	call RootControl.setRoot();
      }
    }
  }

  event void RadioControl.stopDone(error_t err) {}

  
  event void StartGathering.startDone(){
    call Leds.led2Toggle();
    if ((!call MeasurementTimer.isRunning()) && (TOS_NODE_ID != SINK_NODE_ID))
      call MeasurementTimer.startPeriodic(SAMPLE_PERIOD);
  }


  event message_t* BaseReceive.receive(message_t* msg, void* payload, uint8_t len) {   
    if( len != sizeof(base_msg_t) ) {
      return msg;
    } else { 
      base_msg_t *tempMsg = (base_msg_t *)payload;
      if (tempMsg->type%10 == START) {        
        if(!call StartGathering.isStarted())
          call StartGathering.getStarted(tempMsg->type/10);
      }
    }   	
    return msg;
  }

  event void MeasurementTimer.fired() {
    call Temperature.read();
    
   
  }

  event void Temperature.readDone( error_t result, uint16_t val) {
    if (result == SUCCESS) {
      call Measurements.set(val);
      call Leds.led0Toggle();
    }
  }


  task void sendTask() {
    error_t eval;
    message_t *head;
    if (sending) {
      // retry timer?
      return;
    }
    head = call SendQueue.head();
    eval = call BaseSend.send(BASE_ID, head, sizeof(base_msg_t));
    if (eval == SUCCESS) {
      sending = TRUE;
      } else {
      // call retry timer?
    }
  }

  event void BaseSend.sendDone(message_t* msg, error_t error) {
     message_t *qe = call SendQueue.head();
    call QEntryPool.put(qe); 
    call SendQueue.dequeue();
    sending = FALSE;
    // introduce timer?
    if (!call SendQueue.empty()) {
      post sendTask();
    }
  }

  event message_t* 
  SubReceive.receive(message_t* msg, void* payload, uint8_t len) {
    uint8_t idx;
    base_msg_t *baseMsg = NULL;
    base_msg_t *tempMsg = (base_msg_t *)payload;
    message_t *qe = call QEntryPool.get();
    baseMsg = (base_msg_t *)call BasePacket.getPayload(qe, NULL);
    call Leds.led1Toggle();    
    baseMsg->src = tempMsg->src;
    baseMsg->type = tempMsg->type;
    baseMsg->parent = tempMsg->parent;
    baseMsg->seq = tempMsg->seq;
    baseMsg->max = tempMsg->max;
    baseMsg->min = tempMsg->min;
    for (idx = 0; idx < NUM_MEASUREMENTS; idx++) {
      baseMsg->data[idx] = tempMsg->data[idx];
    }
    if (call SendQueue.enqueue(qe) == SUCCESS) {
      post sendTask();
    }
    return msg;
  }

  event void Send.sendDone(message_t* m, error_t e) {}

  

}
