#include "Bcp.h"
#include "Timer.h"

module BcpForwardingEngineP{
  provides {
    interface Init;
    interface StdControl;
    interface Send;
    interface Receive;
    interface Packet;
    interface CollectionPacket;
    interface BcpPacket;
    interface Get<uint16_t> as getBackpressure;
  }
  uses{
    interface AMSend as SubSend;
    interface Receive as SubReceive;
    interface Receive as SubSnoop;
    interface Packet as SubPacket;
    interface PacketAcknowledgements as DataPacketAcknowledgements;    

    // For radio checksum
    interface CC2420PacketBody;
    
    // These interfaces are used for inactive forwarding engine beacon broadcasts
    interface AMSend as BeaconSend;
    interface Receive as BeaconReceive;

    interface RootControl;
    interface Pool<fe_queue_entry_t> as QEntryPool;
    interface Pool<message_t> as MessagePool;
    interface Stack<fe_queue_entry_t*> as SendStack;
    interface Pool<message_t> as SnoopPool;
    interface Queue<message_t*> as SnoopQueue;
    interface Timer<TMilli> as BeaconTimer;
    interface BcpRouterForwarderIF as RouterForwarderIF;
    interface AMPacket as AMDataPacket;   

    interface Timer<TMilli> as txRetryTimer;
    
    interface SplitControl as RadioControl;
    interface Timer<TMilli> as DelayPacketTimer;
    interface BcpDebugIF;
  }
}
implementation{

  // Pre-declare for use
  void forwarderActivity();

  /* We suppress duplicate packets (caused by loss of
   *  an ack message) using this routing-table-like
   *  structure.
   */
  uint8_t latestForwardedTableActive;
  latestForwarded_table_entry latestForwardedTable[ROUTING_TABLE_SIZE];
  
  /* seqno stamps each outgoing bcp packet header with it's
   *  sequence number automatically.
   */
  uint8_t seqno;
  uint8_t nullSeqNo;

  /* Used to transmit beacon messages during periods when the
   *  forwarder is turned off.
   */
  message_t beaconMsgBuffer;
  bcp_beacon_header_t * beaconHdr;
  
  /* beaconSending informs the beacon timer that we are already
   *  in the process of broadcasting a beacon.  Upon successful
   *  beaconSend.sendDone(), we set back to FALSE;
   */
  bool beaconSending = FALSE;
  
  /* Keeps track of whether the routing layer is running; if not,
   * it will not send packets. */
  bool running = FALSE;
  
  /* Keeps track of whether the packet on the head of the queue
   * is being used, and control access to the data-link layer.*/
  bool sending = FALSE;
  
  /* Keeps track of whether the radio is on; no sense sending packets
   * if the radio is off. */
  bool radioOn = FALSE;

  /* Used to track total transmission count by the local node */
  uint16_t localTXCount = 0;  

  /* The routing engine stipulated next-hop address */
  am_addr_t nextHopAddress_m;
  uint16_t  nextHopBackpressure_m;
 
  /* Initialized to TOS_NODE_ID, but set temporarily by the BcpRoutingEngine
   *  each time it recognizes a good link temporarily exists from a neighbor.
   */
  am_addr_t notifyBurstyLinkNeighbor_m;
 
  /* The loopback message is for when a collection roots calls
     Send.send. Since Send passes a pointer but Receive allows
     buffer swaps, the forwarder copies the sent packet into 
     the loopbackMsgPtr and performs a buffer swap with it.
     See sendTask(). */
  message_t loopbackMsg;
  message_t* ONE_NOK loopbackMsgPtr;

  /* The sendQe is used to store the current packet being
   *  attempted at transmission.  This is necessary when
   *  stacks are being used - as subsequent arrivals
   *  may cause the stack to change - bad mojo!
   */
  fe_queue_entry_t* sendQe;
  bool sendQeOccupied = FALSE;

  /* The virtual queue preserves backpressure values through
   *  stack drop events.  This preserves performance of
   *  BCP.  If a forwarding event occurs while the data stack
   *  is empty, a null packet is generated from this virtual
   *  queue backlog.
   */
  uint16_t virtualQueueSize;

  /* These counters track failed and successful CRC counts
     for debugging purposes. */
  uint16_t dataCRCSuccessCount;
  uint16_t dataCRCFailCount;
  uint16_t snoopCRCSuccessCount;
  uint16_t snoopCRCFailCount;

  bcp_data_header_t* getHeader(message_t* m) {
    return (bcp_data_header_t*)call SubPacket.getPayload(m, sizeof(bcp_data_header_t));
  }

  uint32_t calcHdrChecksum( message_t* msg )
  {
    uint32_t checksum = 0;
    bcp_data_header_t* hdr;
 
    hdr = getHeader( msg );

    // This is a hop-by-hop checksum of the control header fields. 
    checksum += hdr->bcpDelay;
    checksum += hdr->bcpBackpressure;
    checksum += hdr->txCount;
    checksum += hdr->origin;
    checksum += hdr->hopCount;
    checksum += hdr->originSeqNo;
    checksum += hdr->pktType;

    return checksum;
  }

  void conditionalFQDiscard()
  {
    fe_queue_entry_t* discardQe;
    if( call SendStack.size() == call SendStack.maxSize() ) {
      discardQe = call SendStack.popBottom(); 
      if( call MessagePool.put(discardQe->msg) != SUCCESS ){ 
        call BcpDebugIF.reportError(0x59); 
        dbg("ERROR","%s memory leak, MessagePool.put() error.", __FUNCTION__);
      }
      if (call QEntryPool.put(discardQe) != SUCCESS) {
        call BcpDebugIF.reportError( 0x39 );
        dbg("ERROR","%s memory leak, QEntryPool.put() error.", __FUNCTION__);
      }
#ifdef VIRTQ 
      // Dropped a data packet, increase virtual queue size
      virtualQueueSize++;
#endif
    }
  }

  void latestForwardedTableInit() 
  {
    latestForwardedTableActive = 0;
  }
  
  /* Returns the latestForwarded_table_entry pointer to the latestForwardedTable
   *  entry representing the neighbor node address passed as a parameter. If
   *  no such neighbor exists, returns NULL.
   */
  latestForwarded_table_entry* latestForwardedTableFind(am_addr_t neighbor_p) {
      uint8_t i;
      if (neighbor_p == TOS_BCAST_ADDR)
          return NULL;
      for (i = 0; i < latestForwardedTableActive; i++) {
          if (latestForwardedTable[i].neighbor == neighbor_p)
              break;
      }

      if( i == latestForwardedTableActive )
        return NULL;

      return &(latestForwardedTable[i]);
  }
  
  error_t latestForwardedTableUpdate(am_addr_t from_p, am_addr_t origin_p,
                                          uint8_t originSeqNo_p, uint8_t hopCount_p)
  {
    latestForwarded_table_entry * latestForwardedEntry;

    latestForwardedEntry = latestForwardedTableFind(from_p);
    if (latestForwardedEntry == NULL && 
        latestForwardedTableActive == ROUTING_TABLE_SIZE) 
    {
      // Not found and table is full
      dbg("ERROR", "%s: latestForwardedTable full, can't insert new neighbor.\n", __FUNCTION__);
      call BcpDebugIF.reportError( 0x38);
      return FAIL;
    }
    else if (latestForwardedEntry == NULL) {
      //not found and there is space
      atomic {
        latestForwardedTable[latestForwardedTableActive].neighbor = from_p;
        latestForwardedTable[latestForwardedTableActive].origin = origin_p;              
        latestForwardedTable[latestForwardedTableActive].originSeqNo = originSeqNo_p;              
        latestForwardedTable[latestForwardedTableActive].hopCount = hopCount_p;
        latestForwardedTableActive++;
      }
      dbg("Duplicate", "%s: OK, new latestForwarded idx %d neighbor %hhu <%hhu,%d,%d>.\n", __FUNCTION__, latestForwardedTableActive-1, from_p, origin_p, originSeqNo_p, hopCount_p);
    } else {
      //found, just update
      atomic {
        latestForwardedEntry->origin = origin_p;
        latestForwardedEntry->originSeqNo = originSeqNo_p;
        latestForwardedEntry->hopCount = hopCount_p;
      }
      dbg("Duplicate", "%s OK, updated entry neighbor %hhu <%hhu,%d,%d>.\n", __FUNCTION__, from_p, origin_p, originSeqNo_p, hopCount_p);
    }
    return SUCCESS;
  }  
  
  /* Generate a beacon message, fill it with backpressure information
   *  and broadcast it.  Other overhearing nodes will update their backpressure
   *  information for this node.  There will bo no packet data in the broadcast.
   */
  task void sendBeaconTask() {
    error_t eval;
    
    // Store the local backpressure level to the backpressure field
    beaconHdr->bcpBackpressure = call SendStack.size() + sendQeOccupied + virtualQueueSize;
   
    eval = call BeaconSend.send(AM_BROADCAST_ADDR,
                                &beaconMsgBuffer, 
                                sizeof(bcp_beacon_header_t));
    if (eval == SUCCESS){
      dbg("Beacon","%s: successfully called BeaconSend.send()\n", __FUNCTION__);
    } 
    else if (eval == EOFF) 
    {
      radioOn = FALSE;
      dbg("Beacon","%s running: %d radioOn: %d\n", __FUNCTION__, running, radioOn);
      post sendBeaconTask();
    } else {
      post sendBeaconTask();
    }
  }

  /*
   * The snoopHandler does all routing processing after receiving a
   * snoop message.  This allows the return statement in the snoop
   * receive interface to immediately supply the radio with a new
   * buffer, hopefully reducing the rate at which packets are corrupted
   * or lost by the radio.
   */

  task void snoopHandlerTask() {
    am_addr_t proximalSrc;
    bcp_data_header_t * snoopPacket;
    message_t* msg;

    if( call SnoopQueue.empty() )
    { return; }

    msg = call SnoopQueue.head();

    proximalSrc = call AMDataPacket.source(msg);
    
    snoopPacket = getHeader(msg);

    // I'm going to disable checksum checking of
    //  snooped packets, I think this is less critical

    // Update the backlog information in the router
    call RouterForwarderIF.updateNeighborSnoop(call SendStack.size() + sendQeOccupied + virtualQueueSize,
                                               snoopPacket->bcpBackpressure, 
                                               snoopPacket->nhBackpressure, 
                                               snoopPacket->nodeTxCount,
                                               proximalSrc, 
                                               snoopPacket->burstNotifyAddr);

    // Free up the resources
    call SnoopQueue.dequeue();
    if( call MessagePool.put(msg) != SUCCESS )
    { call BcpDebugIF.reportError(0x59); }
  }

  /*
   * These is where all of the send logic is. When the ForwardingEngine
   * wants to send a packet, it posts this task. The send logic is
   * independent of whether it is a forwarded packet or a packet from
   * a send client.
   *
   * The task first checks that there is a packet to send and that
   * there is at least one neighbor. If the node is a collection
   * root, it signals Receive with the loopback message. Otherwise,
   * it sets the packet to be acknowledged and sends it. It does not
   * remove the packet from the send queue: while sending, the 
   * packet being sent is at the head of the queue; a packet is dequeued
   * in the sendDone handler, either due to retransmission failure
   * or to a successful send.
   */

  task void sendDataTask() {
    fe_queue_entry_t* qe;
    fe_queue_entry_t* nullQe;
    message_t* nullMsg;
    bcp_data_header_t* nullHdr;
    error_t subsendResult;
    error_t retVal;
    uint8_t payloadLen;
    am_addr_t dest;
    bcp_data_header_t* hdr;
    uint32_t sendTime;
    uint16_t checksum = 0;

    // Specialty handling of loopback or sudden sink designation
    if( call RootControl.isRoot() ){
      sending = FALSE; // If we are sending we'll abort
      if( sendQeOccupied == TRUE ){
        qe = sendQe;
        sendQeOccupied = FALSE; // Guaranteed succcessful service
      } else {
        if( call SendStack.empty() && virtualQueueSize == 0){
          // This shouldn't be possible! Panic! Sky is falling!
          call BcpDebugIF.reportError( 0x4a );
          return;
        }
        qe = sendQe = call SendStack.popTop();
      }

      memcpy(loopbackMsgPtr, qe->msg, sizeof(message_t));
      retVal = call MessagePool.put( qe->msg );
      if( retVal != SUCCESS ){call BcpDebugIF.reportError( 0xbb );}
      retVal = call QEntryPool.put( qe );
      if( retVal != SUCCESS ){call BcpDebugIF.reportError( 0xbc );}

      loopbackMsgPtr = signal Receive.receive(loopbackMsgPtr,
                              call Packet.getPayload(loopbackMsgPtr, call Packet.payloadLength(loopbackMsgPtr)), 
                              call Packet.payloadLength(loopbackMsgPtr));

      // Maybe do it again, if we are sink and there are data packets!
      forwarderActivity();
      return;
    }

    if( sendQeOccupied == TRUE )
    {
      qe = sendQe;
    } else {
      if( call SendStack.empty() && virtualQueueSize == 0)
      {
        // This shouldn't be possible! Panic! Sky is falling!
        call BcpDebugIF.reportError( 0x40 );
        return;
      }

      // Check to see whether there exists a neighbor to route to with positive weight.
      retVal = call RouterForwarderIF.updateRouting( call SendStack.size() + sendQeOccupied + virtualQueueSize );
      if( retVal == FAIL )
      {
        // No neighbor is a good option right now, wait on a recompute-time
        sending = FALSE;
        call txRetryTimer.startOneShot( REROUTE_TIME );
        return;
      }

      if( call SendStack.empty() )
      {
        // Create a null packet, place it on the stack (must be here by virtue of a virtual backlog)
        call BcpDebugIF.reportValues( 0,0,0,0,call QEntryPool.size(),call MessagePool.size(), 0, 0xda );

        nullQe = call QEntryPool.get();
        if ( nullQe == NULL) {
          dbg("ERROR","%s client cannot enqueue, QEntryPool.get() error.", __FUNCTION__);
          call BcpDebugIF.reportError( 0x6b );
          return;
        }

        nullMsg = call MessagePool.get();
        if (nullMsg == NULL) {
          dbg("ERROR","%s cannot forward, MessagePool.get() error.", __FUNCTION__);
          call BcpDebugIF.reportError( 0x6c );
          // To avoid a memory leak, free the QEntryPool
          if (call QEntryPool.put(nullQe) != SUCCESS){
            dbg("ERROR","%s memory leak, QEntryPool.put() error.", __FUNCTION__);        
            call BcpDebugIF.reportError( 0x6d );
          }
          return;
        }

        nullHdr = getHeader( nullMsg );
        nullHdr->hopCount = 0;
        nullHdr->origin = TOS_NODE_ID;
        nullHdr->originSeqNo  = nullSeqNo++;
        nullHdr->bcpDelay = 0;
        nullHdr->txCount = 0;
        nullHdr->pktType = PKT_NULL;

        nullQe->arrivalTime = call DelayPacketTimer.getNow();
        nullQe->firstTxTime = 0;
        nullQe->bcpArrivalDelay = 0;
        nullQe->msg = nullMsg;
        nullQe->source = LOCAL_SEND;
        nullQe->txCount = 0;

        retVal = call SendStack.pushTop( nullQe ); 
        if( retVal != SUCCESS )
          call BcpDebugIF.reportError( 0x47 );

        virtualQueueSize--;
      }


      qe = sendQe = call SendStack.popTop();
      qe->firstTxTime = call txRetryTimer.getNow();
      sendQeOccupied = TRUE;
    }

    payloadLen = call SubPacket.payloadLength(qe->msg);

    // Give up on a link after MAX_RETX_ATTEMPTS retransmit attempts, link is lousy!
    // Furthermore, penalize by double MAX_RETX_ATTEMPTS, due to cutoff.
    if( qe->txCount >= MAX_RETX_ATTEMPTS )
    {
      call RouterForwarderIF.updateLinkSuccess(call AMDataPacket.destination(qe->msg), 2*MAX_RETX_ATTEMPTS);
      call BcpDebugIF.reportValues( 0,0,0,0,0,MAX_RETX_ATTEMPTS, call AMDataPacket.destination(qe->msg),0x77 );
      qe->txCount = 0;

      // Place back on the Stack, discard element if necesary
      conditionalFQDiscard();
      retVal = call SendStack.pushTop( qe );
      if( retVal != SUCCESS )
        call BcpDebugIF.reportError( 0x48 );

      sendQeOccupied = FALSE;

      // Try again after a REROUTE_TIME, this choice was bad. 
      sending = FALSE;
      call txRetryTimer.startOneShot( REROUTE_TIME );
      return;
    }

    qe->txCount++;
    localTXCount++;

    dest            = nextHopAddress_m;

    // Request an ack, not going to support DL without ack (for now)     
    call DataPacketAcknowledgements.requestAck(qe->msg);

    // Store the local backpressure level to the backpressure field
    hdr = getHeader(qe->msg);
    hdr->bcpBackpressure = call SendStack.size() + sendQeOccupied + virtualQueueSize; 
    // Fill in the next hop Backpressure value
    hdr->nhBackpressure = nextHopBackpressure_m;
    // Fill in the node tx count field (burst success detection by neighbors
    hdr->nodeTxCount = localTXCount;
    // Fill in the burstNotifyAddr, then reset to TOS_NODE_ID immediately
    hdr->burstNotifyAddr = notifyBurstyLinkNeighbor_m;
    notifyBurstyLinkNeighbor_m = TOS_NODE_ID;
    
    // Update the txCount field
    hdr->txCount++;

    sendTime = call DelayPacketTimer.getNow();

    // regardless of transmission history, lastTxTime and BcpDelay are re-comptued.
    hdr->bcpDelay   = qe->bcpArrivalDelay + ( sendTime - qe->arrivalTime ) + PER_HOP_MAC_DLY;

    // Calculate the checksum!
    checksum = calcHdrChecksum( qe->msg );
    hdr->hdrChecksum = checksum;

    subsendResult = call SubSend.send(dest, qe->msg, payloadLen);
    if (subsendResult == SUCCESS) {
      // Successfully submitted to the data-link layer.
      dbg("Forwarder", "%s: subsend succeeded with %p.\n", __FUNCTION__, qe->msg);
      return;
    }
    else if (subsendResult == EOFF) {
      // The radio has been turned off underneath us. Assume that
      // this is for the best. When the radio is turned back on, we'll
      // handle a startDone event and resume sending.
      radioOn = FALSE;
      dbg("Forwarder", "%s: subsend failed from EOFF.\n", __FUNCTION__);
      call BcpDebugIF.reportError( 0x32 );
    }
    else if (subsendResult == EBUSY) {
      // This shouldn't happen, as we sit on top of a client and
      // control our own output; it means we're trying to
      // double-send (bug). This means we expect a sendDone, so just
      // wait for that: when the sendDone comes in, // we'll try
      // sending this packet again.   
      dbg("Forwarder", "%s: subsend failed from EBUSY.\n", __FUNCTION__);
      call BcpDebugIF.reportError( 0x33 );
      // Try again? Not sure why this is happening to me.  SendDone never responds after this error!
      post sendDataTask();
    }
    else if (subsendResult == ESIZE) {
      dbg("Forwarder", "%s: subsend failed from ESIZE: truncate packet.\n", __FUNCTION__);
      call Packet.setPayloadLength(qe->msg, call Packet.maxPayloadLength());
      call BcpDebugIF.reportError( 0x34 );
    }
  } 

  /* Whenever a forwarding decision is to be made [idle, beacon, or data packet]
   *  the forwarderActivity() function decides.
   */
  void forwarderActivity()
  {
    if( !running )
    {
      //When the forwarder not initialized, do nothing
      return;
    }
    else if( call RootControl.isRoot() )
    {
      // As soon as we are root, should have zero virtual queue
      virtualQueueSize = 0;

      // The root should always be beaconing
      if(!call BeaconTimer.isRunning()){
        // If this is the start of the beacon, be agressive! Beacon fast
        //  so neighbors can re-direct rapidly.
        call BeaconTimer.startOneShot( FAST_BEACON_TIME );
      }

      // If there are packets sitting in the forwarding queue, get them to the reciever
      if( !call SendStack.empty() ){
        // Don't need sending set to true here? Not using radio?
        post sendDataTask();
      }

      return;
    }
    else if (sending ) {
      dbg("Forwarder", "%s: already sending, exit\n", __FUNCTION__);
      return;
    }
    else if (!( call SendStack.empty() ) || virtualQueueSize > 0 || sendQeOccupied )
    {
      // Stop Beacon, not needed if we are sending data packets (snoop)
      call BeaconTimer.stop();

      // Start sending a data packet
      sending = TRUE;
      post sendDataTask();

      return;
    }
    else
    {
      // Nothing to do but start the beacon!
      call BeaconTimer.startPeriodic(BEACON_TIME);
    }
  }

  /*
   * Function for preparing a packet for forwarding. Performs
   * a buffer swap from the message pool. If there are no free
   * message in the pool, it returns the passed message and does not
   * put it on the send queue.
   */
  message_t* ONE forward(message_t* ONE m, uint32_t arrivalTime_p) {
    message_t* newMsg;
    fe_queue_entry_t *qe;
    bcp_data_header_t *hdr;
    error_t retVal;

    // In the event of either LIFO type, if arrival finds a full LIFO
    //  discard the oldest element.
    conditionalFQDiscard();
      
    if (call MessagePool.empty()) {
      dbg("WARNING", "%s cannot forward, message pool empty.\n", __FUNCTION__);
      call BcpDebugIF.reportError( 0x70 );
      return m;
    }
    else if (call QEntryPool.empty()) {
      dbg("WARNING", "%s cannot forward, queue entry pool empty.\n", 
          __FUNCTION__);
      call BcpDebugIF.reportError( 0x71 );
      return m;
    }

    qe = call QEntryPool.get();
    if (qe == NULL) {
      dbg("ERROR","%s cannot forward, QEntryPool.get() error.", __FUNCTION__);
      call BcpDebugIF.reportError( 0x72 );
      return m;
    }

    newMsg = call MessagePool.get();
    if (newMsg == NULL) {
      dbg("ERROR","%s cannot forward, MessagePool.get() error.", __FUNCTION__);
      call BcpDebugIF.reportError( 0x73 );
      // To avoid a memory leak, free the QEntryPool
      if (call QEntryPool.put(qe) != SUCCESS){
        call BcpDebugIF.reportError( 0x74 );
        dbg("ERROR","%s memory leak, QEntryPool.put() error.", __FUNCTION__);
      }
      return m;
    }

    memset(newMsg, 0, sizeof(message_t));
    memset(m->metadata, 0, sizeof(message_metadata_t));
    
    hdr = getHeader(m);
    
    qe->msg = m;
    qe->source = FORWARD;
    qe->arrivalTime = arrivalTime_p;
    qe->txCount = 0;
    qe->firstTxTime = 0;
    qe->bcpArrivalDelay = hdr->bcpDelay;
     
#ifdef LIFO
    retVal = call SendStack.pushTop(qe);
#endif

#ifndef LIFO
    retVal = call SendStack.pushBottom(qe);
#endif

    if (retVal == SUCCESS) {
      call BcpDebugIF.reportBackpressure( call SendStack.size() + sendQeOccupied, call SendStack.size() + sendQeOccupied + virtualQueueSize, localTXCount, hdr->origin, hdr->originSeqNo, 3 );
      dbg("Forwarder", "%s forwarding packet %p with queue size %hhu\n", __FUNCTION__, m, call SendStack.size());

      forwarderActivity();
 
      // Successful function exit point:
      return newMsg;
    } else {
      call BcpDebugIF.reportError( 0x49 );
      // There was a problem enqueuing to the send queue.
      //  Free the allocated MessagePool and QEntryPool
      if (call MessagePool.put(newMsg) != SUCCESS){
        call BcpDebugIF.reportError( 0x75 );
        dbg("ERROR","%s Memory leak, MessagePool.put() error.", __FUNCTION__);
      }
      if (call QEntryPool.put(qe) != SUCCESS){
        call BcpDebugIF.reportError( 0x76 );
        dbg("ERROR","%s memory leak, QEntryPool.put() error.", __FUNCTION__);
      }
    }
  

    dbg("ERROR","%s cannot forward, resource acquisition problem.", __FUNCTION__);
    return m;
  }
  
  command error_t StdControl.start()
  {
    running = TRUE;

    // Start beaconing - we'll need this anyway =)
    call BeaconTimer.startPeriodic(BEACON_TIME);
    
    return SUCCESS;    
  }
  
  command error_t StdControl.stop()
  {
    running = FALSE;
    
    // Stop Beacons
    call BeaconTimer.stop();
    
    return SUCCESS;
  }
  
  command error_t Init.init()
  {
    // Initialization code
    beaconSending = FALSE;
    running = FALSE;
    sending = FALSE;
    radioOn = FALSE;
    seqno = 0;
    nullSeqNo = 0;
    latestForwardedTableInit();
    beaconHdr = call BeaconSend.getPayload(&beaconMsgBuffer, call BeaconSend.maxPayloadLength());
    dataCRCSuccessCount = 0;
    dataCRCFailCount = 0;
    snoopCRCSuccessCount = 0;
    snoopCRCFailCount = 0;
    sendQeOccupied = FALSE;
    virtualQueueSize = 0;
    localTXCount = 0;
    loopbackMsgPtr = &loopbackMsg;
    notifyBurstyLinkNeighbor_m = TOS_NODE_ID;
    return SUCCESS;
  }
  
  command error_t Send.send(message_t* msg, uint8_t len)
  {
    // Send code for client send request    
    bcp_data_header_t* hdr;
    uint32_t arrivalTime = call DelayPacketTimer.getNow();
    error_t retVal;
    
    dbg("Forwarder", "%s: sending packet: %x, len %hhu\n", __FUNCTION__, msg, len);
    if (!running) {return EOFF;}
    if (len > call Send.maxPayloadLength()) {return ESIZE;}
    
    call Packet.setPayloadLength(msg, len);
    hdr = getHeader(msg);
    hdr->hopCount = 0;
    hdr->origin = TOS_NODE_ID;
    hdr->originSeqNo  = seqno++;
    hdr->bcpDelay = 0;
    hdr->txCount = 0;
    hdr->pktType = PKT_NORMAL;

    // If needed, discard an element from the forwarding queue
    conditionalFQDiscard();
   
    if (call MessagePool.empty()) {
      dbg("Forwarder", "%s client cannot enqueue, message pool empty.\n", __FUNCTION__);
      call BcpDebugIF.reportError( 0x5d );
      return EBUSY;
    }
    else if (call QEntryPool.empty()) {
      dbg("Forwarder", "%s client cannot enqueue, queue entry pool empty.\n", 
          __FUNCTION__);
      call BcpDebugIF.reportError( 0x5f );
      return EBUSY;
    }
    else {
      message_t* newMsg;
      fe_queue_entry_t *qe;
      
      qe = call QEntryPool.get();
      if (qe == NULL) {
        dbg("ERROR","%s client cannot enqueue, QEntryPool.get() error.", __FUNCTION__);
        call BcpDebugIF.reportError( 0x5b );
        return FAIL;
      }

      newMsg = call MessagePool.get();
      if (newMsg == NULL) {
        dbg("ERROR","%s client cannot enqueue, MessagePool.get() error.", __FUNCTION__);
        
        // Free the QEntryPool
        if (call QEntryPool.put(qe) != SUCCESS){
          call BcpDebugIF.reportError( 0x5c );
          dbg("ERROR","%s memory leak, QEntryPool.put() error.", __FUNCTION__);
        }
        
        call BcpDebugIF.reportError( 0x5d );
        return FAIL;
      }

      memset(newMsg, 0, sizeof(message_t));
      memset(msg->metadata, 0, sizeof(message_metadata_t));
      
      // Copy the message, client may send more messages.
      memcpy(newMsg, msg, sizeof(message_t));
      
      qe->msg = newMsg;
      qe->source = LOCAL_SEND;
      qe->arrivalTime = arrivalTime;
      qe->txCount = 0;
      qe->firstTxTime = 0;
      qe->bcpArrivalDelay = 0;
      
      
#ifdef LIFO
    retVal = call SendStack.pushTop(qe);
#endif

#ifndef LIFO
    retVal = call SendStack.pushBottom(qe);
#endif

      if (retVal == SUCCESS) {
        call BcpDebugIF.reportBackpressure( call SendStack.size() + sendQeOccupied, call SendStack.size() + sendQeOccupied + virtualQueueSize, localTXCount, hdr->origin, hdr->originSeqNo, 2 );
        dbg("Forwarder", "%s client queued packet %p with queue size %hhu\n", __FUNCTION__, msg, call SendStack.size());

        forwarderActivity();

        signal Send.sendDone(msg, SUCCESS);
        
        // Successful function exit point:
        return SUCCESS;
      } else {
        call BcpDebugIF.reportError( 0x4a );
        // There was a problem enqueuing to the send queue.
        if (call MessagePool.put(newMsg) != SUCCESS) {
          dbg("ERROR","%s memory leak, MessagePool.put() error.", __FUNCTION__);
          call BcpDebugIF.reportError( 0x5c );
        }
        if (call QEntryPool.put(qe) != SUCCESS){
          dbg("ERROR","%s memory leak, QEntryPool.put() error.", __FUNCTION__);
          call BcpDebugIF.reportError( 0x5d );
        }
      }
    }

    // NB: at this point, we have a resource acquistion problem.
    // Log the event, and drop the
    // packet on the floor.

    dbg("ERROR","%s client cannot send, resource acquisition problem.", __FUNCTION__);
    call BcpDebugIF.reportError( 0x4b );

    return FAIL;
  }
  
  command error_t Send.cancel(message_t* msg)
  {
    // Always fail a Send.concel. Like e-mail, can't rectract it! ;)  	
    return FAIL;
  }
  
  command uint8_t Send.maxPayloadLength()
  {
    return call Packet.maxPayloadLength();
  }
  
  command void* Send.getPayload(message_t* msg, uint8_t len)
  {
    return call Packet.getPayload(msg, len);
  }
  
  event message_t* SubReceive.receive(message_t* msg, void* payload, uint8_t len)
  {
    am_addr_t from;
    bcp_data_header_t * rcvPacket;
    uint32_t checksum = 0;
    latestForwarded_table_entry * latestForwardedEntry;
    uint32_t arrivalTime = call DelayPacketTimer.getNow();
    
    /*
     * A packet arrived destined to this AM_ADDR.  Handle bcpBackpressure update to
     *  the routing engine.  If we are the root, signal the receive event.  Otherwise
     *  we place the packet into the forwarding queue.
     */ 

    if (len > call SubSend.maxPayloadLength()) {
      dbg("ERROR","%s: len > maxPayloadLength()!\n", __FUNCTION__);
      call BcpDebugIF.reportError( 0x50 ); // sendDone called and qe == NULL or qe->msg != msg
      return msg;
    }
    
    // Grab the backpressure value and send it to the router
    from = call AMDataPacket.source(msg);
    
    rcvPacket = (bcp_data_header_t*)payload;
    
    // Calculate the checksum!
    checksum = calcHdrChecksum( msg );
    // Verify checksum!
    if( checksum != rcvPacket->hdrChecksum )
    {
      // Packet header failed checksum!
      // I'm going to continue forwarding it, but disregard the control
      // information.
      dataCRCFailCount++;
      call BcpDebugIF.reportValues( snoopCRCFailCount, snoopCRCSuccessCount,dataCRCFailCount, dataCRCSuccessCount,0,0,0,0x90 );
      // We cannot afford to forward corrupted messages, they can lead to bad behaviors
      return msg;
    } else {
      dataCRCSuccessCount++; 

      // Grab the latestForwardedEntry for this neighbor
      latestForwardedEntry = latestForwardedTableFind( from );
    
      if( latestForwardedEntry == NULL )
      {
        // Update the latestForwardedTable, this neighbor is unknown
        latestForwardedTableUpdate( from, rcvPacket->origin, 
                                    rcvPacket->originSeqNo, rcvPacket->hopCount);
      }
      else if( latestForwardedEntry->origin == rcvPacket->origin &&
          latestForwardedEntry->originSeqNo == rcvPacket->originSeqNo &&
          latestForwardedEntry->hopCount    == rcvPacket->hopCount )
      {
        /**
         * Duplicate suppresion
         *  We will store the last source / packetid / hop count receive per neighbor
         *  and reject any new arrival from that neighbor with identical parameters.
         *  This allows packets with identical source / packetid to be forwarded 
         *  through a node multiple times - necessary in a dynamic routing scenario.
         */
        dbg("Duplicates", "%s: detected a duplicate data packet, discarding silently <%hhu,%u,%u>.\n", __FUNCTION__,
             rcvPacket->origin, rcvPacket->originSeqNo, rcvPacket->hopCount);
        call BcpDebugIF.reportValues( 0,0,0,0,0,0,0,0x83 );
        return msg;
      }
      else
      {
        // Update the latestForwardedTable
        latestForwardedTableUpdate( from, rcvPacket->origin, 
                                    rcvPacket->originSeqNo, rcvPacket->hopCount);
      }
    
      // Update the backpressure information in the router
      call RouterForwarderIF.updateNeighborBackpressure(from, rcvPacket->bcpBackpressure);
    }

    // Retrieve the hopCount, increment it in the header
    rcvPacket->hopCount++;
 
    // If I'm the root, signal receive. 
    if (call RootControl.isRoot())
      return signal Receive.receive(msg, 
                           call Packet.getPayload(msg, call Packet.payloadLength(msg)), 
                           call Packet.payloadLength(msg));
    else {
      dbg("Forwarder", "Forwarding packet from %hu.\n", getHeader(msg)->origin);
      return forward(msg, arrivalTime);
    }    
    return msg;
  }

  command void Packet.clear(message_t* msg) {
    call SubPacket.clear(msg);
  }
  
  command uint8_t Packet.payloadLength(message_t* msg) {
    return call SubPacket.payloadLength(msg) - (uint8_t)sizeof(bcp_data_header_t);
  }

  command void Packet.setPayloadLength(message_t* msg, uint8_t len) {
    call SubPacket.setPayloadLength(msg, len + (uint8_t)sizeof(bcp_data_header_t));
  }
  
  command uint8_t Packet.maxPayloadLength() {
    return call SubPacket.maxPayloadLength() - (uint8_t)sizeof(bcp_data_header_t);
  }

  command void* Packet.getPayload(message_t* msg, uint8_t len) {
    uint8_t* payload = call SubPacket.getPayload(msg, len + (uint8_t)sizeof(bcp_data_header_t));
    if (payload != NULL) {
      payload = payload + (uint8_t)sizeof(bcp_data_header_t);
    }
    return payload;
  }
  
  /*
   * The second phase of a send operation; based on whether the transmission was
   * successful, the ForwardingEngine either stops sending or starts the
   * RetxmitTimer with an interval based on what has occured. If the send was
   * successful or the maximum number of retransmissions has been reached, then
   * the ForwardingEngine dequeues the current packet. If the packet is from a
   * client it signals Send.sendDone(); if it is a forwarded packet it returns
   * the packet and queue entry to their respective pools.
   * 
   */  
  event void SubSend.sendDone(message_t* msg, error_t error) {
    uint16_t txTimeMS = 0;
    uint32_t nowTime = 0;
    fe_queue_entry_t *qe = sendQe;
    bcp_data_header_t * sentPacket;

    dbg("Forwarder", "%s: to %hu and %hhu\n", __FUNCTION__, call AMDataPacket.destination(msg), error);
    if (qe == NULL || qe->msg != msg) {
      dbg("ERROR", "%s: BUG: not our packet (%p != %p)!\n", __FUNCTION__, msg, qe->msg);
      call BcpDebugIF.reportError( 0x30 ); // sendDone called and qe == NULL or qe->msg != msg
      return;
    }
    
    sentPacket = getHeader(msg);
    
    if (error != SUCCESS) {
      // CTP fears that "Immediate retransmission is the worst thing to do."
      //  I'm doing it anyway, simplicity is king for now.  I don't want to be
      //  having to justify all these constant parameter selections in a paper later.
      dbg("Forwarder", "%s: send failed, retrying immediately.\n", __FUNCTION__);
      post sendDataTask();
//      call BcpDebugIF.reportValues(sentPacket->originSeqNo,sentPacket->hopCount,sentPacket->txCount,0,0,sentPacket->origin,
//                                   call AMDataPacket.destination(msg),0x51);
    }
    else if (!call DataPacketAcknowledgements.wasAcked(msg)) {
      call RouterForwarderIF.txNoAck( call AMDataPacket.destination(msg) );
      dbg("Forwarder", "%s: not acked, re-posting sendTask.\n", __FUNCTION__);
      post sendDataTask();
//      call BcpDebugIF.reportValues(sentPacket->originSeqNo,sentPacket->hopCount,sentPacket->txCount,0,0,sentPacket->origin,
//                                   call AMDataPacket.destination(msg),0x52);
    }
    else {
      // A successfully sent packet
      dbg("Forwarder", "%s: successfully forwarded packet (client: %hhu), message pool is %hhu/%hhu, SendStack is %hhu/%hhu.\n", 
           __FUNCTION__, qe->source, call MessagePool.size(), 
           call MessagePool.maxSize(), call SendStack.size(), call SendStack.maxSize());
      
      // Link rate estimation
      nowTime = call DelayPacketTimer.getNow();
      if(nowTime - qe->firstTxTime > 0xFFFF)
        txTimeMS = 0xFFFF;
      else
        txTimeMS = (uint16_t)(nowTime - qe->firstTxTime);

      call RouterForwarderIF.updateLinkSuccess(call AMDataPacket.destination(msg), qe->txCount);
      call RouterForwarderIF.updateLinkRate(call AMDataPacket.destination(qe->msg), txTimeMS);
      
      if (call MessagePool.put(qe->msg) != SUCCESS)
      {
        call BcpDebugIF.reportError( 0x37 );
        dbg("ERROR", "%s: Memory leak, failed MessagePool.put().\n", __FUNCTION__);
      }
      if (call QEntryPool.put(qe) != SUCCESS)
      {
        call BcpDebugIF.reportError( 0x41 );
        dbg("ERROR", "%s: Memory leak, failed QEntryPool.put().\n", __FUNCTION__);
      }

      // Only if successful do we set sending to FALSE;
      sendQeOccupied = FALSE;
      sending = FALSE;

      call BcpDebugIF.reportBackpressure( call SendStack.size() + sendQeOccupied, call SendStack.size() + sendQeOccupied + virtualQueueSize, localTXCount, getHeader(msg)->origin, getHeader(msg)->originSeqNo, 1 );

      forwarderActivity(); 
    }
  }
  
  event void BeaconTimer.fired()
  {
    dbg("Beacon","%s: BeaconTimer fired! Posting sendBeaconTask\n", __FUNCTION__);
    //call BcpDebugIF.reportValues( 0,0,0,0,0,0,0,0xbe );
    // If this was a quick Beacon triggered by a new sink designation, slow down and
    //  begin a periodic beacon now.
    if( call BeaconTimer.isOneShot() ){
        call BeaconTimer.startPeriodic(BEACON_TIME);
    }

    atomic if( beaconSending == FALSE)
    {
      beaconSending = TRUE;
    } else { return; }
    post sendBeaconTask();
  }
 
  event void txRetryTimer.fired()
  {
    if( sending == FALSE )
    {
      sending = TRUE;
      post sendDataTask();
    }
  } 
 
  command collection_id_t CollectionPacket.getType(message_t* msg) {return 0;} // Not used here
  command am_addr_t       CollectionPacket.getOrigin(message_t* msg) {return (am_addr_t)getHeader(msg)->origin;}
  command uint8_t         CollectionPacket.getSequenceNumber(message_t* msg) {return (uint8_t)getHeader(msg)->originSeqNo;}
  command void CollectionPacket.setType(message_t* msg, collection_id_t id) {return;}
  command void            CollectionPacket.setOrigin(message_t* msg, am_addr_t addr) {getHeader(msg)->origin = addr;}
  command void            CollectionPacket.setSequenceNumber(message_t* msg, uint8_t _seqno) {getHeader(msg)->originSeqNo = _seqno;}
  
  command uint8_t       BcpPacket.getType(message_t* msg) {return 0;}
  command am_addr_t     BcpPacket.getOrigin(message_t* msg) {return (am_addr_t)getHeader(msg)->origin;}
  command uint8_t       BcpPacket.getSequenceNumber(message_t* msg) {return (uint8_t)getHeader(msg)->originSeqNo;}
  command void          BcpPacket.setType(message_t* msg, uint8_t id) {return;}
  command void          BcpPacket.setOrigin(message_t* msg, am_addr_t addr) {getHeader(msg)->origin = addr;}
  command void          BcpPacket.setSequenceNumber(message_t* msg, uint8_t _seqno) {getHeader(msg)->originSeqNo = _seqno;}
  command uint32_t      BcpPacket.getDelay(message_t* msg) {return getHeader(msg)->bcpDelay;}
  command uint16_t      BcpPacket.getTxCount(message_t* msg){return getHeader(msg)->txCount;}
  command uint16_t      BcpPacket.getBackpressure(message_t* msg) {return getHeader(msg)->bcpBackpressure;}
  command uint16_t      BcpPacket.getNhBackpressure(message_t* msg) {return getHeader(msg)->nhBackpressure;}
  command uint8_t       BcpPacket.getHopCount(message_t* msg) {return getHeader(msg)->hopCount;}
  command uint8_t       BcpPacket.getBCPPktType(message_t* msg) {return getHeader(msg)->pktType;}
  command uint8_t       BcpPacket.getNodeTxCount(message_t* msg) {return getHeader(msg)->nodeTxCount;}

  event void RouterForwarderIF.setNextHopAddress(am_addr_t nextHopAddress_p, uint16_t nextHopBackpressure_p){
    nextHopAddress_m = nextHopAddress_p;
    nextHopBackpressure_m = nextHopBackpressure_p;
  }

  event void RouterForwarderIF.setNotifyBurstyLinkNeighbor(am_addr_t neighbor_p){
    notifyBurstyLinkNeighbor_m = neighbor_p;
  }  
  
  event void BeaconSend.sendDone(message_t* msg, error_t error)
  {
    if( (message_t *)msg != &beaconMsgBuffer)
    {
      dbg("Beacon", "%s: Yikes! BeaconSend.sendDone received a message pointer not its own!\n", __FUNCTION__);
      call BcpDebugIF.reportError( 0x83 );
    }    
    else
    {
      dbg("Beacon", "%s: BeaconSend.sendDone() called successfully.\n", __FUNCTION__);
      beaconSending = FALSE;
    }
  }
  
  event message_t* BeaconReceive.receive(message_t* msg, void* payload, uint8_t len)
  {
    am_addr_t from;
    bcp_beacon_header_t * rcvBeacon;
    
    /* We need to error-check the beacon message, then parse it
     *  to inform the routing engine of new neighbor backlogs.
     */
    if (len != sizeof(bcp_beacon_header_t)) 
    {
      dbg("Beacon", "%s, received beacon of size %hhu, expected %i\n",
                     __FUNCTION__, 
                     len,
                     (int)sizeof(bcp_beacon_header_t));
              
      return msg;
    }
    
    from = call AMDataPacket.source(msg);
    
    rcvBeacon = (bcp_beacon_header_t*)payload;
    
    dbg("Beacon","%s: Received a beacon from neighbor %hhu, backpressure %u\n",__FUNCTION__, from, rcvBeacon->bcpBackpressure);
    //call BcpDebugIF.reportValues( rcvBeacon->bcpBackpressure,0,0,0,0,0,from,0xbf ); 
    // Update the backlog information in the router
    call RouterForwarderIF.updateNeighborBackpressure(from, rcvBeacon->bcpBackpressure);
    
    return msg;
  }
  
  /* ForwardingEngine keeps track of whether the underlying
     radio is powered on. If not, it enqueues packets;
     when it turns on, it then starts sending packets. */ 
  event void RadioControl.startDone(error_t err) {
    if (err == SUCCESS) {
      radioOn = TRUE;
      forwarderActivity();
    }
  }
  
  event void RadioControl.stopDone(error_t err) {
    if (err == SUCCESS) {
      radioOn = FALSE;
    }
  }
  
  /**
   * Snooping in on a non-broadcast, non-local-destined packet.
   *   We will update the routing table with backpressure info
   *   from the new header.
   *
   * Also, look for bursts of successfully overheard packets,
   *  If we overhear 3 sequential we'll notify the neighbor
   *  that the link is temporarily good (STLE).
   */
  event message_t* SubSnoop.receive(message_t* msg, void *payload, uint8_t len) 
  {  
    message_t* newMsg;
    if (len > call SubSend.maxPayloadLength()) {
      dbg("ERROR","%s: snoop len > maxPayloadLength()!\n", __FUNCTION__);
      call BcpDebugIF.reportError( 0x36 );
      return msg;
    }    

    /* In an effort to avoid radio-blocking of incomming messages, we are going to
       use a message queue for snoop messages (for now shared with forwarder) */
    if( call SnoopQueue.size() == call SnoopQueue.maxSize() )
    {
      // No more room, SnoopQueue is full! Drop this message
      return msg;
    }
    else if ( call MessagePool.empty() )
    {
      // No more pool space, have to drop this message
      return msg;
    }

    newMsg = call MessagePool.get();
    if( newMsg == NULL )
    {
      // Failed to get new message pool, not sure
      //  why, abort this snoop packet
      call BcpDebugIF.reportError( 0xdb );
      return msg;
    }

    if( call SnoopQueue.enqueue( msg ) != SUCCESS )
    {
      // Epic fail, dunno why
      call MessagePool.put(newMsg);
      call BcpDebugIF.reportError( 0x57 );
      return msg;
    }

    post snoopHandlerTask(); 

    return newMsg;
  }  

  event void DelayPacketTimer.fired()
  {

  }  

  /**
   * Retrieves a value of type val_t.
   *
   * @return the value itself
   */
  command uint16_t getBackpressure.get()
  {
    return call SendStack.size() + sendQeOccupied + virtualQueueSize;
  }
}
