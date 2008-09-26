#!/usr/bin/python



import sys;


if (len(sys.argv) != 5):
    print "usage: solarmodel.py <filename> <outfilename> <panel size m^2> <eff>"
    sys.exit(1);

fname = sys.argv[1];
outfname = sys.argv[2];
psize = sys.argv[3];
peff = sys.argv[4];


f = file(fname,"r");
outf = file(outfname,"w");


hour = 0;

for line in f:
    tokens = line[:len(line)-1].split(",");
    #hour = int(tokens[0]);
    energy = float(tokens[1]) * float(psize) * float(peff);

    permin = energy * 60 * 1000; # convert to mJ/min

    for i in range(60):
        mstime = (hour * 3600000L) + (i * 60000);
        outf.write(str(mstime) + ":" + str(int(permin))+"\n");
    hour = hour + 1

outf.close();
f.close();
