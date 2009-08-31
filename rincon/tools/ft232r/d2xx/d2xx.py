########################################################################
### d2xx.py
###

import _d2xx
__doc__ = _d2xx.__doc__

class D2XX:
    @classmethod
    def devs(self):
        return _d2xx.devs()

    def __init__(self, dev=0):
        "open the device"
        try:
            dev = int(dev)
        except:
            pass
        self._h = _d2xx.open(dev)
        self.reset()

    def close(self):
        "close the device"
        self._h = self._b = None

    __del__ = close

    def info(self):
        return _d2xx.info(self._h)

    def reset(self, how=0):
        _d2xx.reset(self._h, how)
        self._b = None

    def flow(self, method, xonChar=19, xoffChar=20):
        _d2xx.flow(self._h, method, xonChar, xoffChar)

    def speed(self, rate):
        _d2xx.speed(self._h, rate)

    def dfmt(self, databits, stopbits, parity):
        _d2xx.dfmt(self._h, databits, stopbits, parity)

    def mode(self, mask, mode):
        if (mode == _d2xx.FT_MODE_UART) or (not mask):
            self._b = None
        else:
            self._b = (0x00, mask, mask, mode)
        _d2xx.mode(self._h, mask, mode)

    def write(self, string):
        nw = _d2xx.write(self._h, string)
        if self._b and nw:
            self._b = (ord(string[nw - 1]),) + self._b[1:]
        return nw

    def read(self, nbytes=1):
        return _d2xx.read(self._h, nbytes)

    def modem(self):
        if self._b:
            raise RuntimeError, "Cannot read modem status in bitbang mode (FIXME)"
        return _d2xx.modem(self._h)

    def purge(self, what):
        _d2xx.purge(self._h, what)

    def _iobang(self, mask, level):
        bval, bmask, omask, bmode = self._b
        if not (mask & omask):
            ### pin isn't in port mask
            if level:
                ### remove from mask, let pullup handle it
                bmask &= ~mask
                _d2xx.mode(self._h, bmask, bmode)
            else:
                ### add to mask and drag it low
                bmask |= mask
                _d2xx.mode(self._h, bmask, bmode)
            self._b = (bval, bmask, omask, bmode)
            self.write(chr(bval & ~mask))
            return
        ### pin is already in port mask -- adjust
        if level:
            bval |= mask
        else:
            bval &= ~mask
        self.write(chr(bval))

    def dtr(self, level=1):
        if not self._b:
            _d2xx.dtr(self._h, level)
        else:
            self._iobang(_d2xx.FT_BANG_DTR_OUTPUT, not level)

    def rts(self, level=1):
        if not self._b:
            _d2xx.rts(self._h, level)
        else:
            self._iobang(_d2xx.FT_BANG_RTS_OUTPUT, not level)

    def brk(self, level=1):
        if self._b:
            raise RuntimeError, "Cannot send BREAK in bitbang mode"
        _d2xx.brk(self._h, level)

    def inq(self, level=1):
        if self._b:
            raise RuntimeError, "Cannot read queue in bitbang mode"
        _d2xx.inq(self._h, level)

    def timeo(self, timeout):
        _d2xx.timeo(self._h, timeout)

    def prog(self, **kw):
        _d2xx.prog(self._h, kw)
        self.reset(2)
        self.close()

    def uasz(self):
        return _d2xx.uasz(self._h)

    def uard(self):
        return _d2xx.uard(self._h)

    def uawr(self, data):
        _d2xx.uawr(self._h, str(data))

    def bits(self):
        return _d2xx.bits(self._h)

for attr in ("reset flow speed dfmt mode write read modem purge " + \
             "dtr rts brk inq timeo").split():
    setattr(getattr(D2XX, attr).im_func, "__doc__", getattr(_d2xx, attr).__doc__)
for attr in dir(_d2xx):
    if attr.startswith("FT_"):
        globals()[attr] = getattr(_d2xx, attr)
del attr

### EOF d2xx.py

