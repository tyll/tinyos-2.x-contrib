
/**
 * See the readme for more info
 * @author David Moss
 */
 
#include "AM.h"
#include "Analysis.h"
#include "message.h"

module AnalysisP {
  uses {
    interface Boot;
    interface Leds;
    
    interface SplitControl as RadioSplitControl;
    interface SplitControl as SerialSplitControl;
    interface AMSend as CommandSender;
    interface AMSend as DummySender;
    interface Receive as SerialCommandReceiver;
    interface Receive as RadioCommandReceiver;
    interface Receive as DummyReceiver;
    interface PacketLink;
    interface LowPowerListening;
    
    interface Timer<TMilli> as SendTimer;
    interface Timer<TMilli> as LedsOffTimer;
    
  }
}

implementation {

  message_t dummyMsg;
  
  message_t commandMsg;

  bool baseStation;
  
  uint16_t currentWorInterval;
  
  uint16_t intervalBetweenMessages;
  
  /***************** Prototypes ****************/
  void receiveCommand(AnalysisMsg *analysisMsg);
  task void sendCommand();
  task void sendDummy();
  
  /***************** Boot Events ****************/
  event void Boot.booted() {
    baseStation = (TOS_NODE_ID == 0);
    currentWorInterval = 0;
    
    call LowPowerListening.setLocalSleepInterval(0);
    call PacketLink.setRetries(&commandMsg, 100);
    call PacketLink.setRetryDelay(&commandMsg, 0);
    
    call RadioSplitControl.start();
    
    if(baseStation) {
      call SerialSplitControl.start();
    }
  }

  /***************** SplitControl Events ****************/
  event void RadioSplitControl.startDone(error_t error) {
    call SendTimer.startPeriodic(1024);
  }
  
  event void RadioSplitControl.stopDone(error_t error) {
  }
  
  event void SerialSplitControl.startDone(error_t error) {
  }
  
  event void SerialSplitControl.stopDone(error_t error) {
  }
  
  
  /***************** Timer Events ****************/
  event void SendTimer.fired() {
    
    post sendDummy();
  }
  
  event void LedsOffTimer.fired() {
    call Leds.set(0);
  }
  
  /***************** Sender Events ****************/
  event void CommandSender.sendDone(message_t *msg, error_t error) {  
    call LowPowerListening.setRxSleepInterval(&commandMsg, currentWorInterval);
  }
  
  event void DummySender.sendDone(message_t *msg, error_t error) {
    ////call Leds.led1Toggle();
  }
  
  /***************** Receive Events ****************/
  event message_t *SerialCommandReceiver.receive(message_t *msg, void *payload, error_t error) {
    receiveCommand((AnalysisMsg *) payload);
    return msg;
  }
  
  event message_t *RadioCommandReceiver.receive(message_t *msg, void *payload, error_t error) {
    receiveCommand((AnalysisMsg *) payload);
    return msg;
  }
  
  event message_t *DummyReceiver.receive(message_t *msg, void *payload, error_t error) {
    ////call Leds.led2Toggle();
    return msg;
  }
  
  
  /***************** Tasks and Functions ****************/
  void receiveCommand(AnalysisMsg *analysisMsg) {
    call Leds.set(1);
    call LedsOffTimer.startOneShot(1024);
    
    memcpy(call CommandSender.getPayload(&commandMsg, sizeof(AnalysisMsg)), analysisMsg, sizeof(AnalysisMsg));
    
    currentWorInterval = analysisMsg->worInterval;
    call LowPowerListening.setLocalSleepInterval(currentWorInterval);
    call LowPowerListening.setRxSleepInterval(&dummyMsg, currentWorInterval);
    
    // This is actually binary milliseconds, while WoR interval is in ms.
    intervalBetweenMessages = analysisMsg->intervalBetweenMessagesMs;
    
    if(baseStation) {
      // Our base station replicates a real network by sending out the 
      // equivalent number of messages
      post sendCommand();
      if(analysisMsg->nodesInSurroundingNetwork > 0 && intervalBetweenMessages > 0) {
        call SendTimer.startPeriodic((uint16_t) ((float) intervalBetweenMessages / (float) analysisMsg->nodesInSurroundingNetwork));
      } else {
        call SendTimer.stop();
      }
      
    } else {
      if(intervalBetweenMessages > 0) {
        call SendTimer.startPeriodic(intervalBetweenMessages);
        
      } else {
        call SendTimer.stop();
      }
    }
  }
  
  
  task void sendCommand() {
    if(call CommandSender.send(AM_BROADCAST_ADDR, &commandMsg, sizeof(AnalysisMsg)) != SUCCESS) {
      post sendCommand();
    }
  }
  
  task void sendDummy() {
    if(call DummySender.send(AM_BROADCAST_ADDR, &dummyMsg, TOSH_DATA_LENGTH) != SUCCESS) {
      post sendDummy();
    }
  }
}

