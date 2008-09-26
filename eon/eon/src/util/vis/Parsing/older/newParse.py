#!/usr/bin/python


import datetime;
import pickle;
import re;
import sys;

try:
	temp = pickle.load(open('dump.dat'))#created in emailGrab
	parsed = open("parsed.dat", "w")
except IOError:
	print 'Error opening one or more files.'
	sys.exit(1);

line = ''
count = 0
hex = re.compile('[0-9A-F]{2}')


#Packet-specific parsers
def parsegps1(c):
  p = {};
  #p['type'] = 'gps1';
  p['valid'] = c[0] >> 7;
  p['ns'] = c[0] & 0x01;
  p['ew'] = (c[0] >> 1) & 0x01;
  p['toofewsats'] = c[1] >> 7;
  p['sats'] = c[1] & 0x7f;
  p['hdil'] = c[2];
  p['lat_d'] = c[3] + (c[4] << 8)
  p['lat_m'] = (c[5] + (c[6] << 8) + (c[7] << 16) + (c[8] << 24)) * 1.0 / 10000.0
  p['lat_dec'] = p['lat_d'] + (p['lat_m'] / 60.0);
  p['lon_d'] = c[9] + (c[10] << 8)
  p['lon_m'] = (c[11] + (c[12] << 8) + (c[13] << 16) + (c[14] << 24)) * 1.0 / 10000.0
  p['lon_dec'] = p['lon_d'] + (p['lon_m'] / 60.0);
  p['alt'] = c[15] + (c[16] << 8);
  return p;

def parsertstate(c):
	p = {};
	#p['type'] = "runtime state";
	p['energy_in'] = c[0] + (c[1] << 8) + (c[2] << 16) + (c[3] << 24)
	p['energy_out'] = c[4] + (c[5] << 8) + (c[6] << 16) + (c[7] << 24)
	p['batt_volts'] =( c[8] + (c[9] << 8) ) * 1.0 / 1000.0;
	p['batt_energy_est'] = c[10] + (c[11] << 8) + (c[12] << 16) + (c[13] << 24)
	p['current_state'] = c[14];
	p['current_grade'] = c[15];
	p['temperature'] = c[16] + (c[17] << 8);
	return p;

def parsertpath(c):
	p={};
	#p['type'] = "runtime path"
	p['path_id'] = c[0] + (c[1] << 8)
	p['count'] = c[2] + (c[3] << 8)
	p['energy'] = c[4] + (c[5] << 8) + (c[6] << 16) + (c[7] << 24)
	p['probability'] = c[8] * 1.0 / 100.0;
	p['source_probability'] = c[9] * 1.0 / 100.0;
	
	return p;

def parseconn(c):
	p={}
	#p['type'] = 'connection event'
	p['address'] = c[0] + (c[1] << 8);
	p['duration'] = c[2] + (c[3] << 8);
	p['quality'] = c[4];
	return p;


#end of packet-specific parsers

packet_types = {1:'gps1',2:'gps2',4:'runtime state',5:'runtime path',6:'connection event'};


def parsepacket(pkt, timeSent):

	bytes = pkt	
	
	thepkt = {};
	thepkt['datasrc'] = bytes[0];
	thepkt['sequence'] = bytes[2] + (bytes[3] << 8);
	thepkt['pkttype'] = bytes[1] & 0x7f;
	thepkt['timeinvalid'] = bytes[1] >> 7 
	thepkt['type'] = packet_types[thepkt['pkttype']];
	thepkt['time_sent'] = timeSent;#email time
	thepkt['timestamp']=bytes[4]+(bytes[5]<<8)+(bytes[6]<<16)+(bytes[7]<<24)
	tempByte = bytes[8:]
	#additional parsing
	if thepkt['pkttype'] == 1: #gps first half
		thepkt['payload'] = parsegps1(bytes[8:]);
		
	if (thepkt['pkttype'] == 2 and len(tempByte) == 12): #gps second half
		thepkt['payload'] = parsegps2(bytes[8:]);
			
	if thepkt['pkttype'] == 4: #rtstate
		thepkt['payload'] = parsertstate(bytes[8:]);
		
		
	if (thepkt['pkttype'] == 5 and len(tempByte) == 10): #rtpath
		thepkt['payload'] = parsertpath(bytes[8:]);
		
	if (thepkt['pkttype'] == 6 and len(tempByte) == 5): #connection
		thepkt['payload'] = parseconn(bytes[8:]);
	
	
	return thepkt;

def date_format(time):
	#replace month with apropriate value
	time = time.split(' ')
	if time[3] == 'Jan':
		time[3] = '01'
		print 'worked Jan'
	if time[3] == 'Feb':
		time[3] = '02'
		print 'worked Feb'
	if time[3] == 'Mar':
		time[3] = '03' 
		print 'worked Mar'
	if time[3] == 'Apr':
		time[3] = '04'
		print 'worked Apr'
	if time[3] == 'May':
		time[3] = '05'
		print 'worked May'
	if time[3] == 'Jun':
		time[3] = '06'
		print 'worked Jun'
	if time[3] == 'Jul':
		time[3] = '07'
		print 'worked Jul'
	if time[3] == 'Aug':
		time[3] = '08'
		print 'worked Aug'
	if time[3] == 'Sep':
		time[3] = '08'
		print 'worked Sep'
	if time[3] == 'Oct':
		time[3] = '10'
		print 'worked Oct'
	if time[3] == 'Nov':
		time[3] = '11'
		print 'worked Nov'
	if time[3] == 'Dec':
		time[3] = '12'
		print 'worked Dec'

	#put date into apropriate format for MySQL 'DATETIME'
	return time[4] + '-' + time[3] + '-' + time[2] + ' ' + time[5]

pDat = []
for num in temp:
	for num2 in num['body'].split('\n'):#breaks up individual lines
		write = 1
		tempChar = ''

		for num3 in num2.split(','): #breaks into ind. value
			if len(num3)==2 and hex.match(num3): #ensures there is a two digit hex value
				try:
					tempChar += chr(int(num3,16))#converts from hex to ascii char
					write = 0
				except TypeError:
					print 'Error while attempting to translate.'

			elif len(num3)!= 2 or not hex.match(num3):#skip the entire line if part of its no good
				break
		
		if write == 0 and len(tempChar)>=6: #only parses a full line
			line = tempChar; 
			write = 1;

			print ("Count", count)
			
			count +=1
			binline = []
			for c in line:
				binline.append(ord(c))

			pDat.append(parsepacket(binline, date_format(num['timeSent'])));

	

try:	pickle.dump(pDat, parsed)	parsed.close()except IOError:
	print 'Error writing to file'
	sys.exit(1)



		
