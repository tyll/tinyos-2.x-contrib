configuration Sniff802154C {
}
implementation {
  components MainC;
  components CC2420ReceiveC as RadioReceive; 
  components CC2420ControlC as RadioControl;
  components CC2420PacketC as RadioPacket; 
  components Sniff802154P as Sniffer;
  components SerialActiveMessageC as Serial;
  components Serial802_15_4C as TransparentSerial;
  components LedsC;
  components HplCC2420InterruptsC as Interrupts;

  
  MainC.Boot <- Sniffer;  
  
  Sniffer.SerialControl -> Serial;
  
  Sniffer.UartSend -> Serial;
  Sniffer.UartReceive -> Serial;
  Sniffer.UartPacket -> Serial;
  //Sniffer.UartAMPacket -> Serial;
  Sniffer.TransparentUartSend -> TransparentSerial.Send;
  //Sniffer.TransparentReceive -> TransparentSerial.Receive;
  
  
  Sniffer.RadioReceiveControl -> RadioReceive.StdControl;
  Sniffer.RadioReceive -> RadioReceive.CC2420Receive;
  Sniffer.RadioDataReceive -> RadioReceive.Receive;
  Sniffer.RadioControlResource -> RadioControl.Resource;
  Sniffer.RadioConfig -> RadioControl.CC2420Config;
  Sniffer.RadioPower -> RadioControl.CC2420Power;
  Sniffer.RadioPacketBody -> RadioPacket.CC2420PacketBody;
  Sniffer.CaptureSFD -> Interrupts.CaptureSFD;
  Sniffer.Leds -> LedsC;
}
