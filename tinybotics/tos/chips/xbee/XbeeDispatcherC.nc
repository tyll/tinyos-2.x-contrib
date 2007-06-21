/* "Copyright (c) 2005 The Regents of the University of California.
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
 * This component provides functionality to send many different kinds
 * of API frames to the XBee.
 * It achieves this by knowing the offset in a message_t
 * through the SerialPacketInfo interface.
 *
 * @author Philip Levis
 * @author Ben Greenstein
 * @author Mirko Bordignon <mirko.bordignon@ieee.org>
 */

configuration XbeeDispatcherC {
  provides {
    interface Init;
    interface SplitControl;
    interface Receive[uart_id_t];
    interface Send[uart_id_t];
  }
  uses {
    interface SerialPacketInfo[uart_id_t];
    interface Leds;
    interface SplitControl as XbeeControl;
  }
}
implementation {
  components XbeeP, new XbeeDispatcherP(),
    XbeeTranslateC,
    PlatformXbeeC;

  Send = XbeeDispatcherP;
  Receive = XbeeDispatcherP;
  SerialPacketInfo = XbeeDispatcherP.PacketInfo;
  SplitControl = XbeeP;
  XbeeControl = XbeeP;

  Init = XbeeP;
  Leds = XbeeP;
  Leds = XbeeDispatcherP;
  Leds = XbeeTranslateC;

  XbeeDispatcherP.ReceiveBytePacket -> XbeeP;
  XbeeDispatcherP.SendBytePacket -> XbeeP;

  XbeeP.SerialFrameComm -> XbeeTranslateC;
  XbeeP.SerialControl -> PlatformXbeeC;
  //  SerialP.SerialFlush -> PlatformSerialC;
  XbeeTranslateC.UartStream -> PlatformXbeeC;
  
}
