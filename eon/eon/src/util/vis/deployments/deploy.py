#!/usr/local/bin/python

import MySQLdb;
import os;
import re;
import sys;
import getopt;


remove_only = False
depset = False

opts, args = getopt.getopt(sys.argv[1:],"rd:")
for opt in opts:
	op, val = opt;
	if (op == "-r"):
		remove_only = True;
	if (op == "-d"):
		DEPID = val
		depset = True;

filename = args[0];

try:	
	con_file = open(filename , 'r')
except:
	print 'Failed to open ' + filename
	sys.exit(1)	

BASEID = [];
NODE = [];
day_start = '';
day_end = '';
hex = re.compile('[0-9A-F]{2}')

for each in con_file.readlines():
	if not each.startswith('#'):
		tokens= each.strip().split(":")
		if (len(tokens) >= 2):
			type = tokens[0]
			data = tokens[1]
			if type == 'DEPID':
				if not depset:
					DEPID = data;
					print 'deployment ' + DEPID
			if type == 'DATES':
				temp = data.split(',')
				day_start = temp[0]
				day_end = temp[1]
				print day_start, day_end
			if type == 'BASID':
				temp = data.split(' ')
				BASEID.append({'ID':temp[0], 'LON':temp[1], 'LAT':temp[2], 'day_start':temp[3], 'day_end':temp[4]})	
				print temp[0], temp[1], temp[2], temp[3], temp[4]
			if type == 'NODES':
				temp = data.split(',')
				NODE.append({'id':temp[0], 'progID':temp[1]})

db = MySQLdb.connect(host='diesel.cs.umass.edu', user='turtle', passwd='hardshell')
cursor = db.cursor()
cursor.execute("USE snapper_turtles;")

print "Removing any previous instance of this deployment...";
cursor.execute("DELETE from DEPLOYMENT where depID=\""+DEPID+"\"");

if (remove_only):
	sys.exit(0);

print "Installing new deployment..."
for each in NODE:
	cursor.execute("INSERT INTO DEPLOYMENT(depID, node, progID) VALUES(%s, %s, %s);",(DEPID, each['id'],each['progID']))

for each in BASEID:
	cursor.execute("INSERT INTO DEPLOYMENT(depID, baseID, NS, EW, start_date, end_date) VALUES(%s,%s,%s,%s,%s,%s)",(DEPID, each['ID'], each['LAT'], each['LON'],  each['day_start'],each['day_end']))

