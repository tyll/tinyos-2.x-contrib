#!/usr/bin/python

import sys;
from serial import *;
from TOSPython import *;

s = Serial("/dev/ttyUSB0",
		57600,
		EIGHTBITS,
		PARITY_NONE,
		STOPBITS_ONE,
		None, 0, 0, None, None);

parser = TOSSerialParser();

s.open();

while True:
	b = s.read(1);
	try:
		parser.readByte(b);
	except TOSSerialReceptionError, e:
		print e;
	except TOSSerialPacket, packet:
		# Time
		print "Time: %02d:%02d:%02d" % (ord(packet.payload[0]), ord(packet.payload[1]), ord(packet.payload[2]));
		# Latitude
		if ord(packet.payload[3]) < 128:
			print "Latitude: %d deg %d.%04d N" % (ord(packet.payload[3]), ord(packet.payload[4]), ord(packet.payload[5]) * 256 + ord(packet.payload[6]));
		else:
			print "Latitude: %d deg %d.%04d S" % (256 - ord(packet.payload[3]), ord(packet.payload[4]), ord(packet.payload[5]) * 256 + ord(packet.payload[6]));
		# Longitude
		lg = ord(packet.payload[7]) * 256 + ord(packet.payload[8]);
		if lg < 32768:
			print "Latitude: %d deg %d.%04d E" % (lg, ord(packet.payload[9]), ord(packet.payload[10]) * 256 + ord(packet.payload[11]));
		else:
			print "Latitude: %d deg %d.%04d W" % (65536 - lg, ord(packet.payload[9]), ord(packet.payload[10]) * 256 + ord(packet.payload[11]));
		# Mode
		print "Mode: %d" % ord(packet.payload[12]);
		# Satellites
		print "%d satellites are seen" % ord(packet.payload[13]);
		# Altitude
		print "Altitude: %d" % (ord(packet.payload[14]) * 256 + ord(packet.payload[15]));
		
		print "";

s.close();
