/**
 * Configuration of the DSN Component for TinyOS.
 *
 * This component gives the facility to easily log messages to the Deployment Support Network
 * and receive commands.
 *
 * @author Roman Lim <rlim@ee.ethz.ch>
 * @modified 10/3/2006 Added documentation.
 *
 **/

#include <AM.h>
#include <msp430usart.h>
#include "DSN.h"

configuration DSNC
{
	provides interface DSN;	
	provides interface Init;
}
implementation
{
	components HplMsp430GeneralIOC;
	components new Msp430GpioC() as TxPin;

#if USART == 0
	components new Msp430Uart0C() as Uart;
	components HplMsp430Usart0C as HplUsart;
	// for setting txpin high while sleeping (avoids framing errors)
	TxPin.HplGeneralIO -> HplMsp430GeneralIOC.UTXD0;	
#endif
#if USART == 1
	components new Msp430Uart1C() as Uart;
	components HplMsp430Usart1C as HplUsart;
	// for setting txpin high while sleeping (avoids framing errors)
	TxPin.HplGeneralIO -> HplMsp430GeneralIOC.UTXD1;
#endif
	DSNP.TxPin -> TxPin;
	
	components ActiveMessageAddressC;
	components new TimerMilliC() as Timer;
	components DSNP;
	components dsnUartConfigureP;
	
	DSN = DSNP.DSN;
	Init = DSNP.Init;
	DSNP.setAmAddress -> ActiveMessageAddressC;
	
	components ActiveMessageC;
	DSNP.Packet->ActiveMessageC;
	DSNP.RadioControl->ActiveMessageC;
	
	// wire uart stuff
	DSNP.UartStream -> Uart;
	DSNP.HplMsp430Usart -> HplUsart;
	DSNP.Resource -> Uart;
	DSNP.Timer -> Timer;
	Uart.Msp430UartConfigure -> dsnUartConfigureP;
	
#ifndef 	NOSHARE
	// rx handshake interrupt 23
	// tmote pin 23 <- 
	// tmote pin 26 ->
	//
	components new Msp430GpioC() as RxRTSPin;
	components new Msp430GpioC() as RxCTSPin;
	RxRTSPin.HplGeneralIO -> HplMsp430GeneralIOC.Port23;
	RxCTSPin.HplGeneralIO -> HplMsp430GeneralIOC.Port26;
	DSNP.RxRTSPin -> RxRTSPin;	
	DSNP.RxCTSPin -> RxCTSPin;	
		
	components new Msp430InterruptC() as RxRTSInt;
	components HplMsp430InterruptC; 
	RxRTSInt.HplInterrupt -> HplMsp430InterruptC.Port23;
	DSNP.RxRTSInt -> RxRTSInt.Interrupt;
#endif
	
	// Emergency logging
	components Counter32khz32C;
	components new CounterToLocalTimeC(T32khz);
	CounterToLocalTimeC.Counter->Counter32khz32C;
	DSNP.LocalTime -> CounterToLocalTimeC;
	components new TimerMilliC() as EmergencyTimer;
	DSNP.EmergencyTimer -> EmergencyTimer;
			
	components NoLedsC as LedsC;
	DSNP.Leds->LedsC;
	
}

