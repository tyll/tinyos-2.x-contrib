"""
Packet encoding/decoding.
"""

import struct
import types

PROTOCOL_MASK = 0x03 # bits 1:0
NAMED_PROTOCOL = 1
TRACKED_MASK = 0x80  # bits 7:7

class Packet(object):
    """
    Basic packet manipulation.
    """

    # protocol may be either a string or an integer
    __slots__ = ['payload', 'track_id', 'protocol']

    def __init__(self, track_id=None, protocol=None, payload=None):
        self.track_id = track_id
        self.protocol = protocol
        self.payload = payload

    @staticmethod
    def is_named(protocol):
        """
        Returns true iff the protocol is "named".
        """
        return isinstance(protocol, types.StringTypes)

    @staticmethod
    def decode(pkt):
        """
        Decode a packet given the raw data.
        """
        header = struct.unpack_from(">I", pkt, 0)[0]
        i = 4

        flags = header >> 24
        tracked = flags & TRACKED_MASK
        protocol_type = flags & PROTOCOL_MASK

        if tracked:
            track_id = struct.unpack_from(">H", pkt, i)[0]
            i += 2
        else:
            track_id = 0

        if protocol_type == NAMED_PROTOCOL:
            # stupid pascal encoding is broken
            name_len = struct.unpack_from(">B", pkt, i)[0]
            i += 1
            protocol = pkt[i:i+name_len]
            i += name_len
        else:
            protocol = struct.unpack_from(">H", pkt, i)[0]
            i += 2
            
        return Packet(track_id, protocol, pkt[i:])


    @staticmethod
    def read_length(pkt):
        """
        Returns the length of the pkt.

        None is returned if not enough of the header is available.
        """
        if len(pkt) >= 4:
            (header,) = struct.unpack(">I", pkt[0:4])
            return header & 0xFFFFFF


    def encode(self):
        """
        Encode a packet for the wire -- from an existing object.
        """
        return Packet._encode(self.track_id, self.protocol, self.payload)

    @staticmethod
    def _encode(track_id, protocol, payload):
        """
        Encode a packet for the wire.

        Is protocol is a string, the packet is sent using a "named
        message", otherwise it's sent using a "resolved message".
        """
        flags = 0
        options = ""
    
        if track_id:
            # tracked
            options += struct.pack(">H", track_id)
            flags |= TRACKED_MASK

        if Packet.is_named(protocol):
            # named
            options += struct.pack(">B", len(protocol)) + protocol
            flags |= NAMED_PROTOCOL
        else:
            # mapped
            options += struct.pack(">H", protocol)

        size = 4 + len(options) + len(payload)
        header = struct.pack(">L", (flags << 24) | size)

        return header + options + payload
