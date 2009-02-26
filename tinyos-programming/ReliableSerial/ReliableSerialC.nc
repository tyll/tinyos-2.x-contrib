/*
 * Copyright (c) 2007-2009 Intel Corporation
 * All rights reserved.

 * This file is distributed under the terms in the attached INTEL-LICENS
 * file. If you do not find this file, a copy can be found by writing to
 * Intel Research Berkeley, 2150 Shattuck Avenue, Suite 1300, Berkeley, CA, 
 * 94704.  Attention:  Intel License Inquiry.
 */
#include "reliableserial.h"

module ReliableSerialC 
{
  provides {
    interface AMSend;
    interface Receive;
  }
  uses {
    interface AMSend as SubSend;
    interface AMSend as AckSend;
    interface Receive as SubReceive;
    interface Receive as AckReceive;
    interface Timer<TMilli>;
  }
}
implementation 
{
  message_t ackmsg;
  bool ackBusy;
  message_t *sending;
  uint8_t sendLen;
  am_addr_t sendAddr;
  uint8_t dropCount;

  uint8_t sendCookie = 1, recvCookie;

  void done(error_t ok) {
    message_t *sent = sending;

    sending = NULL;
    sendCookie *= 3; /* New cookie time! Cycles every 64 cookies. */
    signal AMSend.sendDone(sent, ok);
  }

  default event void AMSend.sendDone(message_t *msg, error_t error) { }

  command error_t AMSend.send(am_addr_t addr, message_t* msg, uint8_t len) {
    error_t ok = EBUSY;

    if (!sending)
      {
	reliable_msg_t *header = call SubSend.getPayload(msg, sizeof(reliable_msg_t));

	header->cookie = sendCookie;
	ok = call SubSend.send(addr, msg, len + sizeof(reliable_msg_t));
	if (ok == SUCCESS)
	  {
	    sending = msg;
	    sendAddr = addr;
	    sendLen = len;
	  }
      }
    return ok;
  }

  event void SubSend.sendDone(message_t *msg, error_t error) {
    if (error == SUCCESS)
      call Timer.startOneShot(ACK_TIMEOUT);
    else
      done(error);
  }

  event void Timer.fired() {
    error_t ok = call SubSend.send(sendAddr, sending, sendLen + sizeof(reliable_msg_t));
    if (ok != SUCCESS)
      done(ok);
  }

  event message_t *AckReceive.receive(message_t *m, void *payload, uint8_t len) {
    ack_msg_t *ack = payload;

#ifdef TESTING
    if (++dropCount == 5)
      {
	dropCount = 0;
	return m;
      }
#endif

    if (ack->cookie == sendCookie)
      {
	call Timer.stop();
	done(SUCCESS);
      }
    return m;
  }

  event message_t *SubReceive.receive(message_t *m, void *payload, uint8_t len) {
    reliable_msg_t *header;
    ack_msg_t *ack = call AckSend.getPayload(&ackmsg, sizeof(ack_msg_t));

#ifdef TESTING
    if (++dropCount == 5)
      {
	dropCount = 0;
	return m;
      }
#endif

    if (len < sizeof(reliable_msg_t))
      return m;
    header = payload;

    if (ack && !ackBusy)
      {
	/* We ack the received packet. We don't care if that fails (we'll
	   just try the ack again on the sender's retry...) */
	ack->cookie = header->cookie;
	if (call AckSend.send(TOS_BCAST_ADDR, &ackmsg, sizeof(ack_msg_t)) == SUCCESS)
	  ackBusy = TRUE;
      }

    /* Duplicate packet - ignore */
    if (header->cookie == recvCookie)
      return m;
    recvCookie = header->cookie;

    return signal Receive.receive(m, header->data, len - sizeof(reliable_msg_t));
  }

  event void AckSend.sendDone(message_t *msg, error_t error) {
    ackBusy = FALSE;
  }

 default event message_t *Receive.receive(message_t *m, void *payload, uint8_t len) {
    return m;
  }

  command error_t AMSend.cancel(message_t* msg) {
    if (msg == sending)
      {
	call Timer.stop();
	return SUCCESS;
      }
    else
      return FAIL;
  }

  command uint8_t AMSend.maxPayloadLength() {
    return call SubSend.maxPayloadLength() - sizeof(reliable_msg_t);
  }

  command void* AMSend.getPayload(message_t* msg, uint8_t len) {
    reliable_msg_t *header = call SubSend.getPayload(msg, len + sizeof(reliable_msg_t));

    return header ? header + 1 : NULL;
  }
}
