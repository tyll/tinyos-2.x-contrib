import asyncore
from socket import error as SocketError
import struct
import warnings

# local
from mapper import ServerClientMap
from packet import Packet


class Connection(asyncore.dispatcher):

    def __init__(self, server=None, socket=None):
        asyncore.dispatcher.__init__(self, socket)
        self.server = server


    def handle_connect(self):
        pass


    def handle_close(self):
        self.close()
        self.server.connection_closed(self)


    def handle_error(self):
        #PST- this will prevent errors from taking down primary dispatch
        #self.handle_close()
        asyncore.dispatcher.handle_error(self)


    def writable(self):
        return False


    def write_packet(self, packet):
        raise RuntimeError("Error writing packet to invalid connection")


class Holding(Connection):
    """
    Pre-handshake adapter. This will alter the server connection to be
    of the correct handler once the pre-amble has determined the
    connection type.
    """

    def __init__(self, preamble="",
                 server=None, socket=None, trigger_magic=None):
        Connection.__init__(self, server=server, socket=socket)
        self.data = ""
        self.client_magic = "PROTOMAP"
        self.trigger_magic = trigger_magic
        self.remaining_preamble = preamble


    def writable(self):
        return self.remaining_preamble


    def handle_write(self):
        sent = self.send(self.remaining_preamble)
        self.remaining_preamble = self.remaining_preamble[sent:]

            
    def handle_read(self):
        self.data += self.recv(4096)

        def begins_with(s, needle):
            return s[:len(needle)] == needle

        def alter_conn(new_conn):
            self.server.alter_connection(self, new_conn)

        if begins_with(self.data, self.trigger_magic):
            alter_conn(Trigger(self.server, self.socket))
        elif begins_with(self.data, self.client_magic):
            carry_over = self.data[len(self.client_magic):]
            alter_conn(ProtoClient(self.server, carry_over, self.socket))
        elif len(self.data) >= max(len(self.trigger_magic),
                                   len(self.client_magic)):
            warnings.warn("connection failed handshake: `" + self.data + "`")
            alter_conn(None)

                
class Trigger(Connection):
    """
    Do-almost-nothing wrapper for a trigger.
    """

    def __init__(self, server=None, socket=None):
        Connection.__init__(self, server=server, socket=socket)


    def writable(self):
        return False


    def handle_read(self):
        """
        Discard inputs to triggers.
        """
        self.recv(4096)


class ProtoClient(Connection):
    
    def __init__(self, server=None, data="", socket=None):
        Connection.__init__(self, server=server, socket=socket)
        self.buffer_out = ""
        self.buffer_in = data
        self.packet_size = None
        # Maps names to ID.
        self.map = ServerClientMap()


    def write_packet(self, packet):
        self.buffer_out += packet.encode()


    def writable(self):
        """
        Wants to write?
        """
        return len(self.buffer_out) > 0


    def handle_write(self):
        """
        Perform write.
        """
        sent = self.send(self.buffer_out)
        self.buffer_out = self.buffer_out[sent:]

        
    def handle_read(self):
        """
        Perform read.
        """
        self.buffer_in += self.recv(4096)
        while self.process_buffer():
            pass


    def process_buffer(self):
        """
        Attempt to parse the packet from the buffer.

        If a complete packet exists in the buffer it is removed and
        the server packet_read callback is invoked.

        Returns True iff a packet was processed.
        """
        if not self.packet_size:
            self.packet_size = Packet.read_length(self.buffer_in)
            if self.packet_size:
                print "Reading packet with length %s" % self.packet_size

        if self.packet_size and len(self.buffer_in) >= self.packet_size:
            # remove from buffer
            raw_packet = self.buffer_in[0:self.packet_size]
            self.buffer_in = self.buffer_in[self.packet_size:]
            self.packet_size = None
            # callback
            self.server.packet_read(self, raw_packet)

            return True
