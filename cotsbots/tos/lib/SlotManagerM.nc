/*
 * Authors:		Sarah Bergbreiter
 * Date last modified:  10/3/03
 *
 */

/** 
 * SlotManagerM is a tiny OS module.
 * This module maintains a relatively current neighbor list.  
 * A table of neighbors is currently kept using the SlotRing
 * interface and timers are used to broadcast our presence 
 * occasionally as well as check if I have heard from my
 * neighbors recently.
 *
 * @author Sarah Bergbreiter
 **/

includes SlotMsg;
includes TosTime;

module SlotManagerM { 
  provides {
    interface StdControl;
    interface SlotRing;
  }
  uses {
    interface StdControl as CommControl;
    interface SendMsg as Send;
    interface ReceiveMsg as Receive;
    interface ReceiveMsg as ReceiveTick;
    interface StdControl as TimerControl;
    interface Timer as BcastTimer;
    interface Timer as InitTimer;
    interface Timer as CatchUpTimer;
    interface Leds;
  }
}

implementation {

  // Constants
  enum {
    MAX_NEIGHBORS=8,
    MOTE_ID = 0,
    LAST_HEARD = 1,
    INIT_INTERVAL = 6000,
    DEFAULT_SLOT_LENGTH = 250,
    DELETE_THRESHOLD = 10,
    TIMER_SEND_OFFSET = 10,
    TIMER_RECEIVE_OFFSET = 2
  };

  // Neighborhood table variables
  uint8_t mNumNeighbors;
  int16_t mNeighborTable[MAX_NEIGHBORS][2];

  // Slot Length variables
  int16_t slotLength;
  int16_t newTick;
  uint8_t slotNumber;
  bool initTimeOut;

  // TOSMsg variables
  TOS_Msg buf;
  TOS_MsgPtr msg;
  bool pending;

  /** Init Neighbor Table **/
  void initNeighbors() {
    uint8_t i,j;
    dbg(DBG_USR1, "Initialized Neighborhood Table\n");
    atomic {
      mNumNeighbors = 0;
      for(i=0; i < MAX_NEIGHBORS; i++)
	for(j=0; j < 2; j++)
	  mNeighborTable[i][j] = -1;
    }
  }

  /** Count legitimate members in neighbor table **/
  uint8_t countNeighbors() {
    uint8_t i;
    uint8_t count = 0;
    for (i = 0; i < MAX_NEIGHBORS; i++) {
      if (mNeighborTable[i][MOTE_ID] != -1)
	count++;
    }
    return count;
  }

  /** Copy in a new neighbor table **/
  uint8_t copyNeighbors(int16_t* table) {
    uint8_t i;
    for (i = 0; i < MAX_NEIGHBORS; i++) {
      dbg(DBG_USR1, "Copying: Index = %d, MoteID = %d, New MoteID = %d\n", i, mNeighborTable[i][MOTE_ID], table[i]);
      if (mNeighborTable[i][MOTE_ID] != table[i]) {
	// Don't remove myself!
	//if (mNeighborTable[i][MOTE_ID] != TOS_LOCAL_ADDRESS) {
	mNeighborTable[i][MOTE_ID] = table[i];
	mNeighborTable[i][LAST_HEARD] = 0;
	//}
      }
    }
    return countNeighbors();
  }

  /** Return index of id in table **/
  int8_t findID(int16_t id) {
    int i;
    for (i = 0; i < mNumNeighbors; i++) {
      if (mNeighborTable[i][MOTE_ID] == id)
	return i;
    }
    return -1;
  }

  void addNeighbor(int16_t id) {
    dbg(DBG_USR1, "Added Neighbor %d\n", id);
    atomic {
      mNumNeighbors++;
      mNeighborTable[mNumNeighbors-1][MOTE_ID] = id;
      mNeighborTable[mNumNeighbors-1][LAST_HEARD] = 0;
      
      if (mNumNeighbors > MAX_NEIGHBORS-1) 
	mNumNeighbors = MAX_NEIGHBORS-1;
    }
  }

  void removeNeighbor(int8_t i) {
    dbg(DBG_USR1, "Removed Neighbor %d\n", mNeighborTable[i][MOTE_ID]);
    atomic {
      mNumNeighbors--;
      mNeighborTable[i][MOTE_ID] = mNeighborTable[mNumNeighbors][MOTE_ID];
      mNeighborTable[i][LAST_HEARD] = mNeighborTable[mNumNeighbors][LAST_HEARD];
      mNeighborTable[mNumNeighbors][MOTE_ID] = -1;
      mNeighborTable[mNumNeighbors][LAST_HEARD] = -1;
    }
  }

  /** 
   * Initialization for the application:
   *  1. Initialize module static variables
   *  2. Initialize timer and comm control components;
   *  @return Returns <code>SUCCESS</code> or <code>FAILED</code>
   **/
  command result_t StdControl.init() {
    atomic {
      msg = &buf;
      pending = FALSE;
      initTimeOut = TRUE;
      slotLength = DEFAULT_SLOT_LENGTH;
      slotNumber = 0;
      newTick = -1;
      initNeighbors();
    }
    return rcombine(call TimerControl.init(), call CommControl.init());
  }

  /** start application and init timer **/
  command result_t StdControl.start(){
    if (newTick > 0)
      slotLength = newTick;
    call InitTimer.start(TIMER_ONE_SHOT, 2*slotLength);
    call Leds.yellowOn();
    return call CommControl.start();
  }

  /** stop application **/
  command result_t StdControl.stop(){
    call BcastTimer.stop();
    return call CommControl.stop();
  } 

  /** build and send a slot message **/
  void sendMessage(uint8_t toSync) {
    SlotMsg *message = (SlotMsg *)msg->data;
    uint8_t i;
    dbg(DBG_USR1, "Mote %d is sending a slot message\n", TOS_LOCAL_ADDRESS);

    message->src = TOS_LOCAL_ADDRESS;
    if (toSync == 1) {
      message->sync = 1;
      call BcastTimer.stop();
      call CatchUpTimer.start(TIMER_ONE_SHOT, slotLength + TIMER_SEND_OFFSET);
    } else {
      message->sync = 0;
    }
    message->tickLength = slotLength;
    for (i = 0; i < MAX_NEIGHBORS; i++)
      message->table[i] = mNeighborTable[i][MOTE_ID];
    if (!pending) {
      if (call Send.send(TOS_BCAST_ADDR, sizeof(SlotMsg), msg))
	pending = TRUE;
      else
	pending = FALSE;
    }
  }

  /** init timer fires -- add myself to the neighbor table and broadcast if
                          we timed out **/
  event result_t InitTimer.fired() {
    dbg(DBG_USR1, "Init Timer has fired for mote %d\n", TOS_LOCAL_ADDRESS);
    if (initTimeOut) {
      addNeighbor(TOS_LOCAL_ADDRESS);
      sendMessage(1);
      //call BcastTimer.start(TIMER_REPEAT, slotLength);
      call Leds.yellowOff();
    }
    initTimeOut = FALSE;
    return SUCCESS;
  }

  /** catchup timer fires -- restart bcast timer with appropriate tick **/
  /** length. **/
  event result_t CatchUpTimer.fired() {
    int16_t mySlot = findID(TOS_LOCAL_ADDRESS);
    uint8_t i;

    dbg(DBG_USR1, "Mote %d CatchUp Timer fired.\n", TOS_LOCAL_ADDRESS);

    // check if I have a new tick length
    if (newTick != -1) {
      slotLength = newTick;
      newTick = -1;
    }

    // restart bcast timer
    call BcastTimer.start(TIMER_REPEAT, slotLength);

    // increment slotNumber
    //if (slotNumber == mySlot) signal SlotRing.endSlotPeriod(slotNumber);
    signal SlotRing.endSlotPeriod(slotNumber);
    atomic {
      slotNumber++;
      if (slotNumber > mNumNeighbors)
	slotNumber = 0;
    }
    if (slotNumber & 0x01) call Leds.redOn();
    else call Leds.redOff();

    // if this is my slot number, send announce message
    // otherwise, do some upkeep and update neighborhood table
    if (slotNumber == mySlot) {
      dbg(DBG_USR1, "Slot on Mote %d...\n", TOS_LOCAL_ADDRESS);
      if (mySlot == 0)
	sendMessage(1);
      else
	sendMessage(0);
    } else {
      atomic {
	mNeighborTable[mySlot][LAST_HEARD] = 0;
	for (i = 0; i < mNumNeighbors; i++) {
	  if (mNeighborTable[i][LAST_HEARD]++ > DELETE_THRESHOLD)
	    removeNeighbor(i);
	}
      }
    }
    return SUCCESS;
  }

  /** bcast timer fires -- check if it is my slot and send message **/
  /** Later I might only want to broadcast if I'm the first dude in **/
  /** the ring. **/
  event result_t BcastTimer.fired() {
    int16_t mySlot = findID(TOS_LOCAL_ADDRESS);
    uint8_t i;

    dbg(DBG_USR1, "Mote %d Bcast Timer fired.\n", TOS_LOCAL_ADDRESS);
    dbg(DBG_USR1, "Mote %d thinks there are %d nodes in the network.\n", TOS_LOCAL_ADDRESS, mNumNeighbors);

    // check if I have a new tick length -- if so, restart Bcast timer
    if (newTick != -1) {
      slotLength = newTick;
      newTick = -1;
      call BcastTimer.stop();
      call BcastTimer.start(TIMER_REPEAT, slotLength);
    }

    // increment slotNumber
    //if (slotNumber == mySlot) signal SlotRing.endSlotPeriod(slotNumber);
    signal SlotRing.endSlotPeriod(slotNumber);
    atomic {
      slotNumber++;
      if (slotNumber > mNumNeighbors)
	slotNumber = 0;
    }
    if (slotNumber & 0x01) call Leds.redOn();
    else call Leds.redOff();

    // if this is my slot number, send announce message
    // otherwise, do some upkeep and update neighborhood table
    if (slotNumber == findID(TOS_LOCAL_ADDRESS)) {
      dbg(DBG_USR1, "Slot on Mote %d...\n", TOS_LOCAL_ADDRESS);
      if (mySlot == 0)
	sendMessage(1);
      else
	sendMessage(0);
    } else {
      atomic {
	mNeighborTable[mySlot][LAST_HEARD] = 0;
	for (i = 0; i < mNumNeighbors; i++) {
	  if (mNeighborTable[i][LAST_HEARD]++ > DELETE_THRESHOLD)
	    removeNeighbor(i);
	}
      }
    }

    return SUCCESS;
  }

  /** send done -- reset pending **/
  /** signal startSlotPeriod here so that upper level application can **/
  /** use this time to send data if desired (and doesn't conflict with **/
  /** this send **/
  event result_t Send.sendDone(TOS_MsgPtr m, result_t success) {
    if (pending && (m == msg))
      pending = FALSE;
    signal SlotRing.startSlotPeriod(slotNumber);
    return success;
  }

  /** tick message received -- set new tick variable to change clock tick on **/
  /** next clock firing **/
  event TOS_MsgPtr ReceiveTick.receive(TOS_MsgPtr m) {
    NewTickMsg *message = (NewTickMsg *)m->data;
    newTick = message->tickLength;
    return m;
  }

  /** message received -- update the neighborhood table **/
  /** if initTimeOut is true, still initializing so set to false, stop initTimer, **/
  /** and add myself to end of table **/
  /** always copy the table in the message to my own table **/
  event TOS_MsgPtr Receive.receive(TOS_MsgPtr m) {
    SlotMsg *message = (SlotMsg *)m->data;
    int8_t sourceIndex;
    int8_t myIndex;

    dbg(DBG_USR1, "Mote %d heard mote %d\n", TOS_LOCAL_ADDRESS, message->src);

    if (initTimeOut) {
      call InitTimer.stop();
      initTimeOut = FALSE;
      call Leds.yellowOff();
    }

    // Sync Clocks
    if (slotLength != message->tickLength) {
      newTick = message->tickLength;
      slotLength = newTick;
    }
    atomic {
      mNumNeighbors = copyNeighbors((int16_t*)message->table);
    }      

    // Add myself to table if I'm not in it
    sourceIndex = findID(message->src);
    slotNumber = sourceIndex;
    myIndex = findID(TOS_LOCAL_ADDRESS);
    if (myIndex == -1) {
      addNeighbor(TOS_LOCAL_ADDRESS);
      //sendMessage(0);
      call BcastTimer.start(TIMER_REPEAT, slotLength);
    }

    if (message->sync == 1) {
      dbg(DBG_USR1, "Mote %d is syncing its clock\n", TOS_LOCAL_ADDRESS);
      slotNumber = 0;
      call BcastTimer.stop();
      call CatchUpTimer.start(TIMER_ONE_SHOT, slotLength - TIMER_RECEIVE_OFFSET);
    }

    // Update the LAST_HEARD field for the mote I just heard from
    if (sourceIndex != -1)
      mNeighborTable[sourceIndex][LAST_HEARD] = 0;

    return m;
  }

  /** add a neighbor to the table **/
  command result_t SlotRing.addNeighbor(int16_t id) {
    addNeighbor(id);
    return SUCCESS;
  }

  /** remove a neighbor from the table **/
  command result_t SlotRing.removeNeighbor(int16_t id) {
    int8_t i = findID(id);
    if (i == -1) {
      return FAIL;
    } else {
      removeNeighbor(i);
    }
    return SUCCESS;
  }

  /** check if neighbor is in table **/
  command int8_t SlotRing.isNeighbor(int16_t id) {
    return findID(id);
  }

  /** return total number of neighbors **/
  command uint8_t SlotRing.numNeighbors() {
    return mNumNeighbors;
  }

  /** clear the neighbor table **/
  command result_t SlotRing.clearNeighbors() {
    initNeighbors();
    return SUCCESS;
  }

  /** copy neighbor table **/
  command result_t SlotRing.copyNeighbors(int16_t* neighbors) {
    atomic {
      mNumNeighbors = copyNeighbors(neighbors);
    }
    return SUCCESS;
  }

  /** set slot length **/
  command result_t SlotRing.setTickLength(int16_t tickLength) {
    newTick = tickLength;
    return SUCCESS;
  }    

  /** signaled when slot period is beginning **/
  default event result_t SlotRing.startSlotPeriod(uint8_t slotNum) { return FAIL; }

  /** signaled when slot period is over **/
  default event result_t SlotRing.endSlotPeriod(uint8_t slotNum) { return FAIL; }

} // end of implementation
