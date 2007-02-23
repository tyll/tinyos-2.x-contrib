#include "DSNBoot.h"
#include "msp430UsartResource.h"

configuration DSNBootC
{
}
implementation
{
	components DSNBootP as App, DSNBootInitP, DSNBootLedsP;
	components DSNBootUartP as Usart;
//	components new Msp430Usart0C() as Usart;

//	App.Boot -> MainC.Boot;
	App.Init -> DSNBootInitP;
	App.InitLeds -> DSNBootLedsP;
 	App.Leds -> DSNBootLedsP;
	
	App.UsartControl -> Usart;
	App.Interrupt -> Usart;

	components HplMsp430GeneralIOC as GeneralIOC
    , new Msp430GpioC() as Led0
    , new Msp430GpioC() as Led1
    , new Msp430GpioC() as Led2
    ;
	DSNBootLedsP.Led0 -> GeneralIOC.Port54;
	DSNBootLedsP.Led1 -> GeneralIOC.Port55;
	DSNBootLedsP.Led2 -> GeneralIOC.Port56;
	
	// BSL on boot pin
	App.BootPin -> GeneralIOC.Port23;
	
	// Uart Pins
	Usart.SIMO -> GeneralIOC.SIMO0;
	Usart.SOMI -> GeneralIOC.SOMI0;
	Usart.UCLK -> GeneralIOC.UCLK0;
	Usart.URXD -> GeneralIOC.URXD0;
	Usart.UTXD -> GeneralIOC.UTXD0;
}
