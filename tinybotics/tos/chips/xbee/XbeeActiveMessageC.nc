/* "Copyright (c) 2000-2005 The Regents of the University of California.  
 * All rights reserved.
 *
 * Permission to use, copy, modify, and distribute this software and its
 * documentation for any purpose, without fee, and without written agreement
 * is hereby granted, provided that the above copyright notice, the following
 * two paragraphs and the author appear in all copies of this software.
 * 
 * IN NO EVENT SHALL THE UNIVERSITY OF CALIFORNIA BE LIABLE TO ANY PARTY FOR
 * DIRECT, INDIRECT, SPECIAL, INCIDENTAL, OR CONSEQUENTIAL DAMAGES ARISING OUT
 * OF THE USE OF THIS SOFTWARE AND ITS DOCUMENTATION, EVEN IF THE UNIVERSITY
 * OF CALIFORNIA HAS BEEN ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
 * 
 * THE UNIVERSITY OF CALIFORNIA SPECIFICALLY DISCLAIMS ANY WARRANTIES,
 * INCLUDING, BUT NOT LIMITED TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY
 * AND FITNESS FOR A PARTICULAR PURPOSE.  THE SOFTWARE PROVIDED HEREUNDER IS
 * ON AN "AS IS" BASIS, AND THE UNIVERSITY OF CALIFORNIA HAS NO OBLIGATION TO
 * PROVIDE MAINTENANCE, SUPPORT, UPDATES, ENHANCEMENTS, OR MODIFICATIONS."
 *
 * Copyright (c) 2007 University of Padova
 * Copyright (c) 2007 Orebro University
 * All rights reserved.
 *
 * Redistribution and use in source and binary forms, with or without
 * modification, are permitted provided that the following conditions
 * are met:
 * - Redistributions of source code must retain the above copyright
 *   notice, this list of conditions and the following disclaimer.
 * - Redistributions in binary form must reproduce the above copyright
 *   notice, this list of conditions and the following disclaimer in the
 *   documentation and/or other materials provided with the
 *   distribution.
 * - Neither the name of the the copyright holders nor the names of
 *   their contributors may be used to endorse or promote products derived
 *   from this software without specific prior written permission.
 *
 * THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS
 * ``AS IS'' AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT
 * LIMITED TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS
 * FOR A PARTICULAR PURPOSE ARE DISCLAIMED.  IN NO EVENT SHALL THE COPYRIGHT
 * HOLDERS OR THEIR CONTRIBUTORS BE LIABLE FOR ANY DIRECT, INDIRECT,
 * INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES
 * (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR
 * SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION)
 * HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT,
 * STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE)
 * ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED
 * OF THE POSSIBILITY OF SUCH DAMAGE.
 */

/**
 * Sending active messages over the serial port to the XBee
 *
 * @author Philip Levis
 * @author Ben Greenstein
 * @author Mirko Bordignon <mirko.bordignon@ieee.org>
 */

#include "Xbee.h"

configuration XbeeActiveMessageC {
  provides {
    interface SplitControl;
    interface AMSend[am_id_t id];
    interface Receive[am_id_t id];
    interface Packet;
    interface AMPacket;
    interface PacketAcknowledgements;
    interface XbeeConfig;
  }
  uses interface Leds;
}
implementation {
  components XbeeActiveMessageP as AM, XbeePacketC, XbeeDispatcherC, XbeeControlC;
  components XbeeAMPacketInfoP as AMInfo, XbeeSMPacketInfoP as SMInfo;
  components MainC, ActiveMessageAddressC as Address, LedsC;

  MainC.SoftwareInit -> XbeeDispatcherC;
  Leds = XbeeDispatcherC;
  SplitControl = XbeeDispatcherC;
  
  AMSend = AM;
  Receive = AM;
  Packet = AM;
  AMPacket = AM;
  PacketAcknowledgements = XbeePacketC;
  XbeeConfig = XbeeControlC;

  AM.SubSend -> XbeeDispatcherC.Send[XBEE_ACTIVE_MESSAGE_ID];
  AM.SubReceive -> XbeeDispatcherC.Receive[XBEE_ACTIVE_MESSAGE_ID];
  AM.StatusReceive -> XbeeDispatcherC.Receive[XBEE_TX_STATUS_MESSAGE_ID];
  AM.amAddress -> Address;
  
  XbeeDispatcherC.SerialPacketInfo[XBEE_ACTIVE_MESSAGE_ID] -> AMInfo;
  XbeeDispatcherC.SerialPacketInfo[XBEE_TX_STATUS_MESSAGE_ID] -> SMInfo;
  XbeeDispatcherC.XbeeControl -> XbeeControlC.XbeeControl;
}
