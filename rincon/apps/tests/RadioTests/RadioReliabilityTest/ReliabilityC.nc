
/**
 * Quick hack to prove that the micaz receiver keeps rebooting when
 * receiving many packets from a transmitter
 * @author David Moss
 */
 
configuration ReliabilityC {
}

implementation {
  components ReliabilityP,
      ActiveMessageC,
      new AMSenderC(0),
      new AMReceiverC(0),
      new SerialAMSenderC(1),
      SerialActiveMessageC,
      MainC,
      LedsC;
      
  ReliabilityP.Boot -> MainC;
  ReliabilityP.AMSend -> AMSenderC;
  ReliabilityP.Receive -> AMReceiverC;
  ReliabilityP.Leds -> LedsC;
  ReliabilityP.AMPacket -> ActiveMessageC;
  ReliabilityP.SplitControl -> ActiveMessageC;
  ReliabilityP.SerialAMSend -> SerialAMSenderC;
  ReliabilityP.SerialSplitControl -> SerialActiveMessageC;
  
}

