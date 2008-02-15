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
generic module StdPublisherP()
{
  uses {
    interface Publish;
    interface SubscriptionListener;
    interface PSHandle;
    interface PSMessageAccess;
    interface AttributeCollection;
    interface Timer<TMilli> as RateTimer;
    interface Random;
    interface Leds;
  }
} implementation {
  
  typedef enum {
    STATE_STOPPED,
    STATE_INIT,
    STATE_SLEEPING,
    STATE_COLLECTING,
    STATE_SENDING,
    STATE_CLEAN_UP,
    STATE_POWERED_DOWN,
  } state_t;

  state_t mState;

  
  // metadata attributes
  typedef nx_uint16_t metavalue_t;
  metavalue_t rate;
  metavalue_t count;
  
  // constraint buffer
  attribute_id_t constraintID[MAX_CONSTRAINTS];
  uint8_t numConstraints;
  uint8_t currentConstraint;
  // collection / send
  message_t msg;
  notification_handle_t nHandle;
  void collectNext();
 
  // debug / sim
#ifdef STATUS_SENDING_ENABLED  
  add_up_32_t rateCount = 0;
#endif 

  void restart()
  {
    uint8_t i, size;
    uint32_t initBackoff;
    uint32_t tmpRate;
    subscription_handle_t sHandle;
    avpair_t *metadata;
    
    if (call SubscriptionListener.getRegisteredSubscription(&sHandle) != SUCCESS){ 
      dbg("StdPublisher","StdPublisher: sHandle == null\n");
      return;
    }

    // check whether all requested attributes are registered
    numConstraints = MAX_CONSTRAINTS;
    if (call PSMessageAccess.getConstraintIDs(sHandle, constraintID, &numConstraints) != SUCCESS)
      return;
    if (!numConstraints)
      return;
    i = 0;
    while (i<numConstraints){
      if (constraintID[i] == FALSE_ATTRIBUTE_ID){
        dbg("StdPublisher","StdPublisher: received unsubscribe\n");
        return;
      } else if (!call AttributeCollection.isRegisteredAttribute(constraintID[i])){
        dbg("StdPublisher","StdPublisher: received request for unknown attribute: %d\n",constraintID[i]);
        return;
      }
      i++;
    }
    
    // update relevant metadata attributes
    rate = DEFAULT_RATE;
    count = DEFAULT_COUNT;
    metadata = call PSMessageAccess.getMetadataViaId(sHandle, RATE_ATTRIBUTE_ID, &size);
    if (metadata)
      rate = *((nx_uint16_t*) metadata->value);
    metadata = call PSMessageAccess.getMetadataViaId(sHandle, COUNT_ATTRIBUTE_ID, &size);
    if (metadata)
      count = *((nx_uint16_t*) metadata->value);
#if PLATFORM_EYESIFXV2 || PLATFORM_TELOSA || PLATFORM_TELOSB || PLATFORM_TMOTE
    metadata = call PSMessageAccess.getMetadataViaId(sHandle, REBOOT_ATTRIBUTE_ID, &size);
    if (metadata)
      WDTCTL = 0;
#endif
    mState = STATE_INIT;
    tmpRate = rate;
    tmpRate *= 102; // in 100 binary milliseconds
    initBackoff = call Random.rand32() % tmpRate;
    call RateTimer.startOneShot(initBackoff);
    dbg("StdPublisher", "StdPublisher initialized with random backoff %d, rate %d\n", initBackoff, rate);
  }
  
  task void update()
  {
    uint8_t oldState = mState;
    dbg("StdPublisher", "received a new subscription.\n");
    //call Leds.led0On();
    //call Leds.led1On();
    //call Leds.led2On(); 
    if (mState == STATE_POWERED_DOWN)
      return;
    call RateTimer.stop();
    if (oldState == STATE_COLLECTING || oldState == STATE_SENDING || oldState == STATE_CLEAN_UP)
      mState = STATE_CLEAN_UP; // restart later
    else
      restart();
    return;
  }

  event void SubscriptionListener.subscriptionReceived(subscription_handle_t handle)
  {
    post update();
  }
  
  event void SubscriptionListener.unsubscribed(subscription_handle_t handle)
  {
    post update();
  }
  
  event void RateTimer.fired() 
  {
    uint32_t rate_ms;
    
    if (count == 0){
      mState = STATE_STOPPED;
      call RateTimer.stop();
      return;
    } else if (count != INFINITE)
      count --;
#ifdef STATUS_SENDING_ENABLED  
    rateCount++;
#endif 
    if (mState == STATE_INIT){
      rate_ms = rate * 100; // rate is in 100 ms
      mState = STATE_SLEEPING;
      call RateTimer.startPeriodic(rate_ms); 
      // fall through
    }
    if (mState == STATE_SLEEPING){
      nHandle = call PSHandle.getNotificationHandle(&msg);
      mState = STATE_COLLECTING;
      currentConstraint = 0;
      collectNext();      
    } 
    if (mState == STATE_SENDING)
      dbg("Error", "RateTimer fired but I'm still busy sending (no route to parent?) !\n");
  }

  void collectNext()
  {
    avpair_t* avpairDest;
    uint8_t cID = constraintID[currentConstraint];
    subscription_handle_t sHandle = 0;
    call SubscriptionListener.getRegisteredSubscription(&sHandle);

    if (currentConstraint < numConstraints){
      uint8_t size = call AttributeCollection.getValueSize(cID);
      avpairDest = call PSMessageAccess.allocateAttribute(nHandle, size);
      if (!avpairDest || call AttributeCollection.getAttribute(cID, avpairDest, size, sHandle) 
          != SUCCESS)
        // discard and try next round; random rate shift to de-align publishers ?
        mState = STATE_SLEEPING;      
    } else {
      mState = STATE_SENDING;
      if (call Publish.publish(nHandle, FALSE) != SUCCESS)
        mState = STATE_SLEEPING;
    }
  }

  event void AttributeCollection.getAttributeDone(avpair_t *avpair, uint8_t size, subscription_handle_t sHandle, error_t result)
  {
    if (mState == STATE_CLEAN_UP){
      restart();
      return;
    } else if (mState != STATE_COLLECTING){
      dbg("Error", "StdPublisher AttributeCollection.dataReady internal error!\n");
      return;
    }
    if (result == SUCCESS)
      if (call SubscriptionListener.getRegisteredSubscription(&sHandle) == SUCCESS &&
          call AttributeCollection.isMatching(avpair, 
            call PSMessageAccess.getConstraintViaIndex(sHandle, currentConstraint, 0))){
        currentConstraint++;
        collectNext();
        return;
      }
    // could not get attribute or match was negative
    mState = STATE_SLEEPING;
  }
  
  event void Publish.publishDone(notification_handle_t handle, error_t error)
  {
    switch (mState)
    {
      case STATE_SENDING: mState = STATE_SLEEPING; break;
      case STATE_CLEAN_UP: restart(); break;
      case STATE_POWERED_DOWN: break; // do nothing
      default: break;
    }
  }
}

