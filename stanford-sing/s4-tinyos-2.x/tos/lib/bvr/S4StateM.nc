

/* This module takes care of maintaining the S4 state
   This includes the beacon flooding, coordinate flooding
   It has both end points for AM messages of type AM_S4_BEACON_MSG
   Differently from previous versions, here there is no separate
   beacon flood: beacons just state that their coordinates are
   0 for themselves, and send the normal coordinate update. 
 ******************
 */

/* Comment on BEACON_ETX:
   BEACON_ETX defines another way of comparing the parent trees, based on ETX.
   ETX is the expected number of transmissions along the path, counting the
retransmissions at each hop. If p_i is the prob. of success at hop i,

   ETX = sum{1/p_i}

   q_i is the bidirectional quality of link i, and 1/pi = 255/qi

   To get around precision and rounding problems we transmit in the packet a
transformed cumulative ETX. Since ETX is at least one, the number of hops is
included in ETX, and we do not use in the ETX transmission. We reuse the field
'quality' in the packet, with 8 bits, to mean e', defined recursively as:
  
   e_0' = 0
   e_i' = (int) [e_{i-1}' + k*(255/q_i - 1) | 255] ([|255] caps it at 255)

  To compare paths we return to ETX from e_i'. h_i is the number of hops
along the path in question:
 
  e_i = e_i'/k +  h_i
  
  If we change the field to 16 bits, then it may be better to use 1/etx scaled
to the full 16 bits as the transmitted number. 

*/

includes AM;
includes S4;
#ifdef FROZEN_COORDS
includes FrozenCoords;
#endif

#define DBG_ERROR "S4-error"
#define DBG_TEMP "S4-temp"
#define DBG_USR3 "S4-usr3"

includes topology;
includes nexthopinfo;
includes BVRCommand;


module S4StateM {
  provides {
    interface Init;
    interface StdControl;
    interface S4Neighborhood;
    interface S4Locator;
    interface S4StateCommand;
    interface FreezeThaw;
    
    interface RoutingTable;
    
  }
  uses {
    
    interface AMSend as S4StateAMSend;
    interface Receive as S4StateReceive;

    

    interface Leds;
    
    interface S4Topology;
    interface Init as S4TopologyInit;
    
    interface Timer<TMilli> as BeaconTimer;
    interface Timer<TMilli> as BeaconRetransmitTimer;
#ifdef FW_COORD_TABLE 
    interface CoordinateTable;
    interface StdControl as CoordinateTableControl;
    interface Init as CoordinateTableControlInit;
#endif

    interface LinkEstimator; 
    interface LinkEstimatorSynch;
    

    interface Random;
    interface AMPacket;
    
    
    #ifdef PLATFORM_MICA2 
    	interface CC1000Control;
    	interface Time;
    #endif
    

    interface Timer<TMilli> as BeaconUpdateTimer;
#ifdef CHECK_LINK
      interface Timer<TMilli> as CheckLinkTimer;
#endif
  
  #ifdef CRROUTING 

    interface AMSend as ClusterAMSend;
    interface Receive as ClusterReceive;
    interface Timer<TMilli> as ClusterTimer;
    interface Timer<TMilli> as ClusterRetransmitTimer;
  #ifdef LOCAL_DV
    interface Timer<TMilli> as ClusterUpdateTimer;
  #endif
  #endif
  
#ifdef TOSSIM
      interface Timer<TMilli> as BeaconDisplayTimer;
#endif
  }
}

