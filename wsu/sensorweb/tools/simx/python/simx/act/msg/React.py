from ..mig.python import ReactBase
from ..mig.python.ReactConst import ReactConst

MAX_PAYLOAD = ReactConst.MAX_REACT_PAYLOAD

class Msg(ReactBase.Msg):
    global __HLEN
    __HLEN = ReactBase.Msg().offset_payload_start_byte()

    def __init__(self, data=chr(0)*__HLEN,
                 addr=None, gid=None, base_offset=0, data_length=None):
        assert len(data) >= __HLEN
        ReactBase.Msg.__init__(self, data=data, addr=addr, gid=gid,
                             base_offset=base_offset, data_length=data_length)

    def max_payload(self):
        return MAX_PAYLOAD
    max_payload = classmethod(max_payload)

    def set_payload(self, payload):
        assert len(self.data) >= __HLEN
        self.data = self.data[0:__HLEN] + payload

    def get_payload(self):
        return self.data[__HLEN:]

    def encode(self, msg, track_id=0):
        """
        Returns msg encoded as list of ReactMsg.

        A list is returned because a single message may exceed the payload
        of a single ReactMsg.
        """
        #print "msg: ",msg
        type = msg.get_amType()
        data = msg.dataGet()
        total = len(data)
        if total < 1:
            raise ValueError, "message to encode must have a positive length"
        encoded = []
        for i in xrange(0, total, MAX_PAYLOAD):
            remaining = total - i
            data_part = data[i:i+MAX_PAYLOAD]
            r = Msg()
            r.set_payload(data_part)
            # only the first part gets the type
            r.set_type(type if i == 0 else 0)
            r.set_track_id(track_id)
            r.set_remaining(remaining)
            encoded.append(r)
        return encoded
    encode = classmethod(encode)

    def complete(self):
        """
        Returns True if the payload can be extracted.
        """
        return self.get_remaining() + __HLEN == len(self.dataGet())

    def extract(self):
        """
        Returns a tuple of (type, track_id, data) of the sub-message.

        Raises an exception if the message is not complete. Use the
        complete() predicate to test.
        """
        if not self.complete():
            raise ValueError, "not complete"
        return (self.get_type(), self.get_track_id(), self.get_payload())

    def merge(self, part):
        """
        Concatentate part, a React.Msg, to self.

        This use used for merging split messages.
        """
        if part.get_type() != 0:
            raise ValueError, "not a React message part"
        if part.get_track_id() != self.get_track_id():
            raise ValueError, "tracking ID change"

        part_len = len(part.get_payload())
        remaining = self.get_remaining() - len(self.data) + __HLEN
        if part_len > remaining:
            raise ValueError, "merged message exceeds length"

        self.data += part.get_payload()
        return self
