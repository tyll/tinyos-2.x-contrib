#!/usr/bin/python
import sys, struct
from bluetooth import *

server_sock=BluetoothSocket( RFCOMM )
server_sock.bind(("",PORT_ANY))
server_sock.listen(1)

port = server_sock.getsockname()[1]

uuid = "85b98cdc-9f43-4f88-92cd-0c3fcf631d1d"
advertise_service( server_sock, "BluetoothMasterServer",
                   service_id = uuid,
                   service_classes = [ uuid, SERIAL_PORT_CLASS ],
                   profiles = [ SERIAL_PORT_PROFILE ],
                    )
                   
try:
   while True:
      print "Waiting for connection on RFCOMM channel %d (Ctrl-C to quit)" % port
      client_sock, client_info = server_sock.accept()
      print "Accepted connection from ", client_info
      print "Seq No || accelX | accelY | accelZ | gyroX | gyroY | gyroZ"

      ddata = ""
      numbytes = 0
      framesize = 22

      try:
         while True:
            while numbytes < framesize:
               ddata += client_sock.recv(framesize)
               numbytes = len(ddata)

            data = ddata[0:framesize]
            ddata = ddata[framesize:]
            numbytes = len(ddata)

            (bof, sensorId, dataType, seqNo, timeStamp, length) = struct.unpack('BBBBHB', data[0:7])
            # need to split like this due to byte allignment
            (accelX, accelY, accelZ, gyroX, gyroY, gyroZ, crc,eof) = struct.unpack('HHHHHHHB', data[7:22])
#               print "%02x %02x %02x %02x %04x %02x %04x %04x %04x %04x %04x %04x %04x %02x" % (bof, sensorId, dataType, seqNo, timeStamp, length, accelX, accelY, accelZ, gyroX, gyroY, gyroZ, crc, eof)
            print "  %03d  ||  %04d  |  %04d  |  %04d  |  %04d |  %04d |  %04d" % (seqNo, accelX, accelY, accelZ, gyroX, gyroY, gyroZ)

      except IOError:
         pass

      print "disconnected"
      client_sock.close()
except KeyboardInterrupt:
   server_sock.close()
   print
   print "All done"
