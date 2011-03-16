#include "DSN.h"
configuration DsnPlatformC {
	provides {
		interface DsnPlatform;
#ifndef NODSN		
		interface UartStream;
		interface Resource;
#endif		
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
#ifdef NODSN
   	components new DsnPlatformTinyNodeP(FALSE);
   	DsnPlatform = DsnPlatformTinyNodeP;
#else		   	
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
#endif
	
// tinynode ##############################################################
#if defined(PLATFORM_TINYNODE184)
	#ifdef NODSN
		components new DsnPlatformTinyNode184P(FALSE);
		DsnPlatform = DsnPlatformTinyNode184P;
	#else
		#if defined(BOARD_SIB) || defined(BOARD_SIB2)
			#warning "********* using DSN for Tinynode184 with SIB"
			// sib ##############################################################
			components DsnPlatformSibP;
			components SibUart0AC as DsnSibUartC;
			
			Resource = DsnPlatformSibP;
			UartStream = DsnSibUartC;
			DsnPlatform = DsnPlatformSibP;
			
			DsnSibUartC.SibUartConfigure->DsnPlatformSibP.SibUartConfigure;
			DsnPlatformSibP.UartControl -> DsnSibUartC;	
			DsnPlatformSibP.UartStream -> DsnSibUartC;
			DsnPlatformSibP.UartByte -> DsnSibUartC;
			DsnPlatformSibP.Resource -> DsnSibUartC;
			DsnPlatformSibP.SibUartHPL -> DsnSibUartC;
		
			#ifdef TINYOS_NP	
			components CrcC,
				InternalFlashC as IFlash;
		
			DsnPlatformSibP.Crc -> CrcC;
			DsnPlatformSibP.IFlash -> IFlash;
			#endif
		#elif defined(BOARD_POWERSWITCH)
			#warning "********* using DSN for Tinynode184 with POWERSWITCH SW UART"
			components new DsnPlatformSWUartTxP(FALSE), SWUartTxP, BusyWaitMicroC;
			components HplMsp430GeneralIOC, new Msp430GpioC();  
			Msp430GpioC.HplGeneralIO->HplMsp430GeneralIOC.Port61;
			SWUartTxP.TxPin -> Msp430GpioC;
			SWUartTxP.BusyWait -> BusyWaitMicroC;
			DsnPlatformSWUartTxP.TxPin -> Msp430GpioC;
			Resource = DsnPlatformSWUartTxP;
			UartStream = SWUartTxP;
			DsnPlatform = DsnPlatformSWUartTxP;
			components ActiveMessageAddressC;
			DsnPlatformSWUartTxP.setAmAddress -> ActiveMessageAddressC;

		#else // not sib
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
	#endif // DSN / NODSN
#endif // TINYNODE184		

}
