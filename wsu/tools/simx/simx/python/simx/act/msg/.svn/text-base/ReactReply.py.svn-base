from ..mig.python import ReactReply as Base
from ..mig.python.ReactConst import ReactConst
from Helper import *

# for status
SUCCESS = ReactConst.RESULT_SUCCESS
FAILURE = ReactConst.RESULT_FAILURE
PARTIAL = ReactConst.RESULT_PARTIAL
UNSOLICITED = ReactConst.RESULT_UNSOLICITED

# for refinement
NORMAL = ReactConst.REFINE_NORMAL
INFO = ReactConst.REFINE_INFO
WARN = ReactConst.REFINE_WARN
ERROR = ReactConst.REFINE_ERROR
FATAL = ReactConst.REFINE_FATAL
DEBUG = ReactConst.REFINE_DEBUG

def failure_reply(*refinements):
    reply = Msg()
    reply.set_status(FAILURE)
    for r in refinements:
        reply.add_refinement(ERROR, r)
    return reply

def success_reply(*refinements):
    reply = Msg()
    reply.set_status(SUCCESS)
    for r in refinements:
        reply.add_refinement(NORMAL, r)
    return reply

class Msg(Base.Msg):
    global __HLEN
    __HLEN = Base.Msg().offset_ve_start_byte()

    def __init__(self, data=chr(0)*__HLEN,
                 addr=None, gid=None, base_offset=0, data_length=None):
        Base.Msg.__init__(self, data=data, addr=addr, gid=gid,
                          base_offset=base_offset,
                          data_length=data_length)
        self.init_data(data)
        self.refinements = [] # of (refinement, data)

    def add_refinement(self, refinement=NORMAL, data=""):
        assert refinement > 0
        assert chr(0) not in data
        self.refinements.append((refinement, data))

    def init_data(self, data):
        assert len(data) >= __HLEN
        (self.data, extra) = split_at(data, __HLEN)
#        self.refinements = [(ord(d[1]), d[1:]) for d in extra.split("\0")]

    def dataGet(self):
        parts = [chr(r) + d for r, d in self.refinements]
        return self.data + merge_multipart(*parts)
