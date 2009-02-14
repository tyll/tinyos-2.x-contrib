//$Id$

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
 */


/**
 * This component provides functionality to send many different kinds
 * of serial packets on top of a general packet sending component. It
 * achieves this by knowing where the different packets in a message_t
 * exist through the SerialPacketInfo interface.
 *
 * @author Philip Levis
 * @author Ben Greenstein
 * @date August 7 2005
 *
 */

configuration MySerialSenderC {
  provides {
    interface Init;
    interface SplitControl;
    interface MySend;
  }
  uses {
    interface Leds;
  }
}
implementation {
  components SerialP, MySerialSenderP,
    HdlcTranslateC,
    PlatformSerialC;

  MySend = MySerialSenderP;
  SplitControl = SerialP;

  Init = SerialP;
  Leds = SerialP;
  Leds = MySerialSenderP;
  Leds = HdlcTranslateC;

  MySerialSenderP.SendBytePacket -> SerialP;
  MySerialSenderP.ReceiveBytePacket -> SerialP;

  SerialP.SerialControl -> PlatformSerialC;
  //  SerialP.SerialFlush -> PlatformSerialC;
  SerialP.SerialFrameComm -> HdlcTranslateC;
  HdlcTranslateC.UartStream -> PlatformSerialC;
  
}
