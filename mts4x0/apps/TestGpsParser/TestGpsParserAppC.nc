
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
 * @file   TestGpsParserAppC.nc
 * @author Christophe Braillon
 * @author Aurelien Francillon
 * @date   Fri May  9 01:32:22 2008
 *
 * @brief  Sample apication to test the on mote parsing of gps frames
 * the converted data is sent over the serial line in GpsGGAMsg packets
 * this data can be displayed with pc/testGPS.py program
 */

#include "gps.h"
//#define PRINTFDEBUG

configuration TestGpsParserAppC
{
}

implementation
{
  components MainC, LedsC as Leds;
  components SerialActiveMessageC;
  components new SerialAMSenderC(AM_GPS);
  components new SerialAMReceiverC(AM_GPS);

  components GpsParserC as GPSParser;

  components TestGpsParserC as App;

  App -> MainC.Boot;
  App.Leds -> Leds;

  App.GPSParser -> GPSParser;
  App.GPSParserControl -> GPSParser.GPSParserControl;
  App.GPSParserInit -> GPSParser.GPSParserInit;

  App.SerialPacket -> SerialAMSenderC;
  App.SerialAMPacket -> SerialAMSenderC;
  App.SerialAMControl -> SerialActiveMessageC;
  App.SerialAMSend -> SerialAMSenderC;

#ifdef PRINTFDEBUG
  components PrintfC;
 	components new TimerMilliC() as FlushTimer;
	App.FlushTimer -> FlushTimer;
	App.PrintfControl -> PrintfC;
  App.PrintfFlush -> PrintfC;
#endif
}
