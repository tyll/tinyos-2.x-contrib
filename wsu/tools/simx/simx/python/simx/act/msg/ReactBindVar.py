from ..mig.python.ReactBindVarBase import ReactBindVarBase
from Helper import *

class Msg(ReactBindVarBar.Msg):
    global __HLEN
    __HLEN = ReactBindVarBar.Msg().offset_ve_start_byte()

    def __init__(self, data=chr(0)*__HLEN,
                 addr=None, gid=None, base_offset=0, data_length=None):
        ReactBindVarBar.Msg.__init__(self, data=data, addr=addr, gid=gid,
                                     base_offset=base_offset,
                                     data_length=data_length)
        self.init_data(data)

    def init_data(self, data):
        assert len(data) >= __HLEN
        (self.data, extra) = (data[0:__HLEN], data[__HLEN:])
        (self.varname, self.watchexpr) = smart_split(extra, "\0", 2)

    def dataGet(self):
        return self.data + "\0".join((self.varname, self.watchexpr))
