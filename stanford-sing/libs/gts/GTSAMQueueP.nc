// $Id$
/*
 * "Copyright (c) 2005 Stanford University. All rights reserved.
 *
 * Permission to use, copy, modify, and distribute this software and
 * its documentation for any purpose, without fee, and without written
 * agreement is hereby granted, provided that the above copyright
 * notice, the following two paragraphs and the author appear in all
 * copies of this software.
 * 
 * IN NO EVENT SHALL STANFORD UNIVERSITY BE LIABLE TO ANY PARTY FOR
 * DIRECT, INDIRECT, SPECIAL, INCIDENTAL, OR CONSEQUENTIAL DAMAGES
 * ARISING OUT OF THE USE OF THIS SOFTWARE AND ITS DOCUMENTATION, EVEN
 * IF STANFORD UNIVERSITY HAS BEEN ADVISED OF THE POSSIBILITY OF SUCH
 * DAMAGE.
 * 
 * STANFORD UNIVERSITY SPECIFICALLY DISCLAIMS ANY WARRANTIES,
 * INCLUDING, BUT NOT LIMITED TO, THE IMPLIED WARRANTIES OF
 * MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE.  THE SOFTWARE
 * PROVIDED HEREUNDER IS ON AN "AS IS" BASIS, AND STANFORD UNIVERSITY
 * HAS NO OBLIGATION TO PROVIDE MAINTENANCE, SUPPORT, UPDATES,
 * ENHANCEMENTS, OR MODIFICATIONS."
 */

/**
 * The fair-share send queue for AM radio communication.
 *
 * @author Philip Levis
 * @date   Jan 16 2006
 */ 

/**
 * GTS co-existing with AM Queue.
 *
 * @author Jung Il Choi
 * @date   Jun 17 2008
 */ 
 
#include "AM.h"

configuration GTSAMQueueP {
  provides interface GTSSend[uint8_t client];
  provides interface AMQuiet;
  provides interface ReportProtocol;
}

implementation {
  enum {
    NUM_CLIENTS = uniqueCount(UQ_AMQUEUE_SEND)
  };
  
  components new GTSAMQueueImplP(NUM_CLIENTS), ActiveMessageC;
  components LedsC;
  components new TimerMilliC() as TQuiet;
  
  components RandomC;

  GTSSend = GTSAMQueueImplP;
  GTSAMQueueImplP.AMSend -> ActiveMessageC;
  GTSAMQueueImplP.AMPacket -> ActiveMessageC;
  GTSAMQueueImplP.Packet -> ActiveMessageC;
  GTSAMQueueImplP.Leds -> LedsC;
  GTSAMQueueImplP.TQuiet -> TQuiet;
  GTSAMQueueImplP.Random -> RandomC;
  GTSAMQueueImplP.GTSPacket -> ActiveMessageC;
  AMQuiet = GTSAMQueueImplP;
  ReportProtocol = GTSAMQueueImplP;  

  components MainC;
  GTSAMQueueImplP -> MainC.Boot;
  components new TimerMilliC() as TUsage;
  GTSAMQueueImplP.TUsage -> TUsage;
  components new TimerMilliC() as TGrant;
  GTSAMQueueImplP.TGrant -> TGrant;
}

