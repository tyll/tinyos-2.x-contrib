from ..mig.python import TimeEvent as Base
from Helper import *

class Msg(Base.Msg):
    global __HLEN
    __HLEN = 1

    def __init__(self, data="", addr=None):
        Base.Msg.__init__(self, data=data, addr=addr)

    def set_time(self, time):
        self.set_timeH(time >> 32)
        self.set_timeL(time & 0xFFFFFFFF)

    def get_time(self):
        return (self.get_timeH() << 32) | self.get_timeL()
