
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
/*                           Aurelien Francillon                       */
/* Contact <aurelien.francillon@inrialpes.fr> for comment, bug reports */
/* and possible alternative licensing of this program                  */
/***********************************************************************/

/**
 * @file   GpsParserC.nc
 * @author Christophe Braillon
 * @author Aurelien Francillon
 *
 * @brief This module receive a NMEA frame form a GPS Driver, parses
 *  the frame and store numerical data into a GpsGGAMsg.
 *  once proper data is retrived ot sigals availaility of data
 *
 */

#include "gps.h"

configuration GpsParserC
{
	provides
	{
		interface GpsParser as GPSParser;
		interface Init as GPSParserInit;
		interface SplitControl as GPSParserControl;
	}
}

implementation
{

	components LedsC as Leds;
	components GpsParserP;
	components GPSC;

	GpsParserP.GPSInit->GPSC;
	GpsParserP.GPSControl->GPSC;
	GpsParserP.GPS->GPSC;

	GpsParserP.Leds->Leds;
	GpsParserP=GPSParser;
	GpsParserP=GPSParserControl;
	GpsParserP=GPSParserInit;

}
