#!/usr/bin/python


import os;
import sys;
import socket;



if (len(sys.argv) != 3):
	print("Usage : "+sys.argv[0] + " <infile> <outfile>");
	sys.exit(1);

ifile = file(sys.argv[1],"r");
ofile = file(sys.argv[2],"w");

rawdata = ifile.readlines();

bundles = [];


def parsedataline(line):
	toks = line.split(' ');
	chrs = [];
	for t in toks:
		if (len(t) > 1):
			#print("t="+str(t)+":"+str(len(t)))
			chrs.append(int(t,16));
	
	return chrs[9:]

# def parsechars(line):
# 	toks = line.split(' ');
# 	chrs = [];
# 	for t in toks:
# 		if (len(t) > 1):
# 			#print("t="+str(t)+":"+str(len(t)))
# 			chrs.append(int(t,16));
# 	return (toks,chrs)
# 	
		
# def parsepkt(tokens,chrs):
# 	#print "chrs[5] = "+str(chrs[5])
# 	internal = (chrs[5] != 1)
# 	page = int(tokens[9]+tokens[8]+tokens[7]+tokens[6],16)
# 	offset = int((tokens[11]+tokens[10]),16)
# 	data = chrs[12:];
# 	return (internal, page, offset, data)
# 
# def parsechunks(outfile, page):
# 	idx = 0;
# 	ccount = 0;
# 	
# 	while (True):
# 		#read the header
# 		data = page["data"];
# 		if ((data[idx] == 0xff) and (data[idx+1] == 0xff) and (data[idx+2] == 0xff)):
# 			#page is done
# 			outfile.write("\n");
# 			return
# 		chsize = ((data[idx+1]) << 8) | data[idx]
# 		print("chsize="+str(chsize))
# 		if (chsize > 255):
# 			outfile.write("\n");
# 			return
# 		#print out the chunk
# 		outfile.write("chunk:("+str(chsize)+" bytes):\n");
# 		ccount = 0;
# 		for i in range(chsize):
# 			print(data[idx+3+i]);
# 			outfile.write(hex(data[idx+3+i]).upper()[2:].zfill(2));
# 			ccount = ccount+1;
# 			if (ccount > 11):
# 				outfile.write("\n");
# 				ccount = 0;
# 			else:
# 				outfile.write(" ");
# 		outfile.write("\n\n");
# 		idx = idx + 3 + chsize;
# 		

def getint32(arr, off):
	val = ((((((long(arr[off+3]) << 8) + arr[off+2]) << 8) + arr[off+1]) << 8) + arr[off]);
	return val;
	
def getsint32(arr, off):
	val = ((((((int(arr[off+3]) << 8) + arr[off+2]) << 8) + arr[off+1]) << 8) + arr[off]);
	return val;

def getint16(arr, off):
	val = (arr[off+1] << 8) + arr[off];
	return val;


def parsertbundle(bundle):
	outstr = ""
	
	#Singleton data
	solar = getint32(bundle[0],0);
	outstr = outstr + "<energyin>"+str(solar)+"</energyin>\n"
	cons = getint32(bundle[0],4);
	outstr = outstr + "<energyout>"+str(cons)+"</energyout>\n"
	volts = getint16(bundle[0],8);
	outstr = outstr + "<volts>"+str(volts / 1000.0)+"</volts>\n"
	reserve = getint32(bundle[0],10);
	outstr = outstr + "<reserve>"+str(reserve)+"</reserve>\n"
	temp = getint16(bundle[0],14);
	outstr = outstr + "<temp>"+str(temp / 10.0)+"</temp>\n"
	outstr = outstr + "<state>"+str(bundle[0][16])+"</state>\n"
	
	#save grade for later
	grade = getint32(bundle[0],17);
	outstr = outstr + "<grade>"+str(grade)+"</grade>\n"
	
	
	#Path Costs
	b_idx=1;
	o_idx = 0;
	path=0;
	done = False;
	while not done:
		if ((o_idx +4) <= len(bundle[b_idx])):
			cost = getsint32(bundle[b_idx], o_idx);
			o_idx = o_idx + 4;
			outstr = outstr + "<pathcost num=\""+str(path)+"\">"+str(cost)+"</pathcost>\n"
		else:
			o_idx = 0;
			if (len(bundle[b_idx]) != 24):
				done = True;
			b_idx = b_idx + 1;
		path = path+1

	#Src Probs
	o_idx = 0;
	src=0;
	done = False;
	while not done:
		if (o_idx < len(bundle[b_idx])):
			prob = bundle[b_idx][o_idx];
			o_idx = o_idx + 1;
			outstr = outstr + "<srcprob src=\""+str(src)+"\">"+str(prob)+"</srcprob>\n"
		else:
			o_idx = 0;
			if (len(bundle[b_idx]) != 24):
				done = True;
			b_idx = b_idx + 1;
		src = src+1
		
	#Path Probs
	o_idx = 0;
	path=0;
	done = False;
	while not done:
		if (o_idx < len(bundle[b_idx])):
			prob = bundle[b_idx][o_idx];
			o_idx = o_idx + 1;
			outstr = outstr + "<pathprob path=\""+str(path)+"\">"+str(prob)+"</pathprob>\n"
		else:
			o_idx = 0;
			if (len(bundle[b_idx]) != 24):
				done = True;
			b_idx = b_idx + 1;
		path = path+1
				
	#How many lines are left
	linesleft = len(bundle) - b_idx;
	if (linesleft % 2 != 0):
		#AAAAG!
		print ("ERROR: The number of lines left ("+str(linesleft)+") is odd");
		
	else:
		scanlines = linesleft/2;
		print(scanlines,b_idx);
		o_idx = 0;
		path=0;
		done = False;
		while not done:
			if (o_idx < len(bundle[b_idx])):
				turtle = bundle[b_idx][o_idx];
				print(b_idx,scanlines,o_idx)
				meetings = bundle[b_idx+scanlines][o_idx];
				
				o_idx = o_idx + 1;
				outstr = outstr + "<connections turtle=\""+str(turtle)+"\" meetings=\"" +str(meetings)+"\"/>\n"
			else:
				o_idx = 0;
				print(b_idx,len(bundle)-scanlines);
				if (b_idx >= (len(bundle)-scanlines-1)):
					done = True;
				b_idx = b_idx + 1;
			path = path+1
			
	return outstr;
	
