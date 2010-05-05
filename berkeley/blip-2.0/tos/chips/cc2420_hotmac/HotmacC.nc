
configuration HotmacC {
  provides {
    interface SplitControl;
    interface Ieee154Send;
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
  Ieee154Send = HotmacTransmitP;
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

  components NoLedsC as LedsC;
  HotmacReceiveP.Leds -> LedsC;
  HotmacTransmitP.Leds -> LedsC;
} 

