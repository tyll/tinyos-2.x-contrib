#!/usr/bin/python
import sys
from bluetooth import *

server_sock=BluetoothSocket( RFCOMM )
server_sock.bind(("",PORT_ANY))
server_sock.listen(1)

port = server_sock.getsockname()[1]

uuid = "40196243-9a06-416a-8988-706d503bc971"

advertise_service( server_sock, "SimpleMasterServer",
                   service_id = uuid,
                   service_classes = [ uuid, SERIAL_PORT_CLASS ],
                   profiles = [ SERIAL_PORT_PROFILE ],
                    )
                   
try:
   while True:
      print "Waiting for connection on RFCOMM channel %d (Ctrl-C to quit)" % port
      client_sock, client_info = server_sock.accept()
      print "Accepted connection from ", client_info

      ddata = ""
      numbytes = 0

      framesize = 14

      try:
         while True:
            while numbytes < framesize:
               ddata += client_sock.recv(framesize)
               numbytes = len(ddata)
            
            data = ddata[0:framesize]
            ddata = ddata[framesize:]
            numbytes = len(ddata)

            sys.stdout.write(data)
            sys.stdout.flush()
      except IOError:
         pass

      print "disconnected"
      client_sock.close()
except KeyboardInterrupt:
   server_sock.close()
   print
   print "All done"
