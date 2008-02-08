

//#include "I2C.h"

configuration FM3116C
{
  provides interface FM3116[ uint8_t i2cAddr ];
  uses interface Boot;
}

implementation
{
	components FM3116M, LedsC, new Atm128I2CMasterC() as Atm128I2CMasterC;
	
//moteiv:  I2CPacketC, HPLUSART0M;
//moteiv:  components new I2CResourceC() as I2CResource;

  FM3116M.Boot = Boot;
  FM3116 = FM3116M;
  FM3116M.Leds -> LedsC;

  FM3116M.I2CResource -> Atm128I2CMasterC;
  FM3116M.I2CPacket -> Atm128I2CMasterC;

//moteiv:  FM3116M.I2CControl -> I2CPacketC;
//moteiv:  FM3116M.UartControl -> HPLUSART0M;
}
