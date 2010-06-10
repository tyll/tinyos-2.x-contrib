# $Id$
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
# @author Steve Ayer
# @date   June 2010
#
# this is mainly for feeding the time module timezone info as revealed by a
# host, first used in shimmer_timesync

import time
import datetime

class ComplicatedTime:

    def __init__(self, year):
        self.year = year

        # params for tos-time module
        self.year_seconds = 0
        self.wday_offset = 0
        if self.year % 4:
            self.isleap = False
        else:
            self.isleap = True

        self.gmt_offset = 0
        
        self.dst_first_yday = 0
        self.dst_last_yday = 0

        self.tzname = time.tzname
        self.daylight = time.daylight
        
        self.newyears_weekday()
        self.gen_gmtime()

        self.tzrules = ((0, 0, 0), (0, 0, 0))
        
        if self.daylight:
            self.tzrules = self.timezone_rules()
            self.dst_first_yday = self.nth_month_day_to_year_day(year, self.tzrules[0]);
            self.dst_last_yday = self.nth_month_day_to_year_day(year, self.tzrules[1]);
            
    def timezone_rules(self):
        # north america
        if self.gmt_offset >= 5.0 and self.gmt_offset <= 8.0:
            return ((3, 6, 2), (11, 6, 1))
        # east across europe/asia
        elif self.gmt_offset <= 0.0 and self.gmt_offset >= -7.0:
            return ((3, 6, 99), (10, 6, 99))
        # far east
        elif self.gmt_offset <= -8.0 and self.gmt_offset >= -11.0:
            # only real exception here is australia
            if 'WST' in self.tzname or \
                   'CST' in self.tzname or \
                   'EST' in self.tzname:       
                return ((10, 6, 1), (4, 6, 1))
            else:
                return ((3, 6, 99), (10, 6, 99))
        # south-west pacific
        elif self.gmt_offset == -12.0:
            if 'NZST' in self.tzname:
                return ((9, 6, 99), (4, 6, 1))
            else:
                return ((3, 6, 99), (10, 6, 99))
        # alaska
        elif self.gmt_offset == 9.0:
            return ((3, 6, 2), (11, 6, 1))
        elif self.gmt_offset == 10.0:
            return ((3, 6, 2), (11, 6, 1))

    def gen_gmtime(self):
        sec_offset = time.timezone                # seconds
        self.gmt_offset = sec_offset / 3600.0       # hours

        self.year_seconds = int(time.mktime((self.year, 1, 1, 0, 0, 0, self.wday_offset, 1, 0)))

    def newyears_weekday(self):
        self.wday_offset =  datetime.date(self.year, 1, 1).weekday()

    def print_em(self):
       print "first second of %d is %x\nfirst day of year %d\ndst start is %d\ndst end is %d" \
        % (self.year, self.year_seconds, self.wday_offset, self.dst_first_yday, self.dst_last_yday)

    # huh?  we want to know which day of 365/6, for example, the second sunday of march in 2010
    # so, we say nth_month_day_to_year(2010, 3, 6, 2) and get back 74
    # if we want the last, pass in 99 for which_one 
    def nth_month_day_to_year_day(self, year, (month, selected_day, which_one)):
        d = { 1:31, 3:31, 4:30, 5:31, 6:30, 7:31, 8:31, 9:30, 10:31, 11:30, 12:31 }
        if self.isleap:
            d[2] = 29
        else:
            d[2] = 28

        if which_one != 99:
            first_weekday = datetime.date(year, month, 1).weekday()

            if selected_day < first_weekday:
                selected_day = selected_day + 7
            days_to_selectedday = selected_day - first_weekday
            our_day = 7 * (which_one - 1) + days_to_selectedday + 1
        else:
            lastday = d[month]
            last_weekday = datetime.date(year, month, lastday).weekday()
            if last_weekday < selected_day:
                last_weekday = last_weekday + 7
            days_to_selectedday = last_weekday - selected_day
            our_day = lastday - days_to_selectedday

        # now we have to convert to day of year
        for i in range(1, month):
            our_day = our_day + d[i]
            
        return our_day
    
