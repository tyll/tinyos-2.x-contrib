#!/cygdrive/c/Python25/python
########################################################################
### at-spi.py -- load TIText program onto ATMega128[L] via SPI
###

__doc__ = """
usage: at-spi.py titext_file
"""

import sys
sys.path.insert(0, "build/lib.win32-2.5")
from d2xx import *
from spi import *
from time import sleep, time

class AT128SPI:
    MOSI   = 0x80  ### Ox
    MISO   = 0x40  ### I
    SCK    = 0x10  ### Ox
    SPI_EN = 0x08  ### O1
    RST    = 0x04  ### Ox

    def __init__(self):
        p = self.p = D2XX()

        s = self.s = SPI(self.SPI_EN, self.RST,
                         self.SCK, self.MOSI, self.MISO,
                         self._read, self._write)
        p.mode(self.MOSI | self.SCK | self.SPI_EN | self.RST, FT_MODE_ASYNC)
        p.speed(FT_BAUD_115200)

        s.spien(1)
        s.rst(1)
        s.sck(0)
        s.mosi(0)

        s.update(True)

        self.spiByte = self.spiByte
        self.spi     = self.spi

    def _read(self):
        return self.p.bits()

    def _write(self, s):
        while s:
            nw = self.p.write(s)
            s  = s[nw:]

    def milliSleep(self, ms):
        self.s.flush()
        sleep(ms * 0.001)

    def cpuAttn(self):
        ### RST and SCK low
        self.s.rst(0)
        self.s.sck(0)
        self.s.update(True)

        ### Positive pulse on RST
        self.s.rst(1)
        self.s.update()

        ### Brief pause
        self.milliSleep(1)

        ### RST low
        self.s.rst(0)
        self.s.update()

        ### Wait 20ms plus one
        self.milliSleep(21)

    def cpuRlse(self):
        ### RST low
        self.s.rst(0)
        self.s.update()
        self.milliSleep(1)

        ### RST high
        self.s.rst(1)
        self.s.update(True)

        ### Disable SPI
        self.s.spien(0)
        self.s.update(True)

    def spiByte(self, byte, doRead=False):
        return self.s.byte(byte, doRead)

    def spi(self, bytes, doRead=False):
        return [self.spiByte(x, doRead) for x in bytes]

    def close(self):
        self.s.flush()
        self.p.close()

    __del__ = close

    def progMode(self):
        for i in xrange(16):
            ### send enter-programming-mode instruction
            self.spiByte(0xac)
            self.spiByte(0x53)
            b = self.spiByte(0x00, True)
            self.spiByte(0x00)
            ### done, if in sync
            if b == 0x53:
                return

            ### not in sync, try again...
            
            ### high RST pulse
            self.s.rst(1)
            self.s.update()
            self.milliSleep(1)

            ### RST low
            self.s.rst(0)
            self.s.update()

            ### Wait 20ms plus one
            self.milliSleep(21)
        raise RuntimeError, "Cannot enter programming mode"

    def chipErase(self):
        ### erase the chip
        self.spiByte(0xac)
        self.spiByte(0x80)
        self.spiByte(0x00)
        self.spiByte(0x00)
        self.milliSleep(11)

        ### end CE mode
        self.s.rst(1)
        self.s.update()
        self.milliSleep(1)
        self.s.rst(0)
        self.s.update(True)

def m(fmt, *rest):
    if rest:
        fmt = fmt % rest
    print fmt.rstrip()
    sys.stdout.flush()

def load(items):
    ### get into programming mode
    T = time()
    p = AT128SPI()
    m("Enter program mode...")
    p.cpuAttn()
    p.progMode()

    ### dump fuses
    if 0:
        print "Lock", [hex(x) for x in p.spi([0x58, 0x00, 0x00, 0x00], True)]
        print "Sig0", [hex(x) for x in p.spi([0x30, 0x00, 0x00, 0x00], True)]
        print "Sig1", [hex(x) for x in p.spi([0x30, 0x00, 0x01, 0x00], True)]
        print "Sig2", [hex(x) for x in p.spi([0x30, 0x00, 0x02, 0x00], True)]
        print "Sig3", [hex(x) for x in p.spi([0x30, 0x00, 0x03, 0x00], True)]
        print "Fuse", [hex(x) for x in p.spi([0x50, 0x00, 0x00, 0x00], True)]
        print "Xtnd", [hex(x) for x in p.spi([0x50, 0x08, 0x00, 0x00], True)]
        print "High", [hex(x) for x in p.spi([0x58, 0x08, 0x00, 0x00], True)]
        print "Cal0", [hex(x) for x in p.spi([0x38, 0x00, 0x00, 0x00], True)]
        print "Cal1", [hex(x) for x in p.spi([0x38, 0x00, 0x01, 0x00], True)]
        print "Cal2", [hex(x) for x in p.spi([0x38, 0x00, 0x02, 0x00], True)]
        print "Cal3", [hex(x) for x in p.spi([0x38, 0x00, 0x03, 0x00], True)]
        m("Fuse dump done")

    ### erase eeprom and flash
    m("Mass erase...")
    p.chipErase()
    p.cpuAttn()
    p.progMode()

    ### program up the chip
    m("Programming...")
    todo = len(items)
    assert not (todo & 1)
    word = 0
    next = iter(items).next
    while todo:
        blk = (todo > 255) and 256 or todo
        wds = blk >> 1
        assert not (blk & 1)
        assert ((todo > 255) and (wds  == 0x80)) or \
               ((todo < 256) and (todo == (wds << 1)))
        for b in xrange(wds):
            p.spi([0x40, 0x00, b, next()])
            p.spi([0x48, 0x00, b, next()])
        ### data sheet is  w r o n g
        p.spi([0x4c, word >> 8, (word & 0xff), 0x00])
        p.milliSleep(6)
        todo -= blk
        word += wds
        m("  %3.0f%% done", (100 * (float(len(items) - todo) / len(items))))

    ### release the interface
    m("Reset...")
    p.cpuRlse()
    p.close()

    ### dump stats
    n = len(items)
    T = time() - T
    m("Programmed %d bytes in %.3f sec, %.3f kb/s", n, T, n / (128. * T))
    m("Done.")

def go(data):
    data = data.replace("\r\n", "\n").replace("\r", "\n")
    assert data.startswith("@0\n")
    data = data[3:]
    assert "@" not in data
    bytes = [ ]
    for b in data.split():
        bytes.append(int(b, 16))
    load(bytes)

def usage():
    raise SystemExit, __doc__

def main(args):
    len(args) == 1 or usage()
    f = open(args[0])
    try:
        d = f.read()
    finally:
        f.close()
    go(d)

if __name__ == "__main__":
    main(sys.argv[1:])

### EOF at-spi.py

