from packet import Packet

class Message(object):
    """
    A ProtoMap message; allows a message to be separated from the
    protocol it is sent as (which allows applying a subname among
    other things) and caches serialization.
    """

    def __init__(self, track_id, pbuffer, name=None, subname=None):
        self.track_id = track_id
        self.pbuffer = pbuffer
        self.subname = subname

        self.name = name or pbuffer.__class__.DESCRIPTOR.full_name
            
        if subname:
            self.name = self.name + "$" + subname

        self.serialized = None


    def encode(self, protocol):
        """
        Encodes the message as a packet (serializing it first if
        needed) using the given protocol.
        """
        if not self.serialized:
            self.serialized = self.pbuffer.SerializeToString()
        packet = Packet(self.track_id, protocol, self.serialized)
        return packet.encode()
