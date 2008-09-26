#!/usr/bin/python
import sys;
import random;
fname = sys.argv[1];
outfname = sys.argv[2];

#varname = sys.argv[3].upper();
#offset = int(sys.argv[4]);


print (fname,outfname)

f = file(fname);
fout = file(outfname,"w");
index= 0;
valid = False;
nexttime = 0;
count = 0;
random.seed();
typedefs = ['video', 'audio', 'image', 'text', '*']

for line in f:	
	#tokens = line.split(',');
	try:
		#format:  time: source : tydefs
		var = ""
		rand_var = random.randrange(0, 5, 1)
		
		fout.write(str(count+.5) + ":" + str(7) + ":" + str(typedefs[rand_var]) + "\n")
	except:
		print "write failed"
	count = count + 1;

print (count,"lines");
f.close();
fout.close();

