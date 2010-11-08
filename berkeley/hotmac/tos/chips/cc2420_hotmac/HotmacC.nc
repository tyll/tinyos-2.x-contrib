/*
 * "Copyright (c) 2010 The Regents of the University  of California.
 * All rights reserved."
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
 */
/*
 * @author Stephen Dawson-Haggerty <stevedh@eecs.berkeley.edu>
 */

configuration HotmacC {
  provides {
    interface SplitControl;
    interface AMSend;
    interface Receive as Ieee154Receive;
    interface PacketAcknowledgements;
    interface PacketLink;
  }
  
} implementation {
  components MainC;
  components CC2420TransmitC, CC2420ReceiveC;
  components CC2420PowerC, CC2420PacketC, CC2420ControlC;
  components HotmacReceiveP, HotmacTransmitP;
  components new StateC();
  components NeighborTableC;
  components RandomC;

  SplitControl = HotmacReceiveP;
  AMSend = HotmacTransmitP;
  Ieee154Receive = HotmacReceiveP.Receive;
  PacketAcknowledgements = CC2420PacketC;
  PacketLink = HotmacTransmitP;

  MainC.SoftwareInit -> NeighborTableC;

  // Alarm wiring -- this way we only use one hardware alarm
  // If we directly use the hardware, we end up using too many compare
  // registers.
  components new Alarm32khz32C() as Alarm;
  components new VirtualizeAlarmC(T32khz, uint32_t, 3) as VA;
  MainC.SoftwareInit -> VA;
  VA.AlarmFrom -> Alarm;

  // Receive wiring
  MainC.SoftwareInit -> HotmacReceiveP.Init;
  HotmacReceiveP.HotmacPacket -> HotmacTransmitP;
  HotmacReceiveP.HotmacState -> StateC;
  HotmacReceiveP.RadioControl -> CC2420PowerC;
  HotmacReceiveP.CC2420Transmit -> CC2420TransmitC;
  HotmacReceiveP.ProbeAlarm -> VA.Alarm[0];
  HotmacReceiveP.ReceiveTimeout -> VA.Alarm[1];
  HotmacReceiveP.PacketAcknowledgements -> CC2420PacketC;
  HotmacReceiveP.CC2420PacketBody -> CC2420PacketC;
  HotmacReceiveP.Packet -> CC2420PacketC;
  HotmacReceiveP.SubReceive -> CC2420ReceiveC;
  HotmacReceiveP.ReceiveIndicator -> CC2420ReceiveC;
  HotmacReceiveP.NeighborTable -> NeighborTableC;
  HotmacReceiveP.CC2420Config -> CC2420ControlC;
  HotmacReceiveP.CC2420Receive -> CC2420ReceiveC;
  HotmacReceiveP.PacketTimeStamp -> CC2420PacketC.PacketTimeStamp32khz;
  HotmacReceiveP.PowerCycleInfo -> CC2420PowerC;
  HotmacReceiveP.Random -> RandomC;
  HotmacReceiveP.TransmitTransfer -> HotmacTransmitP;

  // Transmit wiring
  MainC.SoftwareInit -> HotmacTransmitP.Init;
  HotmacTransmitP.CC2420PacketBody -> CC2420PacketC;
  HotmacTransmitP.SubBackoff -> CC2420TransmitC;
  HotmacTransmitP.CC2420Config -> CC2420ControlC;
  HotmacTransmitP.RadioControl -> CC2420PowerC;
  HotmacTransmitP.HotmacState -> StateC;
  HotmacTransmitP.SendAlarm -> VA.Alarm[2];
  HotmacTransmitP.CC2420Transmit -> CC2420TransmitC;
  HotmacTransmitP.Random -> RandomC;
  HotmacTransmitP.ReceiveTransfer -> HotmacReceiveP.ReceiveTransfer;
  HotmacTransmitP.NeighborTable -> NeighborTableC;
  HotmacTransmitP.PacketAcknowledgements -> CC2420PacketC;
  HotmacTransmitP.ControlChannel -> HotmacReceiveP.ControlChannel;

  components NoLedsC as LedsC;
  HotmacReceiveP.Leds -> LedsC;
  HotmacTransmitP.Leds -> LedsC;

#ifdef MSP430_TRANSITIONS
  components HplMsp430GeneralIOC;
  HotmacReceiveP.Pin -> HplMsp430GeneralIOC.Port26;
#endif

} 

