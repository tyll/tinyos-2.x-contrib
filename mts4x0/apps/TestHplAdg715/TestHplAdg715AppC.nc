
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

#include <I2C.h>
#include <mts400.h>

configuration TestHplAdg715AppC
{
}

implementation
{
	components MainC, LedsC as Leds;
	components new HplAdg715C(I2C_POWER_SWITCH_ADDR) as PowerSwitch;
	components new Atm128I2CMasterC() as I2C;
	components TestHplAdg715C as App;

	components new TimerMilliC() as Timer0;

	App -> MainC.Boot;
	App.Timer0 -> Timer0;
	App.Leds -> Leds;
	App.PowerSwitch -> PowerSwitch;

	PowerSwitch.I2C -> I2C;
	PowerSwitch.I2CResource -> I2C;
}
