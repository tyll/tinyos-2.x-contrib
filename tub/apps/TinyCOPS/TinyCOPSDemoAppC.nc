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
configuration TinyCOPSDemoAppC
{
}
implementation
{
  components new StdPublisherC() as Publisher,          // the publisher application
             new TinyCOPSClientC() as Client,           // structured access to the broker   
             new CtpWrapperC() as NotificationProtocol, // notification protocol
             new DisseminationTrickleC() as SubscriptionProtocol; // subscription protocol
  
  // wiring (specifying) the protocols for the publisher
  Client.ReceiveSubscription -> SubscriptionProtocol;
  Client.GetSubscriptionAMID -> SubscriptionProtocol;
  Client.SendNotification -> NotificationProtocol;
  Client.ReceiveNotification -> NotificationProtocol;
  Client.InterceptNotification -> NotificationProtocol;
  Client.GetNotificationAMID -> NotificationProtocol.GetAMID;   
  Client.PacketNotification -> NotificationProtocol.Packet;   
  Client.PacketSubscription -> SubscriptionProtocol.Packet;
  Client.RootControl -> NotificationProtocol;

  // wiring the service interfaces to the publisher
  Publisher.Publish -> Client;
  Publisher.SubscriptionListener -> Client;
  Publisher.PSMessageAccess -> Client;
  Publisher.PSHandle -> Client;
  Publisher.AttributeCollection -> Client;

  // the following is a subscriber gateway - i.e. in this application
  // every node can act as a gateway and forward the subscriptions
  // from PC to the sensor network and notifications from the
  // sensor network back to the PC (check the TinyCOPS java tools)
  components new SubscriberGWC() as Bridge;
  
  Client.SendSubscription -> SubscriptionProtocol;
  Bridge.Subscribe -> Client;
  Bridge.PSMessageAccess -> Client;
  Bridge.PSHandle -> Client;

  // attributes must only be instantiated, and not wired
  // (they are implemented such that they know where they have
  // to wire themselves); the same holds for CSECs and ASECs
  components AttributePingC;  // a very simple attribute

  components new SendOnDeltaC(0); // a CSEC
  components new DummyASECC();    // an ASEC
}