def parsegpsbundle(bundle):
	outstr = ""
	rawtext = "";
	for c in bundle[0]:
		rawtext = rawtext + chr(c);
	#outstr = outstr + "<raw>"+rawtext+"</raw>\n";
	#outstr = outstr + "<raw>"+str(bundle[1])+"</raw>\n";
	
	date = ""
	for c in bundle[0][0:11]:
		if (c > 0):
			date = date + chr(c)
	outstr = outstr + "<date>"+date+"</date>\n"
	time = ""
	for c in bundle[0][11:]:
		if (c > 0):
			time = time + chr(c)
	outstr = outstr + "<time>"+time+"</time>\n"
	
	#now get the location information
	outstr = outstr + "<valid>"+str(bundle[1][0])+"</valid>\n"
	outstr = outstr + "<hr>"+str(bundle[1][1])+"</hr>\n"
	outstr = outstr + "<min>"+str(bundle[1][2])+"</min>\n"
	
	seconds = ((((((bundle[1][6] << 8) + bundle[1][5]) << 8) + bundle[1][4]) << 8) + bundle[1][3]) ;
	outstr = outstr + "<sec>"+str(seconds)+"</sec>\n"
	latdeg = (bundle[1][8] << 8) + bundle[1][7];
	outstr = outstr + "<latdeg>"+str(latdeg)+"</latdeg>\n"
	latmin = ((((((bundle[1][12] << 8) + bundle[1][11]) << 8) + bundle[1][10]) << 8) + bundle[1][9]) ;
	outstr = outstr + "<latmin>"+str(latmin)+"</latmin>\n"
	outstr = outstr + "<latdec>"+str(((latmin * 1.0)/600000.0) + latdeg)+"</latdec>\n"
	outstr = outstr + "<ns>"+chr(bundle[1][13])+"</ns>\n"
	v=""
	longdeg = (bundle[1][15] << 8) + bundle[1][14];
	outstr = outstr + "<longdeg>"+str(longdeg)+"</longdeg>\n"
	longmin = ((((((bundle[1][19] << 8) + bundle[1][18]) << 8) + bundle[1][17]) << 8) + bundle[1][16]) ;
	outstr = outstr + "<longmin>"+str(longmin)+"</longmin>\n"
	outstr = outstr + "<latdec>"+str(((longmin * 1.0)/600000.0) + longdeg)+"</latdec>\n"
	outstr = outstr + "<ew>"+chr(bundle[1][20])+"</ew>\n"
	outstr = outstr + "<sats>"+str(bundle[1][21])+"</sats>\n"
	outstr = outstr + "<hdilution>"+str(bundle[1][22])+"</hdilution>\n"
	alt = (bundle[1][24] << 8) + bundle[1][23];
	outstr = outstr + "<alt>"+str(alt)+"</alt>\n"
	
	return outstr;

def parsebundle(bundle):
	if (len(bundle) == 2):
		return parsegpsbundle(bundle);
	else:
		return parsertbundle(bundle);


currentbundle = []	

for line in rawdata:

	

	if line.startswith("01"):
		currentbundle.append(parsedataline(line));
	else:
		if (len(currentbundle) > 0):
			currentbundle.reverse();
			bundles.append(currentbundle);
		currentbundle = [];
		
	print "bundles..."
	
for b in bundles:
	#print("Page: " + str(p["page"])+"\n");
	ofile.write("<bundle>\n ");
	ofile.write(parsebundle(b));
	ofile.write("<bundle\>\n\n");
	
ofile.close();