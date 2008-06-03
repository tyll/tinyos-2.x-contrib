
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
 * This module tests the power Switch on mda4X0 board
 * On success red led is blinking and green and yellow leds are constantly on 
 */


module TestHplAdg715C
{
	uses
	{
		interface Leds;
		interface Timer<TMilli> as Timer0;
		interface Switch as PowerSwitch;
		interface Boot;
	}
}

implementation
{
	uint8_t cpt;

	task void startTimer()
	{
		call Leds.led2On();
		call Timer0.startPeriodic(500);
	}

	event void Boot.booted()
	{
		cpt = 0;

		if( call PowerSwitch.setAll(0x00) == SUCCESS)
		{
			call Leds.led1On();
		}
	}

	event void Timer0.fired()
	{
		cpt = 1 - cpt;

		call Leds.led0Toggle();

		if (call PowerSwitch.set(1, cpt) == SUCCESS)
		{
			call Leds.led1On();
		}
		else
		{	
			call Leds.led1Off();
		}
	}

	event void PowerSwitch.setDone(error_t error)
	{


		if(error == SUCCESS)
		{
			call Leds.led2On();
		}
		else
		{
			call Leds.led2Off();
		}
	}

	event void PowerSwitch.setAllDone(error_t error)
	{
		post startTimer();
	}

	event void PowerSwitch.maskDone(error_t error)
	{
	}
	event void PowerSwitch.getDone(error_t error, uint8_t val)
	{
	}
}
