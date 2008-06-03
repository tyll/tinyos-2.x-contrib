
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


configuration TestMts400SwitchesAppC
{
}

implementation
{
	components MainC;
	components LedsC as Leds;
	App.Boot -> MainC.Boot;
	App.Timer0 -> Timer0;
	App.Leds -> Leds;


	components Mts400SwitchesC;
	components TestMts400SwitchesC as App;
 	components new TimerMilliC() as Timer0;
	App.SplitInit -> Mts400SwitchesC.SplitInit;
	App.GPSPower  -> Mts400SwitchesC.GPSPower;
	App.GPSConnect  -> Mts400SwitchesC.GPSConnect;
 	components new TimerMilliC() as TimerStop;
	App.TimerStop -> TimerStop;


  components PrintfC;
 	components new TimerMilliC() as FlushTimer;
	App.FlushTimer -> FlushTimer;
	App.PrintfControl -> PrintfC;
  App.PrintfFlush -> PrintfC;
}
