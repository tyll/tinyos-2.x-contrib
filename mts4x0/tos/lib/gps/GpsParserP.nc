
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

module GpsParserP
{
	provides
	{
		interface GpsParser as GPSParser;
		interface Init as GPSParserInit;
		interface SplitControl as GPSParserControl;
	}

	uses
	{
		interface Leds;
		interface Init as GPSInit;
		interface SplitControl as GPSControl;
		interface MTS400Sensor as GPS;
	}
}

implementation
{
	// pointer passing is used to avoid data corruption just like with
	// Tinyos Receive interface
	GpsGGAMsg gga, *ggaptr;

	command error_t GPSParserInit.init()
	{
		ggaptr=&gga;
		return call GPSInit.init();
	}

	command error_t GPSParserControl.start()
	{
		return call GPSControl.start();
	}

	command error_t GPSParserControl.stop()
	{
		return call GPSControl.stop();
	}

	event void GPSControl.startDone(error_t error)
	{
		signal GPSParserControl.startDone(error);
	}

	event void GPSControl.stopDone(error_t error)
	{
		signal GPSParserControl.stopDone(error);
	}

	/** 
	 * parses the GGA time string (in HHMMSS format) and convert it to
	 * numerical h/m/s
	 * 
	 * @param i poition in the time string 
	 * @param b character to process
	 */
	void parseTime(uint8_t i, uint8_t b)
	{
		b-='0';
		switch(i)
		{
			case 0:
				ggaptr->time.h = b * 10;
				break;
			case 1:
				ggaptr->time.h += b;
				break;
			case 2:
				ggaptr->time.m = b * 10;
				break;
			case 3:
				ggaptr->time.m += b;
				break;
			case 4:
				ggaptr->time.s = b * 10;
				break;
			case 5:
				ggaptr->time.s += b;
				break;
		}
	}
	/** 
	 * parses the GGA latitude string (in DDMMdddd format) and convert it to
	 * numerical D/M/mmin 
	 * D degree 
	 * M minute 
	 * mmin minute 10^-3
	 * 
	 * @param i pos in NMEA latitude string
	 * @param b byte of the MNEA string 
	 */
	void parseLatitude(uint8_t i, uint8_t b)
	{
		b-='0';
		switch(i)
		{
			case 0:
				ggaptr->latitude.deg = b * 10;
				break;

			case 1:
				ggaptr->latitude.deg += b;
				break;

			case 2:
				ggaptr->latitude.min = b * 10;
				break;

			case 3:
				ggaptr->latitude.min += b;
				break;

			case 4:
				ggaptr->latitude.mmin = b * 1000;
				break;

			case 5:
				ggaptr->latitude.mmin += b * 100;
				break;

			case 6:
				ggaptr->latitude.mmin += b * 10;
				break;

			case 7:
				ggaptr->latitude.mmin += b;
				break;
		}
	}
	
	void parseLongitude(uint8_t i, uint8_t b)
	{
		b-='0';
		switch(i)
		{
			case 0:
				ggaptr->longitude.deg = b * 100;
				break;

			case 1:
				ggaptr->longitude.deg = b * 10;
				break;

			case 2:
				ggaptr->longitude.deg += b;
				break;

			case 3:
				ggaptr->longitude.min = b * 10;
				break;

			case 4:
				ggaptr->longitude.min += b;
				break;

			case 5:
				ggaptr->longitude.mmin = b * 1000;
				break;

			case 6:
				ggaptr->longitude.mmin += b * 100;
				break;

			case 7:
				ggaptr->longitude.mmin += b * 10;
				break;

			case 8:
				ggaptr->longitude.mmin += b;
				break;
		}
	}

	/** 
	 * Converts two digit string of the number of satellites into a
	 * uint8_t
	 * 
	 * @param i pos in string 
	 * @param b char
	 */
	void parseNbSat(uint8_t i, uint8_t b)
	{
		
		b-= '0';
		switch(i)
		{
			case 0:
				ggaptr->nb_sat = 10 * b;
				break;

			case 1:
				ggaptr->nb_sat += b;
				break;
		}
	}

	/** 
	 * converts altitude as string bytes to altitude in numerical meters
	 * 
	 * @param i position in the string 
	 * @param b decimal character of the altitude
	 */
	void parseAltitude(uint8_t i, uint8_t b)
	{
		ggaptr->altitude = ggaptr->altitude * 10 + (b - '0');
	}

	void initGGA()
	{
		ggaptr->time.h = -1;
		ggaptr->time.m = -1;
		ggaptr->time.s = -1;

		ggaptr->latitude.deg = -1;
		ggaptr->latitude.min = -1;
		ggaptr->latitude.mmin = -1;

		ggaptr->longitude.deg = -1;
		ggaptr->longitude.min = -1;
		ggaptr->longitude.mmin = -1;

		ggaptr->mode = -1;
		ggaptr->nb_sat = -1;
		ggaptr->altitude = 0;
	}

	/** 
	 * Parses the NMEA frame sent by the gps device 
	 * Only  $GP,GGA are handled for now 
	 * TODO add VTG handling if needed  
	 *
	 * @param buf    the NMEA Frame received 
	 * @param length lenght of the frame 
	 */
	event void GPS.dataReady(uint8_t *buf, uint16_t length)
	{
		uint8_t i, ref;
		uint8_t state = 0;
	 
		if((buf[0] == '$') &&
		   (buf[1] == 'G') &&
		   (buf[2] == 'P'))
		{
			if((buf[3] == 'G') &&
			   (buf[4] == 'G') &&
			   (buf[5] == 'A'))
			{
				// resets the gga buffer 
				initGGA();

				ref = 7;

				for(i = 7; i < length; i++)
				{
					// skip the commas, parse next field,
					if(buf[i] == ',')
					{
						ref = i + 1;
						state++;
						continue;
					}

					switch(state)
					{
						case 0:
							parseTime(i - ref, buf[i]);
							break;

						case 1:
							parseLatitude(i - ref, buf[i]);
							break;

						case 2:
							if(buf[i] == 'N')
							{
								// Nothing to do
							}
							else if(buf[i] == 'S')
							{
								ggaptr->latitude.deg = -ggaptr->latitude.deg;
							}
							else
							{
								// Parsing is invalid
								return;
							}
							break;
						
						case 3:
							parseLongitude(i - ref, buf[i]);
							break;

						case 4:
							if(buf[i] == 'E')
							{
								// Nothing to do
							}
							else if(buf[i] == 'W')
							{
								ggaptr->longitude.deg = -ggaptr->longitude.deg;
							}
							else
							{
								// Parsing is invalid
								return;
							}
							break;

						case 5:
							ggaptr->mode = buf[i] - '0';
							break;

						case 6:
							parseNbSat(i - ref, buf[i]);
							break;

						case 7:
							// Horizontal dilution of position
							break;

						case 8:
							// Altitude
							if(buf[i] == '.')
							{
								state++;
								break;
							}
							parseAltitude(i - ref, buf[i]);
							break;

						case 9:
							// Altitude decimals
							break;

						case 10:
							// Altitude unit
							break;
					}
				}
				
				// NMEA GGA string was completely parsed signal arival of gga data
				ggaptr=signal GPSParser.GGAReceived(ggaptr);
			}
		}
	}
}
