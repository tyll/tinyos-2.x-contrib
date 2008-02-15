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

configuration BrokerP
{
  provides {
    interface Publish[uint8_t clientID];
    interface Subscribe[uint8_t clientID];
    interface SubscriptionListener[uint8_t clientID];
    interface SubscriptionFilter<CSEC_OUTBOUND> as SubscriptionFilterOut;
    interface SubscriptionFilter<CSEC_INBOUND> as SubscriptionFilterIn;
    interface NotificationFilter<CSEC_OUTBOUND>  as NotificationFilterOut;
    interface NotificationFilter<CSEC_INBOUND>  as NotificationFilterIn;
    interface PSMessageAccess;
    interface PSHandle[uint8_t clientID];
    interface Get<subscription_handle_t> as GetSubscription[uint8_t clientID]; 
  } uses {
    interface Send as SendSubscription[uint8_t clientID];
    interface Receive as ReceiveSubscription[uint8_t clientID];
    interface Intercept as InterceptSubscription[uint8_t clientID];
    interface Get<am_id_t> as GetSubscriptionAMID[uint8_t clientID];
    
    interface Send as SendNotification[uint8_t clientID];
    interface Receive as ReceiveNotification[uint8_t clientID];
    interface Intercept as InterceptNotification[uint8_t clientID];
    interface Get<am_id_t> as GetNotificationAMID[uint8_t clientID];
    interface AttributeValue as SourceAdress[uint8_t clientID]; 
    interface RootControl[uint8_t clientID];
    interface Packet as PacketNotification[uint8_t clientID];
    interface Packet as PacketSubscription[uint8_t clientID];
  }
} implementation {
  components BrokerImplP;
    
  Publish = BrokerImplP.Publish;
  Subscribe = BrokerImplP.Subscribe;
  SubscriptionListener = BrokerImplP;
  PSMessageAccess = BrokerImplP;
  PSHandle = BrokerImplP.PSHandle;
  PacketNotification = BrokerImplP.PacketNotification;
  PacketSubscription = BrokerImplP.PacketSubscription;

  SubscriptionFilterOut = BrokerImplP.SubscriptionFilterOut;
  SubscriptionFilterIn = BrokerImplP.SubscriptionFilterIn;
  NotificationFilterOut = BrokerImplP.NotificationFilterOut;
  NotificationFilterIn = BrokerImplP.NotificationFilterIn;

  
  SendSubscription = BrokerImplP.SendSubscription;
  ReceiveSubscription = BrokerImplP.ReceiveSubscription;
  InterceptSubscription = BrokerImplP.InterceptSubscription;
  GetSubscriptionAMID = BrokerImplP.GetSubscriptionAMID;
  RootControl = BrokerImplP.RootControl;
  SourceAdress = BrokerImplP;
  
  SendNotification = BrokerImplP.SendNotification;
  ReceiveNotification = BrokerImplP.ReceiveNotification;
  InterceptNotification = BrokerImplP.InterceptNotification;
  GetNotificationAMID = BrokerImplP.GetNotificationAMID;
  GetSubscription = BrokerImplP.GetSubscription;

  components LedsC as LedsC, MainC, ActiveMessageC, AttributeCollectorC;

  BrokerImplP.Leds -> LedsC;
  BrokerImplP.Boot -> MainC;
  BrokerImplP.AMPacket -> ActiveMessageC;
  BrokerImplP.AttributeCollection -> AttributeCollectorC.AttributeCollection[255];
  BrokerImplP.SubSplitControl -> ActiveMessageC;
}

