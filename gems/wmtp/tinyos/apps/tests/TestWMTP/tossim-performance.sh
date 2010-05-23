#!/bin/sh

./test.py | grep "WmtpPerformanceReporterP:" | awk '{ print $4 }' | cut -d ] -f 1 | sort -t\; +1 +0 -n > tossim.csv
