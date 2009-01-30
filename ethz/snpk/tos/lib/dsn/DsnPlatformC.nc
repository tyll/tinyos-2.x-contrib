#include "DSN.h"
configuration DsnPlatformC {
	provides {
		interface DsnPlatform;
		interface UartStream;
		interface Resource;
	}
}
implementation {
// tmote ##############################################################
#if defined(PLATFORM_TELOSB)
#ifndef USART
#define USART 0
#endif
	components HplMsp430GeneralIOC;
   	components new Msp430GpioC() as TxPin;
	#if USART == 0
		components DsnPlatformTelosbP;
		components new Msp430Uart0C() as Uart;
		components HplMsp430Usart0C as HplUsart;
		TxPin.HplGeneralIO -> HplMsp430GeneralIOC.UTXD0;
		// rx handshake interrupt 23
		// tmote pin 23 <- 
		// tmote pin 26 ->
		//
		components new Msp430GpioC() as RxRTSPin;
		components new Msp430GpioC() as RxCTSPin;
		RxRTSPin.HplGeneralIO -> HplMsp430GeneralIOC.Port23;
		RxCTSPin.HplGeneralIO -> HplMsp430GeneralIOC.Port26;
		DsnPlatformTelosbP.RxRTSPin -> RxRTSPin;
		DsnPlatformTelosbP.RxCTSPin -> RxCTSPin;
		components new Msp430InterruptC() as RxRTSInt;
		components HplMsp430InterruptC;
		RxRTSInt.HplInterrupt -> HplMsp430InterruptC.Port23;
		DsnPlatformTelosbP.RxRTSInt -> RxRTSInt.Interrupt;
	#endif
	#if USART == 1
		components DsnPlatformTelosbP;
		components new Msp430Uart1C() as Uart;
		components HplMsp430Usart1C as HplUsart;
		TxPin.HplGeneralIO -> HplMsp430GeneralIOC.UTXD1;
	#endif
	components MainC, new TimerMilliC() as TimeoutTimer;
	DsnPlatformTelosbP.Boot->MainC.Boot;
	DsnPlatformTelosbP.Resource -> Uart;
	DsnPlatformTelosbP.TimeoutTimer->TimeoutTimer;
	Resource = DsnPlatformTelosbP.DsnResource;
	DsnPlatform = DsnPlatformTelosbP;
	UartStream = Uart;
	Uart.Msp430UartConfigure -> DsnPlatformTelosbP;
	DsnPlatformTelosbP.TxPin -> TxPin;
	DsnPlatformTelosbP.HplMsp430Usart->HplUsart;

	components ActiveMessageC;
	DsnPlatformTelosbP.Packet->ActiveMessageC;
	DsnPlatformTelosbP.RadioControl->ActiveMessageC;
	components ActiveMessageAddressC;
	DsnPlatformTelosbP.setAmAddress -> ActiveMessageAddressC;
#endif

// tinynode ##############################################################
#if defined(PLATFORM_TINYNODE)
#ifndef USART
#define USART 1
#endif
	components HplMsp430GeneralIOC;
   	components new Msp430GpioC() as TxPin;
	#if USART == 1
		components new DsnPlatformTinyNodeP(FALSE);
		components new Msp430Uart1C() as Uart;
		components HplMsp430Usart1C as HplUsart;
		TxPin.HplGeneralIO -> HplMsp430GeneralIOC.UTXD1;
		Resource = DsnPlatformTinyNodeP.DummyResource;
		DsnPlatformTinyNodeP.Resource -> Uart;
	#endif
	DsnPlatform = DsnPlatformTinyNodeP;
	UartStream = Uart;
	Uart.Msp430UartConfigure -> DsnPlatformTinyNodeP;
	DsnPlatformTinyNodeP.TxPin -> TxPin;
	DsnPlatformTinyNodeP.HplMsp430Usart->HplUsart;

	components ActiveMessageC;
	DsnPlatformTinyNodeP.Packet->ActiveMessageC;
	DsnPlatformTinyNodeP.RadioControl->ActiveMessageC;
	components ActiveMessageAddressC;
	DsnPlatformTinyNodeP.setAmAddress -> ActiveMessageAddressC;
#endif
	
// tinynode ##############################################################
	#if defined(PLATFORM_TINYNODE184)
	#ifndef USART
	#define USART 1
	#endif
		components HplMsp430GeneralIOC;
	   	components new Msp430GpioC() as TxPin;
		#if USART == 1
			components new DsnPlatformTinyNode184P(FALSE);
			components new Msp430UartA1C() as Uart;
			components HplMsp430UsciA1C as HplUsart;
			TxPin.HplGeneralIO -> HplMsp430GeneralIOC.UTXD1;
			Resource = DsnPlatformTinyNode184P.DummyResource;
			DsnPlatformTinyNode184P.Resource -> Uart;
		#endif
		DsnPlatform = DsnPlatformTinyNode184P;
		UartStream = Uart;
		Uart.Msp430UartConfigure -> DsnPlatformTinyNode184P;
		DsnPlatformTinyNode184P.TxPin -> TxPin;
		DsnPlatformTinyNode184P.HplMsp430Usart->HplUsart;

		components ActiveMessageAddressC;
		DsnPlatformTinyNode184P.setAmAddress -> ActiveMessageAddressC;
	#endif

}
