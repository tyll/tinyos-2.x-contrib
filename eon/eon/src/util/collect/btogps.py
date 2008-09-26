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
	if (b.getAttribute("type") == "gps"):
		latd = b.getElementsByTagName("latdec")[0].firstChild.nodeValue;
		lond = b.getElementsByTagName("longdec")[0].firstChild.nodeValue;
		dt = b.getElementsByTagName("date")[0].firstChild.nodeValue;
		tm = b.getElementsByTagName("time")[0].firstChild.nodeValue;
		ofile.write("point"+str(count)+","+dt+"-"+tm+","+latd+",-"+lond+",red\n")

ofile.close();
		