import asyncore
from socket import error as SocketError

# local package
from util import sync_read, is_sfclient


class InjectSock(asyncore.dispatcher):

    def __init__(self, sf_inject=None, socket=None):
        if sf_inject is None:
            raise ValueError, "sf_inject required"
        asyncore.dispatcher.__init__(self, socket)
        self.sf_inject = sf_inject
        self.sf_inject.attach_conn(self)

    def handle_close(self):
        self.close()
        self.sf_inject.detach_conn(self)

    def handle_connect(self):
        pass


class InjectTrigger(InjectSock):
    """
    Do-almost-nothing wrapper for trigger.
    """
    def __init__(self, sf_inject=None, socket=None):
        InjectSock.__init__(self, sf_inject=sf_inject, socket=socket)

    def handle_connect(self):
        pass

    def handle_read(self):
        self.recv(50)

    def handle_write(self):
        pass

    def writable(self):
        return False

    def write_packet(self, packet):
        pass


class InjectPacketSock(InjectSock):
    """
    Socket connection from SFInject to connected clients.

    Acts as server.
    """
    
    def __init__(self, sf_inject=None, socket=None):
        InjectSock.__init__(self, sf_inject=sf_inject, socket=socket)
        self.buffer_out = ""
        self.buffer_in = ""
        self.packet_left = 0

    def write_packet(self, packet):
        self.buffer_out = self.buffer_out + chr(len(packet)) + packet

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
        # No packet in progress, next byte is len. Even though this is
        # handle_read, because handle_connect might have read
        # connection issue, the next read may fail. Hence the pretty
        # exceptions.
        if self.packet_left == 0:
            try:
                ch = self.recv(1)
            except SocketError: # try later
                pass
            else:
                if len(ch) < 1: # EOF
                    return
                packet_size = ord(ch)
                self.packet_left = packet_size
        # data in, try to read packet
        try:
            read = self.recv(self.packet_left)
        except SocketError: # try later
            pass
        else:
            if len(read) < 1: #EOF
                return
            # maybe have a packet
            self.buffer_in += read
            self.packet_left = self.packet_left - len(read)
            if self.packet_left == 0:
                self.sf_inject.packet_read(self, self.buffer_in)
                self.buffer_in = ""


class InjectUpstream(InjectPacketSock):

    def __init__(self, sf_inject=None, socket=None):
        InjectPacketSock.__init__(self, sf_inject=sf_inject, socket=socket)


class InjectDownstream(InjectPacketSock):

    def __init__(self, sf_inject=None, socket=None):
        InjectPacketSock.__init__(self, sf_inject=sf_inject, socket=socket)

    def handle_connect(self):
        ver = sync_read(self.socket, 2)
        if not is_sfclient(ver):
            raise ValueError, "bridged SF has invalid version"
