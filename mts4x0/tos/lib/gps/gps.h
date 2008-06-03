
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

#ifndef GPS_H
#define GPS_H

enum
{
	AM_GPS = 6
};

typedef nx_struct GpsTime
{
	nx_uint8_t h;
	nx_uint8_t m;
	nx_uint8_t s;
} GpsTime;

typedef nx_struct GpsLatitude
{
	nx_int8_t deg;   // Between -90°, i.e. 9O° S (south pole) and 90°, i.e. 90° N (north pole)
	nx_uint8_t min;  // Between 0 and 59
	nx_uint16_t mmin; // Between 0 and 9999
} GpsLatitude;

typedef nx_struct GpsLongitude
{
	nx_int16_t deg;  // Between -180°, i.e. 180° W and 180°, i.e. 180° E
	nx_uint8_t min;  // Between 0 and 59
	nx_uint16_t mmin; // Between 0 and 9999
} GpsLongitude;

// Enum for GPS mode
enum
{
	GPS_MODE_INVALID   = 0,
	GPS_MODE_GPS       = 1,
	GPS_MODE_DGPS      = 2,
	GPS_MODE_PPS       = 3,
	GPS_MODE_RTK       = 4,
	GPS_MODE_FLOAT_RTK = 5,
	GPS_MODE_ESTIMATED = 6,
	GPS_MODE_MANUAL    = 7,
	GPS_MODE_SIMULATED = 8
};

// 16 bytes  
typedef nx_struct GpsGGAMsg
{
	GpsTime time;
	GpsLatitude latitude;
	GpsLongitude longitude;
	nx_uint8_t mode;
	nx_uint8_t nb_sat;
	nx_uint16_t altitude;
} GpsGGAMsg;

typedef nx_struct GpsVTGMsg
{
	//TODO
	nx_uint8_t speed;
} GpsVTGMsg;

#endif
