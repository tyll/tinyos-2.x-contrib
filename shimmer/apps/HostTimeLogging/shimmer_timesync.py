#! /usr/bin/env python
#
# $Id$
#
#
# Copyright (c) 2010, Shimmer Research, Ltd.
# All rights reserved
#
# Redistribution and use in source and binary forms, with or without
# modification, are permitted provided that the following conditions are
# met:
#
#     * Redistributions of source code must retain the above copyright
#       notice, this list of conditions and the following disclaimer.
#     * Redistributions in binary form must reproduce the above
#       copyright notice, this list of conditions and the following
#       disclaimer in the documentation and/or other materials provided
#       with the distribution.
#     * Neither the name of Shimmer Research, Ltd. nor the names of its
#       contributors may be used to endorse or promote products derived
#       from this software without specific prior written permission.
#
# THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS
# "AS IS" AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT
# LIMITED TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR
# A PARTICULAR PURPOSE ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT
# OWNER OR CONTRIBUTORS BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL,
# SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT
# LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE,
# DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY
# THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT
# (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE
# OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
#
#
# @author Steve Ayer
# @date   March, 2010

import serial
import struct
import time
import random
import sys
import shimmerUtil
from ComplicatedTime import *

# Find the data serial port
# this needs to find the real serial port
port = shimmerUtil.find_data_port(True)
if port == '':
    print 'Could not find SHIMMER data port port.  Exiting.'
    sys.exit()

speed = 115200
print 'Found SHIMMER data port on %s' % (port)
ser = serial.Serial(port, speed, timeout = 1)
ser.flushInput()

t1 = int(time.time())

g = time.gmtime()
year = g.tm_year    
ct = ComplicatedTime(year)

for i in range(0, 4):
    # this is the current time in seconds
    t2 = (t1 >> 8 * (3-i)) & 0x000000ff
    time.sleep(random.random())

    t2_str = struct.pack('B', t2)
    ser.write(t2_str)
    
for i in range(0, 4):
    # this is the start of this year in seconds
    y2 = (ct.year_seconds >> 8 * (3-i)) & 0x000000ff
    time.sleep(random.random())

    y2_str = struct.pack('B', y2)
    ser.write(y2_str)


# day of jan 1
zd_str = struct.pack('B', ct.wday_offset)
ser.write(zd_str)

# first day of dst
for i in range(0, 2):
    # this is the start of this year in seconds
    dstf = (ct.dst_first_yday >> 8 * (1-i)) & 0x00ff
    time.sleep(random.random())

    dstf_str = struct.pack('B', dstf)
    ser.write(dstf_str)

# last day of dst
for i in range(0, 2):
    # this is the start of this year in seconds
    dstl = (ct.dst_last_yday >> 8 * (1-i)) & 0x00ff
    time.sleep(random.random())

    dstl_str = struct.pack('B', dstl)
    ser.write(dstl_str)

# we need to tell it what year it is
for i in range(0, 2):
    # this is the start of this year in seconds
    yr = (year >> 8 * (1-i)) & 0x00ff
    time.sleep(random.random())

    yr_str = struct.pack('B', yr)
    ser.write(yr_str)

print "Wrote %d to shimmer.  Done!" % t1

ser.close()

