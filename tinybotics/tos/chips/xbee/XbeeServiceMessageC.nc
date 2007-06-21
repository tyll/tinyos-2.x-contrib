/*
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
 * Sending service messages over the serial port to the XBee
 * @author Mirko Bordignon <mirko.bordignon@ieee.org>
 */

#include "Xbee.h"

configuration XbeeServiceMessageC {
  provides {
    interface SplitControl;
    interface AMSend[am_id_t id];
    interface Receive[am_id_t id];
    interface Packet;
    interface AMPacket;
    interface PacketAcknowledgements;
  }
  uses interface Leds;
}

implementation {
  components XbeeServiceMessageP as SM, XbeeDispatcherC;
  components XbeeServiceMessagePacketInfoP as Info, MainC;

  MainC.SoftwareInit -> XbeeDispatcherC;
  Leds = XbeeDispatcherC;
  SplitControl = XbeeDispatcherC;

  AMSend = SM;
  Receive = SM;
  Packet = SM;
  AMPacket = SM;
  PacketAcknowledgements = SM;

  SM.SubSend -> XbeeDispatcherC.Send[XBEE_SERVICE_MESSAGE_ID];
  SM.SubReceive -> XbeeDispatcherC.Receive[XBEE_SERVICE_MESSAGE_ID];

  XbeeDispatcherC.SerialPacketInfo[XBEE_SERVICE_MESSAGE_ID] -> Info;
}
