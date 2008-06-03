
/***********************************************************************/
/* This program is free software; you can redistribute it and/or       */
/* modify it under the terms of the GNU General Public License as      */
/* published by the Free Software Foundation; either version 2 of the  */
/* License, or (at your option) any later version.                     */
/*                                                                     */
/* This program is distributed in the hope that it will be useful, but */
/* WITHOUT ANY WARRANTY; without even the implied warranty of          */
/* MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU   */
/* General Public License for more details.                            */
/*                                                                     */
/* Written and (c) by INRIA, Christophe Braillon                       */
/*                           Aurélien Francillon                       */
/* Contact <aurelien.francillon@inrialpes.fr> for comment, bug reports */
/* and possible alternative licensing of this program                  */
/***********************************************************************/
/**
 * @file   GPSC.nc
 * @author Aurelien Francillon
 * @date   Sun May 25 19:15:12 2008
 *
 * @brief the high level component access to the gps device
 *
 */

#include <I2C.h>
#include <Atm128Uart.h>

configuration GPSC
{
	provides
	{
		// Interface for GPS setup
		interface Init as GPSInit;
		interface SplitControl as GPSControl;

		// Sensor interface
		interface MTS400Sensor;
	}

}

implementation{


	components LeadtekGPS9546C as GPSChip;
	MTS400Sensor = GPSChip.MTS400Sensor;
	GPSChip.GPSInit = GPSInit;

  components HplAtm128UartC as UART;
	GPSChip.UART1 -> UART.HplUart1;
	GPSChip.UART1RxControl -> UART.Uart1RxControl;

	components GPSP;
	GPSP.GPSControl=GPSControl;
	// GPSP handles the connecting and powering up which is specific to
	//	the senenor board

  components Mts400SwitchesC as Switches;
	GPSP.Mts400Init->Switches.SplitInit;
	GPSP.GPSPower->Switches.GPSPower;
	GPSP.GPSConnect->Switches.GPSConnect;

}
