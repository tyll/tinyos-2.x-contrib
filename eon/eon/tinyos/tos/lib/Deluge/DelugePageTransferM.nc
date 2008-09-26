// $Id$

/*									tab:2
 *
 *
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
 */

/**
 * @author Jonathan Hui <jwhui@cs.berkeley.edu>
 */

module DelugePageTransferM {
  provides {
    interface StdControl;
    interface DelugePageTransfer as PageTransfer;
  }
  uses {
    interface BitVecUtils;
    interface DelugeDataRead as DataRead;
    interface DelugeDataWrite as DataWrite;
    interface DelugeStats;
    interface Leds;
    interface Random;
    interface ReceiveMsg as ReceiveDataMsg;
    interface ReceiveMsg as ReceiveReqMsg;
    interface SendMsg as SendDataMsg;
    interface SendMsg as SendReqMsg;
    interface SharedMsgBuf;
    interface Timer;
  }
}

implementation {

  // send/receive page buffers, and state variables for buffers
  uint8_t  pktsToSend[DELUGE_PKT_BITVEC_SIZE];    // bit vec of packets to send
  uint8_t  pktsToReceive[DELUGE_PKT_BITVEC_SIZE]; // bit vec of packets to receive

  DelugeDataMsg rxQueue[DELUGE_QSIZE];
  uint8_t head, size;

  // state variables
  uint8_t  state;
  imgnum_t workingImgNum;
  pgnum_t  workingPgNum;
  uint16_t nodeAddr;
  uint8_t  remainingAttempts;
  bool     suppressReq;
  uint8_t  imgToSend;
  uint8_t  pageToSend;

  enum {
    S_DISABLED,
    S_IDLE,     
    S_TX_LOCKING,
    S_SENDING,
    S_RX_LOCKING,
    S_RECEIVING,
  };

  void changeState(uint8_t newState) {
    
    if ((newState == S_DISABLED || newState == S_IDLE)
	&& (state == S_SENDING || state == S_RECEIVING))
      call SharedMsgBuf.unlock();

    state = newState;
    
  }

  command result_t StdControl.init() {
    changeState(S_DISABLED);
    workingImgNum = DELUGE_INVALID_IMGNUM;
    workingPgNum = DELUGE_INVALID_PGNUM;
    return SUCCESS;
  }

  command result_t StdControl.start() {
    changeState(S_IDLE);
    return SUCCESS;
  }

  command result_t StdControl.stop() {
    changeState(S_DISABLED);
    return SUCCESS;
  }

  command result_t PageTransfer.setWorkingPage(imgnum_t imgNum, pgnum_t pgNum) {
    workingImgNum = imgNum;
    workingPgNum = pgNum;
    memset(pktsToReceive, 0xff, DELUGE_PKT_BITVEC_SIZE);
    return SUCCESS;
  }

  command bool PageTransfer.isTransferring() {
    return (state != S_IDLE && state != S_DISABLED);
  }

  void startReqTimer(bool first) {
    uint32_t delay;
    if (first)
      //delay = DELUGE_MIN_DELAY + (call Random.rand() % DELUGE_MAX_REQ_DELAY);
	  delay = DELUGE_MIN_DELAY;
    else
      delay = DELUGE_NACK_TIMEOUT + (call Random.rand() % DELUGE_NACK_TIMEOUT);
	
	  
    call Timer.start(TIMER_ONE_SHOT, delay);
  }

  command result_t PageTransfer.dataAvailable(uint16_t sourceAddr, imgnum_t imgNum) {

    if ( state == S_IDLE && workingImgNum == imgNum ) {
      // currently idle, so request data from source
      changeState(S_RX_LOCKING);
      nodeAddr = sourceAddr;
      remainingAttempts = DELUGE_MAX_NUM_REQ_TRIES;
      suppressReq = FALSE;
      
      // randomize request to prevent collision
      startReqTimer(TRUE);
    }

    return SUCCESS;

  }

  block_addr_t calcOffset(pgnum_t pgNum, uint8_t pktNum) {
    return (block_addr_t)pgNum*(block_addr_t)DELUGE_BYTES_PER_PAGE
      + (uint16_t)pktNum*(uint16_t)DELUGE_PKT_PAYLOAD_SIZE
      + DELUGE_METADATA_SIZE;
  }
  
  void setupReqMsg() {

    TOS_MsgPtr pMsgBuf = call SharedMsgBuf.getMsgBuf();
    DelugeReqMsg* pReqMsg = (DelugeReqMsg*)(pMsgBuf->data);

    if ( state == S_RX_LOCKING ) {
      if ( call SharedMsgBuf.isLocked() )
	return;
      call SharedMsgBuf.lock();
      changeState(S_RECEIVING);
      pReqMsg->dest = (nodeAddr != TOS_UART_ADDR) ? nodeAddr : TOS_UART_ADDR;
      pReqMsg->sourceAddr = TOS_LOCAL_ADDRESS;
      pReqMsg->imgNum = workingImgNum;
      pReqMsg->vNum = call DelugeStats.getVNum(workingImgNum);
      pReqMsg->pgNum = workingPgNum;
    }

    if (state != S_RECEIVING)
      return;

    // suppress request
    if ( suppressReq ) {
      startReqTimer(FALSE);
      suppressReq = FALSE;
    }
    
    // tried too many times, give up
    else if ( remainingAttempts == 0 ) {
      changeState(S_IDLE);
    }

    // send req message
    else {
      memcpy(pReqMsg->requestedPkts, pktsToReceive, DELUGE_PKT_BITVEC_SIZE);
      if (call SendReqMsg.send(pReqMsg->dest, sizeof(DelugeReqMsg), pMsgBuf) == FAIL)
	startReqTimer(FALSE);
    }

  }

  void writeData() {
    if( call DataWrite.write(workingImgNum, calcOffset(rxQueue[head].pgNum, rxQueue[head].pktNum),
			     rxQueue[head].data, DELUGE_PKT_PAYLOAD_SIZE) == FAIL )
      size = 0;
  }

  void suppressMsgs(imgnum_t imgNum, pgnum_t pgNum) {
    if (state == S_SENDING || state == S_TX_LOCKING) {
      if (imgNum < imgToSend
	  || (imgNum == imgToSend
	      && pgNum < pageToSend)) {
	changeState(S_IDLE);
	memset(pktsToSend, 0x0, DELUGE_PKT_BITVEC_SIZE);
      }
    }
    else if (state == S_RECEIVING || state == S_RX_LOCKING) {
      if (imgNum < workingImgNum
	  || (imgNum == workingImgNum
	      && pgNum <= workingPgNum)) {
	// suppress next request since similar request has been overheard
	suppressReq = TRUE;
      }
    }
  }

  event TOS_MsgPtr ReceiveDataMsg.receive(TOS_MsgPtr pMsg) {

    DelugeDataMsg* rxDataMsg = (DelugeDataMsg*)pMsg->data;

    if ( state == S_DISABLED
	 || rxDataMsg->imgNum >= DELUGE_NUM_IMAGES )
      return pMsg;

    dbg(DBG_USR1, "DELUGE: Received DATA_MSG(vNum=%d,imgNum=%d,pgNum=%d,pktNum=%d)\n",
	rxDataMsg->vNum, rxDataMsg->imgNum, rxDataMsg->pgNum, rxDataMsg->pktNum);

    // check if need to suppress req or data messages
    suppressMsgs(rxDataMsg->imgNum, rxDataMsg->pgNum);

    if ( rxDataMsg->vNum == call DelugeStats.getVNum(rxDataMsg->imgNum)
	 && rxDataMsg->imgNum == workingImgNum
	 && rxDataMsg->pgNum == workingPgNum
	 && BITVEC_GET(pktsToReceive, rxDataMsg->pktNum)
	 && size < DELUGE_QSIZE ) {
      // got a packet we need
      call Leds.set(rxDataMsg->pktNum);
      
      dbg(DBG_USR1, "DELUGE: SAVING(pgNum=%d,pktNum=%d)\n", 
	  rxDataMsg->pgNum, rxDataMsg->pktNum);
      
      // copy data
      memcpy(&rxQueue[head^size], rxDataMsg, sizeof(DelugeDataMsg));
      if ( ++size == 1 ) 
	writeData();
    }

    return pMsg;

  }

  void setupDataMsg() {

    TOS_MsgPtr pMsgBuf = call SharedMsgBuf.getMsgBuf();
    DelugeDataMsg* pDataMsg = (DelugeDataMsg*)(pMsgBuf->data);

    uint16_t nextPkt;

    if (state != S_SENDING && state != S_TX_LOCKING)
      return;
    
    signal PageTransfer.suppressMsgs(imgToSend);

    if ( state == S_TX_LOCKING ) {
      if ( call SharedMsgBuf.isLocked() )
	return;
      call SharedMsgBuf.lock();
      changeState(S_SENDING);
      pDataMsg->vNum = call DelugeStats.getVNum(imgToSend);
      pDataMsg->imgNum = imgToSend;
      pDataMsg->pgNum = pageToSend;
      pDataMsg->pktNum = 0;
    }

    if (!call BitVecUtils.indexOf(&nextPkt, pDataMsg->pktNum, 
				  pktsToSend, DELUGE_PKTS_PER_PAGE)) {
      // no more packets to send
      dbg(DBG_USR1, "DELUGE: SEND_DONE\n");
      changeState(S_IDLE);
    }
    else {
      pDataMsg->pktNum = nextPkt;
      if (call DataRead.read(imgToSend, calcOffset(pageToSend, nextPkt), 
			     pDataMsg->data, DELUGE_PKT_PAYLOAD_SIZE) == FAIL)
	call Timer.start(TIMER_ONE_SHOT, DELUGE_FAILED_SEND_DELAY);
    }

  }

  event result_t Timer.fired() {
    setupReqMsg();
    setupDataMsg();
    return SUCCESS;
  }

  event TOS_MsgPtr ReceiveReqMsg.receive(TOS_MsgPtr pMsg) {

    DelugeReqMsg *rxReqMsg = (DelugeReqMsg*)(pMsg->data);
    imgnum_t imgNum;
    pgnum_t pgNum;
    int i;

    dbg(DBG_USR1, "DELUGE: Received REQ_MSG(dest=%d,vNum=%d,imgNum=%d,pgNum=%d,pkts=%x)\n",
	rxReqMsg->dest, rxReqMsg->vNum, rxReqMsg->imgNum, rxReqMsg->pgNum, rxReqMsg->requestedPkts[0]);

    if ( state == S_DISABLED
	 || rxReqMsg->imgNum >= DELUGE_NUM_IMAGES )
      return pMsg;

    imgNum = rxReqMsg->imgNum;
    pgNum = rxReqMsg->pgNum;
    
    // check if need to suppress req or data msgs
    suppressMsgs(imgNum, pgNum);

    // if not for me, ignore request
    if ( rxReqMsg->dest != TOS_LOCAL_ADDRESS
	 || rxReqMsg->vNum != call DelugeStats.getVNum(imgNum)
	 || pgNum >= call DelugeStats.getNumPgsComplete(imgNum) )
      return pMsg;

    if ( state == S_IDLE
	 || ( (state == S_SENDING || state == S_TX_LOCKING)
	      && imgNum == imgToSend
	      && pgNum == pageToSend ) ) {
      // take union of packet bit vectors
      for ( i = 0; i < DELUGE_PKT_BITVEC_SIZE; i++ )
	pktsToSend[i] |= rxReqMsg->requestedPkts[i];
    }

    if ( state == S_IDLE ) {
      // not currently sending, so start sending data
      changeState(S_TX_LOCKING);
      imgToSend = imgNum;
      pageToSend = pgNum;
      //nodeAddr = (rxReqMsg->sourceAddr != TOS_UART_ADDR) ? TOS_BCAST_ADDR : TOS_UART_ADDR;
	  //JMS fix: for unicast programming
	  nodeAddr = rxReqMsg->sourceAddr;
      setupDataMsg();
    }

    return pMsg;

  }

  event void DataRead.readDone(storage_result_t result) {

    TOS_MsgPtr pMsgBuf = call SharedMsgBuf.getMsgBuf();

    if (state != S_SENDING)
      return;

    if (result != STORAGE_OK) {
      changeState(S_IDLE);
      return;
    }

    if (call SendDataMsg.send(nodeAddr, sizeof(DelugeDataMsg), pMsgBuf) == FAIL)
      call Timer.start(TIMER_ONE_SHOT, DELUGE_FAILED_SEND_DELAY);

  }

  event void DataWrite.writeDone(storage_result_t result) {

    uint16_t tmp;

    // mark packet as received
    BITVEC_CLEAR(pktsToReceive, rxQueue[head].pktNum);
    head = (head+1)%DELUGE_QSIZE;
    size--;
    
    if (!call BitVecUtils.indexOf(&tmp, 0, pktsToReceive, DELUGE_PKTS_PER_PAGE)) {
      signal PageTransfer.receivedPage(workingImgNum, workingPgNum);
      changeState(S_IDLE);
      size = 0;
    }
    else if ( size ) {
      writeData();
    }
    
  }

  event result_t SendReqMsg.sendDone(TOS_MsgPtr pMsg, result_t success) {

    if (state != S_RECEIVING)
      return SUCCESS;
    
    remainingAttempts--;

    // start timeout timer in case request is not serviced
    startReqTimer(FALSE);
    return SUCCESS;

  }

  event result_t SendDataMsg.sendDone(TOS_MsgPtr pMsg, result_t success) {
    TOS_MsgPtr pMsgBuf = call SharedMsgBuf.getMsgBuf();
    DelugeDataMsg* pDataMsg = (DelugeDataMsg*)(pMsgBuf->data);
    BITVEC_CLEAR(pktsToSend, pDataMsg->pktNum);
    call Timer.start(TIMER_ONE_SHOT, 2);
    return SUCCESS;
  }
  
  event void SharedMsgBuf.bufFree() { 
    switch(state) {
    case S_TX_LOCKING: setupDataMsg(); break;
    case S_RX_LOCKING: setupReqMsg(); break;
    }
  }
  
  event void DataRead.verifyDone(storage_result_t result, bool isValid) {}
  event void DataWrite.eraseDone(storage_result_t result) {}
  event void DataWrite.commitDone(storage_result_t result) {}

}
