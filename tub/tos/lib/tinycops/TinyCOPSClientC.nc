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

/**
 * The TinyCOPSClientC provides structured access to TinyCOPS, i.e.
 * every Publisher/Subscriber component should instantiate its own
 * TinyCOPSClientC and use only its provided interfaces. At the same time
 * the Publisher/Subscriber component has to wire the used interfaces
 * to its desired notification and subscription delivery protocol.
 */
generic configuration TinyCOPSClientC()
{
  provides {
    interface Publish;
    interface Subscribe;
    interface SubscriptionListener;
    interface PSMessageAccess;
    interface PSHandle;
    interface AttributeCollection;
    interface Get<subscription_handle_t> as GetSubscription; // address tunneling (publisher side)
  } uses {
    interface Send as SendSubscription;
    interface Intercept as InterceptSubscription;
    interface Receive as ReceiveSubscription;
    interface Get<am_id_t> as GetSubscriptionAMID;
    interface Send as SendNotification;
    interface Receive as ReceiveNotification;
    interface Intercept as InterceptNotification;
    interface Get<am_id_t> as GetNotificationAMID;
    interface Packet as PacketNotification;
    interface Packet as PacketSubscription;
    interface AttributeValue as SourceAdress; // address tunneling on subscriber side (optional)
    interface RootControl; // optional
  }
} implementation {
  components BrokerP, new AttributeClientP();

  enum {
    PSCLIENT = unique(PSCLIENT_ID),
  };

  SendSubscription = BrokerP.SendSubscription[PSCLIENT];
  ReceiveSubscription = BrokerP.ReceiveSubscription[PSCLIENT];
  InterceptSubscription = BrokerP.InterceptSubscription[PSCLIENT];
  GetSubscriptionAMID = BrokerP.GetSubscriptionAMID[PSCLIENT];
  SendNotification = BrokerP.SendNotification[PSCLIENT];
  ReceiveNotification = BrokerP.ReceiveNotification[PSCLIENT];
  InterceptNotification = BrokerP.InterceptNotification[PSCLIENT];
  GetNotificationAMID = BrokerP.GetNotificationAMID[PSCLIENT];
  AttributeCollection = AttributeClientP;

  Publish = BrokerP.Publish[PSCLIENT];
  Subscribe = BrokerP.Subscribe[PSCLIENT];
  SubscriptionListener = BrokerP.SubscriptionListener[PSCLIENT];
  PSMessageAccess = BrokerP.PSMessageAccess;
  PSHandle = BrokerP.PSHandle[PSCLIENT];
  PacketNotification = BrokerP.PacketNotification[PSCLIENT];
  PacketSubscription = BrokerP.PacketSubscription[PSCLIENT];
  SourceAdress = BrokerP.SourceAdress[PSCLIENT];
  RootControl =  BrokerP.RootControl[PSCLIENT];
  GetSubscription = BrokerP.GetSubscription[PSCLIENT];
}
