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
      for i in range(0,120,6):
         (accelx, accely, accelz) = struct.unpack('hhh', data[i:i+6])
         print "%4d %4d %4d" % (accelx, accely, accelz)

   ser.close()
