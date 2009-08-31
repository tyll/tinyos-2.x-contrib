########################################################################
### spi.py -- _spi wrapper
###

from _spi import *

class SPI:
    def __init__(self, *rest):
        self._s     = alloc(*rest)
        self.spien  = self.spien
        self.rst    = self.rst
        self.sck    = self.sck
        self.mosi   = self.mosi
        self.miso   = self.miso
        self.update = self.update
        self.flush  = self.flush
        self.rbit   = self.rbit
        self.byte   = self.byte

    def spien(self, val):
        spien(self._s, val)

    def rst(self, val):
        rst(self._s, val)

    def sck(self, val):
        sck(self._s, val)

    def mosi(self, val):
        mosi(self._s, val)

    def miso(self, val):
        miso(self._s, val)

    def update(self, doFlush=False):
        update(self._s, doFlush)

    def flush(self):
        flush(self._s)

    def rbit(self):
        return rbit(self._s)

    def byte(self, val, doRead=False):
        return byte(self._s, val, doRead)

### EOF spi.py

