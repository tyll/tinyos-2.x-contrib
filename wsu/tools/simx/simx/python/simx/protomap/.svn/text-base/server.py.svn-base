"""
Protomap Server

This implementation uses asynchronous IO that runs in a separate
thread. The Queue data-structure is used to provide thread-safe
access. Because a separate thread is used, C code must correctly
release the GIL to prevent starvation.

Author: Paul Stickney @ WSU-V, Feb 2009
"""

import asyncore
import socket
import thread
from warnings import warn
import logging
import os
import traceback
import sys
import time
import random

from proto.python.CoreMessages_pb2 import MessageRejected, MappedName
# import MappedName
from mapper import ServerMap, ServerClientMap
from packet import Packet
from connection import Trigger, ProtoClient, Holding
from queue import FifoQueue
from message import Message

PROTOMAP_VERSION = 1
PROTOMAP_MAGIC = "PROTOMAP" + chr(ord("a") + PROTOMAP_VERSION - 1)

DEFAULT_IN_SIZE = -1
DEFAULT_OUT_SIZE = -1

SELECT_IDLE_SECONDS = 10
CONNECTION_QUEUE_SIZE = 2


class ProtoServer(asyncore.dispatcher):
    """
    Server for ProtoMap.
    """

    log = logging.getLogger(__name__)

    def __init__(self, port=None,
                 queue_in_size=DEFAULT_IN_SIZE,
                 queue_out_size=DEFAULT_OUT_SIZE):
        """
        Initialize.

        port specifies the IP port to listen on.

        queue_in_size and queue_out_size limit the maximum number of
        queued elements. A size of zero specifies that there is no
        limit. When the queues fill up a warning is generated and the
        oldest element is dropped.
        """
        asyncore.dispatcher.__init__(self)

        self.connection_map = {} # connection => connection
        self.clients = []        # connections that want messages
        self.server_map = ServerMap()

        self.trigger = None
        self.trigger_magic = None # must be matched to accept trigger

        # of (client, message, handler)
        self.q_in = FifoQueue(queue_in_size)
        # of (target, packet)
        # where target is a client to send to, or None to send to all
        self.q_out = FifoQueue(queue_out_size)

        # PST: could possibly use UNIX sockets when not windows
        self._init_server(("", port))
        self._init_trigger(("127.0.0.1", port))
        self.thread = None

        # setup basic handlers
        def message_rejected(client, message):
            print "MessageRejected(Dummy Handler) {%s}" % message

        def mapped_name(client, message):
            print "MappedName: %s -> %d" % (message.name, message.id)
            client.map.add_resolution(message.name, message.id)

        self.server_map.set_handler(MessageRejected, message_rejected)
        self.server_map.set_handler(MappedName, mapped_name)


    def _init_server(self, server_addr):
        """
        Setup server socket.
        """
        self.create_socket(socket.AF_INET, socket.SOCK_STREAM)
        self.setsockopt(socket.SOL_SOCKET, socket.SO_REUSEADDR, 1)
        self.bind(server_addr)
        self.listen(CONNECTION_QUEUE_SIZE)
        self.connection_map[self] = self


    def _init_trigger(self, server_addr):
        """
        Setup trigger socket.

        The trigger is used to interrupt the asyncore loop and force
        examination of the outbound message queue. (This is because
        ``threading'' in Python 2.6 and before is absolutely soupy.)
        """
        assert not self.trigger

        trigger = socket.socket(socket.AF_INET, socket.SOCK_STREAM)
        trigger.connect(server_addr)
        trigger.shutdown(socket.SHUT_RD)
        # to identify as trigger
        self.trigger_magic = "TRIGGER:%08x" % random.randint(0, 0xffffffff)
        trigger.send(self.trigger_magic)
        self.trigger = trigger


    def packet_read(self, conn, raw_packet):
        """
        Read in a packet and dispatch -- asyncore callback.
        """
        packet = Packet.decode(raw_packet)
        print "packet in with protocol"

        if Packet.is_named(packet.protocol):
            # protocol is named, resolve id first
            name = packet.protocol
            id = self.server_map.resolve_id(name)

            if id:
                named = MappedName()
                named.name = name
                named.id = id
                msg = Message(0, named)
                self.q_out.fifo_put((conn, msg))
            else:
                print "unmapped name: " + str(name)
                rejected = MessageRejected()
                rejected.id = 0
                rejected.reason = rejected.UNMAPPED_NAME
                rejected.message = "Unmapped name: '%s'" % name
                msg = Message(0, rejected)
                self.q_out.fifo_put((conn, msg))
                # stop processing
                return

        else:
            # just take id
            id = packet.protocol

        # this seems slightly silly in the case where the message was
        # a named message (it shouldn't hurt though)
        name = self.server_map.resolve_name(id)

        if not name:
            # if the reverse name lookup fails
            print "unmapped id: " + str(id)
            rejected = MessageRejected()
            rejected.id = 0
            rejected.reason = rejected.UNMAPPED_ID
            rejected.message = "Unmapped ID: %d" % id
            msg = Message(0, rejected)
            self.q_out.fifo_put((conn, msg))
            # stop processing
            return

        protobuf_class = self.server_map.resolve_protobuffer(name)
        assert protobuf_class

        protobuf = protobuf_class()
        protobuf.ParseFromString(packet.payload)
        message = Message(packet.track_id, protobuf, name=name)
        print "have protobuf: {" + str(protobuf) + "}"

        self.q_in.fifo_put((conn, message))

            
    def handle_accept(self):
        """
        Process new connections (asyncore callback).
        """
        client, addr = self.accept()
        holding = Holding(PROTOMAP_MAGIC, self, client, self.trigger_magic)
        self.attach_connection(holding)


    def attach_connection(self, new_conn):
        """
        Attach a new connection.
        """
        self.alter_connection(None, new_conn)


    def alter_connection(self, old_conn, new_conn):
        """
        Alter an existing connection handler; if new_conn is None the
        connection is closed. The old_conn, if any, is removed.
        """
        if old_conn and new_conn:
            # prevent socket-swapping
            assert old_conn.socket is new_conn.socket

        # remove existing (if any)
        if old_conn in self.connection_map:
            del self.connection_map[old_conn]
            if old_conn in self.clients:
                self.clients.remove(old_conn)

        # attach new (if any)
        if new_conn:
            self.connection_map[new_conn] = new_conn
            if isinstance(new_conn, ProtoClient):
                self.clients.append(new_conn)
        elif old_conn:
            # no new_conn, but old_conn -- close connection
            old_conn.close()


    def connection_closed(self, conn):
        """
        Remove a connection.
        """
        self.log.debug("Connection closed")
        if conn in self.clients:
            self.clients.remove(conn)

        del self.connection_map[conn]

    #
    # Internal
    #

    # PST- can avoid this and keep asyncore loop tighter?
    # PST- could possibly send packet to closed connection
    def _send_queued_packets(self):
        """
        Flush all queued out packets onto the wire.
        """
        def send(client, message):
            protocol = client.map.resolve_id(message.name) or message.name
            packet = message.encode(protocol)
            print "writing packet " + str(protocol)
            client.write_packet(packet)

        while not self.q_out.empty():
            client, message = self.q_out.get()
            if client:
                send(client, message)
            else:
                for client in self.clients:
                    send(client, message)


    def _thread_pump(self):
        """
        Pump that runs inside the dispatch thread. This never normally
        terminates.
        """
        self.log.debug("Pump started")
        while True:
            asyncore.loop(SELECT_IDLE_SECONDS, False, self.connection_map, 1)
            self._send_queued_packets()

    #
    # Public
    #

    def process_messages(self):
        """
        Invoke handlers for messages in the incoming queue.

        This method should be invoked in the thread where the handlers
        are to be executed.
        """
        while not self.q_in.empty():
            client, message = self.q_in.get()
            handler = self.server_map.resolve_handler(message.name)
            handler(client, message)


    def write(self, message, target=None):
        """
        Write a message.

        The message is sent to target. If target is None the message
        is sent to all connected clients. This method is safe to call
        outside the event thread.
        """
        self.q_out.fifo_put((target, message))
        self.trigger.send('t')


    def start(self):
        """
        Spawn a thread and start running the server.

        Returns self.
        """
        def launcher():
            "Terminate on pump exception"
            try:
                self._thread_pump()
            except:
                traceback.print_exc()
                print >> sys.stderr, "!!! ProtoServer Terminated !!!"
                os._exit(1)

        self.thread = thread.start_new_thread(launcher, ())
        return self
