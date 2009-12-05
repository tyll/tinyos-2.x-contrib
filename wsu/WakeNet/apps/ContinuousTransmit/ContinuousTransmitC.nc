configuration ContinuousTransmitC {
}

implementation {

  components ActiveMessageC,
      new AMSenderC(0),
      ContinuousTransmitP,
 //     BlazeSpiC,
      LedsC,
      MainC;
      
  ContinuousTransmitP.Boot -> MainC;
  ContinuousTransmitP.AMSend -> AMSenderC;
  ContinuousTransmitP.SplitControl -> ActiveMessageC;
  ContinuousTransmitP.Leds -> LedsC;
  
}

