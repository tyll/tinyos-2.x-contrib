// ex: set tabstop=2 shiftwidth=2 expandtab syn=c:
// $Id$

/*                                                                      
 * "Copyright (c) 2000-2005 The Regents of the University  of California.  
 * All rights reserved.
 *
 * Permission to use, copy, modify, and distribute this software and its
 * documentation for any purpose, without fee, and without written agreement is
 * hereby granted, provided that the above copyright notice, the following
 * two paragraphs and the author appear in all copies of this software.
 * 
 * IN NO EVENT SHALL THE UNIVERSITY OF CALIFORNIA BE LIABLE TO ANY PARTY FOR
 * DIRECT, INDIRECT, SPECIAL, INCIDENTAL, OR CONSEQUENTIAL DAMAGES ARISING OUT
 * OF THE USE OF THIS SOFTWARE AND ITS DOCUMENTATION, EVEN IF THE UNIVERSITY OF
 * CALIFORNIA HAS BEEN ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
 * 
 * THE UNIVERSITY OF CALIFORNIA SPECIFICALLY DISCLAIMS ANY WARRANTIES,
 * INCLUDING, BUT NOT LIMITED TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY
 * AND FITNESS FOR A PARTICULAR PURPOSE.  THE SOFTWARE PROVIDED HEREUNDER IS
 * ON AN "AS IS" BASIS, AND THE UNIVERSITY OF CALIFORNIA HAS NO OBLIGATION TO
 * PROVIDE MAINTENANCE, SUPPORT, UPDATES, ENHANCEMENTS, OR MODIFICATIONS."
 *
 * Copyright (c) 2002-2003 Intel Corporation
 * All rights reserved.
 *
 * This file is distributed under the terms in the attached INTEL-LICENSE     
 * file. If you do not find these files, copies can be found by writing to
 * Intel Research Berkeley, 2150 Shattuck Avenue, Suite 1300, Berkeley, CA, 
 * 94704.  Attention:  Intel License Inquiry.
 */

/*
 * Authors:  Rodrigo Fonseca
 * Date Last Modified: 2005/11/17
 */

/* This is the main module of BVR. Provides the "route to coordinates"
* interface, and uses the services of the BVRControl plane, Link Estimator,
* logging, etc.
* The current implementation does not do the successive dropping of beacons
* that is described in the BVR paper, and uses beacons that are statically
* assigned through topology.h. The coordinate table, link estimator, 
* coordinate establishment and continuous maintenance, greedy and fallback
* routing, as well as the scoped flood are all implemented.
*
* Minor change (2005/11/17): previously receive to the local node would only
*   be signalled if the dest_id field matched the node_id of this node. Now
*   if the coordinates are the same AND dest_id == TOS_BCAST_ADDR, then we also
*   call receive. This in effect implements an anycast to any node which has the
*   same coordinates. One use of this is to send a message to a beacon:
*   set dest_id to TOS_BCAST_ADDR and the coordinates to 0 in the beacon you want,
*   invalid for all others.
*/

#define DBG_ROUTE "S4Router"
#define DBG_USR2 "S4UserRouter"


includes Timer;


includes AM;
includes S4;
includes Logging;
includes nexthopinfo;



