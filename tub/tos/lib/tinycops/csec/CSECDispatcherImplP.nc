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
#include "CSECClient.h"
module CSECDispatcherImplP
{
  provides {
    interface SubscriptionFilter<CSEC_OUTBOUND> as SubscriptionFilterOut[uint8_t clientID];
    interface SubscriptionFilter<CSEC_INBOUND> as SubscriptionFilterIn[uint8_t clientID];
    interface NotificationFilter<CSEC_OUTBOUND>  as NotificationFilterOut[uint8_t clientID];
    interface NotificationFilter<CSEC_INBOUND>  as NotificationFilterIn[uint8_t clientID];
  } uses {
    interface Boot;
    interface SubscriptionFilter<CSEC_OUTBOUND> as BrokerSubscriptionFilterOut;
    interface SubscriptionFilter<CSEC_INBOUND> as BrokerSubscriptionFilterIn;
    interface NotificationFilter<CSEC_OUTBOUND>  as BrokerNotificationFilterOut;
    interface NotificationFilter<CSEC_INBOUND>  as BrokerNotificationFilterIn;

    interface Get<uint8_t> as GetClientPrioritySubscriptionOut[uint8_t clientID];
    interface Get<uint8_t> as GetClientPrioritySubscriptionIn[uint8_t clientID];
    interface Get<uint8_t> as GetClientPriorityNotificationOut[uint8_t clientID];
    interface Get<uint8_t> as GetClientPriorityNotificationIn[uint8_t clientID];
  }
} implementation {

  enum {
    NUM_CLIENTS_SUBSCRITPION_OUT = uniqueCount(CSEC_SUBSCRITPION_OUT_ID),
    NUM_CLIENTS_SUBSCRITPION_IN = uniqueCount(CSEC_SUBSCRITPION_IN_ID),
    NUM_CLIENTS_NOTIFICATION_OUT = uniqueCount(CSEC_NOTIFICATION_OUT_ID),
    NUM_CLIENTS_NOTIFICATION_IN = uniqueCount(CSEC_NOTIFICATION_IN_ID),

    TOTAL_CLIENTS = NUM_CLIENTS_SUBSCRITPION_OUT + 
                    NUM_CLIENTS_SUBSCRITPION_IN +
                    NUM_CLIENTS_NOTIFICATION_OUT +
                    NUM_CLIENTS_NOTIFICATION_IN,
  };

  uint8_t dontBugMe; // avoiding compiler warning - comparison to zero if no client wired

  uint8_t priTableSout[NUM_CLIENTS_SUBSCRITPION_OUT];
  uint8_t priTableSin[NUM_CLIENTS_SUBSCRITPION_IN];
  uint8_t priTableNout[NUM_CLIENTS_NOTIFICATION_OUT];
  uint8_t priTableNin[NUM_CLIENTS_NOTIFICATION_IN];

  void initTable(uint8_t *table, uint8_t *priorities, uint8_t num)
  {
    uint8_t i, smallest = 0, tindex = 0, next=255, k;
    for (k=0; k<num; k++){
      for (i=0; i<num; i++){
        next = 255;
        if (priorities[i] == smallest)
          table[tindex++] = i; 
        else if (priorities[i] < next)
          next = priorities[i];
      }
      smallest = next;
    }
  }

  event void Boot.booted()
  {
    uint8_t buf[TOTAL_CLIENTS];
    uint8_t i;
    dontBugMe = NUM_CLIENTS_SUBSCRITPION_OUT;
    for (i=0; i<dontBugMe; i++)
      buf[i] = call GetClientPrioritySubscriptionOut.get[i]();
    initTable(priTableSout, buf, NUM_CLIENTS_SUBSCRITPION_OUT);
    dontBugMe = NUM_CLIENTS_SUBSCRITPION_IN;
    for (i=0; i<dontBugMe; i++)
      buf[i] = call GetClientPrioritySubscriptionIn.get[i]();
    initTable(priTableSin, buf, NUM_CLIENTS_SUBSCRITPION_IN);

    dontBugMe = NUM_CLIENTS_NOTIFICATION_OUT;
    for (i=0; i<dontBugMe; i++)
      buf[i] = call GetClientPriorityNotificationOut.get[i]();
    initTable(priTableNout, buf, NUM_CLIENTS_NOTIFICATION_OUT);
    dontBugMe = NUM_CLIENTS_NOTIFICATION_IN;
    for (i=0; i<dontBugMe; i++)
      buf[i] = call GetClientPriorityNotificationIn.get[i]();
    initTable(priTableNin, buf, NUM_CLIENTS_NOTIFICATION_IN);
  }

  event bool BrokerSubscriptionFilterOut.forward(subscription_handle_t sHandle, bool isIntercept)
  {
    uint8_t i;
    dontBugMe = NUM_CLIENTS_SUBSCRITPION_OUT;
    for (i=0; i<dontBugMe; i++)
      if (!signal SubscriptionFilterOut.forward[priTableSout[i]](sHandle, isIntercept))
        return FALSE;
    return TRUE;
  }

  event bool BrokerSubscriptionFilterIn.forward(subscription_handle_t sHandle, bool isIntercept)
  {
    uint8_t i;
    dontBugMe = NUM_CLIENTS_SUBSCRITPION_IN;
    for (i=0; i<dontBugMe; i++)
      if (!signal SubscriptionFilterIn.forward[priTableSin[i]](sHandle, isIntercept))
        return FALSE;
    return TRUE;
  }

  event bool BrokerNotificationFilterOut.forward(notification_handle_t nHandle, subscription_handle_t sHandle, bool isIntercept)
  {
    uint8_t i;
    dontBugMe = NUM_CLIENTS_NOTIFICATION_OUT;
    for (i=0; i<dontBugMe; i++)
      if (!signal NotificationFilterOut.forward[priTableNout[i]](nHandle, sHandle, isIntercept))
        return FALSE;
    return TRUE;
  }

  event bool BrokerNotificationFilterIn.forward(notification_handle_t nHandle, subscription_handle_t sHandle, bool isIntercept)
  {
    uint8_t i;
    dontBugMe = NUM_CLIENTS_NOTIFICATION_IN;
    for (i=0; i<dontBugMe; i++)
      if (!signal NotificationFilterIn.forward[priTableNin[i]](nHandle, sHandle, isIntercept))
        return FALSE;
    return TRUE;
  }

  default event bool SubscriptionFilterOut.forward[uint8_t clientID](subscription_handle_t sHandle, bool isIntercept){return TRUE;}
  default event bool SubscriptionFilterIn.forward[uint8_t clientID](subscription_handle_t sHandle, bool isIntercept){return TRUE;}
  default event bool NotificationFilterOut.forward[uint8_t clientID](notification_handle_t nHandle, subscription_handle_t sHandle, bool isIntercept){return TRUE;}
  default event bool NotificationFilterIn.forward[uint8_t clientID](notification_handle_t nHandle, subscription_handle_t sHandle, bool isIntercept){return TRUE;}

  default command uint8_t GetClientPrioritySubscriptionOut.get[uint8_t clientID](){return 255;}
  default command uint8_t GetClientPrioritySubscriptionIn.get[uint8_t clientID](){return 255;}
  default command uint8_t GetClientPriorityNotificationOut.get[uint8_t clientID](){return 255;}
  default command uint8_t GetClientPriorityNotificationIn.get[uint8_t clientID](){return 255;}
}

