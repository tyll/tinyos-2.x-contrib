#!/usr/bin/python

import imaplib;
import pickle;
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
