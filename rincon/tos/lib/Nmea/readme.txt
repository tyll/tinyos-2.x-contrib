@author Danny Park

There is still plenty of work to be done with the NMEA drivers.  This code
was written without the assistance of the official specifications so there
may be errors.  The only packet type that can be partially parsed is the
GGA packet type.  Even that is not complete, though.

TODO:
-Finish the parsing code for the GGA packet
-Implement using the checksum to check data integrity
-Add more packet parsing capabilities
-Test and refine what has been written