implementation {

/******************* Declarations *******************************/ 




#ifdef BEACON_ETX
  enum {
    MAX_ETX = 255, 
    ETX_SCALE = 10, 
  };
#endif
#ifdef ETX_TOLERANCE
  enum {
    RESET_TOLERANCE = 128, //7 chances
  };
#define ETX_MD_FACTOR (2.0)
#endif

  uint32_t b_timer_int;
  uint32_t b_timer_jit;

  uint16_t delay_timer_jit;
  
  bool state_is_active;
  bool state_beaconing_coords;

  bool beacons_to_send;

  Coordinates my_coords;
  
  message_t beacon_buf;     //buffer to store beacons to be sent

  message_t rcv_beacon_buf; //local buff for buffer swapping for rcv'd beacons

  message_t* rcv_beacon_ptr;       //for rcv'd buffer swapping
  bool rcv_buffer_busy;
  
  S4BeaconMsg *beacon_msg_ptr;       //for casting
  S4BeaconMsgData *beacon_data_ptr; //for casting
  
  uint8_t beacon_msg_length; 
  bool beacon_send_busy;           //synchronize access to beacon_buf
  
  uint16_t beacon_seqno;
/* **/


/* Root Beacon info */
  S4RootBeacon rootBeacons[N_ROOT_BEACONS];
  CoordsParents my_coords_parents;
  
  bool state_is_root_beacon;
  uint8_t root_beacon_id;
  uint8_t root_beacon_seqno;

  bool initialized = FALSE; ////////////////////???????????????????




uint8_t beacon_send_retries = 0;

#ifdef MULTIPLE_BEACON

#if 0
  /* use an index to specify next beacon to send.
   * since we need to send all beacons, we
   * can pre-calculate how many total beacon vectors
   */
  uint16_t bv_index;  //# of beacon vectors that have been sent SUCCESSFULLY
  uint8_t total_bv;  //total # of beacon vectors needed for all beacons
#endif

  
#endif
  uint8_t next_beacon;  //next beacon to send


  uint8_t curr_bv_size;  //number of elements in current bv

  uint32_t update_int;  //interval to start UpdateTimer
#ifdef RELIABLE_BCAST
  uint32_t check_int;   //interval to check reliability
  PendingBeacons pending_beacons[MAX_PENDING_BEACON];
#endif

#ifdef CRROUTING
  bool first_global_beacon; //indicate whether it's the first global beacon received
#ifdef FLOOD_DV_ONCE
  bool clusterupdatetimer_started;
#endif

 

  uint8_t dv_send_retries = 0;

  //table for cluster members
  ClusterMember ClusterTable[MAX_CLUSTER_SIZE];
  uint16_t cluster_size;

  message_t cluster_buf;     //buffer to store cluster beacons to be sent
  message_t rcv_cluster_buf; //local for rcv'd cluster beacons
  message_t* rcv_cluster_ptr;       //for rcv'd cluster buffer swapping
  bool rcv_clusterbuffer_busy;

  uint8_t cluster_msg_length; 
  bool cluster_send_busy;           //synchronize access to cluster_buf
  uint8_t cluster_seqno;
#endif

#ifdef LOCAL_DV 
  DVMsg *cluster_msg_ptr;       //for casting
  DVMsgData *cluster_data_ptr; //for casting
  /* index of next_dv entry,
   * start checking from here
   */
  uint8_t next_dv;
  uint8_t curr_dv_size;  //number of elements in current dv

#ifdef RELIABLE_BCAST
  PendingDVs pending_dvs[MAX_PENDING_DV];
#endif

#endif

  uint8_t current_scope;
  uint8_t scope_age;

//added for testing largest scope
  uint8_t largest_scope;

  uint8_t beacon_round;
#ifdef LOCAL_DV
  uint8_t dv_round;
#endif

  uint16_t sent_bv;
  uint16_t sent_dv;
/////////////////////////////////

/******************** Prototypes ********************************/

static void init_beacon_msg();
static void set_beacon_msg();

static void init_my_coords();

static void rootBeaconInit(S4RootBeacon* b);

task void sendBeaconTask();



#ifdef CRROUTING
static void init_cluster_msg();
task void sendClusterTask();
#endif

static void set_beacon_update_msg();
static void set_dv_update_msg();
//////////////

  /******************** Init and Control *************************/  
  static void initialize() {
    int i;
    
    uint8_t original_root_beacon_id[N_NODES];
    
    call S4TopologyInit.init();
        
    call S4Topology.getRootBeaconIDs(original_root_beacon_id);


    b_timer_int = I_BEACON_INTERVAL *INTERVAL_MUL;
    b_timer_jit = I_BEACON_JITTER;
    
    beacons_to_send = 0;
  
    delay_timer_jit = I_DELAY_TIMER;

    beacon_send_busy = FALSE;
    rcv_buffer_busy = FALSE;

    state_beaconing_coords = TRUE;

    beacon_msg_length = sizeof(S4BeaconMsg);
    beacon_seqno = 1;
    rcv_beacon_ptr = &rcv_beacon_buf;
    
    
    state_is_root_beacon = 
       (original_root_beacon_id[call AMPacket.address()] == INVALID_BEACON_ID) ? FALSE : TRUE;
    root_beacon_id = original_root_beacon_id[call AMPacket.address()];
    
    dbg("S4-beacon", "original_root_beacon_id[call AMPacket.address()]=%d, state_is_root_beacon=%d\n", 
                      original_root_beacon_id[call AMPacket.address()], state_is_root_beacon);

    root_beacon_seqno = 1;


#ifdef MULTIPLE_BEACON
    next_beacon = 0;
#endif

    init_beacon_msg();
#ifdef FROZEN_COORDS

    //Load my coordinates
    coordinates_copy( &frozen_coords[call AMPacket.address()], &my_coords);
    
    for (i = 0; i < call S4Topology.getRootNodesCount(); i++) {
       //Load parent pointer
        my_coords_parents.parent[i]=frozen_coords_parents[call AMPacket.address()].parent[i];
    
        //Set RootBeacons Info
        rootBeacons[i].valid=1;
        rootBeacons[i].parent=my_coords_parents.parent[i];
        rootBeacons[i].last_seqno=1;
        rootBeacons[i].hops=my_coords.comps[i];
        rootBeacons[i].combined_quality=250;
    
}
#else
  for (i = 0; i<MAX_ROOT_BEACONS; i++)
    rootBeaconInit(&rootBeacons[i]);

  init_my_coords();
  
  
  #ifdef TOSSIM
  #ifdef SHOW_BEACONID
      for (i = 0; i<tos_state.num_nodes; i++) {
        if (original_root_beacon_id[i] != INVALID_BEACON_ID) {
          rootBeacons[original_root_beacon_id[i]].nodeid = i;
        }
      }
  #endif
  #endif
  
#endif

  


#ifdef MULTIPLE_BEACON
    next_beacon = 0;
#endif

    update_int = I_BEACON_UPDATE_INTERVAL;
#ifdef RELIABLE_BCAST
    check_int = I_BEACON_RELIABILITY_CHECK_INTERVAL;
    for (i=0; i<MAX_PENDING_BEACON; i++) {
      pending_beacons[i].occupied = FALSE;
      pending_beacons[i].retries = 0;
      pending_beacons[i].n_rcv = 0;
    }
#endif

#ifdef CRROUTING
    cluster_send_busy = FALSE;
    rcv_clusterbuffer_busy = FALSE;
    cluster_seqno = 1;
    rcv_cluster_ptr = &rcv_cluster_buf;
    init_cluster_msg();
    cluster_size = 0;
    for (i=0; i<MAX_CLUSTER_SIZE; i++)
      ClusterTable[i].valid = 0;
    first_global_beacon = TRUE;
#ifdef FLOOD_DV_ONCE
    clusterupdatetimer_started = FALSE;
#endif
#endif


#ifdef LOCAL_DV
    cluster_msg_length = sizeof(DVMsg);
    next_dv = 0;
    curr_dv_size = 0;

    //insert a dumy entry for myself,
    //so that set_cluster_msg() doesn't need to take special care
    //of including myself in the dv msgs
    ClusterTable[0].valid = 1;
    ClusterTable[0].dest = call AMPacket.address();
    ClusterTable[0].parent = INVALID_NODE_ID; //no parent to myself
    ClusterTable[0].hops = 0; //always 0 hops to myself
    //the scope will be determined at the beginning of each new round
    ClusterTable[0].scope = INVALID_COMPONENT;
    ClusterTable[0].updated = 1;
#ifdef RELIABLE_BCAST
    ClusterTable[0].bcastlost = 0;
#endif
    cluster_size++;

#ifdef RELIABLE_BCAST
    for (i=0; i<MAX_PENDING_DV; i++) {
      pending_dvs[i].occupied = FALSE;
      pending_dvs[i].retries = 0;
      pending_dvs[i].n_rcv = 0;
    }
#endif

#endif
      
    largest_scope = 0;
    current_scope = INVALID_COMPONENT;
    scope_age = 0;

    beacon_round = 0;
#ifdef LOCAL_DV
    dv_round = 0;
#endif

    sent_bv = 0;
    sent_dv = 0;

      
  }
  
  inline bool hasLowerHash(uint16_t val1, uint16_t val2) {
    if ( (val1 % 10) == (val2 % 10) ) {
      return val1 < val2;
    }
  
    return (val1 % 10) < (val2 % 10);
  }
  
  
  
  
  void displayRootBeacons() {
#ifdef TOSSIM
    
    int i;
    for (i = 0; i < MAX_BEACON_VECTOR_SIZE; i++) {
      dbg("S4-beacon", "BeaconDisplayTimer: hopcount=%d, i=%d, nodeid=%d, parent=%d, valid=%d, time=%s\n", rootBeacons[i].hops,
          i, rootBeacons[i].nodeid, rootBeacons[i].parent,
          rootBeacons[i].valid, sim_time_string()
          );		  		                		    
    }
#endif
  }
  
#ifdef TOSSIM
  event void BeaconDisplayTimer.fired() {
    displayRootBeacons();
  }
#endif
  
  
  command error_t Init.init() {   
    error_t ok = FALSE;
    state_is_active = TRUE;
        
    initialize();      
    
    dbg("S4-debug","sizeof MAX_ROOT_BEACONS:%d Coords:%d AppMsg:%d S4Msg:%d S4CommandMsg:%d LoggingMsg:%d message_t:%d\n",
      MAX_ROOT_BEACONS, sizeof(Coordinates), sizeof(S4AppMsg), sizeof(S4BeaconMsg), sizeof(S4CommandMsg), sizeof(S4LogMsgWrapper), sizeof(message_t));
    dbg("S4-debug","sizeof TOSH_DATA_LENGTH:%d app_data_length:%d ReverseLinkMsg:%d\n",
      TOSH_DATA_LENGTH, TOSH_DATA_LENGTH - (offsetof(S4AppMsg,type_data) + offsetof(S4AppData,data)), sizeof(ReverseLinkMsg));
    
    call CoordinateTableControlInit.init();
    
    dbg("S4-debug", "ending S4StateM.Init.init\n");
    
    initialized = TRUE;
    return SUCCESS;
  }
  
  command error_t StdControl.start() {  
  
    if (!initialized) {
      state_is_active = TRUE;
      initialize();
      dbg("S4-debug","sizeof MAX_ROOT_BEACONS:%d Coords:%d AppMsg:%d S4Msg:%d S4CommandMsg:%d LoggingMsg:%d message_t:%d\n",
        MAX_ROOT_BEACONS, sizeof(Coordinates), sizeof(S4AppMsg), sizeof(S4BeaconMsg), sizeof(S4CommandMsg), sizeof(S4LogMsgWrapper), sizeof(message_t));
      dbg("S4-debug","sizeof TOSH_DATA_LENGTH:%d app_data_length:%d ReverseLinkMsg:%d\n",
        TOSH_DATA_LENGTH, TOSH_DATA_LENGTH - (offsetof(S4AppMsg,type_data) + offsetof(S4AppData,data)), sizeof(ReverseLinkMsg));
      
      call CoordinateTableControlInit.init();
      initialized = TRUE;
    }
    
    dbg("S4-debug", "S4StateM.start next_beacon=%d\n", next_beacon);
    
    dbg("S4-debug","This is S4StateM starting!\n");
    call CoordinateTableControl.start();
    
    if (state_beaconing_coords) {
      dbg("S4-debug","Starting BeaconTimer with period %d\n", b_timer_int);
      call BeaconTimer.startOneShot(b_timer_int);
    }
    
#ifdef SEND_UPDATE_ONLY
        //start the first UpdateTimer after the first BeaconTimer
#ifndef FLOOD_BEACON_ONCE
        call BeaconUpdateTimer.start(TIMER_ONE_SHOT,I_BEACON_START+update_int);
#else
        call BeaconUpdateTimer.start(TIMER_ONE_SHOT,I_BEACON_START+100000+update_int);
#endif
#endif
    
    return SUCCESS;
  }
  
  command error_t StdControl.stop() {
  
    call CoordinateTableControl.stop();
    return SUCCESS;
  }


  command error_t FreezeThaw.freeze() {
    state_is_active = FALSE;
    call BeaconTimer.stop();
    return SUCCESS;
  }
  
  command error_t FreezeThaw.thaw() {
    
    state_is_active = TRUE;
    if (state_beaconing_coords) {
      dbg("S4-debug","Starting BeaconTimer\n");
      call BeaconTimer.startOneShot( b_timer_int);
    }
    return SUCCESS;
  }
  /****************** Internal Functions **************************/

   static uint8_t combine_quality(uint8_t q1, uint8_t q2) {

   
    return (q1+q2)>>1;
  }

  static uint8_t combine_root_quality(uint8_t q1, uint8_t q2) {
    uint8_t result;

    
    result = (uint8_t) (((q1/255.0)*(q2/255.0))*255); 
    dbg("S4-debug","combine_root_quality: q1:%d, q2:%d, combined: %d\n",q1,q2,result);
    return result;
  }

#ifdef BEACON_ETX
  inline uint8_t scaledEtxFromQuality(uint8_t quality) {
    uint16_t etx;
    if (quality == 0 ) 
      return MAX_ETX;
    etx = (uint16_t)((255.0/quality - 1)*ETX_SCALE + 0.5);
    dbg("S4-debug","scaled received quality %d, returning etx %d\n",quality,etx);
    etx = (etx > MAX_ETX)?MAX_ETX:etx;
    return (uint8_t)etx;
  }
#endif
  
  /**For suppressing repeated multihop messages*/
  static  bool is_within_range(uint8_t _new, uint8_t old) {
    uint8_t range = (uint8_t) MSG_VALID_RANGE8;
    if (((uint8_t)(old + range)) < old) {
      return (_new > old || _new < ((uint8_t)(old + range)));
    } else {
      return (_new > old && _new < ((uint8_t)(old + range)));
    }
  }

  
  
  
  static  bool is_greater_by_2(uint8_t _new, uint8_t old) {
      uint8_t range = (uint8_t) MSG_VALID_RANGE8;
      uint8_t old1 = (uint8_t)(old + SEQNO_DISTANCE);
      if (((uint8_t)(old1 + range)) < old1) {
        return (_new > old1 || _new < ((uint8_t)(old1 + range)));
      } else {
        return (_new > old1 && _new < ((uint8_t)(old1 + range)));
      }
    }
    static  bool is_within_2(uint8_t _new, uint8_t old) {
      uint8_t range = (uint8_t) MSG_VALID_RANGE8;
      bool t1,t2;
      uint8_t old1 = (uint8_t)(old + SEQNO_DISTANCE);
      if (((uint8_t)(old + range)) < old) {
        t1 = (_new > old || _new < ((uint8_t)(old + range)));
      } else {
        t1 = (_new > old && _new < ((uint8_t)(old + range)));
      }
      if (((uint8_t)(old1 + range)) < old1) {
        t2 = (_new <= old1 && _new >= ((uint8_t)(old1 + range)));
      } else {
        t2 = (_new <= old1 || _new >= ((uint8_t)(old1 + range)));
      }
      return (t1 && t2);
    }
  
  
  
  
  
  static  uint8_t quality_with_retransmissions(uint8_t quality, uint8_t k) {
  
  #ifdef RETEX_QUALITY 
    float qi,qf;
    uint8_t q;
    int i;
    qi = ((255 - quality)/255.0);
    qf = qi;
    for (i = 1; i < k; i++) {
      qf = qf*qi;
    }
    
    q = (uint8_t)(255*( 1.0 - qf ));
    dbg("S4-debug","quality_with_restransmissions(%d): %d -> %d\n", k, quality, q);
    return q;
    #else
    return quality;
    #endif
  }
 

  /* Determine the minimum quality that has to be achieved to be
   * better than quality with the given threshold.
   * Relative, and threshold is treated as a fraction of 255! */
   uint8_t apply_threshold(uint8_t quality, uint8_t threshold) {
    uint8_t increase, difference, result;
    increase = (uint8_t) (1.0*quality * threshold/255.0);
    difference = 255 - quality;
    if (difference < increase)
      result = 255;
    else
      result = quality + increase;
    dbg("S4-debug","COORDS: apply_threshold: (quality %d, threshold %d) -> %d\n",
      quality, threshold, result);
    return result;
  }

 
  /* 
   * Nothing in particular to do currently
   */
  static void init_beacon_msg() {
    beacon_msg_ptr = (S4BeaconMsg*) &beacon_buf.data[0];
    beacon_data_ptr = (S4BeaconMsgData*) &beacon_msg_ptr->type_data;
    return ;
  }

  /* 
   * Sets the beacon message with the coordinates from rootBeacons
   * and increments the sequence number
   * Note that the beacon sequence number is not incremented here
   */      
  static void set_beacon_msg() {
    int i;
    S4RootBeacon* b;
    uint8_t b_parent_ld;
    uint8_t quality_first,combined_quality = 0;
#ifdef BEACON_ETX
    uint8_t combined_etx; /* this is e_i' */
    uint8_t etx_first;    /* this is the scaled etx to the first node */
#endif


#ifdef MULTIPLE_BEACON  
    uint8_t counter=0; 

#ifndef SAME_SEQNO

    beacon_data_ptr->seqno=beacon_seqno-1;
#else
    beacon_data_ptr->seqno=beacon_seqno;

#endif
#else
  
  beacon_data_ptr->seqno = beacon_seqno++;
#endif



    for (i = 0; i < call S4Topology.getRootNodesCount(); i++) {
        dbg("S4-beacon","set_beacon_msg: rootBeacons[%d].nodeid=%d,hops=%d, parent=%d\n",i, rootBeacons[i].nodeid, rootBeacons[i].hops, rootBeacons[i].parent);
    }
  
    // the other option is to use the synchronize interface from the LinkEstimator
    // and store the value of the quality.
    ///**************************************************
    
#ifdef MULTIPLE_BEACON
                       
    while(counter<MAX_BEACON_VECTOR_SIZE && next_beacon<call S4Topology.getRootNodesCount())
    {

    	b=&rootBeacons[next_beacon];

    	if(b->hops!=INVALID_COMPONENT && b->valid)
    		{
    		beacon_data_ptr->beacons[counter].beacon_id=next_beacon;

    		beacon_data_ptr->beacons[counter].hopcount=b->hops;
    		beacon_data_ptr->beacons[counter].seqno= b->last_seqno;
    		beacon_data_ptr->beacons[counter].nodeid = b->nodeid;
    		
    		dbg("S4-beacon", "setting beacon_data_ptr: counter=%d,  b->nodeid=%d, next_beacon=%d\n", counter, b->nodeid, next_beacon);

#else
    
    for (i = 0; i < call S4Topology.getRootNodesCount(); i++) {
      b = &rootBeacons[i]; 
      if (b->hops != INVALID_COMPONENT) {
        beacon_data_ptr->beacons[i].hopcount = b->hops;
        beacon_data_ptr->beacons[i].seqno = b->last_seqno;
#endif
#ifdef BEACON_ETX
        /* Store ETX information. See comment above. We store (etx-1)*ETX_SCALE */
#ifdef MULTIPLE_BEACON
        	if(state_is_root_beacon && next_beacon == root_beacon_id) {
#else
        
        if (state_is_root_beacon && i == root_beacon_id) {
#endif
          combined_etx = 0;
        } else {
          if (call LinkEstimator.find(b->parent, &b_parent_ld) != SUCCESS) { 
            /* if parent not in link table */
            combined_etx = MAX_ETX;
          } else if (call LinkEstimator.getBidirectionalQuality(b_parent_ld, &quality_first) != SUCCESS) {
            combined_etx = MAX_ETX;
          }
          if (quality_first > 0) {
            etx_first = scaledEtxFromQuality(quality_first);
            quality_first = etx_first;
            combined_etx = etx_first + b->combined_quality;
            if (combined_etx < etx_first) combined_etx = MAX_ETX; //if overflow
          } else {
            combined_etx = MAX_ETX;
          }
        }
        combined_quality = combined_etx;
#else
        /* Original combined quality info */
        
#ifdef MULTIPLE_BEACON
        if(state_is_root_beacon && next_beacon == root_beacon_id){
#else
        if (state_is_root_beacon && i == root_beacon_id) {
        
#endif
          quality_first = 255;
          combined_quality = 255;
        } else {
          if (call LinkEstimator.find(b->parent, &b_parent_ld) != SUCCESS) { 
            /* if parent not in link table */
            
#ifdef MULTIPLE_BEACON
            
            dbg("S4-debug","set_beacon_msg: ERROR: valid parent %d for root_id %d not in link table!\n",b->parent, i);
#endif
            quality_first = 0;
            combined_quality = 0;
          } else if (call LinkEstimator.getBidirectionalQuality(b_parent_ld, &quality_first) != SUCCESS) {
            quality_first = 0;
            combined_quality = 0;
          }
          if (quality_first > 0) {
            quality_first = quality_with_retransmissions(quality_first, 5);
            combined_quality = combine_root_quality(quality_first, b->combined_quality);
          }
        }
#endif        
        
	#ifdef MULTIPLE_BEACON	
	        beacon_data_ptr->beacons[counter].quality = combined_quality;
	        counter++;
	#else
	        beacon_data_ptr->beacons[i].quality = combined_quality;
	#endif
        
      
      } else {
#ifdef MULTIPLE_BEACON

#else
        beacon_data_ptr->beacons[i].hopcount = INVALID_COMPONENT;
        dbg("S4-debug","set_beacon_msg: [%d] - \n",i);
#endif
      }
#ifdef MULTIPLE_BEACON
      next_beacon++;
    }
    curr_bv_size = counter;
    if (counter == 0) return; //should not happen?
    if (counter < MAX_BEACON_VECTOR_SIZE) {
      /* need to nullify remaining elements in the vector.
       * can only possibly happen for the last vector
       */
      while (counter < MAX_BEACON_VECTOR_SIZE ) {
        /* assume that no beacon is farther away than 255.
         */
        beacon_data_ptr->beacons[counter].hopcount = INVALID_COMPONENT;
        counter++;
      }
#endif      
    }
    dbg("S4-debug","set_beacon_msg: seqno:%d my coordinates: ",beacon_data_ptr->seqno);
    coordinates_print(&my_coords);
  }
  
  /* RootBeacon related functions */
  static void rootBeaconInit(S4RootBeacon* b) {
    if (b!=NULL) {
      b->valid = 0;
      b->parent = 0;
      b->hops = INVALID_COMPONENT; 
      b->last_seqno = 0;
      b->nodeid = 0xFFFF;
#ifndef BEACON_ETX
      b->combined_quality = 0;
#else 
      b->combined_quality = MAX_ETX;
#endif
    } else
      dbg("S4-error","rootBeaconInit called with NULL pointer\n");
  } 

  
  static void rootBeaconSetMyself(S4RootBeacon *b) {

    if (b!=NULL) {
      b->valid = 1;
      b->nodeid = call AMPacket.address();
      b->parent = TOS_BCAST_ADDR; 
      b->hops = 0; 
      b->last_seqno = root_beacon_seqno;  
#ifdef BEACON_ETX
      b->combined_quality = 0;
#else
      b->combined_quality = 255;
#endif

      b->updated=0;
#ifdef RELIABLE_BCAST
      b->bcastlost=0;
#endif

#ifdef SHOW_BEACONID
      b->nodeid=INVALID_NODE_ID;
#endif

    } else 
      dbg("S4-error","rootBeaconSetMyself called with NULL pointer\n");
  }



////////////////////////////////
  uint8_t getBidirectionalQuality(uint16_t nextHop) {
    uint8_t idx = 0;
    uint8_t quality;

    if (   call LinkEstimator.find(nextHop, &idx) == FAIL
	|| call LinkEstimator.getBidirectionalQuality(idx, &quality)==FAIL
       )
    {
      return 0;
    }

    return quality;

  }

  

  /* Inits rootBeacon (if I'm a beacon), my_coords, my_coords_parents */
  static void init_my_coords() {
    int i;
    dbg("S4-beacon","init_my_coords: state_is_root_beacon:%d, root_beacon_id=%d\n",state_is_root_beacon, root_beacon_id);
    coordinates_init(&my_coords);
    if (state_is_root_beacon) {
      coordinates_set_component(&my_coords,root_beacon_id,0);
      rootBeaconSetMyself(&rootBeacons[root_beacon_id]);
    }
    dbg("S4-debug","init_my_coords:");
    coordinates_print(&my_coords);
    for (i = 0; i < call S4Topology.getRootNodesCount(); i++) {
      dbg("S4-beacon","init_my_coords: rootBeacons[%d].nodeid=%d\n",i, rootBeacons[i].nodeid);

      if (rootBeacons[i].valid) {
        my_coords_parents.parent[i] = rootBeacons[i].parent;
      } else {
        my_coords_parents.parent[i] = TOS_BCAST_ADDR;
      }
    }
  }


  /*Node addr has been dropped. See if it is our parent for any beacon, and in that
    case, drop it.
    In fact, our parent is never dropped, as the LinkEstimator pins down any node
    which is a parent. 
    A parent which dies is replaced when another node is chosen as a replacement parent */
  static void dropParent(uint8_t addr) {
    int i;
    
    for (i = 0; i < call S4Topology.getRootNodesCount(); i++) {
      if (rootBeacons[i].parent == addr) {
        dbg("S4-debug","Dropping parent %d for root %d\n",addr,i);
        rootBeaconInit(&rootBeacons[i]);
        my_coords_parents.parent[i] = TOS_BCAST_ADDR;
      }
    }
  } 


  /* Updates the information regarding one specific beacon. 
   * If node 'from' is a better parent, then we update the
   * coordinates. We only update once per sequence number, and only
   * if we receive from the parent. If the parent dies, then its
   * quality will reach 0, and we shall replace it by some other 
   * neighbor.
   * Observation:
   *  0.we have to add 1 to the hopcount we receive. It is done here.
   *  1.if the hopcount does not change, it is safe to update, even if
   *    the seqno is the same. Also, the threshold for updates is not
   *    needed if the hopcount is the same 
   *  2.if we don't update the data, do not update the seqno, this may
   *    get tricky.
   */
  void updateRootBeacon(uint8_t root_id, uint16_t nodeid, uint16_t from, uint8_t quality, 
                        uint8_t seqno, uint8_t hopcount) { 

    //quality is what is received in the packet

    bool force_update = FALSE;  //in case there is no info or the current parent is not in the link table
    bool valid_seqno = FALSE;
    bool same_parent = FALSE;
    bool better_parent = FALSE;
    bool equal_parent = FALSE; 
    uint8_t from_ld;
    uint8_t current_parent_ld; //indices into the link estimator table
    uint8_t received_quality, received_combined_quality;
    uint8_t current_quality;
    uint8_t quality_update_threshold;
#ifndef BEACON_ETX
    uint8_t current_combined_quality, min_update_quality;
#endif
    bool current_parent_in_table;
    bool different_hop;

#ifdef BEACON_ETX
    uint8_t first_s_etx, combined_s_etx; //scaled etx values
    float received_combined_etx;       //true etx
    float current_combined_etx;        //true etx
    float etx_change_threshold;
#endif

    hopcount = hopcount + 1;
    
    dbg("S4-beacon","root_id=%d, nodeid=%d, from=%d, hopcount=%d\n", root_id, nodeid, from, hopcount);

    if ( rootBeacons[root_id].valid &&  hasLowerHash(rootBeacons[root_id].nodeid, nodeid) ) {
      dbg("S4-beacon","Returning due to higher hash compared to %d", rootBeacons[root_id].nodeid);
      return;
    }
    else if (rootBeacons[root_id].nodeid != nodeid) {
      int i;
      force_update = TRUE;

      dv_round = 0;
      dbg("S4-beacon", "Changing rootbeacon %d from %d to %d\n", root_id, rootBeacons[root_id].nodeid, nodeid);

      
      for (i=1; i<MAX_CLUSTER_SIZE; i++)
        ClusterTable[i].valid = 0;
    }

    if (root_id >= MAX_ROOT_BEACONS) {
      dbg("S4-debug","ROOT: warning, received invalid root_id %d\n",root_id);
      return;
    }
    
    if (call LinkEstimator.find(from, &from_ld) != SUCCESS) {
      dbg("S4-beacon","ROOT: assertion failed: updateBeaconInfo received node %d not in LinkEstimator table\n",from); 
      return;
    }
    
    if (state_is_root_beacon && root_id == root_beacon_id && rootBeacons[root_id].nodeid == nodeid) {
      dbg("S4-beacon","From myself, discarding\n");
      return;
    }


    /* get the quality of the incoming root message */
    if (call LinkEstimator.getBidirectionalQuality(from_ld, &received_quality) != SUCCESS) {
      received_quality = 0;
      dbg("S4-debug","getBidirectionalQuality for %d failed, setting to 0\n",from);
    } else {
      dbg("S4-debug","getBidirectionalQuality for %d returned %d\n",from,received_quality);
    }
#ifndef BEACON_ETX
    received_quality = quality_with_retransmissions(received_quality, 5);
    received_combined_quality = 
      combine_root_quality(received_quality, quality);
#else
    if (received_quality > 0) {
      first_s_etx = scaledEtxFromQuality(received_quality);
      combined_s_etx = first_s_etx + quality;
      if (combined_s_etx < first_s_etx) combined_s_etx = MAX_ETX; //if overflow
    } else {
      combined_s_etx = MAX_ETX;
    }

     /* Comparison needs to restore the actual etx values. The etx values
      * in the packet are only the 'extra' transmissions, they must be added to
      * the current hopcount of the path, after downscaled */

    received_combined_etx = (1.0*combined_s_etx)/ETX_SCALE + hopcount;
    received_combined_quality = quality;
    dbg("S4-debug","UpdateRootBeacon: received etx:%d first_s_etx:%d (quality_fist:%d) combined_s_etx:%d ETX:%f\n",
               quality, first_s_etx, received_quality, combined_s_etx,received_combined_etx);
    
#endif
 
    dbg("S4-debug","Root beacon message: source: %d seqno:%d hopcount:%d last_hop:%d comb.quality:%d\n",
                  root_id, seqno, hopcount, from, quality);
    


    if (!(rootBeacons[root_id].valid)) {
      /* don't know about this beacon, will update anyway */
      dbg("S4-debug","Stored root beacon :     id: %d no info stored\n", root_id);
      force_update = TRUE;
    } else {
      /* we have info about this beacon */
      dbg("S4-debug","Stored root beacon :     id: %d seqno:%d hopcount:%d last_hop:%d comb.quality:%d\n",
                    root_id, rootBeacons[root_id].last_seqno, rootBeacons[root_id].hops, 
                    rootBeacons[root_id].parent, rootBeacons[root_id].combined_quality);
      current_parent_in_table = (call LinkEstimator.find(rootBeacons[root_id].parent, &current_parent_ld) == SUCCESS);
      if (!current_parent_in_table) {
        dbg("S4-debug","ROOT: force update: current parent %d not in LinkEstimator table\n", rootBeacons[root_id].parent);
        force_update = TRUE;
      } else {
        /* current parent is in link table */

        /* if same hopcount */
        /* Although it is apparently right (meaning we couldn't find a case
         * that breaks this, accepting the same sequence numbers makes breaking loops
         * that appear for some reason very hard */
        if (hopcount == rootBeacons[root_id].hops) {
           different_hop = FALSE;
          /* in this case we can use information with the same sequence number also */
          
          valid_seqno = is_within_range(seqno, rootBeacons[root_id].last_seqno);
          
          /* modified by Feng Wang for slow update */
	  //valid_seqno = is_within_range(seqno, rootBeacons[root_id].last_seqno);
	  valid_seqno = is_greater_by_2(seqno, rootBeacons[root_id].last_seqno);
          
          ////////////////////////////
          
          quality_update_threshold = 0;
          dbg("S4-debug","ROOT: update: same hopcount, valid_seqno: %d threshold %d\n", 
              valid_seqno, quality_update_threshold);
        } else {
          different_hop = TRUE;          
          
          ///valid_seqno = is_within_range(seqno, rootBeacons[root_id].last_seqno); /// feng weng ullo
          valid_seqno = is_greater_by_2(seqno, rootBeacons[root_id].last_seqno);//// feng weng ullo
          
          quality_update_threshold = PARENT_SWITCH_THRESHOLD;
          dbg("S4-debug","ROOT: update: different hopcount, valid_seqno: %d threshold: %d\n", 
              valid_seqno, quality_update_threshold);
        }
        

        /* if the same or a different parent */
        if (from == rootBeacons[root_id].parent) {
          same_parent = TRUE;
#ifdef BEACON_ETX
#ifdef ETX_TOLERANCE
          if (different_hop) {
            rootBeacons[root_id].tolerance = RESET_TOLERANCE;
            dbg("S4-debug","UpdateBeacon: same parent, different hop, reset tolerance: t[ %d ]= %d\n",root_id,rootBeacons[root_id].tolerance);
          } else {
            if (rootBeacons[root_id].tolerance < 255)
              rootBeacons[root_id].tolerance++;
            dbg("S4-debug","UpdateBeacon: same parent,   same hop, increase tolerance: t[ %d ]= %d\n",root_id,rootBeacons[root_id].tolerance);
          }
#endif //ETX_TOLERANCE
          //This entire ifdef is here just for logging, unnecessary otherwise
          if (call LinkEstimator.getBidirectionalQuality(current_parent_ld,&current_quality) != SUCCESS) 
             current_quality = 0;
          if (current_quality > 0) {
            first_s_etx = scaledEtxFromQuality(current_quality);
            combined_s_etx = first_s_etx + rootBeacons[root_id].combined_quality;
            if (combined_s_etx < first_s_etx) combined_s_etx = MAX_ETX; //if overflow
          } else {
            combined_s_etx = MAX_ETX;
          }
          current_combined_etx = (1.0*combined_s_etx)/ETX_SCALE + rootBeacons[root_id].hops;
 
          //Logging for evaluation of hysteresis options
          //TODO: convert this to an actual log message, for the real testbed
              dbg("S4-debug","ETX root_id: %d CURRENT etx: %f hopcount: %d through: %d RECEIVED etx: %f hopcount: %d from: %d changed: %d\n",
                sim_time_string(), root_id,
                current_combined_etx, rootBeacons[root_id].hops, rootBeacons[root_id].parent,
                received_combined_etx, hopcount, from,
                (force_update || ( valid_seqno && ( same_parent || better_parent ))));
#endif
        /* ###### IMPORTANT CHANGE by FENG WANG ######
	         * also accept same seqno from better parent (for now, just smaller hopcount)
	         */	        
	        } else if ( valid_seqno || 
	                    ( is_within_2(seqno,rootBeacons[root_id].last_seqno) && (hopcount <= rootBeacons[root_id].hops) ) ||
	                    ( (seqno == rootBeacons[root_id].last_seqno) && (hopcount < rootBeacons[root_id].hops) ) ) {
          
          /* compare the qualities, if different parent and valid sequence number */
          if (call LinkEstimator.getBidirectionalQuality(current_parent_ld,&current_quality) != SUCCESS) 
             current_quality = 0;
#ifndef BEACON_ETX
          current_quality  = quality_with_retransmissions( current_quality, 5);
          current_combined_quality =    
             combine_root_quality(current_quality, rootBeacons[root_id].combined_quality);
             min_update_quality = apply_threshold(current_combined_quality, quality_update_threshold);

          // modified by Feng Wang	 
#ifdef CRROUTING
             //always choose shorter paths
             //added on Mar 05: must be above the quality threshold
             better_parent = (hopcount < rootBeacons[root_id].hops);
             equal_parent = (hopcount == rootBeacons[root_id].hops);
             //dbg(DBG_ROUTE,"received_quality is %d, better_parent is %d\n",received_quality,better_parent);
#endif
#else 
          if (current_quality > 0) {
            first_s_etx = scaledEtxFromQuality(current_quality);
            combined_s_etx = first_s_etx + rootBeacons[root_id].combined_quality;
            if (combined_s_etx < first_s_etx) combined_s_etx = MAX_ETX; //if overflow
          } else {
            combined_s_etx = MAX_ETX;
          }
          current_combined_etx = (1.0*combined_s_etx)/ETX_SCALE + rootBeacons[root_id].hops;
          dbg("S4-debug","UpdateRootBeacon: current etx:%d first_s_etx:%d (quality_fist:%d) combined_s_etx:%d ETX:%f\n",
               quality, first_s_etx, current_quality, combined_s_etx, current_combined_etx);
         
          
          etx_change_threshold = 1.0*quality_update_threshold/(1.0*ETX_SCALE);
          better_parent = (received_combined_etx < current_combined_etx - etx_change_threshold );

#ifdef ETX_TOLERANCE
          //if better_parent and different_hop and tolerance over, switch

          if (better_parent) {
            if (different_hop) {
              rootBeacons[root_id].tolerance = (uint8_t)(rootBeacons[root_id].tolerance / ETX_MD_FACTOR);
              better_parent = (rootBeacons[root_id].tolerance == 0);
              if (rootBeacons[root_id].tolerance == 0) {
                rootBeacons[root_id].tolerance = RESET_TOLERANCE; //7 chances
                dbg("S4-debug","UpdateBeacon: diff parent, different hop, reset tolerance: t[ %d ]= %d\n",root_id,rootBeacons[root_id].tolerance);
              } else {
                dbg("S4-debug","UpdateBeacon: diff parent, different hop, decrease tolerance: t[ %d ]= %d\n",root_id,rootBeacons[root_id].tolerance);
              }
            } else {
              //better parent, same hop: increase tolerance
              if (rootBeacons[root_id].tolerance < 255)
                rootBeacons[root_id].tolerance++;
              dbg("S4-debug","UpdateBeacon: diff parent,   same hop, increase tolerance: t[ %d ]= %d\n",root_id,rootBeacons[root_id].tolerance);
            }
          }
#endif //ETX_TOLERANCE

          dbg("S4-debug","UpdateRootBeacon: comparing ETX. Current etx %f hopcount %d . Received etx %f hopcount %d (threshold:%f)\n", 
              current_combined_etx, rootBeacons[root_id].hops, received_combined_etx, hopcount,etx_change_threshold);
  
          //Logging for evaluation of hysteresis options
          //TODO: convert this to an actual log message, for the real testbed
              dbg("S4-debug","%s ETX root_id: %d CURRENT etx: %f hopcount: %d through: %d RECEIVED etx: %f hopcount: %d from: %d changed: %d\n",
                sim_time_string(), root_id,
                current_combined_etx, rootBeacons[root_id].hops, rootBeacons[root_id].parent,
                received_combined_etx, hopcount, from,
                (force_update || ( valid_seqno && ( same_parent || better_parent ))));

#endif //BEACON_ETX
        }
      } //is current parent in the LinkEstimator table? (the answer will be yes)
    } //do we have info about this beacon?

#ifdef ETX_TOLERANCE
    if (force_update) {
      rootBeacons[root_id].tolerance = RESET_TOLERANCE; //7 chances
      dbg("S4-debug","UpdateBeacon: force update,   - -, reset tolerance: t[ %d ]= %d\n",root_id,rootBeacons[root_id].tolerance);
    }
#endif //ETX_TOLERANCE

    //XXX: RF: should we update seqno when we don't update the information?
    //     Initial thought says NO, it may get nasty if my parent becomes
    //     disconnected from the root.
    
    
    
    
    
    /* ##### IMPORTANT CHANGE by FENG WANG #####
         * 1. instead of only accepting larger seqno, we also
         * accept same seqno if from a better parent.
         * 2. shouldn't we always accept larger seqno 
         * no matter it's from same/better parent or not!!!???
         */
     if (force_update || ((valid_seqno || is_within_2(seqno,rootBeacons[root_id].last_seqno)) && (better_parent || equal_parent) )
                         || ( (seqno == rootBeacons[root_id].last_seqno) && better_parent ) ) {
       bool coordinates_changed, parent_changed;
       
    
       /////////////////////////////////////////// 
    
  
      //do the update and the logging

      //These conditions assume that [! force_update => rootBeacons[root_id].valid]
      //and depend on short-circuit evaluation
      parent_changed      = (force_update || rootBeacons[root_id].parent != from);
      coordinates_changed = (force_update || rootBeacons[root_id].hops != hopcount);

      //logging
      if (!parent_changed) {
        dbg("S4-debug","NGProcessRootBeacon: keeping parent for beacon %d\n", root_id);
      } else {
        dbg("S4-debug","NGProcessRootBeacon: replacing parent for beacon %d\n",  root_id);
        if (rootBeacons[root_id].valid){
          dbg("S4-temp","root_beacon_%d DIRECTED GRAPH: remove edge %d\n",root_id,
            rootBeacons[root_id].parent);
        }
        dbg("S4-temp","root_beacon_%d DIRECTED GRAPH: add edge %d\n",root_id,
            from);
      }      
      
      //added by Feng Wang
      if (rootBeacons[root_id].hops != hopcount) {
              rootBeacons[root_id].updated = 1;
      }
      
      //////////////////////////

      if (root_id >= call S4Topology.getRootNodesCount() )
          call S4Topology.setRootNodesCount(root_id+1);

      call S4Topology.setRootBeaconID(rootBeacons[root_id].nodeid, 0xFF);
      call S4Topology.setRootBeaconID(nodeid, root_id);
      
      
      if (rootBeacons[root_id].nodeid == call AMPacket.address()) {
        state_is_root_beacon = FALSE;
      }
      
      rootBeacons[root_id].valid = TRUE;
      rootBeacons[root_id].nodeid = nodeid;
      
      rootBeacons[root_id].parent = from;
      rootBeacons[root_id].last_seqno = seqno;
      rootBeacons[root_id].hops = hopcount; 
      rootBeacons[root_id].combined_quality = received_combined_quality;
      coordinates_set_component(&my_coords,root_id,hopcount);
      my_coords_parents.parent[root_id] = rootBeacons[root_id].parent;
      
      dbg("S4-beacon","CHANGED! root_id=%d, nodeid=%d, from=%d, hopcount=%d\n", root_id, nodeid, from, hopcount);
      
      
      //log a change if either the coordinate or the parent changed
      if (coordinates_changed) {
        dbg("S4-debug","COORDS: My Coordinates changed: ");
        coordinates_print(&my_coords);
        signal S4Locator.statusChanged();
      }      
      
      dbg("S4-debug", "Reached end of updateBeaconInfo\n");
    }
  } //end updateBeaconInfo
  




  /* This task processes received beacon messages.
   * Nodes learn both coordinates of other nodes and derive the root
   * beacon trees.
   * Update node info in coordinate table
   * For each valid coordinate
   *   update root beacon messages
   */
  task void processMessage() {
    /* will work from rcv_beacon_ptr */
    bool found = FALSE;
    S4BeaconMsg * rcv_bvr_msg = (S4BeaconMsg*)&rcv_beacon_ptr->data[0];
    S4BeaconMsgData * rcv_bvr_data_ptr = (S4BeaconMsgData*)&rcv_bvr_msg->type_data;
    BeaconInfo *beacon_info;
    int i;
    uint8_t beacon_i;
    
    uint8_t neighbor;
    uint8_t quality;
   
   
   #ifdef RELIABLE_BCAST
       int j;
       uint8_t beacon_j;
       uint8_t n_ngb;
       call LinkEstimator.getNumGoodLinks(&n_ngb);
#endif

/////////////////
    
   #ifdef FW_COORD_TABLE
       Coordinates received_coords;
       CoordinateTableEntry* ce;
   #endif

   /* TODO: need to check seqno of this message,
        * i.e. check rcv_bvr_data_ptr->seqno,
        * which requires to store last seqno for each neighbor.
        * This is different from checking seqno 
        * for each beacon inside the message,
        * i.e. rcv_bvr_data_ptr->beacons[i].seqno
        */
    
  
  #ifdef FW_COORD_TABLE
      //Copy the received data into a Coordinates structure
      coordinates_init(&received_coords);
  #endif
  

  
  #ifdef MULTIPLE_BEACON
      for (i = 0; i < MAX_BEACON_VECTOR_SIZE; i++) {
  #else
      for (i = 0; i < call S4Topology.getRootNodesCount(); i++) {
  #endif
        if (rcv_bvr_data_ptr->beacons[i].hopcount != INVALID_COMPONENT) {
          beacon_info = &rcv_bvr_data_ptr->beacons[i];
  #ifdef MULTIPLE_BEACON
          beacon_i = beacon_info->beacon_id;
  #ifdef FW_COORD_TABLE
          coordinates_set_component(&received_coords, beacon_i, beacon_info->hopcount);
  #endif
  #else
  #ifdef FW_COORD_TABLE
          coordinates_set_component(&received_coords, i, beacon_info->hopcount);
  #endif
  #endif
        }        
      }
      
      if (!rcv_buffer_busy) 
        dbg("S4-debug","Assertion failed: in processMessage, rcv_buffer_busy is false!!\n");
  
      if ((call LinkEstimator.find(rcv_bvr_msg->header.last_hop, &neighbor))==SUCCESS)
        found = TRUE;
      else 
        found = FALSE;
  
      if (found) {
        //the neighbor exists in the link info cache
        if (call LinkEstimator.getBidirectionalQuality(neighbor,&quality) != SUCCESS) 
          quality = 0;
  
        dbg("S4-debug","NG$S4StateReceive$receive: from %d \n", rcv_bvr_msg->header.last_hop);
  
  
        //discard message from ourselves
        if (rcv_bvr_msg->header.last_hop == call AMPacket.address()) {
          //this will not actually happen
          dbg("S4-debug","COORDS: Received beacon from myself, discarding\n");
        } else {
  #ifdef FW_COORD_TABLE  
          dbg("S4-debug","COORDS: Received coordinate beacon. last_hop:%d seqno:%d",
                    rcv_bvr_msg->header.last_hop, rcv_bvr_data_ptr->seqno);
        
        
        /////////////**************
        dbg("S4-debug"," coords: ");
        coordinates_print(&received_coords);
  
        ce = call CoordinateTable.getEntry(rcv_bvr_msg->header.last_hop);
        if (ce == NULL) {
          //it is not in the table, let's try to store it
          dbg("S4-debug","COORDS: Node is not in CoordinateTable\n");
          ce = call CoordinateTable.storeEntry(
                      rcv_bvr_msg->header.last_hop,
                      rcv_bvr_msg->header.last_hop,
                      rcv_bvr_data_ptr->seqno,
                      quality,
                      &received_coords);
          if (ce != NULL) {
            //it was successfully added to our table, and is fresh
            dbg("S4-debug","COORDS: It is now\n");
          }
        } else {
          dbg("S4-debug","COORDS: Node is in CoordinateTable, updating entry\n");
          //it is in our table already
          CTEntryTouch(ce);
          CTEntryUpdateCoordinates(ce, &received_coords);
          CTEntryUpdateSeqno(ce, rcv_bvr_data_ptr->seqno); 
          //call Logger.LogUpdateNeighbor(ce);
        }               
        if (ce == NULL) {
          dbg("S4-debug","COORDS: could not store entry in CoordinateTable\n");
          //XXX: we can decide whether or not we want to use this node as a potential
          //parent. I don't see why not...
        }
#endif

        /* ********************************************** */
        /* Now update the root beacon information for each valid beacon */
        /* ********************************************** */

#ifndef FROZEN_COORDS

#ifdef RELIABLE_BCAST
        //for each beacon, overhear and count number of neighbors receiving the broadcast
#ifdef MULTIPLE_BEACON
        for (j=0; j<MAX_BEACON_VECTOR_SIZE; j++) {
#else
        for (j=0; j<call S4Topology.getRootNodesCount(); j++) {
#endif
          if (rcv_bvr_data_ptr->beacons[j].hopcount != INVALID_COMPONENT) {
#ifdef MULTIPLE_BEACON
            beacon_j = rcv_bvr_data_ptr->beacons[j].beacon_id;
#else
            beacon_j = j;
#endif
            for (i=0; i<MAX_PENDING_BEACON; i++) {
              if (pending_beacons[i].occupied) {
                if (beacon_j == pending_beacons[i].beacon_id) {

                  if ( (is_within_range(rcv_bvr_data_ptr->beacons[j].seqno, rootBeacons[beacon_j].last_seqno) ||
                        rcv_bvr_data_ptr->beacons[j].seqno == rootBeacons[beacon_j].last_seqno) &&
                        rcv_bvr_data_ptr->beacons[j].hopcount <= rootBeacons[beacon_j].hops+1 ) {
                    /* it's surely from a different neighbor,
                     * since if having already received, 
                     * a neighbor wouldn't re-broadcast in a same beaconing round
                     */
                    pending_beacons[i].n_rcv++;
                  
                    //dbg(DBG_ROUTE,"%d increment n_rcv to %d (n_ngb %d) for beacon %d\n",(int)(tos_state.tos_time/4000),
                    //               pending_beacons[i].n_rcv,n_ngb,rootBeacons[beacon_j].nodeid);

                    if (pending_beacons[i].n_rcv >= n_ngb ) {
                      pending_beacons[i].occupied = FALSE;
                      rootBeacons[pending_beacons[i].beacon_id].bcastlost = 0;
                      pending_beacons[i].n_rcv = 0;
                      pending_beacons[i].retries = 0;
                    }
                  }
                  break;
                }
              }
            }
          }
        }
#endif

#ifdef MULTIPLE_BEACON
        for (i = 0; i < MAX_BEACON_VECTOR_SIZE; i++) {
#else
        for (i = 0; i < call S4Topology.getRootNodesCount(); i++) {
#endif
          if (  rcv_bvr_data_ptr->beacons[i].hopcount != INVALID_COMPONENT
             && rcv_bvr_data_ptr->beacons[i].nodeid != 0 
              )
          {
            beacon_info = &rcv_bvr_data_ptr->beacons[i];
#ifdef MULTIPLE_BEACON
            beacon_i = beacon_info->beacon_id;
            //displayRootBeacons();
            updateRootBeacon(beacon_i, beacon_info->nodeid, rcv_bvr_msg->header.last_hop, 
                             beacon_info->quality, beacon_info->seqno, 
                             beacon_info->hopcount);
	    //displayRootBeacons();
#else
            updateRootBeacon(i, beacon_info->nodeid, rcv_bvr_msg->header.last_hop, 
                             beacon_info->quality, beacon_info->seqno, 
                             beacon_info->hopcount);
#endif
          }
        }

#ifdef CHECK_LINK
//added by Feng Wang
#ifdef CRROUTING
        i = coordinates_get_closest_beacon(&my_coords);
        //if this is the first global beacon message, start ClusterTimer.
        //and only start if we are not a landmark
        if (first_global_beacon && 
            i != INVALID_COMPONENT && !state_is_root_beacon) {
          first_global_beacon = FALSE;
          dbg(DBG_USR3,"%s Starting ClusterTimer in %d\n",sim_time_string(),b_timer_int);
#ifdef SEND_UPDATE_ONLY
          call ClusterTimer.startOneShot(update_int*WAIT_BEACON_ROUNDS);
#else
          call ClusterTimer.startOneShot( b_timer_int*WAIT_BEACON_ROUNDS);
#endif

#ifdef LOCAL_DV
#ifdef SEND_UPDATE_ONLY
          //start the first ClusterUpdateTimer after the first ClusterTimer
          dbg(DBG_USR3,"%s Starting ClusterUpdateTimer in %d ms\n",sim_time_string(),b_timer_int+update_int);
          call ClusterUpdateTimer.startOneShot(update_int*(WAIT_BEACON_ROUNDS+1));
#endif
#endif
        }
#endif  //CRROUTING
#endif  //CHECK_LINK

#endif 

      } //if from myself (shouldn't happen at all)
    } //if found in LinkTable. Ignore if not found

    //else
    

    rcv_buffer_busy = FALSE; 
  } //end processMessage


  /* When a link is dropped by the link estimator, we should update the 
   * Coordinate table and the parent table.
   */
  event error_t LinkEstimatorSynch.linkRemoved(uint16_t addr) {
    if (state_is_active) {
#ifdef FW_COORD_TABLE
      call CoordinateTable.removeEntry(addr);
#endif
#ifndef FROZEN_COORDS
      dropParent(addr);
#endif
    }
    return SUCCESS;
  }

  event error_t LinkEstimatorSynch.bidirectionalQualityChanged(uint16_t addr, uint8_t quality) {

#ifdef FW_COORD_TABLE
    if (state_is_active)
      call CoordinateTable.updateQuality(addr, quality);
#endif

    return SUCCESS;
  }

  event error_t LinkEstimatorSynch.reverseQualityChanged(uint16_t addr, uint8_t reverseQuality) {
    return SUCCESS;
  }

  event error_t LinkEstimatorSynch.qualityChanged(uint16_t addr, uint8_t quality) {
    return SUCCESS;
  }

/****************** Provided Interface Commands *****************/  
  command error_t S4Locator.getCoordinates(Coordinates * coords) {

    //displayRootBeacons();
    if (coordinates_count_valid_components(&my_coords) != 0) {
      coordinates_copy(&my_coords, coords);
      
      return SUCCESS;
    } else {
      
      return FAIL;
    }
  }


  /* Will not allow eviction of a neighbor which is a parent to some beacon */
  event error_t LinkEstimator.canEvict(uint16_t addr) {
    int i;
    bool is_parent = FALSE;
    for (i = 0; i < call S4Topology.getRootNodesCount(); i++) {
      is_parent = (rootBeacons[i].parent == addr);
      if (is_parent)
        break;
    }
    return is_parent?FAIL:SUCCESS;
  }

/************************ S4StateCommand**************************/

  /* This command is doing nothing */
  command error_t S4StateCommand.setCoordinates(Coordinates * coords) {
    return SUCCESS;
  }
  
  command error_t S4StateCommand.getCoordinates(Coordinates ** coords) {
    *coords = &my_coords;
    return SUCCESS;
  }
  
  command error_t S4StateCommand.stopRootBeacon() {
    return SUCCESS;
  }

  command error_t S4StateCommand.startRootBeacon() {
    return SUCCESS;
  }


  #ifdef FW_ROOTBEACON_CMD
    /* Use with care. It is not polite to have two beacons with the same id! */
    command error_t S4StateCommand.setRootBeacon(uint8_t id) {
      
    
      if (id == NOT_ROOT_BEACON) {
        if (state_is_root_beacon) {
          state_is_root_beacon = FALSE;
        }
      } else {
        if (id > call S4Topology.getRootNodesCount()) {
          return FAIL;
        } else {
          if (!state_is_root_beacon) {
            state_is_root_beacon = TRUE;
            root_beacon_id = id;
            rootBeaconSetMyself(&rootBeacons[id]);
          }      
        }
      }
      return SUCCESS;
  }
  /* Value: NOT_ROOT_BEACON  indicates that the node is not a root beacon.
     Otherwise, the returned value is the root beacon id
  */
  command error_t S4StateCommand.isRootBeacon(bool *value) {
    if (!state_is_root_beacon) 
      *value = NOT_ROOT_BEACON;
    else 
      *value = root_beacon_id;
    return SUCCESS;
  }
  #endif
  #ifdef FW_COORD_TABLE 
  command error_t S4StateCommand.getNumNeighbors(uint8_t *n) {
    *n = call CoordinateTable.getOccupied();
    return SUCCESS;
  }
  #endif
  
  command error_t S4StateCommand.getRootInfo(uint8_t n, S4RootBeacon** r) {

  
    if (n >= call S4Topology.getRootNodesCount() || r == NULL)
      return FAIL;
    *r =  &rootBeacons[n];
     return SUCCESS;
  }
  


/************************* Events ******************************/  


/////////////////// Messs///////////////////////////////////////
//*************************************************************
//***************************************************************


   //send beacon with my coordinates
    //We only beacon when our coordinates have changed. 
    //When this happens, we send two consecutive beacons
    event void BeaconTimer.fired() {
     
  #ifndef CHECK_LINK
      int i;
  #endif
  
  #ifndef FLOOD_BEACON_ONCE
      int32_t jitter, jitter2;
      uint32_t interval;
  
      if (state_beaconing_coords) {
        //will also log my coordinates        

        jitter = ((call Random.rand32()) % (b_timer_jit>>2)) - (b_timer_jit >> 3);
        interval = b_timer_int + jitter;
        dbg(DBG_TEMP,"COORDS: beacon timer:jitter=%d. (max %d). Interval: %d\n"
                    ,jitter,b_timer_jit,interval);
        call BeaconTimer.startOneShot(interval);
      }
  #endif
  
    
  
  #ifndef CHECK_LINK
      beacon_round++;  dbg("BVR", "beacon_round=%d\n", beacon_round);
      if (beacon_round > MAX_BEACON_ROUND) {
        //added by Feng Wang, to start the ClusterTimer
  #ifdef CRROUTING
        i = coordinates_get_closest_beacon(&my_coords);    

        //if this is the first global beacon message, start ClusterTimer.
        //and only start if we are not a landmark
        if (first_global_beacon && 
            i != INVALID_COMPONENT && !state_is_root_beacon) {
          first_global_beacon = FALSE;
          jitter2 = ((call Random.rand32()) % 2000);
          dbg(DBG_ROUTE,"%s Starting ClusterTimer in %d\n",sim_time_string(), b_timer_int+jitter2);
  #ifdef SEND_UPDATE_ONLY
          call ClusterTimer.startOneShot( update_int);
  #else
          call ClusterTimer.startOneShot(b_timer_int + jitter);
  #endif
  
  #ifdef LOCAL_DV
  #ifdef SEND_UPDATE_ONLY
  
          //start the first ClusterUpdateTimer after the first ClusterTimer
          dbg(DBG_USR3,"%d Starting ClusterUpdateTimer in %d ms\n",sim_time(),b_timer_int+update_int);
          call ClusterUpdateTimer.startOneShot(update_int*2);
  #endif
  #endif
        }
  #endif
  
      }
  #endif
  
      /* if busy, just wait for next timeout.
       * the only possibility is we are in the 
       * middle of transmitting multiple beacon update msgs
       * from BeaconUpdateTimer.fired()
       */
      if (beacon_send_busy) {
        //dbg(DBG_ROUTE,"%d in BeaconTimer: beacon_send_busy is TRUE\n",(int)(tos_state.tos_time/4000));
        return;
      }
  
  #ifdef MULTIPLE_BEACON
      if (next_beacon == 0) {
  #else
      if (beacons_to_send == 0) {
  #endif
  
        //normal behavior
        //see if we should send a beacon
  
  #ifdef MULTIPLE_BEACON
  

        //BIG HACK by Feng Wang on Mar 14
        //in the same PERIOD, use the same seqno
  #ifndef SAME_SEQNO
        beacon_seqno++;
  #endif
  #else
        beacons_to_send = 1;
  #endif
  
        if (state_is_root_beacon) {
  #ifndef SAME_SEQNO
          rootBeacons[root_beacon_id].last_seqno = root_beacon_seqno++;
  #else
          rootBeacons[root_beacon_id].last_seqno = root_beacon_seqno;
  #endif
        }
        set_beacon_msg();  //sets the beacon message with coordinates, qualities, seqnos
   
        //send local coordinate beacon
        //if busy, just wait
  #ifdef MULTIPLE_BEACON
        dbg("S4-debug", "curr_bv_size = %d\n", curr_bv_size);

        if (curr_bv_size>0) {
          /* ############# important change ###############
           * set beacon_send_busy flag before posting sendBeaconTask.
           * avoid potential concurrent writing to beacon_buf
           * from BeaconTimer and BeaconUpdateTimer.
           * beacon_send_busy will be reset after finishing sending beacons.
           */
          beacon_send_busy = TRUE;  
  
          post sendBeaconTask();
        } else next_beacon = 0;  //reset to 0
  #else

        beacon_send_busy = TRUE;
        post sendBeaconTask();
  #endif
      }
      else
  #ifdef MULTIPLE_BEACON
        dbg(DBG_ROUTE,"next_beacon != 0, next_beacon = %d\n", next_beacon);
  #else
        dbg(DBG_ROUTE,"beacons_to_send != 0\n");
  #endif
  
      return;
    }
  
    event void BeaconRetransmitTimer.fired() {
      post sendBeaconTask();
      return;
    }
  
    task void sendBeaconTask() {
  
      int j;
      uint8_t beacon_j;
  
  #ifdef RELIABLE_BCAST
      int i,indx;
      uint8_t n_ngb;
  #ifdef TOSSIM
      int curTime = sim_time();
  #else
      uint32_t curTime = call Time.getLow32();
  #endif
  #endif
    

      dbg("S4-debug","NG$BeaconTimer$fired: bcast beacon. seqno:%d to_send:%d\n",
         beacon_data_ptr->seqno,beacons_to_send);
  
  
  #ifdef MULTIPLE_BEACON
      for (j=0; j<MAX_BEACON_VECTOR_SIZE; j++) {
  #else
      for (j=0; j<call S4Topology.getRootNodesCount(); j++) {
  #endif
        if (beacon_data_ptr->beacons[j].hopcount != INVALID_COMPONENT) {
  #ifdef MULTIPLE_BEACON
          beacon_j = beacon_data_ptr->beacons[j].beacon_id;
          dbg("S4-beacon","NG$BeaconTimer$fired: bcast beacon. j:%d seqno:%d to_send:%d, nodeid=%d\n", j,
                                beacon_data_ptr->seqno, beacons_to_send, beacon_data_ptr->beacons[j].nodeid );
  #else
          beacon_j = j;
  #endif
        }
        
        dbg("S4-beacon","NG$BeaconTimer$fired: bcast beacon. j:%d seqno:%d to_send:%d, nodeid=%d\n", j,
                                beacon_data_ptr->seqno, beacons_to_send, beacon_data_ptr->beacons[j].nodeid );
      }
  
      //count beacon traffic overhead
      sent_bv += curr_bv_size*sizeof(BeaconInfo);
  
      if (call S4StateAMSend.send(AM_BROADCAST_ADDR, &beacon_buf, beacon_msg_length) == SUCCESS) {
        beacon_send_retries = 0;
  
  #ifdef RELIABLE_BCAST
  
        // first, remove entries received by sufficient neighbors
        call LinkEstimator.getNumGoodLinks(&n_ngb);
        for (i=0; i<MAX_PENDING_BEACON; i++) {
          if (pending_beacons[i].occupied) {
            uint8_t dist_to_orig = rootBeacons[pending_beacons[i].beacon_id].hops;

            if ( (dist_to_orig == 0 && pending_beacons[i].n_rcv >= n_ngb) ||
                 (dist_to_orig > 0 && pending_beacons[i].n_rcv*3 >= n_ngb) ) {
  
              pending_beacons[i].occupied = FALSE;
              rootBeacons[pending_beacons[i].beacon_id].bcastlost = 0;
            }
          }
        }
  
  #ifdef MULTIPLE_BEACON
        for (j=0; j<MAX_BEACON_VECTOR_SIZE; j++) {
  #else
        for (j=0; j<call S4Topology.getRootNodesCount(); j++) {
  #endif
          if (beacon_data_ptr->beacons[j].hopcount != INVALID_COMPONENT) {
  #ifdef MULTIPLE_BEACON
            beacon_j = beacon_data_ptr->beacons[j].beacon_id;
  #else
            beacon_j = j;
  #endif
  
            indx = -1;
            for (i=0; i<MAX_PENDING_BEACON; i++) {
              if (pending_beacons[i].occupied &&
                  pending_beacons[i].beacon_id == beacon_j) {
                indx = i;
                break;
              }
            }
  
            if (indx < 0) { // not found in pending
  
              for (i=0; i<MAX_PENDING_BEACON; i++) {
                if (!pending_beacons[i].occupied) {
                  indx = i;
                  break;
                }
              }
            }
  
            if (indx >= 0 && indx < MAX_PENDING_BEACON) { //valid index
              //reset for current broadcast session
  
              pending_beacons[indx].occupied = TRUE;
              pending_beacons[indx].beacon_id = beacon_j;
              pending_beacons[indx].n_rcv = 0;
  #ifdef TOSSIM
              pending_beacons[indx].sendtime = curTime;
  #else
              pending_beacons[indx].sendtime = (uint8_t)(curTime>>10);  //convert binary milliseconds into seconds
  #endif
              pending_beacons[indx].retries = 0;
            } else { //pending_beacons table must be full
              
            }
          }
        }
  #endif
  
  
      } else {
        /* add a retransmission counter
         * so that to avoid retransmitting forever.
         */
        beacon_send_retries++;
        if (beacon_send_retries < MAX_BEACON_SEND_RETRIES) {
          //retry
          dbg(DBG_ROUTE,"%d Failure: send failed for beacon!\n",sim_time());
  
  #ifndef MULTIPLE_BEACON
          if (beacons_to_send > 0) {
  #else
          if (next_beacon < call S4Topology.getRootNodesCount()) {  //shouldn't it always be true???
  #endif
            uint16_t delay = call Random.rand32() % delay_timer_jit + 1;
            dbg(DBG_ROUTE,"%d Retrying\n", sim_time());
            call BeaconRetransmitTimer.startOneShot(delay);
          }
        } else {
          /* MUST RESET beacon_send_busy after
           * last failed retransmission
           */
          //dbg(DBG_ROUTE,"%d reset beacon_send_busy after failed retransmissions\n",(int)(tos_state.tos_time/4000));
          beacon_send_busy = FALSE;
          beacon_send_retries = 0;
        }
      }
    }
   
  
    event void S4StateAMSend.sendDone(message_t* msg, error_t success) {
      dbg("S4-state-func","NG$S4StateAMSend$SendDone (%p): result=%s\n",msg,(success==SUCCESS)?"ok":"failure");
      if (msg == &beacon_buf) {
  
        int j;
        uint8_t beacon_j;
  
        dbg(DBG_USR2,"\t sent beacon buffer\n");
  
        //reset updated flag after sending is done
        //care to check "success"???
  #ifdef MULTIPLE_BEACON
        for (j=0; j<MAX_BEACON_VECTOR_SIZE; j++) {
  #else
        for (j=0; j<call S4Topology.getRootNodesCount(); j++) {
  #endif
          if (beacon_data_ptr->beacons[j].hopcount != INVALID_COMPONENT) {
  #ifdef MULTIPLE_BEACON
            beacon_j = beacon_data_ptr->beacons[j].beacon_id;
  #else
            beacon_j = j;
  #endif
            //dbg(DBG_ROUTE,"%d reset updated flag for %d\n",(int)(tos_state.tos_time/4000),rootBeacons[beacon_j].nodeid);
            rootBeacons[beacon_j].updated = 0;
          }
        }
  
  
  #ifndef MULTIPLE_BEACON
        beacons_to_send--;
        if (beacons_to_send > 0) {
          uint16_t delay = call Random.rand32() % delay_timer_jit + 1;
          set_beacon_msg();
          call BeaconRetransmitTimer.startOneShot(delay);
        } else {
          //dbg(DBG_ROUTE,"%d reset beacon_send_busy after finishing sending beacons\n",(int)(tos_state.tos_time/4000));
          beacon_send_busy = FALSE;
        }
  #else
  
  #if 0
        bv_index++;   //apparently, only one of these two is necessary
  #endif
  
        if (next_beacon < call S4Topology.getRootNodesCount()) {
          set_beacon_msg();
          if (curr_bv_size > 0) {
            uint16_t delay = call Random.rand32() % delay_timer_jit + 1;
            call BeaconRetransmitTimer.startOneShot(delay);
          } else {
            if (next_beacon < call S4Topology.getRootNodesCount()) {
              //shouldn't happen
              //beacon_send_busy = FALSE;
              //beacon_send_retries = 0;
              return;
            }
            //reset next_beacon index
            beacon_send_busy = FALSE;
            beacon_send_retries = 0;
            next_beacon = 0;
          }
        } else {
          //reset next_beacon index
          //dbg(DBG_ROUTE,"%d reset beacon_send_busy after finishing sending beacons\n",(int)(tos_state.tos_time/4000));
          beacon_send_busy = FALSE;
          beacon_send_retries = 0;
          next_beacon = 0;
        }
  #endif
  
      }
  
      return ;
    }
  
  
    /* This is triggered when we receive a ngeo message
     *  1. update the link information
     *  2. update bidirectional link information (check hash)
     *  3. update my coordinates
     */
  
    event message_t* S4StateReceive.receive(message_t* rcvMsg, void* msgPayload, uint8_t payloadLength) {
      message_t* next_receive = rcv_beacon_ptr;
  
      S4BeaconMsg * rcv_bvr_msg = (S4BeaconMsg*)&rcvMsg->data[0];
      uint8_t neighbor;
      bool quality;
  
      rcv_beacon_ptr = (void*)0; //to guarantee that it breaks if there is a logical error
  
      dbg("S4-state-func","S4StateReceive$receive: %p (rcv_beacon_ptr:%p)08\n",rcvMsg,rcv_beacon_ptr);
      
#ifdef TOSSIM
      //displayRootBeacons();
#endif

      if (!state_is_active) {
        rcv_beacon_ptr = next_receive;
        return rcvMsg;
      }
      

  
      //drop message which was not for us
      if (call AMPacket.destination(rcvMsg) != call AMPacket.address() &&
          call AMPacket.destination(rcvMsg) != TOS_BCAST_ADDR) {
        rcv_beacon_ptr = next_receive;
        return rcvMsg;
      }
  

      /* added by Feng Wang on Mar 08:
       * also drop message if from a low quality link
       */
      if ((call LinkEstimator.find(rcv_bvr_msg->header.last_hop, &neighbor))!=SUCCESS) {
        rcv_beacon_ptr = next_receive;
        return rcvMsg;
      }
      
            

      if (call LinkEstimator.goodBidirectionalQuality(neighbor,&quality) != SUCCESS) 
        quality = FALSE;
        
      if (!quality) {      
        rcv_beacon_ptr = next_receive;
        return rcvMsg;
      }
      
      
  
      if (!rcv_buffer_busy) {
        post processMessage();
        rcv_beacon_ptr = rcvMsg;
        rcv_buffer_busy = TRUE;
        dbg(DBG_USR2,"S4StateM$S4StateReceive$receive: posting processMessage, rcv_beacon_ptr:%p\n",
            rcv_beacon_ptr);
      } else {
        //drop message, buffer is busy
        dbg(DBG_USR2,"Failure: S4StateM$S4StateReceive$receive:dropping message, busy processing\n");
        rcv_beacon_ptr = next_receive;
        next_receive = rcvMsg;
      }
      dbg(DBG_USR2,"S4StateReceive$receive: returning %p\n",next_receive);
      return next_receive;
    }
  
  
    //added by Feng Wang
  
    event void BeaconUpdateTimer.fired() {
      int32_t jitter;
      uint32_t interval;
  
      int i;
  #ifdef RELIABLE_BCAST
      
      uint8_t n_ngb;
  #ifdef TOSSIM
      int curTime = sim_time();
  #else
      uint32_t curTime = call Time.getLow32();
  #endif
  #endif
  
  
      jitter = ((call Random.rand32()) % (b_timer_jit>>2)) - (b_timer_jit >> 3);
      interval = update_int + jitter;
      call Leds.led1Toggle();
      call BeaconUpdateTimer.startOneShot(interval);
  
  #ifndef CHECK_LINK
      beacon_round++;
      if (beacon_round > MAX_BEACON_ROUND) {
        call BeaconUpdateTimer.stop();
  
        //added by Feng Wang, to start the ClusterTimer
  #ifdef CRROUTING
        i = coordinates_get_closest_beacon(&my_coords);
        //if this is the first global beacon message, start ClusterTimer.
        //and only start if we are not a landmark
        if (first_global_beacon && 
            i != INVALID_COMPONENT && !state_is_root_beacon) {
          first_global_beacon = FALSE;
          dbg(DBG_USR3,"%d Starting ClusterTimer in %d\n",sim_time(),b_timer_int);
  #ifdef SEND_UPDATE_ONLY
          call ClusterTimer.startOneShot(update_int);
  #else
          call ClusterTimer.startOneShot(b_timer_int);
  #endif
  
  #ifdef LOCAL_DV
  #ifdef SEND_UPDATE_ONLY
          //start the first ClusterUpdateTimer after the first ClusterTimer
          dbg(DBG_USR3,"%d Starting ClusterUpdateTimer in %d ms\n",sim_time(),b_timer_int+update_int);
          call ClusterUpdateTimer.startOneShot(update_int*2);
  #endif
  #endif
        }
  #endif
  
      }
  #endif
  
      /* if busy, just wait for next timeout.
       * the only possibility is we are in the 
       * middle of transmitting multiple beacon msgs
       * from BeaconTimer.fired()
       */
      if (beacon_send_busy) {
        return ;
      }
  
  #ifdef RELIABLE_BCAST
  
      call LinkEstimator.getNumGoodLinks(&n_ngb);
      //dbg(DBG_ROUTE,"# of good links: %d\n",n_ngb);
  
      /* first check if any "lost" beacons.
       * we simply set the "bcastlost" flag
       * of the corresponding beacon to 1, so
       * that it'll be caught when scanning
       * the beacon table for retransmission
       */
      for (i=0; i<MAX_PENDING_BEACON; i++) {
        if (pending_beacons[i].occupied) { 
          if (pending_beacons[i].retries > MAX_REBCAST) {
            //too many retries, remove it
  
            pending_beacons[i].occupied = FALSE;
            rootBeacons[pending_beacons[i].beacon_id].bcastlost = 0;
            pending_beacons[i].retries = 0;
            pending_beacons[i].n_rcv = 0;
          } else {
  #ifdef TOSSIM
            if (curTime - pending_beacons[i].sendtime > check_int) {
  #else
            uint8_t t = (uint8_t)(curTime>>10);
            if (t - pending_beacons[i].sendtime > check_int) {
  #endif
            //############# simple heuristics #######################
              uint8_t dist_to_orig = rootBeacons[pending_beacons[i].beacon_id].hops;
              //dbg(DBG_ROUTE,"dist_to_orig %d\n",dist_to_orig);
              if ( (dist_to_orig == 0 && pending_beacons[i].n_rcv < n_ngb) ||
                   (dist_to_orig > 0 && pending_beacons[i].n_rcv*3 < n_ngb) ) {
                   
                uint8_t indx = pending_beacons[i].beacon_id;
                
                rootBeacons[indx].bcastlost = 1;
                pending_beacons[i].retries++;
              } else {
                //received by sufficient neighbors, remove it
  
                pending_beacons[i].occupied = FALSE;
                pending_beacons[i].retries = 0;
                pending_beacons[i].n_rcv = 0;
                rootBeacons[pending_beacons[i].beacon_id].bcastlost = 0;
              }
            } else rootBeacons[pending_beacons[i].beacon_id].bcastlost = 0;
          }
        }
      }
  #endif
  
      /* now scan the beacon table,
       * and retransmit those w/ updated | bcastlost==1.
       * start from setting the first update msg
       */
      set_beacon_update_msg();
      if (curr_bv_size > 0) {
        beacon_send_busy = TRUE;  
  
        post sendBeaconTask();
      } else next_beacon = 0; //RESET to 0!!!!!!!
      return ;
    }
  
    /* 
     * Sets the beacon update message for next sending
     */
    static void set_beacon_update_msg() {
      uint8_t counter = 0;
      S4RootBeacon* b;
   
      while (counter < MAX_BEACON_VECTOR_SIZE && next_beacon < call S4Topology.getRootNodesCount()) {
        b = &rootBeacons[next_beacon];
  
        //fill the vector until full or reaching the end of table
  
  #ifdef RELIABLE_BCAST
        if (b->bcastlost) {
          //dbg(DBG_ROUTE,"%d bcast lost for beacon %d\n",(int)(tos_state.tos_time/4000),next_beacon);
        }
  
        if (b->valid && (b->updated || b->bcastlost)) {
  #else
        if (b->valid && b->updated) {
  #endif
  
          beacon_data_ptr->beacons[counter].hopcount = b->hops;
          beacon_data_ptr->beacons[counter].beacon_id = next_beacon;
          beacon_data_ptr->beacons[counter].seqno = b->last_seqno;
          beacon_data_ptr->beacons[counter].quality = b->combined_quality;
          counter++;
        }
        next_beacon++;
      }
      curr_bv_size = counter;
      if (counter == 0) return;
      if (counter < MAX_BEACON_VECTOR_SIZE) {
        /* need to nullify remaining elements in the vector.
         * can only possibly happen for the last vector
         */
        while (counter < MAX_BEACON_VECTOR_SIZE ) {
          /* assume that no beacon is farther than 255.
           */
          beacon_data_ptr->beacons[counter].hopcount = INVALID_COMPONENT;
          counter++;
        }
      }
    }
  
  #ifdef CRROUTING
  
    command error_t S4Neighborhood.getNextHops(uint16_t dest_addr, uint8_t closest_beacon,
                                                uint16_t* next_hop) {
      int i;
      NextHopTableEntry* nhte;

      //first, check if this dest is stored in routing table
      if (cluster_size > 0) {

#ifdef TOSSIM
        //check if any duplicate entries
        int hit[1000];
        for (i=0;i<1000;i++)
          hit[i] = 0;
  
        dbg(DBG_ROUTE,"cluster routing table:\n");
        for (i=0; i<cluster_size; i++) {
          dbg_clear(DBG_ROUTE,"\t dest: %d, nexthop: %d, hopcount: %d\n",
              ClusterTable[i].dest,ClusterTable[i].parent,ClusterTable[i].hops);
          hit[ClusterTable[i].dest]++;
        }
  
        for (i=0;i<1000;i++)
          if (hit[i] > 1)
            dbg(DBG_ROUTE,"duplicate entries for destination %d\n",i);
#endif
        
        for (i=0; i<cluster_size; i++) {
          if (ClusterTable[i].dest == dest_addr) {
            *next_hop = ClusterTable[i].parent;
            dbg(DBG_ROUTE,"nexthop (from cluster) of %d is %d\n",dest_addr,*next_hop);
            return SUCCESS;
          }
        }
      }

      
  
      //if not in routing table, forward to closest_beacon (of dest) first
      //if I'm the closest_beacon, and dest is not in my routing table, then
      //return FAIL
      /* stupid bug here: closest_beacon is just an index,
       * not the actual id!!!
       * need to carry the id
       */
      
      dbg("S4-beacon", "closest_beacon=%d, bvrtopology.getrootnodescount=%d\n",closest_beacon, 
                                                                               call S4Topology.getRootNodesCount());
      if (closest_beacon == INVALID_COMPONENT ||
          closest_beacon >= call S4Topology.getRootNodesCount()) {
          dbg(DBG_ROUTE,"routing failure: no valid closest beacon\n");
          return FAIL;
      }
      if (rootBeacons[closest_beacon].valid==1) {
        *next_hop = rootBeacons[closest_beacon].parent;
        if (*next_hop == INVALID_NODE_ID) {
          /* no valid parent, 
           * i.e. i'm the closest beacon myself and dest is not in my routing table
           */          
           
          dbg(DBG_ROUTE,"routing failure: no valid parent, broadcasting...\n");          
        }
        dbg(DBG_ROUTE,"nexthop (from closest beacon) of %d is %d (hc %d)\n",closest_beacon,*next_hop,rootBeacons[closest_beacon].hops);
        return SUCCESS;
      }            
  
      //otherwise, routing fails
      dbg(DBG_ROUTE,"routing failure: other reasons\n");
      return FAIL;
    }
  
  #ifdef FAILURE_RECOVERY
    command error_t S4Neighborhood.FR_getNextHops(uint16_t dest_addr, uint8_t closest_beacon,
                                                uint16_t* next_hop, uint8_t* cost_type, uint8_t* cost) {
      int i;
      //first, check if this dest is stored in routing table
      if (cluster_size > 0) {
        
        for (i=0; i<cluster_size; i++) {
          if (ClusterTable[i].dest == dest_addr) {
            *next_hop = ClusterTable[i].parent;
            //dbg(DBG_ROUTE,"nexthop of %d is %d\n",dest_addr,*next_hop);
            *cost_type = 1;
            *cost = ClusterTable[i].hops;
            return SUCCESS;
          }
        }
      }
  
      //if not in routing table, forward to closest_beacon (of dest) first
      //if I'm the closest_beacon, and dest is not in my routing table, then
      //return FAIL
      /* stupid bug here: closest_beacon is just an index,
       * not the actual id!!!
       * need to carry the id
       */

  
      if (closest_beacon == INVALID_COMPONENT ||
          closest_beacon >= call S4Topology.getRootNodesCount()) {
          dbg(DBG_ROUTE,"routing failure: no valid closest beacon\n");
          return FAIL;
      }
      if (rootBeacons[closest_beacon].valid==1) {
        *next_hop = rootBeacons[closest_beacon].parent;
        if (*next_hop == INVALID_NODE_ID) {
          /* no valid parent, 
           * i.e. i'm the closest beacon myself and dest is not in my routing table
           */
          dbg(DBG_ROUTE,"routing failure: no valid parent\n");
          return FAIL;
        }
        //dbg(DBG_ROUTE,"nexthop of %d is %d (hc %d)\n",rootBeacons[closest_beacon].nodeid,*next_hop,rootBeacons[closest_beacon].hops);
        *cost_type = 0;
        *cost = rootBeacons[closest_beacon].hops;
        return SUCCESS;
      }
  
      //otherwise, routing fails
      dbg(DBG_ROUTE,"routing failure: other reasons\n");
      return FAIL;
    }
  #endif
  
  #endif
  
  #ifdef LOCAL_DV
    //if using local distance vector
  
    static void init_cluster_msg() {
      cluster_msg_ptr = (DVMsg*) &cluster_buf.data[0];
      cluster_data_ptr = (DVMsgData*) &cluster_msg_ptr->type_data;
      return ;
    }
  
    /* 
     * Sets the dv message for next sending
     */
    static void set_cluster_msg() {
      uint8_t counter = 0;
   
      //generate a distance vector
      while (counter < MAX_VECTOR_SIZE && next_dv < cluster_size) {
        //fill the vector until full or reaching the end of table
        if (ClusterTable[next_dv].valid &&
            ClusterTable[next_dv].hops < ClusterTable[next_dv].scope) {
          cluster_data_ptr->dv_adv[counter].indx = next_dv;
          cluster_data_ptr->dv_adv[counter].source = ClusterTable[next_dv].dest;
          cluster_data_ptr->dv_adv[counter].hopcount = ClusterTable[next_dv].hops;
          cluster_data_ptr->dv_adv[counter].scope = ClusterTable[next_dv].scope;
          cluster_data_ptr->dv_adv[counter].seqno = ClusterTable[next_dv].last_seqno;
          counter++;
        }
        next_dv++;
      }
      curr_dv_size = counter;
      if (counter == 0) return;
      if (counter < MAX_VECTOR_SIZE) {
        /* need to nullify remaining elements in the vector.
         * can only possibly happen for the last vector
         */
        while (counter < MAX_VECTOR_SIZE ) {
          /* assume that nobody can have a scope of 255.
           * is it realistic to have a "bunch" of scope 255?
           */
          cluster_data_ptr->dv_adv[counter].scope = INVALID_COMPONENT;
          counter++;
        }
      }
    }
   
    /* This task processes received distance vector messages.
     */
    task void processDVMessage() {
      /* will work from rcv_cluster_ptr */
      bool found = FALSE;
      DVMsg * rcv_dv_msg = (DVMsg*)&rcv_cluster_ptr->data[0];
      DVMsgData * rcv_dv_data_ptr = (DVMsgData*)&rcv_dv_msg->type_data;
      int i, src_index;
      int first_invalid;
  
      bool stored;
      uint16_t source;
      uint8_t hopcount;    
      uint8_t scope;    
      uint8_t seqno;
      uint8_t neighbor;
      //maoy: comment it out
      //uint8_t quality = 0;
  
  #ifdef RELIABLE_BCAST
      uint8_t n_ngb;
      call LinkEstimator.getNumGoodLinks(&n_ngb);
  #endif
      

      if (!rcv_clusterbuffer_busy) {
        dbg(DBG_ROUTE,"Assertion failed: rcv_clusterbuffer_busy should be true!!\n");
        
      }
      
      dbg(DBG_ROUTE,"processing DVMessage\n");
  
      if ((call LinkEstimator.find(rcv_dv_msg->header.last_hop, &neighbor))==SUCCESS)
        found = TRUE;
      else 
        found = FALSE;
  
      if (found) {
        //the neighbor exists in the link info cache
  
  
        //discard message from ourselves
        if (rcv_dv_msg->header.last_hop == call AMPacket.address()) {
          //this will not actually happen
          dbg(DBG_ROUTE,"Received distance vector from myself, discarding\n");
        } else {
          uint8_t counter = 0;  //start from the first element in the vector
          while (counter < MAX_VECTOR_SIZE && 
                 rcv_dv_data_ptr->dv_adv[counter].scope != INVALID_COMPONENT ) {
  
            source = rcv_dv_data_ptr->dv_adv[counter].source;
            hopcount = rcv_dv_data_ptr->dv_adv[counter].hopcount;
            scope = rcv_dv_data_ptr->dv_adv[counter].scope;
            seqno = rcv_dv_data_ptr->dv_adv[counter].seqno;
            counter++;
            if (source != call AMPacket.address()) {
              if (scope <= hopcount ) {
                //shouldn't happen
                dbg(DBG_ROUTE,"receive a dv with scope<=hopcount\n");
                continue;
              }
  
              //still inside the "bunch"
  
              //first, check if this source is stored in table
              stored = FALSE;
              first_invalid = cluster_size;
              if (cluster_size > 0) {
                for (i=0; i<cluster_size; i++) {
                  if (!ClusterTable[i].valid && first_invalid == cluster_size)
                    first_invalid = i;
                  if (ClusterTable[i].valid && ClusterTable[i].dest == source) {
                    src_index = i;
                    stored = TRUE;
                    break;
                  }
                }
              }
  
              if (!stored) {  //a new source, need a new entry
                if (cluster_size >= MAX_CLUSTER_SIZE && first_invalid == cluster_size) {
                  /* a better action:
                   * replace out an older entry  with the largest hopcount
                   */
                  int largestHopCount=0, largestHopCountPos=0; 
                   
                  dbg(DBG_ROUTE,"Failure: %d exceeds max cluster table size (%d), Finding new invalid\n",cluster_size,MAX_CLUSTER_SIZE);
                  //continue;
                  
                  
                  for (i=0; i<cluster_size; i++) {
		    
		    if (ClusterTable[i].valid && ClusterTable[i].hops > largestHopCount) {
		      largestHopCountPos = i;
		      largestHopCount = ClusterTable[i].hops;		      
		    }
                  }
                  
                  if (largestHopCount >= hopcount   )
                    first_invalid = largestHopCountPos;
                  else
                    continue;

                    
                  dbg(DBG_ROUTE,"Found new invalid %d for %d\n", first_invalid, source);
                    
                }
  
                //dbg(DBG_ROUTE,"add a new routing entry for destination %d\n",source);
  
                ClusterTable[first_invalid].valid = 1;
                ClusterTable[first_invalid].dest = source;
                ClusterTable[first_invalid].parent = rcv_dv_msg->header.last_hop;
                ClusterTable[first_invalid].last_seqno = seqno;
                ClusterTable[first_invalid].updated = 1;
                ClusterTable[first_invalid].hops = hopcount+1;
                ClusterTable[first_invalid].scope = scope;
                //maoy comment it out
                //ClusterTable[first_invalid].combined_quality = quality;
  #ifdef RELIABLE_BCAST
                ClusterTable[first_invalid].bcastlost = 1;
  #endif
                if (first_invalid == cluster_size)
                  cluster_size++;
  #if 0
              } else if ( seqno > ClusterTable[src_index].last_seqno ||
                          (seqno == ClusterTable[src_index].last_seqno &&
                           hopcount+1 < ClusterTable[src_index].hops) ) {
  #endif
              } else {
  
  #ifdef RELIABLE_BCAST
                //only make sense to check for those already stored
                if ( (is_within_range(seqno, ClusterTable[src_index].last_seqno) || (seqno == ClusterTable[src_index].last_seqno)) && (hopcount <= ClusterTable[src_index].hops+1) ) {
                  for (i=0; i<MAX_PENDING_DV; i++) {
                    if (pending_dvs[i].occupied) {
                      if (source == ClusterTable[pending_dvs[i].indx].dest) {
                        /* it's surely from a different neighbor,
                         * since if having already received,
                         * a neighbor wouldn't re-broadcast in a same dv round
                         */
                        pending_dvs[i].n_rcv++;
  
                        //dbg(DBG_ROUTE,"%d increment n_rcv to %d (n_ngb %d) for dv %d\n",(int)(tos_state.tos_time/4000),
                        //               pending_dvs[i].n_rcv,n_ngb,source);
  
                        if (pending_dvs[i].n_rcv >= n_ngb) {
                          pending_dvs[i].occupied = FALSE;
                          ClusterTable[src_index].bcastlost = 0;
                          pending_dvs[i].n_rcv = 0;
                          pending_dvs[i].retries = 0;
                        }
                        break;
                      }
                    }
                  }
                }
  #endif
  
                if ( is_greater_by_2(seqno, ClusterTable[src_index].last_seqno) ||
                     ( is_within_2(seqno,ClusterTable[src_index].last_seqno) && (hopcount+1 <= ClusterTable[src_index].hops) ) ||
                     ( (seqno == ClusterTable[src_index].last_seqno) && (hopcount+1 < ClusterTable[src_index].hops) ) ) {
  
                  //dbg(DBG_ROUTE,"replace an existing routing entry for destination %d\n",source);
   
                  //a newer dv or equally new but shorter path
                  ClusterTable[src_index].parent = rcv_dv_msg->header.last_hop;
                  ClusterTable[src_index].last_seqno = seqno;
                  if (ClusterTable[src_index].hops != hopcount+1)
                    ClusterTable[src_index].updated = 1;
                  ClusterTable[src_index].hops = hopcount+1;
                  ClusterTable[src_index].scope = scope;
                  //maoy comment it out
                  //ClusterTable[src_index].combined_quality = quality;
                }
              } // if (!stored)  
            } // if source of this entry is not myself
          } // while loop over the elements
  
  #ifdef FLOOD_DV_ONCE
          /* need to check if this is the first dv,
           * if yes, must start a ClusterUpdateTimer to propagate it
           */
          if (!clusterupdatetimer_started) {
            uint16_t delay = call Random.rand32() % delay_timer_jit + 1;
            //dbg(DBG_ROUTE,"%d starting ClusterUpdateTimer in %d ms\n",(int)(tos_state.tos_time/4000),delay);
            call ClusterUpdateTimer.startOneShot(delay);
            clusterupdatetimer_started = TRUE;
          }
  #endif 
  
        } //if from myself (shouldn't happen at all)
  
      } //if found in LinkTable. Ignore if not found
      //else {
      //  dbg(DBG_ROUTE,"%d not found %d in linkTable\n", (int)(tos_state.tos_time/4000), rcv_dv_msg->header.last_hop);
      //}
      rcv_clusterbuffer_busy = FALSE; 
    } //end processDVMessage
  
    //periodically send cluster beacons
    event void ClusterTimer.fired() {
      int i;
  
  #ifndef FLOOD_DV_ONCE  
      int32_t jitter;
      uint32_t interval;
  
      jitter = ((call Random.rand32()) % (b_timer_jit>>2)) - (b_timer_jit >> 3);
      interval = b_timer_int + jitter;
      call ClusterTimer.startOneShot(interval);
  #endif
  
  #ifndef CHECK_LINK
      dv_round++;
      dbg("BVR", "%d\n", dv_round);
      if (dv_round > MAX_DV_ROUND && call S4Topology.getRootNodesCount() >= MAX_ROOT_BEACONS)
        call ClusterTimer.stop();
  #endif
  
      /* if busy, just wait for next timeout.
       * the only possibility is we are in the
       * middle of transmitting multiple dv update msgs
       * from ClusterUpdateTimer.fired()
       */
      if (cluster_send_busy) {
        //dbg(DBG_ROUTE,"%d in ClusterTimer: cluster_send_busy is TRUE\n",(int)(tos_state.tos_time/4000));
        return ;
      }
  
      //set my own scope
      if (current_scope == INVALID_COMPONENT || scope_age > SCOPE_LIFETIME) {
        i = coordinates_get_closest_beacon(&my_coords);
        if (i == INVALID_COMPONENT || my_coords.comps[i] == 0) {
          //should not happen
          dbg(DBG_ROUTE,"no closest beacon, something is wrong\n");
          current_scope = INVALID_COMPONENT;
          return;
        }
        scope_age = 1;
        current_scope = my_coords.comps[i];
        ClusterTable[0].scope = my_coords.comps[i];
  
        //for testing only
        if (largest_scope < current_scope)
          largest_scope = current_scope;
      } else scope_age++;
  
      //##############TO ADD######################
      /* code to delete old entries 
       * by checking the "age" field for each entry.
       * for simplicity, we could just set valid=0.
       * the problem is, whether the total number of valid and
       * invalid entries will exceed max table size.
       * to handle this, we can reuse invalid entries when 
       * inserting a new valid entry.
       * NOTE: never delete the dummy entry for myself (at index=0)
       */
  
  
 
  
      if (next_dv == 0) {
        //we can start a new round of transmitting distance vectors to neighbors.
  
        //increment my own seqno
        //changed by Feng Wang on Mar 14,
        //use the same seqno during the same PERIOD
  #ifndef SAME_SEQNO
        ClusterTable[0].last_seqno = cluster_seqno++;
  #else
        ClusterTable[0].last_seqno = cluster_seqno;
  #endif
  
        set_cluster_msg();  //sets the first dv message for sending 
  
        /* send first dv to neighbors.
         * others are sent later successively upon sendDone().
         * don't need to check curr_dv_size, since for the first dv,
         * it should be guaranteed that curr_dv_size>0
         */
        if (curr_dv_size>0) {
          cluster_send_busy = TRUE;
          post sendClusterTask();
        } else next_dv = 0;

  
      }
  
      return;
    }
  
    event void ClusterRetransmitTimer.fired() {
      /* need TO ADD a retransmission counter
       * abort if exceeding the max number of retransmissions
       */
      post sendClusterTask();
    }
  
    task void sendClusterTask() {
  
  #ifdef RELIABLE_BCAST
      int i,j,indx;
      uint8_t n_ngb;
      uint16_t src_id;
  #ifdef TOSSIM
      int curTime = sim_time();
  #else
      uint32_t curTime = call Time.getLow32();
  #endif
  #endif
  
  
     dbg(DBG_ROUTE,"sendClusterTask: bcast dv.\n");
 
  
      //count dv traffic overhead
      sent_dv += curr_dv_size*sizeof(DVInfo);
  
      if (call ClusterAMSend.send(TOS_BCAST_ADDR,  &cluster_buf, cluster_msg_length) == SUCCESS) {
        dbg(DBG_ROUTE,"ClusterAMSend.send successful\n");

        dv_send_retries = 0;
  
  #ifdef RELIABLE_BCAST
  
        // first, remove entries received by sufficient neighbors
        call LinkEstimator.getNumGoodLinks(&n_ngb);
        for (i=0; i<MAX_PENDING_DV; i++) {
          if (pending_dvs[i].occupied) {
            uint8_t dist_to_orig = ClusterTable[pending_dvs[i].indx].hops;
            //dbg(DBG_ROUTE,"dist_to_orig %d\n",dist_to_orig);
            if ( (dist_to_orig == 0 && pending_dvs[i].n_rcv >= n_ngb) ||
                 (dist_to_orig > 0 && dist_to_orig+1 < ClusterTable[pending_dvs[i].indx].scope && pending_dvs[i].n_rcv*3 > n_ngb) ) {
                 
                 
              pending_dvs[i].occupied = FALSE;
              ClusterTable[pending_dvs[i].indx].bcastlost = 0;
            }
          }
        }
  
        j = 0;
        while (j < MAX_VECTOR_SIZE && 
               cluster_data_ptr->dv_adv[j].scope != INVALID_COMPONENT &&
               cluster_data_ptr->dv_adv[j].scope > cluster_data_ptr->dv_adv[j].hopcount+1) {
          src_id = cluster_data_ptr->dv_adv[j].source;
          indx = -1;
          for (i=0; i<MAX_PENDING_DV; i++) {
            if (pending_dvs[i].occupied &&
                ClusterTable[pending_dvs[i].indx].dest == src_id) {
              indx = i;
              break;
            }
          }
  
          if (indx < 0) { // not found in pending
  
            //dbg(DBG_ROUTE,"%d new pending dv %d ",(int)(tos_state.tos_time/4000),src_id);
  
            for (i=0; i<MAX_PENDING_DV; i++) {
              if (!pending_dvs[i].occupied) {
                indx = i;
                break;
              }
            }
          }
  
          if (indx >= 0 && indx < MAX_PENDING_DV) { //valid index
            //reset for current broadcast session
  
            //dbg_clear(DBG_ROUTE,"entry %d\n",indx);
  
            pending_dvs[indx].occupied = TRUE;
            pending_dvs[indx].indx = cluster_data_ptr->dv_adv[j].indx;
            pending_dvs[indx].n_rcv = 0;
  #ifdef TOSSIM
            pending_dvs[indx].sendtime = curTime;
  #else
            pending_dvs[indx].sendtime = (uint8_t)(curTime>>10);
  #endif
            pending_dvs[indx].retries = 0;
          } else { //pending_dvs table must be full
            //dbg_clear(DBG_ROUTE,"\n");
            //dbg(DBG_ROUTE,"%d pending_dvs is full\n",(int)(tos_state.tos_time/4000));
          }
          j++;
        }
  #endif
  
  #if 0
        cluster_send_busy = TRUE;
  #endif
      } else {
        dv_send_retries++;
        
       dbg(DBG_ROUTE,"%s Failure: send failed for dv!\n",sim_time_string());

        if (dv_send_retries < MAX_BEACON_SEND_RETRIES) {
          //retry
       
          if (next_dv < cluster_size) {  //shouldn't it always be true???
            uint16_t delay = call Random.rand32() % delay_timer_jit + 1;
            dbg(DBG_ROUTE,"%d Retrying\n",sim_time());
            call ClusterRetransmitTimer.startOneShot(delay);
          }
        } else {
          cluster_send_busy = FALSE;
          dv_send_retries = 0;
        }
      }
    }
  
    event void ClusterAMSend.sendDone(message_t* msg, error_t success) {
      dbg(DBG_ROUTE,"NG$ClusterAMSend$SendDone: result=%s\n",(success==SUCCESS)?"ok":"failure");
      if (msg == &cluster_buf) {
  
        int i;
  
  
        //reset updated flag after sending is done
        i = 0;
        while (i < MAX_VECTOR_SIZE && 
               cluster_data_ptr->dv_adv[i].scope != INVALID_COMPONENT) {
          /* potential risk:
           * must guarantee that the value of indx is correct,
           * i.e., the index of an entry is consistent
           * throughout the whole life of this entry
           */
          ClusterTable[cluster_data_ptr->dv_adv[i].indx].updated = 0;
          i++;
        }
               
  #if 0
        dvs_to_send--;
        dbg(DBG_ROUTE, "dvs_to_send reduced to %d\n", dvs_to_send);
        if (dvs_to_send > 0) {
  #endif
        if (next_dv < cluster_size) {
          set_cluster_msg();
          if (curr_dv_size > 0) {
            uint16_t delay = call Random.rand32() % delay_timer_jit + 1;
            call ClusterRetransmitTimer.startOneShot(delay);
          } else {
            if (next_dv < cluster_size) {
              //shouldn't happen
              dbg(DBG_ROUTE, "curr_dv_size is 0, but not the end of cluster table!\n");
              return;
            }
            //reset next_dv index
            next_dv = 0;
            cluster_send_busy = FALSE;
            dv_send_retries = 0;
          }
        } else {
          //reset next_dv index
          next_dv = 0;
          cluster_send_busy = FALSE;
          dv_send_retries = 0;
        }
      }
 	
      return;
    }
  
    event message_t* ClusterReceive.receive(message_t* rcvMsg, void* msgPayload, uint8_t len) {
      message_t* next_receive = rcv_cluster_ptr;
  
      DVMsg * rcv_dv_msg = (DVMsg*)&rcvMsg->data[0];
      uint8_t neighbor;
      bool quality;
  
      rcv_cluster_ptr = (void*)0; //to guarantee that it breaks if there is a logical error
  
      if (!state_is_active) {
        rcv_cluster_ptr = next_receive;
        return rcvMsg;
      }
  

      //drop message which was not for us
      if (call AMPacket.destination(rcvMsg) != call AMPacket.address() &&
          call AMPacket.destination(rcvMsg) != TOS_BCAST_ADDR) {
        rcv_cluster_ptr = next_receive;
        return rcvMsg;
      }
  

      /* added by Feng Wang on Mar 08:
       * also drop message if from a low quality link
       */
      if ((call LinkEstimator.find(rcv_dv_msg->header.last_hop, &neighbor))!=SUCCESS) {
        rcv_cluster_ptr = next_receive;
        return rcvMsg;
      }
  

      if (call LinkEstimator.goodBidirectionalQuality(neighbor,&quality) != SUCCESS) 
        quality = FALSE;
      if (!quality) {
        rcv_cluster_ptr = next_receive;
        return rcvMsg;
      }
  

      if (!rcv_clusterbuffer_busy) {         

        post processDVMessage();
        rcv_cluster_ptr = rcvMsg;
        rcv_clusterbuffer_busy = TRUE;
      } else {
        //drop message, buffer is busy
        dbg(DBG_ROUTE,"Failure: ClusterReceive$receive: dropping message, busy processing\n");
        rcv_cluster_ptr = next_receive;
        next_receive = rcvMsg;
      }
      return next_receive;
    }
  
  #ifdef LOCAL_DV
    event void ClusterUpdateTimer.fired() {
      int32_t jitter;
      uint32_t interval;
  
  #ifdef RELIABLE_BCAST
      uint8_t n_ngb;
      int i;
  #ifdef TOSSIM
      int curTime = sim_time();
  #else
      uint32_t curTime = call Time.getLow32();
  #endif
  #endif
  
      jitter = ((call Random.rand32()) % (b_timer_jit>>2)) - (b_timer_jit >> 3);
      interval = update_int + jitter;
      
      call Leds.led2Toggle();
      call ClusterUpdateTimer.startOneShot( interval);
  
  #ifndef CHECK_LINK
      dv_round++;
      if (dv_round > MAX_DV_ROUND)
        call ClusterUpdateTimer.stop();
  #endif
  
      if (cluster_send_busy) {
        return;
      }
  
      dbg(DBG_ROUTE,"%s ClusterUpdateTimer fired for dv_round=%d\n",sim_time_string(), dv_round);
  
  #ifdef RELIABLE_BCAST
  
      call LinkEstimator.getNumGoodLinks(&n_ngb);
  
      /* first check if any "lost" dvs.
       */
      for (i=0; i<MAX_PENDING_DV; i++) {
        if (pending_dvs[i].occupied) {
          if (pending_dvs[i].retries > MAX_REBCAST) {
            //too many retries, remove it
    
            pending_dvs[i].occupied = FALSE;
            ClusterTable[pending_dvs[i].indx].bcastlost = 0;
            pending_dvs[i].retries = 0;
            pending_dvs[i].n_rcv = 0;
          } else {
  #ifdef TOSSIM
            if (curTime - pending_dvs[i].sendtime > check_int) {
  #else
            uint8_t t = (uint8_t)(curTime>>10);
            if (t - pending_dvs[i].sendtime > check_int) {
  #endif
            //############# simple heuristics #######################
              uint8_t dist_to_orig = ClusterTable[pending_dvs[i].indx].hops;
              
              if ( (dist_to_orig == 0 && pending_dvs[i].n_rcv < n_ngb) ||
                   (dist_to_orig > 0 && dist_to_orig+1 < ClusterTable[pending_dvs[i].indx].scope && pending_dvs[i].n_rcv*3 < n_ngb) ) {
                   
                uint8_t indx = pending_dvs[i].indx;

                ClusterTable[indx].bcastlost = 1;
                pending_dvs[i].retries++;
              } else {
                //received by sufficient neighbors, remove it  
  
                pending_dvs[i].occupied = FALSE;
                pending_dvs[i].retries = 0;
                pending_dvs[i].n_rcv = 0;
                ClusterTable[pending_dvs[i].indx].bcastlost = 0;
              }
            } else ClusterTable[pending_dvs[i].indx].bcastlost = 0;
          }
        }
      }
  #endif
  
      set_dv_update_msg();
      if (curr_dv_size > 0) {
        cluster_send_busy = TRUE;         
  
        post sendClusterTask();
      } else {
        next_dv = 0; //RESET to 0!!!!!!!
      }
      return;
    }
  
    static void set_dv_update_msg() {
      uint8_t counter = 0;
      ClusterMember *b;
  
      while (counter < MAX_VECTOR_SIZE && next_dv < cluster_size) {
        b = &ClusterTable[next_dv];
  
  #ifdef RELIABLE_BCAST
        if (b->valid && b->scope != INVALID_COMPONENT && b->scope > b->hops && (b->updated || (b->bcastlost && b->scope > b->hops+1))) {
  #else
        if (b->valid && b->scope != INVALID_COMPONENT && b->scope > b->hops && b->updated) {
  #endif
          cluster_data_ptr->dv_adv[counter].indx = next_dv;
          cluster_data_ptr->dv_adv[counter].source = b->dest;
          cluster_data_ptr->dv_adv[counter].hopcount = b->hops;
          cluster_data_ptr->dv_adv[counter].seqno = b->last_seqno;
          cluster_data_ptr->dv_adv[counter].scope = b->scope;
          counter++;
        }
        next_dv++;
      }
      curr_dv_size = counter;
      if (counter == 0) return;
      if (counter < MAX_VECTOR_SIZE) {
        while (counter < MAX_VECTOR_SIZE) {
          cluster_data_ptr->dv_adv[counter].scope = INVALID_COMPONENT;
          counter++;
        }
      }
    }
  
  #endif
  
  
  #endif
  
  #ifdef CHECK_LINK
    event void CheckLinkTimer.fired() {
      int i;
      uint8_t neighbor,n_links;
  
      if (cluster_size <= 1)
        //only myself
        return SUCCESS;
  
      /* check whether the parent has failed.
       * the rule is: if link table is not full and
       * the parent is not currently in link table,
       * then we think it fails.
       * if link table is full, we cannot tell for now.
       * need some advanced rules.
       */
      call LinkEstimator.getNumLinks(&n_links);
      if (n_links >= N_CACHE_SIZE) return SUCCESS;
  
      for (i=1; i<cluster_size; i++) {
        if (!ClusterTable[i].valid) continue;
        if ((call LinkEstimator.find(ClusterTable[i].parent, &neighbor))!=SUCCESS) {
          //the next hop is not in link table any more
          dbg(DBG_ROUTE,"ClusterTable[%d]: %d failed\n",i,ClusterTable[i].parent);
          ClusterTable[i].valid = 0;
  #if 0 //ignore quality for now, only deal with node failure
        } else {
          if (call LinkEstimator.goodBidirectionalQuality(neighbor,&quality) != SUCCESS) {
            //cannot get bi-di link quality for this neighbor
            ClusterTable[i].valid = 0;
          } else if (!quality) {
            ClusterTable[i].valid = 0;
          }
  #endif
        } 
      }
  
      for (i=0; i<call S4Topology.getRootNodesCount(); i++) {
        if (i == root_beacon_id || !rootBeacons[i].valid) continue;
        if ((call LinkEstimator.find(rootBeacons[i].parent, &neighbor))!=SUCCESS) {
          dbg(DBG_ROUTE,"rootBeacons[%d]: %d failed\n",i,rootBeacons[i].parent);
          rootBeacons[i].valid = 0;
  #if 0 //ignore quality for now, only deal with node failure
        } else {
          if (call LinkEstimator.goodBidirectionalQuality(neighbor,&quality) != SUCCESS) {
            //cannot get bi-di link quality for this neighbor
            rootBeacons[i].valid = 0;
          } else if (!quality) {
            rootBeacons[i].valid = 0;
          }
  #endif
        } 
      }
  
      return;
    }
  #endif
  
  
      //added by Yun Mao
      command uint16_t RoutingTable.get_routing_table_size() {
          return cluster_size;
      }
      
      command ClusterMember* RoutingTable.get_routing_table(){
          return ClusterTable;
      }
  
      //added by Feng Wang
      command uint16_t S4StateCommand.get_routing_state() {
        uint16_t routing_state = 0;
  
        /* in current implementation, there are bool types.
         */
        //routing_state += call S4Topology.getRootNodesCount() * sizeof(S4RootBeacon);
        routing_state += call S4Topology.getRootNodesCount() * 5;
        //routing_state += cluster_size * sizeof(ClusterMember);
        routing_state += cluster_size * 6;
  
        return routing_state;
      }
      command uint16_t S4StateCommand.get_sent_bv() {
        return sent_bv;
      }
      command uint16_t S4StateCommand.get_sent_dv() {
        return sent_dv;
      }
      
      //added by tahir
      command am_addr_t S4Neighborhood.getClosestBeaconAddr(uint16_t addr) {
        uint8_t original_root_beacon_id[N_NODES];      
        Coordinates coords;
        
        uint8_t closest_beacon;
        uint16_t closestBeaconAddr;
        
        call S4Topology.getRootBeaconIDs(original_root_beacon_id);
        call S4Locator.getCoordinates(&coords);
        closest_beacon = coordinates_get_closest_beacon(&coords);    
        
        if (coords.comps[closest_beacon] >= coords.comps[original_root_beacon_id[addr]] - 1)
          return addr; 
        
        closestBeaconAddr = search( original_root_beacon_id, N_NODES, closest_beacon);
        
        return closestBeaconAddr;
      }
  
  } // end of implementation
   