module S4RouterM {
  provides {
    interface StdControl;
    interface S4Send;
    interface S4Receive;
    interface Init;
    
    #ifdef FAILURE_RECOVERY 
        command void set_fr_timer(uint16_t t);
        command error_t get_fr_timer(uint16_t *t);
#endif
  }
  uses {
    interface S4Neighborhood as Neighborhood;
    interface S4Locator as Locator;
    interface AMSend;
    interface Receive;
    
    #ifdef FAILURE_RECOVERY /////////////?????
        interface AMSend;
        interface Receive;
      
    #endif
    

    interface Timer<TMilli> as ForwardDelayTimer;
    interface Random;

    interface Packet;
    interface AMPacket;
    
    #ifdef FAILURE_RECOVERY  
       interface Timer as FRSendReplyTimer;
       interface Timer as FRWaitReplyTimer;
       interface LinkEstimator;
    #endif
    
    #ifdef SERIAL_LOGGING
    interface AMSend as SerialAMSend ;
    interface SplitControl as SerialAMControl;
    interface Packet as SerialPacketInterface;
    
    interface Packet as BeaconsPacketInterface;
    interface AMSend as BeaconsAMSend; 
    #endif
    
    
    interface Timer<TMilli> as PeriodicTimer;
    interface S4Topology;
  
  }
}
implementation {
  
  enum {
    DUP_CACHE_SIZE = 4,
    DUP_CACHE_ENABLED = 1,
  };
 
  typedef struct {
    bool valid;
    uint16_t min_dist;
    uint32_t key;
  } duplicateCacheEntry;

  
  /* "Unique" identifier for the messages originated at this
   *  node. This, plus the source id, is used for duplicate
   *  suppression of messages across the network. Wrap around
   *  should be fine with 16 bits, because we don't expect the
   *  nodes to keep 64K packets from the same source around! 
   *  This will be incremented with each call to BVRSend */
  uint16_t local_message_counter;
  
  uint8_t dup_cache_index;
  duplicateCacheEntry dup_cache[DUP_CACHE_SIZE];


  Coordinates my_coords;
  bool coords_valid;

  forwardRoutingBuffer forward_buffer;
  forwardRoutingBuffer send_buffer;

  message_t fwd_buf;

  enum {
    BCAST_MEAN_DELAY = 2   //in ms
  };

  bool forward_delay_timer_pending;
  uint32_t forward_delay;
  uint32_t delay_timer_jit;
  bool initialized = FALSE;
  
  bool serialPortLocked = FALSE;
  
  message_t loggingPacket;  


  //Forward Declarations
  
  void duplicateCacheInit();
  //bool duplicateCacheFind(uint32_t key, uint16_t dist);
  //void duplicateCacheUpdate(uint32_t key, uint16_t dist);
  bool duplicateCacheFind(uint32_t key);
  void duplicateCacheUpdate(uint32_t key);
  void duplicateCacheRemove(uint32_t key);
  uint32_t getMsgUid(uint16_t, uint16_t);
  
  
  
  //////////////////////////////////////////****** added
  
  
  #ifdef FAILURE_RECOVERY
    //state maintained for requester
    message_t* fr_reqmsg;   ////////////************************************???????
    message_t* msg_in_recovery = NULL; //////////////**************************?????
    uint16_t salvaging_nexthop = INVALID_NODE_ID;
    uint8_t salvaging_costtype; //to closest beacon or destination
    uint8_t salvaging_cost;
  
    /* state maintained for replier
     * we need to maintain these soft state because
     * the reply msg is not sent back right away,
     * but sent after a certain random delay
     */
    message_t* fr_repmsg;  ///////////////**************************************
    bool reply_busy = FALSE;
    uint16_t reply_requester;
    uint8_t reply_costtype;
    uint8_t reply_cost;
      //maoy
      uint16_t fr_timer = I_WAIT_FR;
#endif
  
  
  ///////////////////////////////////////////////////////////////
  ///////////**********************************************************
  
    void sendBeaconsListPacket() {      
#ifndef TOSSIM
      /*BeaconsListPacket* bp = (BeaconsListPacket*) call BeaconsPacketInterface.getPayload(&loggingPacket, NULL);
      
      if (serialPortLocked)
        return;
      
      bp->beacon1 = my_coords.nodeIds[0];
      bp->beacon2 = my_coords.nodeIds[1];
      bp->beacon3 = my_coords.nodeIds[2];
      bp->beacon4 = my_coords.nodeIds[3];
      bp->beacon5 = my_coords.nodeIds[4];
      bp->beacon6 = my_coords.nodeIds[5];
      bp->beacon7 = my_coords.nodeIds[6];
      bp->beacon8 = my_coords.nodeIds[7];
      
      if (call BeaconsAMSend.send(AM_BROADCAST_ADDR, &loggingPacket, sizeof(BeaconsListPacket)) ==SUCCESS){
        serialPortLocked = TRUE;
      }*/
  
#endif
    }
    
    void sendTestSerialPacket(uint16_t origin,  uint16_t dest, uint16_t last_hop, uint8_t type, uint8_t received) {
  #ifndef TOSSIM
  #ifdef SERIAL_LOGGING
      SerialPacket* sp = (SerialPacket*) call SerialPacketInterface.getPayload(&loggingPacket, NULL);         
  
      if (serialPortLocked)
            return;    
      
      sp->origin = origin;
      sp->dest = dest;
      sp->type = type;
      sp->received = received;
      sp->last_hop = last_hop;
      if (call SerialAMSend.send(AM_BROADCAST_ADDR, &loggingPacket, sizeof(SerialPacket))==SUCCESS) {
        serialPortLocked = TRUE;
      }
  #endif
  #endif
  }
 

  command error_t Init.init() {  
    //init forwarding    
    local_message_counter = 0;
    forwardRoutingBufferInit(&send_buffer,NULL);
    forwardRoutingBufferInit(&forward_buffer,&fwd_buf);
    forward_delay_timer_pending = FALSE;
    delay_timer_jit = BCAST_MEAN_DELAY;

    duplicateCacheInit();
    
    coords_valid = FALSE; 
    
     #ifdef FAILURE_RECOVERY
     fr_timer=I_WAIT_FR;
     #endif
      
    initialized = TRUE;  /////*****???????????????
#ifdef SERIAL_LOGGING    
    call SerialAMControl.start();
#endif
    return SUCCESS;
  }
  
  command error_t StdControl.start() {
    if (!initialized) {
      //init forwarding    
      local_message_counter = 0;
      forwardRoutingBufferInit(&send_buffer,NULL);
      forwardRoutingBufferInit(&forward_buffer,&fwd_buf);
      forward_delay_timer_pending = FALSE;
      delay_timer_jit = BCAST_MEAN_DELAY;

      duplicateCacheInit();
    
      coords_valid = FALSE;
      
#ifdef SERIAL_LOGGING      
      call SerialAMControl.start();
#endif
      initialized = TRUE;
    }
    
    coords_valid = (call Locator.getCoordinates(&my_coords) == SUCCESS);
    return SUCCESS;
  }
  
  command error_t StdControl.stop() {
    return SUCCESS;
  }

  
  /* forwardMessage is called by both sendMsg (in case this is the
   * first hop) and receiveMsg (in case this is being forwarded).
   * Assumes that there is a valid next hop at the current index.
   * In particular, this function assumes that nextHops has been filled elsewhere.
   * If fallback, sets a flag in the packet for logging purposes.
   * If the address is not valid, or inconsistent state, LOG_SEND_ERROR
   * If send fails, drop the message, LOG_SEND_FAIL, free the buffer
   * If send succeeds, we just wait for the sendDone
   */
  static error_t forwardMessage(forwardRoutingBuffer *fb) {
    S4AppMsg* pS4Msg;

    uint32_t msg_uid; //the duplicateCache key of this message
    
    pS4Msg = (S4AppMsg*)fb->msg->data;

     /*Sanity check*/
    #ifdef CRROUTING        
        if (!fb->busy || fb->msg == NULL /*|| fb->next_hop == INVALID_NODE_ID*/) {
          dbg(DBG_ROUTE,"Error here\n");

          return FAIL;
        }
    #endif
        
        /*Try to send the message*/
    #ifdef CRROUTING
        if (call AMSend.send(fb->next_hop,  fb->msg, sizeof(S4AppMsg)) == SUCCESS) {
    

    
          //dbg(DBG_ROUTE,"S4Router$forwardMessage: scheduled send to %d (tried_hopcount: %d), wait for sendDone\n", fb->next_hop, pS4Msg->type_data.tried_hopcount);
    
          return SUCCESS;
        } else {
          dbg(DBG_ROUTE,"S4Router$forwardMessage: send failed. Queue full\n");

          //remove from duplicateCache (since we didn't send it!)
          msg_uid = getMsgUid(pS4Msg->type_data.origin,pS4Msg->type_data.msg_id);
          duplicateCacheRemove(msg_uid);
          forwardRoutingBufferFree(fb);
          return FAIL;
        }
    #endif
    
      }  
    
      event void AMSend.sendDone(message_t* msg, error_t result) {
        forwardRoutingBuffer * fb;
        S4AppMsg* pS4Msg;
        uint8_t status;
    /*
    #ifdef FAILURE_RECOVERY
        error_t rslt;
        uint16_t old_nexthop;
        uint8_t old_costtype;
        uint8_t old_cost;
    #endif
    */
        pS4Msg = (S4AppMsg*)msg->data;
        //dbg(DBG_ROUTE, "S4Router$AMSend$sendDone:sucess=%d\n",result);
        if (msg == forward_buffer.msg) {
          fb = &forward_buffer;
        } else if (msg == send_buffer.msg) {
          fb = &send_buffer;
        } else {
          dbg(DBG_ROUTE, "S4Router$AMSend$sendDone: error:%p is not a known buffer!\n",msg);
          //call Logger.LogRouteReport(LOG_ROUTE_BUFFER_ERROR,pS4Msg->type_data.msg_id,pS4Msg->type_data.origin,pS4Msg->type_data.dest_id,pS4Msg->type_data.hopcount-1,pS4Msg->type_data.closest_beacon,pS4Msg->type_data.rexmit_count,pS4Msg->type_data.tried_hopcount);
        }
        if (result == SUCCESS) { //SENT_OK
          if (call AMPacket.destination(msg) == TOS_BCAST_ADDR) {
            status = LOG_ROUTE_SENT_BCAST_OK;
    #ifdef CRROUTING
          } else status = LOG_ROUTE_SENT_NORMAL_OK;
    #endif
    
          //call Logger.LogRouteReport(status,pS4Msg->type_data.msg_id,pS4Msg->type_data.origin,pS4Msg->type_data.dest_id,pS4Msg->type_data.hopcount-1,pS4Msg->type_data.closest_beacon,pS4Msg->type_data.rexmit_count,pS4Msg->type_data.tried_hopcount);
          forwardRoutingBufferFree(fb);
          if (fb == &send_buffer) {
            signal S4Send.sendDone(msg,result);
            return;
          }
          else 
            return;
        } else { //sendDone result=FAIL
          /* here is the case of node failure.
           * added implementation of the failure recovery feature.
           * it's a one-time recovery for this data packet only,
           * no routing state update is involved.
           */
    
    
    #ifndef FAILURE_RECOVERY
    
            dbg(DBG_ROUTE,"forwarding to %d failed (src %d dest %d)\n",fb->next_hop,pS4Msg->type_data.origin,pS4Msg->type_data.dest_id);
    
            forwardRoutingBufferFree(fb);
            if (call AMPacket.destination(msg) == TOS_BCAST_ADDR) {
              status = LOG_ROUTE_STATUS_BCAST_FAIL;
            } else {
              status = LOG_ROUTE_FAIL_STUCK;
            }
            //call Logger.LogRouteReport(status,pS4Msg->type_data.msg_id,pS4Msg->type_data.origin,pS4Msg->type_data.dest_id,pS4Msg->type_data.hopcount-1,pS4Msg->type_data.closest_beacon,pS4Msg->type_data.rexmit_count,pS4Msg->type_data.tried_hopcount);
            if (fb == &send_buffer) {
              signal S4Send.sendDone(msg,result);
              return;
            }
            else 
              return ;
    #if 0
          }
    #endif
    
    #else
          /* create a FRReq msg and broadcast it.
           * then start a wait timer.
           * choose a next hop for recovery when timer expires
           */
          FRReqMsg* pFRMsg = (FRReqMsg*) &fr_reqmsg.data[0];
          FRReqMsgData* pFRMsgData = (FRReqMsgData*) &pFRMsg->type_data;
   
          //pFRMsgData->requester_id = TOS_LOCAL_ADDRESS;
          pFRMsgData->dest_id = pS4Msg->type_data.dest_id;
          pFRMsgData->closest_beacon = pS4Msg->type_data.closest_beacon;
          pFRMsgData->cur_next_hop = fb->next_hop;
          pFRMsgData->cost_type = fb->cost_type;
          pFRMsgData->cost = fb->cost;
    
          dbg(DBG_ROUTE,"node %d failure\n",fb->next_hop);
    
          if (call FRReqAMSend.send(TOS_BCAST_ADDR,(uint8_t)sizeof(FRReqMsg),&fr_reqmsg) == SUCCESS) {
    
            dbg(DBG_ROUTE,"send a FRReq msg\n");
    
            msg_in_recovery = msg;  //maintain the (address of) msg being recovered
            pS4Msg->type_data.data.data[0]++;
            return SUCCESS;
          } else msg_in_recovery = NULL;
          if (fb == &send_buffer)
            return signal S4Send.sendDone(msg,result);
          else
            return SUCCESS;
    #endif
        }
    #ifdef CRROUTING
    //will we reach here?
        if (fb == &send_buffer) {
          signal S4Send.sendDone(msg,result);
          return;
        }
        else
          return ;
    #endif
      }
    
    #ifdef CRROUTING
       command error_t S4Send.send(message_t* msg, uint16_t mhLength,
                                    uint16_t dest_id, uint8_t closest_beacon)
    #endif
      {
        uint8_t status = LOG_ROUTE_INVALID_STATUS;
        
        S4AppMsg* pS4Msg = (S4AppMsg*)msg->data;
        
        
        error_t result;
    
        pS4Msg->type_data.msg_id = local_message_counter++;            
    
        /*If the message is for us, drop it, and return FAIL*/
        if (dest_id == call AMPacket.address()) {
          status = LOG_ROUTE_TO_SELF;
          dbg(DBG_ROUTE,"S4Router$S4Send$send: dest_id is for us, error!\n");
        } else {
          /* Message is for someone else */
          if (send_buffer.busy) {
            /*Cannot take message */
            status = LOG_ROUTE_FAIL_NO_LOCAL_BUFFER;
    
            dbg(DBG_ROUTE,"no send_buffer failure\n");
    
          } else {
            /*Have room*/
            

            send_buffer.busy = TRUE; 
            send_buffer.msg = msg;
            /* Fill Routing Header fields */
            pS4Msg->type_data.hopcount = 1;
            pS4Msg->type_data.rexmit_count = 0; //added by Feng Wang on 09/22
            pS4Msg->type_data.tried_hopcount = 0; //added by Feng Wang on 09/22
            pS4Msg->type_data.origin = call AMPacket.address();
            pS4Msg->type_data.dest_id = dest_id;
            
            
            
    #ifdef CRROUTING
            pS4Msg->type_data.closest_beacon = closest_beacon;
    #ifndef FAILURE_RECOVERY
            result = call Neighborhood.getNextHops(dest_id, closest_beacon, &send_buffer.next_hop);
    #else
            result = call Neighborhood.FR_getNextHops(dest_id, closest_beacon, &send_buffer.next_hop, &send_buffer.cost_type, &send_buffer.cost);
    #endif
            if (result == FAIL /*|| send_buffer.next_hop == INVALID_NODE_ID*/) {
    #endif    
              status = LOG_ROUTE_FAIL_STUCK_0; //no more next hops
    
    #ifndef FAILURE_RECOVERY
    
              dbg(DBG_ROUTE,"STUCK_0 failure\n");
    
              forwardRoutingBufferFree(&send_buffer);
    #else
              /* modified by Feng Wang on Mar 15,
               * suggested by Lili and Yun, forward to a 
               * fake node (use the dest_id), so that
               * failure recovery will take over later.
               */
              send_buffer.next_hop = dest_id;

              return forwardMessage(&send_buffer);
    #endif
    
            } else {
              /*At least one next hop, start the trial process*/
              //Hack to force flood from the start 
              //send_buffer.next_hops.n = 0;
              //send_buffer.next_hops.f = 1;
              //send_buffer.next_hops.index = 0;
              //send_buffer.next_hops.next_hops[0] = TOS_LOCAL_ADDRESS;
              uint8_t root_beacon_id[N_NODES];
              
              call S4Topology.getRootBeaconIDs(root_beacon_id);
              
              dbg("TestBVR", "closest_beacon=%d, send_buffer.next_hop=%d\n", closest_beacon, send_buffer.next_hop);

	      if ( send_buffer.next_hop == INVALID_NODE_ID  ) {
                 
                //signal S4Send.sendDone(msg, SUCCESS);

                //return SUCCESS;
                return FAIL;
	      }
	      else {	         
	         return forwardMessage(&send_buffer);
              }
              
            }
          } //buffer is not busy
        } //else message is not for us
    
        
        return FAIL;
        /* The only successful path out of this function 
         * is when forwardMessage returns SUCCESS 
         */
      }
    
      event message_t* Receive.receive(message_t* pMsg, void* msgPayload, uint8_t len) {
        message_t* next_receive = NULL;
        S4AppMsg* pS4Msg;
        uint8_t status = LOG_ROUTE_INVALID_STATUS;
    
        void *payload;
        uint16_t payloadLen;
    
        /*Dup cache entry*/
        uint32_t msg_uid;
    
        error_t result;
    
        payloadLen = TOSH_DATA_LENGTH - (offsetof(S4AppMsg,type_data) + offsetof(S4AppData,data));
        pS4Msg = (S4AppMsg*)msgPayload;
        payload = &pS4Msg->type_data.data;
        

	dbg("TestBVR","BVRRouter$ReceiveMsg: org:%d last_hop:%d hopcount:%d  dest:%d,   time=%s\n",
		 pS4Msg->type_data.origin, pS4Msg->header.last_hop,
		 pS4Msg->type_data.hopcount,
		 pS4Msg->type_data.dest_id,
		 sim_time_string());
		 
#ifndef TOSSIM    
#ifdef SERIAL_LOGGING
      if ( !serialPortLocked ) {
	SerialPacket* sp = (SerialPacket*) call SerialPacketInterface.getPayload(&loggingPacket, NULL);
	sp->origin = pS4Msg->type_data.origin;
	sp->dest = pS4Msg->type_data.dest_id;	
	sp->received = TRUE;
	sp->last_hop = pS4Msg->header.last_hop;
	if (call SerialAMSend.send(AM_BROADCAST_ADDR, &loggingPacket, sizeof(SerialPacket))==SUCCESS){
	  serialPortLocked = TRUE;
	}
      }
#endif
#endif

        msg_uid = getMsgUid(pS4Msg->type_data.origin,pS4Msg->type_data.msg_id);
        if (duplicateCacheFind(msg_uid)) {
          //Ignore message
          dbg(DBG_ROUTE,"S4Router$Receive: duplicate!! Ignoring message (src %d dest %d)\n",pS4Msg->type_data.origin,pS4Msg->type_data.dest_id);
          
          next_receive = pMsg;
          return next_receive;
        }
        //Not duplicate, proceed with normal processing
        duplicateCacheUpdate(msg_uid);
    
        
    
        /* If the message is for us */
    #ifdef CRROUTING
        if (pS4Msg->type_data.dest_id == call AMPacket.address() ||
            pS4Msg->type_data.dest_id == TOS_BCAST_ADDR) {
    #endif
          status = LOG_ROUTE_SUCCESS;
          
            dbg("TestBVR","DestinedPacket: org:%d last_hop:%d hopcount:%d  \n",
	                 pS4Msg->type_data.origin, pS4Msg->header.last_hop,
	                 pS4Msg->type_data.hopcount
	                 );
          next_receive = signal S4Receive.receive(pMsg, payload, payloadLen);
        } else {
	        
          /* Not for us, forward */
          if (forward_buffer.busy) {
            /*Cannot take message */
            status = LOG_ROUTE_FAIL_NO_LOCAL_BUFFER;        
    
            dbg(DBG_ROUTE,"no forward_buffer failure\n");
    
            next_receive = pMsg;
            //remove message from duplicateCache
            duplicateCacheRemove(msg_uid);
          } else {
            forward_buffer.busy = TRUE;
            //swap buffers
            next_receive = forward_buffer.msg;
            forward_buffer.msg = pMsg;
           
            if (call AMPacket.destination(pMsg) == TOS_BCAST_ADDR) {
    #ifdef CRROUTING
                forward_buffer.next_hop = TOS_BCAST_ADDR;
    #endif
                status = SUCCESS;
                pS4Msg->type_data.hopcount++; 
                //set a random timer and forward it then
                if (!forward_delay_timer_pending) {
                  forward_delay = call Random.rand32() % delay_timer_jit + 1;
                  dbg(DBG_ROUTE,"FLOOD: timer with delay %d \n", forward_delay);\
                  call ForwardDelayTimer.startOneShot(forward_delay);
                  if (FALSE) {
                    status = LOG_ROUTE_BCAST_ERROR_TIMER_FAILED;
                    forwardRoutingBufferFree(&forward_buffer);
                  } else {
                    forward_delay_timer_pending = TRUE;
                    status = SUCCESS;
                  }
                } else {
                    status = LOG_ROUTE_BCAST_ERROR_TIMER_PENDING;
                    forwardRoutingBufferFree(&forward_buffer);
                }
            } else {
              //normal routing
    #ifdef CRROUTING
    #ifndef FAILURE_RECOVERY
              result = call Neighborhood.getNextHops(pS4Msg->type_data.dest_id, 
                              pS4Msg->type_data.closest_beacon, &forward_buffer.next_hop);
    #else
              result = call Neighborhood.FR_getNextHops(pS4Msg->type_data.dest_id, pS4Msg->type_data.closest_beacon, &forward_buffer.next_hop, &forward_buffer.cost_type, &forward_buffer.cost);
    #endif
              if (result == FAIL) {
    #endif
    
                status = LOG_ROUTE_FAIL_STUCK_0;
    
    #ifndef FAILURE_RECOVERY
                /*drop packet, NO_NEXT_HOPS. Release buffer, return next_receive*/
    
                dbg(DBG_ROUTE,"STUCK_0 failure\n");
    
                forwardRoutingBufferFree(&forward_buffer);
    #else
                /* modified by Feng Wang on Mar 15,
                 * suggested by Lili and Yun, forward to a 
                 * fake node (use the dest_id), so that
                 * failure recovery will take over later.
                 */
                forward_buffer.next_hop = pS4Msg->type_data.dest_id;
                //should still increment hopcount before forwarding!?
                pS4Msg->type_data.hopcount++;
                forwardMessage(&forward_buffer);
    #endif
    
              } else {
                /*At least one next hop, start the trial process */
                status = SUCCESS;
                pS4Msg->type_data.hopcount++;

		if ( call AMPacket.address() == pS4Msg->type_data.closest_beacon &&  pS4Msg->type_data.origin == call AMPacket.address()) {
		
		}
	        else {	         
                  forwardMessage(&forward_buffer);
                }
              } //else there is at least one next hop
            } //broadcast?
          } //else fwd_busy
        } //else msg is for us
        
        
        return next_receive;
      }
    
    
      event void ForwardDelayTimer.fired() {
        dbg(DBG_ROUTE,"FLOOD: timer fired , will forward\n");
        forward_delay_timer_pending = FALSE;
        forwardMessage(&forward_buffer);
        return ;
      }
    
    /********************************************************************************/
    
      command void* S4Send.getBuffer(message_t* msg, uint16_t* length) {
        S4AppMsg* pS4Msg = (S4AppMsg*)(msg->data);

        if (length != NULL)
          *length = TOSH_DATA_LENGTH - (offsetof(S4AppMsg,type_data) + offsetof(S4AppData,data));
        return (&pS4Msg->type_data.data);
      }
     
    
    
      event error_t Locator.statusChanged() {
        coords_valid = (call Locator.getCoordinates(&my_coords) == SUCCESS);
        
        return SUCCESS;
      }
    
      /* Functions that implement the simple duplicate suppresion cache.
       * The cache has no expiration, and replacement is strictly of the
       * oldest entry */
    
      uint32_t getMsgUid(uint16_t origin, uint16_t id) {
        uint32_t result = ((uint32_t)(origin) << 16) | (uint32_t)(id);
        //dbg(DBG_ROUTE,"getMsgUid: (o:%d, i:%d -> %d\n",origin,id,result);
        return result;
      }
    
      void duplicateCacheInit() {
        int i;
        for (i = 0; i < DUP_CACHE_SIZE; i++) {
          dup_cache[i].valid = FALSE;
        }
        dup_cache_index = 0;
      }
    
      /* returns position if found, DUP_CACHE_SIZE otherwise */
      uint8_t duplicateCacheGetIndex(uint32_t key) {
        int i,pos;
        pos = DUP_CACHE_SIZE;
        for (i = 0; i < DUP_CACHE_SIZE && pos == DUP_CACHE_SIZE; i++) {
          if (dup_cache[i].valid && dup_cache[i].key == key) {
            pos = i;
          }
        }
        return pos;
      }
    
      /* removes entry from the cache if it is in the cache */
      void duplicateCacheRemove(uint32_t key) {
        int i;
    
        if (!DUP_CACHE_ENABLED)
          return;
    
        i = duplicateCacheGetIndex(key);
        if (i < DUP_CACHE_SIZE) {
          dbg(DBG_USR2,"duplicateCacheRemove: %d was in cache, pos %d, removing\n",key,i);
          dup_cache[i].valid = FALSE;
        } else {
          dbg(DBG_USR2,"duplicateCacheRemove: %d was not in cache!\n");
        }
      }
    
      /* Returns true if the key is found in the cache 
       * In this case we should ignore the packet
       */
      //bool duplicateCacheFind(uint32_t key, uint16_t dist) {
      bool duplicateCacheFind(uint32_t key) {
        int i;
        bool isDuplicate = FALSE;
    
        if (!DUP_CACHE_ENABLED)
          return FALSE;
    
        i = duplicateCacheGetIndex(key);
        if (i < DUP_CACHE_SIZE) {
          //dbg(DBG_ROUTE,"duplicateCacheFind: %d in cache (pos: %d)\n",key, i);
          isDuplicate = TRUE;
        }
        return isDuplicate;
      }
    
      //void duplicateCacheUpdate(uint32_t key, uint16_t dist) {
      void duplicateCacheUpdate(uint32_t key) {
        int i;
    
        if (!DUP_CACHE_ENABLED)
          return;
    
        i = duplicateCacheGetIndex(key);
        if (i < DUP_CACHE_SIZE) {
          //update
          //dup_cache[i].min_dist = dist;
        } else {
          //insert
          dup_cache[dup_cache_index].valid = TRUE;
          dup_cache[dup_cache_index].key = key;
          //dup_cache[dup_cache_index].min_dist = dist;
          //dbg(DBG_ROUTE, " duplicateCacheUpdate key %d, index %d\n",
          //      key, dup_cache_index);
          dup_cache_index = (dup_cache_index + 1) % DUP_CACHE_SIZE;
        }
      }
    
    
    #ifdef FAILURE_RECOVERY 
      event error_t FRReqAMSend.sendDone(message_t* msg, error_t result) {
        call FRWaitReplyTimer.start(TIMER_ONE_SHOT,fr_timer);
        return SUCCESS;
      }
    
      event message_t* FRReqReceive.receive(message_t* rcvMsg) {
        uint16_t recover_dest;
        uint8_t recover_closest_beacon;
        uint16_t failed_nexthop,new_nexthop;
        uint8_t req_costtype, req_cost;
        uint8_t priority;
        error_t result;
        FRReqMsg* pFRMsg = (FRReqMsg*) &rcvMsg->data[0];
        FRReqMsgData* pFRMsgData = (FRReqMsgData*) &pFRMsg->type_data;
        if (rcvMsg->addr != TOS_BCAST_ADDR &&
            rcvMsg->addr != call AMPacket.address()) {  //should always be BCAST, but anyway...
          return rcvMsg;
        }
    
        if (reply_busy) {
    
          dbg(DBG_ROUTE,"reply_busy\n");
    
          return rcvMsg;
        }
    
        //reply_requester = pFRMsgData->requester_id;
        reply_requester = pFRMsg->header.last_hop;
        recover_dest = pFRMsgData->dest_id;
        recover_closest_beacon = pFRMsgData->closest_beacon;
        failed_nexthop = pFRMsgData->cur_next_hop;
        req_costtype = pFRMsgData->cost_type;
        req_cost = pFRMsgData->cost;
    
        dbg(DBG_ROUTE,"received a FRReq from %d (%d failed)\n",reply_requester,failed_nexthop);
    
        result = call Neighborhood.FR_getNextHops(recover_dest, recover_closest_beacon, &new_nexthop, &reply_costtype, &reply_cost);
        if (result == FAIL || new_nexthop == INVALID_NODE_ID ||  new_nexthop == reply_requester) {
          //I cannot recover
          dbg(DBG_ROUTE,"invalid next hop\n");
          return rcvMsg;
        } else {
          //now before replying, check the quality of the link
          uint8_t neighbor;
          bool quality;
          uint16_t delay = call Random.rand() % FR_CW;
          //uint16_t delay = call Random.rand() % (I_WAIT_FR>>1);
          if (call LinkEstimator.find(new_nexthop, &neighbor) != SUCCESS) {
            dbg(DBG_ROUTE,"not in linkTable\n");
            return rcvMsg;
          }
          if (call LinkEstimator.goodBidirectionalQuality(neighbor, &quality) != SUCCESS) {
            quality = FALSE;
          }
          if (!quality) {
            //link to the new_nexthop is bad, shouldn't use it
            dbg(DBG_ROUTE,"low quality (%d) link to my nexthop %d\n",quality,new_nexthop);
            return rcvMsg;
          }
    
          dbg(DBG_ROUTE,"salvaging link quality: %d\n",quality);
    
          /* Now I can reply.
           * start a timer to send a FRRep msg back.
           * first determine the priority (1~4) based on cost_type and cost,
           * then set the timer based on priority
           */
          reply_busy = TRUE;
    
          if (req_costtype == 1) {
            //dest is within local cluster of requester
            if (reply_costtype == 1) {
              if (reply_cost <= req_cost - 1)
                priority = 0;
              else if (reply_cost == req_cost)
                priority = 1;
              else priority = 2;
            } else priority = 3;
          } else {
            if (reply_costtype == 1)
              priority = 0;
            else {
              if (reply_cost <= req_cost - 1)
                priority = 1;
              else if (reply_cost == req_cost)
                priority = 2;
              else priority = 3;
            }
          }
          call FRSendReplyTimer.start(TIMER_ONE_SHOT,delay+priority*(FR_CW>>1));
          //call FRSendReplyTimer.start(TIMER_ONE_SHOT,delay);
          return rcvMsg;
        }
      }
    
      event error_t FRSendReplyTimer.fired() {
        FRRepMsg* pFRMsg = (FRRepMsg*) &fr_repmsg.data[0];
        FRRepMsgData* pFRMsgData = (FRRepMsgData*) &pFRMsg->type_data;
    
        pFRMsgData->requester_id = reply_requester;
        pFRMsgData->replier_id = call AMPacket.address();
        pFRMsgData->cost_type = reply_costtype;
        pFRMsgData->cost = reply_cost;
    
        dbg(DBG_ROUTE,"sending a FRRep for request from %d\n",reply_requester);
    
        //call FRRepAMSend.send(reply_requester,(uint8_t)sizeof(FRRepMsg),&fr_repmsg);
        //broadcast so that other potential replier can hear it
        call FRRepAMSend.send(TOS_BCAST_ADDR,(uint8_t)sizeof(FRRepMsg),&fr_repmsg);
        return SUCCESS;
      }
    
      event error_t FRRepAMSend.sendDone(message_t* msg, error_t result) {
        reply_busy = FALSE;
        return SUCCESS;
      }
    
      event message_t* FRRepReceive.receive(message_t* rcvMsg) {
        FRRepMsg* pFRMsg = (FRRepMsg*) &rcvMsg->data[0];
        FRRepMsgData* pFRMsgData = (FRRepMsgData*) &pFRMsg->type_data;
        S4AppMsg* pS4Msg;
    
        forwardRoutingBuffer * fb;
    
        if (msg_in_recovery == NULL) {
          //nothing to recover
          return rcvMsg;
        }
    
        pS4Msg = (S4AppMsg*)msg_in_recovery->data;
        if (msg_in_recovery == forward_buffer.msg) {
          fb = &forward_buffer;
        } else if (msg_in_recovery == send_buffer.msg) {
          fb = &send_buffer;
        } else {
          //call Logger.LogRouteReport(LOG_ROUTE_BUFFER_ERROR,pS4Msg->type_data.msg_id,pS4Msg->type_data.origin,pS4Msg->type_data.dest_id,pS4Msg->type_data.hopcount-1,pS4Msg->type_data.closest_beacon,pS4Msg->type_data.rexmit_count,pS4Msg->type_data.tried_hopcount);
          return rcvMsg;
        }
    
        if (rcvMsg->addr != TOS_BCAST_ADDR &&
            rcvMsg->addr != call AMPacket.address()) {  //should always be BCAST, but anyway...
          return rcvMsg;
        }
        if (pFRMsg->header.last_hop == call AMPacket.address()) {
          //should not happen
          return rcvMsg;
        }
    
        //process reply msg
    
        if (pFRMsgData->requester_id == call AMPacket.address()) {
    
          /* don't bother to check quality here again,
           * since the replier has already made sure the
           * bidirectional link quality is good.
           * NOTE: there is an asymmetry in bi-di quality measurement!!!
           * should we check one more time?
           */
    #if 0
          uint8_t neighbor;
          bool quality;
          if (call LinkEstimator.find(pFRMsgData->replier_id, &neighbor) != SUCCESS) {
            //dbg(DBG_ROUTE,"not in linkTable\n");
            return rcvMsg;
          }
          if (call LinkEstimator.goodBidirectionalQuality(neighbor, &quality) != SUCCESS) {
            quality = FALSE;
          }
          if (!quality) {
            //link to the replier is bad, shouldn't use it
            //dbg(DBG_ROUTE,"low quality (%d) link to replier %d\n",quality,pFRMsgData->replier_id);
            return rcvMsg;
          }
    #endif
          //I: if I'm the requester, then compare with current best reply, accept or reject it
          if (salvaging_nexthop == INVALID_NODE_ID || 
              salvaging_costtype < pFRMsgData->cost_type ||
              (salvaging_costtype == pFRMsgData->cost_type && salvaging_cost > pFRMsgData->cost)) {
            salvaging_nexthop = pFRMsgData->replier_id;
            salvaging_costtype = pFRMsgData->cost_type;
            salvaging_cost = pFRMsgData->cost;
    
            dbg(DBG_ROUTE,"received a FRRep from %d (requester %d)\n",pFRMsg->header.last_hop,pFRMsgData->requester_id);
    
    #if 0
            //dbg(DBG_ROUTE,"accept salvaging link with quality: %d\n",quality);
    #endif
    
            /* added by Feng Wang on Mar 15,
             * for opportunistic failure recovery,
             * always choose the first replier
             */
            call FRWaitReplyTimer.stop();
            dbg(DBG_ROUTE,"recover through %d\n",salvaging_nexthop);
            fb->next_hop = salvaging_nexthop;
            pS4Msg->type_data.tried_hopcount++; //added by Feng Wang on 09/22
            forwardMessage(fb);
            msg_in_recovery = NULL;
            salvaging_nexthop = INVALID_NODE_ID;
            return rcvMsg;
    
          }
        } else {
          //II: if I'm not the requester, then compare with my reply, stop my timer if it's better
          if (reply_costtype < pFRMsgData->cost_type ||
              (reply_costtype == pFRMsgData->cost_type && reply_cost >= pFRMsgData->cost)) {
            call FRSendReplyTimer.stop();
            reply_busy = FALSE;
          } else {
            //dbg(DBG_ROUTE,"but my reply is better\n");
          }
        }
    
        return rcvMsg;
      }
    
      event error_t FRWaitReplyTimer.fired() {
        forwardRoutingBuffer * fb;
        S4AppMsg* pS4Msg;
        uint8_t status;
    
        pS4Msg = (S4AppMsg*)msg_in_recovery->data;
        if (msg_in_recovery == forward_buffer.msg) {
          fb = &forward_buffer;
        } else if (msg_in_recovery == send_buffer.msg) {
          fb = &send_buffer;
        } else {
          //call Logger.LogRouteReport(LOG_ROUTE_BUFFER_ERROR,pS4Msg->type_data.msg_id,pS4Msg->type_data.origin,pS4Msg->type_data.dest_id,pS4Msg->type_data.hopcount-1,pS4Msg->type_data.closest_beacon,pS4Msg->type_data.rexmit_count,pS4Msg->type_data.tried_hopcount);
          return SUCCESS; //no difference for return value of Timer.fired()
        }
        //TODO: salvage the msg_in_recovery using new_nexthop if any
        if (salvaging_nexthop == INVALID_NODE_ID) {
          //recovery failed
          //take same action as route failure w/o trying to recover
    
          dbg(DBG_ROUTE,"recovery failed\n");
    
          forwardRoutingBufferFree(fb);
          if (msg_in_recovery->addr == TOS_BCAST_ADDR) {
            status = LOG_ROUTE_STATUS_BCAST_FAIL;
          } else {
            status = LOG_ROUTE_FAIL_STUCK;
          }
          //call Logger.LogRouteReport(status,pS4Msg->type_data.msg_id,pS4Msg->type_data.origin,pS4Msg->type_data.dest_id,pS4Msg->type_data.hopcount-1,pS4Msg->type_data.closest_beacon,pS4Msg->type_data.rexmit_count,pS4Msg->type_data.tried_hopcount);
          if (fb == &send_buffer) 
            signal S4Send.sendDone(msg_in_recovery,FAIL);
          msg_in_recovery = NULL;
          return SUCCESS;
        }
    
        dbg(DBG_ROUTE,"recover through %d\n",salvaging_nexthop);
    
        fb->next_hop = salvaging_nexthop;
        pS4Msg->type_data.tried_hopcount++; //added by Feng Wang on 09/22
        forwardMessage(fb);
        msg_in_recovery = NULL;
        salvaging_nexthop = INVALID_NODE_ID;
        return SUCCESS;
      }
    
      event error_t LinkEstimator.canEvict(uint16_t addr) {
        return SUCCESS;
      }
    
        command void set_fr_timer(uint16_t t) {
            fr_timer = t;
        }
        command error_t get_fr_timer(uint16_t *t){
            *t = fr_timer;
            return SUCCESS;
        }
    #endif
    
    //end of implementation
#ifdef SERIAL_LOGGING    
      event void SerialAMControl.startDone(error_t err) {      
          if (err!=SUCCESS) {
            call SerialAMControl.start();
          }
          else {
            call PeriodicTimer.startPeriodic(60000);
          }
    
      }
    
      event void SerialAMControl.stopDone(error_t err) {
    
      }
    
      event void SerialAMSend.sendDone(message_t* bufPtr, error_t error) {
        if (bufPtr == &loggingPacket)
          serialPortLocked = FALSE;
      }
    
      event void BeaconsAMSend.sendDone(message_t* bufPtr, error_t error) {
          if (bufPtr == &loggingPacket)
            serialPortLocked = FALSE;
      }
#endif
      
      event void PeriodicTimer.fired() {
          if (call Locator.getCoordinates(&my_coords) == SUCCESS) {          
          }
          else {          
          }          
      }
    
}
      
