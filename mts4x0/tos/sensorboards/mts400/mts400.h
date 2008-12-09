
/******************************************************************************/
/* This program is free software; you can redistribute it and/or              */
/* modify it under the terms of the GNU General Public License as             */
/* published by the Free Software Foundation; either version 2 of the         */
/* License, or (at your option) any later version.                            */
/*                                                                            */
/* This program is distributed in the hope that it will be useful, but        */
/* WITHOUT ANY WARRANTY; without even the implied warranty of                 */
/* MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU          */
/* General Public License for more details.                                   */
/*                                                                            */
/* Written and (c) by INRIA, Aurelien Francillon                              */
/* Contact <aurelien.francillon@inrialpes.fr> for comment, bug reports        */
/* and possible alternative licensing of this program                         */
/******************************************************************************/


/**
 * @file   mts400.h
 * @author Aurelien Francillon 
 * @date   Fri May  9 02:30:49 2008
 * 
 * @brief this inlude file contains declarations for the mts4X0 boards
 * 
 */

#ifndef  MTS400_H
#define   MTS400_H

// addresses of the two swtches on the i2c bus
enum{
  I2C_POWER_SWITCH_ADDR=0x48,
  I2C_DATA_SWITCH_ADDR=0x49,
};

// power switch 
enum{
	PWR_GPS_ENA = 0x80,
	PWR_GPS_PWR = 0x40,
	PWR_PRESSURE= 0x04,
	ALLOFF=0,
	ALLON=0,
	// values according to the datasheet not tested 
	// please report sucess /failure ...
	PWR_ACCEL   = 0x20, 
	PWR_EEPROM  = 0x10,
	PWR_LIGHT   = 0x01,
	PWR_HUMIDITY= 0x08,
};

// data switch 

// Bit positions;
enum{
	GPS_RX_BITPOS=0,
	GPS_TX_BITPOS=1,
	PRESSURE_SCLK_BITPOS=2,
	PRESSURE_DIN_BITPOS=3,
	PRESSURE_DOUT_BITPOS=4,
	//	D6 not connected 
	HUMIDITY_SCK_BITPOS=6,
	HUMIDITY_DATA_BITPOS=7,
};
// word values 
enum{
	GPS_RX= (1<<GPS_RX_BITPOS),
	GPS_TX= (1<<GPS_TX_BITPOS),
	
	PRESSURE_SCLK= (1<<PRESSURE_SCLK_BITPOS),
	PRESSURE_DIN = (1<<PRESSURE_DIN_BITPOS),
	PRESSURE_DOUT= (1<<PRESSURE_DOUT_BITPOS),
	
	HUMIDITY_SCK = (1<<HUMIDITY_SCK_BITPOS),
	PRESSURE_DATA= (1<<HUMIDITY_DATA_BITPOS),
};

#endif /* MTS400_H */
