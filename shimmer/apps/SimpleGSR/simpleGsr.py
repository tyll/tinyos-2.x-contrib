#!/usr/bin/python
#import serial
import sys, struct, array
from bluetooth import *

if len(sys.argv) < 2:
   print "no device specified"
   print "You need to specifiy the MAC address of the shimmer you wish to connect to"
   print "example:"
   print "  simpleGsr.py 00:06:66:42:24:18"
   print
else:
   port = 1;
   host = sys.argv[1]

   sock = BluetoothSocket( RFCOMM )
   sock.connect((host, port))

   ddata = ""
   numbytes = 0

   framesize = 80 

   num = 0
   
   try:
      while True:
         while numbytes < framesize:
            ddata += sock.recv(framesize)
            numbytes = len(ddata)

         data = ddata[0:framesize]
         ddata = ddata[framesize:]
         numbytes = len(ddata)

         for i in range(0,framesize,4):
            gsr = struct.unpack('I', data[i:i+4])
            print "%10d" % gsr,
            sys.stdout.flush()
            num += 1
            if num == 5:
               print
               num = 0
   except KeyboardInterrupt:
      sock.close()
      print
      print "All done"
