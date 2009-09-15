#include <Timer.h>
#include <TreeRouting.h>





generic module ArbutusControlPlaneP() {
    provides {
        interface UnicastNameFreeRouting as Routing;
        interface RootControl;
        interface StdControl;
        interface dataToControl;
        interface Init;
        interface controlPlane;
        

    } 
    uses {
        interface AMSend as BeaconSend;
        interface Receive as BeaconReceive;
        interface AMPacket;
        interface SplitControl as RadioControl;
        interface Timer<TMilli> as BeaconTimer;
        interface Timer<TMilli> as PinTimer;
        interface Timer<TMilli> as StatsTimer;
        interface AMSend as StatsSend;  
        interface Random;
        interface controlToData;
        interface CC2420Packet;
        interface Packet;
        interface Leds;
        interface Parent;
    }
}


implementation {


enum {BEACON_QUEUE_SIZE=12, CONGESTION_PERIOD=1, STATS_COLLECTION=30240, PINNED=2, UNPINNED=3, ROUTE=1,   };

// key variables
uint8_t adjustedHopCount;
uint16_t rnpHistory[NODES];
uint16_t correctionFactor=0;
uint16_t rssBottleneck, lqiBottleneck;
uint16_t gbLoadBtlDownstream, gbLocalLoad, gbAdvertisedHopCount, gbAdvertisedHopCountBaseline;
uint8_t gbLinkRSS, gbLinkLQI;
am_addr_t gbCurrentParent, gbFormerParent, localAddress, preferredParent;
uint16_t gbCurrentParentCost;
uint8_t  gbCurrentHopCount;


// control variables to isolate out certain functions
bool congestionControl=TRUE;
bool noOuterFieldFeedback=FALSE;

// flags
bool radioOn = FALSE;
bool attemptingParentChange=FALSE;
bool processingBeacon = FALSE;
bool loopFound=FALSE;
bool pinParent = FALSE;
bool state_is_root;
bool localCongestionFlag;
bool gbParentChange;
bool routeLost = FALSE;

// counters
uint16_t congestionCounter=0;

// timing
uint32_t beaconTime;

// packets
Arbutus_routing_frame_t* thisBeacon;
Arbutus_routing_frame_t thisBeacon_i;
Arbutus_routing_frame_t queuedBeacon[BEACON_QUEUE_SIZE];
Arbutus_routing_frame_t* queuedBeaconPtr[BEACON_QUEUE_SIZE]; 
message_t beaconMsgBuffer;
Arbutus_routing_frame_t* beaconMsg;
Arbutus_routing_frame_t ina;
Arbutus_routing_frame_t* in=&ina;
message_t statsMsgPkt;
message_t* statsMsgPktPtr;
stats_msg_t* statsMsg;

// queueing
int8_t queueCount;
uint8_t queueIn, queueOut;

// non-essential variables, for stats only
uint16_t controlSeqNo=0;
uint8_t controlState=3;
uint16_t controlTrafficTx=0,controlTrafficRx=0;

void task statsTask();
void task sendBeaconTask(); 
 
////////////////////////////////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////////////////////////////////
/// LQI and RSS normalization
///////////////////////////////////////////////////////////////////////////////////////////////
   
uint16_t adjustLQI(uint8_t lqi) {
  uint16_t result; int16_t lqiNorm;
  lqiNorm=(-2*lqi+200)*10;
  if (lqiNorm<0)
  result=0; 
  else result=(uint16_t)((double)lqiNorm/10);
  return result;}
  
uint16_t adjustRSS_old(uint8_t rssi) {
    uint16_t result; int16_t rssiNorm;
    if (rssi<30) rssiNorm=0;
    else rssiNorm=-25*rssi+6375;
    if (rssiNorm<0)
    result=0; 
    else result=(uint16_t)((double)rssiNorm/10);
    return result;}

  
uint16_t adjustRSS(uint8_t rssi) {
    uint16_t result; int16_t rssiNorm;
    if (rssi<30) rssiNorm=0;
    else if (rssi>223) rssiNorm = 0;
    else rssiNorm=-3*rssi+669;
    if (rssiNorm<0)
    result=0; 
    else result=(uint16_t)((double)rssiNorm/10);
    return result;
  }

  
  
uint16_t max(uint16_t a, uint16_t b) {uint16_t res; if (a>b) res = a; else res = b; return res; }  

//////////////////////////////////////////////////////////////////////////////////////////////////////////////////
   

void task beaconProcessingTask()
{
  am_addr_t beaconer;   uint16_t beaconerParent;  uint16_t beaconFormerParent; 
  uint16_t beaconerHopCount, beaconerAdvertisedHopcount;   
  uint8_t beaconerRssBtl, beaconerRssBtlNorm;
  uint8_t beaconerLqiBtl, beaconerLqiBtlNorm;
  uint16_t beaconerLoadBtl;   uint16_t beaconerCost, rssCost, lqiCost;
  uint8_t beaconerRssLink;   uint8_t beaconerLqiLink;
  uint16_t beaconerRssLinkNorm, beaconerLqiLinkNorm, addendum;
  uint8_t oldHopcount;
  uint16_t beaconerMtx;
  bool badParent = FALSE;


 processingBeacon = TRUE;
  
  memcpy (thisBeacon, queuedBeaconPtr[queueOut], sizeof(Arbutus_routing_frame_t));

  beaconer=thisBeacon->sender;
  beaconerParent=thisBeacon->parent;
  beaconFormerParent=thisBeacon->formerParent;
  beaconerHopCount=thisBeacon->hopcount;
  beaconerAdvertisedHopcount=thisBeacon->advertisedHopcount;
  beaconerRssBtl=thisBeacon->rssBottleneck;
  beaconerLqiBtl=thisBeacon->lqiBottleneck;
  beaconerLoadBtl=thisBeacon->loadBottleneck;
  beaconerRssLink=thisBeacon->linkRSS;
  beaconerLqiLink= thisBeacon->linkLQI;
    beaconerMtx = thisBeacon->mtx; 
  gbLinkRSS=beaconerRssLink;
  gbLinkLQI=beaconerLqiLink;
  
  beaconerRssLinkNorm=adjustRSS(beaconerRssLink);
  beaconerLqiLinkNorm=adjustLQI(beaconerLqiLink);
  beaconerRssBtlNorm=(beaconerRssBtl);
  beaconerLqiBtlNorm=(beaconerLqiBtl);

  if (queueCount>0)  queueCount--;
  if (++queueOut>=BEACON_QUEUE_SIZE) queueOut=0;

if (pinParent && (beaconer != gbFormerParent))  { processingBeacon=FALSE;  if (queueCount>0) post beaconProcessingTask();
return;  // PARENT PINNING
}
else  
 
if ((gbCurrentParent != AM_BROADCAST_ADDR) && (((gbCurrentParent == beaconFormerParent) || (gbCurrentParent == beaconer)) && (beaconerParent == AM_BROADCAST_ADDR)))
{  


        if ((gbCurrentParent == beaconer)&&(beaconFormerParent==AM_BROADCAST_ADDR)) {

                pinParent = TRUE;  controlState = PINNED; 
                call PinTimer.startOneShot(BEACON_PERIOD*1024);}

        else controlState = UNPINNED;
        
        atomic gbFormerParent = gbCurrentParent; 
        atomic gbCurrentParent=AM_BROADCAST_ADDR;  
        atomic gbCurrentHopCount=ROUTE_INVALID;

        //post sendBeaconTask();
}
    
else if (beaconerParent != AM_BROADCAST_ADDR)
 
{ 


        pinParent = FALSE;
        correctionFactor=call controlToData.getMtx();
        if (correctionFactor>0) correctionFactor--;
   
        
       if (gbCurrentParent<NODES)
       badParent = (rnpHistory[gbCurrentParent]>2) ;
       else
       badParent = FALSE;


        if ((correctionFactor>5)||(badParent))
            {adjustedHopCount=gbCurrentHopCount+1; 
             addendum=100*(correctionFactor);}
        else 
            {adjustedHopCount=gbCurrentHopCount; 
             addendum=0;}
 
        if (noOuterFieldFeedback) adjustedHopCount=gbCurrentHopCount;
 
        if (((gbCurrentParent == AM_BROADCAST_ADDR)||(beaconer==gbCurrentParent)||(beaconerHopCount<adjustedHopCount))&&(beaconerParent!=localAddress)){

                lqiCost = beaconerLqiLinkNorm+beaconerHopCount*beaconerLqiBtlNorm;
                rssCost = beaconerRssLinkNorm+beaconerHopCount*beaconerRssBtlNorm;    

              
                if (LoadBalancing)
                    beaconerCost = rssCost + lqiCost + beaconerLoadBtl;
                else
                    beaconerCost = rssCost + lqiCost;

                if (noOuterFieldFeedback) addendum=0;

               //  if ((beaconerLqiLink<80)||((beaconerRssLink<0xD7)&&(beaconerRssLink>30)))
               // beaconerCost = 0xFFFF;



               if (((gbCurrentParent == AM_BROADCAST_ADDR)||(beaconer==gbCurrentParent)||((beaconerCost)<(gbCurrentParentCost + addendum)))){
                            gbFormerParent=gbCurrentParent;
                            oldHopcount = gbCurrentHopCount;
                            gbCurrentHopCount = beaconerHopCount+1;
                            adjustedHopCount = gbCurrentHopCount;
                            gbAdvertisedHopCountBaseline = beaconerAdvertisedHopcount+1;
                            gbCurrentParentCost = beaconerCost;  
                            gbLoadBtlDownstream = beaconerLoadBtl;
                            rssBottleneck=max(beaconerRssLinkNorm, beaconerRssBtlNorm);
                            lqiBottleneck=max(beaconerLqiLinkNorm, beaconerLqiBtlNorm);

                            if (beaconer!=gbCurrentParent) {
                                atomic gbCurrentParent = beaconer;  
                                gbParentChange=TRUE;
                                if (gbFormerParent<NODES)
                                rnpHistory[gbFormerParent]=correctionFactor;
                                call controlToData.resetMtx();}  
    
                            if ((gbFormerParent==AM_BROADCAST_ADDR)&&(gbCurrentParent!=AM_BROADCAST_ADDR)) 
                                {signal controlPlane.routeFound(); 
                                 }
                                controlState = ROUTE; }
            }
} 

processingBeacon = FALSE;
if (queueCount>0) post beaconProcessingTask();}
////////////////////////////////////////////////////////////////////////////////////////////
//  for use only with routing table  
void command dataToControl.attemptParentChange(bool forceChange) {

if (useRoutingTable) {

    if ((!attemptingParentChange)&&(controlState!=PINNED)) {

        attemptingParentChange=TRUE;
        preferredParent = call Parent.getPreferredParent(forceChange);
        gbFormerParent=gbCurrentParent;
        gbCurrentHopCount = call Parent.getPreferredParent_hopcount()+1;
        adjustedHopCount = gbCurrentHopCount;
        gbCurrentParentCost = call Parent.getPreferredParent_csiCost();  
        rssBottleneck=max(call Parent.getPreferredParent_rssLinkNorm()  , call Parent.getPreferredParent_rssBtlNorm());
        lqiBottleneck=max(call Parent.getPreferredParent_lqiLinkNorm()  , call Parent.getPreferredParent_lqiBtlNorm());

         if (preferredParent!=gbCurrentParent)
 
            {atomic gbCurrentParent = preferredParent;  
             gbParentChange=TRUE;
             call controlToData.resetMtx();}  
   
        controlState = ROUTE;
    
        if ((gbFormerParent==AM_BROADCAST_ADDR)&&(gbCurrentParent!=AM_BROADCAST_ADDR)) 
            {signal controlPlane.routeFound();}             

        attemptingParentChange=FALSE;}
}}

//////////////////////////////////////////////////////////////////
// BEACON RECEIVED
//////////////////////////////////////////////////////////////////
event message_t* BeaconReceive.receive(message_t* msg, void* payload, uint8_t len) {

if (!(call RootControl.isRoot())){ 

    in = (Arbutus_routing_frame_t*)payload;
    in->linkRSS= call CC2420Packet.getRssi(msg);
    in->linkLQI= call CC2420Packet.getLqi(msg);

    controlTrafficRx++;  
   
    if (queueCount<BEACON_QUEUE_SIZE)
        memcpy(queuedBeaconPtr[queueIn], in, sizeof(Arbutus_routing_frame_t));
     
    queueCount++;

    if (++queueIn>=BEACON_QUEUE_SIZE) queueIn=0; 

    if (! processingBeacon)
    post beaconProcessingTask();}

return msg;}

/////////////////////////////////////////////////////////////////////
// AT STARTUP
////////////////////////////////////////////////////////////////////////////////////////////

command error_t Init.init() {
uint32_t ranu = call Random.rand32() ;
beaconTime= 1024*BEACON_PERIOD+ranu%(1024*5);
return SUCCESS;}


command error_t StdControl.start() {

uint8_t k;
radioOn = FALSE; 
state_is_root = 0;
queueCount=0;
queueIn=0; queueOut=0;
localAddress = TOS_NODE_ID;

call Init.init();

statsMsgPktPtr=&statsMsgPkt;
thisBeacon=&thisBeacon_i;
gbAdvertisedHopCount=0xFFFF;
correctionFactor=0;

for (k=0; k<NODES; k++)
rnpHistory[NODES]=0;
    
for (k=0; k<BEACON_QUEUE_SIZE; k++)  
queuedBeaconPtr[k] = &queuedBeacon[k];  
        
gbParentChange = FALSE;
localCongestionFlag = FALSE;
controlTrafficTx=0;
controlTrafficRx=0;
localCongestionFlag = FALSE;
gbAdvertisedHopCountBaseline=ROUTE_INVALID;
gbLoadBtlDownstream=0;
  
if (TOS_NODE_ID!=BASE_STATION_ADDRESS)
    {atomic gbCurrentParent = AM_BROADCAST_ADDR;
     gbFormerParent=0;}
else 
    {atomic gbCurrentParent = 0;
     gbFormerParent=0;}
     gbCurrentParentCost = 0x7fff;
     gbCurrentHopCount = ROUTE_INVALID;
     return SUCCESS;}

command error_t StdControl.stop() { return SUCCESS;}
 

event void RadioControl.startDone(error_t error) {
    radioOn = TRUE;
    if (TOS_NODE_ID==BASE_STATION_ADDRESS)
	call BeaconTimer.startOneShot(1024);
    call StatsTimer.startPeriodic(STATS_COLLECTION);} 

event void RadioControl.stopDone(error_t error) {
        radioOn = FALSE;}
////////////////////////////////////////////////////////////////////////////////////////////

void task sendBeaconTask()

{
correctionFactor=call controlToData.getMtx();
beaconMsg = (Arbutus_routing_frame_t*)call BeaconSend.getPayload(&beaconMsgBuffer, call BeaconSend.maxPayloadLength());  
gbLocalLoad=call controlToData.getLoad();
beaconMsg->mtx = correctionFactor;

if (((gbCurrentParent!=AM_BROADCAST_ADDR)&&(!localCongestionFlag)) || (state_is_root)) {   
    beaconMsg->parent = gbCurrentParent;
    beaconMsg->formerParent = gbCurrentParent;
    beaconMsg->lqiBottleneck = lqiBottleneck;
    beaconMsg->rssBottleneck = rssBottleneck;
    beaconMsg->sender=localAddress;
    if (state_is_root)
      beaconMsg->loadBottleneck = 0; 
    else 
      beaconMsg->loadBottleneck = max(gbLocalLoad, gbLoadBtlDownstream);    
    if (correctionFactor>0) correctionFactor--;

    gbAdvertisedHopCount=gbAdvertisedHopCountBaseline + correctionFactor;
    
    beaconMsg->advertisedHopcount = gbAdvertisedHopCount;
    beaconMsg->hopcount = gbCurrentHopCount;
    beaconMsg->linkRSS = gbLinkRSS;
    beaconMsg->linkLQI = gbLinkLQI;
    beaconMsg->localLoad = gbLocalLoad;  
    beaconMsg->rate = 0;
    beaconMsg->controlSeqNo = controlSeqNo++; }
  else 
   {beaconMsg->loadBottleneck = 0xffff;
    beaconMsg->sender=localAddress;
    beaconMsg->hopcount = ROUTE_INVALID;
    beaconMsg->advertisedHopcount = ROUTE_INVALID;
    beaconMsg->linkRSS = 0x7f;
    beaconMsg->linkLQI = 0x7f;
    beaconMsg->localLoad = 0xffff;
    beaconMsg->parent = AM_BROADCAST_ADDR;
    beaconMsg->controlSeqNo = controlSeqNo++;
 
    //if ((!localCongestionFlag)||(loopFound)||(routeLost))   
    //beaconMsg->formerParent = gbFormerParent;  // tells neighbors to beware of gbCurrentParent if parent (not me) has loop or congestion
    //else
    beaconMsg->formerParent = AM_BROADCAST_ADDR;
    
    beaconMsg->lqiBottleneck = 0x7f;
    beaconMsg->rssBottleneck = 0x7f;
    
    beaconMsg->rate = 0;
    
    loopFound=FALSE; }
    
controlTrafficTx++;

call BeaconSend.send(AM_BROADCAST_ADDR, &beaconMsgBuffer, sizeof(Arbutus_routing_frame_t));}

event void StatsSend.sendDone(message_t* msg, error_t error) {}

event void BeaconSend.sendDone(message_t* msg, error_t error) {post statsTask();}

/////////////////////////////////////////////////////////////////////
// TIMERS
/////////////////////////////////////////////////////////////////////
 
event void BeaconTimer.fired() {
    uint32_t ranu = call Random.rand32() ;
    post sendBeaconTask();
    beaconTime = 1024*BEACON_PERIOD+ranu% 1024;
    call BeaconTimer.startOneShot(beaconTime);}

event void PinTimer.fired() {pinParent=FALSE;}

/////////////////////////////////////////////////////////////////////

event void controlToData.loopDetected()  {
    
if (!state_is_root) {
    loopFound = TRUE;
    gbFormerParent = gbCurrentParent;
    atomic gbCurrentParent = AM_BROADCAST_ADDR; 
    atomic gbCurrentHopCount=ROUTE_INVALID;
    post sendBeaconTask(); }}  

/////////////////////////////////////////////////////////////////////
         
event void controlToData.congestionDetected()  {
    
if (congestionControl) {      

      if (!state_is_root) {           

            if (((congestionCounter)%CONGESTION_PERIOD)==0) {
            atomic gbFormerParent = gbCurrentParent;
            localCongestionFlag = TRUE; post sendBeaconTask();} 
            congestionCounter++;
} } } 
         
event void controlToData.routeBroken()  {

if (!state_is_root) {
        routeLost = TRUE; localCongestionFlag = FALSE;
        atomic gbFormerParent = gbCurrentParent; 
        atomic gbCurrentParent=AM_BROADCAST_ADDR;  
        atomic gbCurrentHopCount=ROUTE_INVALID;
        //post sendBeaconTask();
}} 
/////////////////////////////////////////////////////////////////////
    
event void controlToData.decongestionDetected()  {
    
if (!state_is_root)
{localCongestionFlag = FALSE; post sendBeaconTask();
}}  
    
/////////////////////////////////////////////////////////////////////

Arbutus_routing_frame_t* getHeader(message_t* m) {
      return (Arbutus_routing_frame_t*)call BeaconSend.getPayload(m, call BeaconSend.maxPayloadLength());}
    
command am_addr_t Routing.nextHop() { return gbCurrentParent; }

command bool Routing.hasRoute() { return (gbCurrentParent != AM_BROADCAST_ADDR); }
   
command error_t RootControl.setRoot() {
     
    atomic {state_is_root = 1;}
    atomic gbCurrentParent = 0;
    gbCurrentParentCost = 0;
    gbCurrentHopCount = 0;
    gbAdvertisedHopCount=0; 
    gbAdvertisedHopCountBaseline = 0;
     
    return SUCCESS; }

command error_t RootControl.unsetRoot() {
        atomic { state_is_root = 0; }
        return SUCCESS; }

command bool RootControl.isRoot() {return state_is_root;}

default event void Routing.noRoute() { }
    
default event void Routing.routeFound() { }


command uint8_t dataToControl.get_adjustedHopcount() {return adjustedHopCount; }
command uint8_t dataToControl.get_hopcount() {return gbCurrentHopCount; }
command void dataToControl.triggerRouteUpdate() {}
command void dataToControl.triggerImmediateRouteUpdate() {}
command uint16_t dataToControl.getRxControl() {return controlTrafficRx;}
command uint16_t dataToControl.getTxControl() {return controlTrafficTx;}
     
default  void event controlPlane.routeFound() {


     
     if (TOS_NODE_ID!=BASE_STATION_ADDRESS) {
            if (call BeaconTimer.isRunning()) 
                call BeaconTimer.stop();   
                call BeaconTimer.startOneShot(102);} 

routeLost = FALSE;

signal Routing.routeFound();
}
     
void event controlToData.slowDown() {//post sendBeaconTask();
}
command am_addr_t dataToControl.getFormerParent() {return gbFormerParent;}
command uint8_t dataToControl.getControlState() {return controlState;}

// unessential functions, for stats only

void task statsTask()
    
{
  statsMsg = (stats_msg_t*)call StatsSend.getPayload(&statsMsgPkt, sizeof(stats_msg_t));
    
  statsMsg->parent=gbCurrentParent;
  statsMsg->hopcount=gbCurrentHopCount;
  statsMsg->queueOccupancy=call controlToData.getQueueOccupancy();
  statsMsg->controlState=controlState;
  statsMsg->dataTraffic_rx=call controlToData.getMtx();
  statsMsg->controlTraffic_rx=controlTrafficRx;
  statsMsg->controlTraffic_tx=controlTrafficTx;
  statsMsg->loop=loopFound;
  statsMsg->localCongestion=localCongestionFlag;
  statsMsg->pinParent=pinParent;
  
call StatsSend.send(0xffff, &statsMsgPkt,  sizeof(stats_msg_t));}
    
event void StatsTimer.fired() {  }
     
     
} 
