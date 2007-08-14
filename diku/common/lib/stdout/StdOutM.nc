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
module StdOutM
{
  provides interface StdOut;
  provides interface Init;
  uses interface SerialByteComm as UART;
}

#define STDOUT_BUFFER_SIZE 1000 // This will probably not be enough always.

// Use the leds to print
//#define DEBUG

implementation
{
  /** The buffer used to buffer into. This is 200 bytes */
  char buffer[STDOUT_BUFFER_SIZE];
  char * bufferhead;
  char * buffertail;
  char * bufferend;
  int isOutputting;
  
  int count;

  /* Init */
  command error_t Init.init() {
    dbg(DBG_USR1, "StdOut starting ......\n");  

    atomic {
      bufferhead   = buffer;
      buffertail   = buffer;
      bufferend    = buffer + STDOUT_BUFFER_SIZE;
      isOutputting = FALSE;
      count        = 0;
    }
    return SUCCESS;

  }

  command error_t StdOut.done() {
    return SUCCESS;
  }

  /* Add a string to the circular buffer. The string must be null-terminated.
     The number of chars written will be returned (not including the trailing \0).
  */
  async command int StdOut.print(const char * str) {
    /* Oh, the horror */
    int na_countret;
    atomic {
      bool return_flag = FALSE;
      int countret = 0;
      dbg(DBG_USR1, "StdOut print \"%s\"\n", str);

      /* Split into two passes - tail after head or before */
      if (buffertail >=  bufferhead) {
	while ((buffertail < bufferend) && (*str !=0)) {
	  // while ((buffertail < bufferend) && (*buffertail++ = *str)) {
	  *buffertail = *str;
	  ++buffertail;
	  //	  dbg(DBG_USR1, "StdOut print - copying \"%c\"\n", *str);
	  ++str;
	  ++countret;
	};
	/* Did we reach the end of the buffer ? */
	if (buffertail == bufferend) {
	  buffertail = buffer;
	} else {
	  /* Done with the string */
	  if (!isOutputting) {
	    //	    dbg(DBG_USR1, "StdOut - putting \"%c\"\n", *bufferhead);
	    call UART.put(*bufferhead);
	    isOutputting = TRUE; // Race condition!
	  }
	  return_flag = TRUE;
	  // return countret;
	}
      } /* buffertail >= buffertail */


      if (!return_flag) {
	//	dbg(DBG_USR1, "StdOut print - past bufferend \"%s\"\n", str);
	/* If we reach here, there are more string, and buffertail <= bufferhead */
	while (buffertail < bufferhead && (*str != 0)) {
	  *buffertail = *str;
	  ++buffertail;
	  ++str;
	  ++countret;
	};
	
	if (!isOutputting) {
	  call UART.put(*bufferhead);
	  isOutputting = TRUE; // Race condition!
	}
	/* Did we reach the end of the buffer ? */
	if (buffertail == bufferhead) {
	  if (!isOutputting) {
	    //	    dbg(DBG_USR1, "StdOut - putting \"%c\"\n", *bufferhead);
	    call UART.put(*bufferhead);
	    isOutputting = TRUE; // Race condition!
	  }
	  return_flag = TRUE;
	  // return countret;
	}
      }
      
      if (!return_flag) {
	/* Done with the string */
	if (!isOutputting) {
	  //	  dbg(DBG_USR1, "StdOut - putting \"%c\"\n", *bufferhead);
	  call UART.put(*bufferhead);
	  isOutputting = TRUE; // Race condition!
	}
	return_flag = TRUE;
	// return countret;
      }
      na_countret = countret;
    } /* Atomic */
    
    return na_countret;
  }

  /* Add a hex number to the circular buffer 
     - code is meant to be easy to read */
  async command int StdOut.printHex(uint8_t c) {
    char str[3];
    uint8_t v;
    
    /* Left digit */
    v = (0xF0U & c) >> 4;
    if (v < 0xAU) {
      str[0] = v + '0';
    } else {
      str[0] = v - 0xAU + 'A';
    }
    
    /* Right digit */
    v = (0xFU & c);
    if (v < 0xAU) {
      str[1] = v + '0';
    } else {
      str[1] = v - 0xAU + 'A';
    }
    str[2] = 0;
    
    return call StdOut.print(str);
  }

  /* Add a word number to the circular buffer as hex
     - code is meant to be easy to read */
  async command int StdOut.printHexword(uint16_t c) {
    return call StdOut.printHex((0xFF00U & c) >> 8) 
      + call StdOut.printHex(0xFFU & c);
  }

  /* Add a long number to the circular buffer as hex
     - code is meant to be easy to read */
  async command int StdOut.printHexlong(uint32_t c) {
    return call StdOut.printHex((0xFF000000U & c) >> 24) 
      + call StdOut.printHex((0xFF0000U & c) >> 16) 
      + call StdOut.printHex((0xFF00U & c) >> 8) 
      + call StdOut.printHex(0xFFU & c);
  }

	/* Add a uint8_t base10 number to the circular buffer */
	async command int StdOut.printBase10uint8(const uint8_t c)
	{
		bool print = 0;
		char str[4];
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
   		
		return call StdOut.print(str);
	}

	/* Add a uint8_t base10 number to the circular buffer */
	async command int StdOut.printBase10int8(const int8_t c)
	{
		uint8_t counter = 0, v;
		
		if (c < 0) {
			counter = call StdOut.print("-");
			v = -1 * c; 
		} else {
			v = (uint8_t) c;
		}

		counter += call StdOut.printBase10uint8(v);
		
		return counter;
	}

	/* Add a uint16_t base10 number to the circular buffer */
	async command int StdOut.printBase10uint16(const uint16_t c)
	{
		bool print = 0;
		char str[6];
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

		return call StdOut.print(str);
	}
  
	/* Add a uint16_t base10 number to the circular buffer */
	async command int StdOut.printBase10int16(const int16_t c)
	{
		uint8_t counter = 0;
		uint16_t v;
		
		if (c < 0) {
			counter = call StdOut.print("-");
			v = -1 * c; 
		} else {
			v = (uint16_t) c;
		}

		counter += call StdOut.printBase10uint16(v);
		
		return counter;
	}

	/* Add a uint32_t base10 number to the circular buffer */
	async command int StdOut.printBase10uint32(const uint32_t c)
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

		return call StdOut.print(str);
	}

	/* Add a uint32_t base10 number to the circular buffer */
	async command int StdOut.printBase10int32(const int32_t c)
	{
		uint8_t counter = 0;
		uint32_t v;
		
		if (c < 0) {
			counter = call StdOut.print("-");
			v = -1 * c; 
		} else {
			v = (uint32_t) c;
		}

		counter += call StdOut.printBase10uint32(v);
		
		return counter;
	}

	/* Add a 8-bit base2 number to the circular buffer */
	async command int StdOut.printBase2(uint8_t c)
	{
	    char str[9];
		uint8_t i, v;
		
		v = c;
		
		for (i = 0; i < 8; i++) 
		{
			str[7 - i] = ((v & 0x01U) == 0x01U) ? '1' : '0';
			v >>= 1;
		}
		
		str[8] = 0;

		return call StdOut.print(str);
	}

	/* Add a 16-bit base2 number to the circular buffer */
	async command int StdOut.printBase2word(uint16_t c)
	{
	    char str[17];
		uint8_t i;
		uint16_t v;
		
		v = c;
		
		for (i = 0; i < 16; i++) 
		{
			str[15 - i] = ((v & 0x0001U) == 0x0001U) ? '1' : '0';
			v >>= 1;
		}
		
		str[16] = 0;

		return call StdOut.print(str);
	}

	/* Add a 32-bit base10 number to the circular buffer */
	async command int StdOut.printBase2long(uint32_t c)
	{
	    char str[33];
		uint8_t i;
		uint32_t v;
		
		v = c;
		
		for (i = 0; i < 32; i++) 
		{
			str[31 - i] = ((v & 0x00000001U) == 0x00000001U) ? '1' : '0';
			v >>= 1;
		}
		
		str[32] = 0;

		return call StdOut.print(str);
	}

  /** Dump an array of hex's
   * 
   * \param ptr - array of uint8_t values
   * \param count - count of values in array
   * \param sep - optional seperator string

   * Always return succes, even if something went wrong.
   */
  async command void StdOut.dumpHex(uint8_t ptr[], uint8_t countar, char * sep) {
    int i;
    for (i = 0; i < countar; i++) {
      if (i != 0) { 
	call StdOut.print(sep);
      }
      call StdOut.printHex(ptr[i]);
    }
  }
  

  /* Handle emptying the buffer - the one in head have now been outputted 
     and we need to output the next, if needed. */
  async event void UART.putDone() {
    //    dbg(DBG_USR1, "StdOut putDone\n");
    atomic {
      /* Adjust bufferhead */
      ++bufferhead;
      ++count;
      if (bufferhead == bufferend) {
	bufferhead = buffer;
      }
      /* Check for more bytes */
      if (bufferhead != buffertail) {
	//	dbg(DBG_USR1, "StdOut - putting \"%c\"\n", *bufferhead);
	call UART.put(*bufferhead);
	isOutputting = TRUE;
      } else {
	isOutputting = FALSE;
      }
    }
    return;
  }

  default async event void StdOut.get(uint8_t data) {
  }

  /* Handle getting data such that the user of this interface can get data. */
  async event void UART.get(uint8_t data) {
    signal StdOut.get(data);
    return;
  }
}
