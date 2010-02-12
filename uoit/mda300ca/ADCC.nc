#include "mda300.h"
generic configuration ADCC() {
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
implementation { 
	components ADCDeviceC;
	//new ArbitratedReadC(uint16_t) as ArbitrateRead;
	
	/*ArbitrateRead.Resource -> ADC.Resource;
	ArbitrateRead.Service -> ADC.Channel0;
	ArbitrateRead.Service -> ADC.Channel1;
	ArbitrateRead.Service -> ADC.Channel2;
	ArbitrateRead.Service -> ADC.Channel3;
	ArbitrateRead.Service -> ADC.Channel4;
	ArbitrateRead.Service -> ADC.Channel5;
	ArbitrateRead.Service -> ADC.Channel6;
	ArbitrateRead.Service -> ADC.Channel7;
	ArbitrateRead.Service -> ADC.Channel01;
	ArbitrateRead.Service -> ADC.Channel23;
	ArbitrateRead.Service -> ADC.Channel45;
	ArbitrateRead.Service -> ADC.Channel67;
	ArbitrateRead.Service -> ADC.Channel10;
	ArbitrateRead.Service -> ADC.Channel32;
	ArbitrateRead.Service -> ADC.Channel54;
	ArbitrateRead.Service -> ADC.Channel76;
	*/
	

	Channel0 = ADCDeviceC.Channel0;
	Channel1 = ADCDeviceC.Channel1;
	Channel2 = ADCDeviceC.Channel2;
	Channel3 = ADCDeviceC.Channel3;
	Channel4 = ADCDeviceC.Channel4;
	Channel5 = ADCDeviceC.Channel5;
	Channel6 = ADCDeviceC.Channel6;
	Channel7 = ADCDeviceC.Channel7;
	Channel01 = ADCDeviceC.Channel01;
	Channel23 = ADCDeviceC.Channel23;
	Channel45 = ADCDeviceC.Channel45;
	Channel67 = ADCDeviceC.Channel67;
	Channel10 = ADCDeviceC.Channel10;
	Channel32 = ADCDeviceC.Channel32;
	Channel54 = ADCDeviceC.Channel54;
	Channel76 = ADCDeviceC.Channel76;
  
}
