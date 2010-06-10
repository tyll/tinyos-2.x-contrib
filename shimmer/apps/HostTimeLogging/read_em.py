#!/usr/bin/python

import os, sys
import array

USAGE_TEXT = """
Usage: read_em.py <datafile>
"""

def usage():
    print USAGE_TEXT
    sys.exit(-1)

def read_it(filename):
    try:
        f = open(filename, 'r')
    except:
        print "can't open %s for read" % filename
        sys.exit(-2)
        
    finfo = os.stat(filename)
    sz = finfo.st_size

#    print "file has size %d samples" % (sz / 6)

    sz = sz / 2
    data = array.array('H')
    data.fromfile(f, sz)

    f.close()

    return data

def print_em(data):
    t = 0.00

    s = len(data)
    for i in range(0,s,3):
        try:
            print "%04.02f\t%d\t%d\t%d" % (t, data[i], data[i+1], data[i+2])
        except:
            print "file has truncated data at index %d" % i
            return
        
        t = t + 0.02
    
def main(argv):                         
    if len(argv) < 1:
        usage()                          

    data = read_it(argv[0])

    print_em(data)
    
if __name__ == "__main__":
    main(sys.argv[1:])

