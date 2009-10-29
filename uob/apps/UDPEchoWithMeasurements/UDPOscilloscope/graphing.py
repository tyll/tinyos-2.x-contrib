#!/usr/bin/python
# -*-  indent-tabs-mode:nil; python-indent:4  -*-

"""Graphical Display of UDP Oscilloscope messages.
Author	: Markus Becker
Date	: 13.10.2009

Usage:
  python graphing.py -p 7000
"""

import sys, os, getopt, datetime

from PyQt4.QtCore import *
from mainwindow import *

import SocketServer, socket
from threading import Thread

from tinyos.message import Message

from util.UdpMeasurement import *

class UDPv6Server(SocketServer.UDPServer):
    address_family = socket.AF_INET6

class UDPOscilloscope(SocketServer.BaseRequestHandler):

    def handle(self):
        print "handle(self)"
        time = datetime.datetime.now()
        print "Time:", time

        data = self.request[0].strip()
        socket = self.request[1]
        print "%s wrote:" % self.client_address[0]

        ServerThread.theserver.window.packetIndicator.setChecked(ServerThread.theserver.window.packetIndicator.isChecked() == False)

        ServerThread.theserver.window.oscm.update_msg(UdpMeasurement(data), time)

        sys.stdout.flush()

class ServerThread(Thread):
    def __init__(self, port, window):
        Thread.__init__(self)

        self.window = window

        self.server = UDPv6Server(("::", port), UDPOscilloscope)

        self.__class__.theserver = self
        self.start()

    def run(self):
        self.server.serve_forever()


def main():
    try:
        opts, args = getopt.getopt(sys.argv[1:], \
                                   "hp:", \
                                   ["help", "port="])
    except getopt.error, msg:
        print msg
        print "for help use --help"
        sys.exit(2)

    port = "7000"

    #print opts, args
    for o, a in opts:
        if o in ("-h", "--help"):
            print __doc__
            sys.exit(0)

        if o in ("-p", "--port"):
            port = a

    app = QApplication(sys.argv)

    print "Using port", port

    window = MainWindow()
    window.show()

    server = ServerThread(int(port), window)

    sys.exit(app.exec_())

if __name__ == "__main__":
    main()
