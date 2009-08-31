#!/bin/sh
########################################################################
### srec2ti -- convert srec to ti-text format
###

'''exec' python $0 ${1+"$@"}
'''

def process(data, writer):
    addr = None
    out  = [ ]
    for (la, cnt, txt) in data:
        if (la & 0xf0000) != ((la + cnt - 1) & 0xf0000):
            raise RuntimeError, "SREC line internally crosses a 64k boundary"
        if addr != la:
            addr = la
            out.append("@%X" % addr)
        out.append(txt)
        naddr = addr + cnt
        if (naddr & 0xf0000) != (addr & 0xf0000):
            ### force a new header
            addr = 0L
        else:
            addr = naddr
    out.append("")
    writer("\r\n".join(out))

import re

HEX_RX = re.compile(r"[0-9A-Fa-f]{2}")

def _hexer(m, ret):
    ret.append(int(m.group(0), 16))
    return ""

def hexer(s):
    ret = [ ]
    fcn = lambda m: _hexer(m, ret)
    chk = HEX_RX.sub(fcn, s)
    if chk:
        raise ValueError, "Extra garbage in line " + repr(s)
    return ret

def filt(line):
    if not line.startswith("S"):
        raise ValueError, "Bad line " + repr(line)
    if len(line) < 2:
        raise ValueError, "Bad line " + repr(line)
    c = line[1]
    if c in "05789":
        return None
    if c not in "123":
        raise ValueError, "Bad line " + repr(line)
    naddr = int(c) + 1
    bytes = hexer(line[2:])
    if len(bytes) < 2:
        raise ValueError, "Bad line " + repr(line)
    chk = bytes.pop()
    sum = (reduce(lambda a, b: a + b, bytes, 0) & 0xff) ^ 0xff
    if sum != chk:
        raise ValueError, "Bad checksum in " + repr(line) + ": " + \
              str(sum) + " != " + str(chk)
    if len(bytes) < 2:
        raise ValueError, "Bad line " + repr(line)
    cnt = bytes[0]
    del bytes[0]
    if (len(bytes) + 1) != cnt:
        raise ValueError, "Bad count in " + repr(line) + ": " + \
              str(len(bytes)) + " != " + str(cnt)
    if len(bytes) <= naddr:
        raise ValueError, "Short line " + repr(line)
    a, bytes = bytes[:naddr], bytes[naddr:]
    la = 0L
    for x in a:
        la <<= 8
        la  |= x
    nbyte = len(bytes)
    bytes = " ".join(map(lambda b: "%02X" % b, bytes))
    return (la, nbyte, bytes)

def go(data, writer):
    data = data.replace("\r\n", "\n").replace("\r", "\n")
    data = data.strip().split("\n")
    data = filter(None, map(filt, data))
    process(data, writer)

__usage__ = """
usage: srec2ti.py <  infile > outfile
"""

def usage():
    raise SystemExit, __usage__

def main(args):
    import sys
    args and usage()
    go(sys.stdin.read(), sys.stdout.write)

if __name__ == "__main__":
    import sys
    main(sys.argv[1:])

### EOF srec2ti

