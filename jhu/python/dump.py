#!/usr/bin/env python

import sys
import tinyos

if len(sys.argv) < 2:
    print "Usage:", sys.argv[0], "/dev/ttyUSB0"
    sys.exit()

s = tinyos.Serial(sys.argv[1], 115200)

while True:
    p = s.sniff_am()
    if p:
        for i in p.data:
            print "%2x" % i,
        print
