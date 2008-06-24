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

/**
 * An AM send queue that provides a Service Instance pattern for
 * formatted packets and calls an underlying AMSend in a round-robin
 * fashion. Used to share L2 bandwidth between different communication
 * clients.
 *
 * @author Philip Levis
 * @date   Jan 16 2006
 */ 

/**
 * Added GTS layer. It keeps track of suppression information and 
 * transmit packets at the right time.
 *
 * @author Jung Il Choi
 * @date   Jun 17 2008
 */ 
 
#include "AM.h"

#ifndef USAGE_PERIOD
#define USAGE_PERIOD 1000
#endif
#ifndef USAGE_COEFFICIENT
#define USAGE_COEFFICIENT 0.5
#endif

generic module GTSAMQueueImplP(int numClients) {
	provides interface GTSSend[uint8_t client];
	provides interface AMQuiet;
	provides interface ReportProtocol;
	uses{
		interface AMSend[am_id_t id];
		interface AMPacket;
		interface Packet;
		interface Timer<TMilli> as TQuiet;
		interface Boot;
		interface Timer<TMilli> as TUsage;
		interface Timer<TMilli> as TGrant;
		interface Random;
		interface Leds;
		interface GTSPacket;
	}
}

implementation {
	typedef struct {
		message_t* msg;
	} queue_entry_t;
	
	typedef struct {
		am_id_t type;
		uint16_t usage;
		uint8_t ind;
		uint8_t inQueue;
	} protocol_entry_t;
  
	uint8_t current = numClients; // mark as empty
	queue_entry_t queue[numClients];
	uint8_t cancelMask[numClients/8 + 1];

	uint8_t numProtocols = 0, next_protocol_chosen_ind;
	protocol_entry_t protocolTable[numClients];
	bool cts = TRUE, send_busy = FALSE, next_protocol_chosen = FALSE;
	bool quietRunning = FALSE, beingGranted = FALSE;
	
	void tryToSend(bool);

	uint8_t findIndex(am_id_t amId) {
		uint8_t i;
		for (i=0;i<numProtocols;i++) {
			if (amId == protocolTable[i].type) 
				return i;
		}
		return 0xff;
	}  	
	
    command void ReportProtocol.report(am_id_t amId) {
    	if (findIndex(amId) == 0xff) {
	    	protocolTable[numProtocols].type = amId;
	    	protocolTable[numProtocols].usage = 0;
	    	protocolTable[numProtocols].inQueue = 0;
	    	protocolTable[numProtocols].ind = 0;
	    	numProtocols++;
	    }
    }
    
    event void TGrant.fired() {
    	atomic beingGranted = FALSE;
    }

	event void Boot.booted() {
		call TUsage.startPeriodic(USAGE_PERIOD);
	}		
  
	void nextPacket() {
		uint8_t i, count = 0;
        uint16_t temp = 0xffff;
        uint8_t prot[numClients];
		if (next_protocol_chosen) {
			next_protocol_chosen = FALSE;
			prot[0] = next_protocol_chosen_ind;
		} else {
			// find the protocol with minimum usage (among pending ones)
			for (i=0;i<numProtocols;i++) { 
				if ((protocolTable[i].inQueue!=0)&&(temp>protocolTable[i].usage)) {
					prot[0] = i;
					count=1;
					temp = protocolTable[i].usage;
				} else if ((protocolTable[i].inQueue!=0)&&(temp==protocolTable[i].usage)) {
					prot[count]=i;
					count++;
				}
			}
			if (count == 0) { // if nothing is waiting
				current = numClients;
				return;
			}
			if (count>1) // if tie, randomly select
				prot[0] = prot[call Random.rand16()%count];
		}

		current = (current + 1) % numClients;
		for(i = 0; i < numClients; i++) {
			if((queue[current].msg == NULL) ||
			   (cancelMask[current/8] & (1 << current%8)) ||
			   (call AMPacket.type(queue[current].msg)!=protocolTable[prot[0]].type))
			{
				current = (current + 1) % numClients;
			}
			else {
				break;
			}
		}
		if(i >= numClients) current = numClients;
	}

	am_id_t nextProtocol() {
		uint8_t i, count = 0;
        uint16_t temp = 0xffff;
        uint8_t prot[numClients];
		for (i=0;i<numProtocols;i++) { 
			if ((protocolTable[i].inQueue!=0)&&(temp>protocolTable[i].usage)) {
				prot[0] = i;
				count=1;
				temp = protocolTable[i].usage;
			} else if ((protocolTable[i].inQueue!=0)&&(temp==protocolTable[i].usage)) {
				prot[count]=i;
				count++;
			}
		}
		if (count == 0) { // if nothing is waiting
			next_protocol_chosen = FALSE;
			return 0xff;
		}
		if (count>1) { // if tie, randomly select
			prot[0] = prot[call Random.rand16()%count];
			next_protocol_chosen = TRUE;
			next_protocol_chosen_ind = prot[0];
		}
		return protocolTable[prot[0]].type;
	}

	uint16_t incrementUsage(am_id_t curType, uint16_t quiet) {
		uint8_t ind = findIndex(curType);
		uint16_t quiet2;
		uint32_t t0 = call TQuiet.gett0();
		uint32_t dt = call TQuiet.getdt();
		uint32_t now = call TQuiet.getNow();
		bool twoAdded = FALSE; // to return pure nonoverlaps, without 2ms airtime
		if (ind == 0xff) return 0;
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
		
		protocolTable[ind].usage += quiet2;
		if (twoAdded) {
			return quiet2-2;
		} else {
			return quiet2;
		}
	}

	void updateTable(uint8_t clientId, am_id_t amId) {
		uint8_t ind;
		ind = findIndex(amId);
		if (ind == 0xff) return;
		protocolTable[ind].ind = clientId;
		if (protocolTable[ind].inQueue!=0) protocolTable[ind].inQueue--;
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
	command error_t GTSSend.send[uint8_t clientId](message_t* msg,
												uint8_t len, uint8_t quiet) {
		am_id_t amId = call AMPacket.type(msg);
		error_t err;
		am_addr_t dest;
		if (clientId >= numClients) {
			return FAIL;
		}
		if (queue[clientId].msg != NULL) {
			return EBUSY;
		}
		dbg("AMQueue", "AMQueue: request to send from %hhu (%p): passed checks\n", clientId, msg);
		
		queue[clientId].msg = msg;
		call Packet.setPayloadLength(msg, len);
		call GTSPacket.setQuiet(msg,quiet);
		protocolTable[findIndex(amId)].inQueue++;
	
		if (current >= numClients && call AMQuiet.clearToSend()) { // queue empty
			dest = call AMPacket.destination(msg);
	  
			dbg("AMQueue", "%s: request to send from %hhu (%p): queue empty\n", __FUNCTION__, clientId, msg);
			current = clientId;
			
			err = call AMSend.send[amId](dest, msg, len);
			if ((err != SUCCESS)&&(err != ERESERVE)) {
				dbg("AMQueue", "%s: underlying send failed.\n", __FUNCTION__);
				current = numClients;
				queue[clientId].msg = NULL;
				return err;
			} else if (err==ERESERVE) {
			} else {
				send_busy = TRUE;
			}			
			return err;
		}
		else {
			dbg("AMQueue", "AMQueue: request to send from %hhu (%p): queue not empty\n", clientId, msg);
		}
		return SUCCESS;
	}

	task void CancelTask() {
		uint8_t i,j,mask,last, ind;
		message_t *msg;
		for(i = 0; i < numClients/8 + 1; i++) {
			if(cancelMask[i]) {
				for(mask = 1, j = 0; j < 8; j++) {
					if(cancelMask[i] & mask) {
						last = i*8 + j;
						msg = queue[last].msg;
						queue[last].msg = NULL;
						ind = findIndex(call AMPacket.type(msg));
						if (ind != 0xff && protocolTable[ind].inQueue!=0) 
							protocolTable[ind].inQueue--;
						cancelMask[i] &= ~mask;
						signal GTSSend.sendDone[last](msg, ECANCEL);
					}
					mask <<= 1;
				}
			}
		}
	}
	
	command error_t GTSSend.cancel[uint8_t clientId](message_t* msg) {
		am_id_t amId = call AMPacket.type(msg);
		if (clientId >= numClients ||		 // Not a valid client	
			queue[clientId].msg == NULL ||	// No packet pending
			queue[clientId].msg != msg) {	 // Not the right packet
			return FAIL;
		}
		if(current == clientId) {
			return call AMSend.cancel[amId](msg);
		}
		else {
			cancelMask[clientId/8] |= 1 << clientId % 8;
			post CancelTask();
			return SUCCESS;
		}
	}

	void sendDone(uint8_t last, message_t *msg, error_t err) {
		updateTable(last, call AMPacket.type(queue[last].msg));
		queue[last].msg = NULL;
		signal GTSSend.sendDone[last](msg, err);
	}

	task void errorTask() {
		sendDone(current, queue[current].msg, FAIL);
		if (call AMQuiet.clearToSend()) tryToSend(FALSE);
	}

	// NOTE: Increments current!
	void tryToSend(bool suppressed) {
		uint8_t lastCurrent = current, len;
		error_t nextErr;
		message_t* nextMsg;
		am_id_t nextId;
		am_addr_t nextDest;
		nextPacket();
		if (current < numClients) { // queue not empty
			nextMsg = queue[current].msg;
			nextId = call AMPacket.type(nextMsg);
			nextDest = call AMPacket.destination(nextMsg);
			len = call Packet.payloadLength(nextMsg);
			if (call AMQuiet.clearToSend()) {
				nextErr = call AMSend.send[nextId](nextDest, nextMsg, len);
				if(nextErr != SUCCESS) {
					post errorTask();
				} else {
					send_busy = TRUE;
				}
			} else {
				nextErr = ERESERVE;
			}
			if ((nextErr != SUCCESS)&&(nextErr !=ERESERVE)) {
				updateTable(current,nextId);
				post errorTask();
			} else if (nextErr == ERESERVE) {
				current=lastCurrent;
			}
		}
	}

	task void QTFinished() {
		if (call AMQuiet.clearToSend()) {
			tryToSend(FALSE);
		}
	}		
  
	event void AMSend.sendDone[am_id_t id](message_t* msg, error_t err) {
	  // Bug fix from John Regehr: if the underlying radio mixes things
	  // up, we don't want to read memory incorrectly. This can occur
	  // on the mica2.
	  // Note that since all AM packets go through this queue, this
	  // means that the radio has a problem. -pal
		uint16_t quiet;
		am_id_t curType;
		send_busy = FALSE;
	  if (current >= numClients) {
	    // something bad happened
	  	call Leds.led0On();
	  	call Leds.led1On();
	  	call Leds.led2On();
	  	return;	  
	  }
		if (queue[current].msg == msg) {
			if (err != ERESERVE) {
				updateTable(current,id);
				quiet = call GTSPacket.getQuiet(msg);
				curType = call AMPacket.type(msg);
				incrementUsage(curType,quiet);
				if (call TQuiet.isRunning()) {
					if (call TQuiet.gett0()+call TQuiet.getdt()-call TQuiet.getNow()<quiet) {
						dbg("GTSMsg","Starting Quiet Time from Tx.. %d / %s\n",quiet,sim_time_string());
						atomic quietRunning = TRUE;
						call TQuiet.startOneShot(quiet);
					}
				} else {
					dbg("GTSMsg","Starting Quiet Time from Tx.. %d / %s\n",quiet,sim_time_string());
					if (quiet!=0) { 
						atomic quietRunning = TRUE;
						call TQuiet.startOneShot(quiet); 
					} else { 
						post QTFinished(); 
					}
				}
                sendDone(current, msg, err);
			} else {
				if (call AMQuiet.clearToSend()) tryToSend(FALSE);
			}
		} else {
			if (call AMQuiet.clearToSend()) tryToSend(FALSE);
		}
	}
	
	command void AMQuiet.runQuiet(message_t* msg) {

		am_id_t curType = call AMPacket.type(msg);
		uint16_t quiet = call GTSPacket.getQuiet(msg);
		uint16_t incrementedUsage;
		uint16_t dest = call AMPacket.destination(msg);
		uint8_t ind = findIndex(curType);
		if (ind == 0xff) {
			return;
		}
		if ((dest!=TOS_NODE_ID)&&(dest!=AM_BROADCAST_ADDR)) {
			incrementedUsage = incrementUsage(curType,quiet);
			if (quiet == 0) return;
			next_protocol_chosen = FALSE;
			if (call TQuiet.isRunning()) {
				if (call TQuiet.gett0()+call TQuiet.getdt()-call TQuiet.getNow()<(uint16_t)quiet) {
					dbg("GTSMsg","Starting Quiet Time from Rx.. %d / %s\n",quiet,sim_time_string());
					atomic quietRunning = TRUE;
					call TQuiet.startOneShot(quiet);
				} else {
				}
			} else {
				dbg("GTSMsg","Starting Quiet Time from Rx.. %d / %s\n",quiet,sim_time_string());
				if (quiet!=0) { 
					atomic quietRunning = TRUE;
					call TQuiet.startOneShot(quiet); 
				} else { 
					post QTFinished(); 
				}
			}
		} else {
			if (quiet != 0) {
				atomic beingGranted = TRUE;
				call TGrant.startOneShot(quiet);
			}
		}
	}
	event void TQuiet.fired() {
		atomic quietRunning = FALSE;
		if (call AMQuiet.clearToSend()) {
			tryToSend(TRUE);
		}
	}  	
	event void TUsage.fired() {
		uint8_t i;
		for (i=0;i<numProtocols;i++) {
			protocolTable[i].usage = protocolTable[i].usage * USAGE_COEFFICIENT;
		}
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
		return ((!call TQuiet.isRunning())&&(!send_busy)&&temp);
	}
  
	async command bool AMQuiet.beingQuiet() {
		bool temp;
		atomic temp = !cts;
		return (temp || quietRunning );
	}
	
	command uint8_t GTSSend.maxPayloadLength[uint8_t id]() {
		return call AMSend.maxPayloadLength[0]();
	}

	command void* GTSSend.getPayload[uint8_t id](message_t* m, uint8_t len) {
	  return call AMSend.getPayload[0](m, len);
	}

	default event void GTSSend.sendDone[uint8_t id](message_t* msg, error_t err) {
		// Do nothing
	}
 	async command bool AMQuiet.isGranted() {
 		bool temp;
 		atomic temp = beingGranted;
 		return temp;
 	}
 	command bool AMQuiet.isUsedType(am_id_t type) {
 		return (findIndex(type) != 0xff);
 	}
 	
}
