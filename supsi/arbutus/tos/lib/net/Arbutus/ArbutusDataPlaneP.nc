

#include <ArbutusDataPlane.h>

   
generic module ArbutusDataPlaneP() {
  provides {
    interface Init;
    interface StdControl;
    interface Send[uint8_t client];
    interface Receive[collection_id_t id];
    interface Intercept[collection_id_t id];
    interface Packet;
    interface controlToData;
    interface dataPlane;
  
    interface ArbutusInfo;
    interface dataPlaneFeedback;
   
  }
  uses {
    interface AMSend as SubSend;
    interface Receive as SubReceive;
    interface Packet as SubPacket;
    interface UnicastNameFreeRouting;
    interface SplitControl as RadioControl;
    interface Timer<TMilli> as Watchdog;
    interface Timer<TMilli> as RetxmitTimer;
    interface dataToControl;
    interface PacketAcknowledgements;
    interface Random;
    interface RootControl;
    interface CollectionId[uint8_t client];
    interface AMPacket;
    interface Leds;}
}

implementation {

enum {DATA_TIMER_INTERVAL=10, QUEUE_SIZE=12, LOST_ROUTE_RETRY_INTERVAL=30,};


Arbutus_data_header_t hdra;      
Arbutus_data_header_t* hdr=&hdra;      

// key variables
bool suspend = FALSE;  // stops tx if true
uint8_t gbClient;
uint8_t gbLen;
uint16_t rxCount=0;
uint16_t  oldrxCount=0; 
uint16_t nlseqno=0;
uint16_t newOwn=1, oldOwn=0;
uint16_t ttx=0, latest_ttx=0, offset_ttx=0, advertised_ttx=0, gbFeedback=0, oldFeedback=0;
uint8_t payloadLen=0;
am_addr_t dest=0; 
bool gbRxBusy = FALSE;
uint16_t lastSequenceNumber[NODES];
uint16_t newSequenceNumber;

  


// timing
uint32_t timeWatchdog=1;


// counters
uint16_t rxStuckCheck=0;



// flags
bool txPending = FALSE;
bool relayEnabled = TRUE;
bool packetAcked=FALSE;
bool congestion = FALSE;
bool running = FALSE;
bool radioOn = FALSE;
bool ackPending = FALSE;
bool ownThere = FALSE;
bool routeBroken = FALSE;
bool dropping = FALSE;

// queueing
uint8_t queueIn, queueOut;
int8_t queueCount;


// stats
uint16_t dropped, loop;
uint16_t totalOwnTraffic, oldown=0;
uint16_t totalRelayedTraffic, oldrelayed=0;
uint16_t totalReceivedTraffic;
uint16_t correctionFactor, localmax, cv[OLD_FEEDBACK];
uint16_t localLoad;      
  

// packets
message_t queuedBeacon[QUEUE_SIZE];
message_t* queuedBeaconPtr[QUEUE_SIZE]; 
message_t packetBeingSent;
message_t* packetBeingSentPtr;
message_t sendmsg_it;
message_t* sendmsg;
message_t ownmsg_it;
message_t* ownmsg;
message_t* ownPacketPtr;
message_t ownPacket;
message_t rxBuffer;
message_t* rxBufferPtr;

void task ownSend();

command error_t Init.init() {
    int i;
    for (i = 0; i < NODES; i++) {lastSequenceNumber[i] = 0;}
    packetBeingSentPtr = &packetBeingSent;
    sendmsg = &sendmsg_it;
    ownmsg = &ownmsg_it;
    ownPacketPtr = &ownPacket;
    rxBufferPtr= &rxBuffer;
    totalOwnTraffic=0;
    totalRelayedTraffic=0;
    totalReceivedTraffic=0;
    return SUCCESS;}

command error_t StdControl.start() {
    uint8_t k;
    running = TRUE;
    queueIn=0; queueOut=0; queueCount=0; dropped=0; loop=0;
    for (k=0; k<QUEUE_SIZE; k++)  
       queuedBeaconPtr[k] = &queuedBeacon[k];
    for (k=0; k<OLD_FEEDBACK; k++)
        cv[k]=0;
    call Init.init();
    return SUCCESS;}

 command error_t StdControl.stop() {
    running = FALSE;
    return SUCCESS;
  }
  
void task txTask();
void task sendDoneTask();
  
event void RadioControl.startDone(error_t err) {
    if (err == SUCCESS) {radioOn = TRUE;     
        call Watchdog.startOneShot(2000);}}
   
event void UnicastNameFreeRouting.routeFound() {
    
    routeBroken = FALSE;
    call controlToData.resetMtx();
    if (suspend)  {suspend=FALSE; post txTask(); }
    else if ((queueCount==0) && ownThere) post ownSend();
    else if (queueCount>0) post txTask();

}

event void UnicastNameFreeRouting.noRoute() {}
  
event void RadioControl.stopDone(error_t err) {if (err == SUCCESS) {radioOn = FALSE;}}

Arbutus_data_header_t* getHeader(message_t* m) 
{return (Arbutus_data_header_t*)call SubPacket.getPayload(m, sizeof(Arbutus_data_header_t));}
 

void task FeedbackTask() {
    uint16_t somma=0; uint8_t k;
    for (k=1; k<OLD_FEEDBACK; k++) 
        {cv[k]=cv[k-1]; somma=somma+cv[k];} //cv[0]=latest_ttx; 
    cv[0]=advertised_ttx;  //was ttx
    somma=somma+cv[0];
  
    gbFeedback=(uint16_t)((double)somma/8);

    if (gbFeedback!=oldFeedback)
    signal dataPlaneFeedback.updateRnp(dest, gbFeedback);

     oldFeedback=gbFeedback; }  
  
///////////////////////////////////////////////////////////////////////////////////////////
////    SENDING OUR OWN PACKETS 
///////////////////////////////////////////////////////////////////////////////////////////

void task ownSend()

{

uint32_t temp;
  
  if (ownmsg==NULL) {signal Send.sendDone[gbClient](ownmsg, FAIL); return;}
  if (txPending) {signal Send.sendDone[gbClient](ownmsg, FAIL); return;}
  else {     
        if (ownThere) ownThere=FALSE;
     
        if (totalOwnTraffic>0) 
            temp = (double)(totalRelayedTraffic)/(double)totalOwnTraffic; 
        else temp=0;
        localLoad = (uint16_t)temp;
        
        newOwn = getHeader(ownmsg)->originSeqNo;
        getHeader(ownmsg)->totalOwnTraffic=totalOwnTraffic;
        getHeader(ownmsg)->totalRelayedTraffic=totalRelayedTraffic;

        if (newOwn>oldOwn) {
            if ((gbRxBusy)||(txPending)) 
                {signal Send.sendDone[gbClient](ownmsg, FAIL); return;} 
            else { 
                    if (call UnicastNameFreeRouting.hasRoute() && (queueCount<QUEUE_SIZE) )  // if all clear
                        { getHeader(ownmsg)->etx=0;
                          call Packet.setPayloadLength(ownmsg, gbLen);
                          oldOwn = newOwn;
                          atomic { memcpy(queuedBeaconPtr[queueIn], ownmsg, sizeof(message_t));
                          queueCount++;
                          if (++queueIn>=QUEUE_SIZE) queueIn=0; }
                              

                          if (((queueCount>=WATERMARK_1)) && (!call RootControl.isRoot()) )
                          { congestion=TRUE; signal controlToData.congestionDetected();}
                            
                          signal dataPlane.queueWasAccessed();}      // enqueued, all good                                        

                       else { 
                            signal dataPlane.queueWasAccessed(); 
                            signal Send.sendDone[gbClient](ownmsg, FAIL); } // trouble...ask client to resend
                       }}}
}


command error_t Send.send[uint8_t client](message_t* msg, uint8_t len) {
    if (call UnicastNameFreeRouting.hasRoute()) {
  atomic {memcpy(ownmsg, msg, sizeof(message_t));   if (!ownThere) ownThere=TRUE;}
  hdr=getHeader(ownmsg);
  hdr->originSeqNo = ++nlseqno;
  hdr->origin = TOS_NODE_ID;
  hdr->type = call CollectionId.fetch[gbClient]();
  gbLen=len; gbClient=client; 
  
  post ownSend();
  return SUCCESS;


  
  } else return FAIL; }
  
 
 

////////////////////////////////////////////////////////////////////////////////////////////////////
  command error_t Send.cancel[uint8_t client](message_t* msg) {
    
    return FAIL;
  }

  command uint8_t Send.maxPayloadLength[uint8_t client]() {
    return call Packet.maxPayloadLength();
  }

  command void* Send.getPayload[uint8_t client](message_t* msg, uint8_t len) {
    return call Packet.getPayload(msg, len);
  }
///////////////////////////////////////////////////////////////////////////////////////////
////    RX FROM UPSTREAM
///////////////////////////////////////////////////////////////////////////////////////////
void task rxTask()

{am_addr_t oldest;




if ((relayEnabled)||(call RootControl.isRoot())) {
am_addr_t fromIndex;
          
  if (!gbRxBusy) 
  {
  gbRxBusy=TRUE;
    fromIndex = getHeader(sendmsg)->origin; //call  controlToData.getOrigin(sendmsg);
     
      if (fromIndex>=NODES) return; 
      
      
      newSequenceNumber = getHeader(sendmsg)->originSeqNo; call controlToData.getSequenceNumber(sendmsg);
      
      if ((newSequenceNumber<=lastSequenceNumber[fromIndex])&&(!congestion))
      
      {gbRxBusy=FALSE;    return;}  
      
       
      
lastSequenceNumber[fromIndex]=newSequenceNumber;


      
      if (queueCount>=QUEUE_SIZE)  { dropped++; gbRxBusy=FALSE;  signal dataPlane.queueWasAccessed(); 
      return;}
        else   // enqueued
        
        {atomic{ memcpy(queuedBeaconPtr[queueIn], sendmsg, sizeof(message_t));  
        
           queueCount++;
          if (++queueIn>=QUEUE_SIZE) queueIn=0; }
          
                   gbRxBusy = FALSE;
          
          
//if ((!congestion)&&(!precongestion)&&(queueCount==6)) {precongestion=TRUE; signal RateControl.slowDown();}
 
//if (((queueCount==WATERMARK_1)||(queueCount==WATERMARK_2)||(queueCount==WATERMARK_3)) && (!call RootControl.isRoot()) )
//{precongestion=FALSE; congestion=TRUE; signal controlToData.congestionDetected();}

if (((queueCount>=WATERMARK_1)) && (!call RootControl.isRoot()) )
{congestion=TRUE; signal controlToData.congestionDetected();}          
 
           
         
       
       
       oldest = call dataToControl.getFormerParent();
       
      if ((fromIndex == TOS_NODE_ID)||(fromIndex==dest)) 
      
      {signal controlToData.loopDetected(); loop++; }
       
       signal dataPlane.queueWasAccessed();

       
       }  // end of enqueued
           
          
   }  //  end of rxbusy
   
   gbRxBusy = FALSE;  
   
   if (rxCount!=oldrxCount)
   post rxTask();}
}

event message_t* 
  SubReceive.receive(message_t* msg, void* payload, uint8_t len) {
  atomic{oldrxCount=rxCount;}
  atomic {rxCount++;}
  
  if (msg!=NULL)
  atomic{memcpy(sendmsg, msg, sizeof(message_t));}
  
  post rxTask();
  
  
 
   
   return msg;

  }
///////////////////////////////////////////////////////////////////////////////////////////
///  TX TASK
////////////////////////////////////////////////////////////////////////////////////////////

void task txTask() {
   
error_t subsendResult;
collection_id_t collectid;
am_addr_t origine;







if (queuedBeaconPtr[queueOut]!=NULL)

{ txPending = TRUE;

if (call RootControl.isRoot())
  
{       

         atomic {memcpy(packetBeingSentPtr, queuedBeaconPtr[queueOut], sizeof(message_t));}
        
          ackPending = FALSE;
          
         collectid = call controlToData.getType(packetBeingSentPtr);
         
         //call Leds.led0Toggle();
          
          rxBufferPtr=signal Receive.receive[collectid](packetBeingSentPtr,
							   call Packet.getPayload(packetBeingSentPtr, call Packet.payloadLength(packetBeingSentPtr)), 
							   call Packet.payloadLength(packetBeingSentPtr));
		if (rxBufferPtr!=NULL)
         {rxStuckCheck=0; signal SubSend.sendDone(packetBeingSentPtr, SUCCESS); }
         else
         
         {rxStuckCheck++; txPending = FALSE; if (rxStuckCheck<100) signal SubSend.sendDone(packetBeingSentPtr, FAIL); 
          else signal SubSend.sendDone(packetBeingSentPtr, SUCCESS);}

} else

{
   ttx++; advertised_ttx++;
   if (ttx==1)  { memcpy(packetBeingSentPtr, queuedBeaconPtr[queueOut], sizeof(message_t));
   }
   
   dest = call UnicastNameFreeRouting.nextHop();
   
   
   if (dest != AM_BROADCAST_ADDR)
   
   {  
      atomic {//outtxt->packetTransmissions++;
getHeader(packetBeingSentPtr)->etx++;
}  

                      
      
      
      //outtxt->sourceaddr = getHeader(packetBeingSentPtr)->originSeqNo;// for debugging only  
      origine = getHeader(packetBeingSentPtr)->origin;
      if (origine == TOS_NODE_ID) {getHeader(packetBeingSentPtr)->hopcount = call dataToControl.get_hopcount();    
getHeader(packetBeingSentPtr)->data[1] = call UnicastNameFreeRouting.nextHop();

      
       totalOwnTraffic++;  

      } else totalRelayedTraffic++;
      

   
   
         payloadLen = call SubPacket.payloadLength(packetBeingSentPtr);

         
       ackPending = (call PacketAcknowledgements.requestAck(packetBeingSentPtr)==SUCCESS);  
       subsendResult = call SubSend.send(dest, packetBeingSentPtr, payloadLen);  
       
       //if (subsendResult==FAIL) call RetxmitTimer.startOneShot(1024);
       
       }
       
       else
       
        
   suspend = TRUE;
       
       
       
       
}}}
///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////////////////
event void Watchdog.fired() { 


if ((queueCount>0) && (!txPending)) post txTask();  

timeWatchdog++;

if (dynamic){
if ((timeWatchdog%24000)==0)
{if (localLoad>2) call RadioControl.stop(); timeWatchdog=1;}}


call Watchdog.startOneShot(10);

}
////////////////////////////////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
  
event void SubSend.sendDone(message_t* msg, error_t error) {
if (error==SUCCESS) { 
    packetAcked=(call PacketAcknowledgements.wasAcked(msg));
    
    post sendDoneTask();}
    

    
        else{ txPending = FALSE;
    if (queueCount>0) post txTask();  
    }
    
    
    

    
    }

void task sendDoneTask()

{
am_addr_t origine;



 origine = getHeader(packetBeingSentPtr)->origin;
 
 //if (ttx<offset_ttx)
 //{offset_ttx=0; } 
 // latest_ttx=ttx-offset_ttx;
  post FeedbackTask();
  
  //if (ttx>=30) packetAcked=TRUE;   //ATTENTO



if ((constrained)&&(ttx>MAX_RETX))
{packetAcked=TRUE; dropping=TRUE;}
  

    if ((!ackPending) || packetAcked)
    
    { 
        // ADDED 5/6
          //if (congestion) signal controlToData.decongestionDetected();
    
        
            atomic {if (queueCount>0)  queueCount--;
       
            queueOut++;       

            if (queueOut>=QUEUE_SIZE) queueOut=0;}
         
            if (((queueCount==0)&&(congestion))&&(!dropping))  
                {congestion=FALSE;  
                 signal controlToData.decongestionDetected();}
                  
            if (queueCount==0) signal dataPlane.queueIsEmpty();
      
         
         
            if (origine==TOS_NODE_ID)  
            { signal Send.sendDone[gbClient](packetBeingSentPtr, SUCCESS);}
      
              ttx=0; advertised_ttx=0;
      
              atomic txPending = FALSE;      
              dropping = FALSE;
         
              if (queueCount>0) post txTask();  }
       
 else
 
 {if (advertised_ttx<PLAIN_RETX)
   {call RetxmitTimer.startOneShot(DATA_TIMER_INTERVAL);
    }
   else
   {

// ADDED 5/6
if ((!congestion) && (onsetDetection))
{congestion=TRUE; signal controlToData.congestionDetected();}

//if (advertised_ttx>MAX_RETX)
//{signal controlToData.routeBroken();}


if (useRoutingTable)
call dataToControl.attemptParentChange(TRUE);
// fix in case of no routing table TODO
//else
//signal controlToData.routeBroken();



call RetxmitTimer.startOneShot(DATA_TIMER_INTERVAL*ttx);}}
}

event void dataToControl.routeStuck() {

//signal controlToData.routeBroken();


}
////////////////////////////////////////////////////////////////////////////////////////////
  event void RetxmitTimer.fired() { 
  
 post txTask();}
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////  
  
command void Packet.clear(message_t* msg) {
    call SubPacket.clear(msg);
  }
  
  command uint8_t Packet.payloadLength(message_t* msg) {
    return call SubPacket.payloadLength(msg) - sizeof(Arbutus_data_header_t);
  }

  command void Packet.setPayloadLength(message_t* msg, uint8_t len) {
    call SubPacket.setPayloadLength(msg, len + sizeof(Arbutus_data_header_t));
  }
  
  command uint8_t Packet.maxPayloadLength() {
    return call SubPacket.maxPayloadLength() - sizeof(Arbutus_data_header_t);
  }

  command void* Packet.getPayload(message_t* msg, uint8_t len) {
    uint8_t* payload = call SubPacket.getPayload(msg, len + sizeof(Arbutus_data_header_t));
    if (payload != NULL) {
      payload += sizeof(Arbutus_data_header_t);
    }
    return payload;
  }

command uint8_t controlToData.getSUSDstate() {



}
   command am_addr_t       controlToData.getOrigin(message_t* msg) {return getHeader(msg)->origin;}
   command collection_id_t  controlToData.getType(message_t* msg) {return getHeader(msg)->type;}
     command uint16_t         controlToData.getSequenceNumber(message_t* msg) {return getHeader(msg)->originSeqNo;}
     command uint16_t         controlToData.getMtx() {return advertised_ttx; //gbFeedback; 
}

     command void         controlToData.resetMtx() {uint8_t k; offset_ttx=latest_ttx; for (k=0; k<OLD_FEEDBACK; k++)  cv[k]=0;  advertised_ttx=0;

}
     command uint16_t         controlToData.getDropped() {return dropped;}
     command uint16_t         controlToData.getLoops() {return loop;}
     command uint16_t controlToData.getGenerated() {return rxStuckCheck;}
     command uint16_t controlToData.getLoad() {return localLoad;}
     command uint16_t controlToData.getRelayed() {return totalRelayedTraffic;}
  
     command uint16_t controlToData.getRxPackets() {return rxCount;}
     
     command bool controlToData.getAckPending() {return gbRxBusy;}
     command bool controlToData.getPacketAcked() {return gbRxBusy;}
     
     command bool controlToData.getTxPending() {return txPending;}

     command bool controlToData.get_ttx() {return ttx;}

     

     
       command uint16_t controlToData.getQueueOccupancy() {

    return queueCount;
  }


  default event void dataPlane.queueWasAccessed() {
  if ((queueCount>0)&&(!txPending)) post txTask();
  }
  
    default event void dataPlane.queueIsEmpty() {
  //post ownSend();
  }
  
 
  default event void
  Send.sendDone[uint8_t client](message_t *msg, error_t error) {
  }

  default event bool
  Intercept.forward[collection_id_t collectid](message_t* msg, void* payload, 
                                               uint8_t len) {
    return TRUE;
  }

  default event message_t *
  Receive.receive[collection_id_t collectid](message_t *msg, void *payload,
                                             uint8_t len) {
    return msg;
  }

  

  default command collection_id_t CollectionId.fetch[uint8_t client]() {
    return 0;
  }

  command uint16_t ArbutusInfo.get_originaddr(message_t *msg){return getHeader(msg)->origin;}
  command uint16_t ArbutusInfo.get_originalSequenceNumber(message_t *msg){return getHeader(msg)->originSeqNo;}
  command uint16_t ArbutusInfo.get_packetTransmissions(message_t *msg){return getHeader(msg)->etx;}
  command uint16_t ArbutusInfo.get_totalOwnTraffic(message_t *msg){return getHeader(msg)->totalOwnTraffic;}
  command uint16_t ArbutusInfo.get_totalRelayedTraffic(message_t *msg){return getHeader(msg)->totalRelayedTraffic;}
  command uint8_t  ArbutusInfo.get_hopcount(message_t *msg){return getHeader(msg)->hopcount;}

  
  
  }
                                                                                            
  