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
module AttributeCollectorP
{
  provides {
    interface AttributeCollection as Collection[uint8_t clientID]; // to the app
    // used by last service extension component in the chain (if any)
    interface AttributeIntercept as InterceptFinal; 
  } uses {
    interface AttributeValue[attribute_id_t attributeID];
    interface AttributeMatching[attribute_id_t attributeID];
    // provided by first service extension component in the chain grep(if any)
    interface AttributeIntercept as InterceptStart;
  }
} implementation {

  subscription_handle_t gSubscription;
  uint8_t numPending, gClientID;
  
  command bool Collection.isRegisteredAttribute[uint8_t clientID](attribute_id_t attributeID)
  {
    if (call AttributeValue.valueSize[attributeID]() != 0xFF)
      return TRUE;
    return FALSE;
  }
  
  command bool Collection.getValueSize[uint8_t clientID](attribute_id_t attributeID)
  {
    return call AttributeValue.valueSize[attributeID]();
  }  
  
  command bool Collection.isMatching[uint8_t clientID](avpair_t *avpair, constraint_t *constraint)
  {
    return call AttributeMatching.isMatching[avpair->attributeID](avpair, constraint);
  }
  
  command error_t Collection.getAttribute[uint8_t clientID](
      attribute_id_t attributeID, avpair_t *avpair, uint8_t maxValueSize, subscription_handle_t subscription)
  {
    if (!maxValueSize)
      return ESIZE;
    avpair->attributeID = attributeID;
    avpair->value[0] = clientID; // temporary storage
    if (subscription)
      return call InterceptStart.getAttribute(avpair, maxValueSize, subscription);
    else
      return call InterceptFinal.getAttribute(avpair, maxValueSize, subscription);
  }

  default command error_t InterceptStart.getAttribute(avpair_t *avpair, 
      uint8_t maxValueSize, subscription_handle_t subscription)
  {
    return call InterceptFinal.getAttribute(avpair, maxValueSize, subscription);
  }

  command error_t InterceptFinal.getAttribute(avpair_t *avpair, 
      uint8_t maxValueSize, subscription_handle_t subscription)
  {
    error_t result = EBUSY;
    if (call AttributeValue.valueSize[avpair->attributeID]() > maxValueSize)
      return ESIZE;
    if (numPending == 0){
      gClientID = avpair->value[0];
      gSubscription = subscription;
    }
    if (gSubscription == subscription){
      numPending++;
      result = call AttributeValue.getValue[avpair->attributeID](avpair->value, maxValueSize);
      if (result != SUCCESS)
        numPending--;
    }
    return result;
  }

  event void AttributeValue.getDone[attribute_id_t attributeID](void *value, uint8_t size, error_t result)
  {
    signal InterceptFinal.getAttributeDone((avpair_t *) ((uint8_t*) value - sizeof(avpair_t)), size, result, gSubscription);
  }

  default event void InterceptFinal.getAttributeDone(avpair_t *avpair, uint8_t size, error_t result, 
      subscription_handle_t subscription)
  {
    signal InterceptStart.getAttributeDone(avpair, size, result, subscription);
  }

  event void InterceptStart.getAttributeDone(avpair_t *avpair, uint8_t size, error_t result, 
      subscription_handle_t subscription)
  {
    numPending--;
    signal Collection.getAttributeDone[gClientID](avpair, size, subscription, result);
  }

  default command uint8_t AttributeValue.valueSize[attribute_id_t attributeID](){ return 0xFF;}
  default command error_t AttributeValue.getValue[attribute_id_t attributeID](void *value, uint8_t maxSize){ return FAIL; }
  default command bool AttributeMatching.isMatching[attribute_id_t attributeID](const avpair_t *avpair, const constraint_t *constraint)
  {
    return FALSE;
  }
  default event void Collection.getAttributeDone[uint8_t clientID](avpair_t *avpair, uint8_t size, subscription_handle_t handle, error_t result){}
}

