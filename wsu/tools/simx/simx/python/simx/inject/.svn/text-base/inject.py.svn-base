"""
Bridge a serial forwarder and provide injection capabilities.  This is
designed to be used to allow a TOSSIM simulation environment to send
extra data up to the processing application, if any. The bridge only
allows injection on the Simulation<->Application side. TOSSIM already
provides a mechanism to directly inject packets into the simulator.

This implementation uses asynchronous IO that runs in a separate
thread. The Queue data-structure is used to provide thread-safe
access. Because a separate thread is used, C code must correctly
release the GIL to prevent starvation.

This is designed to bridge the sim-sf TOSSIM enchancement by Chad
Metcalf but it should be able to forward from any serial-forward
compliant server.

Inject may also be used as a stand-alone without sim-sf. In this
case packets will not be bridged. It should also be possible run
multiple SFInject instances at the same time (provided they don't try
to bind to the same ports).

Author: Paul Stickney @ WSU-V, May 2008
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

from tinyos.message.SerialPacket import SerialPacket

# local packages
from wiretap import InjectUpstream, InjectDownstream, InjectTrigger
from util import sync_read, is_trigger, is_sfclient, \
    TRIGGER_MAGIC, SFCLIENT_MAGIC
from queue import FifoQueue


DEFAULT_IN_SIZE = 1500
DEFAULT_OUT_SIZE = 1500

SELECT_IDLE_SECONDS = 10
CONNECTION_QUEUE_SIZE = 2


class InvalidVersionWarning(RuntimeWarning):
    """
    Warning generated when an invalid version is detected.
    """
    def __init__(self, msg="invalid serial-forward version"):
        RuntimeWarning.__init__(self, msg)


class Inject(asyncore.dispatcher):
    """
    Select-dispatch to move packets across sf-compatible streams.
    """

    log = logging.getLogger(__name__)

    def __init__(self, port, bridge_port=None,
                 queue_in_size=DEFAULT_IN_SIZE,
                 queue_out_size=DEFAULT_OUT_SIZE):
        """
        Initialize.

        port specifies the IP port to listen on. bridge_port is used
        for briding to an existing serial-forward (such as that
        provided by sim-sf).

        queue_in_size and queue_out_size limit the maximum number of
        queued elements. A size of zero specified that there is no
        limit. When the queues fill up a warning is generated and the
        oldest element is dropped.
        """
        asyncore.dispatcher.__init__(self)

        # maintained with callbacks from InjectSock, etc.
        self.map = {}
        self.upstream = []
        self.bridge_source = None

        # of (client, packet)
        # where client is the source, or None if from the proxy source
        self.q_in = FifoQueue(queue_in_size)
        # of (target, packet)
        # where target is a client to send to, or None to send to all
        self.q_out = FifoQueue(queue_out_size)

        self._init_server(("", port))
        self._init_trigger(("127.0.0.1", port))
#        if bridge_port is not None:
#            self._init_bridge(("127.0.0.1", bridge_port))

        self.thread = None


    def _init_server(self, server_addr):
        """
        Setup server socket.
        """
        self.create_socket(socket.AF_INET, socket.SOCK_STREAM)
        self.setsockopt(socket.SOL_SOCKET, socket.SO_REUSEADDR, 1)
        self.bind(server_addr)
        self.listen(CONNECTION_QUEUE_SIZE)
        self.map[self] = self


    def _init_bridge(self, bridge_addr):
        """
        Setup bridge socket.
        """
        source = InjectDownstream(sf_inject=self)
        source.create_socket(socket.AF_INET, socket.SOCK_STREAM)
        source.connect(bridge_addr)
        # sim-sf will block until it receives the serial-forward
        # version and, since it (sf.process()) does not perform a GIL
        # release, this thread will never resume. This will ensure
        # that the sim-sf serial forwarder doesn't hang (here) by
        # forcing data onto the wire.
        source.send(SFCLIENT_MAGIC)
        self.bridge_source = source


    def _init_trigger(self, server_addr):
        """
        Setup trigger socket.

        The trigger is used to interrupt the asyncore loop and force
        examination of the message queue.
        """
        trigger = socket.socket(socket.AF_INET, socket.SOCK_STREAM)
        trigger.connect(server_addr)
        trigger.shutdown(socket.SHUT_RD)
        # How the handle_accept identifies this as a trigger. Very
        # important to prevent blocking with handle_accept+sync_read.
        trigger.send(TRIGGER_MAGIC)
        self.trigger = trigger


    def packet_read(self, conn, packet):
        """
        Read in a packet and dispatch -- asyncore callback.
        """
        if conn == self.bridge_source:
            # TODO: fix (huh?)
            self.send_packet_upstream(packet)
        else:
            self.q_in.fifo_put((conn, packet))
            # foward to motes (should be filtered)
            if self.bridge_source:
                self.bridge_source.write_packet(packet)

            
    def handle_accept(self):
        """
        Process new connections (sf-client or trigger) -- asyncore
        callback.
        """
        client, addr = self.accept()
        # Determine who connected and if they look valid. This is done
        # first to siphon off the 'trigger' handler. It also blocks.
        magic = sync_read(client, 2)

        if is_trigger(magic):
            InjectTrigger(sf_inject=self, socket=client)

        elif is_sfclient(magic):
            InjectUpstream(sf_inject=self, socket=client)
            client.send(SFCLIENT_MAGIC)

        else:
            warn(InvalidVersionWarning())
            client.close()


    def attach_conn(self, conn):
        """
        Attach a connections.
        """
        if not conn in self.map:
            if isinstance(conn, InjectUpstream):
                self.upstream.append(conn)
            self.map[conn] = conn


    def detach_conn(self, conn):
        """
        Remove a connection.
        """
        if conn in self.upstream:
            self.upstream.remove(conn)
        del(self.map[conn])

    #
    # Internal
    #

    def _message_to_packet(self, msg, dest=0xFFFF, group=0xAA):
        """
        Wraps a message in an AM (Serial) packet.
        """
        payload = msg.dataGet()
        am_type = msg.amType()
        pkt = SerialPacket(None)
        pkt.set_header_dest(dest)
        pkt.set_header_group(group)
        pkt.set_header_type(int(am_type))
        pkt.set_header_length(len(payload))
        # first byte, always 0, identifies as AM packet
        return chr(0) + pkt.dataGet()[0:pkt.offset_data(0)] + payload


    def _send_queued_packets(self):
        """
        Flush all queued out packets onto the wire.
        """
        while not self.q_out.empty():
            (client, message) = self.q_out.get()
            serial_packet = self._message_to_packet(message)
            if client is not None:
                # send to specific connection
                client.write_packet(serial_packet)
            else:
                # send to all upstream connections
                for conn in self.upstream:
                    conn.write_packet(serial_packet)


    def _thread_pump(self):
        """
        Pump that runs inside the dispatch thread. This never normally
        terminates.
        """
        self.log.debug("Pump started")
        while True:
            asyncore.loop(SELECT_IDLE_SECONDS, False, self.map, 1)
            self._send_queued_packets()


    #
    # Public
    #

    def read_packets(self):
        """
        Returns a list of (client, packet) for all incoming packets.

        The packets are removed from the incoming queue and have the
        AM (Serial) header stripped.
        """
        read = []
        while not self.q_in.empty():
            (client, data) = self.q_in.get()
            read.append((client, data[8:]))
        return read


    def inject(self, message, target=None):
        """
        Inject a message.

        The message is sent to target. If target is None the message
        is sent to everyone. This is safe to call outside the event
        thread.
        """
        self.q_out.fifo_put((target, message))
        self.trigger.send("t")


    def start(self):
        """
        Spawn a thread and start running the injection bridge.

        Returns self.
        """
        def launcher():
            "Terminate on pump exception"
            try:
                self._thread_pump()
            except:
                traceback.print_exc()
                print >>sys.stderr, "!!! INJECTOR TERMINATED !!!"
                os._exit(1)

        self.thread = thread.start_new_thread(launcher, ())
        return self
