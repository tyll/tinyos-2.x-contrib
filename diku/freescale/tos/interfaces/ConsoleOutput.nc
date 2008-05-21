/*
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
 *
 * Console interface.
 *
 * <p>Interface that provides a primitive way to output chars, most
 * likely to one of the uarts. It is also possibly to use the get
 * event to get an event when chars are received from the uart.</p>
 *
 * <p>Important: This interface is _not_ a very good TinyOS citizen,
 * and is meant for debug only.</p>
 * 
 * @author Mads Bondo Dydensborg, <madsdyd@diku.dk>
 */

interface ConsoleOutput
{
  //async command void printLeds(uint8_t ledStatus);
  /** Put a string into the output buffer.
      @param str Nulterminated string to enter into the buffer.
      @return Number of bytes actually buffered. */
  command int print(const char * str);

  command int printStr(const char *str, uint16_t length);

  /** Format value as a hex string and put it into the output buffer.
      @param c Numberical value to be formatted and printed.
      @return Number of bytes actually buffered. */
  command int printHex(const uint8_t c);

  /** Format value as a hex string and put it into the output buffer.
      @param c Numberical value to be formatted and printed.
      @return Number of bytes actually buffered. */
  command int printHexword(const uint16_t c);

  /** Format value as a hex string and put it into the output buffer.
      @param c Numberical value to be formatted and printed.
      @return Number of bytes actually buffered. */
  command int printHexlong(const uint32_t c);

  /** Format value as a base10 string and put it into the output buffer.
      @param c Numberical value to be formatted and printed.
      @return Number of bytes actually buffered. */
  command int printBase10uint8(const uint8_t c);

  /** Format value as a base10 string and put it into the output buffer.
      @param c Numberical value to be formatted and printed.
      @return Number of bytes actually buffered. */
  command int printBase10int8(const int8_t c);

  /** Format value as a base10 string and put it into the output buffer.
      @param c Numberical value to be formatted and printed.
      @return Number of bytes actually buffered. */
  command int printBase10uint16(const uint16_t c);

  /** Format value as a base10 string and put it into the output buffer.
      @param c Numberical value to be formatted and printed.
      @return Number of bytes actually buffered. */
  command int printBase10int16(const int16_t c);

  /** Format value as a base10 string and put it into the output buffer.
      @param c Numberical value to be formatted and printed.
      @return Number of bytes actually buffered. */
  command int printBase10uint32(const uint32_t c);

  /** Format value as a base10 string and put it into the output buffer.
      @param c Numberical value to be formatted and printed.
      @return Number of bytes actually buffered. */
  command int printBase10int32(const int32_t c);

  /** Put an array of hex values into the buffer, formatted as a string.
      @param ptr[] Array of values to be formatted and printed.
      @param count Length of array.
      @param sep Char to be printed between values in the buffer.
      @return Number of bytes actually buffered. */
  command void dumpHex(const uint8_t ptr[], const uint8_t count, const char * sep);

}
