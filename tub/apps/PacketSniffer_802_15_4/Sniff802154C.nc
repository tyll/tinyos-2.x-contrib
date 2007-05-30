configuration Sniff802154C {
}
implementation {
  components MainC, Sniff802154P, LedsC;
  components CC2420SniffC as RadioSniff;
  components SerialActiveMessageC as Serial;
  
  
  MainC.Boot <- Sniff802154P;  
  
  Sniff802154P.SerialControl -> Serial;
  
  Sniff802154P.UartSend -> Serial;
  Sniff802154P.UartReceive -> Serial;
  Sniff802154P.UartPacket -> Serial;
  Sniff802154P.UartAMPacket -> Serial;
  
	Sniff802154P.RadioSniffControl -> RadioSniff;
  Sniff802154P.rawReceive <- RadioSniff.rawReceive;
  Sniff802154P.setChannel -> RadioSniff;
  
  Sniff802154P.Leds -> LedsC;
}
