#!/usr/bin/env python 
# TinyOS wrappers for Python
#
# (C)2001-2002 Christophe Braillon <christophe.braillon@inrialpes.fr>

import sys, os, string

if os.name == 'posix':
    from TOSSerial import *
else:
    raise Exception("Sorry: no implementation for your platform ('%s') available or not tested yet" % os.name)
