#!/usr/bin/python

#
# @author Michael Okola
#

import sys, time
import pytos.util.NescApp as NescApp
import pytos.util.ParseArgs as ParseArgs
import pytos.tools.UnitTest as UnitTest

app = UnitTest.UnitTest("telosa", "sf@localhost:9002", tosbase=False, localCommOnly=True, applicationName="UnitTest")
