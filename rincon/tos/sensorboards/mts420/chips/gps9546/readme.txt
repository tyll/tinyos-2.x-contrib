@author Danny Park

The Leadtek GPS-9546 is the gps chip on the MTS420CA/B sensorboards.
gps9546C provides a split control that starts/stops the communication
on the gps chip.  It appears* the power to the gps chip is always
connected, contrary to what the MTS420 users manual says about all
sensors being disconnected by default.

Note on porting to other platforms:
It is dependent upon an HplGps9546C.nc in the
tos/platforms/<platformname>/sensorboards/mts420/chips/gps9546
directory to provide the platform specific starting of of the UART
and wiring the SyncUartStream.
Be sure to set the baud rate to 4800 (NMEA specification) on the UART.

*All that is required is to use the adg715 to connect the UART TX/RX
lines and information will flow from the gps.