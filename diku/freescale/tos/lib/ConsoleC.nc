/*
    Console configurations - module that buffers and perhaps
    eventually will do some printf like thing.  

    Copyright (C) 2002-2004 Mads Bondo Dydensborg <madsdyd@diku.dk>

    This program is free software; you can redistribute it and/or modify
    it under the terms of the GNU General Public License as published by
    the Free Software Foundation; either version 2 of the License, or
    (at your option) any later version.

    This program is distributed in the hope that it will be useful,
    but WITHOUT ANY WARRANTY; without even the implied warranty of
    MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
    GNU General Public License for more details.

    You should have received a copy of the GNU General Public License
    along with this program; if not, write to the Free Software
    Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA  02111-1307  USA
*/
/**
 * Simple Console component that uses Uart interface.  
 *
 * <p>This configuration maps onto the uart that is normally used to
 * connect onto a pc.</p>
 *
 * 

 */
configuration ConsoleC
{
	provides {
		interface ConsoleInput as ConsoleIn;
		interface ConsoleOutput as ConsoleOut;
		interface StdControl;
	}
}

implementation
{
	components ConsoleP,
	           Hcs08Uart1C;

	ConsoleIn = ConsoleP.ConsoleIn;
	ConsoleOut = ConsoleP.ConsoleOut;
	StdControl = ConsoleP.StdControl;
  Hcs08Uart1C.UartByte <- ConsoleP;
  Hcs08Uart1C.UartStream <- ConsoleP;
  Hcs08Uart1C.StdControl <- ConsoleP.UartControl;
}
