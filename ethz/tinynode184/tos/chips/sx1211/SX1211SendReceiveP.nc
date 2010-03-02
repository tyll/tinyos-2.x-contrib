/* 
 * Copyright (c) 2006, Ecole Polytechnique Federale de Lausanne (EPFL),
 * Switzerland.
 * All rights reserved.
 *
 * Redistribution and use in source and binary forms, with or without
 * modification, are permitted provided that the following conditions
 * are met:
 * - Redistributions of source code must retain the above copyright notice,
 *   this list of conditions and the following disclaimer.
 * - Redistributions in binary form must reproduce the above copyright
 *   notice, this list of conditions and the following disclaimer in the
 *   documentation and/or other materials provided with the distribution.
 * - Neither the name of the Ecole Polytechnique Federale de Lausanne (EPFL) 
 *   nor the names of its contributors may be used to 
 *   endorse or promote products derived from this software without 
 *   specific prior written permission.
 * 
 * THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS
 * "AS IS" AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT
 * LIMITED TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR
 * A PARTICULAR PURPOSE ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT
 * OWNER OR CONTRIBUTORS BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL,
 * SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED
 * TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA,
 * OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY
 * OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT
 * (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE
 * USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
 *
 * ========================================================================
 */

/*
 * @author Henri Dubois-Ferriere
 *
 */


module SX1211SendReceiveP {
    provides interface Send;
    provides interface Packet;
    provides interface PacketAcknowledgements;
    provides interface Receive;
    provides interface AckSendReceive;
    provides interface SendBuff;
    provides interface SplitControl @atleastonce();

