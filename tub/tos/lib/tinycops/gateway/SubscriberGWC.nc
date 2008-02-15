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
#include "SubscriberGW.h"
generic configuration SubscriberGWC()
{
  uses {
    interface Subscribe;
    interface PSMessageAccess;
    interface PSHandle;
  }  
} implementation {

  components MainC, new SubscriberGWImplP() as SubscriberGWP, SerialActiveMessageC as Serial, 
             NoLedsC as NoLeds, ActiveMessageC, LedsC;
  components new AMSendQueueC(10) as SerialSendQueue;
  
  Subscribe = SubscriberGWP;
  PSMessageAccess = SubscriberGWP;
  PSHandle = SubscriberGWP;

  Serial.Leds -> NoLeds;
  MainC.Boot <- SubscriberGWP;

  SubscriberGWP.AMPacket -> ActiveMessageC;
  SubscriberGWP.SubSplitControl -> Serial;
#ifdef PSGW_FORWARD_MESSAGES
  SubscriberGWP.SerialSend[AM_CTP_DATA] -> SerialSendQueue;
  SerialSendQueue.SubSend -> Serial.AMSend[AM_CTP_DATA];
  // add channels for other notification am ids here...
#else
  SubscriberGWP.SerialSend[AM_NOTIFICATION] -> SerialSendQueue;
  SerialSendQueue.SubSend -> Serial.AMSend[AM_NOTIFICATION];
#endif
  SubscriberGWP.SerialReceive -> Serial.Receive[AM_SUBSCRIPTION];
  SubscriberGWP.SerialPacket -> Serial;
  SubscriberGWP.SerialAck -> Serial;
  SubscriberGWP.Leds -> LedsC;
}
