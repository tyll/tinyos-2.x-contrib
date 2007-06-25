/* Copyright (c) 2007 ETH Zurich.
*  All rights reserved.
*
*  Redistribution and use in source and binary forms, with or without
*  modification, are permitted provided that the following conditions
*  are met:
*
*  1. Redistributions of source code must retain the above copyright
*     notice, this list of conditions and the following disclaimer.
*  2. Redistributions in binary form must reproduce the above copyright
*     notice, this list of conditions and the following disclaimer in the
*     documentation and/or other materials provided with the distribution.
*  3. Neither the name of the copyright holders nor the names of
*     contributors may be used to endorse or promote products derived
*     from this software without specific prior written permission.
*
*  THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS `AS IS'
*  AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE
*  IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE
*  ARE DISCLAIMED.  IN NO EVENT SHALL THE COPYRIGHT HOLDERS OR CONTRIBUTORS
*  BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR
*  CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO, LOSS OF USE, DATA,
*  OR PROFITS) HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN
*  CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE)
*  ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF
*  THE POSSIBILITY OF SUCH DAMAGE.
*
*  For additional information see http://www.btnode.ethz.ch/
*
*  $Id$
* 
*/

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
//	provides interface Init;
}
implementation
{
#ifdef NODSN
	components ActiveMessageAddressC;
	components noDSNP as DSNP;
	
	DSN = DSNP.DSN;
	components RealMainP;
	RealMainP.PlatformInit -> DSNP.NodeIdInit;
	DSNP.setAmAddress -> ActiveMessageAddressC;
#else
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
	components DSNP;
	components dsnUartConfigureP;
	
	components RealMainP, MainC;
	RealMainP.PlatformInit -> DSNP.NodeIdInit;
	
	DSN = DSNP.DSN;
	MainC.SoftwareInit->DSNP.Init;
	DSNP.Boot -> MainC;
	DSNP.setAmAddress -> ActiveMessageAddressC;
	
	components ActiveMessageC;
	DSNP.Packet->ActiveMessageC;
	DSNP.RadioControl->ActiveMessageC;
	
	// wire uart stuff
	DSNP.UartStream -> Uart;
	DSNP.HplMsp430Usart -> HplUsart;
	DSNP.Resource -> Uart;
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
			
	components LedsC as LedsC;
	DSNP.Leds->LedsC;
#endif	
}

