// $Id$

/*									tab:4
 * "Copyright (c) 2004-2005 The Regents of the University  of California.  
 * All rights reserved.
 *
 * Permission to use, copy, modify, and distribute this software and its
 * documentation for any purpose, without fee, and without written agreement is
 * hereby granted, provided that the above copyright notice, the following
 * two paragraphs and the author appear in all copies of this software.
 * 
 * IN NO EVENT SHALL THE UNIVERSITY OF CALIFORNIA BE LIABLE TO ANY PARTY FOR
 * DIRECT, INDIRECT, SPECIAL, INCIDENTAL, OR CONSEQUENTIAL DAMAGES ARISING OUT
 * OF THE USE OF THIS SOFTWARE AND ITS DOCUMENTATION, EVEN IF THE UNIVERSITY OF
 * CALIFORNIA HAS BEEN ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
 * 
 * THE UNIVERSITY OF CALIFORNIA SPECIFICALLY DISCLAIMS ANY WARRANTIES,
 * INCLUDING, BUT NOT LIMITED TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY
 * AND FITNESS FOR A PARTICULAR PURPOSE.  THE SOFTWARE PROVIDED HEREUNDER IS
 * ON AN "AS IS" BASIS, AND THE UNIVERSITY OF CALIFORNIA HAS NO OBLIGATION TO
 * PROVIDE MAINTENANCE, SUPPORT, UPDATES, ENHANCEMENTS, OR MODIFICATIONS."
 *
 * Copyright (c) 2004-2005 Intel Corporation
 * All rights reserved.
 *
 * This file is distributed under the terms in the attached INTEL-LICENSE     
 * file. If you do not find these files, copies can be found by writing to
 * Intel Research Berkeley, 2150 Shattuck Avenue, Suite 1300, Berkeley, CA, 
 * 94704.  Attention:  Intel License Inquiry.
 */

/**
 *
 * The Active Message layer for TOSSIM. This is a naming wrapper
 * around a simulated CC2420 Active Message layer. This is a modified
 * version that uses LPP.
 *
 * @author Philip Levis
 * @author Razvan Musaloiu-E.
 */

configuration ActiveMessageC
{
  provides {
    interface SplitControl;

    interface AMSend[uint8_t id];
    interface Receive[uint8_t id];
    interface Receive as Snoop[uint8_t id];
    interface Monitor;

    interface Packet;
    interface AMPacket;
    interface PacketAcknowledgements;
    interface LowPowerProbing;
  }
}

implementation
{
  components CC2420ActiveMessageC;
  components MonitorC;
  components LppC;

  SplitControl = LppC;
  LowPowerProbing = LppC;
  
  AMSend       = MonitorC.AMSend;
  Receive      = MonitorC.Receive;
  Snoop        = MonitorC.Snoop;
  Packet       = CC2420ActiveMessageC;
  AMPacket     = CC2420ActiveMessageC;
  PacketAcknowledgements = CC2420ActiveMessageC;
  Monitor = MonitorC;

  MonitorC.SubAMSend -> LppC;
  MonitorC.SubReceive -> CC2420ActiveMessageC.Receive;
  MonitorC.SubSnoop -> CC2420ActiveMessageC.Snoop;
  MonitorC.Acks -> CC2420ActiveMessageC.PacketAcknowledgements;
  
  LppC.SubSplitControl -> CC2420ActiveMessageC.SplitControl;
  LppC.SubAMSend -> CC2420ActiveMessageC;
}
