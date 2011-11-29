#!/usr/bin/python
import sys, os, struct, array, time
try:
   import tos
except ImportError:
   import posix
   sys.path = [os.path.join(posix.environ['TOSROOT'], 'support', 'sdk', 'python')] + sys.path
   import tos


if len(sys.argv) < 2:
   print "no device specified"
   print "example:"
   print "   simpleAccelGyroRecv.py /dev/ttyUSB5"
else:
   try:
      ser = tos.Serial(sys.argv[1], 115200)
      am = tos.AM(ser)
   except:
      print "ERROR: Unable to initialize serial port connection to", sys.argv[1]
      sys.exit(-1)

   try:
      while True:
         packet = am.read(timeout=5)
         if packet:
            if len(packet.data) < 2:
               print "skipping truncated packet"
               pass
            elif len(packet.data) != 100:
               print packet.data
            else:
               count = int(packet.data[1]) + (int(packet.data[0]<<8))
            
               for i in range(2,86,14):
                  accelx = int(packet.data[i + 1] << 8) + int(packet.data[i])
                  accely = int(packet.data[i + 3] << 8) + int(packet.data[i + 2])
                  accelz = int(packet.data[i + 5] << 8) + int(packet.data[i + 4])
                  gyrox  = int(packet.data[i + 7] << 8) + int(packet.data[i + 6])
                  gyroy  = int(packet.data[i + 9] << 8) + int(packet.data[i + 8])
                  gyroz  = int(packet.data[i + 11] << 8) + int(packet.data[i + 10])
                  rawbatt  = int(packet.data[i + 13] << 8) + int(packet.data[i + 12])
                  batt = rawbatt / 4095.0 * 3.0 * 2.0
                  print "%d %d %d %d %d %d %d %d %5.3f" % (packet.source, count, accelx, accely, accelz, gyrox, gyroy, gyroz, batt)
                  sys.stdout.flush()
                  
   except KeyboardInterrupt:
      print "All done"
