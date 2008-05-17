#!/usr/bin/env python

import sys
import tos

if len(sys.argv) < 3:
    print "Usage:", sys.argv[0], "/dev/ttyUSB0 115200"
    sys.exit()

s = tos.Serial(sys.argv[1], int(sys.argv[2]), debug=False)
am = tos.AM(s)

while True:
    p = am.read()
