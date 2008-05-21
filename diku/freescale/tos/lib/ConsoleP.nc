/*
    Console module - module that buffers and perhaps eventually will do some
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

/**
 * Simple Console component that uses Uart interface.
 * <p>This configuration maps onto the uart that is normally used to connect onto 
 * a pc.</p>
 *
 */

module ConsoleP
{
	provides {
		interface ConsoleInput as ConsoleIn;
		interface ConsoleOutput as ConsoleOut;
		interface StdControl;
	}
	uses {
		interface StdControl as UartControl;
    interface UartStream;
    interface UartByte;
	}
}
implementation
{
	
	command error_t StdControl.start()
	{
		call UartControl.start();
		call UartStream.enableReceiveInterrupt();
		return SUCCESS;
	}
	
	command error_t StdControl.stop()
	{
		call UartControl.stop();
		return SUCCESS;
	}

	/*async command void ConsoleOut.printLeds(uint8_t ledStatus)
	{
		call Uart.putSync(0x10 | (0x0F & ledStatus));
	}*/

	/* Writes a string to the UART. The string must be null-terminated.
	   The number of chars written will be returned (not including the trailing \0).
	*/
	command int ConsoleOut.print(const char *str)
	{
		int countret = 0;

		while (*str != 0) {
				call UartByte.send(*str);
				str++;
				countret++;
		}

		return countret;
	}
	
	command int ConsoleOut.printStr(const char *str, uint16_t length)
	{
		int countret = 0;
		uint8_t i = 0;
		while (i < length) {
			call UartByte.send(str[i]);
				i++;
				countret++;
		}
		return countret;
		
	}

#ifdef NEED_VA_LIST_SUPPORT_FOR_SPRINTF  
	/* Printf into a buffer, print it */
	command int ConsoleOut.printf(const char * fmt, ...)
	{
		va_list ap;
		char buf[200];
		FILE f;
		int i;
		f.flags = __SWR | __SSTR;
		f.buf = buf;
		f.size = 199;

		va_start(ap, fmt);
		i = vfprintf(&f, fmt, ap);
		va_end(ap);
		buf[i < f.size? i: f.size] = 0;

		return call ConsoleOut.print(buf);
	}
#endif

	/* Add a hex number to the circular buffer 
	   - code is meant to be easy to read */
	command int ConsoleOut.printHex(const uint8_t c)
	{
		char str[3];
		uint8_t v;
    
		// Left digit
		v = (0xF0 & c) >> 4;
		if (v < 0xA) {
			str[0] = v + '0';
		} else {
			str[0] = v - 0xA + 'A';
		}
    
		// Right digit
		v = (0xF & c);
		if (v < 0xA) {
			str[1] = v + '0';
		} else {
			str[1] = v - 0xA + 'A';
		}
		str[2] = 0;
    
		return call ConsoleOut.print(str);
	}

	/* Add a word number to the circular buffer as hex - code is meant
	   to be easy to read. And, also, if you wrote this as an expression,
	   you will be bitten by compiler reordering. I was. And was
	   surprised. */

	command int ConsoleOut.printHexword(const uint16_t c)
	{
		int i = 0;
		i += call ConsoleOut.printHex(c >> 8);
		i += call ConsoleOut.printHex(0xFF & c);
		return i;
	}
  
	/* Add a long number to the circular buffer as hex
	   - code is meant to be easy to read.*/
	command int ConsoleOut.printHexlong(const uint32_t c)
	{
		int i = 0;
		i += call ConsoleOut.printHex(c >> 24);
		i += call ConsoleOut.printHex( (c >> 16) & 0xFF);
		i += call ConsoleOut.printHex( (c >> 8) & 0xFF);
		i += call ConsoleOut.printHex( c & 0xFF);
		return i;
	}
  
	/* Add a uint8_t base10 number to the circular buffer */
	command int ConsoleOut.printBase10uint8(const uint8_t c)
	{
		bool print = 0;
		char str[11];
		uint8_t idx = 0, tmp;
		uint32_t v;
		
		v = c;

		// Digit 10^2
		tmp = v / 100;
		if (tmp != 0 || print) {
			str[idx] = tmp + 48;
			idx++;
			v = v % 100;
			print = 1;
		}

		// Digit 10^1
		tmp = v / 10;
		if (tmp != 0 || print) {
			str[idx] = tmp + 48;
			idx++;
			v = v % 10;
			print = 1;
		}

		// Digit 10^0
		str[idx] = v + 48;
		idx++;
   
      		str[idx] = 0;
   		
		return call ConsoleOut.print(str);
	}

	/* Add a uint8_t base10 number to the circular buffer */
	command int ConsoleOut.printBase10int8(const int8_t c)
	{
		uint8_t count = 0, v;
		
		if (c < 0) {
			count = call ConsoleOut.print("-");
			v = -1 * c; 
		} else {
			v = (uint8_t) c;
		}

		count += call ConsoleOut.printBase10uint8(v);
		
		return count;
	}

	/* Add a uint16_t base10 number to the circular buffer */
	command int ConsoleOut.printBase10uint16(const uint16_t c)
	{
		bool print = 0;
		char str[11];
		uint8_t idx = 0, tmp;
		uint32_t v;
		
		v = c;

		// Digit 10^4
		tmp = v / 10000;
		if (tmp != 0 || print) {
			str[idx] = tmp + 48;
			idx++;
			v = v % 10000;
			print = 1;
		}
		
		// Digit 10^3
		tmp = v / 1000;
		if (tmp != 0 || print) {
			str[idx] = tmp + 48;
			idx++;
			v = v % 1000;
			print = 1;
		}

		// Digit 10^2
		tmp = v / 100;
		if (tmp != 0 || print) {
			str[idx] = tmp + 48;
			idx++;
			v = v % 100;
			print = 1;
		}

		// Digit 10^1
		tmp = v / 10;
		if (tmp != 0 || print) {
			str[idx] = tmp + 48;
			idx++;
			v = v % 10;
			print = 1;
		}

		// Digit 10^0
		str[idx] = v + 48;
		idx++;
   
      		str[idx] = 0;

		return call ConsoleOut.print(str);
	}
  
	/* Add a uint16_t base10 number to the circular buffer */
	command int ConsoleOut.printBase10int16(const int16_t c)
	{
		uint8_t count = 0;
		uint16_t v;
		
		if (c < 0) {
			count = call ConsoleOut.print("-");
			v = -1 * c; 
		} else {
			v = (uint16_t) c;
		}

		count += call ConsoleOut.printBase10uint16(v);
		
		return count;
	}

	/* Add a uint32_t base10 number to the circular buffer */
	command int ConsoleOut.printBase10uint32(const uint32_t c)
	{
		bool print = 0;
		char str[11];
		uint8_t idx = 0, tmp;
		uint32_t v;
		
		v = c;
    
		// Digit 10^9
		tmp = v / 1000000000;
		if (tmp != 0) {
			str[idx] = tmp + 48;
			idx++;
			v = v % 1000000000;
			print = 1;
		}
				
		// Digit 10^8
		tmp = v / 100000000;
		if (tmp != 0 || print) {
			str[idx] = tmp + 48;
			idx++;
			v = v % 100000000;
			print = 1;
		}

		// Digit 10^7
		tmp = v / 10000000;
		if (tmp != 0 || print) {
			str[idx] = tmp + 48;
			idx++;
			v = v % 10000000;
			print = 1;
		}
		
		// Digit 10^6
		tmp = v / 1000000;
		if (tmp != 0 || print) {
			str[idx] = tmp + 48;
			idx++;
			v = v % 1000000;
			print = 1;
		}
		
		// Digit 10^5
		tmp = v / 100000;
		if (tmp != 0 || print) {
			str[idx] = tmp + 48;
			idx++;
			v = v % 100000;
			print = 1;
		}
		
		// Digit 10^4
		tmp = v / 10000;
		if (tmp != 0 || print) {
			str[idx] = tmp + 48;
			idx++;
			v = v % 10000;
			print = 1;
		}
		
		// Digit 10^3
		tmp = v / 1000;
		if (tmp != 0 || print) {
			str[idx] = tmp + 48;
			idx++;
			v = v % 1000;
			print = 1;
		}

		// Digit 10^2
		tmp = v / 100;
		if (tmp != 0 || print) {
			str[idx] = tmp + 48;
			idx++;
			v = v % 100;
			print = 1;
		}

		// Digit 10^1
		tmp = v / 10;
		if (tmp != 0 || print) {
			str[idx] = tmp + 48;
			idx++;
			v = v % 10;
			print = 1;
		}

		// Digit 10^0
		str[idx] = v + 48;
		idx++;
   
      		str[idx] = 0;

		return call ConsoleOut.print(str);
	}

	/* Add a uint32_t base10 number to the circular buffer */
	command int ConsoleOut.printBase10int32(const int32_t c)
	{
		uint8_t count = 0;
		uint32_t v;
		
		if (c < 0) {
			count = call ConsoleOut.print("-");
			v = -1 * c; 
		} else {
			v = (uint32_t) c;
		}

		count += call ConsoleOut.printBase10uint32(v);
		
		return count;
	}

	/** Dump an array of hex's
	 * 
	 * \param ptr - array of uint8_t values
	 * \param count - count of values in array
	 * \param sep - optional seperator string

	 * Always return succes, even if something went wrong.
	 */
	command void ConsoleOut.dumpHex(const uint8_t ptr[], const uint8_t countar, const char * sep)
	{
		int i;
		for (i = 0; i < countar; i++) {
			if (i != 0) {
				call ConsoleOut.print(sep);
			}
			call ConsoleOut.printHex(ptr[i]);
		}
	}

	/* Handle getting data such that the user of this interface can get data. */
	async event void UartStream.receivedByte(uint8_t byte) 
	{
		signal ConsoleIn.get(byte);
	}
	
	async event void UartStream.sendDone( uint8_t* buf, uint16_t len, error_t error ) {}
  
	async event void UartStream.receiveDone( uint8_t* buf, uint16_t len, error_t error ) {}

	default async event void ConsoleIn.get(uint8_t consoleData) {}
}