    uses interface SX1211PhyRxTx;
    uses interface SX1211PhyRssi;
    uses interface SplitControl as PhySplitControl;
    uses interface SX1211PacketBody;

}
implementation {

typedef  enum {
    PKT_CODE = 0,
    ACK_CODE = 1,
    BUF_CODE = 2,
} preamble_t;

    typedef nx_struct ackMsg_t {
    	nx_uint16_t pl;
    } ackMsg_t;
  
    message_t ackMsg;
    message_t *ackMsgPtr = &ackMsg;
    uint16_t ackPayload;

    message_t *txMsgSendDonePtr=NULL;
    norace message_t *txMsgPtr=NULL;   // message under transmission (non-null until after sendDone).
    norace uint8_t _len;
    bool wasAcked;

    bool rx_busy=FALSE;
    message_t rxMsg;
    message_t *rxMsgPtr=&rxMsg; 

    norace preamble_t prbl;          // pattern to send before buffer

    bool sendAcks=TRUE;

    task void signalPacketReceived();
    error_t sendRadioOn(preamble_t preamble);

  
    command void AckSendReceive.setAckPayload(uint16_t _pl) {
    	atomic ackPayload = _pl;
    }
    
    command void AckSendReceive.enableAck() {
    	atomic sendAcks = TRUE;
    }
    
    command void AckSendReceive.disableAck() {
       	atomic sendAcks = FALSE;
    }
    
    command uint16_t AckSendReceive.getAckPayload() {
    	uint16_t ack_tmp;
    	atomic ack_tmp = ackPayload;
    	return ack_tmp;
    }

    command uint8_t Send.maxPayloadLength() {
	return call Packet.maxPayloadLength();
    }

    command void* Send.getPayload(message_t* m, uint8_t len) {
	return call Packet.getPayload(m, len);
    }

    task void sendDoneBufTask() {
    	txMsgSendDonePtr = txMsgPtr;
    	txMsgPtr=NULL;
    	signal SendBuff.sendDone((uint8_t*)txMsgSendDonePtr, SUCCESS);
    }
    
    task void sendDoneBufFailTask() {
    	txMsgSendDonePtr = txMsgPtr;
    	txMsgPtr=NULL;
    	signal SendBuff.sendDone((uint8_t*)txMsgSendDonePtr, FAIL);
    }
    
    task void sendDoneTask() {
    	txMsgSendDonePtr = txMsgPtr;
    	txMsgPtr=NULL;
    	atomic {
    		if (wasAcked)
    			(call SX1211PacketBody.getHeader(txMsgSendDonePtr))->ack |= 0x01;
    		else
    			(call SX1211PacketBody.getHeader(txMsgSendDonePtr))->ack &= 0xfe;
    	}
    	signal Send.sendDone(txMsgSendDonePtr, SUCCESS);
    }

    task void sendDoneFailTask() {
    	txMsgSendDonePtr = txMsgPtr;
    	txMsgPtr=NULL;
    	signal Send.sendDone(txMsgSendDonePtr, FAIL);
    }
    
    task void signalPacketReceived() {
    	message_t * tmpMsg;
    	atomic tmpMsg = rxMsgPtr;
    	tmpMsg = signal Receive.receive(tmpMsg, tmpMsg->data, (call SX1211PacketBody.getMetadata(tmpMsg))->length);
    	atomic {
    		rxMsgPtr = tmpMsg;
        	rx_busy = FALSE;
    	}

    }

    command error_t SplitControl.start() {
	error_t err;
	err = call PhySplitControl.start();

	return err;
    }

    command error_t SplitControl.stop() {
    	error_t err;

    	// One could also argue that this is split phase so should cope and do the right thing.
    	// Or one could argue that whatever the phy is doing underneath just gets interrupted.
    	if (call SX1211PhyRxTx.busy() || txMsgPtr!=NULL) return EBUSY;

    	err = call PhySplitControl.stop();
    	atomic rx_busy = FALSE;
    	return err;

    }

    event void PhySplitControl.startDone(error_t error) {
	atomic {
	    if (txMsgPtr!=NULL) {
	    	sendRadioOn(PKT_CODE);
	    }
	    signal SplitControl.startDone(error);
	}
    }

    event void PhySplitControl.stopDone(error_t error) { 
	
	signal SplitControl.stopDone(error);
    }

    task void sendAck() {
    	if (txMsgPtr != NULL) { // unable to send ack;
    		atomic {
    			sendAcks = TRUE;
        		rx_busy = FALSE;
    		}
    		return;
    	}
    	atomic {
	    (call SX1211PacketBody.getHeader(ackMsgPtr))->group = \
			(call SX1211PacketBody.getHeader((message_t*)rxMsgPtr))->group;
	    (call SX1211PacketBody.getHeader(ackMsgPtr))->type = \
			(call SX1211PacketBody.getHeader(rxMsgPtr))->type;
	    (call SX1211PacketBody.getHeader(ackMsgPtr))->dest = \
			(call SX1211PacketBody.getHeader(rxMsgPtr))->source;
	    (call SX1211PacketBody.getHeader(ackMsgPtr))->source = TOS_NODE_ID;
	    ((ackMsg_t*)(ackMsgPtr->data))->pl = ackPayload;
	    txMsgPtr = ackMsgPtr;
    	}
    	_len = sizeof(ackMsg_t);
    	if (sendRadioOn(ACK_CODE)!=SUCCESS) {
    		atomic {
    			sendAcks = TRUE;
        		rx_busy = FALSE;
    		}
    	}
    }
    
    command error_t Send.cancel(message_t* msg) {
	/* Cancel is unsupported for now. */
	return FAIL;
    }

    error_t sendRadioOn(preamble_t preamble) {
    	error_t err=SUCCESS;
    	uint8_t txIndex=0;
    	if(preamble==PKT_CODE || preamble==ACK_CODE) {
    		// len included in header
    		(call SX1211PacketBody.getHeader(txMsgPtr))->len = sizeof(sx1211_header_t) + _len + sizeof(sx1211_footer_t) - 1;
    		(call SX1211PacketBody.getMetadata(txMsgPtr))->length = _len; 
    		txIndex = sizeof(sx1211_header_t) + _len + sizeof(sx1211_footer_t);
    	}
    	else if (preamble==BUF_CODE) {
    		(call SX1211PacketBody.getHeader(txMsgPtr))->len = _len - 1;
    		txIndex = _len;    	    
    	}
    	switch (preamble) {
    	case PKT_CODE:
    		err = call SX1211PhyRxTx.sendFrame((uint8_t *) call SX1211PacketBody.getHeader(txMsgPtr), txIndex, data_pattern);
    		break;

    	case ACK_CODE:
    		err = call SX1211PhyRxTx.sendFrame((uint8_t *) call SX1211PacketBody.getHeader(txMsgPtr), txIndex, ack_pattern);
    		break;

    	case BUF_CODE:
    		err = call SX1211PhyRxTx.sendFrame((uint8_t *) call SX1211PacketBody.getHeader(txMsgPtr), txIndex, buf_pattern);
    		break;
    	}
    	if (err != SUCCESS) { 
    		txMsgPtr = NULL;
    	} else {
    		if (preamble==PKT_CODE && (call SX1211PacketBody.getHeader(txMsgPtr))->ack==1) {
    			atomic wasAcked = FALSE;
    			call SX1211PhyRxTx.enableAck(TRUE);
    		}
    		prbl=preamble;
    	}
    	return err;
    }

    /*
     * first byte of buff is overwritten with length
     */
    command error_t SendBuff.send(uint8_t* buff, uint8_t len) {
	atomic {
	    if (txMsgPtr){ return EBUSY;}
	    if (buff==NULL) { return FAIL;}
	    if (call SX1211PhyRxTx.busy()==TRUE){ return EBUSY;}

	    if (call SX1211PhyRxTx.off()) {
	    	return EOFF;
	    }
	    txMsgPtr = (message_t*)buff;
	    _len = len;
	}
	return sendRadioOn(BUF_CODE);
    }

    command error_t Send.send(message_t* msg, uint8_t len) {
	atomic {
	    if (txMsgPtr){ return EBUSY;}
	    if (msg==NULL) { return FAIL;}
	    if (call SX1211PhyRxTx.busy()==TRUE){return EBUSY;}
		txMsgPtr = msg;
		_len = len;    
	}
	return  sendRadioOn(PKT_CODE);
    }


    async event void SX1211PhyRxTx.sendFrameDone(uint16_t timestamp, error_t err) __attribute__ ((noinline)) {
	switch (prbl) {
	case PKT_CODE:
	    if(err==SUCCESS) {
	    	(call SX1211PacketBody.getMetadata(txMsgPtr))->time = timestamp;
	    	post sendDoneTask();
	    } else {
	    	post sendDoneFailTask();
	    }
	    break;

	case ACK_CODE:
	    txMsgPtr = NULL;
	    post signalPacketReceived();
	    break;

	case BUF_CODE:
	    if(err==SUCCESS) {
	    	post sendDoneBufTask();
	    } else {
	    	post sendDoneBufFailTask();
	    }
	    break;
	}
    }

 default event void Send.sendDone(message_t* msg, error_t error) { }
 default event void SendBuff.sendDone(uint8_t* msg, error_t error) { }

 async event message_t * SX1211PhyRxTx.rxFrameEnd(message_t* msg, uint8_t len, uint16_t timestamp, error_t status)   __attribute__ ((noinline)) {
     sx1211_metadata_t* meta;
     sx1211_header_t* header;
     message_t *mptr;
     if (status != SUCCESS) return msg;
     header = call SX1211PacketBody.getHeader(msg);
     // test ack
     if (txMsgPtr && len == sizeof(sx1211_header_t) + sizeof(ackMsg_t) + sizeof(sx1211_footer_t) - 1){ // this is probably an ACK
    	 if (
    			 header->source == (call SX1211PacketBody.getHeader(txMsgPtr))->dest &&
    			 header->dest == TOS_NODE_ID &&
    			 header->type == (call SX1211PacketBody.getHeader(txMsgPtr))->type &&			 
    			 header->group == (call SX1211PacketBody.getHeader(txMsgPtr))->group)
			 {
				 // successfully acked
				 ackPayload = ((ackMsg_t*)msg->data)->pl;
				 wasAcked = TRUE;
				 (call SX1211PacketBody.getMetadata(txMsgPtr))->strength = call SX1211PhyRssi.readRxRssi();
			     return msg;
			 }
     }

     // process packet
     if (rx_busy) return msg;
               
     rx_busy=TRUE;
     meta = call SX1211PacketBody.getMetadata(msg);
     meta->strength = call SX1211PhyRssi.readRxRssi();
     meta->length = len - sizeof(sx1211_header_t) - sizeof(sx1211_footer_t) + 1; // payload length
     meta->time = timestamp;
#ifndef SX1211_RECEIVE_ALL         
     if (sendAcks && header->dest == TOS_NODE_ID && ((header->ack & 0x01)==1)) {
    	 sendAcks = FALSE;
    	 post sendAck();
     }
     else if (!((header->ack & 0x01)==1 && !sendAcks)){
    	 post signalPacketReceived();
     }
     else {
    	 // we should have acknowledge this packet, but did not, discard it
    	 rx_busy=FALSE;
    	 return msg;
     }
#else
     if (header->dest == TOS_NODE_ID && ((header->ack & 0x01)==1)) {
      	 post sendAck();
     }
     else  {
      	 post signalPacketReceived();
     }
#endif
     // switch pointers
     mptr = rxMsgPtr;
     rxMsgPtr = msg;
     return mptr;
 }


 command void Packet.clear(message_t* msg) {
     memset(msg, 0, sizeof(message_t));
 }

 command uint8_t Packet.payloadLength(message_t* msg) {
     return (call SX1211PacketBody.getMetadata(msg))->length;
 }
 
 command void Packet.setPayloadLength(message_t* msg, uint8_t len) {
	 (call SX1211PacketBody.getMetadata(msg))->length  = len;
 }
  
 command uint8_t Packet.maxPayloadLength() {
     return TOSH_DATA_LENGTH;
 }

 command void* Packet.getPayload(message_t* msg, uint8_t len) {
     if (len <= TOSH_DATA_LENGTH) {
	 return (void*)msg->data;
     }
     else {
	 return NULL;
     }
 }

 async command error_t PacketAcknowledgements.requestAck(message_t* msg) {
     (call SX1211PacketBody.getHeader(msg))->ack |= 0x01;
     return SUCCESS;
 }

 async command error_t PacketAcknowledgements.noAck(message_t* msg) {
     (call SX1211PacketBody.getHeader(msg))->ack &= 0xFE;
     return SUCCESS;
 }

 async command bool PacketAcknowledgements.wasAcked(message_t* msg) {
     return (call SX1211PacketBody.getHeader(msg))-> ack & 0x01;
 }

}

