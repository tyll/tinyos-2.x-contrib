/*
    StdOut module - module that buffers and perhaps eventually will do some
    printf like thing.
    Copyright (C) 2002 Mads Bondo Dydensborg <madsdyd@diku.dk>

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
/*
 * Simple StdOut component, uses Uart interface, buffers into 200 char buffer
 */

/**
 * Simple StdOut component that uses Uart interface.
 * <p>This configuration maps onto the uart that is normally used to connect onto 
 * a pc.</p>
 *
 * <p>Please note that this component blocks interrupts and copies
 * data - it is not a very good TinyOS citizen. Its a debug tool.</p>
 */
module StdNullM
{
  provides interface Init;
  provides interface StdOut;
}


implementation
{
  command error_t Init.init() {

    return SUCCESS;
  }

  command error_t StdOut.done() {
    return SUCCESS;
  }

  async command int StdOut.print(const char * str) {
    return 0;
  }
  async command int StdOut.printHex(uint8_t c) {
    return 0;
  }

  async command int StdOut.printHexword(uint16_t c) {
    return 0;
  }

  async command int StdOut.printHexlong(uint32_t c) {
    return 0;
  }

	async command int StdOut.printBase10uint8(const uint8_t c)
	{
    return 0;
	}

	async command int StdOut.printBase10int8(const int8_t c)
	{
    return 0;
	}

	async command int StdOut.printBase10uint16(const uint16_t c)
	{
    return 0;
	}
  
	async command int StdOut.printBase10int16(const int16_t c)
	{
    return 0;
	}

	async command int StdOut.printBase10uint32(const uint32_t c)
	{
    return 0;
	}

	async command int StdOut.printBase10int32(const int32_t c)
	{
    return 0;
	}

	async command int StdOut.printBase2(uint8_t c)
	{
    return 0;
	}

	async command int StdOut.printBase2word(uint16_t c)
	{
    return 0;
	}

	async command int StdOut.printBase2long(uint32_t c)
	{
    return 0;
	}

  async command void StdOut.dumpHex(uint8_t ptr[], uint8_t countar, char * sep) {

  }
  
  default async event void StdOut.get(uint8_t data) {
  }

}
