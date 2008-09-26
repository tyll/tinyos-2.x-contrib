#!/usr/bin/python

import os;
import sys;

from xml.dom.minidom import parse;


if (len(sys.argv) != 3):
	print("Usage : "+sys.argv[0] + " <infile> <outfile>");
	sys.exit(1);

ifile = sys.argv[1];
ofile = file(sys.argv[2],"w");


thedom = parse(ifile);

bundles = thedom.getElementsByTagName("bundle")

count = 0;
for b in bundles:
	if (b.getAttribute("type") == "rtdata"):
		ein = int(b.getElementsByTagName("energyin")[0].firstChild.nodeValue);
		eout = int(b.getElementsByTagName("energyout")[0].firstChild.nodeValue);
		
		if (((ein >> 30) & 0x00000001) == 1):
			ein = (eval(hex(ein)[:10]+" ^ 0xffffffff")+1) * -1
		
		if (((eout >> 30) & 0x00000001) == 1):
			eout = (eval(hex(eout)[:10]+" ^ 0xffffffff")+1) * -1
		
		
		ofile.write("ein = "+str(ein)+", eout = "+str(eout)+"\n")

ofile.close();
		