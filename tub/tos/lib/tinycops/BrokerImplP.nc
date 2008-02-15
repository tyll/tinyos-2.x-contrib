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
#include "TinyCOPS.h"
#include "Attributes.h"
module BrokerImplP 
{
  provides {
    interface Publish[uint8_t clientID];
    interface Subscribe[uint8_t clientID];
    interface SubscriptionListener[uint8_t clientID];
    
    interface SubscriptionFilter<CSEC_OUTBOUND> as SubscriptionFilterOut;
    interface SubscriptionFilter<CSEC_INBOUND> as SubscriptionFilterIn;
    interface NotificationFilter<CSEC_OUTBOUND>  as NotificationFilterOut;
    interface NotificationFilter<CSEC_INBOUND>  as NotificationFilterIn;

    interface PSHandle[uint8_t clientID];
    interface PSMessageAccess;
    interface Get<subscription_handle_t> as GetSubscription[uint8_t clientID]; 
  } uses {
    interface Boot;
    interface Leds;
    interface SplitControl as SubSplitControl;
    interface AMPacket;
    interface AttributeCollection;
    
    interface Send as SendSubscription[uint8_t clientID];
    interface Packet as PacketSubscription[uint8_t clientID];
    interface Receive as ReceiveSubscription[uint8_t clientID];
    interface Intercept as InterceptSubscription[uint8_t clientID];
    interface Get<am_id_t> as GetSubscriptionAMID[uint8_t clientID];
    interface RootControl[uint8_t clientID];
    interface AttributeValue as InsertSourceAddress[uint8_t clientID];

    interface Send as SendNotification[uint8_t clientID];
    interface Packet as PacketNotification[uint8_t clientID];
    interface Receive as ReceiveNotification[uint8_t clientID];
    interface Intercept as InterceptNotification[uint8_t clientID];
    interface Get<am_id_t> as GetNotificationAMID[uint8_t clientID];
  }
} implementation {
 
  enum {
    CTL_SUBSCRIBER = 1,
    CTL_DIRTY = 2,
    CTL_ACTIVE = 4,
    CTL_SENDBUSY = 8,
    
    TABLE_ENTRIES = uniqueCount(PSCLIENT_ID),

    TYPE_AVPAIR = 0,
    TYPE_CONSTRAINT = 1,

    MAGIC_NUMBER = 0xbeef,
  };
  
  typedef struct
  {
    uint8_t control;
    uint8_t data[MAX_SUBSCRIPTION_SIZE];
  } subtable_entry_t;
  
  subtable_entry_t subtable[TABLE_ENTRIES];
  
  bool isUnsubscribe(subscription_t *subscription); 
  bool matches(notification_t *notification, subscription_t *subscription);
  message_t* getMsg(ps_item_t *first, uint8_t clientID, bool isSubscription);
  uint8_t getSize(ps_item_t *first);
  bool isMatchingSubscriber(subscription_t *arrived, subscription_t *registered, uint8_t clientID);

  error_t getIDs(ps_item_t *first, attribute_id_t attributeID[], uint8_t *numEntries, uint8_t type);
  error_t getNumEntries(ps_item_t *first, uint8_t *num, uint8_t type);
  void *getItemByIndex(ps_item_t *first, uint8_t indexNum, uint8_t type);
  void *allocateItem(ps_item_t *first, uint8_t datasize, uint8_t type);
  error_t getValueByID(ps_item_t* first, attribute_id_t id, void *value, uint8_t *maxValueSize, uint8_t type);
  void *getItemViaID(ps_item_t *first, attribute_id_t id, uint8_t *valueSize, uint8_t type);
  void *getItemViaIndex(ps_item_t *first, uint8_t _index, uint8_t *valueSize, uint8_t type);

  task void startSub()
  {
    call SubSplitControl.start();
  }
    
  event void Boot.booted()
  {
    uint8_t i;
    call Leds.led0On();
    call Leds.led1On();
    call Leds.led2On();
    for (i=0; i<TABLE_ENTRIES; i++)
      subtable[i].control = 0;
    post startSub();
  }

  event void SubSplitControl.startDone(error_t error){}
  event void SubSplitControl.stopDone(error_t error){}

  /******************************/
  /*         SUBSCRIBE          */
  /******************************/

  command error_t Subscribe.subscribe[uint8_t clientID](subscription_handle_t subscription)
  {
    error_t result;
    uint8_t size = 0;
    message_t* msg = getMsg((ps_item_t*) subscription, clientID, TRUE);
   
    if (call AMPacket.source(msg) != MAGIC_NUMBER) 
      return EINVAL; // subscription was created by different client
    if (!signal SubscriptionFilterOut.forward(subscription, FALSE))
      return SUCCESS;
    size = getSize((ps_item_t*) subscription);
    if (size > MAX_SUBSCRIPTION_SIZE)
      return ESIZE; // does not fit in subscription table
    if (subtable[clientID].control & CTL_SENDBUSY)
      return EBUSY; // busy sending subscription
    subtable[clientID].control |= CTL_SENDBUSY;
    result = call SendSubscription.send[clientID](msg, size); 
    dbg("Broker", "Subscribe.send result = %d\n", result);
    if (result != SUCCESS){
      subtable[clientID].control &= ~CTL_SENDBUSY;
      call AMPacket.setSource(msg, MAGIC_NUMBER);
    } else
      call RootControl.setRoot[clientID]();
    return result;
  }

  command error_t Subscribe.unsubscribe[uint8_t clientID](subscription_handle_t subscription)
  {
    avpair_t *avpair;
    message_t* msg = getMsg((ps_item_t*) subscription, clientID, TRUE);
   
    call PSHandle.getSubscriptionHandle[clientID](msg); //reset
    avpair = call PSMessageAccess.allocateMetadata(subscription, 1);
    if (avpair){
      // an unsubscribe is internally represented by a subscription containing
      // the "FALSE attribute", which can never be matched by a notification
      avpair->attributeID = FALSE_ATTRIBUTE_ID;
      avpair->value[0] = 0;
    } else return ESIZE;
    return call Subscribe.subscribe[clientID](subscription);
  }

  event void SendSubscription.sendDone[uint8_t clientID](message_t* msg, error_t error)
  {
    uint8_t size =  call PacketSubscription.payloadLength[clientID](msg);
    subscription_t *subscription = call PacketSubscription.getPayload[clientID](msg, size);
    call Leds.led1Toggle();
    if (error == SUCCESS){
      memcpy(&(subtable[clientID].data), subscription, size); // update subscription table
      subtable[clientID].control |= CTL_DIRTY;
      dbg("Broker", "Successful Subscribe.sendDone");
    } else dbg("Broker", "FAILED Subscribe.sendDone");
    call AMPacket.setSource(msg, MAGIC_NUMBER);
    subtable[clientID].control &= ~CTL_SENDBUSY;
    if (isUnsubscribe(subscription)){
      subtable[clientID].control &= ~CTL_SUBSCRIBER;
      signal Subscribe.unsubscribeDone[clientID](subscription, error);
    } else {
      subtable[clientID].control |= CTL_SUBSCRIBER;
      signal Subscribe.subscribeDone[clientID](subscription, error);
    }
  }

  event message_t* ReceiveSubscription.receive[uint8_t clientID](message_t* msg, void* payload, uint8_t len)
  {
    uint8_t destClient = 0xFF, freeClient = 0xFF;
    uint8_t i;
    subscription_t *subscription = payload;
    error_t result = FAIL;
    am_id_t subAMID = call AMPacket.type(msg);
    nx_am_id_t notAMID;
    avpair_t *metadata;
    notAMID = 0xFF;

    call Leds.led1Toggle();
    dbg("Broker", "Received subscription");
    if (len > MAX_SUBSCRIPTION_SIZE){
      dbg("Broker", "Subscription size too big ! len = %d\n", len);
      return msg;
    }
    if (!signal SubscriptionFilterIn.forward(subscription, FALSE))
      return msg;
    metadata = call PSMessageAccess.getMetadataViaId(
      subscription, ATTRIBUTE_NOTIFICATION_AMID, 0);
    if (metadata)
      notAMID = *((nx_am_id_t*) metadata->value);

    for (i=0; i<TABLE_ENTRIES; i++)
      if (subAMID == call GetSubscriptionAMID.get[i]() &&
          notAMID == call GetNotificationAMID.get[i]())
        if (isMatchingSubscriber(subscription, (subscription_t*) &(subtable[i].data), clientID))
        {
          // update an existing entry
          destClient = i;
          result = SUCCESS;
          break;
        } else if (!(subtable[i].control & CTL_ACTIVE)){
          // remember this one
          freeClient = i;
        }
    if (result != SUCCESS && freeClient != 0xFF){
      destClient = freeClient;
      result = SUCCESS;
    }
    if (result == SUCCESS){
      memcpy(&(subtable[destClient].data), subscription, len);
      subtable[destClient].control |= CTL_DIRTY;
      if (isUnsubscribe(subscription)){
        subtable[destClient].control &= ~CTL_ACTIVE;
        signal SubscriptionListener.unsubscribed[destClient]((subscription_t*) &(subtable[destClient].data));
      } else {
        subtable[destClient].control |= CTL_ACTIVE;
        signal SubscriptionListener.subscriptionReceived[destClient]((subscription_t*) &(subtable[destClient].data));
      }
    }
    return msg;
  }

  command error_t SubscriptionListener.getRegisteredSubscription[uint8_t clientID](subscription_t** handle)
  {
    if (subtable[clientID].control & CTL_DIRTY){
      *handle = (subscription_t*) &(subtable[clientID].data);
      return SUCCESS;
    } else
      return FAIL;
  }

  command subscription_handle_t GetSubscription.get[uint8_t clientID]()
  {
    return (subscription_t*) &(subtable[clientID].data);
  }

  event bool InterceptSubscription.forward[uint8_t clientID](message_t* msg, void* payload, uint8_t len)
  {
    return signal SubscriptionFilterIn.forward((subscription_t*) payload, TRUE);
  }

  /******************************/
  /*           PUBLISH          */
  /******************************/

  command error_t Publish.publish[uint8_t clientID](notification_handle_t notification, bool push)
  {
    error_t result = FAIL;
    subscription_t *subscription;
    message_t* msg = getMsg((ps_item_t*) notification, clientID, FALSE);
    
    if (call AMPacket.source(msg) != MAGIC_NUMBER) 
      return EINVAL; // safety check: subscription was created by different client
    if (!push && call SubscriptionListener.getRegisteredSubscription[clientID](&subscription) != SUCCESS)
      return FAIL;
    if (subtable[clientID].control & CTL_SENDBUSY)
      return EBUSY;
    if (!signal NotificationFilterOut.forward(notification, subscription, FALSE)){
      signal Publish.publishDone[clientID](notification, SUCCESS); // move into separate task ?
      return SUCCESS;
    }
    else if (push || matches(notification, subscription)){
      subtable[clientID].control |= CTL_SENDBUSY;
      result = call SendNotification.send[clientID](msg, getSize((ps_item_t*) notification));
      dbg("Broker", "Sending notification from client %d with result %d\n", clientID, result);
      if (result != SUCCESS){
        subtable[clientID].control &= ~CTL_SENDBUSY;
        call AMPacket.setSource(msg, MAGIC_NUMBER);
      }
    }
    return result;
  }
  
  event void SendNotification.sendDone[uint8_t clientID](message_t* msg, error_t error)
  {
    notification_t *notification = call PacketNotification.getPayload[clientID](msg, 0);
    dbg("Broker", "Notification was sent ");
 
    if (error == SUCCESS){
      call Leds.led0Toggle();
      dbg("Broker", "successfully\n");
    } else dbg("Broker", "unsuccessfully\n");
    call AMPacket.setSource(msg, MAGIC_NUMBER);
    subtable[clientID].control &= ~CTL_SENDBUSY;
    signal Publish.publishDone[clientID](notification, error);
  }

  event message_t* ReceiveNotification.receive[uint8_t clientID](message_t* msg, void* payload, uint8_t len)
  {
    uint8_t i;
    notification_t *notification;

    dbg("Broker", "Notification arrived");
    notification = (notification_t *) payload;
    for (i=0; i<TABLE_ENTRIES; i++)
      if (subtable[i].control & CTL_SUBSCRIBER){
        if (matches(notification, (subscription_t*) subtable[i].data)){
          if (signal NotificationFilterIn.forward(notification, (subscription_t*) subtable[i].data, FALSE))
            signal Subscribe.notificationReceived[i](notification);
      }
    }
    return msg;
  }
  
  event bool InterceptNotification.forward[uint8_t clientID](message_t* msg, void* payload, uint8_t len)
  {
    uint8_t i;
    notification_t *notification;

    dbg("Broker", "Notification arrived");
    notification = (notification_t *) payload;
    for (i=0; i<TABLE_ENTRIES; i++)
      if (matches(notification, (subscription_t*) subtable[i].data))
        return signal NotificationFilterIn.forward(notification, (subscription_t*) subtable[i].data, TRUE);
    return TRUE;
  }
   
  /******************************/
  /*       MESSAGE ACCESS       */
  /******************************/

  command error_t PSMessageAccess.numAttributes(notification_handle_t handle, uint8_t *num)
  {
    return getNumEntries((ps_item_t *) handle, num, TYPE_AVPAIR);
  }
    
  command error_t PSMessageAccess.numConstraints(subscription_handle_t handle, uint8_t *num)
  {
    return getNumEntries((ps_item_t *) handle, num, TYPE_CONSTRAINT);
  }
    
  command error_t PSMessageAccess.numMetadata(subscription_handle_t handle, uint8_t *num)
  {
    return getNumEntries((ps_item_t *) handle, num, TYPE_AVPAIR);
  }
  
  command error_t PSMessageAccess.getAttributeIDs(notification_handle_t handle, attribute_id_t *id, uint8_t *num)
  {
    return getIDs((ps_item_t*) handle, id, num, TYPE_AVPAIR);
  }
    
  command error_t PSMessageAccess.getConstraintIDs(subscription_handle_t handle, attribute_id_t *id, uint8_t *num)
  {
    return getIDs((ps_item_t*) handle, id, num, TYPE_CONSTRAINT);
  }
    
  command error_t PSMessageAccess.getMetadataIDs(subscription_handle_t handle, attribute_id_t *id, uint8_t *num)
  {
    return getIDs((ps_item_t*) handle, id, num, TYPE_AVPAIR);
  }

  command avpair_t* PSMessageAccess.getAttributeViaId(notification_handle_t handle, attribute_id_t id, uint8_t *valueSize)
  {
    return (avpair_t*) getItemViaID((ps_item_t*) handle, id, valueSize, TYPE_AVPAIR);
  }

  command constraint_t *PSMessageAccess.getConstraintViaId(subscription_handle_t handle, attribute_id_t id, uint8_t *valueSize)
  {
    return (constraint_t*) getItemViaID((ps_item_t*) handle, id, valueSize, TYPE_CONSTRAINT);
  }

  command avpair_t *PSMessageAccess.getMetadataViaId(subscription_handle_t handle, attribute_id_t id, uint8_t *valueSize)
  {
    return (avpair_t*) getItemViaID((ps_item_t*) handle, id, valueSize, TYPE_AVPAIR);
  }

  command avpair_t *PSMessageAccess.getAttributeViaIndex(notification_handle_t handle, uint8_t _index, uint8_t *valueSize)
  {
    return (avpair_t*) getItemViaIndex((ps_item_t*) handle, _index, valueSize, TYPE_AVPAIR);
  }
  command constraint_t *PSMessageAccess.getConstraintViaIndex(subscription_handle_t handle, uint8_t _index, uint8_t *valueSize)
  {
    return (constraint_t*) getItemViaIndex((ps_item_t*) handle, _index, valueSize, TYPE_CONSTRAINT);
  }
  command avpair_t *PSMessageAccess.getMetadataViaIndex(subscription_handle_t handle, uint8_t _index, uint8_t *valueSize)
  {
    return (avpair_t*) getItemViaIndex((ps_item_t*) handle, _index, valueSize, TYPE_AVPAIR);
  }

  command constraint_t* PSMessageAccess.allocateConstraint(
      subscription_t* subscription, uint8_t size)
  {
    return (constraint_t*) allocateItem((ps_item_t *) subscription, size, TYPE_CONSTRAINT);
  }

  command avpair_t* PSMessageAccess.allocateMetadata(
      subscription_t *sub, uint8_t datasize)
  {
    return (avpair_t*) allocateItem((ps_item_t *) sub, datasize, TYPE_AVPAIR);
  }    

  command subscription_handle_t PSHandle.getSubscriptionHandle[uint8_t clientID](message_t* msg)
  {
    uint8_t vsize, max = call SendSubscription.maxPayloadLength[clientID]();
    ps_item_t *first = call PacketSubscription.getPayload[clientID](msg, 0);
    nx_am_id_t amID;
    amID = call GetNotificationAMID.get[clientID]();

    call AMPacket.setSource(msg, MAGIC_NUMBER);
    if (max & PSITEM_ITEM)
      max = 0x7F;
    first->control = max;
    if (amID != 0xFF){
      avpair_t *avpair;
      avpair = call PSMessageAccess.allocateMetadata((subscription_t*) first, sizeof(nx_am_id_t));
      if (avpair){
        avpair->attributeID = ATTRIBUTE_NOTIFICATION_AMID;
        avpair->value[0] = amID;
      }
    }
    if ((vsize = call InsertSourceAddress.valueSize[clientID]()) > 0){
      avpair_t *avpair;
      avpair = call PSMessageAccess.allocateMetadata((subscription_t*) first, vsize);
      call InsertSourceAddress.getValue[clientID](avpair->value, vsize);
      avpair->attributeID = ATTRIBUTE_SUBSCRIBER_ADDRESS;
    }
    if (uniqueCount(PSCLIENT_ID) > 1){
      avpair_t *avpair;
      avpair = call PSMessageAccess.allocateMetadata((subscription_t*) first, 1);
      if (avpair){
        avpair->attributeID = ATTRIBUTE_CLIENT_ID;
        avpair->value[0] = clientID;
      }
    }
    return (subscription_handle_t) first;
  }

  command avpair_t* PSMessageAccess.allocateAttribute(
      notification_t *notification, uint8_t datasize)
  {
    return (avpair_t*) allocateItem((ps_item_t *) notification, datasize, TYPE_AVPAIR);
  }

  command notification_handle_t PSHandle.getNotificationHandle[uint8_t clientID](message_t* msg)
  {
    uint8_t max = call SendNotification.maxPayloadLength[clientID]();
    ps_item_t *first = call PacketNotification.getPayload[clientID](msg,0);
    call AMPacket.setSource(msg, MAGIC_NUMBER);
    if (max & PSITEM_ITEM)
      max = 0x7F;
    first->control = max;
    return (notification_handle_t) first;
  }
  /******************************/
  /*      HELPER FUNCTIONS      */
  /******************************/

  // returns a pointer to the constraint/avpair
  void *getItemViaID(ps_item_t *first, attribute_id_t id, uint8_t *destValueSize, uint8_t type)
  {
    ps_item_t *ps_item = first;

    if (ps_item->control & PSITEM_ITEM){ // check if there are any items
      do {
        if (ps_item->control & PSITEM_CONSTRAINT){
          if (type == TYPE_CONSTRAINT && ps_item->constraint.attributeID == id){
            if (destValueSize)
              *destValueSize = (ps_item->control & PSITEM_SIZE_MASK) - 1 - sizeof(constraint_t);
            return &ps_item->constraint;
          }
        } else {
          if (type == TYPE_AVPAIR && ps_item->constraint.attributeID == id){
            if (destValueSize)
              *destValueSize = (ps_item->control & PSITEM_SIZE_MASK) - 1 - sizeof(avpair_t);
            return &ps_item->avpair;
          }
        }
        ps_item = (ps_item_t *) ((uint8_t*) ps_item + (ps_item->control & PSITEM_SIZE_MASK));
        if (!(ps_item->control & PSITEM_ITEM))
          break;
      } while (TRUE);
    }
    if (destValueSize)
      *destValueSize = 0;
    return 0;
  }

  // returns a pointer to the constraint/avpair
  void *getItemViaIndex(ps_item_t *first, uint8_t indexNum, uint8_t *valueSize, uint8_t type)
  {
    uint8_t num = 0;
    ps_item_t *ps_item = first;

    if (ps_item->control & PSITEM_ITEM){ // check if there are any items
      do {
        if (ps_item->control & PSITEM_CONSTRAINT){
          if (type == TYPE_CONSTRAINT)
            if (num++ == indexNum){
              if (valueSize)
                *valueSize = (ps_item->control & PSITEM_SIZE_MASK) - 1 - sizeof(constraint_t);
              return &ps_item->constraint;
            }
        } else {
          if (type == TYPE_AVPAIR)
            if (num++ == indexNum){
              if (valueSize)
                *valueSize = (ps_item->control & PSITEM_SIZE_MASK) - 1 - sizeof(avpair_t);
              return &ps_item->avpair;
            }
        }
        ps_item = (ps_item_t *) ((uint8_t*) ps_item + (ps_item->control & PSITEM_SIZE_MASK));
        if (!(ps_item->control & PSITEM_ITEM))
          break;
      } while (TRUE);
    }
    if (valueSize)
      *valueSize = 0;
    return 0;
  }

  error_t getIDs(ps_item_t *first, attribute_id_t attributeID[], uint8_t *numEntries, uint8_t type)
  {
    uint8_t num = 0;
    uint8_t maxNum = *numEntries;
    ps_item_t *ps_item = first;

    while (ps_item->control & PSITEM_ITEM) {
      if (ps_item->control & PSITEM_CONSTRAINT){
        if (type == TYPE_CONSTRAINT)
          if (num < maxNum)
            attributeID[num++] = ps_item->constraint.attributeID;
          else
            return ESIZE;
      } else {
        if (type == TYPE_AVPAIR)
          if (num < maxNum)
            attributeID[num++] = ps_item->constraint.attributeID;
          else
            return ESIZE;
      }
      ps_item = (ps_item_t *) ((uint8_t*) ps_item + (ps_item->control & PSITEM_SIZE_MASK));
      if (!(ps_item->control & PSITEM_ITEM))
        break;
    }
    *numEntries = num;
    return SUCCESS;
  }

  error_t getNumEntries(ps_item_t *first, uint8_t *numEntries, uint8_t type)
  {
    uint8_t num = 0;
    ps_item_t *ps_item = first;

    if (ps_item->control & PSITEM_ITEM){ // check if there are any items
      do {
        if (ps_item->control & PSITEM_CONSTRAINT){
          if (type == TYPE_CONSTRAINT)
            num++;
        } else {
          if (type == TYPE_AVPAIR)
            num++;
        }
        ps_item = (ps_item_t *) ((uint8_t*) ps_item + (ps_item->control & PSITEM_SIZE_MASK));
        if (!(ps_item->control & PSITEM_ITEM))
          break;
      } while (TRUE);
    }
    *numEntries = num;
    return SUCCESS;
  }

  void *getItemByIndex(ps_item_t *first, uint8_t indexNum, uint8_t type)
  {
    uint8_t num = 0;
    ps_item_t *ps_item = first;

    if (ps_item->control & PSITEM_ITEM){ // check if there are any items
      do {
        if (ps_item->control & PSITEM_CONSTRAINT){
          if (type == TYPE_CONSTRAINT)
            if (num++ == indexNum)
              return &ps_item->constraint;
        } else {
          if (type == TYPE_AVPAIR)
            if (num++ == indexNum)
              return &ps_item->avpair;
        }
        ps_item = (ps_item_t *) ((uint8_t*) ps_item + (ps_item->control & PSITEM_SIZE_MASK));
        if (!(ps_item->control & PSITEM_ITEM))
          break;
      } while (TRUE);
    }
    return 0;
  }

  void *allocateItem(ps_item_t *first, uint8_t datasize, uint8_t type)
  {
    uint8_t itemSize;
    ps_item_t *ps_item = first;
    uint8_t max;

    itemSize = 1 + (type == TYPE_CONSTRAINT ? sizeof(constraint_t) : sizeof(avpair_t)) + datasize;
    while (ps_item->control & PSITEM_ITEM)
      ps_item = (ps_item_t *) ((uint8_t*) ps_item + (ps_item->control & PSITEM_SIZE_MASK));
    max = ps_item->control & PSITEM_SIZE_MASK;
    if (itemSize+1 <= max){
      ps_item->control = itemSize;
      ps_item->control |=  PSITEM_ITEM;
      if (type == TYPE_CONSTRAINT)
        ps_item->control = ps_item->control | PSITEM_CONSTRAINT;
      ((ps_item_t *)((uint8_t*) ps_item + itemSize))->control = max - itemSize;
      return (void *) &ps_item->avpair;
    }
    return 0;
  }

  error_t getValueByID(ps_item_t* first, attribute_id_t id, void *value, uint8_t *maxValueSize, uint8_t type)
  {
    uint8_t i, valueSize;
    ps_item_t *ps_item = first;

    if (!value)
      return ESIZE;

    if (ps_item->control & PSITEM_ITEM){ // check if there are any items
      do {
        if (ps_item->control & PSITEM_CONSTRAINT){
          if (type == TYPE_CONSTRAINT && ps_item->constraint.attributeID == id){
            valueSize = (ps_item->control & PSITEM_SIZE_MASK) - 1 - sizeof(constraint_t);
            if (valueSize <= *maxValueSize){
              for (i=0; i<valueSize; i++)
                ((uint8_t*)value)[i] = ps_item->constraint.value[i];
              *maxValueSize = valueSize;
              return SUCCESS;
            } else {
              *maxValueSize = 0;
              return FAIL;
            }
          }
        } else {
          if (type == TYPE_AVPAIR && ps_item->constraint.attributeID == id){
            valueSize = (ps_item->control & PSITEM_SIZE_MASK) - 1 - sizeof(avpair_t);
            if (valueSize <= *maxValueSize){
              for (i=0; i<valueSize; i++)
                ((uint8_t*)value)[i] = ps_item->avpair.value[i];
              *maxValueSize = valueSize;
              return SUCCESS;
            } else {
              *maxValueSize = 0;
              return FAIL;
            }
          }
        }
        ps_item = (ps_item_t *) ((uint8_t*) ps_item + (ps_item->control & PSITEM_SIZE_MASK));
        if (!(ps_item->control & PSITEM_ITEM))
          break;
      } while (TRUE);
    }
    *maxValueSize = 0;
    return FAIL;
  }


  uint8_t getSize(ps_item_t *first)
  {
    uint8_t size = 0;
    ps_item_t *ps_item = first;

    while (ps_item->control & PSITEM_ITEM){
      size += ps_item->control & PSITEM_SIZE_MASK;
      ps_item = (ps_item_t *) ((uint8_t*) ps_item + (ps_item->control & PSITEM_SIZE_MASK));
    }
    size += 1; // last length byte
    return size;
  }

  bool matches(notification_t *notification, subscription_t *subscription)
  {
    ps_item_t * nItems = (ps_item_t *) notification;
    ps_item_t * sItems = (ps_item_t *) subscription;

    if (!(sItems->control & PSITEM_ITEM))
      return TRUE; // no constraints
    if (!(nItems->control & PSITEM_ITEM))
      return FALSE; // no attributes
    do {
      if (sItems->control & PSITEM_CONSTRAINT){
        nItems = (ps_item_t *) notification;
        do {
          if (!(nItems->control & PSITEM_CONSTRAINT) && 
              sItems->constraint.attributeID == nItems->avpair.attributeID)
            if (call AttributeCollection.isMatching(&nItems->avpair, &sItems->constraint))
              break; // constraint matched, break from inner loop
          nItems = (ps_item_t *) ((uint8_t*) nItems + (nItems->control & PSITEM_SIZE_MASK));
          if (!(nItems->control & PSITEM_ITEM))
            return FALSE;
        } while(TRUE);
      }
      sItems = (ps_item_t *) ((uint8_t*) sItems + (sItems->control & PSITEM_SIZE_MASK));
      if (!(sItems->control & PSITEM_ITEM))
        break;
    } while (TRUE);
    return TRUE;
  }

  bool isUnsubscribe(subscription_t *subscription)
  {
    uint8_t buf[1];
    uint8_t size = 1;
    if (getValueByID((ps_item_t *)subscription, FALSE_ATTRIBUTE_ID, buf, &size, TYPE_CONSTRAINT) == SUCCESS)
      return TRUE;
    return FALSE;
  }

  message_t* getMsg(ps_item_t *first, uint8_t clientID, bool isSubscription)
  {
    message_t tmp;
    uint8_t offset;
    if (isSubscription)
      offset = (uint8_t*)call PacketSubscription.getPayload[clientID](&tmp, 0) - ((uint8_t*)&tmp);
    else
      offset = (uint8_t*)call PacketNotification.getPayload[clientID](&tmp, 0) - ((uint8_t*)&tmp);
    return (message_t*) ((uint8_t*) first - offset);
  }

  event void AttributeCollection.getAttributeDone(avpair_t *avpair, uint8_t size, subscription_handle_t handle, error_t result)
  {
    return; // will not happen
  }
    
  bool isMatchingSubscriber(subscription_t *arrived, subscription_t *registered, uint8_t clientID)
  {
    // check for (optional) information that identifies a subscriber by
    // its address (whatever addressing scheme) and client ID.
    uint8_t len1=10, len2=10, i;
    uint8_t data1[10], data2[10];
    avpair_t *m1,*m2;

    m1 = call PSMessageAccess.getMetadataViaId(
      arrived, ATTRIBUTE_SUBSCRIBER_ADDRESS, &len1);
    m2 = call PSMessageAccess.getMetadataViaId(
      registered, ATTRIBUTE_SUBSCRIBER_ADDRESS, &len2);
    if ((m1 && !m2) || (m2 && !m1))
      return FALSE;
    if (len1 == len2){
      for (i=0; i<len1; i++)
        if (data1[i] != data2[i])
          return FALSE;
    } else return FALSE;

    len1 = len2 = 10;
    m1 = call PSMessageAccess.getMetadataViaId(
      arrived, ATTRIBUTE_CLIENT_ID, &len1);
    m2 = call PSMessageAccess.getMetadataViaId(
      registered, ATTRIBUTE_CLIENT_ID, &len2);
    if ((m1 && !m2) || (m2 && !m1))
      return FALSE;
    if (len1 != len2 || (len1 && (m1->value[0] != m2->value[0])))
      return FALSE;
    return TRUE;
  }
  
  default event void Publish.publishDone[uint8_t clientID](notification_handle_t handle, error_t error){}
  default command error_t SendNotification.cancel[uint8_t clientID](message_t* msg){ return FAIL; }
  default command uint8_t SendNotification.maxPayloadLength[uint8_t clientID](){ return 0;}
  default command error_t SendNotification.send[uint8_t clientID](message_t* msg, uint8_t len){return FAIL;}
  default command void* PacketNotification.getPayload[uint8_t clientID](message_t* msg, uint8_t len){return msg->data;}
  default command void* PacketSubscription.getPayload[uint8_t clientID](message_t* msg, uint8_t len){return msg->data;}
  default command uint8_t PacketSubscription.payloadLength[uint8_t clientID](message_t* msg){return 0;}

  default event void Subscribe.subscribeDone[uint8_t clientID](subscription_handle_t handle, error_t error){}
  default event void Subscribe.unsubscribeDone[uint8_t clientID](subscription_handle_t handle, error_t error){}
  default event void Subscribe.notificationReceived[uint8_t clientID](notification_t* notification){return;}
  default command error_t SendSubscription.send[uint8_t clientID](message_t* msg, uint8_t len){ return FAIL; }
  default command error_t SendSubscription.cancel[uint8_t clientID](message_t* msg){ return FAIL; }
  default command uint8_t SendSubscription.maxPayloadLength[uint8_t clientID](){ return 0;}
  default event void SubscriptionListener.subscriptionReceived[uint8_t clientID](subscription_t* subscription){}
  default event void SubscriptionListener.unsubscribed[uint8_t clientID](subscription_handle_t handle){}

  default command am_id_t GetNotificationAMID.get[uint8_t clientID](){ return 0xFF;}
  default command am_id_t GetSubscriptionAMID.get[uint8_t clientID](){ return 0xFF;}
  default command error_t RootControl.setRoot[uint8_t clientID](){ return FAIL;}

  default event bool SubscriptionFilterOut.forward(subscription_handle_t sHandle, bool isIntercept){return TRUE;}
  default event bool SubscriptionFilterIn.forward(subscription_handle_t sHandle, bool isIntercept){return TRUE;}
  default event bool NotificationFilterOut.forward(notification_handle_t nHandle, subscription_handle_t sHandle, bool isIntercept){return TRUE;}
  default event bool NotificationFilterIn.forward(notification_handle_t nHandle, subscription_handle_t sHandle, bool isIntercept){return TRUE;}
  default command error_t InsertSourceAddress.getValue[uint8_t clientID](void *value, uint8_t maxSize){return FAIL;}
  default command error_t InsertSourceAddress.valueSize[uint8_t clientID](){return 0;}
  event void InsertSourceAddress.getDone[uint8_t clientID](void *value, uint8_t _size, error_t result){}
}

