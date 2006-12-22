The internal memory on the avr is an EEPROM, meaning you can write 
over the top of addresses that have already been written.  The memory
is erased every time you install a new application on the mote in the 
internal flash.

If you are strictly implementing software for the avr, then you don't have
to erase segments before writing them.  Erase, in this case, will simply write
out 0xFF fill bytes to the choosen segment.  The erase function is useful
to maintain application compatibility across platforms.

Flush is not implemented either, but it is on other platforms.  If the avr
is the only platform you plan on running your application on, then there
is no need to call flush().  Otherwise, calling flush() after you have
written data will support cross-platform compatibility.

This DirectStorage interface uses the pre-defined EEPROM functions 
provided in /usr/avr/includes/avr.  This will work on many other AVR
platforms besides just the ATmega128.

@author David Moss

