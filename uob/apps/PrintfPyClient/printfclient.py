#!/usr/bin/python
# -*-  indent-tabs-mode:nil; python-indent:4  -*-

"""Output printf messages.
Author	: Markus Becker
Date	: 23.11.2009

Usage:
  python printfclient.py -s localhost:9001
"""

import sys, os, getopt, datetime

from tinyos.message import MoteIF
from tinyos.message import Message

from printf import printf

class Listen:
    def __init__(self, source_str):
        self.mif = MoteIF.MoteIF()

        self.mif.addListener(self, printf)

        self.source = self.mif.addSource(source_str)

    # callback
    def receive(self, src, msg):
        #time = datetime.datetime.now()
        #print "Time:", time, ":",

        message_str = ""
        for i in msg.get_buffer():
            message_str = message_str + chr(i)
        print message_str
        sys.stdout.flush()

def main():
    try:
        opts, args = getopt.getopt(sys.argv[1:], \
                                   "hs:", \
                                   ["help", "sf="])
    except getopt.error, msg:
        print msg
        print "for help use --help"
        sys.exit(2)

    sf = "localhost:9001"
    usesf = False

    #print opts, args
    for o, a in opts:
        if o in ("-h", "--help"):
            print __doc__
            sys.exit(0)

        if o in ("-s", "--sf"):
            sf = a
            usesf = True


    source = ""
    if usesf:
        source = "sf@" + sf
        print "Connecting", source
    else:
        print "Please specify source with -s."
        sys.exit(0)

    l = Listen(source)

    while True:
        pass

if __name__ == "__main__":
    main()
