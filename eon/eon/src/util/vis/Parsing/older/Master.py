#!/usr/bin/python
import datetime;
import imaplib;
import MySQLdb;
import pickle;
import re;
import sys;logName = "eon.turtles.test"logPass = "turtlepower"resultSet = []count = 0
search = '(UNSEEN)'

#command-line arguments to change search criteria
try:
	if sys.argv[1] == 'new':
		search = '(UNSEEN)'
		print 'using: \'(UNSEEN)\''
	elif sys.argv[1] == 'old':
		search = '(SEEN)'
		print 'using: \'(SEEN)\''
	elif sys.argv[1] == 'all':
		search = '(ALL)'
		print 'using: ALL'
except:
	print 'using default: UNSEEN'

#Connects to GMail Imap Server, selects inbox
try:	conn = imaplib.IMAP4_SSL('imap.gmail.com',993)	conn.login(logName,logPass)	conn.select()except imaplib.IMAP4.error:	print 'Unable to connect.'	sys.exit(1)	
#Grabs all unread emails, puts them into the resultSet Dictionary 
try:	typ, data = conn.search(None, search)	for num in data[0].split():		#Grabs body, time and baseID
		tempTime = conn.fetch(num, '(BODY[HEADER.FIELDS (DATE)])')		tempBody = conn.fetch(num, '(BODY[TEXT])')
		baseID = conn.fetch(num, '(BODY[HEADER.FIELDS (SUBJECT)])')		resultSet.append({'body':tempBody[1][0][1], 'timeSent':tempTime[1][0][1].replace('-0400','').replace('\n','').replace('\r','').replace('Date:',''), 'baseID':baseID[1][0][1].split(',')[0]})
		conn.store(num,'+FLAGS','\\SEEN')#Marks the message as read	
	except imaplib.IMAP4.error:	print 'Unable to perform search/fetch operation.'	sys.exit(1)
#Dumps into a file
try:	dumpFile = open("dump.dat", "w")	pickle.dump(resultSet, dumpFile)	dumpFile.close()except IOError:	print "Error writing to file."	sys.exit(1)	#Close connections and files.
conn.close()conn.logout()

##
#Begin Parsing
##

temp = resultSet
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

	

##
#Begin Database Script
##

	mis_digit = []

try:

	db = MySQLdb.connect(host='diesel.cs.umass.edu', user='turtle', passwd='hardshell')

except MySQLdb.Error:
	print 'Unable to connect to database';
	sys.exit(1)

cursor = db.cursor()
cursor.execute("USE snapper_turtles;")

#statement to check for duplicates
check = "select * FROM %s WHERE datasrc = %s AND sequence = %s AND timest = %s;"

#checks for duplicate entries and put data into snapper_turtles database
def GPS_ins(pkt, pay):
	if cursor.execute(check % ('GPS',pkt['datasrc'],pkt['sequence'],pkt['timestamp'])) == 0:
		cursor.execute("INSERT INTO GPS(datasrc, sequence, timeinvalid, time_sent, timest, gpsvalid, ns, ew, toofewsats, sats, hdil, lat_d, lat_m, lat_dec, lon_d, lon_m, lon_dec, alt) VALUES (%s,%s,%s,%s,%s,%s,%s,%s,%s,%s,%s,%s,%s,%s,%s,%s,%s,%s)", (pkt['datasrc'], pkt['sequence'], pkt['timeinvalid'], pkt['time_sent'], pkt['timestamp'], pay['valid'], pay['ns'], pay['ew'], pay['toofewsats'], pay['sats'], pay['hdil'],pay['lat_d'], pay['lat_m'],pay['lat_dec'], pay['lon_d'], pay['lon_m'], pay['lon_dec'], pay['alt']))
	#else:
	#	print 'duplicate entry'

def RTSTATE_ins(pkt, pay):
	if cursor.execute(check % ('RT_STATE',pkt['datasrc'],pkt['sequence'],pkt['timestamp'])) == 0:
		cursor.execute("INSERT INTO RT_STATE(datasrc, sequence, timest, energy_in, energy_out, 			batt_volts, batt_energy_est, temperature, current_state, current_grade, email_time, timeinvalid) VALUES(%s, %s,%s, %s, %s, %s, %s, %s, %s, %s, %s,%s)",(pkt['datasrc'], pkt['sequence'], pkt['timestamp'], pay['energy_in'],pay['energy_out'], pay['batt_volts'], pay['batt_energy_est'], pay['current_state'],pay['current_grade'], pay['temperature'],pkt['time_sent'],pkt['timeinvalid']))
	#else:
	#	print 'duplicate entry'

def RTPATH_ins(pkt, pay):
	if cursor.execute(check % ('RT_PATH',pkt['datasrc'],pkt['sequence'],pkt['timestamp'])) == 0:
		cursor.execute("INSERT INTO RT_PATH(datasrc, sequence, timest, path_id, count, energy, 			probability, email_time, timeinvalid) VALUES (%s, %s, %s, %s, %s, %s, %s, %s,%s)", 
		(pkt['datasrc'],pkt['sequence'], pkt['timestamp'], pay['path_id'], pay['count'], pay['energy'], 
		pay['probability'],pkt['time_sent'],pkt['timeinvalid']))
	#else:
	#	print 'duplicate entry'

def CONN_ins(pkt, pay):
	if cursor.execute(check % ('CONN',pkt['datasrc'],pkt['sequence'],pkt['timestamp'])) == 0:
		cursor.execute("INSERT INTO CONN(datasrc, sequence, timest, address, duration, quality, 			email_time, timeinvalid) VALUES ( %s, %s, %s, %s, %s, %s, %s, %s)",(pkt['datasrc'], pkt['sequence'],pkt['timestamp'],pay['address'], pay['duration'], pay['quality'], pkt['time_sent'],pkt['timeinvalid']))
	#else:
	#	print 'duplicate entry'


#end of ins


#store all entries older than three weeks in final tables
def store_old():
	#statement for moving old entries
	move = 'insert into %s select * from %s where email_time < %;'

	#establish time window
	time = []
	types = ["GPS","GPSSECOND", "RTSTATE", "RTPATH", "CONN"]
	for each in types:
		cur.execute("select max(email_time) from " + each )
		time.append(cur.fetchone())

	too_old = max(time[0][0]) - datetime.timedelta(days = 21)

	past_due = [each for each in info if each['time_sent'] < too_old]
	
	#delete all entries in mis_digit that are out of range
	try:
		mis_digit = mis_digit.remove([each for each in mis_digit if each['time_sent'] < too_old])	
	except:
		print 'nothing doing'

	#send old entries into sql_insert
	for each in types:
		if each == "GPS":
			GPS_check('GPS')
		if each == "GPSSECOND":
			GPS_check('GPSSECOND')
		cursor.execute(move % (each+'_FINAL', each, 'CAST(\'' + str(too_old) + '\' AS DATETIME)'))	

def insert_list(info):
	for num in info:

		#extract payload and check for empties
		try:
			pay = num['payload']
		except:
			print num['pkttype']
			
			continue;
		
		if num['pkttype'] == 1:
			#print 'GPS1'
			GPS_ins(num, pay)
	
		elif num['pkttype'] == 4:
			#print 'RTSTATE'
			RTSTATE_ins(num, pay)
	
		elif num['pkttype'] == 5:
			#print 'RTPATH'
			RTPATH_ins(num, pay)

		elif num['pkttype'] == 6:
			#print 'CONN'
			CONN_ins(num, pay)


insert_list(pDat)
parsed_timed = []



		
