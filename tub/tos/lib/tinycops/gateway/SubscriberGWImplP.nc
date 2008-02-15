/* 
 * Copyright (c) 2007, Technische Universitaet Berlin
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
 * - Neither the name of the Technische Universitaet Berlin nor the names
 *   of its contributors may be used to endorse or promote products derived
 *   from this software without specific prior written permission.
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
 * - Revision -------------------------------------------------------------
 * $Revision$
 * $Date$
 * @author: Jan Hauer <hauer@tkn.tu-berlin.de>
 * ========================================================================
 */

#include "StdPublisher.h"
#include "TinyCOPS.h"
#include "Attributes.h"
#include "SubscriberGW.h"
generic module SubscriberGWImplP()
{
  uses {
    interface Boot;
    interface Leds;
    // WSN side
    interface Subscribe;
    interface PSMessageAccess;
    interface PSHandle;

    interface SplitControl as SubSplitControl;
    interface AMSend as SerialSend[am_id_t id];
    interface Receive as SerialReceive;
    interface Packet as SerialPacket;
    interface AMPacket;
    interface PacketAcknowledgements as SerialAck;
  }
} implementation {

  message_t subMsg, notMsg;
  message_t *notMsgPtr = &notMsg;
  bool subMsgFree = TRUE;
  bool notMsgFree = TRUE;
  uint8_t dupSuppressionBufLen = 0;
  uint8_t dupSuppressionBuf[TOSH_DATA_LENGTH];

  message_t* getMsg(notification_t *notification)
  {
    uint8_t offset;
    message_t tmpMsg;
    notification_t *tmpNot = call PSHandle.getNotificationHandle(&tmpMsg);
    offset = (uint8_t *) tmpNot  - (uint8_t *) &tmpMsg;
    return (message_t*)((uint8_t *) notification - offset);
  }

  uint8_t getSize(ps_item_t *first)
  {
    uint8_t size = 0;
    ps_item_t *ps_item = first;

    while (ps_item->control & PSITEM_ITEM){
      size += ps_item->control & PSITEM_SIZE_MASK;
      ps_item = (ps_item_t *) ((uint8_t*) ps_item + (ps_item->control & PSITEM_SIZE_MASK));
    }
    return size;
  }

  void task startUp()
  {
    call SubSplitControl.start();
  }

  event void Boot.booted()
  {
    post startUp();
  }

  event void SubSplitControl.startDone(error_t error){}
  event void SubSplitControl.stopDone(error_t error){}

  event message_t* SerialReceive.receive(message_t* msg, void* payload, uint8_t len)
  {
    error_t res = FAIL;
    nx_uint8_t clientID;
    uint8_t i;
    subscription_handle_t handle;
    avpair_t *avpair;
    subscription_t *subscription = (subscription_t *) payload;
    clientID = 0;

    if (len <= 2)
      return msg;

    // check for duplicates: workaround until the serial connection is reliable...
    if (dupSuppressionBufLen == len){
      for (i=0; i<dupSuppressionBufLen; i++)
        if ( ((uint8_t*)payload)[i] != dupSuppressionBuf[i])
          break;
      if (i == dupSuppressionBufLen)
        return msg; // duplicate !
    }
    dupSuppressionBufLen = len;
    memcpy(dupSuppressionBuf, payload, len);

    if (subMsgFree){
      handle = call PSHandle.getSubscriptionHandle(&subMsg);
      avpair = call PSMessageAccess.allocateMetadata(handle, len-2);
      if (!avpair)
        return msg;
      memcpy(((uint8_t *) avpair)-1, subscription, len);
      subMsgFree = FALSE;
      if (call PSMessageAccess.getMetadataViaId(subscription, FALSE_ATTRIBUTE_ID, 0))
        res = call Subscribe.unsubscribe(handle);
      else
        res = call Subscribe.subscribe(handle);
    }
    if (res == SUCCESS)
      call Leds.led2Toggle();
    return msg;
  }

  event void Subscribe.subscribeDone(
      subscription_handle_t handle, error_t error)
  {
    dbg("Broker", "Subscribe.subscribeDone, error code: %d\n", error);
    subMsgFree = TRUE;
  }
  
  event void Subscribe.unsubscribeDone(
      subscription_handle_t handle, error_t error)
  {
    dbg("Broker", "Subscribe.unsubscribeDone, error code: %d\n", error);
    subMsgFree = TRUE;
  }
  
  event void Subscribe.notificationReceived(notification_handle_t handle)
  {
    nx_uint8_t destClientID;
    uint8_t sizeAvailable=0, sizeNeeded;
    uint8_t *dest, *src = (uint8_t *) handle;
    am_id_t amid = AM_NOTIFICATION;

    destClientID = 0; // TODO
/*    if (uniqueCount(PSSUBSCRIBER_CLIENT) > 1){*/
      /*call PSMessageAccess.getAttributeIDs(handle, attributeID, &num);*/
      /*for (i=0; i<num; i++)*/
        /*if (attributeID[i] == ATTRIBUTE_CLIENT_ID){*/
          /*avpair = call PSMessageAccess.getAttributeByIndex(handle, i);*/
          /*avpair->value[0] = destClientID;*/
          /*break;*/
        /*}*/
      /*if (i==num)*/
        /*return;*/
    /*}*/
    dest = call SerialPacket.getPayload(notMsgPtr, 0);
    sizeAvailable = call SerialPacket.maxPayloadLength();
    sizeNeeded = getSize((ps_item_t *) handle);
#ifdef PSGW_FORWARD_MESSAGES
    {
      message_t *msg = getMsg(handle);
      sizeNeeded += (uint8_t *) handle - (uint8_t *)msg->data;
      amid = call AMPacket.type(msg);
      src = (uint8_t *)msg->data;
    }
#endif
    if (sizeNeeded > sizeAvailable)
      return;
    memcpy((uint8_t *) dest, (uint8_t *) src, sizeNeeded);
    notMsgFree = FALSE;
    if (call SerialSend.send[amid](destClientID, notMsgPtr, sizeNeeded) != SUCCESS)
      notMsgFree = TRUE;
  }

  default command error_t SerialSend.send[am_id_t id](am_addr_t addr, message_t* msg, uint8_t len)
  {
    return FAIL;
  }


  event void SerialSend.sendDone[am_id_t id](message_t* msg, error_t error)
  {
    call Leds.led2Toggle();
    notMsgPtr = msg;
    notMsgFree = TRUE;
  }
}
    
