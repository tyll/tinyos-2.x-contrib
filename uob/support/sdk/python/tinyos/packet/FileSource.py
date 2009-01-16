import re
import socket
from struct import *

from tinyos.packet.PacketSource import *

class FileSource(PacketSource):
    def __init__(self, dispatcher, args):
        PacketSource.__init__(self, dispatcher)

        m = re.match(r'(.*)', args)
        if m == None:
            raise PacketSourceException("bad arguments")

        (file) = m.groups()
        self.sourcefile = open(args)

    def cancel(self):
        self.done = True

    def open(self):
        PacketSource.open(self)

    def close(self):
        self.sourcefile.close()

    def readPacket(self):
        #print "read"
        packet = self.sourcefile.readline()
        packet = packet.strip(" \r\n")
        #print ":",packet,":"
        if packet == "":
            print "EOF"
            self.close()
            
        tok_packet = packet.split(' ')
        #print tok_packet

        tok_packet_int = []
        for ch in tok_packet:
            tok_packet_int.append(int(ch, 16))

        #print tok_packet_int
        #print "Length:", len(tok_packet_int)

        tok_packet_int_H = []
        for i in range(0, len(tok_packet_int), 2):
            #print i
            if i+1 < len(tok_packet_int):
                tok_packet_int_H.append(tok_packet_int[i]*256+ tok_packet_int[i+1])
            else:
                tok_packet_int_H.append(tok_packet_int[i])


        #print tok_packet_int_H

        buf = pack('!'+len(tok_packet_int_H)*'H', *tok_packet_int_H)

        #print repr(buf)
            
        #print "~read"
        return buf

    def writePacket(self, packet):
        #print "write"
        self.prot.writePacket(packet)
