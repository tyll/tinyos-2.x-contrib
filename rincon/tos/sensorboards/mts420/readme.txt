@author Danny Park

The implementation of a complete sensorboard suite for the MTS420 is
sparse.  Currently it only includes a partially functional GPS driver
for the MTS420CA sensorboard running on the MICAz mote.

File dependencies: see the .sensor file found in this directory for
a list of dependencies.

More complete documentation can be found on the TinyOS wiki
(http://docs.tinyos.net/)

Organization of Code:
-Platform independent code is located in the tos/chips and tos/lib folders.
-Platform dependent code is located in
  tos/platform/<specific platform>/sensorboards/mts420 directory
-Platform independent but sensorboard dependent code is located in this
  directory

Components of note:
(see also: folders and files listed for more documentation)

tos/lib/Nmea contains the code that receives and translates the Nmea packets.

tos/lib/SyncUartStream contains the code that converts the async UartStream
into synchronous code for ease of coding and debugging.

tos/sensorboards/mts420/chips/gps9546 contains the code that connects the
UART to the gps and provides a SyncUartStream to retrieve bytes from.

tos/sensorboards/mts420/NmeaRawReceive{C|P}.nc group the bytes into raw
NMEA packets.

adg715 is an octal switch controlled by an I2C bus that controls the power
and communication of the sensors on the MTS420 (there are 2 switches).