#!/usr/bin/env python

#
# Run TOSSDR. TinyOS on GNUradio with UCLA IEEE 802.15.4
#
# Author: Markus Becker
#

import math, struct, time, sys
import threading
import traceback
from datetime import datetime

from TOSSDR import *
from tinyos.tossim.TossimApp import *

from sdr_handling import *

class TOSSDRThread(threading.Thread):
    def __init__(self, t, v, s2t, rcvEvent):
        threading.Thread.__init__(self)
        self.t = t
        self.v = v
        self.s2t = s2t
        self.noRcvEvent = noRcvEvent

    def run(self):
        ts = TossimSync()
        start = time.time()

        while True:
            #if noRcvEvent.wait():
            #print "event at", self.t.timeStr(), "/", datetime.now()
            #print "!!!!!!!!",self.v.getData()

            # unfortunately I haven't found a way around setting the
            # callback method again and again. it kept being resetted
            # to 0 -> SEGFAULT
            self.t.set_data2sdr_callback(self.s2t.data2sdr_callback)
            self.t.set_send_callback(self.s2t.send_callback)

            ts.runNextEventInTime()
            #self.t.runNextEvent()

        print "TOSSDRThreads.run() is over."

noRcvEvent = threading.Event()

class DummyTosSdrInterface():
    def data2SdrDone(self):
        print "DummyTosSdrInterface data2SdrDone()"

    def receive(self, payload, len):
        print "DummyTosSdrInterface receive()", payload, len

class sdr2tos:
    def __init__(self, tosi):
        self.tosi = tosi
        self.current_payload = None

    def set_sdr(self, sdr_rx, sdr_tx):
        self.sdr_rx = sdr_rx
        self.sdr_tx = sdr_tx

    # TinyOS MAC -> SDR PHY
    def data2sdr_callback(self, payload):
        print "#######################"
        print "### data2sdr_callback"
        print "### payload = '%s'" % \
            str(map(hex, map(ord, payload)))
        #print "### payload = '%s'" % \
        #    payload
        #print "len", len(payload)
        print "#######################"

        self.current_payload = payload

        self.tosi.data2SdrDone()

        # test rx:
        #self.rx_callback(True, payload)

        print "data2sdr_callback successfully finished"

    def send_callback(self, cca):
        print "############################"
        print "### send_callback"
        #print "--- payload = '%s'" % \
        #    self.current_payload
        print "len", len(self.current_payload)

        if self.current_payload != None:
            print "### payload = '%s'" % \
                str(map(hex, map(ord, self.current_payload)))
            print "### cca", cca

            #if cca == True:
            if False:
                print "### Carrier sensing"
                retval = self.sdr_rx.carrier_sensed()
            else:
                print "### No carrier sensing"
                retval = False
            print "### retval:", retval

            if retval != True:
                print "### Giving packet to SDR"
                #self.sdr_tx.send_tinyos_pkt(struct.pack('13B', \
                #                                            0x41, 0x88, 0xcf, \
                #                                            0x22, 0x0, 0xff, \
                #                                            0xff, 0x1, 0x0, \
                #                                            0x3f, 0xf0, 0x66, \
                #                                            0x8c))

                #FIXME: send the real payload again:
                self.sdr_tx.send_tinyos_pkt(self.current_payload, False)
                print "### Packet given to SDR"
            else:
                print "### Carrier busy"
        else:
            print "### No packet available"
            retval = True # actually this is an error
        print "########################"

        print "send_callback successfully finished", retval
        #return value: congestion
        return retval

    # TODO: implement the other callbacks as well:
    # EnergyIndicator.isReceiving()
    # ByteIndicator.isReceiving()

    # SDR PHY -> TinyOS MAC
    def rx_callback(self, ok, payload):
        print "------------------------"
        print "--- rx_callback"
        #print "--- payload = '%s'" % \
        #    str(map(hex, map(ord, payload)))
        #print "--- payload = '%s'" % \
        #    str(map(hex, map(ord, payload[:-2])))

        head = struct.pack("b", 0xD)
        repaired = ''.join((head, payload[:-2]))

        print "--- payload = '%s'" % \
            str(map(hex, map(ord, repaired)))

        #print "--- payload = '%s'" % \
        #    payload
        #print "len", len(payload)
        #print "len", len(payload[:-2])
        print "--- len", len(repaired)
        print "------------------------"

        #self.tosi.receive(payload, len(payload))
        self.tosi.receive(repaired, len(repaired))
        print "rx_callback successfully finished"

def main ():

    testsdr = False # for debugging the SDR, without TinyOS
    testtos = False # for debugging without SDR board

    # Setup TinyOS
    print "Setting up TinyOS..."
    if testsdr == True:
        tosi = DummyTosSdrInterface()
    else:
        n = NescApp()
        tos = Tossdr(n.variables.variables())
        tosi = TosSdrInterface()

    # Create the object that bridges between TinyOS and SDR
    print "Setting up the SDR/TOS bridge..."
    s2t = sdr2tos(tosi)

    # Setup the SDR
    print "Setting up the SDR..."
    if testtos == True:
        sdr_rx = dummy_rx_block(s2t.rx_callback)
    else:
        sdr_rx = rx_block(s2t.rx_callback)
    sdr_rx.start()

    if testtos == True:
        sdr_tx = dummy_tx_block()
    else:
        sdr_tx = tx_block()
    sdr_tx.start()

    print "Registering the SDR with the SDR/TOS bridge..."
    s2t.set_sdr(sdr_rx, sdr_tx)

    if testsdr == False:
        # Setup node 0
        m = tos.getNode(0)
        v = m.getVariable("SdrTransmitP__data2sdr_callback")
        m.bootAtTime(0)

        print "Setting debugging channels..."
        # Set debugging channels
        #tos.addChannel("SimMainP", sys.stdout)
        #tos.addChannel("SimMoteP", sys.stdout)
        #tos.addChannel("Packet", sys.stdout)
        #tos.addChannel("Tossdr", sys.stdout)
        tos.addChannel("AM", sys.stdout)
        #tos.addChannel("Test", sys.stdout)
        #tos.addChannel("Boot", sys.stdout)
        #tos.addChannel("BaseStation", sys.stdout)
        #tos.addChannel("Scheduler", sys.stdout)
        #tos.addChannel("Queue", sys.stdout)
        tos.addChannel("Leds", sys.stdout)

    # FIXME? needed?
    # Inter-Thread Communication
    #noRcvEvent.set()

    # Start running TOS scheduler
        print "Start running TOS scheduler..."
        tossdr_thread = TOSSDRThread(tos, v, s2t, noRcvEvent)
        tossdr_thread.start()

    if testsdr == True:
        payload = "something" # FIXME
        s2t.data2sdr_callback(payload)
        s2t.send_callback(False)
        #s2t.send_callback(True)

    # Wait until we are finished
    sdr_rx.wait()
    sdr_tx.wait()
    print "SDR finished"

    if testsdr == False:
        tossdr_thread.join()

    print "TinyOS finished"

if __name__ == '__main__':
    main ()
