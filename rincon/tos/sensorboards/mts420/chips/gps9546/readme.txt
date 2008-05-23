@author Danny Park

The Leadtek GPS-9546 is the gps chip on the MTS420CA/B sensorboards.
gps9546C provides a split control that starts/stops the communication
on the gps chip.  It may* control the power to the gps chip, as well.

Note on porting to other platforms:
It is dependent upon an HplGps9546C.nc in the
tos/platforms/<platformname>/sensorboards/mts420/chips/gps9546
directory to provide the platform specific starting of of the UART
and wiring the SyncUartStream.
Be sure to set the baud rate to 4800 (NMEA specification) on the UART.

*I am unsure at this time if the power to the GPS is
always connected or if the GPS_ENA wire is actually powering the chip.