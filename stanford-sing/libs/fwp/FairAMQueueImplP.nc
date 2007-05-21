// $Id$
/*
 * "Copyright (c) 2005 Stanford University. All rights reserved.
 *
 * Permission to use, copy, modify, and distribute this software and
 * its documentation for any purpose, without fee, and without written
 * agreement is hereby granted, provided that the above copyright
 * notice, the following two paragraphs and the author appear in all
 * copies of this software.
 * 
 * IN NO EVENT SHALL STANFORD UNIVERSITY BE LIABLE TO ANY PARTY FOR
 * DIRECT, INDIRECT, SPECIAL, INCIDENTAL, OR CONSEQUENTIAL DAMAGES
 * ARISING OUT OF THE USE OF THIS SOFTWARE AND ITS DOCUMENTATION, EVEN
 * IF STANFORD UNIVERSITY HAS BEEN ADVISED OF THE POSSIBILITY OF SUCH
 * DAMAGE.
 * 
 * STANFORD UNIVERSITY SPECIFICALLY DISCLAIMS ANY WARRANTIES,
 * INCLUDING, BUT NOT LIMITED TO, THE IMPLIED WARRANTIES OF
 * MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE.  THE SOFTWARE
 * PROVIDED HEREUNDER IS ON AN "AS IS" BASIS, AND STANFORD UNIVERSITY
 * HAS NO OBLIGATION TO PROVIDE MAINTENANCE, SUPPORT, UPDATES,
 * ENHANCEMENTS, OR MODIFICATIONS."
 */
/*
* Copyright (c) 2006 Stanford University.
* All rights reserved.
*
* Redistribution and use in source and binary forms, with or without
* modification, are permitted provided that the following conditions
* are met:
* - Redistributions of source code must retain the above copyright
*   notice, this list of conditions and the following disclaimer.
* - Redistributions in binary form must reproduce the above copyright
*   notice, this list of conditions and the following disclaimer in the
*   documentation and/or other materials provided with the
*   distribution.
* - Neither the name of the Stanford University nor the names of
*   its contributors may be used to endorse or promote products derived
*   from this software without specific prior written permission.
*
* THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS
* ``AS IS'' AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT
* LIMITED TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS
* FOR A PARTICULAR PURPOSE ARE DISCLAIMED.  IN NO EVENT SHALL STANFORD
* UNIVERSITY OR ITS CONTRIBUTORS BE LIABLE FOR ANY DIRECT, INDIRECT,
* INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES
* (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR
* SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION)
* HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT,
* STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE)
* ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED
* OF THE POSSIBILITY OF SUCH DAMAGE.
*/

/**
 * FWP codes added. FWP core codes reside here. FairAMQueueImplP
 * handles quiet times and does fair queueing.
 *
 * @auther Jung Il Choi
 * @date   May 18 2007
 */
 
#include "AM.h"

#define PENALTY 10
#define PACKET_TIME 1
#define USAGEPERIOD 1000*PACKET_TIME
#define SENDER_PENALTY 100
#include "Timer.h"

generic module FairAMQueueImplP(int numClients) {
  provides {
  	interface FairSend[uint8_t client];
  	interface AMQuiet;
  }
  uses{
    interface AMSend[am_id_t id];
    interface AMPacket;
    interface Packet;
    interface Timer<TMilli> as TQuiet;
    interface Timer<TMilli> as TJitter;
    
    interface Boot;
    interface Timer<TMilli> as TUsage;
    interface Random;
    interface Leds;

//    command void myDebug(uint8_t ind, uint16_t data);
//	interface AMSend as AMSendUART;
  }
}

