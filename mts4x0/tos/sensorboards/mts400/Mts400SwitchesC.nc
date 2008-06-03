
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
#include "mts400.h"

configuration Mts400SwitchesC
{
	provides
	{
		interface SplitControl as SplitInit;
		interface SplitControl as GPSPower;
		interface SplitControl as AccelPower;
		interface SplitControl as EEPROMPower;
		interface SplitControl as HumidityPower;
		interface SplitControl as PressurePower;
		interface SplitControl as LightPower;

		interface SplitControl as HumidityConnect;
		interface SplitControl as PressureConnect;
		interface SplitControl as GPSConnect;
	}
}

implementation
{

	components new HplAdg715C(I2C_POWER_SWITCH_ADDR) as PowerSwitch;
	components new HplAdg715C(I2C_DATA_SWITCH_ADDR) as DataSwitch;
	components new Atm128I2CMasterC() as I2CPower;
	components new Atm128I2CMasterC() as I2CData;
	components Mts400SwitchesP;


	Mts400SwitchesP.SplitInit      = SplitInit;
	Mts400SwitchesP.GPSPower       = GPSPower;
	Mts400SwitchesP.AccelPower     = AccelPower;
	Mts400SwitchesP.EEPROMPower    = EEPROMPower;
	Mts400SwitchesP.HumidityPower  = HumidityPower;
	Mts400SwitchesP.PressurePower   = PressurePower;
	Mts400SwitchesP.LightPower     = LightPower;
	Mts400SwitchesP.HumidityConnect= HumidityConnect;
	Mts400SwitchesP.PressureConnect= PressureConnect;
	Mts400SwitchesP.GPSConnect     = GPSConnect;

	Mts400SwitchesP.PowerSwitch->PowerSwitch;
	Mts400SwitchesP.DataSwitch->DataSwitch;

	PowerSwitch.I2CResource ->I2CPower.Resource;
	DataSwitch.I2CResource -> I2CData.Resource;

	PowerSwitch.I2C->I2CPower;
	DataSwitch.I2C -> I2CData;


}
