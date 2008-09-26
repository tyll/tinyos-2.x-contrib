#!/usr/bin/python


import os;
import sys;
import socket;

data = sys.stdin.readlines();
of = file("outlog","w")
df = file("slog","w")
gpsf = file("glog","w")
tf = file("tracelog","w")

lcount = 0
last_energy = 0;

pages = [];
pg = {}
firstpg = True;

def parsechars(line):
	toks = line.split(' ');
	chrs = [];
	for t in toks:
		if (len(t) > 1):
			#print("t="+str(t)+":"+str(len(t)))
			chrs.append(int(t,16));
	return (toks,chrs)
	
		
def parsepkt(tokens,chrs):
	#print "chrs[5] = "+str(chrs[5])
	internal = (chrs[6] != 1)
	page = int(tokens[10]+tokens[9]+tokens[8]+tokens[7],16)
	offset = int((tokens[12]+tokens[11]),16)
	data = chrs[13:];
	return (internal, page, offset, data)

def parsegps1(c):
	day = c[0];
	mon = c[1];
	yr = c[2];
	valid = c[3]
	hr = c[4];
	minu = c[5];
	sats = c[6];
	hdil = c[7];
	ns = c[8];
	ew = c[9];
	alt = c[10] + (c[11] << 8);
	of.write(str((day,mon,yr,valid,hr,minu,sats, hdil, ns, ew, alt)));
	return;

def parsegps2(c):
	lat_d = c[0] + (c[1] << 8)
	lat_m = c[2] + (c[3] << 8) + (c[4] << 16) + (c[5] << 24)
	lon_d = c[6] + (c[7] << 8)
	lon_m = c[8] + (c[9] << 8) + (c[10] << 16) + (c[11] << 24)
	of.write(str((lat_d, lat_m, lon_d, lon_m)));
	
	lat = lat_d + (lat_m * 1.0 / 600000)
	lon = lon_d + (lon_m * 1.0 / 600000)
	
	gpsf.write("1,1,"+str(lat)+",-"+str(lon)+",red\n");
	return;

def parsetempwet(c):
	return;

def parsertstate(c):
	ein = c[0] + (c[1] << 8) + (c[2] << 16) + (c[3] << 24)
	eout = c[4] + (c[5] << 8) + (c[6] << 16) + (c[7] << 24)
	volts = c[8] + (c[9] << 8)
	res = c[10] + (c[11] << 8) + (c[12] << 16) + (c[13] << 24)
	cst = c[14];
	cgrade = c[15];
	of.write(str((ein,eout,volts,res,cst,cgrade)));
	df.write(str(ein)+","+str(eout)+","+str(volts)+","+str(res)+","+str(cst)+","+str(cgrade)+"\n");
	return;

def parsertpath(c):
	pid = c[0] + (c[1] << 8)
	cnt = c[2] + (c[3] << 8)
	cost = c[4] + (c[5] << 8) + (c[6] << 16) + (c[7] << 24)
	prb = c[8];
	sprb = c[9];
	
	of.write(str((pid,cnt,cost,prb,sprb)));
	return;

def parseconn(c):
	return;

		
def parsechunks(outfile, page):
	global lcount
	global last_energy
	idx = 0;
	ccount = 0;
	
	while (True):
		#read the header
		data = page["data"];
		if (idx >= 252):
			outfile.write("\n");
			return
		if ((data[idx] == 0xff)):
			#page is done
			outfile.write("\n");
			return
		chsize = data[idx];
		print("chsize="+str(chsize))
		if (chsize > 45):
			outfile.write("Chunk too big "+str(chsize)+" bytes\n");
			return
		#print out the chunk
		outfile.write("chunk:("+str(chsize)+" bytes):\n");
		thechunk = []
		ccount = 0;
		for i in range(chsize):
			print(data[idx+1+i]);
			outfile.write(hex(data[idx+1+i]).upper()[2:].zfill(2));
			thechunk.append(data[idx+1+i]);
			ccount = ccount+1;
			if (ccount > 11):
				outfile.write("\n");
				ccount = 0;
			else:
				outfile.write(" ");
		outfile.write("\n\n");
		idx = idx + 1 + chsize;
		
		if (len(thechunk) < 6):
			print("chunk too short");
			return;
			
		srcaddr = thechunk[0];
		seqnum = (thechunk[2] << 8) + thechunk[1];
		chunktype = thechunk[3];
		bitvec = (thechunk[5] << 8) + thechunk[4];
		
		of.write(str(srcaddr)+" :#"+str(seqnum)+" :T("+str(chunktype)+"),B("+str(bitvec)+"):");
		
		#additional parsing
		if (chunktype == 1): #gps first half
			parsegps1(thechunk[6:]);
			of.write("--gps1\n");
			
		if (chunktype == 2): #gps second half
			parsegps2(thechunk[6:]);
			of.write("--gps2\n");
			
		if (chunktype == 3): #tempwet
			of.write("--temp-wet\n");
			parsetempwet(thechunk[6:]);
			
		if (chunktype == 4): #rtstate
			parsertstate(thechunk[6:]);
			of.write("--rtstate\n");
			
		if (chunktype == 5): #rtpath
			parsertpath(thechunk[6:]);
			of.write("--rtpath\n");
			
		if (chunktype == 6): #connection
			parseconn(thechunk[6:]);
			of.write("--connection\n");
			
for line in data:
	#get the values
	#7e 00 01 7d 0f 01 6e 02 00 00 90 00 ff ff ff 1b 00 00 6e 02 
	tokens, chrs = parsechars(line);
	intrnl, pagenum, off, data = parsepkt(tokens,chrs);
	#print ("pkt",intrnl, pagenum, off, data);
	
	if (not intrnl  and off == 0):
	
		if not firstpg:
			pages.append(pg);
		else:
			firstpg = False;
		pg = {};
		pg["page"] = pagenum;
		pg["data"] = data;
	else:
		if not intrnl:
		
			pg["data"] = pg["data"] + data;
			
		
print "pages..."
	
lcount = 0;
for p in pages:
	#print("Page: " + str(p["page"])+"\n");
	of.write("Page: " + str(p)+"\n");
	parsechunks(of, p)
	
of.close();
df.close();
gpsf.close();
tf.close();