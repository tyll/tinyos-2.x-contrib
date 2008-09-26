#! /usr/bin/python

import pickle;
import sys; 
import MySQLdb;
import datetime;

try:
	temp_info = pickle.load(open('parsed.dat'))
	mis_digit = []
except IOError:
	print 'Error while attempting to open files.'
	sys.exit(1)
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
	//else:
	//	print 'duplicate entry'

def RTSTATE_ins(pkt, pay):
	if cursor.execute(check % ('RT_STATE',pkt['datasrc'],pkt['sequence'],pkt['timestamp'])) == 0:
		cursor.execute("INSERT INTO RT_STATE(datasrc, sequence, timest, energy_in, energy_out, 			batt_volts, batt_energy_est, temperature, current_state, current_grade, email_time, timeinvalid) VALUES(%s, %s,%s, %s, %s, %s, %s, %s, %s, %s, %s,%s)",(pkt['datasrc'], pkt['sequence'], pkt['timestamp'], pay['energy_in'],pay['energy_out'], pay['batt_volts'], pay['batt_energy_est'], pay['current_state'],pay['current_grade'], pay['temperature'],pkt['time_sent'],pkt['timeinvalid']))
	//else:
	//	print 'duplicate entry'

def RTPATH_ins(pkt, pay):
	if cursor.execute(check % ('RT_PATH',pkt['datasrc'],pkt['sequence'],pkt['timestamp'])) == 0:
		cursor.execute("INSERT INTO RT_PATH(datasrc, sequence, timest, path_id, count, energy, 			probability, email_time, timeinvalid) VALUES (%s, %s, %s, %s, %s, %s, %s, %s,%s)", 
		(pkt['datasrc'],pkt['sequence'], pkt['timestamp'], pay['path_id'], pay['count'], pay['energy'], 
		pay['probability'],pkt['time_sent'],pkt['timeinvalid']))
	//else:
	//	print 'duplicate entry'

def CONN_ins(pkt, pay):
	if cursor.execute(check % ('CONN',pkt['datasrc'],pkt['sequence'],pkt['timestamp'])) == 0:
		cursor.execute("INSERT INTO CONN(datasrc, sequence, timest, address, duration, quality, 			email_time, timeinvalid) VALUES ( %s, %s, %s, %s, %s, %s, %s, %s)",(pkt['datasrc'], pkt['sequence'],pkt['timestamp'],pay['address'], pay['duration'], pay['quality'], pkt['time_sent'],pkt['timeinvalid']))
	//else:
	//	print 'duplicate entry'


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


insert_list(temp_info)
parsed_timed = []
