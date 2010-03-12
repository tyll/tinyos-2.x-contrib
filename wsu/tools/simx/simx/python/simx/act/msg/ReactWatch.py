from ..mig.python import ReactWatch as Base
from Helper import *

class Msg(Base.Msg):
    global __HLEN
    __HLEN = Base.Msg().offset_ve_start_byte()

    def __init__(self, data=chr(0)*__HLEN,
                 addr=None, gid=None, base_offset=0, data_length=None):
        Base.Msg.__init__(self, data=data, addr=addr, gid=gid,
                          base_offset=base_offset,
                          data_length=data_length)
        self.init_data(data)

    def set_value(self, value):
        self.value = value

    def init_data(self, data):
        assert len(data) >= __HLEN
        (self.data, extra) = split_at(data, __HLEN)
        self.value = extra

    def dataGet(self):
        return self.data + self.value
