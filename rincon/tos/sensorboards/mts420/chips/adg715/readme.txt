@author Danny Park

There are two Analog ADG715 chips on the MTS420 sensorboard.  One
controls connecting wires to VCC (adg715Power) and the other mainly
deals with connecting wires for communication (adg715Comm).  For
specific descriptions of what each channel connects see the comments
in the specific *C.nc files in this folder or the MTS420 Users
Manual.

Note on porting sensorboard to other platforms:
For adg715CommC.nc and adg715PowerC.nc to function properly they
need an HplAdge715C.nc found in the
tos/platforms/<platformname>/sensorboards/mts420/chips/adg715/
directory.  This file must provide 8 Channel interfaces and wire
the dependencies of tos/chips/adg715 (namely the I2CPacket and
Resource interfaces).  See the implementation for micaz in this
directory structure for an example.