implementation {

  
	enum {
		QUEUE_EMPTY = 255,
		NUMBER_PROTOCOLS = uniqueCount(UQ_AMQUEUE_SEND),
	};

	typedef struct {
		message_t* msg;
	} queue_entry_t;
  
	typedef struct {
		am_id_t type;
		uint16_t usage;
		uint8_t ind;
		uint8_t inQueue;
	} protocol_entry_t;
  
	uint8_t current = QUEUE_EMPTY;
	queue_entry_t queue[numClients];

	uint8_t idedProtocols = 0;
	protocol_entry_t protocolTable[NUMBER_PROTOCOLS];  
	bool cts = TRUE;
	bool send_busy = FALSE;
	bool chosenNextProtocolBool = FALSE;
	uint8_t chosenNextProtocolInd;
	bool jitterRunning = FALSE, quietRunning = FALSE;
#ifdef FQ_SENDERPENALTY 
	bool justsent = FALSE;
#endif
	
	event void Boot.booted() {
		dbg("FQUsage","Starting Usage Timer\n");
		call TUsage.startPeriodic(USAGEPERIOD);
	}		

	void tryToSend();
	task void QTFinished();
 
 	command void AMQuiet.initUsage() {
 		uint16_t i;
 		for (i=0;i<NUMBER_PROTOCOLS;i++) {
 			protocolTable[i].usage = 0;
 		}
 	}
 	
	void nextPacket() {
		uint16_t i, temp=(uint16_t)65535ul;
		uint8_t initial, count=0;
		uint8_t prot[NUMBER_PROTOCOLS], protocol;

		if (chosenNextProtocolBool) {
			chosenNextProtocolBool = FALSE;
			protocol = chosenNextProtocolInd;
		} else {
			 
			for (i=0;i<idedProtocols;i++) { 
				if ((temp>protocolTable[i].usage)&&(protocolTable[i].inQueue!=0)) {
					prot[0] = i;
					count=1;
					temp = protocolTable[i].usage;
				} else if ((temp==protocolTable[i].usage)&&(protocolTable[i].inQueue!=0)) {
					prot[count]=i;
					count++;
				}
			}
			if (count == 0) { // if nothing is waiting
				current = QUEUE_EMPTY;
				return;
			}
			if (count>1) { // if tie, randomly select
				protocol = prot[call Random.rand16()%count];
			} else {
				protocol = prot[0];
			}
		}
		initial = protocolTable[protocol].ind+1;
		i = initial;
		for (; i < (initial + numClients); i++) {
			uint8_t client = (uint8_t)i % numClients;
			if (queue[client].msg != NULL) {
				if (call AMPacket.type(queue[client].msg)==protocolTable[protocol].type) {
					current = client;
					return;
				}
			}
		}
		current = QUEUE_EMPTY;
	}
	am_id_t nextProtocol() {
		uint16_t i, temp=(uint16_t)65535ul;
		uint8_t count=0;
		uint8_t prot[NUMBER_PROTOCOLS], protocol;
 
		for (i=0;i<idedProtocols;i++) { 
			if ((temp>protocolTable[i].usage)&&(protocolTable[i].inQueue!=0)) {
				prot[0] = i;
				count=1;
				temp = protocolTable[i].usage;
			} else if ((temp==protocolTable[i].usage)&&(protocolTable[i].inQueue!=0)) {
				prot[count]=i;
				count++;
			}
		}
		if (count == 0) { // if nothing is waiting
			current = QUEUE_EMPTY;
			return 0xff;
		}
		if (count>1) { // if tie, randomly select
			protocol = prot[call Random.rand16()%count];
			chosenNextProtocolBool = TRUE;
			chosenNextProtocolInd = protocol;
		} else {
			protocol = prot[0];
		}
		return protocolTable[protocol].type;
	}
	uint8_t indexvalue;
	uint8_t* findIndex(am_id_t amId, bool originate) { // only originating protocols can be added
		uint8_t i;
		bool match = FALSE;
		for (i=0;i<idedProtocols;i++) {
			if (amId == protocolTable[i].type) {
				match = TRUE;
				break;
			}
		}
		if (!originate && !match) return NULL;
		if (!match) {
			i = idedProtocols++;
			protocolTable[i].type = amId;
			protocolTable[i].usage = 0;
			protocolTable[i].inQueue = 0;
		}
		indexvalue = i;
		return &indexvalue;
	}  	
	uint16_t incrementUsage(am_id_t curType, uint16_t quiet) {
		uint8_t* indptr = (findIndex(curType, FALSE));
		uint16_t quiet2;
		uint32_t t0 = call TQuiet.gett0();
		uint32_t dt = call TQuiet.getdt();
		uint32_t now = call TQuiet.getNow();
		bool twoAdded = FALSE; // to return pure nonoverlaps, without 2ms airtime
		uint8_t ind;
		
		if (indptr == NULL) return 0;
		ind = *indptr;
		if (call TQuiet.isRunning()) {
			if (t0+dt < now+quiet) {
				quiet2 = (now+quiet-t0-dt)&0xffff;
				if (quiet2>quiet) quiet2 = quiet;
			} else {
				quiet2 = 0;
			}
		} else {
			quiet2 = quiet+2; // 2ms for airtime
			twoAdded = TRUE;
		}
		
		if (protocolTable[ind].usage <= 65535ul - quiet2) protocolTable[ind].usage += quiet2;
		dbg("FQUsage","Incrementing Usage: Type[%d] 1: %d / 2: %d / 3: %d @ %s\n",protocolTable[ind].type,protocolTable[0].usage,protocolTable[1].usage,protocolTable[2].usage,sim_time_string());
		if (twoAdded) {
			return quiet2-2;
		} else {
			return quiet2;
		}
	}
    	
	void updateTable(uint8_t clientId, am_id_t amId) {
		uint8_t* indptr = (findIndex(amId, FALSE));
		uint8_t ind;
		
		if (indptr == NULL) return;
		ind = *indptr;

		protocolTable[ind].ind = clientId;
		if (protocolTable[ind].inQueue!=0) protocolTable[ind].inQueue--;
	}
	
	double fsqrt(double dbInput) {
		double dbRtnValue = 2.0;
		if (dbInput == 0)	return 0;

		dbRtnValue = 0.5 * (dbRtnValue + dbInput / dbRtnValue);
		dbRtnValue = 0.5 * (dbRtnValue + dbInput / dbRtnValue);
		dbRtnValue = 0.5 * (dbRtnValue + dbInput / dbRtnValue);
		dbRtnValue = 0.5 * (dbRtnValue + dbInput / dbRtnValue);
		return dbRtnValue;
	}
    	uint8_t calculatePP(am_id_t amId) {
		uint8_t i;
		uint16_t min = 0xffff, myusage;
		double ratio, res;
		uint8_t delay=0;
		uint8_t* indptr = (findIndex(amId, FALSE));
		uint8_t ind;
		
		if (indptr == NULL) return 0;
		ind = *indptr;
		if (idedProtocols == 1) return 0;
		for (i=0;i<idedProtocols;i++) {
			if ((protocolTable[i].usage != 0)&&(protocolTable[i].usage < min))
				 min = protocolTable[i].usage;	
		}
		if (min==0xffff) return 0;
		myusage = protocolTable[ind].usage;
		if (myusage == min) return 0;
		ratio = (double)myusage/min;
#ifndef NO_PROTOCOL_PENALTY
		res = 10 - (double)10*fsqrt((double)2/(1+ratio*ratio));
		delay = (uint8_t)(res + 0.5);
#endif

		return delay;
	}
  /**
   * Accepts a properly formatted AM packet for later sending.
   * Assumes that someone has filled in the AM packet fields
   * (destination, AM type).
   *
   * @param msg - the message to send
   * @param len - the length of the payload
   *
   */
   
	command error_t FairSend.send[uint8_t clientId](message_t* msg,
                                              uint8_t len,
                                              uint8_t quiet) {
		am_id_t amId = call AMPacket.type(msg);
		uint8_t* ch;
		if (clientId > numClients) {return FAIL;}
		if (queue[clientId].msg != NULL) {return EBUSY;}
		dbg("AMQueue", "AMQueue: request to send from %hhu (%p): passed checks\n", clientId, msg);

		queue[clientId].msg = msg;
		call Packet.setPayloadLength(msg, len);
		call AMPacket.setQuiet(msg,quiet);
		protocolTable[*(findIndex(amId,TRUE))].inQueue++;
		if ((current == QUEUE_EMPTY)&&(call AMQuiet.clearToSend()) ) {
			error_t err;
			am_addr_t dest = call AMPacket.destination(msg);

			dbg("AMQueue", "%s: request to send from %hhu (%p): queue empty\n", __FUNCTION__, clientId, msg);
			current = clientId;
			ch = (uint8_t*) call AMSend.getPayload[0](msg);
			dbg("FMSend2","Actually Sending %d from %d @ %s\n",ch[0],ch[1],sim_time_string());
			err = call AMSend.send[amId](dest, msg, len);
			if ((err != SUCCESS)&&(err != ECANCEL)) {
				dbg("AMQueue2","Underlying Sending Failed @ %s\n",sim_time_string());
				dbg("AMQueue", "%s: underlying send failed.\n", __FUNCTION__);
				current = QUEUE_EMPTY;
				queue[clientId].msg = NULL;
				return err;
			} else if (err==ECANCEL) {
				dbg("AMQueue2","Underlying Sending Canceled @ %s\n",sim_time_string());
			} else {
				dbg("AMQueue2","Underlying Sending Success @ %s\n",sim_time_string());
				send_busy = TRUE;
			}			
			return SUCCESS;
		}
		else {
			dbg("AMQueue", "AMQueue: request to send from %hhu (%p): queue not empty\n", clientId, msg);
		}
		return SUCCESS;
	}

	command error_t FairSend.cancel[uint8_t clientId](message_t* msg) {
		am_id_t amId = call AMPacket.type(msg);
		uint8_t* indptr = (findIndex(amId, FALSE));
		uint8_t ind;
		
		if (indptr == NULL) return FAIL;
		ind = *indptr;
		if (clientId > numClients ||         // Not a valid client    
			queue[clientId].msg == NULL ||    // No packet pending
			queue[clientId].msg != msg) {     // Not the right packet
				return FAIL;
		}
		if (current == clientId) {
			error_t err = call AMSend.cancel[amId](msg);
			if (err == SUCCESS) {
    			queue[clientId].msg = NULL;
				updateTable(clientId,amId);
				call AMPacket.setQuiet(msg,0);
				send_busy = FALSE;
				// remove it from the queue
				if (call AMQuiet.clearToSend()) tryToSend();
			}
			return err;
		}
		else {
			queue[clientId].msg = NULL;
			if (protocolTable[ind].inQueue!=0) protocolTable[ind].inQueue--;
			return SUCCESS;
		}
	}

	task void errorTask() {
		message_t* msg = queue[current].msg;
		queue[current].msg = NULL;
		signal FairSend.sendDone[current](msg, FAIL);
		if (!send_busy) tryToSend();
	}

  // NOTE: Increments current!
	void tryToSend() {
		uint8_t* ch;
		uint8_t lastCurrent = current;
		nextPacket();
		if (current != QUEUE_EMPTY) {
			error_t nextErr;
			message_t* nextMsg = queue[current].msg;
			am_id_t nextId = call AMPacket.type(nextMsg);
			am_addr_t nextDest = call AMPacket.destination(nextMsg);
			uint8_t len = call Packet.payloadLength(nextMsg);
			ch = (uint8_t*) call AMSend.getPayload[0](nextMsg);
			dbg("FMSend2","Actually Sending %d from %d @ %s\n",ch[0],ch[1],sim_time_string());
			if (call AMQuiet.clearToSend()) {
				nextErr = call AMSend.send[nextId](nextDest, nextMsg, len);
				if (nextErr == SUCCESS) {
					dbg("AMQueue2","Underlying Sending Success @ %s\n",sim_time_string());
					send_busy = TRUE;
				}
			} else {
				nextErr = ECANCEL;
			}
			if ((nextErr != SUCCESS)&&(nextErr !=ECANCEL)) {
				dbg("AMQueue2","Underlying Sending Failed @ %s\n",sim_time_string());
				updateTable(current,nextId);
				post errorTask();
			} else if (nextErr == ECANCEL) {
				dbg("AMQueue2","Underlying Sending Canceled @ %s\n",sim_time_string());
				current=lastCurrent;
//				if (call AMQuiet.clearToSend()) tryToSend();
			}
		}
	}
 
	  
	event void AMSend.sendDone[am_id_t id](message_t* msg, error_t err) {
		uint16_t quiet;
		am_id_t curType;
		send_busy = FALSE;
		dbg("AMQueue2","Underlying SendDone Called.. err=%d msg==msg=%d @ %s\n",
		   err,(queue[current].msg==msg),sim_time_string());
		if (queue[current].msg == msg) {
			
			dbg("PointerBug", "%s received send done for %p, signaling for %p.\n", __FUNCTION__, msg, queue[current].msg);
			if (err != ECANCEL) {
				uint8_t last = current;
				if (err!=SUCCESS) call AMPacket.setQuiet(msg,0);
				updateTable(current,id);
				queue[last].msg = NULL;
				quiet = call AMPacket.getQuiet(msg) * PACKET_TIME;
				curType = call AMPacket.type(msg);
				incrementUsage(curType,quiet);
#ifdef FQ_SENDERPENALTY
				justsent = TRUE;
#endif
				signal FairSend.sendDone[last](msg, err);

				if (call TQuiet.isRunning()) {
					if (call TQuiet.gett0()+call TQuiet.getdt()-call TQuiet.getNow()<quiet) {
						dbg("AMQueue2","Starting Quiet Time from Tx.. %d / %s\n",quiet,sim_time_string());
						atomic jitterRunning = FALSE;
						atomic quietRunning = TRUE;
						call TJitter.stop();
						call TQuiet.startOneShot(quiet);
					}
				} else {
					dbg("AMQueue2","Starting Quiet Time from Tx.. %d / %s\n",quiet,sim_time_string());
					if (quiet!=0) { 
						atomic jitterRunning = FALSE;
						atomic quietRunning = TRUE;
						call TJitter.stop();
						call TQuiet.startOneShot(quiet); 
					} else { 
						atomic jitterRunning = FALSE;
						call TJitter.stop();
						post QTFinished(); 
					}
				}
			} else {
			}
		} else {
			if (call AMQuiet.clearToSend()) tryToSend();
		}
	}
	
	command void AMQuiet.runQuiet(message_t* msg) {

		am_id_t curType = call AMPacket.type(msg);
		uint16_t quiet = call AMPacket.getQuiet(msg) * PACKET_TIME;
		uint16_t incrementedUsage;
		uint16_t dest = call AMPacket.destination(msg);
		uint8_t* indptr = (findIndex(curType, FALSE));
		if (indptr == NULL) return;
//		if (call AMQuiet.clearToSend()) tryToSend();
#ifdef FQ_SENDERPENALTY
		justsent = FALSE;
#endif

		if ((dest!=TOS_NODE_ID)&&(dest!=AM_BROADCAST_ADDR)) {
			incrementedUsage = incrementUsage(curType,quiet);
			if (quiet == 0) return;
			call TJitter.stop();

			chosenNextProtocolBool = FALSE;
			if (call TQuiet.isRunning()) {
				if (call TQuiet.gett0()+call TQuiet.getdt()-call TQuiet.getNow()<(uint16_t)quiet) {
					dbg("AMQueue2","Starting Quiet Time from Rx.. %d / %s\n",quiet,sim_time_string());
					atomic jitterRunning = FALSE;
					atomic quietRunning = TRUE;
					call TJitter.stop();
					call TQuiet.startOneShot(quiet);
				} else {
//					if (call AMQuiet.clearToSend()) tryToSend();
				}
			} else {
				dbg("AMQueue2","Starting Quiet Time from Rx.. %d / %s\n",quiet,sim_time_string());
				if (quiet!=0) { 
					atomic jitterRunning = FALSE;
					atomic quietRunning = TRUE;
					call TJitter.stop();
					call TQuiet.startOneShot(quiet); 
				} else { 
					atomic jitterRunning = FALSE;
					call TJitter.stop();
					post QTFinished(); 
				}
			}
//			if (call AMQuiet.clearToSend()) tryToSend();
		} else {
//			if (call AMQuiet.clearToSend()) tryToSend();
		}
	}
	
	task void QTFinished() {
		if (call AMQuiet.clearToSend()) {
			tryToSend();
		}
	}		

	event void TQuiet.fired() {
		uint8_t penalty = 0;
		am_id_t nextId;
		atomic quietRunning = FALSE;
		
#ifndef NO_PROTOCOL_PENALTY 
		nextId = nextProtocol();
		if (nextId != 0xff) penalty += calculatePP(nextId);
#endif
#ifdef FQ_SENDERPENALTY
		if (justsent) {
			justsent = FALSE;
			penalty += SENDER_PENALTY;
			dbg("FQ_PENALTY","Giving Sender Penalty.. %s\n",sim_time_string());
		}
#endif
		dbg("FQ_PENALTY","Finished Quiet Time.. Jitter: %d/%s\n",penalty,sim_time_string());
		if (penalty!=0) {
			atomic jitterRunning = TRUE;
			call TJitter.startOneShot(penalty);
			return;
		}
		if (call AMQuiet.clearToSend()) {
			tryToSend();
		}
	}  	
	event void TJitter.fired() {
		atomic jitterRunning = FALSE;
		dbg("AMQueue2","Finished Jitter Time.. %s\n",sim_time_string());
		if (call AMQuiet.clearToSend()) tryToSend();
	}  	

	event void TUsage.fired() {
		uint8_t i;
		for (i=0;i<idedProtocols;i++) {
			protocolTable[i].usage = protocolTable[i].usage/2;
		}
		dbg("FQUsage","Halving Usage: 1: %d / 2: %d / 3: %d @ %s\n",protocolTable[0].usage,protocolTable[1].usage,protocolTable[2].usage,sim_time_string());
	}  	

	async command void AMQuiet.blockSend() {
		atomic cts = FALSE;
	}
	async command void AMQuiet.allowSend() {
		atomic cts = TRUE;
	}

	command bool AMQuiet.clearToSend() {
		bool temp;
		atomic temp = cts;
		dbg("AMQueue2","ClearToSend : TQuiet %d / TJitter %d / send_busy %d\n",
			call TQuiet.isRunning(), call TJitter.isRunning(), send_busy);
		return ((!call TQuiet.isRunning())&&(!call TJitter.isRunning())&&(!send_busy)&&temp);
	}
  
	async command bool AMQuiet.beingQuiet() {
		bool temp;
		atomic temp = !cts;
		return (temp || quietRunning || jitterRunning);
	}
	
	command void AMQuiet.setUsage(am_id_t type, uint16_t usage) {
		uint8_t* indptr = (findIndex(type, FALSE));
		uint8_t ind;
		
		if (indptr == NULL) return;
		ind = *indptr;
		protocolTable[ind].usage = usage;
	}

	command uint16_t AMQuiet.getUsage(am_id_t type) {
		uint8_t* indptr = (findIndex(type, FALSE));
		uint8_t ind;
		
		if (indptr == NULL) return 0;
		ind = *indptr;
		return protocolTable[ind].usage;
	}
	
	command uint8_t AMQuiet.getNumProtocols() {
		return idedProtocols;
	}  
	command uint8_t AMQuiet.getProtocolTableEntry(uint8_t ind) {
		return protocolTable[ind].type;
	}
	
	command uint8_t FairSend.maxPayloadLength[uint8_t id]() {
		return call AMSend.maxPayloadLength[0]();
	}

	command void* FairSend.getPayload[uint8_t id](message_t* m) {
		return call AMSend.getPayload[0](m);
	}

	default event void FairSend.sendDone[uint8_t id](message_t* msg, error_t err) {
		// Do nothing
	}
}

