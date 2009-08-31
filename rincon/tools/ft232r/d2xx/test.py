########################################################################
### test.py
###

import sys
from d2xx import *

print "d2xx import ok"

def i(msg="Press ENTER"):
    sys.stdout.write(msg)
    sys.stdout.flush()
    raw_input("")

print D2XX.devs()
port = D2XX()
print port.info()
print port.uasz()
s = port.uard()
print len(s), repr(s)
port.uawr("This is a test of UAWrite")
s = port.uard()
print len(s), repr(s)

raise SystemExit
port.prog(description="Hill Mote")
port.close()
import sys, time
sys.stdout.flush()
for i in xrange(10):
    time.sleep(1)
    try:
        port = D2XX()
    except:
        continue
    print "reopened!"
    break
else:
    raise RuntimeError, "reopen failed!"
print port.info()
port.close()
port = D2XX("FTQCSZJQ")

port.reset()

if 0:
    port.flow(FT_FLOW_NONE)
    port.speed(FT_BAUD_9600)
    port.dfmt(FT_BITS_8, FT_STOP_BITS_1, FT_PARITY_NONE)

if 0:
    PROG_EN  = FT_BANG_CTS_OUTPUT
    PROG_TCK = FT_BANG_DTR_OUTPUT
    PROG_RST = FT_BANG_RTS_OUTPUT

    i("ENTER to deassert PROG_EN")
    port.mode(PROG_EN | PROG_TCK | PROG_RST, FT_MODE_ASYNC)
    port.write(chr(PROG_TCK | PROG_RST))

    i("ENTER to assert PROG_EN")
    port.write(chr(PROG_TCK | PROG_RST | PROG_EN))

    i("ENTER to deassert DTR (TCK-A1)")
    port.write(chr(PROG_RST | PROG_EN))

    i("ENTER to deassert RTS (RST#-A2)")
    port.write(chr(PROG_EN))

    i("ENTER for UART mode")
    port.mode(0x00, FT_MODE_UART)

    i("ENTER to terminate")

if 1:
    i("DTR high")
    port.dtr(1)
    i("DTR low")
    port.dtr(0)

port.close()

sys.path.insert(0, r"..\serial")
from seriald2xx import Serial
s = Serial(0)
s.resetMCU()

### EOF test.py

