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
 * This component is a generic publisher that tries to publish notifications
 * in response to subscriptions by simply querying the Attribute Collector for
 * attribute data corresponding to constraints in a given subscription.  It
 * understands some basic metadata atributes (RATE, COUNT, REBOOT).
 **/

generic configuration StdPublisherC()
{
  uses {
    interface Publish;
    interface SubscriptionListener;
    interface PSMessageAccess;
    interface PSHandle;
    interface AttributeCollection;
  }
} implementation {
  components new StdPublisherP() as StdPublisher;

  Publish = StdPublisher;
  SubscriptionListener = StdPublisher;
  PSMessageAccess = StdPublisher;
  PSHandle = StdPublisher;
  AttributeCollection = StdPublisher;
  
  components new TimerMilliC() as RateTimer;
  components RandomC, NoLedsC as LedsC;

  StdPublisher.RateTimer -> RateTimer;
  StdPublisher.Random -> RandomC;
  StdPublisher.Leds -> LedsC;
}
