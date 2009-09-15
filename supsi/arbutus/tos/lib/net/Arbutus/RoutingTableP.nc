#include "RoutingTable.h"

module RoutingTableP {
  provides {
    interface StdControl;
    interface Receive;
    interface Parent;

  }

  uses {
    interface AMPacket as SubAMPacket;
    interface Packet as SubPacket;
    interface CC2420Packet;
    interface Receive as SubReceive;
    interface AMSend as SerialSend;
    interface Timer<TMilli> as TableEntryTimer;
    interface dataPlaneFeedback;
    interface dataToControl;
    interface Random;
       interface UnicastNameFreeRouting as Routing;
}}

implementation {

 Arbutus_routing_frame_t ina;
 Arbutus_routing_frame_t* in=&ina;



 neighbor_table_entry_t NeighborTable[NEIGHBOR_TABLE_SIZE];
 uint16_t latestRss, latestLqi, latestRnp, currentParent, preferredParent, latestSeqno;

 uint16_t beaconerParent;
 uint8_t beaconerHops;
 uint16_t beaconerRssBottleneck;
 uint16_t beaconerLqiBottleneck;
uint16_t latestMetric;

 uint8_t tableIndex = 0;
  message_t uartbuf;
entry_msg_t outa; 
 entry_msg_t* out=&outa;
  message_t* uartbufPtr=&uartbuf;
    neighbor_table_entry_t *nee;

uint16_t adjustLQI(uint8_t lqi) {
  uint16_t result; int16_t lqiNorm;
  lqiNorm=(-2*lqi+200)*10;
  if (lqiNorm<0)
  result=0; 
  else result=(uint16_t)((double)lqiNorm/10);
  return result;}
  
uint16_t adjustRSS(uint8_t rssi) {
    uint16_t result; int16_t rssiNorm;
    if (rssi<30) rssiNorm=0;
    else rssiNorm=-25*rssi+6375;
    if (rssiNorm<0)
    result=0; 
    else result=(uint16_t)((double)rssiNorm/10);
    return result;
  }
  
uint16_t max(uint16_t a, uint16_t b) {uint16_t res; if (a>b) res = a; else res = b; return res; }  


uint16_t getMetric ()

{
uint16_t rssCost, lqiCost;

  lqiCost = latestLqi+max(latestLqi, beaconerLqiBottleneck);
 // if (lqiCost>0) 
     rssCost = latestRss+max(latestRss, beaconerRssBottleneck);
//  else 
//     rssCost=0; 

lqiCost = latestLqi+beaconerHops*beaconerLqiBottleneck;
rssCost = latestRss+beaconerHops*beaconerRssBottleneck;    




return (rssCost+lqiCost);





}


  uint16_t findBestNeighbor() {

uint8_t i;
    uint8_t bestNeighborIdx = INVALID_RVAL;
    uint16_t bestMetric = 0xFFFF, thisMetric;
    uint16_t preferred = 0xFFFF;
    for (i = 0; i < NEIGHBOR_TABLE_SIZE; i++) {
      if (NeighborTable[i].flags == 1)  {

   if ((latestSeqno-NeighborTable[i].lastseq)>2)
   NeighborTable[i].flags=0;
		   
     thisMetric = NeighborTable[i].metric;
      if ((thisMetric < bestMetric)  &&  ((latestSeqno-NeighborTable[i].lastseq)<2)) {
	bestNeighborIdx = i;
	bestMetric = thisMetric;
    preferred=NeighborTable[bestNeighborIdx].ll_addr;
      }
    }}
    return preferred;
  }




task void printTable()

{
uint32_t ranu = call Random.rand32() ; 

out = (entry_msg_t*)call SerialSend.getPayload(uartbufPtr, sizeof(entry_msg_t));

nee = &NeighborTable[tableIndex];

if (tableIndex==NEIGHBOR_TABLE_SIZE)
{
call TableEntryTimer.startOneShot(1024*30+ranu%1024);
tableIndex=0;}

else {
tableIndex++;
if (nee->flags==1) {

out->rssBottleneck=nee->rssBottleneck;
out->lqiBottleneck=nee->lqiBottleneck;
out->metric=nee->metric;
out->node = nee->node;
out->ll_addr=nee->ll_addr;
out->isParent = nee->isParent;
out->beaconerParent = nee->beaconerParent;
out->local_hopcount = nee->local_hopcount;
out->local_adjustedHopcount = nee->local_adjustedHopcount;
out->beaconer_hopcount = nee->beaconer_hopcount;
out->lastseq=nee->lastseq;
out->formerParent=nee->formerParent;
out->controlState=nee->controlState;
//out->rcvcnt=nee->rcvcnt;
//out->failcnt=nee->failcnt;
out->rss=nee->rss;
out->lqi=nee->lqi;
out->rnp=nee->rnp;
out->flags=nee->flags;
out->freaky=nee->freaky;
out->preferredParent = preferredParent;
out->tableIndex = tableIndex;

call SerialSend.send(0xffff, uartbufPtr, sizeof(entry_msg_t));}
call TableEntryTimer.startOneShot(128);
}



}

  
    // initialize the given entry in the table for neighbor ll_addr
  void initNeighborIdx(uint8_t i, am_addr_t ll_addr) {
    neighbor_table_entry_t *ne;
    ne = &NeighborTable[i];
    ne->ll_addr = ll_addr;
    ne->freaky = 0;
    ne->isParent = 0xFFFF;
    ne->lastseq = 0;
    ne->rcvcnt = 0;
    ne->failcnt = 0;
    ne->rss = 0;
    ne->lqi = 0;
    ne->rnp = 0xFFFF;
    ne->flags = 1;

  }

  uint8_t findIdx(am_addr_t ll_addr) {
    uint8_t i;
    for (i = 0; i < NEIGHBOR_TABLE_SIZE; i++) {
      if (NeighborTable[i].flags == 1) {
	if (NeighborTable[i].ll_addr == ll_addr) {
	  return i;
	}
      }
    }
    return INVALID_RVAL;
  }

  uint8_t findEmptyNeighborIdx() {
    uint8_t i;
    for (i = 0; i < NEIGHBOR_TABLE_SIZE; i++) {
      if (NeighborTable[i].flags == 1) {
      } else {
	return i;
      }
    }
      return INVALID_RVAL;
  }

  




  void updateNeighborEntryIdx(uint8_t idx, uint16_t seq) {
    uint8_t packetGap;

latestSeqno=seq;

    if (NeighborTable[idx].flags == 0) {
      NeighborTable[idx].lastseq = seq;
      NeighborTable[idx].flags = 1;
    }
    
    packetGap = seq - NeighborTable[idx].lastseq;

    NeighborTable[idx].lastseq = seq;
    NeighborTable[idx].rcvcnt++;
    if (packetGap > 0) {
      NeighborTable[idx].failcnt += packetGap - 1;
    }
    if (packetGap > 100) {
      NeighborTable[idx].failcnt = 0;
      NeighborTable[idx].rcvcnt = 1;
    }
   
      NeighborTable[idx].rss = latestRss;
      NeighborTable[idx].lqi = latestLqi;

      NeighborTable[idx].node = TOS_NODE_ID;
 NeighborTable[idx].beaconerParent = beaconerParent;
 NeighborTable[idx].rssBottleneck = beaconerRssBottleneck;
NeighborTable[idx].lqiBottleneck = beaconerLqiBottleneck;
NeighborTable[idx].beaconer_hopcount = beaconerHops;
NeighborTable[idx].local_hopcount = call dataToControl.get_hopcount();
NeighborTable[idx].local_adjustedHopcount = call dataToControl.get_adjustedHopcount();
NeighborTable[idx].formerParent = call dataToControl.getFormerParent();
NeighborTable[idx].controlState = call dataToControl.getControlState();

if (NeighborTable[idx].rnp == 0xFFFF)
NeighborTable[idx].metric = getMetric();
else
NeighborTable[idx].metric = getMetric()+ NeighborTable[idx].rnp;

NeighborTable[idx].isParent=call Routing.nextHop();

preferredParent = findBestNeighbor();



 }

event void dataToControl.routeStuck() {




}

    
  void initNeighborTable() {
    uint8_t i;

    for (i = 0; i < NEIGHBOR_TABLE_SIZE; i++) {
      NeighborTable[i].flags = 0;
    }
  }


  command error_t StdControl.start() {
        
uint32_t ranu = call Random.rand32() ; initNeighborTable();
call TableEntryTimer.startOneShot(ranu%(1024*5));
    return SUCCESS;
  }

  command error_t StdControl.stop() {
    return SUCCESS;
  }




void processReceivedMessage(message_t* msg, void* payload, uint8_t len) {
    uint8_t nidx;





 
    if (call SubAMPacket.destination(msg) == AM_BROADCAST_ADDR) {

      am_addr_t ll_addr;
      in = (Arbutus_routing_frame_t*)payload;

  beaconerHops=in->hopcount;


if (beaconerHops>=( call dataToControl.get_adjustedHopcount()))
return;


      ll_addr = in->sender;
      nidx = findIdx(ll_addr);

      latestRss = adjustRSS(call CC2420Packet.getRssi(msg));
      latestLqi = adjustLQI(call CC2420Packet.getLqi(msg));
  beaconerParent=in->parent;

  beaconerRssBottleneck=in->rssBottleneck;
  beaconerLqiBottleneck=in->lqiBottleneck;

      

      if (nidx != INVALID_RVAL) {
    	updateNeighborEntryIdx(nidx, in->controlSeqNo);
      } else {
	    nidx = findEmptyNeighborIdx();
	
      if (nidx != INVALID_RVAL) {
	  initNeighborIdx(nidx, ll_addr);
	  updateNeighborEntryIdx(nidx, in->controlSeqNo);} 
}}  }


 event message_t* SubReceive.receive(message_t* msg,
				      void* payload,
				      uint8_t len) {
    processReceivedMessage(msg, payload, len);
    return signal Receive.receive(msg,
				  call SubPacket.getPayload(msg, call SubPacket.payloadLength(msg)),
				  call SubPacket.payloadLength(msg));
  }


  event void SerialSend.sendDone(message_t *msg, error_t error) {}

event void TableEntryTimer.fired() {

post printTable();


}

event void dataPlaneFeedback.updateRnp (uint16_t address, uint16_t rnp)

{

    uint8_t nidx;

      nidx = findIdx(address);
currentParent = address;
latestRnp = rnp;
NeighborTable[nidx].rnp=(uint16_t)latestRnp;

if (latestRnp>5)
NeighborTable[nidx].freaky = 1;


}

  event void Routing.routeFound() {
    
  }

  event void Routing.noRoute() {
    
  }

command uint16_t Parent.getPreferredParent(bool forceChange)

{
if (forceChange) {
uint8_t nidx = findIdx(currentParent);
NeighborTable[nidx].rnp=1000;}
preferredParent = findBestNeighbor();


return preferredParent;}


command uint8_t Parent.getPreferredParent_hopcount()
{uint8_t nidx = findIdx(preferredParent); return NeighborTable[nidx].beaconer_hopcount;}

command uint16_t Parent.getPreferredParent_csiCost()  
{uint8_t nidx = findIdx(preferredParent); return (NeighborTable[nidx].rss + NeighborTable[nidx].lqi + NeighborTable[nidx].rssBottleneck + NeighborTable[nidx].lqiBottleneck);}


command uint8_t Parent.getPreferredParent_rssLinkNorm()
{uint8_t nidx = findIdx(preferredParent); return NeighborTable[nidx].rss;}


command uint8_t Parent.getPreferredParent_rssBtlNorm()
{uint8_t nidx = findIdx(preferredParent); return NeighborTable[nidx].rssBottleneck;}

command uint8_t Parent.getPreferredParent_lqiLinkNorm()
{uint8_t nidx = findIdx(preferredParent); return NeighborTable[nidx].lqi;}


command uint8_t Parent.getPreferredParent_lqiBtlNorm()
{uint8_t nidx = findIdx(preferredParent); return NeighborTable[nidx].lqiBottleneck;}





}