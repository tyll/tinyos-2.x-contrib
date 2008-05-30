@author Danny Park

There is still plenty of work to be done with the NMEA drivers.  This code
was written without the assistance of the official specifications so there
may be errors.  The only packet type that can be partially parsed is the
GGA packet type.  Even that is not complete, though.

TODO:
-Finish the parsing code for the GGA packet
--Check everything
--add horizontal dilution of position, time in seconds since last DGPS update,
  and DGPS station ID number
--make gga packet platform independent (i.e. use nx_ types)
-Implement using the checksum to check data integrity
-Add more packet types to the parsing capabilities
-Test and refine what has been written