from ..mig.python import ReactBindWatchBase as Base
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

    def init_data(self, data):
        assert len(data) >= __HLEN
        (self.data, extra) = split_at(data, __HLEN)
        (self.varname, self.watchexpr) = split_multipart(extra, 2)

    def set_varname(self, varname):
        self.varname = varname

    def set_watchexpr(self, expr):
        self.watchexpr = expr
    def set_value(self,value):
        self.value = value
    def dataGet(self):
        return self.data + merge_multipart(self.varname, self.watchexpr)
