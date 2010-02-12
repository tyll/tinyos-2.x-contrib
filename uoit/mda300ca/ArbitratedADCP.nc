configuration ArbitratedADCP
{
  provides interface Read<uint16_t> as Channel0;
  provides interface Read<uint16_t> as Channel1;
  provides interface Read<uint16_t> as Channel2;
  provides interface Read<uint16_t> as Channel3;
  provides interface Read<uint16_t> as Channel4;
  provides interface Read<uint16_t> as Channel5;
  provides interface Read<uint16_t> as Channel6;
  provides interface Read<uint16_t> as Channel7;
  provides interface Read<uint16_t> as Channel01;
  provides interface Read<uint16_t> as Channel23;
  provides interface Read<uint16_t> as Channel45;
  provides interface Read<uint16_t> as Channel67;
  provides interface Read<uint16_t> as Channel10;
  provides interface Read<uint16_t> as Channel32;
  provides interface Read<uint16_t> as Channel54;
  provides interface Read<uint16_t> as Channel76;
}
implementation
{
  components ADCDeviceC,
    new ArbitratedReadC(uint16_t) as ArbitrateRead0;//might need more than one

  Channel0 = ArbitrateRead0;
  ArbitrateRead0.Service -> ADCDeviceC.ReadChannel0;
  ArbitrateRead0.Resource -> ADCDeviceC.Resource;
  
  Channel1 = ArbitrateRead0;
  ArbitrateRead0.Service -> ADCDeviceC.ReadChannel1;
  ArbitrateRead0.Resource -> ADCDeviceC.Resource;
  
  Channel2 = ArbitrateRead0;
  ArbitrateRead0.Service -> ADCDeviceC.ReadChannel2;
  ArbitrateRead0.Resource -> ADCDeviceC.Resource;
  
  Channel3 = ArbitrateRead0;
  ArbitrateRead0.Service -> ADCDeviceC.ReadChannel3;
  ArbitrateRead0.Resource -> ADCDeviceC.Resource;
  
  Channel4 = ArbitrateRead0;
  ArbitrateRead0.Service -> ADCDeviceC.ReadChannel4;
  ArbitrateRead0.Resource -> ADCDeviceC.Resource;
  
  Channel5 = ArbitrateRead0;
  ArbitrateRead0.Service -> ADCDeviceC.ReadChannel5;
  ArbitrateRead0.Resource -> ADCDeviceC.Resource;
  
  Channel6 = ArbitrateRead0;
  ArbitrateRead0.Service -> ADCDeviceC.ReadChannel6;
  ArbitrateRead0.Resource -> ADCDeviceC.Resource;
  
  Channel7 = ArbitrateRead0;
  ArbitrateRead0.Service -> ADCDeviceC.ReadChannel7;
  ArbitrateRead0.Resource -> ADCDeviceC.Resource;
  
  Channel01 = ArbitrateRead0;
  ArbitrateRead0.Service -> ADCDeviceC.ReadChannel01;
  ArbitrateRead0.Resource -> ADCDeviceC.Resource;
  
  Channel23 = ArbitrateRead0;
  ArbitrateRead0.Service -> ADCDeviceC.ReadChannel23;
  ArbitrateRead0.Resource -> ADCDeviceC.Resource;
  
  Channel45 = ArbitrateRead0;
  ArbitrateRead0.Service -> ADCDeviceC.ReadChannel45;
  ArbitrateRead0.Resource -> ADCDeviceC.Resource;
  
  Channel67 = ArbitrateRead0;
  ArbitrateRead0.Service -> ADCDeviceC.ReadChannel67;
  ArbitrateRead0.Resource -> ADCDeviceC.Resource;
  
  Channel10 = ArbitrateRead0;
  ArbitrateRead0.Service -> ADCDeviceC.ReadChannel10;
  ArbitrateRead0.Resource -> ADCDeviceC.Resource;
  
  Channel32 = ArbitrateRead0;
  ArbitrateRead0.Service -> ADCDeviceC.ReadChannel32;
  ArbitrateRead0.Resource -> ADCDeviceC.Resource;
  
  Channel54 = ArbitrateRead0;
  ArbitrateRead0.Service -> ADCDeviceC.ReadChannel54;
  ArbitrateRead0.Resource -> ADCDeviceC.Resource;
  
  Channel76 = ArbitrateRead0;
  ArbitrateRead0.Service -> ADCDeviceC.ReadChannel76;
  ArbitrateRead0.Resource -> ADCDeviceC.Resource;
}
