#!/usr/bin/python

# system libs
import time,sys

sys.path.append("..")

TEST_PING = 1
TEST_CLEAR = 2
TEST_STOP = 3
TEST_START = 4

from threading import Condition
from tinyos.message import MoteIF, Message
from TestDriverMsg import TestDriverMsg

# make sure Ctrl-C works
import signal
signal.signal(signal.SIGINT, signal.SIG_DFL)

class Driver:
    def __init__(self):
        self.mif = MoteIF.MoteIF()
        self.source = self.mif.addSource()
        # Give source a chance to start running
        time.sleep(1)

        # Set up listeners
        self.addListener(self, TestDriverMsg)
        self.target = -1
        self.total_received = 0
        self.doneCV = Condition()

    def sendMsg(self, addr, msg, group=0x0, amtype=None):
        if (amtype == None): amtype = msg.get_amType()
        self.mif.sendMsg(self.source, addr, amtype, group, msg)

    def addListener(self, listener, msgClass):
        self.mif.addListener(listener, msgClass)

    def receive(self, source, msg):
        self.total_received += 1
        print "received:", self.total_received, "target:", self.target
        if self.target >= 0 and self.total_received == self.target:
            # calling finish from the same thread as the dispatch
            # seems to confuse things.  Thus, this.
            self.doneCV.acquire()
            self.doneCV.notify()
            self.doneCV.release()

    def finish(self):
        self.mif.removeListener(self)
        self.mif.finishAll()

    def setTarget(self, target):
        self.target = target

    def waitOnFinish(self):
        self.doneCV.acquire()
        self.doneCV.wait()
        self.finish()
    

    def start_pings(self, traffic_file):
        try:
            f = open(traffic_file, "r")
        except:
            print "Open %s failed" % traffic_file
            sys.exit(1)

        addr =  [0x20, 0x01, 0x04, 0x70, 0x1f, 0x04, 0x05, 0x6d, 
                 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00];

        lines = f.readlines()
        for l in lines:
            s = l.split()
            addr[15] = int(s[1])
        
            t = TestDriverMsg()
            t.set_cmd(TEST_PING)
            t.set_dt(int(s[2]))
            t.set_n(int(s[3]))
            t.set_addr(addr)
            print int(s[0]), t
            self.sendMsg(int(s[0]), t)
            time.sleep(1)

        self.setTarget(len(lines))

    def stop_node(self, n):
        t = TestDriverMsg()
        t.set_cmd(TEST_STOP)
        self.sendMsg(n, t)
        
if __name__ == "__main__":
    if len(sys.argv) < 3:
        print "Usage: %s [clear | ping] <traffic file>" % sys.argv[0]
        sys.exit(1)
    
    d = Driver()


    if sys.argv[1] == "ping":
        d.start_pings(sys.argv[2])

        if len(sys.argv) == 4 and sys.argv[3] == "dontwait":
            d.finish()
        else:
            d.waitOnFinish()

    elif sys.argv[1] == "clear":
        t = TestDriverMsg()
        t.set_cmd(TEST_CLEAR)
        for i in range(1,225):
            d.sendMsg(i, t)
        d.finish()

    elif sys.argv[1] == "stop":
        d.stop_node(int(sys.argv[2]))
        d.finish()

    elif sys.argv[1] == "start":
        t = TestDriverMsg()
        t.set_cmd(TEST_START)
        d.sendMsg(int(sys.argv[2]), t)
        d.finish()
    
    elif sys.argv[1] == "wait":
        d.setTarget(len(sys.argv[2]))
        d.waitOnFinish()
