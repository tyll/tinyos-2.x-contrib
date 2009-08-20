
configuration PendingBitC {
  provides {
    interface PendingBit;
  }
}

implementation {
  
  components PendingBitP;
  components BlazeC;
  
  PendingBit = PendingBitP;
  
  PendingBitP.Receive -> BlazeC.Receive;
  PendingBitP.LowPowerListening -> BlazeC;
  PendingBitP.BlazePacket -> BlazeC;
  
  components new TimerMilliC();
  PendingBitP.Timer -> TimerMilliC;
  
}

