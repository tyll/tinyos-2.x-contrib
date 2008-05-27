
This is the Intel JFlashmm tool configured for the Imote2
=========================================================

What does this do?
1. Program any file or OS to the Imote2's FLASH memory
2. Restore the Imote2's TinyOS boot loader

Note:
JFlashmm is substantially slower than "xflash" but Intel
made it freely available (see included licence agreement).

What do you need?
1. An Imote2 (e.g., Crossbow IPR2400)
2. An Imote2 interface/debug baord (e.g., Crossbow IIB2400)
3. An "Intel JTAG(R) Cable"
   Note: It may also work with other JTAG devices, see doc
4. This software distribution

How do I restore a damaged Imote2 TinyOS boot loader?
1. Run the included "restore-bootloader.bat" script
2. Be patient!

How do I program the Imote2's FLASH with my own file?
1. Run "JFlashmm.exe bulbcx16 myfile.bin P 0x0"
   Note: The hex number at the end is the loading address

Note:
You can also use JFlashmm to program Linux and other OSes
into the Imote2.


