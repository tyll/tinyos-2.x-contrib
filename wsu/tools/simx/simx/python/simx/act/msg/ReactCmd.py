from ..mig.python import ReactCmdBase as Base
from warnings import warn

class Msg(Base.Msg):
    global __HLEN
    __HLEN = Base.Msg().offset_ve_start_byte()

    def __init__(self, data=chr(0)*__HLEN,
                 addr=None, gid=None, base_offset=0, data_length=None):
        Base.Msg.__init__(self, data=data, addr=addr, gid=gid,
                          base_offset=base_offset,
                          data_length=data_length)
        self.init_data(data)

    def set_cmd(self, cmd):
        self.cmd = cmd

    def get_cmd(self):
        return self.cmd

    def init_data(self, data):
        assert len(data) >= __HLEN
        (self.data, self.cmd) = (data[0:__HLEN], data[__HLEN:])

    def dataGet(self):
        return self.data + self.cmd
