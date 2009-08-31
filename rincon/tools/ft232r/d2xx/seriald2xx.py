########################################################################
### seriald2xx.py -- serial driver for win32 d2xx on FT232R
###

import d2xx
from serial import serialutil

VERSION = "1.1"

PARITY_NONE, PARITY_EVEN, PARITY_ODD = range(3)
STOPBITS_ONE, STOPBITS_TWO = (1, 2)
FIVEBITS, SIXBITS, SEVENBITS, EIGHTBITS = (5,6,7,8)

_Pd = {
    PARITY_NONE: d2xx.FT_PARITY_NONE,
    PARITY_EVEN: d2xx.FT_PARITY_EVEN,
    PARITY_ODD:  d2xx.FT_PARITY_ODD,
}

_Dd = {
    FIVEBITS:  d2xx.FT_BITS_5,
    SIXBITS:   d2xx.FT_BITS_6,
    SEVENBITS: d2xx.FT_BITS_7,
    EIGHTBITS: d2xx.FT_BITS_8,
}

_Sd = {
    STOPBITS_ONE: d2xx.FT_STOP_BITS_1,
    STOPBITS_TWO: d2xx.FT_STOP_BITS_2,
}

class D2XXSerial(serialutil.FileLike):
    def __init__(self,
                 port,                  #number of device, numbering starts at
                                        #zero. if everything fails, the user
                                        #can specify a device string, note
                                        #that this isn't portable anymore
                 baudrate=9600,         #baudrate
                 bytesize=EIGHTBITS,    #number of databits
                 parity=PARITY_NONE,    #enable parity checking
                 stopbits=STOPBITS_ONE, #number of stopbits
                 timeout=None,          #set a timeout value, None for waiting forever
                 xonxoff=0,             #enable software flow control
                 rtscts=0,              #enable RTS/CTS flow control
                 ):
        """initialize comm port"""

        self.timeout = timeout

        try:
            self._port = int(port)
        except:
            self._port = port
        if type(port) == type(''):       #strings are taken directly
            self.portstr = port
        else:
            self.portstr = 'COM%d' % (port+1) #numbers are transformed to a string

        try:
            self._d = d2xx.D2XX(self._port)
        except Exception, msg:
            self._d = None    #'cause __del__ is called anyway
            raise serialutil.SerialException, "could not open port %s: %s" % (self._port, msg)

        if timeout is None:
            timeout = 120
        self._d.timeo(timeout * 1000)

        self._d.speed(baudrate)

        self._d.dfmt(_Dd[bytesize], _Sd[stopbits], _Pd[parity])

        if rtscts:
            self._d.flow(d2xx.FT_FLOW_RTS_CTS)
        elif xonxoff:
            self._d.flow(d2xx.FT_FLOW_XON_XOFF)
        else:
            self._d.flow(d2xx.FT_FLOW_NONE)

        self._d.purge(d2xx.FT_PURGE_TX | d2xx.FT_PURGE_RX)

    def __del__(self):
        self.close()

    def close(self):
        """close port"""
        if self._d:
            #self.setRTS(0)
            #self.setDTR(0)
            self._d.purge(d2xx.FT_PURGE_TX | d2xx.FT_PURGE_RX)
            self._d.reset()
            self._d = None

    def setBaudrate(self, baudrate):
        """change baudrate after port is open"""
        self._d.speed(baudrate)

    def inWaiting(self):
        """returns the number of bytes waiting to be read"""
        return self._d.inq()

    def read(self, size=1):
        "read num bytes from serial port"
        ret = ""
        while len(ret) < size:
            buf  = self._d.read(size - len(ret))
            ret += buf
        return ret

    def write(self, s):
        "write string to serial port"
        l = len(s)
        w = 0
        while w < l:
            nw = self._d.write(s[w:])
            w += nw

    def flushInput(self):
        self._d.purge(d2xx.FT_PURGE_RX)

    def flushOutput(self):
        self._d.purge(d2xx.FT_PURGE_TX)

    def sendBreak(self):
        if not self.hComPort: raise portNotOpenError
        import time
        self._d.brk(True)
        #TODO: how to set the correct duration??
        time.sleep(0.020)
        self._d.brk(False)

    def setRTS(self,level=1):
        """set terminal status line"""
        self._d.rts(not level)

    def setDTR(self,level=1):
        """set terminal status line"""
        self._d.dtr(not level)

    def getCTS(self):
        """read terminal status line"""
        return (self._d.modem() & d2xx.FT_MODEM_CTS) != 0

    def getDSR(self):
        """read terminal status line"""
        return (self._d.modem() & d2xx.FT_MODEM_DSR) != 0

    def getRI(self):
        """read terminal status line"""
        return (self._d.modem() & d2xx.FT_MODEM_RI) != 0

    def getCD(self):
        """read terminal status line"""
        return (self._d.modem() & d2xx.FT_MODEM_DCD) != 0

    ########################################

    def programMode(self, state):
        if state:
            mask = d2xx.FT_BANG_CTS_OUTPUT | \
                   d2xx.FT_BANG_DTR_OUTPUT | \
                   d2xx.FT_BANG_RTS_OUTPUT
            mode = d2xx.FT_MODE_ASYNC
        else:
            mask = 0x00
            mode = d2xx.FT_MODE_UART
        self._d.mode(mask, mode)
        if mask:
            ### make all outputs high
            self.write(chr(mask))

    def tenMilliSec(self):
        import time
        time.sleep(0.010)

    def resetMCU(self):
        self.programMode(True); self.tenMilliSec()
        ### RST = 0
        self.setRTS(0); self.tenMilliSec()
        ### RST = 1
        self.setRTS(1); self.tenMilliSec()
        self.programMode(False)

    def enterBSL(self, hasTestPin=False):
        self.programMode(True); self.tenMilliSec()
        ### drag reset low
        self.setRTS(0); self.tenMilliSec()
        if hasTestPin:
            v = 1
            self.setDTR(1 - v); self.tenMilliSec()
        else:
            v = 0
        ### three edges on TCK
        self.setDTR(v);     self.tenMilliSec()
        self.setDTR(1 - v); self.tenMilliSec()
        self.setDTR(v);     self.tenMilliSec()
        self.setDTR(1 - v); self.tenMilliSec()
        self.setDTR(v);     self.tenMilliSec()
        ### bring reset high
        self.setRTS(1);     self.tenMilliSec()
        ### toggle TCK 
        self.setDTR(1 - v); self.tenMilliSec()
        ### release
        self.setDTR(1);     self.tenMilliSec()
        self.programMode(False)
        for i in xrange(50):
            self.tenMilliSec()

Serial = D2XXSerial

if __name__ == '__main__':
    s = Serial(0)

### EOF seriald2xx.py

