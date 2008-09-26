#!/usr/bin/python


import sys
import os

seconds = int(sys.argv[1])
nodes = int(sys.argv[2])

os.chdir("tests");

def runtest(testname):
	os.chdir(testname);
	if (os.system("make pc > compile.log") != 0):
		print("COMPILE FAILED...see "+testname+"/compile.log");
		sys.exit(1);

	ts = seconds;
	tn = nodes;
	if (os.path.exists(".testconfig")):
		f = file(".testconfig","r");
		cfg = f.readlines();
		ts = int(cfg[0][:len(cfg[0])])
		tn = int(cfg[1][:len(cfg[1])])
	
			
	p = os.popen("build/pc/main.exe -t="+str(ts)+" "+ str(tn)+" | grep UNITTEST")

	lines = p.readlines();

	p.close();

	success = 0;
	fail = 0;

	for line in lines:
		lineNoN = line[:len(line)-1];
		if (lineNoN.find("SUCCESS") >= 0):
			 success = success+1;
		elif (lineNoN.find("FAILED") >= 0):
			print(lineNoN)
			fail = fail + 1
		else:
			print(lineNoN)
	

	print(testname +" Tests Finished! ("+str(ts)+"s, x"+str(tn)+")");
	if (success+fail > 0):
		print(str(success) + " out of " + str(success+fail) + "("+str(success*100.0/(success+fail))+"%) tests passed...");
	else:
		print("No tests finished")
	os.chdir("..");
	return (success, fail);
	
totals = 0;
totalf = 0;
totalt = 0;	
	
entries = os.listdir(".");
for e in entries:
	if os.path.isdir(e) and e.startswith("UnitTest"):
		s,f = runtest(e)
		totals = totals + s;
		totalf = totalf + f;
		
totalt = totals + totalf;

print("\n\nFinished Tests");
print(str(totals) + " out of " + str(totalt) + "("+str(totals*100.0/(totalt))+"%) tests passed...");