/*
 * "Copyright (c) 2009 Stanford University. All rights reserved.
 *
 * Permission to use, copy, modify, and distribute this software and
 * its documentation for any purpose, without fee, and without written
 * agreement is hereby granted, provided that the above copyright
 * notice, the following two paragraphs and the author appear in all
 * copies of this software.
 *
 * IN NO EVENT SHALL STANFORD UNIVERSITY BE LIABLE TO ANY
 * PARTY FOR DIRECT, INDIRECT, SPECIAL, INCIDENTAL, OR CONSEQUENTIAL
 * DAMAGES ARISING OUT OF THE USE OF THIS SOFTWARE AND ITS
 * DOCUMENTATION, EVEN IF STANFORD UNIVERSITY HAS BEEN
 * ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
 *
 * STANFORD UNIVERSITY SPECIFICALLY DISCLAIMS ANY WARRANTIES,
 * INCLUDING, BUT NOT LIMITED TO, THE IMPLIED WARRANTIES OF
 * MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE.  THE SOFTWARE
 * PROVIDED HEREUNDER IS ON AN "AS IS" BASIS, AND THE UNIVERSITY OF
 * CALIFORNIA HAS NO OBLIGATION TO PROVIDE MAINTENANCE, SUPPORT,
 * UPDATES, ENHANCEMENTS, OR MODIFICATIONS."
 *
 */

/*
 * Wiring for the PowerNet base station.
 *
 * @author Maria Kazandjieva, <mariakaz@cs.stanford.edu>
 * @date Oct 18, 2009 
*/

#include "PowerNetBase.h"
#include "Ctp.h"

configuration PowerNetBaseC {}
implementation {
  components PowerNetBaseP, MainC, LedsC, ActiveMessageC;
  components CollectionC as Collector;
  components new CollectionSenderC(AM_ID);
  components new SerialAMSenderC(AM_ID);
  components SerialActiveMessageC;
#ifndef NO_DEBUG
  components new SerialAMSenderC(AM_COLLECTION_DEBUG) as UARTSender;
  components UARTDebugSenderP as DebugSender;
#endif
  components RandomC;
  components new QueueC(message_t*, 12);
  components new PoolC(message_t, 12);

  PowerNetBaseP.Boot -> MainC;
  PowerNetBaseP.RadioControl -> ActiveMessageC;
  PowerNetBaseP.SerialControl -> SerialActiveMessageC;
  PowerNetBaseP.UartPacket -> SerialActiveMessageC;
  PowerNetBaseP.UartAMPacket -> SerialActiveMessageC;
  PowerNetBaseP.RoutingControl -> Collector;
  PowerNetBaseP.Leds -> LedsC;
  PowerNetBaseP.Send -> CollectionSenderC;
  PowerNetBaseP.RootControl -> Collector;
  PowerNetBaseP.Receive -> Collector.Receive[AM_ID];
  PowerNetBaseP.UARTSend -> SerialAMSenderC.AMSend;
  PowerNetBaseP.CollectionPacket -> Collector;
  PowerNetBaseP.CtpInfo -> Collector;
  PowerNetBaseP.CtpCongestion -> Collector;
  PowerNetBaseP.Random -> RandomC;
  PowerNetBaseP.Pool -> PoolC;
  PowerNetBaseP.Queue -> QueueC;
  PowerNetBaseP.RadioPacket -> ActiveMessageC;
  PowerNetBaseP.RadioAMPacket -> ActiveMessageC;
  
#ifndef NO_DEBUG
  components new PoolC(message_t, 10) as DebugMessagePool;
  components new QueueC(message_t*, 10) as DebugSendQueue;
  DebugSender.Boot -> MainC;
  DebugSender.UARTSend -> UARTSender;
  DebugSender.MessagePool -> DebugMessagePool;
  DebugSender.SendQueue -> DebugSendQueue;
  Collector.CollectionDebug -> DebugSender;
  PowerNetBaseP.CollectionDebug -> DebugSender;
#endif
  PowerNetBaseP.AMPacket -> ActiveMessageC;
}
