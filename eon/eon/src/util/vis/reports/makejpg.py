#!/usr/local/bin/python



import sys
import random
import os

if len(sys.argv) == 1:
	mdir="."
elif len(sys.argv) == 2:
	mdir=sys.argv[1]
else:
	print("You obviously don't know how to use this scripts...");
	print("Usage: makejpg.py <dir>");
	sys.exit(-1);
	
os.chdir(mdir);



def listdirext(thedir, root, ext):
	lst = os.listdir(thedir)
	res = []
	for l in lst:
		if l.endswith(ext) and l.startswith(root):
			res.append(l);
	return res;

def convertPDF(f):
	root = "tmpppm"+str(int(random.random()*10000))
	os.system("pdftoppm "+f+" "+root);
	#pick up the pieces
	ppms = listdirext(".",root,".ppm")
	for p in ppms:
		os.system("ppmtojpeg "+p+" > "+f+".jpg");
		os.system("rm "+p);
	if (os.path.exists(f+".txt")):
		os.system("cp "+f+".txt "+f+".jpg.txt");

dirs = listdirext(".","","")

for d in dirs:
	if (os.path.isdir(d)):
		listing= listdirext(d,"",".pdf")
		
		for f in listing:
			convertPDF(d+"/"+f);
