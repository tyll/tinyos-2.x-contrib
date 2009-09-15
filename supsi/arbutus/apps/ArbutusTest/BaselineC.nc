
#include <AM.h>
#include "data.h"

module BaselineC {
  


  uses {
   
    interface Boot;
    interface SplitControl as RadioControl;
    interface SplitControl as SerialControl;
    interface StdControl as RoutingControl;
    interface Send;
    interface Receive;
    interface AMSend as SerialSend;  

    interface RootControl;
    interface Timer<TMilli>;
    interface Leds;
    interface Random;
    interface ArbutusInfo;
    interface Packet;
interface CC2420Packet;

  }
}

implementation {

 enum {APP_QUEUE_SIZE=1,};


 
  task void uartSendTask();
  static void startTimer();
  static void fatal_problem();
  static void report_problem();
  static void report_sent();
  static void report_received();

  uint8_t uartlen; uint8_t gbDepth=2;
   uint16_t interval, dropped=0, countq=0, porcataCounter=0;
  message_t sendbuf, uartbuf, uartbuf2;
  message_t* sendbufPtr=&sendbuf;
  message_t* uartbufPtr=&uartbuf;
  message_t* uartbufPtr2=&uartbuf2;
  bool sendbusy=FALSE, uartbusy=FALSE;
  
       
      
        data_msg_t ina;
 data_msg_t* in=&ina;
      data_msg_t outa; 
data_msg_t* out=&outa; 
      
     
        data_msg_t in2a;
  data_msg_t* in2=&in2a;
      data_msg_t out2a; 
 data_msg_t* out2=&out2a;

  
    int8_t queueCount=0;
  uint8_t queueIn=0, queueOut=0;
bool debug=FALSE;

  
  data_msg_t queuedPacket[APP_QUEUE_SIZE];
  data_msg_t* queuedPacketPtr[APP_QUEUE_SIZE]; 
  
  
 
  
  uint16_t seqno;


  
  event void Boot.booted() {
   
   uint8_t k;
   seqno=1; 
   interval=DEFAULT_INTERVAL;
  
   
 for (k=0; k<APP_QUEUE_SIZE; k++)  
      queuedPacketPtr[k] = &queuedPacket[k];


       
       
//if ((TOS_NODE_ID!=124) && ((TOS_NODE_ID>0)&&(TOS_NODE_ID<200)))   

// {




//if (((TOS_NODE_ID>0) && (TOS_NODE_ID<124)) || (TOS_NODE_ID==181) ||
//     (TOS_NODE_ID==124) || (TOS_NODE_ID==179) || (TOS_NODE_ID==17) || (TOS_NODE_ID==27)  || ((TOS_NODE_ID>124) && (TOS_NODE_ID<158)) )

//if ((TOS_NODE_ID==106)||(TOS_NODE_ID==65)||(TOS_NODE_ID==79)||(TOS_NODE_ID==84)||(TOS_NODE_ID==124)||(TOS_NODE_ID==181)||(TOS_NODE_ID==179)|| ((TOS_NODE_ID>0) && (TOS_NODE_ID<158)))



 

if ((TOS_NODE_ID>0) && (TOS_NODE_ID<300) 
//&&
//(TOS_NODE_ID!=103)&&
//(TOS_NODE_ID!=15)&&
//(TOS_NODE_ID!=42)&&
//(TOS_NODE_ID!=49)&&
//(TOS_NODE_ID!=118)
 )




{


    if (call RadioControl.start() != SUCCESS)
      fatal_problem();

    if (call RoutingControl.start() != SUCCESS)
      fatal_problem();}
  }

  event void RadioControl.startDone(error_t error) {
    if (error != SUCCESS)
      fatal_problem();
      
        if (TOS_NODE_ID == BASE_STATION_ADDRESS)
      call RootControl.setRoot();

    if (call SerialControl.start() != SUCCESS)
      fatal_problem();
  }

  event void SerialControl.startDone(error_t error) {
    if (error != SUCCESS)
      fatal_problem();



    startTimer();
  }

  static void startTimer() {
  uint16_t offset=call Random.rand16() % 1024;
  
  if ( TOS_NODE_ID != BASE_STATION_ADDRESS)
     call Timer.startOneShot(interval+offset);
  }

  event void RadioControl.stopDone(error_t error) { }
  event void SerialControl.stopDone(error_t error) { }

  event message_t*
  Receive.receive(message_t* msg, void *payload, uint8_t len) {
  
        
in = (data_msg_t*)payload;

   in->totalRelayedTraffic=call ArbutusInfo.get_totalRelayedTraffic(msg);
   in->totalOwnTraffic=call ArbutusInfo.get_totalOwnTraffic(msg);
   in->packetTransmissions=call ArbutusInfo.get_packetTransmissions(msg);
   in->hopcount=call ArbutusInfo.get_hopcount(msg);
   in->localLoad = call CC2420Packet.getRssi(msg);

   
  
  if ((msg==NULL) || (payload==NULL)) return msg;
  
    if (uartbusy == FALSE) {

      
          
      if (in==NULL) {uartbusy=FALSE;  return NULL;}
      
      else 
      {	
        
        uartlen = sizeof(data_msg_t);
      
        if ((queueCount<APP_QUEUE_SIZE)&&(queueIn<APP_QUEUE_SIZE)) {
        memcpy(queuedPacketPtr[queueIn], in, sizeof(data_msg_t));
        queueCount++;
        atomic {queueIn++;}
        atomic {if (queueIn>=APP_QUEUE_SIZE) queueIn=0; }
        post uartSendTask();
        
        return msg;
        }

        
      
      else {

atomic {if (queueIn>=APP_QUEUE_SIZE) queueIn=0; }
uartbusy=FALSE; return NULL;}
      }
 }   
 
 else {
 
 return NULL;
        
        
        }
 
 
 }
 
 

  task void uartSendTask() {
  

      in2 = (data_msg_t*)queuedPacketPtr[queueOut];
      out2 = (data_msg_t*)call SerialSend.getPayload(uartbufPtr2, sizeof(data_msg_t));
      
      uartbusy = TRUE;
      
      if ((in2!=NULL)&&(out2!=NULL))
      memcpy(out2, in2, sizeof(data_msg_t));
      else {uartbusy = FALSE; }
      
      if (debug) call Leds.led0Toggle(); 
      uartlen = sizeof(data_msg_t);
  
      if (call SerialSend.send(0xffff, uartbufPtr2, uartlen) != SUCCESS) { uartbusy = FALSE;  }
  }
  
    
  event void SerialSend.sendDone(message_t *msg, error_t error) {
   


  if (queueCount>0)  queueCount--;
  atomic {if (++queueOut>=APP_QUEUE_SIZE) queueOut=0;}
  
  uartbusy = FALSE;
    
    if (debug)
    call Leds.led1Toggle(); 

    
    if (queueCount>0)
   { post uartSendTask();}
    
  }



  event void Timer.fired() {
  
  data_msg_t *o;
  
  
   call Leds.led1Toggle(); 
   

  
    if (!sendbusy) {
    
     sendbusy = TRUE;
      o = (data_msg_t *)call Send.getPayload(sendbufPtr, sizeof(data_msg_t));
      if (o == NULL) {
	fatal_problem();
	sendbusy = FALSE;
	return;
      }
      
      if (sizeof(*o)>call Send.maxPayloadLength())  {sendbusy = FALSE;
	return;
      }
     
      o->originaddr=TOS_NODE_ID;
      o->originalSequenceNumber=seqno;
      
      if (call Send.send(sendbufPtr, sizeof(data_msg_t)) != SUCCESS)
	{ report_problem();  sendbusy = FALSE;}
	}  
	
	call Timer.startOneShot(interval+call Random.rand16() % 102);   
   
  }

  event void Send.sendDone(message_t* msg, error_t error) {
    
  
  data_msg_t *o = (data_msg_t *)call Send.getPayload(msg, sizeof(data_msg_t));
  am_addr_t origine=o->originaddr;  
  
   
 

  
    if (error == SUCCESS)
     { report_sent();    if (origine==TOS_NODE_ID) atomic{seqno++;}}
    else
      report_problem();
      
      
      

    sendbusy = FALSE;
  }

  
  
 


  // Use LEDs to report various status issues.
  static void fatal_problem() { 
    //call Leds.led0On(); 
    //call Leds.led1On();
    //call Leds.led2On();
    //call Timer.stop();
  }

  static void report_problem() { //call Leds.led0Toggle(); 
  }
  static void report_sent() { //call Leds.led1Toggle();
  }
  static void report_received() { //call Leds.led2Toggle();
  }
  
  







  
  
}
