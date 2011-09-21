#!/usr/bin/python
import serial
import sys, struct, array

if len(sys.argv) < 2:
   print "no device specified"
   print "example:"
   print "  simpleAccel.py Com5"
   print "or"
   print "  simpleAccel.py /dev/rfcomm0"
else:
   ser = serial.Serial(sys.argv[1], 115200)
   ser.flushInput();

   while True:
      data = ser.read(120);
      for i in range(0,120,8):
         (accelx, accely, accelz, rawbatt) = struct.unpack('hhhh', data[i:i+8])
         batt = rawbatt / 4095.0 * 3.0 * 2.0
         print "%4d %4d %4d %5.2f" % (accelx, accely, accelz, batt)

   ser.close()
